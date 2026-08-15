---
title: ML1 - Complete Midterm Study Notes (v2)
course: 2400-DS1ML1
midterm_date: 2026-05-15 (retake)
version: 2
tags: [machine-learning, classification, msc, wne-uw, midterm]
supersedes: "[[ML1_Midterm_Study_Notes]]"
---

# ML1 — Complete Midterm Study Notes (v2)

> **What changed in v2:** This is the definitive single-source reading document. It integrates the original lecture notes with all lab-specific content (which was previously in `ML1_Lab_Notes`) and all comparison tables (previously in `ML1_Comparison_Tables`) into their natural sections. Reading v2 top-to-bottom gives you complete coverage of everything tested on the May 15 exam.
>
> **Still separate as purpose-built tools:** `[[ML1_Past_Exam_Practice]]` (drilling), `[[ML1_Worked_Examples]]` (practice problems), `[[ML1_Derivations]]` (proofs to memorize), `[[ML1_Code_CheatSheet]]` (sklearn API lookup), `[[ML1_Exam_Day_QuickRef]]` (30-min pre-exam skim).

## Contents

- [[#1 Introduction to Machine Learning]]
- [[#2 ML as a Function & Estimation]]
- [[#3 Training a Model — Cost Functions & Gradient Descent]]
- [[#4 Linear Regression]]
- [[#5 Logistic Regression]]
- [[#6 Generalized Linear Models (GLMs)]]
- [[#7 Regression Evaluation Metrics]]
- [[#8 Classification Evaluation Metrics]]
- [[#9 Probability-based Evaluation (ROC, PR, Brier, Log-loss)]]
- [[#10 Bias–Variance Trade-off]]
- [[#11 Train / Validation / Test Splits]]
- [[#12 Cross-Validation]]
- [[#13 K-Nearest Neighbours (KNN)]]
- [[#14 Support Vector Machines (SVM & SVR)]]
- [[#15 Data Preparation, EDA & Imputation]]
- [[#16 Feature Engineering]]
- [[#17 Regularization]]
- [[#18 Hyperparameter Tuning]]
- [[#19 Feature Selection]]
- [[#20 Class Rebalancing (Imbalanced Data)]]
- [[#21 Ensemble Methods]]
- [[#22 Probability Calibration]]
- [[#23 Model Depreciation & Drift Detection]]
- [[#24 statsmodels vs sklearn — Inference vs Prediction]]
- [[#25 Decision Trees]]
- [[#26 Random Forest]]
- [[#27 ML Project Workflow]]
- [[#28 Algorithm Comparison Reference]]
- [[#29 Bias-Variance Movers Reference]]
- [[#30 Cheat Sheet]]

---

## 1. Introduction to Machine Learning

**Machine Learning (ML)** is the process of using mathematical models of data to help a computer learn *without direct instruction*. ML is a subset of AI. Algorithms identify patterns in data, and those patterns produce a model that makes predictions. More data + experience → better accuracy.

ML is well-suited when:
- Data is constantly changing
- The task/request keeps shifting
- A hand-coded rule-based solution would be impractical

### Types of ML

| Type | Data | Goal |
|---|---|---|
| **Supervised** | Labeled (X, y) pairs | Learn $f: X \to Y$ |
| **Unsupervised** | Unlabeled X | Find hidden structure |
| **Semi-supervised** | Small labeled + large unlabeled | Combine both worlds |
| **Reinforcement** | Agent–environment, reward signal | Maximize cumulative reward |

**Supervised** splits into:
- **Regression** — continuous target (predict tomorrow's stock return, house price)
- **Classification** — categorical target (spam vs ham, disease vs healthy)

**Unsupervised** subtypes: clustering, anomaly/novelty detection, dimensionality reduction, association rules.

Econometrics is a subset of supervised learning.

### Main Challenges in ML

1. **Insufficient training data** — most algorithms need thousands of examples; complex problems need millions.
2. **Non-representative training data** — if training data doesn't reflect deployment distribution, generalization fails.
3. **Poor-quality data** — errors, outliers, noise hide the underlying patterns.

### Glossary of Synonyms (exam-relevant)

| Concept | Synonyms |
|---|---|
| Target | Dependent, endogenous, output, regressand, response, label |
| Feature | Independent, exogenous, explanatory, predictor, regressor, attribute |
| Example | Entity, row, observation, instance, sample, data point |
| Recall | True Positive Rate (TPR), Sensitivity, Hit rate |
| Specificity | True Negative Rate (TNR) |
| Precision | Positive Predictive Value (PPV) |
| FPR | Type I error, False alarm rate |
| FNR | Type II error, Miss rate |

---

## 2. ML as a Function & Estimation

### Fundamental assumption

$$Y = f(X) + \epsilon$$

- $f$ = fixed but unknown function of $X$
- $\epsilon$ = random error, independent of $X$, mean zero

**Goal:** estimate $f$. The true $f$ is unobservable — we can only approximate.

$$\hat{Y} = \hat{f}(X)$$

Prediction error has two parts:
- **Reducible error** (bias from a wrong functional form — fixable)
- **Irreducible error** (noise, omitted variables — unfixable)

### Three approaches to estimating $f$

| Approach | Functional form | # parameters | Examples |
|---|---|---|---|
| **Parametric** | Known | Finite | Linear regression, logistic regression |
| **Nonparametric** | Unknown | "Infinite" | KNN, SVM (basic), trees |
| **Semi-parametric** | Mix | Practically finite | — |

### Purpose of estimation

1. **Best prediction** → favor complex, non-parametric.
2. **Best inference / understanding** → favor parametric, explainable.
3. **Both** → balance.

> A more complex model is NOT always better. Understand the problem before modelling.

### Types of variables

- **Numeric** — continuous, discrete
- **Categorical** — nominal (no order), ordinal (ordered)
- **Binary** — special case of nominal with 2 levels

---

## 3. Training a Model — Cost Functions & Gradient Descent

### Loss vs Cost function

- **Loss function** $L$ — error between a *single* prediction and its actual value.
- **Cost function** $J$ — aggregated error across the *whole dataset*. Often = sum of losses + regularization term.

> **Model training = minimizing the cost function.**

### Properties of a good cost function

- Yields an **unbiased** estimator: $E[\hat{f}] = f$
- Yields an **efficient** estimator (smallest variance)
- Best case: **MVUE** (minimum-variance unbiased estimator)
- **Convex** — single global minimum
- **Smooth** — continuous & differentiable
- Reflects the **business/real cost** of errors (asymmetric losses when appropriate)

### Closed-form vs gradient descent

Some cost functions can be solved analytically (OLS: set $\partial J / \partial \beta = 0$, solve). Most cannot → gradient descent.

### Gradient descent

The gradient $\nabla J(\theta)$ points in the direction of fastest increase. Move in the opposite direction:

$$\theta_{t+1} = \theta_t - \eta \cdot \nabla J(\theta_t)$$

$\eta$ = **learning rate**. Too large → overshoot/diverge. Too small → painfully slow.

### Three GD variants

| Variant | Gradient computed on | Update | Trade-off |
|---|---|---|---|
| **Batch GD** | Entire training set | Once per epoch | Accurate but slow |
| **Stochastic GD (SGD)** | One sample at a time | Many per epoch | Fast & noisy; can escape local minima |
| **Mini-batch GD** | Small batch (e.g., 32, 64) | Per batch | Best practical balance |

### Loss function vs Evaluation metric — critical distinction

| | Loss function | Evaluation metric |
|---|---|---|
| Purpose | Train the model | Judge the model |
| Must be differentiable? | ✅ Yes (for gradient methods) | ❌ No |
| Must be convex? | ✅ Preferred | ❌ No |
| Examples (regression) | MSE, MAE | RMSE, MAPE, R², MedAE |
| Examples (classification) | Log-loss, hinge loss | Accuracy, F1, ROC AUC, MCC |
| Multiple per model | Usually 1 | Always evaluate on several |

---

## 4. Linear Regression

Basic supervised algorithm for predicting **continuous** targets.

- Econometric view: mostly for **inference**.
- ML view (this course): mostly for **prediction**.

Estimation methods: OLS (our focus), WLS, GLS.

### Matrix notation & closed form

$$y = X\beta + \epsilon, \qquad \hat{\beta}_{OLS} = (X^TX)^{-1}X^Ty$$

Requires $X^TX$ to be invertible → no perfect multicollinearity.

### OLS regression output — what to look at

- **R²** — % of variance in target explained. Always increases as you add features → misleading.
- **Adjusted R²** — penalizes useless features. Can *decrease*. Always ≤ R².

$$R^2_{adj} = 1 - (1 - R^2)\frac{n - 1}{n - p - 1}$$

- **F-statistic p-value** — p < 0.05 → model well specified.
- **t-statistic p-value (per parameter)** — p < 0.05 → variable is significant.

### Gauss-Markov: OLS is BLUE

Under classical assumptions, OLS is the **Best Linear Unbiased Estimator** — minimum-variance unbiased estimator in the linear class.

Required assumptions:
1. **Linearity** — relationship linear in parameters.
2. **Random sampling** — observations i.i.d.
3. **No perfect multicollinearity** — features not exact linear combos.
4. **Zero conditional mean** — $E[\epsilon | X] = 0$.
5. **Homoscedasticity** — $\text{Var}(\epsilon | X) = \sigma^2$ (constant variance).
6. **Normality of errors** — only needed for hypothesis testing.

### Multi-collinearity — what it does

When two features are highly correlated (but not perfectly):
- **Inflates variance of coefficient estimates** → wider confidence intervals → coefficients look insignificant.
- Point predictions $\hat{y}$ still fine — only interpretation is affected.
- Does NOT reduce RSS to zero, does NOT lower bias (OLS remains unbiased), does NOT force rank one (only perfect collinearity does).

**Fixes:** Ridge regression (handles gracefully), remove redundant features, PCA.
**Diagnostic:** Variance Inflation Factor (VIF).

---

## 5. Logistic Regression

Basic supervised algorithm for predicting **binary nominal** targets.

- Output is a **probability** in $[0, 1]$.
- Used for both inference and prediction.
- Interpretation harder → use marginal effects and odds ratios.

### Why not linear regression for binary y?

1. **Range** — linear can output <0 or >1, meaningless as probability.
2. **Wrong relationship** — going from P=0.50→0.51 vs P=0.98→0.99 aren't equally hard.
3. **Heteroscedasticity** — Var(y|x) = p(1-p) depends on x, violating OLS assumptions.

### The Sigmoid (Logistic) Function

$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

Properties:
1. Maps $\mathbb{R} \to (0, 1)$ → interpretable as probability.
2. **Differentiable** → gradient-friendly.
3. Sharp transitions push most outputs near 0 or 1.
4. **Derivative:** $\sigma'(z) = \sigma(z)(1 - \sigma(z))$ — used in gradient derivation.

### Linear vs Logistic — side by side

| | Linear | Logistic |
|---|---|---|
| Output | $\beta^T x$ | $\sigma(\beta^T x)$ |
| Range | $(-\infty, +\infty)$ | $(0, 1)$ |
| Cost function | MSE | Log-loss (binary cross-entropy) |
| Use | Continuous y | Binary y |
| Calibrated probabilities? | N/A | ✅ Yes (native) |
| Decision boundary | N/A | Linear |

### Key terminology

- **Odds** = $\frac{p}{1 - p}$
- **Log-odds (logit)** = $\log\frac{p}{1-p} = \beta^T x$ ← linear in features!

**Coefficient interpretation:** $\beta_j$ = change in **log-odds** per unit of $x_j$ (NOT probability directly).

### Cost function — Binary cross-entropy (log-loss)

$$J(\beta) = -\frac{1}{n}\sum_{i=1}^{n}\left[y_i \log \hat{p}_i + (1 - y_i)\log(1 - \hat{p}_i)\right]$$

**Why log-loss instead of MSE with sigmoid?** MSE + sigmoid → non-convex → gradient descent can get stuck in local minima. Log-loss + sigmoid → convex → global minimum guaranteed.

Gradient (clean form): $\nabla_\beta J = \frac{1}{n} X^T (\hat{p} - y)$ — same structure as linear regression.

### Multinomial logistic regression

For $k > 2$ classes:

**Approach 1: One-vs-All (OvR)** — train $k$ binary classifiers, pick the one with highest probability.

**Approach 2: Softmax** — generalizes sigmoid to $k$ classes:

$$P(y = j | x) = \frac{e^{\beta_j^T x}}{\sum_{l=1}^{k} e^{\beta_l^T x}}$$

**Cost:** categorical cross-entropy (generalized log-loss).

### Solver × Penalty compatibility (sklearn)

Not all solvers support all regularization penalties:

| Solver | L2 | L1 | Elastic Net | None |
|---|---|---|---|---|
| `lbfgs` (default) | ✅ | ❌ | ❌ | ✅ |
| `liblinear` | ✅ | ✅ | ❌ | ❌ |
| `saga` | ✅ | ✅ | ✅ | ✅ |
| `newton-cg` | ✅ | ❌ | ❌ | ✅ |

**Rules:**
- Elastic Net → **must** use `saga`.
- L1 with small data → `liblinear` is fastest.
- L1 with lots of data → `saga`.
- Default (`lbfgs`) is fine for standard L2 or unregularized.

---

## 6. Generalized Linear Models (GLMs)

A **GLM** extends linear regression by:
- Allowing the linear predictor $\eta = X\beta$ to relate to $y$ via a **link function** $g(\cdot)$ where $g(E[y]) = \eta$.
- Allowing variance to be a function of the mean.

Logistic regression = a GLM with logit link and Bernoulli distribution.

| Family | Distribution | Link | Use |
|---|---|---|---|
| Linear regression | Normal | Identity | Continuous y |
| Logistic regression | Bernoulli | Logit | Binary y |
| Poisson regression | Poisson | Log | Count y |
| Multinomial logistic | Multinomial | Softmax | Multi-class y |

---

## 7. Regression Evaluation Metrics

> Cost function trains the model. **Evaluation metric** judges it afterwards. Metrics don't need to be differentiable.

**Bias** = $y - \hat{y}$ (single prediction error).

| Metric | Formula | Notes |
|---|---|---|
| **MSE** | $\frac{1}{n}\sum (y_i - \hat{y}_i)^2$ | Penalizes big errors heavily |
| **RMSE** | $\sqrt{MSE}$ | Same units as y |
| **MAE** | $\frac{1}{n}\sum \|y_i - \hat{y}_i\|$ | Robust to outliers |
| **MAPE** | $\frac{1}{n}\sum \|\frac{y_i - \hat{y}_i}{y_i}\|$ | Scale-free %; breaks when $y_i \to 0$ |
| **sMAPE** | Symmetric MAPE | Avoids MAPE's asymmetry & div-by-zero |
| **MSLE** | $\frac{1}{n}\sum (\log(1 + y_i) - \log(1 + \hat{y}_i))^2$ | Penalizes under-prediction more |
| **R²** | $1 - \frac{\sum(y_i - \hat{y}_i)^2}{\sum(y_i - \bar{y})^2}$ | % variance explained |
| **MedAE** | Median of $\|y_i - \hat{y}_i\|$ | Very robust |

### Regression metric — decision guide

| Scenario | Best metric |
|---|---|
| No extreme outliers, standard use | RMSE, R² |
| Outliers present | MAE, MedAE |
| Errors across different scales matter | MAPE, sMAPE |
| Under-prediction is worse than over | MSLE |
| Communicating variance explained | R² |
| Comparing models with different # features | Adjusted R² |

**Tip:** Always visualize residual distribution — never trust a single number alone.

### MAE vs MSE properties

| | MSE | MAE |
|---|---|---|
| Sensitivity to outliers | High (squared) | Low (linear) |
| Gradient at zero | Smooth, continuous | Discontinuous |
| Preferred estimator | Sample **mean** | Sample **median** |
| Common in | Gradient-based training | Robust loss / L1 regression |

---

## 8. Classification Evaluation Metrics

### The Confusion Matrix

| | Predicted Positive | Predicted Negative |
|---|---|---|
| **Actual Positive** | TP | FN (Type II error) |
| **Actual Negative** | FP (Type I error) | TN |

**Memory aid:** row split = recall/specificity; column split = precision/NPV.

### Core metrics

| Metric | Formula | Question it answers |
|---|---|---|
| **Accuracy** ⚠️ | $(TP + TN)/N$ | How many predictions correct? (bad for imbalanced) |
| **Recall / Sensitivity / TPR** | $TP/(TP + FN)$ | Of all actual positives, how many caught? |
| **Specificity / TNR** | $TN/(TN + FP)$ | Of all actual negatives, how many caught? |
| **Precision / PPV** | $TP/(TP + FP)$ | Of predicted positives, how many correct? |
| **NPV** | $TN/(TN + FN)$ | Of predicted negatives, how many correct? |
| **FPR** | $FP/(FP + TN)$ | Type I error rate |
| **FNR** | $FN/(FN + TP)$ | Type II error rate |

### F-beta score

$$F_\beta = (1 + \beta^2) \cdot \frac{\text{Precision} \cdot \text{Recall}}{\beta^2 \cdot \text{Precision} + \text{Recall}}$$

- $\beta = 1$ → F1 (equal weight on P and R) — **harmonic mean**, not arithmetic.
- $\beta > 1$ → favor recall (e.g., cancer screening, fraud detection).
- $\beta < 1$ → favor precision (e.g., spam filter, recommendation).
- Great for **imbalanced datasets**.

### Matthews Correlation Coefficient (MCC)

Correlation between predictions and truth. Range $[-1, 1]$. **Robust to class imbalance.**

### Multiclass extensions

Compute per-class precision/recall/F-beta using one-vs-all, then aggregate:
- **micro** — pool TP/FP/FN across classes, then compute
- **macro** — average per-class metrics equally
- **weighted** — average per-class metrics weighted by support

### Classification metric — decision guide

| Scenario | Best metric |
|---|---|
| Balanced classes | Accuracy, F1, ROC AUC |
| Severely imbalanced | F-beta (β>1 if recall critical), PR AUC, MCC |
| Cost of FP >> FN | Precision, F-beta with β<1 |
| Cost of FN >> FP | Recall, F-beta with β>1 |
| Probabilities matter (risk) | Log-loss, Brier score |
| Ranking matters | ROC AUC (balanced), PR AUC (imbalanced) |

### Why accuracy fails on imbalanced data

99:1 dataset → "predict majority always" gets 99% accuracy but 0% recall on the minority. Baseline models beat real models on accuracy. Always check recall/precision/F1 alongside.

---

## 9. Probability-based Evaluation (ROC, PR, Brier, Log-loss)

Most classifiers output **probabilities**, not classes. We need to choose a **cut-off threshold**. Default 0.5 is often wrong.

### ROC curve (Receiver Operating Characteristic)

Plot **TPR (y)** vs **FPR (x)** for every possible cut-off.
- At threshold = 1: everything predicted negative → TPR = 0, FPR = 0.
- As threshold ↓: both TPR and FPR rise.
- The closer the curve hugs the top-left corner, the better.

### AUC ROC

Area under the ROC curve. Range $[0.5, 1]$ (0.5 = random, 1 = perfect).
- **Interpretation:** probability a random positive scores higher than a random negative.
- **Good for:** balanced or moderately imbalanced data, ranking tasks.
- **Bad for:** highly imbalanced data — misleadingly optimistic.

### Precision-Recall (PR) curve

Plot **Precision (y)** vs **Recall (x)** for every cut-off. Classic trade-off: higher precision ↔ lower recall.

### AUC PR (average precision)

Area under the PR curve.
- **Better than ROC AUC for imbalanced problems** — precision denominator is small, so false positives hurt visibly.
- Useful when communicating precision/recall trade-off to stakeholders.

### Log-loss / Cross-entropy

$$-\frac{1}{n}\sum [y_i \log \hat{p}_i + (1-y_i)\log(1-\hat{p}_i)]$$

- Heavily penalizes confident wrong predictions.
- **Proper scoring rule:** minimized in expectation by the true conditional probability $P(Y|X)$. That's why LogReg trained with log-loss gives calibrated probabilities.
- Lower is better.

### Brier score

$$BS = \frac{1}{N} \sum_{i=1}^{N} (p_i - y_i)^2$$

- Just MSE between predicted probabilities and 0/1 labels.
- Range $[0, 1]$; 0 = perfect.
- "Predict base rate always" model gets $BS = \bar{y}(1-\bar{y})$ = 0.25 on balanced data.
- Decomposes into **calibration + refinement** — calibration fixes only the first component.
- **NOT identical to log-loss** — Brier is bounded, log-loss is unbounded above.
- **Proper scoring rule** — also minimized by true $P(Y|X)$.

### Gini coefficient (credit scoring)

$$\text{Gini} = 2 \cdot \text{AUC-ROC} - 1$$

Popular in credit risk & insurance. Range $[-1, 1]$, 1 = perfect. Just AUC rescaled.

⚠️ Different concept from **Gini impurity** used for decision tree splits.

### Lift curve

Ratio of the model's precision at the top X% of predictions vs the base rate.
- "Lift @ 10% = 5" → top 10% predictions have 5× the base-rate positive rate.
- Common in **marketing** — "target top 10% of customers → 5× normal response rate."

### Metric applicability by model

| Metric | Any classifier? | Requires probabilities? |
|---|---|---|
| Accuracy | ✅ | ❌ |
| Precision / Recall / F1 | ✅ | ❌ |
| MCC | ✅ | ❌ |
| ROC AUC | ✅ (needs scores) | ✅ or scores |
| PR AUC | ✅ (needs scores) | ✅ or scores |
| Log-loss | ✅ | ✅ |
| Brier | ✅ | ✅ |

---

## 10. Bias–Variance Trade-off

> ⭐ **The single most-tested concept.**

### Definitions

- **Bias** — difference between expected prediction and true value. *How far off, on average?*
- **Variance** — variability of predictions across different training sets. *How sensitive to specific training data?*

### MSE decomposition

$$\text{Error} = \text{Bias}^2 + \text{Variance} + \sigma^2_{\text{noise}}$$

### The trade-off

| Model complexity | Bias | Variance | Risk |
|---|---|---|---|
| Too simple | High | Low | **Underfitting** |
| Too complex | Low | High | **Overfitting** |
| Just right | Balanced | Balanced | Good generalization |

Increasing model flexibility → **lowers bias while raising variance** (usually).

### Underfitting — signs and remedies

- Training AND validation errors both high.
- Model too simple to capture the pattern.
- **Fixes:** more complex model, more features, less regularization, **boosting**.

### Overfitting — signs and remedies

- Training error very low; validation error much higher.
- Model memorized noise.
- **Fixes:** simpler model, regularization, more data, dropout, **bagging**.

### Diagnosing from learning curves

| Curve pattern | Diagnosis |
|---|---|
| Both curves converge at low error | ✅ Good fit |
| Both curves plateau high, close together | Underfit |
| Train near 0, validation high and rising | Overfit |
| Both curves still descending steeply at end | Need more data |

### Bias-variance movers reference

| Action | Bias | Variance |
|---|---|---|
| Increase model complexity | ↓ | ↑ |
| Decrease model complexity | ↑ | ↓ |
| Add more training data | – | ↓ |
| Add regularization (L1/L2) | ↑ | ↓ |
| Remove regularization | ↓ | ↑ |
| Bagging (Random Forest) | – | ↓↓ |
| Boosting (XGBoost) | ↓↓ | ↓ (modest) |
| Use more (relevant) features | ↓ | ↑ |
| Use fewer features | ↑ | ↓ |
| Increase $k$ in KNN | ↑ | ↓ |
| Decrease $k$ in KNN | ↓ | ↑ |
| Increase $C$ in SVM | ↓ | ↑ |
| Decrease $C$ in SVM | ↑ | ↓ |
| Increase $\gamma$ in RBF | ↓ (locally) | ↑ |
| Decrease tree max_depth | ↑ | ↓ |

---

## 11. Train / Validation / Test Splits

> **Training and evaluating on the same data is a methodological mistake.**

| Set | Purpose |
|---|---|
| **Train** | Fit model parameters |
| **Validation** | Tune hyperparameters, select model |
| **Test** | Final, unbiased estimate of generalization |

### Stratified splitting

For classification with **imbalanced classes**, use **stratified sampling** so each split preserves the original class frequencies. Critical for imbalanced problems.

```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)
```

---

## 12. Cross-Validation

> Single train/validation split is fragile — value depends on which examples landed where.

**CV** = resampling method that trains/validates on different portions over multiple iterations.

### Why CV?

1. **Quasi-objective quality assessment** → reduces overfitting risk.
2. **Safe hyperparameter tuning** → prevents tuning on a lucky split.

### CV variants — decision guide

| Type | Use when… |
|---|---|
| **Hold-out** | Quick baseline, very large datasets |
| **K-Fold** | Standard cross-sectional data, no time component |
| **Stratified K-Fold** | Classification with imbalanced classes |
| **Leave-One-Out (LOO)** | Very small datasets (<100 obs) |
| **Leave-p-Out** | Niche statistical applications |
| **Repeated K-Fold** | Need more stable estimate, budget allows |
| **Nested K-Fold** | Honest performance estimate WHEN tuning |
| **Time Series Split** | Time-ordered data — never shuffle time series |
| **Group K-Fold** | Multiple observations per entity (patients, customers) |

### Nested CV — the honest performance estimate

Normal CV: tune hyperparameters AND estimate performance on the same folds → information leakage, optimistic bias.

Nested CV:
- **Inner loop**: CV for hyperparameter tuning (grid/random/Bayesian).
- **Outer loop**: assesses generalization — its test folds are completely held out from inner loop.

Computationally expensive but gives the most honest estimate. Example cost: 5 outer × 3 inner × 10 configs = 155 model fits.

### TimeSeriesSplit — expanding vs rolling window

Regular K-Fold **cheats** on time series (past validated on future). TimeSeriesSplit fixes this.

**Expanding window (default):**
```
Fold 1: train=[1..10],  val=[11..20]
Fold 2: train=[1..20],  val=[21..30]
Fold 3: train=[1..30],  val=[31..40]
```

**Rolling window (`max_train_size=N`):**
```
Fold 1: train=[1..10],  val=[11..20]
Fold 2: train=[11..20], val=[21..30]
Fold 3: train=[21..30], val=[31..40]
```

Two warnings specific to time series:
1. **Look-ahead leakage in features** — computing a rolling mean on the entire dataset before splitting leaks the future.
2. **Concept drift after fold end** — TimeSeriesSplit validates against the last portion of your data; if the world changed *after* your dataset ends, validation looks fine but production won't.

### The one principle behind every CV variant

*Validation must simulate the way the model will actually be used.* New patients → GroupKFold. Predicting the future → TimeSeriesSplit. Estimating generalization including tuning cost → nested CV.

### CV + imbalance

- Use **Stratified K-Folds** to preserve class proportions per fold.
- If also rebalancing (SMOTE, undersampling): do it **inside each training fold**, never before splitting. Use `imblearn.pipeline.Pipeline` — see §20.

### validation_curve vs learning_curve

Two different diagnostic plots:

| | `validation_curve` | `learning_curve` |
|---|---|---|
| X-axis | A **hyperparameter** value | **Training-set size** |
| Y-axis | Score | Score |
| Answers | "How does score change with this hyperparameter?" | "Would more data help?" |
| Diagnoses | Under/overfitting for a given hyperparameter | Data-limited vs not |

---

## 13. K-Nearest Neighbours (KNN)

### Core idea

> The best prediction for a new observation is the label of the most similar example(s) in the training set.

### KNN properties

- **Non-parametric** — no distributional assumptions.
- **Instance-based / lazy learner** — no training step; the training set IS the model.
- All computational cost is at **prediction time**.

### KNN for classification vs regression

- **Classification** → majority vote among k nearest neighbors.
- **Regression** → average (or weighted average) of k nearest target values.

### Three key hyperparameters

#### (a) Distance metric

| Metric | Formula | Notes |
|---|---|---|
| **Minkowski-p** | $\left(\sum \|x_i - y_i\|^p\right)^{1/p}$ | General form |
| **Euclidean** | Minkowski $p = 2$ | Straight-line; most common |
| **Manhattan** | Minkowski $p = 1$ | Grid distance; robust to outliers |
| **Chebyshev** | $\max_i \|x_i - y_i\|$ | Minkowski $p \to \infty$ |
| **Cosine** | $1 - \frac{x \cdot y}{\|x\|\|y\|}$ | Angle; good for text |

#### (b) Number of neighbors $k$

- Rule of thumb: $k \approx \sqrt{n}$, then tune with CV.
- **Small k → high variance** (overfits; $k=1$ is extreme).
- **Large k → high bias, smoother boundaries**.
- Prefer **odd k** for binary classification (avoid ties).

#### (c) Neighbor weights

- **Uniform** — all $k$ neighbors equally weighted (default).
- **Distance-weighted** — closer neighbors count more (e.g., inverse distance $1/d$ or $1/d^2$).

### Feature scaling — MANDATORY for KNN

Distance metrics are **absolute** — a variable on domain 0-1,000,000 will dominate one on 0-1, regardless of predictive value.

Example: age (20-80) vs income (20k-200k). Without scaling, income difference of 10k dominates age difference of 5 years, though age might matter more.

### Search algorithms

- **Brute force** — computes distance to all points, O(n) per query. Small data.
- **K-D Tree** — O(log n) per query. Efficient for low-dim data (< ~20 dims).
- **Ball Tree** — better for high-dim.

### Curse of dimensionality

As dimensions grow, points become approximately equidistant → "nearest" loses meaning. Numerical example: to capture 1% of data in a 100-dim unit hypercube, you need a neighborhood covering ~95% of each feature's range.

**Mitigations:** dimensionality reduction (PCA), feature selection, bagging, more data (exponentially).

### KNN — pros & cons

| ✅ Pros | ❌ Cons |
|---|---|
| Intuitive & simple | Slow at prediction time |
| Non-parametric | Memory-hungry (stores all data) |
| No training step | Curse of dimensionality |
| Works for classification & regression | Often low accuracy in practice |
| Few hyperparameters | Requires feature scaling |
| Handles sparse matrices well | Not naturally suited to imbalanced data |
| | No built-in missing value handling |
| | Sensitive to irrelevant features |

---

## 14. Support Vector Machines (SVM & SVR)

### Core idea

> Find the **hyperplane** that separates classes with the **maximum margin** — the widest "street" between it and the closest training points (the **support vectors**).

Author: Vladimir Vapnik.

### Geometric intuition

- Many hyperplanes can separate two classes.
- The best one lies as far as possible from the nearest points of both classes.
- Only **support vectors** (points on the margin) determine the hyperplane → SVM is **memory-efficient**.

### Formalization (binary, linearly separable)

Decision: $f(x) = w^T x + b$; predict +1 if $f(x) \ge 0$, else -1.

Margin width = $\frac{2}{\|w\|}$.

**Hard margin optimization:**

$$\min_{w, b} \frac{1}{2}\|w\|^2 \quad \text{s.t.} \quad y_i(w^T x_i + b) \ge 1 \;\; \forall i$$

Solved via **Lagrangian / quadratic programming**. Each point gets a Lagrange multiplier $\alpha_i$; only support vectors have $\alpha_i > 0$.

### Soft margin & the C parameter

Real data isn't always linearly separable. Introduce **slack variables** $\xi_i$:

$$\min_{w, b, \xi} \frac{1}{2}\|w\|^2 + C \sum \xi_i$$

- **Low $C$** → wide margin, more tolerance for errors, smoother boundary (more regularization).
- **High $C$** → narrow margin, fewer errors allowed, can overfit. Very high $C$ → hard margin behavior.

**$C$ is the most important SVM hyperparameter.** Search on a log scale (e.g., $C \in \{0.001, 0.01, 0.1, 1, 10, 100, 1000\}$).

### Hinge loss

$$L(y, f(x)) = \max(0, 1 - y \cdot f(x))$$

- $y \in \{-1, +1\}$.
- Zero loss if $y \cdot f(x) \ge 1$ (correctly classified outside margin).
- **Sub-differentiable at $y \cdot f(x) = 1$** → needs sub-gradient descent.
- Used by SVM — NOT by logistic regression (which uses log-loss).

### Primal vs Dual formulation

**Primal:** $\min \frac{1}{2}\|w\|^2 + C\sum \xi_i$ — learn $w \in \mathbb{R}^p$.

**Dual:** reformulate via Lagrange multipliers $\alpha_i$. Prediction becomes:

$$f(x) = \sum_i \alpha_i y_i \langle x_i, x \rangle + b$$

**Key property of dual:** data appears only as inner products $\langle x_i, x_j \rangle$ → enables the kernel trick.

**When to use which:**
- **Primal** — #samples >> #features (few dimensions to learn).
- **Dual** — #features >> #samples, OR you want non-linear kernels.

### Kernel trick

When data isn't linearly separable in input space, map it to a higher-dimensional space where it is. But we never compute the mapping explicitly — we use a **kernel function** $K(x_i, x_j) = \phi(x_i)^T \phi(x_j)$.

| Kernel | Formula | Use |
|---|---|---|
| **Linear** | $x^T x'$ | Linearly separable data |
| **Polynomial** | $(x^T x' + c)^d$ | Polynomial boundaries; hyperparameter: degree |
| **RBF / Gaussian** | $\exp(-\gamma \|x - x'\|^2)$ | Most flexible; hyperparameter: $\gamma$ |
| **Sigmoid** | $\tanh(\alpha x^T x' + c)$ | Less common |

**Mercer's theorem** guarantees kernels correspond to valid inner products in *some* feature space — we don't need to know which space.

### The $\gamma$ parameter in RBF

Controls **the reach of a single training point's influence**:
- **Large $\gamma$** → narrow influence → wiggly boundary → risk of overfitting (high variance).
- **Small $\gamma$** → broad influence → smoother boundary → risk of underfitting.

Search $\gamma$ on log scale too. Sklearn default `gamma='scale'` = $1/(n_{\text{features}} \cdot X.\text{var}())$.

### Feature scaling — MANDATORY for SVM

Like KNN, SVM relies on distances → **always standardize** (typically z-score). Fit scaler on train, transform on test.

### Multiclass SVM

SVM is natively binary. For $k$ classes:
- **One-vs-All** → $k$ classifiers
- **One-vs-One** → $\binom{k}{2}$ classifiers; vote

### Support Vector Regression (SVR)

Adapts SVM for regression with an **$\epsilon$-tube** of tolerance. Errors inside $|\hat{y} - y| \le \epsilon$ don't count; outside, they're penalized.

Key SVR hyperparameters: $C$, kernel (+ its params), $\epsilon$ (tube width).

### SVM — pros & cons

| ✅ Pros | ❌ Cons |
|---|---|
| Effective in high-dim spaces | Slow on very large datasets |
| Works when #dims > #samples | Low interpretability (kernels) |
| Memory-efficient (SVs only) | Bad when classes overlap heavily |
| Versatile via kernels | Overfits when #features >> #samples without care |
| Partially outlier-robust (with regularization) | No native probabilities — need CV calibration |
| Class weighting for imbalance | |

---

## 15. Data Preparation, EDA & Imputation

### Dataset preparation pipeline

1. Define and source necessary data.
2. **Ingest** — extract from source systems.
3. Transform to clean, analytical form.
4. Initial exploration + validation.
5. Combine sources if appropriate.
6. **Split** {train, val, test} early. ⚠️ Fit all transformations on train only.
7. Clean (impute missings).
8. **Feature engineering** — generate new variables.
9. Extensive EDA (stats + viz).
10. Initial feature selection.
11. Rebalance target classes if needed.
12. Save to a model-friendly format.

### Exploratory Data Analysis (EDA)

**Visual analysis:**
- Univariate (histograms, box plots)
- Bivariate (scatter plots, grouped boxplots)
- Multivariate (pair plots, heatmaps, parallel coordinates)

**Statistical analysis:**

| Univariate | Multivariate |
|---|---|
| Descriptive stats (mean, std, skew, kurtosis, quantiles) | Correlation (Pearson/Spearman/Kendall) |
| One-sample tests | Chi-square (cat-cat) |
| Autocorrelation, white noise (time series) | ANOVA (cat-num) |
| Frequency tables | t-test (num-num across groups) |

Unsupervised techniques like **PCA** are useful exploratory tools.

### Types of missing data

| Type | Full name | Meaning |
|---|---|---|
| **MCAR** | Missing Completely At Random | Missingness unrelated to any variable. Sensor failed randomly. |
| **MAR** | Missing At Random | Missingness depends on OBSERVED variables. Older customers less likely to disclose income (depends on age, observed). |
| **NMAR** | Not Missing At Random | Missingness depends on the unobserved value itself. High earners refuse to disclose income (depends on income). |

**Consequences:**
- **MCAR** → simple imputation (mean/median) is unbiased.
- **MAR** → conditional imputation (KNN, MICE) can be unbiased.
- **NMAR** → imputation introduces bias no matter what.

### Missing data treatment

1. **Do nothing** — some algorithms handle it natively (XGBoost, LightGBM).
2. **Remove**:
   - Drop column if > ~10% missing AND not crucial.
   - Drop row only if dataset is large AND missings look random.
3. **Imputation** (see table below).

### Imputation methods

| Variable type | Univariate | Multivariate |
|---|---|---|
| Continuous | constant, mean/median/mode (global or by subgroup), random draw | KNN imputation, **MICE**, other supervised ML |
| Categorical | new "missing" category, mode | KNN, MICE |
| Time series | LOCF (forward fill), next-observed, linear/polynomial/spline interpolation | — |
| Binary | mode | MICE with logistic |

### The Missing Indicator column

When you impute a value, you throw away the information that it was missing. Sometimes that missingness itself is predictive.

**Solution:** add a binary column `feature_missing` (1 if original was missing, 0 otherwise) alongside the imputed feature.

**When it helps:** missingness is informative (NMAR, or MAR with predictive value). Example: missing "years-of-employment" often correlates with unemployment in credit scoring.

**Sklearn:**
```python
from sklearn.impute import SimpleImputer
imp = SimpleImputer(strategy='median', add_indicator=True)
```

### ColumnTransformer — different transformations per column set

```python
from sklearn.compose import ColumnTransformer
ct = ColumnTransformer([
    ('num', StandardScaler(), ['age', 'income']),
    ('cat', OneHotEncoder(handle_unknown='ignore'), ['country']),
], remainder='drop')
```

**Why crucial:** only way to combine numeric scaling + categorical encoding in one Pipeline. Prevents leakage in CV.

### When to skip imputation

- Algorithm handles missings natively (XGBoost, LightGBM, CatBoost).
- Missingness is informative → create indicator AND impute.

---

## 16. Feature Engineering

> The single biggest determinant of model quality. "Garbage in, garbage out."

**Two main moments:**
1. **During ETL** — analytical engineering with domain knowledge (aggregations).
2. **After ETL** — creative feature creation, especially for models that can't capture non-linearity natively (OLS, KNN, SVM).

> ⚠️ Each transformation must be **fit on training set only**, then applied to test set.

### Numeric variable transformations

| Technique | Formula / Idea | When to use |
|---|---|---|
| **Min-max scaling** | $z = (x - \min)/(\max - \min) \in [0, 1]$ | Feature roughly uniform in a fixed range |
| **Clipping (winsorization)** | Cap above max, floor below min | Extreme outliers |
| **Log scaling** | $z = \log(x)$ | Feature follows a power law |
| **Z-score (StandardScaler)** | $z = (x - \mu)/\sigma$ → mean 0, std 1 | No extreme outliers |
| **Robust Scaler** | $(x - \text{median})/IQR$ | Outliers present |
| **Quantile transformer** | Map to uniform $[0, 1]$ or normal | Robust to outliers, changes distribution |
| **Power transformer (Box-Cox, Yeo-Johnson)** | Map to ~Gaussian | Reduce skew |
| **Bucketing (discretization)** | Bin continuous into ranges | Non-linearity, overfitting |
| **Polynomial / spline transformer** | Add $x^2, x^3, \dots$ | Capture non-linear relationships |

**Bucketing boundaries:** equal spacing, quantiles, decision-tree splits, expert-defined.

### Categorical variable transformations

| Technique | Description | Best for |
|---|---|---|
| **One-hot encoding** | $k$ levels → $k$ (or $k-1$) binary columns | Nominal, low cardinality (<10), linear models |
| **Ordinal encoder** | Map levels to integers | TRULY ordinal (rank, education level) |
| **Target encoder** | Replace category with mean-of-target for that category (with cross-fitting to prevent leakage) | High cardinality, tree models |
| **CatBoost encoder** | Target encoding with ordered statistics | Many high-cardinality features |
| **WoE (Weight of Evidence)** | $\log(P(\text{good})/P(\text{bad}))$ | Credit risk, binary classification |
| **Count/Frequency encoding** | Replace with the count | When frequency itself is informative |
| **Hashing** | Hash to fixed buckets | Very high cardinality, online learning |

### Cardinality rule of thumb

- **< 10 levels** → one-hot.
- **10-50 levels** → one-hot for linear models, target/CatBoost for tree models.
- **> 50 levels** → target/CatBoost or hashing.

### ⚠️ Encoding traps

- **`LabelEncoder`** is for the **target** only. NEVER for features (it imposes an artificial order).
- **`OrdinalEncoder`** for features, but ONLY when the order is real.
- **`OneHotEncoder(handle_unknown='ignore')`** is essential — otherwise unseen test-time categories raise errors.
- **`drop='first'`** avoids perfect collinearity in linear models. With L1/L2 you can keep all.

### Feature scaling — which methods need it?

| Algorithm | Needs scaling? | Why? |
|---|---|---|
| **OLS Linear Regression** | ❌ No | Coefficients absorb the scale |
| **Ridge / Lasso / Elastic Net** | ✅ YES | Penalty treats all coefficients equally |
| **Logistic Regression (vanilla)** | ⚠️ Helps convergence | Gradient descent faster |
| **Regularized Logistic Regression** | ✅ YES | Same as Ridge/Lasso |
| **KNN** | ✅ MUST | Distance-based |
| **SVM (any kernel)** | ✅ MUST | Distance/kernel-based |
| **Decision Tree** | ❌ No | Threshold-invariant |
| **Random Forest / XGBoost** | ❌ No | Same as tree |
| **Neural Networks** | ✅ YES | Gradient stability |
| **K-means clustering** | ✅ YES | Distance-based |
| **PCA** | ✅ YES | Variance dominated by large-scale features |

### Interactions

Multiply, divide, subtract pairs of variables. Use domain intuition.

### Practical wisdom

- More features isn't always better.
- Tree-based models can ignore irrelevant features; linear models cannot.
- In finance, features with **strong theoretical basis** usually beat fishing.

---

## 17. Regularization

> A tool to fight **overfitting** (high variance). Modifies the loss to penalize complexity.

$$J_{reg}(\theta) = J(\theta) + \lambda \cdot R(\theta)$$

- $\lambda$ (or $\alpha$) controls strength; tune via CV.

### Three main types

| Type | Penalty | Effect |
|---|---|---|
| **L1 (Lasso)** | $\sum \|\theta_j\|$ | Pushes weights to **exactly 0** → automatic **feature selection** |
| **L2 (Ridge)** | $\sum \theta_j^2$ | Shrinks weights toward 0 but rarely zero. Handles **multicollinearity** well |
| **Elastic Net** | $\alpha L_1 + (1-\alpha) L_2$ | Best of both. Often the most reasonable choice. |

### Detailed comparison

| | L1 (Lasso) | L2 (Ridge) | Elastic Net |
|---|---|---|---|
| Coefficient shrinkage | Drives to exact 0 | Shrinks toward 0 | Both |
| Feature selection | ✅ Yes (auto) | ❌ No | ✅ Partial |
| Handles multicollinearity | ⚠️ Poorly (picks one randomly) | ✅ Well | ✅ Well |
| Solution path | Sparse | Dense | Mixed |
| **Closed form solution** | ❌ **No** — needs coordinate descent or LARS | ✅ **Yes:** $(X^TX + \lambda I)^{-1}X^Ty$ | ❌ No |
| Convexity | Convex (non-smooth at 0) | Smooth & convex | Convex |
| When features > samples | ⚠️ Selects at most n features | ✅ Works | ✅ Works |

### Decision rule

- **Lasso** — many features, most likely irrelevant, want feature selection.
- **Ridge** — all features probably matter, multicollinearity present.
- **Elastic Net** — when in doubt, or correlated groups of features (Lasso picks one arbitrarily; Elastic Net keeps the group).

### Ridge has a closed form; Lasso doesn't

**Ridge:** Adding $\lambda I$ makes matrix invertible even under multicollinearity → that's why Ridge handles it. Coefficients smoothly approach zero as $\lambda$ increases but never hit exactly.

**Lasso:** L1 penalty is non-smooth at zero → no closed form. Solved via **coordinate descent** or **LARS**. The gradient discontinuity at zero is precisely why coefficients CAN land at exactly zero.

### Elastic Net requires the `saga` solver

For logistic regression with Elastic Net penalty, sklearn requires `solver='saga'` — no other solver supports it.

### Feature scaling before regularization

**Always scale before Ridge/Lasso/Elastic Net.** The penalty term treats all coefficients equally; without scaling, large-range features get small coefficients that escape the penalty while small-range features get penalized heavily. Result depends on units — meaningless.

---

## 18. Hyperparameter Tuning

**Hyperparameter** — a parameter NOT learned during training; set by the researcher (e.g., $k$ in KNN, $C$ in SVM, tree depth).

### Components

1. **Hyperparameter space** — set of values or distributions.
2. **Search strategy** — how to explore the space.
3. **Score function** — how to evaluate each configuration.
4. **CV scheme** — appropriate for the problem.

### Three search strategies

| Strategy | How it works | Pros | Cons |
|---|---|---|---|
| **Grid search** | Exhaustively test every combination | Simple, reproducible | Expensive; bad in high dim |
| **Random search** | Randomly sample $n$ configs | More efficient than grid in high dim | Doesn't learn from past trials |
| **Bayesian search** | Build probabilistic surrogate model; balance exploration vs exploitation | Sample-efficient; great for expensive evals | Complex to implement |
| **Halving / Successive Halving** | Many configs briefly; survivors get more compute | Very efficient | Risk of pruning slow-starters |
| **Hyperband** | Multi-fidelity bandit allocation | Strong on neural nets | Less mature in non-DL ML |

### Bayesian search — the surrogate model

The key idea:
1. Sample first few configurations randomly.
2. Fit a **Gaussian Process** (or tree-based surrogate) to `(hyperparams → CV score)` observations.
3. Use an **acquisition function** (e.g., Expected Improvement) to pick the next configuration — balancing:
   - **Exploration** (uncertain regions)
   - **Exploitation** (promising regions)
4. Update surrogate, repeat.

**Package:** `scikit-optimize`, class `BayesSearchCV`.

**When it wins over random search:** expensive-to-evaluate models. Random search fine for cheap evaluations.

### Successive Halving

Different acceleration than Bayesian:
1. Run **all** configurations on a small resource (small dataset, few estimators).
2. Keep top ~1/3 by CV score.
3. Double resource, run survivors.
4. Repeat until one wins.

Best when you have many configurations AND a tunable resource. Simpler and more parallelizable than Bayesian.

### Practical workflow

1. Start with **random search** over wide range (50-100 trials).
2. Identify promising region.
3. Switch to **grid search** in smaller region OR **Bayesian** for fine-tuning.
4. Always combine with **proper CV** (Stratified K-Fold for imbalanced classification).

---

## 19. Feature Selection

After feature engineering you have **many** features — but some models don't auto-select (OLS, KNN, SVM). Time to prune.

### Two-step recommended approach

**Step 1: Univariate / bivariate selection**

| Method | What it tests |
|---|---|
| **Variance Threshold** | Removes features with variance below threshold (constants & near-constants) — does NOT use target |
| **Mutual information** | Information-theoretic dependence between feature and target |
| **F-test (ANOVA)** | For numeric feature × categorical target |
| **Chi²** | For non-negative feature × categorical target |
| **Correlation** | Pearson (linear), Spearman (rank), Kendall |

Wrap with `SelectKBest` or `SelectPercentile`.

**Step 2: Multivariate selection**

**Embedded** (selection during model fitting):
- **Lasso / Elastic Net** — built-in via L1 penalty.
- **Boruta** — wrapper around Random Forest.
- **SHAP values** — explainable ML feature importance.

**Wrapper** (search over feature subsets using CV):
- **Forward selection (SFS forward)** — start empty, add best each round.
- **Backward selection (SFS backward)** — start with all, remove worst each round.
- **RFE (Recursive Feature Elimination)** — iteratively fits estimator, removes least important feature by coefficient/importance.
- **RFECV** — RFE with CV to auto-select optimal number of features.
- **SelectFromModel** — one-shot filter based on feature importance threshold (typically with Lasso or RandomForest).

### RFE vs SequentialFeatureSelector vs SelectFromModel

| Method | Speed | Uses CV? | Basis |
|---|---|---|---|
| **RFE** | Fast | No | Model's coefficient/importance |
| **RFECV** | Slower | Yes | Model's coefficient + CV |
| **SFS** | Slow | Yes | CV score improvement |
| **SelectFromModel** | Fastest | No | Feature importance vs threshold |

### Built-in feature importance

Random Forest, XGBoost, CatBoost, LightGBM all expose feature importance — use heavily in practice.

---

## 20. Class Rebalancing (Imbalanced Data)

The imbalance problem hits in two places:
1. **During training** — cost function focuses on majority.
2. **During evaluation** — accuracy & ROC AUC misleadingly optimistic.

### Four families of solutions

1. **Cost-function modification** (class weights)
2. **Undersampling** (reduce majority)
3. **Oversampling** (grow minority)
4. **Combination** of both

### class_weight='balanced' — the exact formula

$$w_c = \frac{n_{\text{samples}}}{n_{\text{classes}} \cdot n_c}$$

where $n_c$ = count of class $c$. Minority gets larger loss weight; majority gets smaller.

**What it does NOT do:** duplicate minority samples (that's random oversampling); remove majority samples (that's undersampling); require SMOTE beforehand (fully independent).

### Undersampling techniques

**Prototype generation:**
- **Cluster Centroids** — replace majority class with K-means centroids of the majority class, keeping same count as minority.

**Prototype selection:**
- **Random undersampler** — fast, simple.
- **Tomek's links** — pair of nearest neighbors of opposite classes; remove the majority member → cleaner boundary.
- **Edited Nearest Neighbours (ENN)** — remove majority points whose class disagrees with their neighbors. Can be repeated → **Repeated ENN**.

### Oversampling techniques

- **Random oversampler** — duplicate minority points.
- **SMOTE (Synthetic Minority Over-sampling Technique)** — create new minority points as **convex combinations** of existing minority points and their nearest neighbors. Variants:
  - **Borderline SMOTE** — generate near the class boundary.
  - **SVM SMOTE** — uses SVM support vectors to guide.
  - **K-means SMOTE** — clusters minority first, generates per cluster.
- **ADASYN (Adaptive Synthetic)** — like SMOTE but generates *more* samples for harder-to-learn minority points.

### Combination methods

- **SMOTETomek** — SMOTE + Tomek-link cleaning.
- **SMOTEENN** — SMOTE + Edited Nearest Neighbours cleaning.

### Decision guide

| Severity & data | Recommendation |
|---|---|
| Mild imbalance (1:3 to 1:5) | class_weight only |
| Moderate (1:5 to 1:20) | class_weight + random undersampling or SMOTE |
| Severe (>1:20) | SMOTE variants + Tomek/ENN cleaning + class_weight |
| Very high-dim data | class_weight only (SMOTE doesn't work well in high dim) |
| Cost-sensitive problem | Custom class weights matching business costs |

### ⚠️ CRITICAL: rebalance INSIDE CV folds

Rebalancing before splitting causes **data leakage**: SMOTE creates synthetic points from existing minority points and their neighbors. If you split after SMOTE, your validation set contains synthetic points whose "parents" are in the training set → the model is being evaluated on near-duplicates of training data → optimistically biased evaluation.

**Solution:** use `imblearn.pipeline.Pipeline` (NOT `sklearn.pipeline.Pipeline` — which doesn't support resampling steps that change sample count):

```python
from imblearn.pipeline import Pipeline
from imblearn.over_sampling import SMOTE

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('smote', SMOTE(random_state=42)),   # sklearn.pipeline can't handle this
    ('model', LogisticRegression()),
])
```

In each fold, SMOTE fires only on the training portion; validation stays at original class ratio.

---

## 21. Ensemble Methods

> Combine multiple **weak models** to get one strong model.

### Four ensemble strategies

| Strategy | Idea | Base learner type | Example | Effect |
|---|---|---|---|---|
| **Bagging (Bootstrap Aggregating)** | Train models on bootstrap samples in parallel; aggregate | High-variance (deep trees) | **Random Forest** | ↓↓ variance |
| **Boosting** | Train sequentially; each corrects previous errors | High-bias (shallow trees) | AdaBoost, XGBoost, LightGBM, CatBoost | ↓↓ bias (and variance) |
| **Stacking** | Base models' predictions become features for a **meta-learner** | Any diverse mix | Custom | Combines strengths |
| **Voting** | Combine different model types; majority vote or average probabilities | Diverse models | VotingClassifier | Quick win |

### Bagging vs Boosting head-to-head

| | Bagging | Boosting |
|---|---|---|
| Training | Parallel | Sequential |
| Aim | Reduce variance | Reduce bias |
| Base learner | Should be high-variance | Should be high-bias |
| Overfit risk | Low | Higher (need regularization) |
| Sensitivity to noise | Low | Higher (focuses on hard/noisy examples) |
| Speed | Faster (parallelizable) | Slower |

### AdaBoost

Adaptive boosting: after each round, increase weights on misclassified examples → next learner focuses on hard cases.

### Hard voting vs Soft voting

| | Hard voting | Soft voting |
|---|---|---|
| Base models return | Class labels | Class probabilities |
| Combination rule | Majority vote | Average of probabilities → argmax |
| Requires `predict_proba`? | No | Yes |
| Usually better when | Base models are diverse | Base models are well-calibrated |

**Soft voting is usually better** — combines confidence, not just labels — IF the base classifiers' probabilities are trustworthy (calibrated).

### Stacking — the out-of-fold requirement

If base models predict on the same data they were trained on, predictions are unrealistically good → the meta-learner learns to trust them blindly, disappointment at test time. **Out-of-fold predictions** simulate the test-time situation. `StackingClassifier` handles this internally.

---

## 22. Probability Calibration

A model is **well-calibrated** if, among predictions with probability ~$p$, roughly fraction $p$ are actually positive.

**Why we care:**
- Some models don't return probabilities natively (SVM).
- Some return probabilities but they're miscalibrated.
- Critical for risk-sensitive applications (credit scoring, insurance).

### Calibration of common classifiers

| Model | Calibration | Why |
|---|---|---|
| **Logistic regression** | ✅ Naturally calibrated | Optimizes log-loss → MLE on probabilities |
| **Naive Bayes** | ❌ Over-confident (pushes to 0/1) | Independence assumption inflates likelihoods |
| **Random Forest** | ❌ Peaks around 0.2 and 0.9, rarely extreme | Averaging trees pulls extreme values toward middle |
| **SVM** | ❌ Strong sigmoid shape | Doesn't optimize for probabilities |
| **KNN** | ⚠️ Granular ($k+1$ values) | Just neighbor counts |
| **Gradient Boosting** | ⚠️ Moderately calibrated | Closer to LR than RF |
| **Neural Network** | ⚠️ Depends | Often over-confident |

### How to calibrate

Fit a **calibrator** (regressor) that maps raw model output → calibrated probability in $[0, 1]$. Done inside **cross-validation** to avoid bias.

Two calibrators (binary; multi-class via One-vs-Rest):

| | Sigmoid (Platt scaling) | Isotonic |
|---|---|---|
| Type | Parametric (2 params: A, B) | Non-parametric, monotone |
| Formula | $p = 1/(1 + \exp(A \cdot f + B))$ | Piecewise constant monotone function |
| Fits via | Logistic regression on classifier scores | Non-parametric monotonic mapping |
| Data needed | Small (~50+) | Large (~1000+) |
| Overfitting risk | Very low | Moderate on small data |
| Best when | Miscalibration is S-shaped (SVM, Naive Bayes) | Miscalibration is irregular (Random Forest) |

**Sklearn:**
```python
from sklearn.calibration import CalibratedClassifierCV
cal = CalibratedClassifierCV(base_estimator=SVC(), method='sigmoid', cv=5)
# or method='isotonic'
```

### Quality of calibration

Check with:
- **Calibration curves (reliability diagrams)** — predicted prob on x, observed frequency on y; the diagonal is perfect calibration.
- **Brier score** — MSE between predicted probs and 0/1 labels; lower = better.

---

## 23. Model Depreciation & Drift Detection

Models degrade over time as data distributions and relationships change.

### Three types of drift

| Type | What changes | Detectable without labels? |
|---|---|---|
| **Data drift / Covariate drift** | $P(X)$ — distribution of inputs | ✅ Yes — compare feature distributions |
| **Concept drift** | $P(Y \mid X)$ — relationship inputs → target | ❌ No — need labels |

**Examples:**
- Data drift: house-size distribution shifts, customer demographics change.
- Concept drift: fraud patterns evolve, new money-laundering techniques emerge.
- Combined: pandemic changes both what customers buy AND how they respond to marketing.

### The two core monitoring questions

1. *Did the input distribution change?* (data drift) — cheap, label-free.
2. *Did the input → target relationship change?* (concept drift) — needs labels, delayed.

Data drift is noticed **first**; concept drift is confirmed **later**.

### Detection tools

**Kolmogorov-Smirnov (KS) test:**
- Compares two empirical CDFs, returns a p-value.
- p < 0.05 → distributions likely different.
- **Pitfall:** with large N, KS detects microscopic differences that are statistically significant but operationally irrelevant. Always pair with an effect-size measure.

**Wasserstein distance (earth-mover's distance):**
- Measures how far one distribution needs to be "moved" to become another.
- Same units as the feature → interpretable.
- Ideal for **alerting thresholds** in production ("alert if `age` shifts by more than 2 years on average").
- Non-parametric — works for any distribution.

```python
from scipy.stats import wasserstein_distance
d = wasserstein_distance(train_feature, prod_feature)
```

### Concept drift is invisible to input monitoring

The features look fine — their distributions unchanged. The model's R² silently collapses because the *coefficients* of the true data-generating process moved. Only signals: (a) accuracy on labeled production data, (b) prediction distribution shifts, (c) auxiliary business KPIs. All three delayed by however long labels take to come back.

### Retraining cadence intuition

Time-vs-error plot patterns:
- **Flat line** → model is stable, retraining adds risk without reward.
- **Slow upward drift** → schedule periodic retraining (weekly/monthly).
- **Sudden jump** → look for an external event (regulation change, promo campaign, pandemic). Usually you need *new features*, not just new data.

---

## 24. statsmodels vs sklearn — Inference vs Prediction

Two libraries, different purposes.

| | sklearn | statsmodels |
|---|---|---|
| **Purpose** | Prediction | Inference |
| **API** | `.fit()`, `.predict()` | `sm.OLS(y, X).fit()`, `.summary()` |
| **Output focus** | Predictions, `.score()`, `.predict_proba()` | p-values, confidence intervals, R², F-statistic |
| **Intercept** | Auto-added | Must add via `sm.add_constant(X)` |
| **Regularization** | Built-in (Ridge, Lasso, ElasticNet) | Available via `.fit_regularized()` |
| **Formula API** | No | Yes: `smf.ols('y ~ x1 + x2', data=df)` |
| **When to use** | Building predictive models | Testing hypotheses, business inference |

### Formula API example

```python
import statsmodels.formula.api as smf
model = smf.ols('house_price ~ sqft + bedrooms + C(neighborhood)', data=df).fit()
print(model.summary())
```

`C(x)` treats `x` as categorical → auto dummy encoding. `y ~ x1 * x2` for interactions.

### Interpretation of statsmodels output

- `coef` — estimated $\hat{\beta}$
- `std err` — standard error
- `t` (or `z` for GLM) — test statistic
- `P>|t|` — p-value (compare to 0.05)
- `[0.025, 0.975]` — 95% confidence interval
- Bottom: R², Adj R², F-statistic, AIC, BIC, Durbin-Watson (autocorr)

---

## 25. Decision Trees

### Core idea

> Learn and apply simple **decision rules** (if-else) from training data. The model is a piecewise-constant approximation of $f$.

### Family of tree algorithms

- **ID3** — categorical features, classification only.
- **C4.5** — adds continuous features.
- **C5.0** — improvement of C4.5.
- **CART** (Classification And Regression Trees) — both tasks.

### Splitting criteria

**Classification:**
- **Gini impurity** — $1 - \sum p_k^2$
- **Entropy** — $-\sum p_k \log_2 p_k$
- **Information Gain** — parent entropy − weighted child entropy

**Regression:**
- **MSE** (variance reduction)
- **MAE**

Both Gini and entropy measure class purity. Gini is faster (no log) and default in sklearn.

### Key hyperparameters

| Hyperparameter | Controls |
|---|---|
| **max_depth** | Tree depth. **Most important — overfitting risk.** Start with 3 |
| **min_samples_split** | Min samples to split an internal node |
| **min_samples_leaf** | Min samples per leaf |
| **criterion** | Gini / entropy / MSE |
| **max_features** | # features to consider per split |

### Trees — pros & cons

| ✅ Pros | ❌ Cons |
|---|---|
| Very intuitive & visualizable | Easy to overfit |
| Handle continuous and categorical natively | Unstable (small data change → very different tree) |
| Non-parametric | Bad with imbalanced data (basic implementation) |
| Auto feature selection + importance | Sensitive to outliers |
| Quick to train | High complexity in regression |
| Built-in pruning | |

---

## 26. Random Forest

### Core idea

Random Forest = **bagging** of decision trees + **feature bagging** at each split.

Author: Leo Breiman.

Two sources of randomness:
1. **Bagging** — each tree trained on a bootstrap sample.
2. **Feature bagging** — at each split, only consider a random subset of features.

Both reduce variance + decorrelate trees.

### Out-of-Bag (OOB) error

When you bootstrap-sample, ~37% of observations don't make it into each tree's training set. Use those "out-of-bag" samples to estimate generalization error **without separate CV**.

### Extremely Randomized Trees (Extra Trees)

Like RF but at each split, draw random thresholds and pick the best. More variance reduction at slight bias cost. Faster too.

### Key RF hyperparameters

| Hyperparameter | Tip |
|---|---|
| **n_estimators** | More is better with diminishing returns |
| **max_features per split** | Default: **all features** for regression, **$\sqrt{p}$** for classification |
| **bootstrap** | Almost always True |
| **n_jobs** | RF parallelizes trivially across CPUs |
| Plus all tree hyperparameters | |

### RF — pros & cons

| ✅ Pros | ❌ Cons |
|---|---|
| Inherits tree strengths, fixes weaknesses | Not fully interpretable (many trees) |
| Lower variance → more overfitting-resistant | Many hyperparameters |
| Robust to outliers | Computationally expensive |
| Handles linear & non-linear | Not great for sparse linear problems |
| Great accuracy & bias-variance balance | |
| Built-in feature importance | |

---

## 27. ML Project Workflow

### CRISP-DM — the classic data mining cycle

**C**ross-**I**ndustry **S**tandard **P**rocess for **D**ata **M**ining:

1. **Business understanding** — what problem is worth solving?
2. **Data understanding** — what data do we have?
3. **Data preparation** — clean, transform, split.
4. **Modelling** — fit & tune candidates.
5. **Evaluation** — meets business goals?
6. **Deployment** — ship it.

Cyclical — loop back as you learn.

### MLOps

Set of practices to deploy and maintain ML models in production reliably and efficiently. Once an algorithm is ready, DS + DevOps + ML engineers transition it to production. Goal: automation, quality, monitoring, business + regulatory compliance.

### Problem statement worksheet (McKinsey style)

At project start, formalize a one-page document:
- Business problem
- Stakeholders
- Success criteria / KPIs
- Constraints (time, data, regulation)
- Out-of-scope

Becomes the contract between parties + project management input.

---

## 28. Algorithm Comparison Reference

Big picture: choosing a baseline supervised model.

| Question | Linear/Logistic | KNN | SVM | Decision Tree | Random Forest |
|---|---|---|---|---|---|
| Parametric? | ✅ Yes | ❌ No | ❌ No | ❌ No | ❌ No |
| Interpretable? | ✅ Excellent | ⚠️ Local only | ❌ Low | ✅ Excellent | ⚠️ Feature importance |
| Handles non-linear? | ❌ Only via FE | ✅ Natively | ✅ With kernels | ✅ Natively | ✅ Natively |
| Handles categorical? | ⚠️ Need encoding | ⚠️ Need encoding | ⚠️ Need encoding | ✅ Natively | ✅ Natively |
| Requires scaling? | ⚠️ For regularized | ✅ MUST | ✅ MUST | ❌ No | ❌ No |
| Handles missing? | ❌ No | ❌ No | ❌ No | ⚠️ Some impls | ⚠️ Some impls |
| Built-in feature selection? | ⚠️ With L1 | ❌ No | ❌ No | ✅ Yes | ✅ Yes (importance) |
| Speed (training) | ⚡ Very fast | ⚡ Instant (lazy) | 🐢 Slow on large data | ⚡ Fast | 🐢 Moderate |
| Speed (prediction) | ⚡ Very fast | 🐢 Slow (stores all) | ⚡ Fast (SV only) | ⚡ Very fast | ⚡ Fast |
| Probabilistic output? | ✅ Native | ⚠️ Via voting | ❌ Needs calibration | ✅ Native | ✅ Native |
| Handles high dim? | ✅ With reg | ❌ Curse | ✅ Excellent | ⚠️ Overfit risk | ✅ Yes |
| Imbalanced data? | ⚠️ Class weights | ❌ Poor | ⚠️ Class weights | ⚠️ Class weights | ⚠️ Class weights |
| Robust to outliers? | ❌ No | ⚠️ Moderate | ✅ With reg | ❌ No | ✅ Yes |

### Decision heuristic

```
START
├─ Interpretability critical? YES → Logistic/Linear, single Decision Tree
├─ Small data (<1000)?         YES → Logistic Regression, KNN small k
├─ High-dim (feats > samples)? YES → SVM, regularized regression
├─ Mostly categorical features? YES → Random Forest, gradient boosting
└─ Default: Random Forest as strong baseline
```

### Head-to-head pairings

**Linear/Logistic vs KNN**
- LR/Log: parametric, fast, can extrapolate, but limited to (close to) linear.
- KNN: non-parametric, captures any pattern, but slow at prediction, dies in high dim.
- Use LR/Log if relationship is roughly linear and you want speed + interpretation.
- Use KNN if dataset is small, dim is moderate, and functional form is unknown.

**KNN vs SVM**
- Both need scaling.
- KNN is local; SVM finds a global separator.
- KNN slow at prediction; SVM slow at training but fast at prediction.
- SVM explicitly maximizes margin → better generalization in high dim.

**Logistic Regression vs Linear SVM**
- Both linear boundaries.
- LR: log-loss, calibrated probabilities, all points influence.
- SVM: hinge loss, geometric margin, only SVs influence, more robust to non-margin outliers.
- Use LR for probabilities; use SVM for high-dim tasks needing only class labels.

**Decision Tree vs Random Forest**
- Single tree: interpretable but high variance.
- RF: many bagged trees + random feature selection → variance massively reduced.
- Use single tree if you need to draw and explain rules.
- Use RF as the default tree-based baseline.

---

## 29. Bias-Variance Movers Reference

See §10 for the full table.

Quick memorization frame — every hyperparameter has a "complexity direction":

| Increasing this... | Increases model complexity → | ↓ bias, ↑ variance |
|---|---|---|
| Tree max_depth | ✅ | overfit risk |
| SVM C | ✅ | overfit risk |
| SVM γ | ✅ | overfit risk |
| KNN 1/k | ✅ (small k = complex) | overfit risk |
| Polynomial degree | ✅ | overfit risk |
| Number of features | ✅ (if relevant) | overfit risk |
| Number of ensemble learners (RF) | ~neutral | reduces variance only |

| Increasing this... | Decreases complexity → | ↑ bias, ↓ variance |
|---|---|---|
| Regularization λ (any) | ✅ | underfit risk |
| KNN k | ✅ | underfit risk |
| Tree min_samples_leaf | ✅ | underfit risk |
| Bagging (# estimators) | ~neutral | reduces variance without adding bias |

---

## 30. Cheat Sheet

> The 10-minute pre-exam refresh.

### Fundamentals

- $Y = f(X) + \epsilon$; estimate $\hat{f}$.
- Reducible (bias) vs irreducible (noise) error.
- **Training = minimizing cost function.** Loss per-example; cost over dataset.
- Gradient descent: $\theta_{t+1} = \theta_t - \eta \nabla J(\theta_t)$.
- **Batch / SGD / Mini-batch** trade-offs.

### Models

- **Linear regression** — predict continuous y. OLS: $(X^TX)^{-1}X^Ty$. Adjusted R² penalizes extra features.
- **Logistic regression** — predict binary y via sigmoid. Cost: log-loss. Linear in logit. Multiclass via OvR or softmax. Elastic Net needs `saga` solver.
- **KNN** — lazy, non-parametric. Tune $k$, distance, weights. **MUST scale.** Curse of dimensionality.
- **SVM** — max-margin hyperplane via support vectors. Hyperparams: $C$, kernel + params. **MUST scale.** Dual → kernel trick.

### Evaluation

- **Confusion matrix**: TP top-left, TN bottom-right.
- **Accuracy misleading on imbalanced data.** Use F-beta, MCC, PR AUC.
- **ROC AUC** — balanced data. **PR AUC** — imbalanced.
- **Brier score** = MSE between probabilities and labels; proper scoring rule.
- **Log-loss** = binary cross-entropy; also proper scoring rule.
- **Bias-Variance: simple → bias↑; complex → variance↑.**
- **Overfitting** → train ≪ val. Fix: simpler model, regularization, more data, bagging.
- **Underfitting** → both errors high. Fix: more complex model, boosting.

### Training methodology

- **Train/Val/Test split** — never evaluate on training data. Stratify for imbalanced classification.
- **K-Fold CV** — most common. Stratified for imbalance. TimeSeriesSplit (expanding/rolling) for temporal.
- **Nested CV** — outer for performance, inner for tuning. No leakage.
- **validation_curve** = score vs hyperparameter. **learning_curve** = score vs training size.

### Pipeline & tricks

- **Feature scaling** — required for KNN, SVM, regularized regression, NN, PCA, K-means.
- **One-hot vs ordinal encoding** — ordinal imposes ordering!
- **Missing indicator** — informative missingness carries signal.
- **ColumnTransformer** — different transforms per column set.
- **Regularization** — L1 (feature selection), L2 (multicollinearity), Elastic Net.
- **Ridge has closed form. Lasso doesn't.**
- **Hyperparameter tuning** — grid, random (often better), Bayesian (surrogate model).
- **Imbalanced data** — class_weight='balanced' formula $w_c = n/(K \cdot n_c)$; SMOTE, ADASYN, undersampling.
- **Rebalance INSIDE CV folds via `imblearn.pipeline.Pipeline`!**
- **Ensembles** — Bagging (↓ variance, RF), Boosting (↓ bias, XGBoost), Stacking (meta-learner), Voting (hard/soft).
- **Probability calibration** — sigmoid (Platt, ≤1000 samples, S-shaped miscal) or isotonic (>1000, irregular miscal).
- **LogReg calibrated by default; RF/SVM/NB not.**
- **Drift** — data drift $P(X)$, concept drift $P(Y|X)$. Wasserstein distance for effect size.

### Formulas to memorize

- $R^2_{adj} = 1 - (1-R^2)\frac{n-1}{n-p-1}$
- Sigmoid: $\sigma(z) = \frac{1}{1 + e^{-z}}$
- Log-odds: $\log\frac{p}{1-p} = \beta^T x$
- Binary cross-entropy: $-\frac{1}{n}\sum [y_i \log\hat{p}_i + (1-y_i)\log(1-\hat{p}_i)]$
- Precision = TP/(TP+FP), Recall = TP/(TP+FN)
- F1 = 2·P·R/(P+R)
- SVM margin: $2/\|w\|$; hard: $\min \frac{1}{2}\|w\|^2$ s.t. $y_i(w^T x_i + b) \ge 1$
- Min-max: $(x-\min)/(\max-\min)$, Z-score: $(x-\mu)/\sigma$
- class_weight='balanced': $w_c = n/(K \cdot n_c)$
- Brier: $\frac{1}{N}\sum(p_i - y_i)^2$
- Gini (evaluation) = $2 \cdot \text{AUC-ROC} - 1$
- Gini (impurity) = $1 - \sum p_k^2$
- Wasserstein: earth-mover's distance, same units as feature

### Common exam traps

1. **Ridge has a closed form, Lasso does not** (L1 non-smooth at zero).
2. **`class_weight='balanced'` re-weights loss, doesn't oversample.**
3. **Min-max = [0,1], NOT mean 0 / std 1** (that's z-score).
4. **L1 gives sparsity, L2 shrinks smoothly** — never the reverse.
5. **Hinge loss = SVM, log-loss = logistic regression** — never swapped.
6. **ROC AUC misleading on imbalanced; use PR AUC.**
7. **Rebalance inside CV folds via imblearn Pipeline.**
8. **Elastic Net needs `saga` solver.**
9. **RFE removes least important features iteratively, not by one-shot correlation.**
10. **Variance Threshold does NOT use the target** — it's a data-cleaning filter.
11. **Dual SVM enables kernel trick; primal doesn't need to.**
12. **`cross_val_score` returns an array, not a float.**
13. **Data drift = P(X); concept drift = P(Y|X).**
14. **F1 is harmonic mean of P and R, not arithmetic.**
15. **Multi-collinearity inflates coefficient variance, doesn't affect $\hat{y}$ much.**

---

## How to use v2 for retake prep

**Primary study source** — read cover to cover across 2-3 sessions. Target ~8 hours of active reading (1,600 lines / ~200 lines per hour of engaged study).

**Cross-reference with:**
- `[[ML1_Past_Exam_Practice]]` — after each major section, attempt related questions from Groups A-D
- `[[ML1_Worked_Examples]]` — for §7-9 (metrics), §10 (bias-variance), §13-14 (KNN, SVM by hand)
- `[[ML1_Derivations]]` — for §4 (OLS), §5 (logistic MLE), §10 (bias-variance decomposition), §14 (SVM margin)
- `[[ML1_Code_CheatSheet]]` — for any "which sklearn function does X" question
- `[[ML1_Exam_Day_QuickRef]]` — on the morning of the retake, skim only this

Good luck, Ondřej. Version 2 has everything you need. 🍀
