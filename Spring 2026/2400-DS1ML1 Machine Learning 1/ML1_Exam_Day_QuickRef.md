---
title: ML1 - Exam Day Quick Reference
course: 2400-DS1ML1
midterm_date: 2026-05-15
tags: [machine-learning, cheatsheet, midterm, exam-day]
related: ["[[ML1_Midterm_Study_Notes]]", "[[ML1_Derivations]]", "[[ML1_Worked_Examples]]", "[[ML1_Comparison_Tables]]"]
---

# ML1 — Exam Day Quick Reference

> **The 30-minute pre-exam refresh.** Print this if allowed, or skim once on the train.

## ⭐ Formulas you must know cold

### Foundations

- **Model assumption:** $Y = f(X) + \epsilon$, where $E[\epsilon] = 0$
- **Estimation:** $\hat{Y} = \hat{f}(X)$; Error = reducible (bias) + irreducible (noise)
- **Bias-variance:** $\text{Error} = \text{Bias}^2 + \text{Variance} + \sigma^2$
- **Gradient descent update:** $\theta_{t+1} = \theta_t - \eta \nabla J(\theta_t)$

### Linear regression

- **OLS closed form:** $\hat{\beta} = (X^T X)^{-1} X^T y$
- **Cost (MSE):** $J = \frac{1}{n}\sum (y_i - \hat{y}_i)^2$
- **Adjusted R²:** $R^2_{adj} = 1 - (1 - R^2)\frac{n-1}{n-p-1}$

### Logistic regression

- **Sigmoid:** $\sigma(z) = \frac{1}{1 + e^{-z}}$
- **Sigmoid derivative:** $\sigma'(z) = \sigma(z)(1 - \sigma(z))$
- **Log-odds (logit):** $\log\frac{p}{1-p} = \beta^T x$
- **Binary cross-entropy:** $J = -\frac{1}{n}\sum [y_i \log \hat{p}_i + (1-y_i)\log(1-\hat{p}_i)]$
- **Softmax:** $P(y=j|x) = \frac{e^{z_j}}{\sum_l e^{z_l}}$

### Classification metrics

- **Accuracy** = $\frac{TP + TN}{\text{total}}$
- **Precision (PPV)** = $\frac{TP}{TP + FP}$
- **Recall (TPR, Sensitivity)** = $\frac{TP}{TP + FN}$
- **Specificity (TNR)** = $\frac{TN}{TN + FP}$
- **F1** = $\frac{2 \cdot P \cdot R}{P + R}$
- **F-beta** = $(1 + \beta^2)\frac{P \cdot R}{\beta^2 P + R}$
- **FPR (Type I error)** = $\frac{FP}{FP + TN}$
- **FNR (Type II error)** = $\frac{FN}{FN + TP}$

### Regression metrics

- **MSE** = $\frac{1}{n}\sum (y_i - \hat{y}_i)^2$
- **RMSE** = $\sqrt{\text{MSE}}$
- **MAE** = $\frac{1}{n}\sum |y_i - \hat{y}_i|$
- **MAPE** = $\frac{1}{n}\sum |\frac{y_i - \hat{y}_i}{y_i}|$
- **R²** = $1 - \frac{\sum(y_i - \hat{y}_i)^2}{\sum(y_i - \bar{y})^2}$

### Distance metrics

- **Euclidean:** $\sqrt{\sum (x_i - y_i)^2}$ (Minkowski $p=2$)
- **Manhattan:** $\sum |x_i - y_i|$ (Minkowski $p=1$)
- **Chebyshev:** $\max_i |x_i - y_i|$ (Minkowski $p\to\infty$)

### Scaling

- **Min-max:** $z = \frac{x - \min}{\max - \min}$ → $[0, 1]$
- **Z-score:** $z = \frac{x - \mu}{\sigma}$ → mean 0, std 1

### SVM

- **Margin width:** $\frac{2}{\|w\|}$
- **Hard margin:** $\min \frac{1}{2}\|w\|^2$ s.t. $y_i(w^T x_i + b) \ge 1$
- **Soft margin:** $\min \frac{1}{2}\|w\|^2 + C \sum \xi_i$
- **Decision function:** $f(x) = w^T x + b$; predict sign

### Regularization

- **L1 (Lasso):** $\lambda \sum |\theta_j|$ → sparse, feature selection
- **L2 (Ridge):** $\lambda \sum \theta_j^2$ → shrinks, multicollinearity
- **Elastic Net:** $\alpha \cdot L_1 + (1-\alpha) \cdot L_2$

### Decision Trees

- **Gini:** $1 - \sum p_j^2$
- **Entropy:** $-\sum p_j \log_2 p_j$
- **Information Gain:** $H(\text{parent}) - \sum_c \frac{|c|}{|\text{parent}|} H(c)$

