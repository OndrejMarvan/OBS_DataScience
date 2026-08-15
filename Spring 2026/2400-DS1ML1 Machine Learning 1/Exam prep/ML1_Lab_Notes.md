---
title: ML1 - Lab Notes (Beyond the Slides)
course: 2400-DS1ML1
midterm_date: 2026-05-15
retake: true
tags: [machine-learning, labs, retake, midterm]
related: ["[[ML1_Midterm_Study_Notes]]", "[[ML1_Code_CheatSheet]]", "[[ML1_Past_Exam_Practice]]"]
---

# ML1 — Lab Notes: Beyond the Slides

> **Why this note exists:** After cross-checking the labs against the May 15 exam, I found that ~30% of the questions test concepts that appear in the lab notebooks but only briefly (or not at all) in the lecture slides. This file plugs those gaps. If you failed the first attempt, this is the most important file to read carefully.

## Contents

- [[#1 Missing Data Types (MCAR / MAR / NMAR)]]
- [[#2 Missing Indicator Column]]
- [[#3 Target Encoder (with Cross-Fitting)]]
- [[#4 ColumnTransformer]]
- [[#5 Time Series Imputation]]
- [[#6 Variance Threshold]]
- [[#7 Univariate Feature Selection Tests]]
- [[#8 RFE vs RFECV vs SequentialFeatureSelector vs SelectFromModel]]
- [[#9 Class Weight Balanced — the Exact Formula]]
- [[#10 imblearn Pipeline vs sklearn Pipeline]]
- [[#11 Cluster Centroids Undersampling]]
- [[#12 Calibration — Sigmoid vs Isotonic]]
- [[#13 Brier Score (Definition & Decomposition)]]
- [[#14 Data Drift vs Concept Drift vs Covariate Drift]]
- [[#15 Wasserstein Distance for Drift]]
- [[#16 TimeSeriesSplit — Expanding vs Rolling Window]]
- [[#17 Nested CV Structure (Code Pattern)]]
- [[#18 BayesSearchCV — the Surrogate Model]]
- [[#19 Successive Halving]]
- [[#20 statsmodels vs sklearn — When to Use Which]]
- [[#21 Gini Coefficient (Credit Scoring)]]
- [[#22 Lift Curve]]
- [[#23 Log-Loss as a Proper Scoring Rule]]
- [[#24 validation_curve vs learning_curve]]
- [[#25 Multi-collinearity — Effect on OLS Coefficients]]
- [[#26 SVM — Primal vs Dual (When to Use Which)]]
- [[#27 Hinge Loss (What Logistic Reg Doesn't Use)]]
- [[#28 Ridge Has a Closed Form; Lasso Doesn't]]
- [[#29 Solver Choice for Logistic Regression]]
- [[#30 Hard Voting vs Soft Voting]]

---

## 1. Missing Data Types (MCAR / MAR / NMAR)

> Very likely on retake. Missed on original exam because slides only glossed this.

| Type | Full name | Meaning |
|---|---|---|
| **MCAR** | Missing Completely At Random | Missingness is unrelated to any variable (observed or not). Example: sensor failed at random. |
| **MAR** | Missing At Random | Missingness depends on observed variables, but not the missing value itself. Example: older customers less likely to disclose income (missingness of income depends on age, which is observed). |
| **NMAR** | Not Missing At Random | Missingness depends on the unobserved value itself. Example: high earners refuse to disclose income (missingness depends on income itself). Hardest case — cannot be fixed by imputation alone. |

**Why it matters:**
- **MCAR** → simple imputation (mean/median) is unbiased.
- **MAR** → conditional imputation (KNN, MICE) can be unbiased.
- **NMAR** → imputation introduces bias no matter what — need domain-specific handling.

---

## 2. Missing Indicator Column

> ⚠️ Group D Q17 tested this exact concept — many people picked wrong.

When you impute a missing value, you're throwing away information about *the fact that it was missing*. Sometimes missingness itself carries predictive signal.

**Solution:** add a binary column `feature_missing` (1 if the original value was missing, 0 otherwise) alongside the imputed feature.

**When it helps:**
- Missingness is informative (NMAR or a specific MAR pattern).
- Example: in credit scoring, a missing "years-of-employment" field often correlates with unemployment.

**Sklearn:** `MissingIndicator` transformer, or `SimpleImputer(add_indicator=True)`.

```python
from sklearn.impute import SimpleImputer
imp = SimpleImputer(strategy='median', add_indicator=True)
X_imputed = imp.fit_transform(X)   # returns original columns + one indicator per feature with missings
```

---

## 3. Target Encoder (with Cross-Fitting)

Encodes each category by the **mean of the target for that category** (or another stat like median).

**Why not just replace each category with its target mean?** Because that's **leakage** — a row's own target influences its own encoded feature. To prevent this, sklearn's `TargetEncoder` uses **internal cross-fitting**: it splits data, computes the encoding on one split, and applies it to the other.

**When to use:**
- High-cardinality categoricals (e.g. 500 zip codes)
- Especially with tree models

**Sklearn API:**
```python
from sklearn.preprocessing import TargetEncoder
enc = TargetEncoder(smooth='auto', target_type='binary')
X_encoded = enc.fit_transform(X_cat, y)
```

**Key parameter:** `smooth` blends the category mean with the global mean — smoother = more shrinkage toward the global mean (prevents overfitting on rare categories).

---

## 4. ColumnTransformer

Applies different transformations to different subsets of columns in one step.

```python
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder

ct = ColumnTransformer([
    ('num', StandardScaler(), ['age', 'income']),
    ('cat', OneHotEncoder(handle_unknown='ignore'), ['country', 'gender']),
], remainder='drop')

X_transformed = ct.fit_transform(X)
```

**Why it's crucial:**
- Only way to have numeric scaling + categorical encoding in a single Pipeline object.
- Guarantees train/test transformations are identical.
- Prevents leakage in cross-validation (each fold refits from scratch).

**`remainder` options:** `'drop'` (default), `'passthrough'` (keep untouched), or a transformer.

---

## 5. Time Series Imputation

Not appropriate to use mean/median on time series — you'd destroy temporal patterns.

| Method | Description |
|---|---|
| **Forward fill (LOCF)** | Carry last observed value forward |
| **Backward fill** | Fill with the next observed value |
| **Linear interpolation** | Draw a line between the surrounding values |
| **Spline interpolation** | Fit a smooth spline through surrounding values |
| **Seasonal decomposition** | Decompose into trend + seasonality + residual, impute residual only |

**Pandas API:**
```python
df.fillna(method='ffill')          # forward fill
df.interpolate(method='linear')     # linear interpolation
df.interpolate(method='spline', order=3)   # cubic spline
```

---

## 6. Variance Threshold

> ⚠️ Group D Q13 tested this — the correct answer was "removes features whose sample variance falls below a chosen threshold". Many mistake it for correlation-based selection.

Removes features with variance below a chosen threshold. Useful for eliminating **near-constant** features (which give no info).

```python
from sklearn.feature_selection import VarianceThreshold
sel = VarianceThreshold(threshold=0.01)  # remove features with variance < 0.01
X_reduced = sel.fit_transform(X)
```

**Key point:** does **NOT** use the target — this is pre-modeling data cleaning, not feature selection tied to prediction. Also, requires features on a **comparable scale** (variance depends on units).

---

## 7. Univariate Feature Selection Tests

Sklearn ships several statistical tests to score each feature against the target:

| Test | Feature type | Target type | Use when |
|---|---|---|---|
| **`f_classif`** (ANOVA F-test) | Numeric | Categorical | Continuous features, classification target |
| **`chi2`** | Non-negative | Categorical | Non-negative features (counts, frequencies), classification |
| **`mutual_info_classif`** | Any | Categorical | Captures non-linear dependence |
| **`f_regression`** | Numeric | Numeric | Regression setting |
| **`mutual_info_regression`** | Any | Numeric | Regression, non-linear |

Wrap with `SelectKBest` (top K features) or `SelectPercentile` (top P%):
```python
from sklearn.feature_selection import SelectKBest, f_classif
sel = SelectKBest(f_classif, k=10)
X_reduced = sel.fit_transform(X, y)
```

**Key limitation:** these tests look at each feature *individually* — they miss features that only matter in combination. Follow with multivariate methods for the full picture.

---

## 8. RFE vs RFECV vs SequentialFeatureSelector vs SelectFromModel

All are wrapper / embedded methods but they work differently:

| Method | How it works |
|---|---|
| **RFE** (Recursive Feature Elimination) | Fit estimator → identify least important feature → remove it → refit → repeat until N features left |
| **RFECV** | Same as RFE but uses CV to pick the *optimal* number of features (no need to specify N) |
| **SequentialFeatureSelector** (forward) | Start empty → add the feature that most improves CV score → repeat |
| **SequentialFeatureSelector** (backward) | Start full → remove the feature whose removal least hurts CV score → repeat |
| **SelectFromModel** | Fit estimator → keep features whose importance ≥ threshold (typically used with `Lasso` or `RandomForest`) |

**Key distinction:**
- **RFE** removes one feature at a time based on estimator's importance/coefficients (fast).
- **SequentialFeatureSelector** adds/removes based on CV score (slow but respects interactions).
- **SelectFromModel** is a one-shot filter based on threshold (fastest).

**Exam relevance (Group B Q18):** RFE = "iteratively fits an estimator and removes the least important feature". Not one-shot correlation ranking, not random subsets.

---

## 9. Class Weight `balanced` — the Exact Formula

> ⚠️ Group D Q9 tested this. The answer is **B** — weights loss inversely to class frequencies.

When you pass `class_weight='balanced'`, sklearn computes:

$$w_c = \frac{n_{\text{samples}}}{n_{\text{classes}} \cdot n_c}$$

where $n_c$ is the count of class $c$. Result: minority class gets a larger weight in the loss, majority class a smaller weight — no data duplication, no sample deletion.

**What it does NOT do:**
- Does NOT duplicate minority samples (that's random oversampling).
- Does NOT remove majority samples (that's undersampling).
- Does NOT need SMOTE — it's a fully independent mechanism.

**Usage:**
```python
from sklearn.linear_model import LogisticRegression
model = LogisticRegression(class_weight='balanced')
# or manually:
model = LogisticRegression(class_weight={0: 1.0, 1: 3.5})
```

---

## 10. imblearn Pipeline vs sklearn Pipeline

> ⚠️ This is the practical answer to "resampling inside CV folds" (Group B Q16 = D).

Standard `sklearn.pipeline.Pipeline` does NOT support resampling steps (SMOTE, undersampling) — these steps change the number of samples, which breaks sklearn's contract.

**Solution:** use `imblearn.pipeline.Pipeline` (or `imblearn.pipeline.make_pipeline`).

```python
from imblearn.pipeline import Pipeline
from imblearn.over_sampling import SMOTE
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('smote', SMOTE(random_state=42)),   # only sklearn.pipeline can't handle this
    ('model', LogisticRegression()),
])

# Cross-validation now correctly:
# 1. splits into train/val
# 2. fits scaler on TRAIN, transforms TRAIN and VAL
# 3. runs SMOTE on TRAIN ONLY (never on val)
# 4. fits model on resampled train
# 5. evaluates on val
```

**The critical property:** in each fold, SMOTE fires *only on the training portion* — validation stays at the original class ratio. No leakage.

---

## 11. Cluster Centroids Undersampling

An undersampling method that **replaces** the majority class with K-means centroids of the majority-class points, keeping the same count as the minority class.

- Not just picking N random points (that's `RandomUnderSampler`).
- Not removing edge cases (that's Tomek links / ENN).
- Instead: computes representative "prototypes" via K-means → the majority class is compressed into a small, information-dense set.

```python
from imblearn.under_sampling import ClusterCentroids
cc = ClusterCentroids(random_state=42)
X_res, y_res = cc.fit_resample(X, y)
```

**Trade-off:** preserves information density but the "new majority points" are synthetic centroids, not real observations.

---

## 12. Calibration — Sigmoid vs Isotonic

Both are calibrators fit on top of a base classifier's scores → produce true probabilities.

| | Sigmoid (Platt scaling) | Isotonic |
|---|---|---|
| Type | Parametric (2 params: A, B) | Non-parametric, monotone |
| Formula | $p = 1/(1 + \exp(A \cdot f + B))$ | Piecewise constant monotone function |
| Data needed | Small (~50+) | Large (~1000+) |
| Overfitting risk | Very low | Moderate on small data |
| Best when | Miscalibration is S-shaped (SVM, Naive Bayes) | Miscalibration is irregular (Random Forest) |

**Sklearn API:**
```python
from sklearn.calibration import CalibratedClassifierCV
cal = CalibratedClassifierCV(base_estimator=SVC(), method='sigmoid', cv=5)
# or method='isotonic'
cal.fit(X, y)
cal.predict_proba(X_new)
```

**⚠️ Group B Q13** tested `method='isotonic'` → the answer is **"a non-parametric piecewise calibration map on classifier scores"**.

**⚠️ Group D Q20** tested Platt scaling → **"fits a logistic regression on classifier scores against true labels"**.

---

## 13. Brier Score (Definition & Decomposition)

> ⚠️ Group B Q20 tested this. Answer: **B** (mean squared error between predicted probabilities and outcomes).

$$BS = \frac{1}{N} \sum_{i=1}^{N} (p_i - y_i)^2$$

where $p_i \in [0, 1]$ is the predicted probability, $y_i \in \{0, 1\}$ is the true label.

**Key properties:**
- Lower is better; 0 = perfect.
- A "predict base rate always" model gets $BS = \bar{y}(1 - \bar{y})$ (0.25 on a balanced dataset).
- Decomposes into **calibration + refinement** components → calibration only fixes the calibration part.
- Not identical to log-loss (log-loss is unbounded above; Brier is bounded by 1).

**Why care beyond log-loss:** Brier is a proper scoring rule with a natural MSE interpretation — easier to communicate to non-technical stakeholders.

---

## 14. Data Drift vs Concept Drift vs Covariate Drift

> ⚠️ Group A Q20 tested this — the fundamental distinction.

| Type | What changes | Detectable without labels? |
|---|---|---|
| **Data drift / Covariate drift** | $P(X)$ — distribution of inputs | ✅ Yes — compare feature distributions |
| **Concept drift** | $P(Y \mid X)$ — the relationship between inputs and target | ❌ No — need labels |

**Examples:**
- Data drift: customer demographics change over time.
- Concept drift: fraud patterns evolve (same features, different meaning).
- Combined: pandemic changes both what customers buy AND how they respond to marketing.

**Practical implication:**
- Data drift is noticed **first** (cheap, label-free monitoring via KS test, Wasserstein).
- Concept drift is noticed **later** (delayed labels, business KPI dashboards).
- Both signal that retraining is needed.

---

## 15. Wasserstein Distance for Drift

> ⚠️ Group C Q19 tested this.

The Wasserstein (earth-mover's) distance measures how far one distribution needs to be "moved" to become another.

- Same units as the feature itself (interpretable).
- Alerting-friendly: "alert if `age` shifts by more than 2 years on average".
- Non-parametric — works for any distribution.

**Vs Kolmogorov-Smirnov (KS):**
- KS returns a p-value ("are these different — yes/no").
- Wasserstein returns a *magnitude* ("how different").
- On large N, KS detects trivial differences → always couple with an effect size (Wasserstein).

**Scipy API:**
```python
from scipy.stats import wasserstein_distance
d = wasserstein_distance(train_feature, prod_feature)
```

---

## 16. TimeSeriesSplit — Expanding vs Rolling Window

> ⚠️ Group C Q16 tested this. Answer: **D** — "expanding training windows followed by a future validation block".

Regular K-Fold **cheats** on time series (past validated on future). `TimeSeriesSplit` fixes this:

**Expanding window (default):**
```
Fold 1: train=[1..10],  val=[11..20]
Fold 2: train=[1..20],  val=[21..30]
Fold 3: train=[1..30],  val=[31..40]
```
Each new fold, training grows.

**Rolling window (`max_train_size=N`):**
```
Fold 1: train=[1..10],  val=[11..20]
Fold 2: train=[11..20], val=[21..30]
Fold 3: train=[21..30], val=[31..40]
```
Training stays same size — old data eventually rolls off.

**Sklearn:**
```python
from sklearn.model_selection import TimeSeriesSplit
tscv = TimeSeriesSplit(n_splits=5)              # expanding
tscv = TimeSeriesSplit(n_splits=5, max_train_size=100)  # rolling
```

---

## 17. Nested CV Structure (Code Pattern)

```python
from sklearn.model_selection import GridSearchCV, cross_val_score, KFold

outer_cv = KFold(n_splits=5, shuffle=True, random_state=42)
inner_cv = KFold(n_splits=3, shuffle=True, random_state=42)

param_grid = {'C': [0.01, 0.1, 1, 10, 100]}

inner_search = GridSearchCV(
    estimator=LogisticRegression(),
    param_grid=param_grid,
    cv=inner_cv,
    scoring='roc_auc',
)

# outer scoring — the honest generalization estimate
nested_scores = cross_val_score(inner_search, X, y, cv=outer_cv, scoring='roc_auc')
print(f"Nested CV AUC: {nested_scores.mean():.3f} ± {nested_scores.std():.3f}")
```

The `GridSearchCV` object refits internally on each outer training fold using inner CV, then evaluates on the outer validation fold — that outer score is the unbiased performance estimate.

**Cost:** if the inner grid has $g$ configurations and $k_{\text{inner}}$ folds, and there are $k_{\text{outer}}$ outer folds, you fit $k_{\text{outer}} \cdot (g \cdot k_{\text{inner}} + 1)$ models. Expensive but essential when the hyperparameter tuning itself matters.

---

## 18. BayesSearchCV — the Surrogate Model

> ⚠️ Group B Q19 tested this. Answer: **D** — "uses a probabilistic surrogate model to propose the next configuration".

Grid and random search are **uninformed** — each trial ignores what previous trials found. Bayesian search **learns from the trials it has already run** by fitting a surrogate model:

1. Sample the first few configurations randomly.
2. Fit a **Gaussian Process** (or tree-based surrogate) to `(hyperparams → CV score)` observations.
3. Use an **acquisition function** (e.g., Expected Improvement) to pick the next configuration:
   - Balances **exploration** (try uncertain regions) vs **exploitation** (drill down on promising ones).
4. Run the CV evaluation, update the surrogate, repeat.

**Package:** `scikit-optimize` (skopt), class `BayesSearchCV`.

```python
from skopt import BayesSearchCV
from skopt.space import Real, Integer, Categorical

search = BayesSearchCV(
    estimator=SVC(),
    search_spaces={
        'C': Real(1e-3, 1e3, prior='log-uniform'),
        'gamma': Real(1e-4, 1e1, prior='log-uniform'),
        'kernel': Categorical(['rbf', 'poly']),
    },
    n_iter=30,
    cv=5,
    scoring='roc_auc',
)
search.fit(X, y)
```

**When it wins over random search:** expensive-to-evaluate models (large data, slow CV). Random search still fine when trials are cheap.

---

## 19. Successive Halving

`HalvingGridSearchCV` and `HalvingRandomSearchCV` — a completely different acceleration strategy from Bayesian:

1. Run **all** configurations on a small resource budget (e.g., small subset of training data).
2. Keep only the top ~1/3 based on CV score.
3. Double the resource budget, run the survivors again.
4. Repeat until one configuration wins.

**Best when:** you have many configurations to explore AND a tunable resource (data size, `n_estimators`, epochs).

**Vs Bayesian search:** halving doesn't build a surrogate — it just eliminates losers cheaply. Simpler, more parallelizable. Modern tools (Optuna, HyperBand) combine both ideas.

---

## 20. statsmodels vs sklearn — When to Use Which

The labs teach both. They serve **different purposes**:

| | sklearn | statsmodels |
|---|---|---|
| **Purpose** | Prediction | Inference |
| **API** | `.fit()`, `.predict()` | `sm.OLS(y, X).fit()`, `.summary()` |
| **Output focus** | Predictions, `.score()`, `.predict_proba()` | p-values, confidence intervals, R², F-statistic |
| **Intercept** | Auto-added | Must add via `sm.add_constant(X)` |
| **Regularization** | Built-in (Ridge, Lasso, ElasticNet) | Available via `.fit_regularized()` |
| **Formula API** | No | Yes: `smf.ols('y ~ x1 + x2', data=df)` |
| **When to use** | Building a production predictive model | Testing hypotheses, business inference |

**In an exam context**, sklearn is what you'll be tested on for prediction pipelines. Statsmodels is what you'd use if the exam asks "which coefficient is statistically significant".

**Formula API example:**
```python
import statsmodels.formula.api as smf
model = smf.ols('house_price ~ sqft + bedrooms + C(neighborhood)', data=df).fit()
print(model.summary())
```

---

## 21. Gini Coefficient (Credit Scoring)

$$\text{Gini} = 2 \cdot \text{AUC-ROC} - 1$$

- Popular in credit risk & insurance.
- Range: $[-1, 1]$ where 1 = perfect, 0 = random.
- Equivalent to AUC — just rescaled.

**Not** to be confused with Gini impurity for decision tree splits — different concept, same name.

---

## 22. Lift Curve

Ratio of the model's precision at the top X% of predictions vs the base rate (population positive rate).

- **Lift @ 10% = 5** means: taking the top 10% predictions, the positive rate is 5× the population rate.
- Common in **marketing** — "if I target the top 10% of customers by predicted response, my response rate is 5× the untargeted baseline".
- Related to **cumulative gains** curve.

---

## 23. Log-Loss as a Proper Scoring Rule

> ⚠️ Group D Q14 tested this. Answer: **D** — "minimized in expectation by the true conditional probability".

A **proper scoring rule** is one where predicting the true conditional probability $P(Y \mid X)$ gives the lowest expected score. Log-loss (binary cross-entropy) and Brier score are both proper.

**Why it matters:** if your model minimizes log-loss on training data, and your training data is a random sample from the true joint distribution, then your model is being pushed toward the true conditional probabilities. That's why LogReg trained with cross-entropy gives calibrated probabilities.

**Non-proper example:** classification accuracy is NOT a proper scoring rule for probabilities — a model that always predicts 0.51 for a 50/50 problem has the same accuracy as one that outputs 0.99 for confident positives.

---

## 24. `validation_curve` vs `learning_curve`

Two different diagnostic plots, both important.

| | `validation_curve` | `learning_curve` |
|---|---|---|
| X-axis | A **hyperparameter** value | **Training-set size** |
| Y-axis | Score | Score |
| Answers | "How does score change as I vary this hyperparameter?" | "Would more data help?" |
| Diagnoses | Under/overfitting for a given hyperparameter | Whether the model is data-limited |

```python
from sklearn.model_selection import validation_curve, learning_curve

# Validation curve for C in logistic regression
train_scores, val_scores = validation_curve(
    LogisticRegression(), X, y,
    param_name='C', param_range=np.logspace(-3, 3, 20),
    cv=5, scoring='accuracy'
)

# Learning curve: does more data help?
train_sizes, train_scores, val_scores = learning_curve(
    LogisticRegression(C=1.0), X, y,
    train_sizes=np.linspace(0.1, 1.0, 10),
    cv=5, scoring='accuracy'
)
```

**⚠️ Group C Q11:** `validation_curve` = "training and validation scores as a function of one hyperparameter". Not sample size (that's `learning_curve`).

---

## 25. Multi-collinearity — Effect on OLS Coefficients

> ⚠️ Group C Q18 tested this.

When two or more features are highly correlated (but not perfectly):
- **Coefficient estimates become unstable** — small changes in data → large changes in coefficients.
- **Standard errors inflate** → confidence intervals widen → coefficients look insignificant even when the group is predictive.
- **Point predictions can still be fine** — multicollinearity doesn't affect $\hat{y}$ much, only the interpretation of individual coefficients.

**Answer:** it **inflates the variance of estimated coefficients**.

**Does NOT:**
- Reduce RSS to zero (that would require perfect fit).
- Lower bias (OLS remains unbiased under G-M assumptions even with correlation — just imprecise).
- Force the design matrix to be rank 1 (only *perfect* collinearity does that, and OLS fails entirely).

**Fixes:** Ridge regression (handles multicollinearity gracefully), remove redundant features, use PCA.

**Diagnostic:** Variance Inflation Factor (VIF).

---

## 26. SVM — Primal vs Dual (When to Use Which)

> ⚠️ Group D Q11 tested this. Answer: **B** — dual formulation enables the kernel trick.

The primal SVM optimization is $\min \frac{1}{2}\|w\|^2 + C\sum \xi_i$ — you learn $w \in \mathbb{R}^p$.

The dual reformulates it in terms of Lagrange multipliers $\alpha_i$ (one per training point). The prediction becomes:

$$f(x) = \sum_i \alpha_i y_i \langle x_i, x \rangle + b$$

Notice: the training data only appears as **inner products** $\langle x_i, x \rangle$ → you can replace with a kernel $K(x_i, x)$ → **kernel trick**.

**Rules of thumb:**
- **Primal preferred when:** #samples >> #features (few dimensions to learn).
- **Dual preferred when:** #features >> #samples, or you want to use non-linear kernels.

---

## 27. Hinge Loss (What Logistic Reg Doesn't Use)

> ⚠️ Group B Q4 tested this. Logistic regression uses **binary cross-entropy (log-loss)**, NOT hinge loss.

$$\text{Hinge}(y, f(x)) = \max(0, 1 - y \cdot f(x))$$

- $y \in \{-1, +1\}$.
- Zero loss if $y \cdot f(x) \geq 1$ (i.e., point is correctly classified with margin).
- Linear penalty inside the margin.
- **Sub-differentiable** at $y \cdot f(x) = 1$ → needs sub-gradient descent.
- Used by SVM (both linear and kernel).

Contrast with log-loss (used by logistic regression), which is smooth everywhere and penalizes even correct-but-uncertain predictions.

---

## 28. Ridge Has a Closed Form; Lasso Doesn't

> ⚠️ Group B Q12 asked what's TRUE about Ridge → **C: shrinks coefficients toward zero without setting any to zero**.

**Ridge closed form:**
$$\hat{\beta}_{ridge} = (X^T X + \lambda I)^{-1} X^T y$$

- Adding $\lambda I$ makes the matrix invertible even under multicollinearity — that's why Ridge handles it.
- Because of the L2 penalty's smoothness, coefficients smoothly approach zero as $\lambda$ increases but never hit it exactly.

**Lasso does NOT have a closed form** — the L1 penalty is non-smooth at zero. Requires **coordinate descent** or **LARS** (Least Angle Regression).

The L1 penalty *can* set coefficients to exactly zero because the gradient is discontinuous at zero, so the optimum often lands there.

---

## 29. Solver Choice for Logistic Regression

Sklearn's `LogisticRegression` needs a solver that matches the penalty:

| Solver | Supports | Notes |
|---|---|---|
| `lbfgs` (default) | L2, none | Good default for small/medium data |
| `liblinear` | L1, L2 | Fast on small data; only 1-vs-rest for multi-class |
| `saga` | L1, L2, Elastic Net, none | Only solver that supports Elastic Net penalty |
| `newton-cg` | L2, none | Small/medium data |
| `newton-cholesky` | L2, none | New (v1.2+); fastest on `n_features` << `n_samples` |
| `sag` | L2, none | Stochastic avg gradient — large data |

**Rules:**
- Elastic net → **must** use `saga`.
- L1 with lots of data → prefer `saga`.
- L1 with small data → `liblinear` is faster.
- Otherwise default (`lbfgs`) is fine.

---

## 30. Hard Voting vs Soft Voting

> ⚠️ Group D Q10 tested hard voting → answer **A: majority class among predictions**.

| | Hard voting | Soft voting |
|---|---|---|
| Base models return | Class labels | Class probabilities |
| Combination rule | Majority vote | Average of probabilities → argmax |
| Requires `predict_proba`? | No | Yes |
| Usually better when | Base models are diverse | Base models are well-calibrated |

```python
from sklearn.ensemble import VotingClassifier
vc = VotingClassifier([
    ('lr', LogisticRegression()),
    ('rf', RandomForestClassifier()),
    ('svm', SVC(probability=True)),
], voting='hard')     # or 'soft'
```

**Soft voting is usually better** — combines confidence, not just class labels — but only if the base classifiers' probabilities are trustworthy (calibrated). SVM without `probability=True` can't participate in soft voting.

---

## Cross-reference to failed exam questions

Reading these 30 lab-specific topics addresses ≥15 questions where the slides alone weren't sufficient. Most-frequently-tested lab topics on the May 15 exam:

- **imbalanced-learn workflow** (SMOTE inside CV): Group B Q16
- **Calibration methods**: Group A Q18, Group B Q13, Group D Q20, Group C Q20
- **Brier score**: Group B Q20
- **Drift concepts**: Group A Q20, Group C Q19
- **CV variants**: Group C Q16, Group A Q17
- **Feature selection details**: Group B Q18, Group D Q13
- **Bayesian search**: Group B Q19
- **class_weight**: Group D Q9
- **Missing indicator**: Group D Q17
- **Multi-collinearity**: Group C Q18
- **Hinge loss / SVM**: Group D Q11, Group B Q4
- **Voting**: Group D Q10
- **validation_curve**: Group C Q11
