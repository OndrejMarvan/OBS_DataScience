---
title: ML1 - Comparison Tables & Decision Guides
course: 2400-DS1ML1
tags: [machine-learning, reference, comparison, midterm]
related: "[[ML1_Midterm_Study_Notes]]"
---

# ML1 — Comparison Tables & Decision Guides

> **Why this note exists:** Theoretical exams love "compare and contrast" and "which would you use for X" questions. This note is structured as side-by-side comparisons that the conceptual study guide doesn't make directly visible.

## Contents

- [[#1 Algorithm vs Algorithm]]
- [[#2 Metric vs Metric — When to Use Which]]
- [[#3 Cross-Validation Type vs Use Case]]
- [[#4 Feature Scaling — Which Methods Need It]]
- [[#5 Regularization Comparison]]
- [[#6 Hyperparameter Search Methods]]
- [[#7 Imbalance Handling Techniques]]
- [[#8 Encoding Categorical Variables]]
- [[#9 Imputation Method by Variable Type]]
- [[#10 Overfitting vs Underfitting Diagnosis]]
- [[#11 Probability Calibration by Model]]
- [[#12 Bias vs Variance Movers]]
- [[#13 Ensemble Method Decision Guide]]
- [[#14 Loss Function vs Evaluation Metric]]

---

## 1. Algorithm vs Algorithm

### Big picture: choosing a baseline supervised model

| Question | Linear/Logistic Reg | KNN | SVM | Decision Tree | Random Forest |
|---|---|---|---|---|---|
| Parametric? | ✅ Yes | ❌ No | ❌ No (basic) | ❌ No | ❌ No |
| Interpretable? | ✅ Excellent | ⚠️ Local only | ❌ Low | ✅ Excellent (single) | ⚠️ Feature importance only |
| Handles non-linear? | ❌ Only via FE | ✅ Natively | ✅ With kernels | ✅ Natively | ✅ Natively |
| Handles categorical? | ⚠️ Need encoding | ⚠️ Need encoding | ⚠️ Need encoding | ✅ Natively | ✅ Natively |
| Requires scaling? | ⚠️ For regularized | ✅ MUST | ✅ MUST | ❌ No | ❌ No |
| Handles missing? | ❌ No | ❌ No | ❌ No | ⚠️ Some impls | ⚠️ Some impls |
| Built-in feature selection? | ⚠️ Only with L1 | ❌ No | ❌ No | ✅ Yes | ✅ Yes (importance) |
| Speed (training) | ⚡ Very fast | ⚡ Instant (lazy) | 🐢 Slow on large data | ⚡ Fast | 🐢 Moderate |
| Speed (prediction) | ⚡ Very fast | 🐢 Slow (stores all) | ⚡ Fast (SV only) | ⚡ Very fast | ⚡ Fast |
| Probabilistic output? | ✅ Native | ⚠️ Via voting | ❌ Needs calibration | ✅ Native | ✅ Native |
| Handles high dim? | ✅ Yes (with reg.) | ❌ Curse | ✅ Excellent | ⚠️ Overfit risk | ✅ Yes |
| Imbalanced data? | ⚠️ Class weights | ❌ Poor | ⚠️ Class weights | ⚠️ Class weights | ⚠️ Class weights |
| Robust to outliers? | ❌ No | ⚠️ Moderate | ✅ With reg. | ❌ No | ✅ Yes |

### "When to use which" decision tree

```
START
├─ Is interpretability critical for stakeholders?
│   ├─ YES → Logistic/Linear Regression, single Decision Tree
│   └─ NO → continue
├─ Is the dataset very small (<1000 obs)?
│   ├─ YES → Logistic Regression, KNN with small k
│   └─ NO → continue
├─ Is the dataset very high-dimensional (#features > #samples)?
│   ├─ YES → SVM (linear or RBF), regularized regression
│   └─ NO → continue
├─ Are features predominantly categorical?
│   ├─ YES → Random Forest, gradient boosted trees
│   └─ NO → continue
└─ Default: try Random Forest first as a strong baseline
```

### Specific head-to-heads

**Linear/Logistic Regression vs KNN**
- LR/Log: parametric, fast, can extrapolate, but limited to (close to) linear relationships.
- KNN: non-parametric, captures any pattern, but slow at prediction time and dies in high dimensions.
- **Use LR/Log if** the relationship is roughly linear and you want speed + interpretation.
- **Use KNN if** the dataset is small, dimensionality is low/moderate, and you have no idea about the functional form.

**KNN vs SVM**
- Both rely on distances → both need scaling.
- KNN is purely local; SVM finds a global separator.
- KNN is slow at prediction; SVM is slow at training but fast at prediction.
- KNN has no notion of margin; SVM explicitly maximizes margin → better generalization in high dim.
- **Use KNN for** quick prototypes on small data, recommendation-style problems.
- **Use SVM for** high-dim problems with clear class separation, especially when #features > #samples.

**Logistic Regression vs SVM (with linear kernel)**
- Both produce linear decision boundaries.
- LR optimizes log-loss → gives calibrated probabilities natively.
- SVM optimizes hinge loss → gives geometric margin but no native probabilities.
- LR is influenced by all points; SVM only by support vectors → SVM more robust to non-margin outliers.
- **Use LR if** you need probabilities directly.
- **Use SVM if** you only need the class label and the data is high-dim.

**Decision Tree vs Random Forest**
- Single tree is interpretable but high variance — small data change → very different tree.
- RF is many bagged trees with random feature selection → variance reduced massively.
- RF nearly always outperforms single trees on predictive metrics.
- **Use single tree if** you really need to draw and explain the decision rules.
- **Use RF as** the default tree-based baseline. Almost always.

---

## 2. Metric vs Metric — When to Use Which

### Classification metrics

| Metric | Best for... | Avoid when... |
|---|---|---|
| **Accuracy** | Balanced classes, all errors equal | Imbalanced data (it lies) |
| **Precision** | False positives are costly (spam filter, recommendation) | Missing positives is costly |
| **Recall** | False negatives are costly (cancer screening, fraud) | False alarms are costly |
| **F1** | Balanced importance of P and R, balanced data | Heavy imbalance — F-beta or PR AUC better |
| **F-beta (β > 1)** | Recall matters more | Precision matters more |
| **F-beta (β < 1)** | Precision matters more | Recall matters more |
| **MCC (Matthews Corr.)** | Severe imbalance, want single robust score | Multi-class (limited support) |
| **ROC AUC** | Ranking matters, balanced or moderate imbalance | Severe imbalance, threshold matters more than ranking |
| **PR AUC** | Severe imbalance, communicating precision-recall trade-off | Negative class is the focus |
| **Log-loss** | Probabilities matter (calibration); training neural nets | Only class labels matter |
| **Brier score** | Probability calibration assessment | Only ranking matters |

### Regression metrics

| Metric | Best for... | Avoid when... |
|---|---|---|
| **MSE** | Mathematically friendly (smooth), penalizes large errors | Outliers dominate |
| **RMSE** | Same units as target, penalizes large errors | Outliers, when relative errors matter |
| **MAE** | Robustness to outliers, intuitive average error | Need to penalize big errors heavily |
| **MAPE** | Comparing across scales (% error) | Target values near zero (division blowup) |
| **sMAPE** | MAPE but with bounded range and symmetric | Same issues as MAPE near zero |
| **MSLE** | Under-prediction is worse than over-prediction; positive targets only | Negative targets, symmetric errors |
| **R²** | Interpretable as "% variance explained" | Comparing across different datasets |
| **Adjusted R²** | Comparing models with different #features on same data | Single model evaluation |
| **MedAE** | Extreme outlier robustness | When mean errors matter |

---

## 3. Cross-Validation Type vs Use Case

| CV Type | Use when... | Avoid when... |
|---|---|---|
| **Hold-out (single split)** | Quick baselines, very large datasets | Small data, need robust estimate |
| **K-Fold** | Standard cross-sectional data with no time component | Time series, severe imbalance |
| **Stratified K-Fold** | Classification with **imbalanced** classes | Regression, time series |
| **Leave-One-Out (LOO)** | Very small datasets (<100 obs), expensive label collection | Anything bigger — too expensive |
| **Leave-p-Out** | Niche statistical applications | Practical ML — usually overkill |
| **Repeated K-Fold** | Need more stable performance estimate, computation budget allows | Time-pressured workflows |
| **Nested K-Fold** | Honest performance estimate WHEN hyperparameter tuning | When you don't need to tune |
| **Time Series Split** | Time-ordered data (TROPOMI satellite, prices, returns) | Cross-sectional data |
| **Group K-Fold** | Multiple obs per entity (patients, customers) | Independent observations |

### The "do not shuffle" rule

For time series, **NEVER use standard K-fold** — it leaks future information into past training folds. Use forward-chaining splits (each train fold ends before its validation fold begins).

---

## 4. Feature Scaling — Which Methods Need It

| Algorithm | Needs scaling? | Why? |
|---|---|---|
| **OLS Linear Regression** | ❌ No (math invariant) | Coefficients absorb the scale |
| **Ridge / Lasso / Elastic Net** | ✅ YES | Penalty term treats all coefs equally; without scaling, large-scale features get penalized less |
| **Logistic Regression (vanilla)** | ⚠️ Helps convergence | Gradient descent converges faster |
| **Logistic Regression (regularized)** | ✅ YES | Same as Ridge/Lasso |
| **KNN** | ✅ MUST | Distance-based — large-scale features dominate |
| **SVM (any kernel)** | ✅ MUST | Distance/kernel-based; RBF gamma is scale-sensitive |
| **Decision Tree** | ❌ No | Splits are scale-invariant (just thresholds) |
| **Random Forest** | ❌ No | Same as tree |
| **Gradient Boosted Trees (XGBoost etc.)** | ❌ No | Same as tree |
| **Neural Networks** | ✅ YES | Gradient descent stability + activation function behavior |
| **K-means clustering** | ✅ YES | Distance-based |
| **PCA** | ✅ YES | Variance-based; large-scale features dominate principal components |
| **Naive Bayes (Gaussian)** | ❌ No | Each feature has its own distribution |

### Choosing the right scaler

| Scaler | Use when... |
|---|---|
| **StandardScaler (z-score)** | No extreme outliers; default choice |
| **MinMaxScaler** | Want bounded [0,1] range, feature is roughly uniform |
| **RobustScaler** | Outliers present — uses median + IQR instead of mean + std |
| **QuantileTransformer** | Want uniform or normal output distribution regardless of input |
| **PowerTransformer (Yeo-Johnson)** | Reduce skewness, approximately normal output |

---

## 5. Regularization Comparison

| | L1 (Lasso) | L2 (Ridge) | Elastic Net |
|---|---|---|---|
| Penalty | $\sum \|\theta_j\|$ | $\sum \theta_j^2$ | $\alpha \cdot L_1 + (1-\alpha) \cdot L_2$ |
| Coefficient shrinkage | Drives to exact 0 | Shrinks toward 0 | Both |
| Feature selection | ✅ Yes (auto) | ❌ No | ✅ Partial |
| Handles multicollinearity | ⚠️ Poorly (picks one randomly) | ✅ Well | ✅ Well |
| Solution path | Sparse | Dense | Mixed |
| Convexity | Convex (not smooth at 0) | Smooth & convex | Convex |
| Optimization | Coordinate descent, LARS | Closed form available | Coordinate descent |
| When features > samples | ⚠️ Selects at most n features | ✅ Works | ✅ Works |

### Decision rule

- **Lasso** — many features, expect most are irrelevant, want automatic feature selection.
- **Ridge** — features all expected to matter (you don't want any dropped), multicollinearity present.
- **Elastic Net** — when in doubt; or correlated groups of features (Lasso would pick one arbitrarily; Elastic Net keeps the group).

---

## 6. Hyperparameter Search Methods

| Method | How it works | Pros | Cons | When to use |
|---|---|---|---|---|
| **Grid Search** | Try all combinations from defined grid | Exhaustive, reproducible | Curse of dim, wastes compute on bad regions | Small hyperparameter space, want guaranteed coverage |
| **Random Search** | Sample N random combinations | Better than grid in high dim, more efficient with budget | Doesn't learn from past trials | Default choice in most projects |
| **Bayesian Optimization** | Build probabilistic model; balance explore/exploit | Most sample-efficient | Implementation complexity, surrogate model overhead | Expensive evaluations (deep models, large data) |
| **Halving / Successive Halving** | Tournament: many candidates briefly, survivors get more compute | Very efficient | Risk of pruning slow-starters | Many candidates, tight budget |
| **Hyperband** | Multi-fidelity bandit allocation | Strong on neural nets | Less mature in non-DL ML | Neural net hyperparameter tuning |

### Practical workflow

1. Start with **random search** over a wide range (50–100 trials).
2. Identify the promising region from results.
3. Switch to **grid search** in that smaller region, or run **Bayesian** for fine-tuning.
4. Always combine with **proper CV** (Stratified K-Fold for classification).

---

## 7. Imbalance Handling Techniques

| Approach | Mechanism | Pros | Cons |
|---|---|---|---|
| **Class weights** | Penalize errors on minority class more in loss function | No data modification, model handles it | Doesn't help feature-space coverage of minority class |
| **Random undersampling** | Remove majority examples randomly | Fast, simple, often surprisingly effective | Loses information |
| **Tomek links** | Remove majority points near minority points to clarify boundary | Cleaner decision boundary | Modest reduction in imbalance |
| **Edited NN (ENN)** | Remove majority points whose neighbors disagree | Smoother boundary | Aggressive; may over-prune |
| **Random oversampling** | Duplicate minority examples | Simple, no info loss | Doesn't add new info — overfits to existing minority points |
| **SMOTE** | Synthesize minority points along lines between existing minority points and their NN | Adds genuine variability to minority class | Can create unrealistic points in overlap regions; only works in low-dim |
| **Borderline SMOTE** | Focus synthesis near the decision boundary | More informative synthetic points | Same low-dim restriction |
| **SVM SMOTE** | Use SVM support vectors to guide synthesis | Focuses on hard cases | Computationally heavier |
| **ADASYN** | Adaptive — generate more synthetic samples for harder-to-learn minority points | Tackles the harder cases | More noise-sensitive than SMOTE |
| **SMOTETomek** | SMOTE oversample + Tomek clean up | Combines benefits | More hyperparameters |
| **SMOTEENN** | SMOTE oversample + ENN clean up | Aggressive cleaning | Can over-remove |

### Decision rule

| Severity & data | Recommendation |
|---|---|
| Mild imbalance (1:3 to 1:5) | Class weights only — often sufficient |
| Moderate imbalance (1:5 to 1:20) | Class weights + random undersampling or SMOTE |
| Severe imbalance (>1:20) | SMOTE variants + Tomek/ENN cleaning, combined with class weights |
| Very high-dim data | Class weights only (SMOTE doesn't work well in high dim) |
| Cost-sensitive problem | Class weights with custom cost ratio matched to business cost |

### ⚠️ The cardinal rule

> **Rebalance INSIDE each CV fold's training set, never on the whole dataset before splitting.** Otherwise validation/test sets contain synthetic relatives of training points → inflated scores.

---

## 8. Encoding Categorical Variables

| Method | What it does | Best for... | Avoid when... |
|---|---|---|---|
| **One-hot encoding** | $k$ levels → $k$ binary columns (or $k-1$ if drop_first) | Nominal categories, linear models, low cardinality | Very high cardinality (cardinality explosion) |
| **Ordinal encoding** | $k$ levels → integers 0, 1, …, $k-1$ | True ordinal (rank, education level) | Nominal categories (imposes false order) |
| **Target encoding** | Replace category with mean (or other stat) of target for that category | High cardinality, tree models | Tiny categories — overfit risk; **MUST do inside CV** |
| **CatBoost encoder** | Target encoding with ordered statistics to reduce leakage | Many high-cardinality features | Computationally heavier |
| **WoE (Weight of Evidence)** | $\log(P(\text{good})/P(\text{bad}))$ per category | Credit risk, binary classification with strong domain context | Multi-class problems |
| **Count / Frequency encoding** | Replace category with its count | When frequency itself is informative | Categories with similar counts but different effects |
| **Hashing** | Hash category to fixed number of buckets | Extremely high cardinality, online learning | When collisions matter |

### Cardinality rule of thumb

- **< 10 levels** → one-hot.
- **10–50 levels** → one-hot if linear model, or target/CatBoost encoder if tree model.
- **> 50 levels** → target/CatBoost encoder or hashing.

---

## 9. Imputation Method by Variable Type

| Variable type | Quick win | Better | Best (multivariate) |
|---|---|---|---|
| **Continuous** | Mean or median (global) | Mean/median by subgroup | KNN imputation, MICE |
| **Categorical** | Mode (global) | Add "missing" as new category | KNN imputation, MICE |
| **Time series** | Last-observed-carried-forward (LOCF) | Linear interpolation | Spline interpolation, STL decomposition |
| **Binary** | Mode | Add "missing" indicator + mode | MICE with logistic |

### When to skip imputation

- **Algorithm handles it natively:** XGBoost, LightGBM, CatBoost — they learn the best direction for missing values during tree splits.
- **Missingness is informative:** create a `missing_indicator` column AND impute, so the model knows.

### When to drop instead

- **Column with > ~50% missing AND not crucial** → drop the column.
- **Row with critical missing fields AND small share** → drop the row.
- **Otherwise, impute.**

---

## 10. Overfitting vs Underfitting Diagnosis

| Symptom | Likely cause | Action |
|---|---|---|
| Train error very low, val error much higher | Overfitting (high variance) | Simpler model, more regularization, more data, bagging |
| Train error and val error both high and close | Underfitting (high bias) | More complex model, more features, less regularization, boosting |
| Train error decreases, val error increases | Overfitting in progress | Early stopping, regularization |
| Train and val error both plateau at moderate level | Data limit reached or wrong model class | More features, different algorithm, more diverse data |
| Train error decreases but val is noisy / unstable | High variance | More data, repeat CV with different seeds, simpler model |

### Learning curve patterns (visual ID)

| Pattern | Diagnosis |
|---|---|
| Both curves converge at low error | ✅ Good fit |
| Both curves plateau at high error, close together | Underfit |
| Train near 0, val high and rising | Overfit |
| Both curves still descending steeply at end of data | Need more data |

---

## 11. Probability Calibration by Model

| Model | Calibration | Why |
|---|---|---|
| **Logistic regression** | ✅ Naturally calibrated | Optimizes log-loss → MLE on probabilities |
| **Naive Bayes** | ❌ Over-confident, pushes to 0/1 | Independence assumption inflates likelihoods |
| **Random Forest** | ❌ Peaks at 0.2 and 0.9, rarely extreme | Averaging trees pulls extreme values toward middle |
| **SVM** | ❌ Strong sigmoid shape (raw scores aren't probabilities) | Doesn't optimize for probabilities at all |
| **KNN** | ⚠️ Granular ($k+1$ possible values) | Just neighbor counts; depends heavily on $k$ |
| **Gradient Boosting** | ⚠️ Moderately well calibrated | Closer to LR than RF, but check anyway |
| **Neural Network (sigmoid out)** | ⚠️ Depends on training | Often over-confident due to deep model effects |

### Calibration methods

| Method | When | How |
|---|---|---|
| **Platt (sigmoid) scaling** | When raw scores are sigmoid-shaped (SVM, NN) | Fit logistic regression on raw scores → probability |
| **Isotonic regression** | Non-parametric, more flexible, needs more data | Fit monotonic mapping from raw score to probability |

> Always fit calibrator on a **separate validation set or in nested CV** to avoid leakage.

---

## 12. Bias vs Variance Movers

| Action | Bias | Variance |
|---|---|---|
| Increase model complexity (deeper tree, more features) | ↓ | ↑ |
| Decrease model complexity | ↑ | ↓ |
| Add more training data | – | ↓ |
| Add regularization (L1/L2) | ↑ | ↓ |
| Remove regularization | ↓ | ↑ |
| Bagging (Random Forest) | – | ↓↓ |
| Boosting (XGBoost) | ↓↓ | ↓ (modestly) |
| Use more features | ↓ (if relevant) | ↑ |
| Use fewer features | ↑ | ↓ |
| Increase $k$ in KNN | ↑ | ↓ |
| Decrease $k$ in KNN | ↓ | ↑ |
| Increase $C$ in SVM | ↓ | ↑ |
| Decrease $C$ in SVM | ↑ | ↓ |
| Increase $\gamma$ in RBF kernel | ↓ (locally) | ↑ |
| Decrease tree max_depth | ↑ | ↓ |
| Increase tree min_samples_leaf | ↑ | ↓ |

> "–" = roughly unchanged. Bagging reduces variance with no bias change. Boosting reduces bias primarily.

---

## 13. Ensemble Method Decision Guide

| Method | Goal | How | Example | When to use |
|---|---|---|---|---|
| **Bagging** | Reduce variance | Train models on bootstrap samples, average predictions | Random Forest, Extra Trees | High-variance base learners (deep trees) |
| **Boosting** | Reduce bias (and variance) | Train sequentially, each model corrects previous errors | AdaBoost, XGBoost, LightGBM, CatBoost | When a single weak learner is too biased |
| **Stacking** | Combine diverse perspectives | Base models → meta-learner uses their predictions as features | Custom (any combination) | When you have several decent but different models |
| **Voting** | Combine diverse models simply | Average probabilities (soft) or majority vote (hard) | sklearn VotingClassifier | Quick win when several models perform similarly |

### Bagging vs Boosting head-to-head

| | Bagging | Boosting |
|---|---|---|
| Training | Parallel (independent models) | Sequential (each depends on previous) |
| Aim | Reduce variance | Reduce bias |
| Base learner | Should be high-variance (deep trees) | Should be high-bias (shallow trees) |
| Overfit risk | Low | Higher (need regularization) |
| Sensitivity to noise | Low | Higher (boosts focus on hard/noisy examples) |
| Speed (training) | Faster (parallel) | Slower (sequential) |

---

## 14. Loss Function vs Evaluation Metric

> A common source of confusion. They are NOT the same.

| | Loss function | Evaluation metric |
|---|---|---|
| Purpose | Train the model (find optimal parameters) | Judge the model (compare or report) |
| Must be differentiable? | ✅ Yes (for gradient methods) | ❌ No |
| Must be convex? | ✅ Preferred (guarantees global min) | ❌ No |
| Examples for regression | MSE, MAE | RMSE, MAPE, R², MedAE |
| Examples for classification | Log-loss, hinge loss | Accuracy, F1, ROC AUC, MCC |
| Multiple per model | Usually 1 | Always evaluate on several |

### Common pairings

| Model | Trains on... | Often evaluated with... |
|---|---|---|
| Linear regression | MSE (RSS) | RMSE, R², MAE |
| Ridge regression | MSE + L2 | RMSE, R² |
| Lasso | MSE + L1 | RMSE, R², #non-zero features |
| Logistic regression | Log-loss | ROC AUC, F1, log-loss |
| SVM | Hinge loss + L2 | Accuracy, F1, ROC AUC (after calibration) |
| Decision tree (classification) | Gini or entropy (impurity) | Accuracy, F1, ROC AUC |
| Decision tree (regression) | MSE or MAE | RMSE, R² |
| Random forest | Same as base tree | Same as base tree |

### Why they differ

- Loss must be optimizable; many useful metrics (F1, MCC, AUC) aren't smoothly differentiable.
- Evaluation should match the **business cost**; loss is constrained by **math friendliness**.
- Example: in fraud detection, you train logistic regression on log-loss (smooth) but evaluate on PR AUC + F2 (matches the business priority of catching positives).

---

## How to use this note for the exam

1. **Quiz yourself on the comparisons.** Cover one column, predict it from the other. e.g., "Why does KNN need scaling but trees don't?"
2. **Look for the trade-off pattern** in every question. ML1 exams reward "X improves A but worsens B" framing.
3. **Memorize the must-scale list** in §4 — this is high-likelihood for a true/false or short answer question.
4. **Know your bias-variance movers** (§12) — almost always a question testing "what happens if you increase $k$ in KNN".
5. **Know which metric for which scenario** (§2) — likely a scenario question.