---

## ⭐ Rules you must know cold

### Always scale before...
- KNN, SVM (any kernel), regularized regression (Ridge/Lasso/Elastic Net), neural networks, K-means, PCA

### Never scale (no benefit)...
- Decision trees, random forests, gradient boosted trees, Naive Bayes

### Accuracy is bad when...
- Classes are imbalanced. Use F-beta, MCC, or PR AUC instead.

### ROC AUC is bad when...
- Severe class imbalance. Use PR AUC instead.

### CV gotchas...
- Stratify K-fold for imbalanced classification.
- Never shuffle time series — use forward-chaining splits.
- **Rebalance INSIDE each CV fold's training set** — not before splitting!
- Same goes for scalers, imputers, target encoders — fit on train fold only.

### Bias-variance triggers

| Increase complexity | ↓ bias, ↑ variance |
| Decrease complexity | ↑ bias, ↓ variance |
| Add data | ↓ variance |
| Regularize | ↑ bias, ↓ variance |
| Bagging | ↓↓ variance |
| Boosting | ↓ bias |

### KNN specifics
- Small $k$ → low bias, high variance (overfit)
- Large $k$ → high bias, low variance
- Rule of thumb: start near $\sqrt{n}$, tune with CV

### SVM specifics
- High $C$ → narrow margin, hard to misclassify, can overfit (high variance)
- Low $C$ → wide margin, allows mistakes, can underfit (high bias)
- High $\gamma$ in RBF → localized, can overfit
- Low $\gamma$ → broad influence, smoother boundary

---

## ⭐ "Which X for Y" cheat answers

### Which metric?

| Scenario | Metric |
|---|---|
| Balanced classification | Accuracy, F1, ROC AUC |
| Imbalanced classification | F-beta (β>1 if recall critical), PR AUC, MCC |
| Probability calibration | Log-loss, Brier score |
| Cost of FP >> FN | Precision, F-beta with β<1 |
| Cost of FN >> FP | Recall, F-beta with β>1 |
| Regression, no outliers | RMSE, R² |
| Regression, outliers | MAE, MedAE |
| % errors across scales | MAPE / sMAPE |
| Under-prediction worse | MSLE |

### Which CV?

| Data shape | CV |
|---|---|
| Cross-sectional, balanced | K-Fold |
| Cross-sectional, imbalanced | Stratified K-Fold |
| Time series | Time Series Split (forward chaining) |
| Grouped (patients, customers) | Group K-Fold |
| Need honest estimate w/ tuning | Nested CV |
| Tiny dataset (<100) | LOO or LOOCV |

### Which encoder?

| Variable | Encoder |
|---|---|
| Nominal, <10 levels | One-hot |
| Nominal, 10-50 levels, linear model | One-hot |
| Nominal, 10-50 levels, tree model | Target / CatBoost encoder |
| Nominal, >50 levels | Target / CatBoost encoder or Hashing |
| Truly ordinal (rank, education) | Ordinal encoder |
| Credit risk, binary y | WoE |

### Which model first?

| Need | Default choice |
|---|---|
| Interpretability priority | Logistic Regression |
| Best baseline accuracy | Random Forest |
| Tiny data, smooth relationship | Linear/Logistic Regression |
| High-dim (#features > #samples) | SVM, regularized regression |
| Categorical features dominate | Random Forest, gradient boosting |
| Need probabilities | Logistic Regression, calibrated RF |

---

## ⭐ Glossary of synonyms (common gotcha)

| Concept | Synonyms |
|---|---|
| Target | Dependent, endogenous, output, regressand, response, label |
| Feature | Independent, exogenous, explanatory, predictor, regressor, attribute |
| Example | Entity, row, observation, instance, sample, data point |
| Recall | True Positive Rate, Sensitivity, Hit Rate |
| Specificity | True Negative Rate |
| Precision | Positive Predictive Value (PPV) |
| FPR | Type I error, False alarm rate |
| FNR | Type II error, Miss rate |
| Hyperparameter | Tuning parameter, meta-parameter |
| Cost function | Objective function, loss (used loosely), criterion |
| Decision boundary | Separating surface, classifier boundary |

---

## ⭐ Confusion matrix template (memorize the layout!)

|  | Predicted Positive | Predicted Negative |
|---|---|---|
| **Actual Positive** | **TP** | **FN** (Type II) |
| **Actual Negative** | **FP** (Type I) | **TN** |

From which:
- Recall splits the **actual positive** row: $\frac{TP}{TP+FN}$
- Specificity splits the **actual negative** row: $\frac{TN}{TN+FP}$
- Precision splits the **predicted positive** column: $\frac{TP}{TP+FP}$
- NPV splits the **predicted negative** column: $\frac{TN}{TN+FN}$

Mnemonic: **"-PV"** = column split. **"recall/specificity"** = row split.

---

## ⭐ Exam strategy

### Time allocation (assume 90 min)

- **5 min** — Read entire exam, mark hardest questions.
- **70 min** — Work questions in order of confidence. Easy → medium → hard.
- **10 min** — Hard questions. Even partial work earns points.
- **5 min** — Final scan: units, sign errors, labels.

### How to handle a derivation question

1. State the setup (what's given, what's to find).
2. State key assumptions used (e.g., linearity, no perfect multicollinearity).
3. Show **every step**, even algebraic ones. Markers love partial credit.
4. Box the final result.
5. Add one sentence of interpretation.

### How to handle a "compare X vs Y" question

Use this structure:
1. **One-line definition of each.**
2. **What they share** (one sentence).
3. **3 key differences** in a clear table or numbered list.
4. **When to use which** (one sentence each).

### How to handle a "scenario" question

1. **Identify the problem type** (classification/regression, balanced/imbalanced, etc.).
2. **Recall the cost structure** (asymmetric? what's expensive?).
3. **Pick the metric.** Justify in one sentence.
4. **Pick the algorithm.** Justify in one sentence.
5. **Note pitfalls** (e.g., "need to scale features", "rebalance inside CV").

### Things to avoid

- ❌ Writing a wall of text. Use bullets, tables, equations.
- ❌ Skipping units (e.g., "0.971 bits", "5 trees", "23%").
- ❌ Forgetting to interpret the result.
- ❌ Claiming a model "is best" without context.
- ❌ Saying "accuracy is good" without checking class balance.

---

## ⭐ Common "trap" questions and answers

**Q: A model has 99% accuracy on a medical screening test. Is it good?**
A: Probably not — likely an imbalanced dataset (1% disease prevalence). Check recall, precision, and PR AUC. A "predict everyone is healthy" baseline could match this.

**Q: Why does KNN work poorly in high dimensions?**
A: Curse of dimensionality — in high-dim spaces, points become roughly equidistant from each other. The "nearest neighbor" loses meaning. The volume needed to capture any non-trivial fraction of the data covers most of the feature range.

**Q: Why must we use stratified CV for imbalanced classification?**
A: Standard K-fold might create folds where the minority class is severely under-represented or even absent → can't evaluate the model on the minority class in those folds. Stratification preserves class proportions in each fold.

**Q: Why is SMOTE applied INSIDE the CV fold and not before?**
A: SMOTE synthesizes minority points by interpolating between real minority points and their neighbors. If applied before splitting, the validation fold ends up containing synthetic points whose "parents" are in the training fold → optimistically biased evaluation.

**Q: Logistic regression vs SVM with linear kernel — what's the difference?**
A: Both produce linear boundaries. LR minimizes log-loss (probability-based, all points influence); SVM minimizes hinge loss (margin-based, only support vectors influence). LR is naturally calibrated; SVM needs Platt/isotonic calibration. SVM is more robust to non-margin outliers.

**Q: Why does adding regularization to OLS require scaling features?**
A: The L1/L2 penalty $\sum |\theta_j|$ or $\sum \theta_j^2$ treats all coefficients equally. Without scaling, a feature with a large numerical range gets a small coefficient that escapes the penalty, while a small-range feature gets a large coefficient that is heavily penalized. The result depends on units, which is meaningless.

**Q: Random Forest reduces variance — how?**
A: Each tree is trained on a bootstrap sample (different data) and uses a random subset of features at each split (different features). This decorrelates the trees. Averaging $n$ uncorrelated estimators reduces variance by a factor of $n$; in practice trees are partly correlated, but variance still drops substantially.

**Q: Bias-variance: what happens with bagging vs boosting?**
A: Bagging reduces variance with no change in bias (averaging independent estimates). Boosting reduces bias by sequentially fitting on residuals/errors (variance can increase modestly but regularization controls it).

**Q: Why use log-loss instead of MSE for logistic regression training?**
A: MSE + sigmoid is a **non-convex** function of parameters → gradient descent can get stuck in local minima. Log-loss + sigmoid is **convex** → global minimum guaranteed. Also, log-loss is what falls out of maximum likelihood estimation for Bernoulli outcomes — it's the principled choice.

---

## ⭐ Final 60-second pre-exam mental checklist

Take a breath. Ask yourself:

1. Do I remember the **confusion matrix layout**?  Y / N
2. Can I write **log-loss** without looking? Y / N
3. Can I state the **bias-variance decomposition**? Y / N
4. Do I know **which methods need scaling**? Y / N
5. Do I know **when accuracy lies**? Y / N
6. Do I know **why rebalancing goes inside CV**? Y / N

If any are "N" — flip back, 30 seconds each. Then go in confidently.

🍀 **You've got this, Ondřej.**
