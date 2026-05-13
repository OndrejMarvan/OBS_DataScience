---
title: ML1 - Classification Methods - Midterm Study Notes
course: 2400-DS1ML1
semester: Spring 2026
midterm_date: 2026-05-15
tags: [machine-learning, classification, msc, wne-uw, midterm]
---

# ML1 — Classification Methods: Midterm Study Notes

> **Goal of these notes:** A complete, self-contained study guide for the mid-term theoretical exam (40 pts). Organized to mirror the lecture flow so you can revise top-to-bottom or jump to a specific concept.

## 📚 Companion Notes

This is the main conceptual guide. For deeper preparation, use these companion notes:

- **[[ML1_Derivations]]** — Step-by-step proofs (OLS, log-loss MLE, bias-variance decomposition, SVM margin, etc.)
- **[[ML1_Worked_Examples]]** — 15 numerical problems with full solutions (confusion matrices, KNN by hand, info gain, ROC construction, etc.)
- **[[ML1_Comparison_Tables]]** — Side-by-side reference (algorithms, metrics, CV types, scalers, encoders, etc.)
- **[[ML1_Exam_Day_QuickRef]]** — 30-min pre-exam refresh with formulas, traps, and exam strategy

## Table of Contents

- [[#1 Introduction to Machine Learning]]
- [[#2 ML as a Function & Estimation]]
- [[#3 Training a Model — Cost Functions & Gradient Descent]]
- [[#4 Linear Regression (ML Perspective)]]
- [[#5 Logistic Regression]]
- [[#6 Generalized Linear Models (GLMs)]]
- [[#7 Evaluation Metrics — Regression]]
- [[#8 Evaluation Metrics — Classification]]
- [[#9 Evaluation Metrics — Probabilities (ROC, PR, AUC)]]
- [[#10 Bias–Variance Trade-off]]
- [[#11 Train / Validation / Test Splits]]
- [[#12 Cross-Validation]]
- [[#13 K-Nearest Neighbours (KNN)]]
- [[#14 Support Vector Machines (SVM & SVR)]]
- [[#15 ML Project Workflow (CRISP-DM, MLOps)]]
- [[#16 Data Preparation, EDA & Imputation]]
- [[#17 Feature Engineering]]
- [[#18 Regularization]]
- [[#19 Hyperparameter Tuning]]
- [[#20 Feature Selection]]
- [[#21 Class Rebalancing (Imbalanced Data)]]
- [[#22 Ensemble Methods]]
- [[#23 Probability Calibration]]
- [[#24 Decision Trees (bonus)]]
- [[#25 Random Forest (bonus)]]
- [[#26 Exam Cheat Sheet — Top Things to Remember]]

---

## 1. Introduction to Machine Learning

**Machine Learning (ML)** is the process of using mathematical models of data to help a computer learn *without direct instruction*. ML is a subset of AI. Algorithms identify patterns in data, and those patterns produce a model that makes predictions. More data + experience → better accuracy.

ML is well-suited when:
- Data is constantly changing
- The task/request keeps shifting
- A hand-coded rule-based solution would be impractical

### Types of Machine Learning

| Type | Data | Goal |
|---|---|---|
| **Supervised** | Labeled (X, y) pairs | Learn $f: X \to Y$ |
| **Unsupervised** | Unlabeled X | Find hidden structure |
| **Semi-supervised** | Small labeled + large unlabeled | Combine both worlds |
| **Reinforcement** | Agent–environment, reward signal | Maximize cumulative reward |

### Supervised Learning

> Given training pairs $\{(x_1, y_1), \dots, (x_n, y_n)\}$, learn a function that maps $x \to y$.

Two flavors:
- **Regression** — outcome is continuous (e.g., predict car price from mileage, age, brand).
- **Classification** — outcome is a category (e.g., spam vs ham email filter).

Econometrics is technically a **subset of supervised learning**.

### Unsupervised Learning

Given $\{x_1, \dots, x_n\}$ (no labels), find structure. Subtypes:
- **Clustering** — group similar objects (e.g., blog visitor segments).
- **Anomaly / novelty detection** — find outliers or new patterns.
- **Dimensionality reduction** — project high-dim data to low-dim while preserving info (e.g., PCA).
- **Association rules** — find strong co-occurrence rules in databases.

### Semi-supervised Learning

Small amount of labeled + lots of unlabeled data. Unlabeled data helps capture the data distribution shape and improve generalization. A special case of weak supervision.

### Reinforcement Learning

Agent learns a *sequence* of decisions to reach a goal in an uncertain environment via trial and error, using rewards and penalties. Goal: maximize total reward.

### Main Challenges in ML

1. **Insufficient training data** — most algorithms need thousands of examples; complex problems need millions.
2. **Non-representative training data** — if training data doesn't reflect the deployment distribution, generalization fails.
3. **Poor-quality data** — errors, outliers, noise hide the underlying patterns. Cleaning data is most of a data scientist's job.

### ML Glossary

| Synonym group | Meaning |
|---|---|
| target / dependent / endogenous / output / regressand / response variable | The variable we predict |
| feature / independent / exogenous / explanatory / predictor / regressor | The variables we use to predict |
| example / entity / row | A single data point |
| label | The target value for one example |

---

## 2. ML as a Function & Estimation

### Fundamental assumption

$$Y = f(X) + \epsilon$$

where:
- $f$ is some **fixed but unknown** function of $X$,
- $\epsilon$ is a random error term, independent of $X$, with mean zero.

**Goal of ML:** estimate $f$. The true $f$ is unobservable — we can only approximate it.

### Estimation idea

$$\hat{Y} = \hat{f}(X)$$

- $\hat{Y}$ is our prediction
- Prediction error = $Y - \hat{Y}$
- Error has two parts:
	- **Reducible error** (bias from a wrong functional form — we can fix this)
	- **Irreducible error** (e.g., omitted variables, noise — we cannot fix this)

### Three approaches to estimating $f$

| Approach | Functional form | # of parameters | Examples |
|---|---|---|---|
| **Parametric** | Known | Finite | Linear regression, logistic regression |
| **Nonparametric** | Unknown (no a priori assumptions) | "Infinite" | KNN, SVM (basic), trees |
| **Semi-parametric** | Mix | Theoretically infinite, practically finite | — |

**Trade-offs for parametric:** simplicity vs constraint, speed vs limited complexity, less data needed vs poor fit.

### Purpose of estimation — three possibilities

1. **Best prediction** → favor black-box, complex, non-parametric.
2. **Best inference / understanding relationships** → favor parametric, fully explainable.
3. **Both** → balance.

> A more complex model is NOT always better. Some problems are purely linear; non-parametric methods may find spurious patterns. **Understand the problem before modelling.**

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

### Properties a good cost function should have

- Yields an **unbiased** estimator: $E[\hat{f}] = f$
- Yields an **efficient** estimator (smallest variance)
- Best case: **MVUE** (minimum-variance unbiased estimator)
- **Convex** — single global minimum
- **Smooth** — continuous & differentiable (so we can use gradient-based optimization)
- Reflects the **business/real cost** of errors (think: is overestimating worse than underestimating? asymmetric losses).

### Closed-form vs gradient descent

For some cost functions, set $\partial J / \partial \theta = 0$ and solve analytically (FOC). For most realistic functions this is **impossible** → use **gradient descent**.

### Gradient descent — intuition

1. The cost function defines a surface in parameter space (we don't know its full shape).
2. Compute the slope (gradient) at the current point.
3. Step downhill (negative gradient direction) until you reach a valley.

### Gradient descent — formally

The gradient $\nabla J(\theta)$ is the vector of partial derivatives — points in the direction of **fastest increase**. So move in the *opposite* direction.

**Vanilla algorithm:**
1. Start with random initial guess $\theta_0$
2. Update: $\theta_{t+1} = \theta_t - \eta \cdot \nabla J(\theta_t)$
3. Repeat until convergence criterion is met.

$\eta$ is the **learning rate** — controls step size. Too large → overshoot/diverge. Too small → painfully slow.

### Three variants of gradient descent

| Variant | Gradient computed on | Update | Trade-off |
|---|---|---|---|
| **Batch GD** | Entire training set | Once per epoch | Accurate but slow |
| **Stochastic GD (SGD)** | One sample at a time | Many per epoch | Fast & noisy; can escape local minima |
| **Mini-batch GD** | Small batch (e.g., 32, 64) | Per batch | Best practical balance |

---

## 4. Linear Regression (ML Perspective)

Basic supervised algorithm for predicting **continuous** variables from a set of independent variables.

- Econometric view: mostly used for **inference**.
- ML view (this course): mostly used for **prediction**.

Estimation methods: OLS (Ordinary Least Squares — our focus), WLS, GLS.

### Matrix notation

$$y = X\beta + \epsilon, \qquad \hat{\beta}_{OLS} = (X^TX)^{-1}X^Ty$$

### OLS regression output — what to look at

- **R²** — % of variance in target explained by inputs. Always increases as you add features → can be misleading.
- **Adjusted R²** — penalizes adding useless features. Can *decrease* when a feature doesn't help. Always ≤ R². Formula:

$$R^2_{adj} = 1 - (1 - R^2)\frac{n - 1}{n - p - 1}$$

where $p$ = number of explanatory variables, $n$ = sample size.

- **F-statistic p-value** — p < 0.05 → model is well specified (better than a model with no features).
- **t-statistic p-value (per parameter)** — p < 0.05 → that variable is significant.
- **Coefficient values** — e.g., $y = 5.2 + 0.47 x_1 + 0.48 x_2 - 0.02 x_3$.

### Key OLS Assumptions (BLUE)

For OLS to be **B**est **L**inear **U**nbiased **E**stimator (Gauss-Markov):
1. **Linearity** — relationship is linear in parameters.
2. **Random sampling** — observations are i.i.d.
3. **No perfect multicollinearity** — features are not exact linear combos of each other.
4. **Zero conditional mean** — $E[\epsilon | X] = 0$ (no omitted variable bias).
5. **Homoscedasticity** — $\text{Var}(\epsilon | X) = \sigma^2$ (constant variance).
6. **Normality of errors** (only needed for hypothesis testing).

---

## 5. Logistic Regression

Basic supervised algorithm for predicting **binary nominal (dichotomous)** variables.

- Output is a **probability** in $[0, 1]$.
- Like linear regression, used both for inference (econometrics) and prediction (ML).
- Interpretation is harder — we use **marginal effects** and **odds ratios** instead of raw coefficients.

### Why not linear regression for binary y?

Linear regression can output values outside $[0, 1]$ — meaningless as a probability. Also, the relationship isn't linear at the extremes.

### The Sigmoid (Logistic) Function

$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

Properties:
1. Maps any real number into $[0, 1]$ → interpretable as a probability.
2. **Differentiable** → friendly to gradient-based optimization.
3. Exponential pushes most outputs near 0 or 1 (sharp decisions, less ambiguous middle).

### Linear regression vs logistic regression

| | Linear | Logistic |
|---|---|---|
| Output | $\beta^T x$ | $\sigma(\beta^T x)$ |
| Range | $(-\infty, +\infty)$ | $(0, 1)$ |
| Cost function | MSE | Log-loss (binary cross-entropy) |
| Use | Continuous y | Binary y |

### Key terminology

- **Odds** = $\frac{p}{1 - p}$
- **Log-odds (logit)** = $\log\left(\frac{p}{1 - p}\right) = \beta^T x$ ← linear in features!

So logistic regression is *linear in the logit*.

### Decision boundary

Default cut-off: probability ≥ 0.5 → class 1, else class 0. The boundary itself is **linear** in feature space.

### Cost function — Binary cross-entropy (log-loss)

$$J(\theta) = -\frac{1}{n}\sum_{i=1}^{n}\left[y_i \log(\hat{p}_i) + (1 - y_i)\log(1 - \hat{p}_i)\right]$$

### Multinomial logistic regression

Two approaches for $k > 2$ classes:
1. **One-vs-All (one-vs-rest)** — train $k$ binary classifiers, pick the one with the highest probability.
2. **Softmax** — generalization of sigmoid to multi-class:

$$P(y = i | x) = \frac{e^{\beta_i^T x}}{\sum_{j=1}^{k} e^{\beta_j^T x}}$$

**Cost function:** generalization of log-loss to cross-entropy. Separate loss per class per observation, then summed.

---

## 6. Generalized Linear Models (GLMs)

A **GLM** generalizes linear regression by:
- Allowing the linear predictor $\eta = X\beta$ to relate to $y$ via a **link function** $g(\cdot)$ where $g(E[y]) = \eta$.
- Allowing the variance of $y$ to be a function of its expected value.

Logistic regression = a GLM with logit link and Bernoulli distribution.

### Common GLM families

| Family | Distribution | Link | Use |
|---|---|---|---|
| Linear regression | Normal | Identity | Continuous y |
| Logistic regression | Bernoulli | Logit | Binary y |
| Poisson regression | Poisson | Log | Count y |
| Multinomial logistic | Multinomial | Softmax | Multi-class y |

---

## 7. Evaluation Metrics — Regression

> Cost function trains the model. **Evaluation metric** judges it afterwards. Eval metrics don't need to be differentiable.

**Bias** = $y - \hat{y}$ (single prediction error; mean over set tells you systematic over/under-estimation).

| Metric | Formula | Notes |
|---|---|---|
| **MSE** | $\frac{1}{n}\sum (y_i - \hat{y}_i)^2$ | Penalizes big errors heavily |
| **RMSE** | $\sqrt{MSE}$ | Same units as y |
| **MAE** | $\frac{1}{n}\sum |y_i - \hat{y}_i|$ | Robust to outliers |
| **MAPE** | $\frac{1}{n}\sum \left|\frac{y_i - \hat{y}_i}{y_i}\right|$ | Scale-free %; breaks when $y_i \to 0$ |
| **sMAPE** | Symmetric MAPE | Avoids MAPE's asymmetry & div-by-zero issues |
| **MSLE** | $\frac{1}{n}\sum (\log(1 + y_i) - \log(1 + \hat{y}_i))^2$ | Penalizes under-prediction more |
| **R²** | $1 - \frac{\sum(y_i - \hat{y}_i)^2}{\sum(y_i - \bar{y})^2}$ | % variance explained |
| **MedAE** | Median of $|y_i - \hat{y}_i|$ | Very robust |

**Tip:** Visualize the residual distribution (histogram / KDE) — never trust a single number alone.

---

## 8. Evaluation Metrics — Classification

### The Confusion Matrix

| | Predicted Positive | Predicted Negative |
|---|---|---|
| **Actual Positive** | TP | FN (Type II error) |
| **Actual Negative** | FP (Type I error) | TN |

### Core metrics

| Metric | Formula | Question it answers |
|---|---|---|
| **Accuracy** ⚠️ | $\frac{TP + TN}{TP + TN + FP + FN}$ | How many predictions correct? (bad for imbalanced) |
| **Recall / Sensitivity / TPR** | $\frac{TP}{TP + FN}$ | Of all actual positives, how many caught? |
| **Specificity / TNR** | $\frac{TN}{TN + FP}$ | Of all actual negatives, how many caught? |
| **Precision / PPV** | $\frac{TP}{TP + FP}$ | Of predicted positives, how many correct? |
| **NPV** | $\frac{TN}{TN + FN}$ | Of predicted negatives, how many correct? |
| **FPR** | $\frac{FP}{FP + TN}$ | Type I error rate |
| **FNR** | $\frac{FN}{FN + TP}$ | Type II error rate |

### F-beta score

$$F_\beta = (1 + \beta^2) \cdot \frac{\text{Precision} \cdot \text{Recall}}{\beta^2 \cdot \text{Precision} + \text{Recall}}$$

- $\beta = 1$ → F1 (equal weight on precision & recall)
- $\beta > 1$ → favor recall (false negatives are costly: e.g., cancer screening)
- $\beta < 1$ → favor precision (false positives are costly: e.g., spam filter)
- Great for **imbalanced datasets**.

### Matthews Correlation Coefficient (MCC)

Correlation between predictions and ground truth. Range $[-1, 1]$. **Robust to class imbalance.**

### Multiclass extensions

- Plot a multiclass confusion matrix.
- Compute per-class precision/recall/F-beta using **one-vs-all**, then aggregate via:
	- **micro** — pool TP/FP/FN across classes, then compute
	- **macro** — average per-class metrics equally
	- **weighted** — average per-class metrics weighted by support

---

## 9. Evaluation Metrics — Probabilities (ROC, PR, AUC)

Most classifiers output **probabilities**, not classes. We need to choose a **cut-off threshold**. Default 0.5 is often wrong.

### ROC curve (Receiver Operating Characteristic)

Plot **TPR (y)** vs **FPR (x)** for every possible cut-off.
- At threshold = 1: classify all as negative → TPR = 0, FPR = 0.
- As threshold ↓: both TPR and FPR rise.
- The closer the curve hugs the top-left corner, the better.

### AUC ROC

Area under the ROC curve. Range $[0.5, 1]$ (0.5 = random, 1 = perfect).
- **Interpretation:** probability that a randomly drawn positive scores higher than a randomly drawn negative.
- **Recommended when:** you care about true negatives as much as true positives, and care about ranking.
- **NOT recommended for highly imbalanced datasets.**

### Precision-Recall (PR) curve

Plot **Precision (y)** vs **Recall (x)** for every cut-off. Classic trade-off: higher precision → lower recall, and vice versa.

### AUC PR

Area under the PR curve. ~ average precision across recall thresholds.
- **Recommended for highly imbalanced problems.**
- Useful when communicating precision/recall trade-off to stakeholders.

### Log-loss / Cross-entropy

$$-\frac{1}{n}\sum [y_i \log(\hat{p}_i) + (1 - y_i)\log(1 - \hat{p}_i)]$$

Penalizes confident wrong predictions heavily. Lower is better.

### Probability metrics for regression

**CRPS (Continuous Ranked Probability Score)** — generalizes MAE to probabilistic forecasts (used when the model predicts a distribution / confidence intervals, not just a point estimate). Not covered in detail in class — just know it exists.

---

## 10. Bias–Variance Trade-off

> ⭐ **This will be on the exam.**

### Definitions

- **Bias** — difference between expected prediction and true value. *How far off, on average?*
- **Variance** — variability of predictions across different training sets. *How sensitive to the specific training data?*

### MSE decomposition

$$\text{Error} = \text{Bias}^2 + \text{Variance} + \text{Noise (irreducible)}$$

### The trade-off

| Model complexity | Bias | Variance | Risk |
|---|---|---|---|
| Too simple | High | Low | **Underfitting** |
| Too complex | Low | High | **Overfitting** |
| Just right | Balanced | Balanced | Good generalization |

### Underfitting — signs and remedies

- Training and validation errors both high.
- Model is too simple to capture the pattern.
- **Fixes:** more complex model, more features, less regularization, **boosting**.

### Overfitting — signs and remedies

- Training error very low; validation error much higher.
- Model memorized noise instead of learning the signal.
- **Fixes:** reduce model complexity, regularization, more data, dropout, **bagging**.

### Learning curves

Plot model performance vs experience (training set size or epochs).

| Curve | What it shows |
|---|---|
| Train learning curve | How well the model learns the training data |
| Validation learning curve | How well the model generalizes |
| Optimization learning curve | Performance of the *cost function* being optimized (e.g., log-loss) |
| Performance learning curve | Performance of the *evaluation metric* (e.g., AUC ROC) |

A widening gap between train and validation = overfitting.

---

## 11. Train / Validation / Test Splits

> **Training and evaluating on the same data is a methodological mistake** — it makes overfitting invisible.

Standard practice: split data into three sets.

| Set | Purpose |
|---|---|
| **Train** | Fit model parameters |
| **Validation** | Tune hyperparameters, select model |
| **Test** | Final, unbiased estimate of generalization |

### Stratified splitting

For classification with **imbalanced classes**, use **stratified sampling** so each split preserves the original class frequencies. Critical.

---

## 12. Cross-Validation

> Single train/validation split is fragile — the value could be optimistic or pessimistic depending on which examples landed where.

**Cross-Validation (CV)** = resampling method that trains/validates on different portions of the data over multiple iterations.

### Why CV?

1. **Quasi-objective quality assessment** → reduces overfitting risk.
2. **Safe hyperparameter tuning** → prevents tuning on a lucky split.

### Types of CV

| Type | Use |
|---|---|
| **Hold-out** | Simple single train/val split — baseline |
| **K-Folds** | Split into k equal folds, rotate validation fold. **Most common.** |
| **Leave-One-Out (LOO)** | k = n. Very expensive, very low bias |
| **Leave-p-Out** | Hold out p observations at a time |
| **Stratified K-Folds** | Preserves class balance per fold — for imbalanced classification |
| **Repeated K-Folds** | Repeat the whole K-fold procedure with different random seeds → more stable estimate |
| **Nested K-Folds** | Outer loop for performance estimation, inner loop for hyperparameter tuning |
| **Time Series CV** | Forward-chaining: train on past, validate on future. **Never shuffle time series!** |

### Nested CV (very important conceptually)

Normal CV: you tune hyperparameters AND estimate performance on the same folds → information leakage and optimistic bias.

Nested CV:
- **Inner loop**: cross-validation for hyperparameter tuning (with grid/random/Bayesian search).
- **Outer loop**: assesses generalization — its test folds are completely held out from the inner loop.

Computationally expensive but gives the most honest performance estimate.

### Cross-validation + imbalance

- Use **Stratified K-Folds** to preserve class proportions.
- If you also rebalance (over/under-sampling), do it **inside each fold separately** to avoid data leakage.

---

## 13. K-Nearest Neighbours (KNN)

### Core idea

> The best prediction for a new observation is the label of the most similar example(s) in the training set.

### KNN is...

- **Non-parametric** — no distributional assumptions.
- **Instance-based / lazy learner** — no training step; the training set IS the model.
- All computational cost is at **prediction time**.

### KNN for classification vs regression

- **Classification** → majority vote among k nearest neighbors.
- **Regression** → average of k nearest neighbors' target values.

### KNN classification algorithm

1. For new point $x$, compute distance from $x$ to **every** point in the training set.
2. Pick the $k$ nearest neighbors.
3. Vote: assign the majority class.

### Three key hyperparameters

#### (a) Distance metric

| Metric | Formula | Notes |
|---|---|---|
| **Minkowski-p** | $\left(\sum |x_i - y_i|^p\right)^{1/p}$ | General form |
| **Euclidean** | Minkowski with $p = 2$ | Straight-line; most common |
| **Manhattan** | Minkowski with $p = 1$ | Grid distance |
| **Chebyshev** | $\max_i |x_i - y_i|$ | Minkowski with $p \to \infty$ |

#### (b) Number of neighbors $k$

- Rule of thumb starting point: $k \approx \sqrt{n}$, then tune with CV (usually smaller).
- **Small k → high variance** (overfits; $k=1$ is extreme).
- **Large k → high bias** (smooths out real patterns).
- Strongly affects the decision boundary.

#### (c) Neighbor weights

- **Uniform** — all $k$ neighbors equally weighted (default).
- **Distance-weighted** — closer neighbors count more (e.g., inverse distance).

### Feature scaling — MANDATORY for KNN

Distance metrics are **absolute** — a variable on a domain of 0–1,000,000 will dominate one on 0–1, regardless of predictive power.

**Scaling techniques:**

| For continuous | Description |
|---|---|
| **Standardization (z-score)** | $z = (x - \mu) / \sigma$ |
| **Min-max (rescaling)** | $z = (x - \min)/(\max - \min) \in [0,1]$ |
| **Quantile normalization** | Maps to a uniform distribution |

| For categorical | Description |
|---|---|
| **One-hot encoder** | n levels → n binary features (optionally rescaled) |
| **Ordinal encoder** | Map levels to integers, then rescale |

### Other important KNN considerations

- **Search algorithms** — brute force works on small data; on larger data use **K-D Tree** or **Ball Tree**.
- **Curse of dimensionality** — as dimensions grow, points become equidistant; "a high-dimensional space is a lonely place". Mitigations: bagging, dimensionality reduction, feature selection.
- **Sensitive to irrelevant features** — feature selection (expert knowledge, forward/backward selection, etc.) is critical.

### KNN — pros & cons

| ✅ Pros | ❌ Cons |
|---|---|
| Intuitive & simple | Slow at prediction time |
| Non-parametric (no assumptions) | Memory-hungry (stores all data) |
| No training step | Curse of dimensionality |
| Works for classification & regression | Often low accuracy in practice |
| Few hyperparameters | Requires feature homogeneity (must scale!) |
| Handles sparse matrices well | Not directly suited to imbalanced data |
| | No built-in missing value handling |
| | Sensitive to feature selection |

---

## 14. Support Vector Machines (SVM & SVR)

### Core idea

> In a multi-dimensional space, find the **hyperplane** that separates classes with the **maximum margin** (widest "street") between it and the closest training points (the **support vectors**).

Author: **Vladimir Vapnik** (one of the most influential ML researchers).

### Geometric intuition

- Many hyperplanes can separate two classes.
- The "best" one is the one that lies as far as possible from the nearest points of both classes.
- Only the **support vectors** (the points on the margin) determine the hyperplane. The rest don't matter — that's why SVM is **memory-efficient**.

### Formalization (binary, linearly separable)

Decision function: $f(x) = w^T x + b$
- Predict +1 if $f(x) \ge 0$, else -1.
- Margin width = $\frac{2}{\|w\|}$.

**Optimization problem (hard margin):**

$$\min_{w, b} \frac{1}{2}\|w\|^2 \quad \text{s.t.} \quad y_i(w^T x_i + b) \ge 1 \;\; \forall i$$

Solved via **Lagrangian / quadratic programming**. Result: each training point gets a Lagrange multiplier $\alpha_i$; only support vectors have $\alpha_i > 0$.

### Soft margin & regularization — the $C$ parameter

Real data is rarely linearly separable. Introduce **slack variables** $\xi_i$ to allow some misclassifications:

$$\min_{w, b, \xi} \frac{1}{2}\|w\|^2 + C \sum \xi_i$$

- **Low $C$** → wide margin, more tolerance for errors, smoother boundary (more regularization).
- **High $C$** → narrow margin, fewer errors allowed, can overfit. Very high $C$ → hard margin behavior.

**$C$ is the most important SVM hyperparameter.**

### Kernel trick

When data isn't linearly separable in input space, **map it to a higher-dimensional space** where it becomes (more) separable. But we never compute the mapping explicitly — we just use a **kernel function** $K(x_i, x_j)$ to compute inner products in the transformed space.

| Kernel | Use |
|---|---|
| **Linear** | Linearly separable data |
| **Polynomial** | Polynomial boundaries; hyperparameter: degree |
| **RBF / Gaussian** | Most flexible; hyperparameter: $\gamma$ |
| **Sigmoid** | Less common |

> $\gamma$ in RBF/poly: how much influence a single training example has. Larger $\gamma$ → more localized influence (risk of overfitting).

**Kernels are hyperparameters AND have their own hyperparameters** — tune via CV.

### Feature scaling — also MANDATORY for SVM

Like KNN, SVM relies on distances → **always standardize** (commonly z-score). Apply scaler fit on train, transform on test.

### Multiclass SVM

SVM is natively binary. For $k$ classes:
- **One-vs-All** → $k$ classifiers
- **One-vs-One** → $\binom{k}{2} = k(k-1)/2$ classifiers; vote

### Support Vector Regression (SVR)

Adapts SVM for regression with an **$\epsilon$-tube** of tolerance around the prediction. Errors inside the tube don't count; outside, they're penalized.

Key SVR hyperparameters: $C$, kernel (+ its params), and $\epsilon$ (tube width). Larger $\epsilon$ → more tolerant.

### SVM — pros & cons

| ✅ Pros | ❌ Cons |
|---|---|
| Effective in high-dim spaces | Slow on very large datasets (basic implementation) |
| Works even when #dims > #samples | Low interpretability (especially with kernels) |
| Memory-efficient (uses only support vectors) | Bad when classes overlap heavily |
| Versatile via kernels | Need to be careful w/ overfitting when #features >> #samples |
| Partially immune to outliers (with regularization) | No native probabilities — must use expensive CV calibration |
| Few hyperparameters | |
| Can handle imbalanced data via class weighting | |

---

## 15. ML Project Workflow (CRISP-DM, MLOps)

### Why a workflow?

Most applied ML projects follow a defined structure to keep research + engineering efficient. Choice depends on business problem, organization, team.

### CRISP-DM — the classic data mining cycle

**C**ross-**I**ndustry **S**tandard **P**rocess for **D**ata **M**ining:

1. **Business understanding** — what is the problem worth solving?
2. **Data understanding** — what data do we have?
3. **Data preparation** — clean, transform, split.
4. **Modelling** — fit & tune candidates.
5. **Evaluation** — does it meet business goals?
6. **Deployment** — ship it.

It's cyclical — loop back as you learn.

### Data Science cycle (variation)

Similar: Ask → Get → Explore → Model → Communicate → (Deploy).

### MLOps

> **Set of practices to deploy and maintain ML models in production reliably and efficiently.** Compound of ML + DevOps.

Once an algorithm is ready, DS + DevOps + ML engineers transition it to production. Goal: automation, quality, monitoring, business + regulatory compliance.

### Problem statement worksheet (McKinsey style)

At the start of an ML consulting project, formalize a **problem statement worksheet** — a one-page document defining:
- Business problem
- Stakeholders
- Success criteria / KPIs
- Constraints (time, data, regulation)
- Out-of-scope

Becomes the contract between parties + the input for project management.

---

## 16. Data Preparation, EDA & Imputation

### Dataset preparation pipeline

1. Define and source the necessary data.
2. **Ingest** — extract from source systems.
3. Transform to a clean, analytical form.
4. Initial exploration + validation.
5. Combine sources (if appropriate).
6. **Split** {train, val, test} early. ⚠️ All transformations must be **fit on train only, then applied to val/test** to prevent leakage.
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
| One-sample tests | Chi-square (cat–cat) |
| Autocorrelation, white noise (time series) | ANOVA (cat–num) |
| Frequency tables | t-test (num–num across groups) |

Unsupervised techniques like **PCA** are also useful exploratory tools.

### Missing data — causes & treatment

**Why data goes missing:**
- Data doesn't exist
- Capture failure (hardware/software/human)
- Deletion / corruption

**Strategies:**

1. **Do nothing** — some algorithms handle missings natively (e.g., XGBoost, LightGBM).
2. **Remove**:
	- Drop column if > ~10% missing AND not crucial.
	- Drop row only if dataset is large and missings look random (otherwise you bias your sample).
3. **Imputation:**

| Variable type | Univariate technique | Multivariate technique |
|---|---|---|
| Continuous | constant (e.g., 0); mean/median/mode (global or by subgroup); random draw from assumed distribution | KNN; **MICE** (Multivariate Imputation by Chained Equations); other supervised ML |
| Categorical | encode missing as new "missing" category; mode (global or subgroup); random non-missing | KNN, MICE |
| Time series | last-observed-carried-forward (LOCF), next-observed; linear/polynomial/spline interpolation | — |

> Always check **why** data is missing — sometimes you can just re-extract it.

---

## 17. Feature Engineering

> The single biggest determinant of model quality. "Garbage in, garbage out."

**Two main moments:**
1. **During ETL** — analytical engineering: aggregations using domain knowledge (e.g., aggregate customer transactions into one row).
2. **After ETL** — creative feature creation to boost predictive power (especially for models that can't capture non-linearity: OLS, KNN, SVM).

> ⚠️ Each transformation must be **fit on training set, then applied to test set** — never refit on test.

### Numeric variable transformations

| Technique | Formula / Idea | When to use |
|---|---|---|
| **Min-max scaling** | $z = (x - \min) / (\max - \min)$ | Feature roughly uniform in a fixed range |
| **Clipping (winsorization)** | Cap above max, floor below min | Feature has extreme outliers |
| **Log scaling** | $z = \log(x)$ | Feature follows a power law |
| **Z-score (standard scaler)** | $z = (x - \mu)/\sigma$ | Feature has no extreme outliers |
| **Quantile transformer** | Map to uniform $[0, 1]$ | Robust to outliers, changes distribution |
| **Power transformer (Box-Cox, Yeo-Johnson)** | Map to ~Gaussian | Stabilize variance, reduce skew |
| **Bucketing (discretization)** | Bin continuous into ranges | Help with non-linearity & overfitting |
| **Polynomial / spline transformer** | Add $x^2, x^3, \dots$ | Capture non-linear relationships |

**Bucketing boundaries**: equal spacing, quantiles, decision-tree splits, or expert-defined.

### Categorical variable transformations

| Technique | Description |
|---|---|
| **One-hot encoding** | n levels → n binary features. Drop one to avoid perfect collinearity in OLS. With L1/L2 regularization, you can keep all. |
| **Ordinal encoder** | Map levels to integers. **Imposes an order** — be careful! Good only for genuinely ordinal features. |
| Target encoder, CatBoost encoder, WoE, Helmert, James-Stein, Leave-One-Out, etc. | Advanced encoders, often domain-specific (e.g., WoE for credit risk) |

### Interactions

Multiply, divide, subtract pairs of variables (numeric × numeric, num × cat, cat × cat). Use intuition + business sense.

### Practical wisdom

- Endless possibilities — but more isn't always better.
- Tree-based models can ignore irrelevant features automatically; linear models cannot.
- In finance, features with strong **business/economic theoretical basis** usually win over purely numerical fishing.

---

## 18. Regularization

> A tool to fight **overfitting** (high variance). Modifies the loss function to penalize complexity.

**Regularized cost function:**

$$J_{reg}(\theta) = J(\theta) + \lambda \cdot R(\theta)$$

- $J(\theta)$ — original loss
- $R(\theta)$ — regularization term (function of parameters)
- $\lambda$ — controls regularization strength (hyperparameter; tune via CV)

### Three main types

| Type | Penalty | Effect |
|---|---|---|
| **L1 (Lasso)** | $\sum |\theta_j|$ | Pushes weights to **exactly 0** → automatic **feature selection** |
| **L2 (Ridge)** | $\sum \theta_j^2$ | Shrinks weights toward 0 but rarely zero. Handles **multicollinearity** well |
| **Elastic Net** | $\alpha \cdot L1 + (1-\alpha) \cdot L2$ | Best of both. Often the most reasonable choice. |

Originally for linear models; now widely used in many ML algorithms.

---

## 19. Hyperparameter Tuning

**Hyperparameter** — a parameter NOT learned during training; set by the researcher (e.g., $k$ in KNN, $C$ in SVM, depth in trees).

### The components

1. **Hyperparameter space** — set of values or distributions to draw from.
2. **Search strategy** — how to explore the space.
3. **Score function** — how to evaluate each configuration (use multiple metrics).
4. **CV scheme** — appropriate for the problem (k-fold, stratified, time series, etc.).

### The generalized procedure

1. Sample a set of hyperparameters from the space.
2. Run cross-validation, compute score(s).
3. Repeat until stop criterion (e.g., iteration budget).
4. Pick the best set.

> Modern algorithms often parallelize step 2 by generating many sets up front.

### Three search strategies

| Strategy | How it works | Pros | Cons |
|---|---|---|---|
| **Grid search** | Exhaustively test every combination of user-defined values | Simple, reproducible | Expensive; bad in high dim |
| **Random search** | Randomly sample $n$ configurations from set / distribution | More efficient than grid in high dim; covers more ground | Still ignores past trials |
| **Bayesian search** | Build a probabilistic model of the objective vs hyperparameters; balance **exploration** (uncertain regions) vs **exploitation** (promising regions); update after each trial | Sample-efficient; great for expensive models | More complex to implement |

> **Recommendation:** random search beats grid search in high dimensions (often cited). Bayesian methods are best for expensive evaluations.

---

## 20. Feature Selection

After good feature engineering you have **many** features — but some models don't auto-select (OLS, KNN, SVM). Time to prune.

### Two-step recommended approach

#### Step 1: Univariate / bivariate selection

| Method | What it tests |
|---|---|
| **Variance threshold** | Remove features with variance below a threshold (constants & near-constants) |
| **Mutual information** | Information-theoretic dependence between feature and target |
| **F-test / Chi²** | Statistical test of dependence |
| **Correlation** | Pearson (linear), Spearman (rank, also for ordinal), Kendall |

#### Step 2: Multivariate selection

**Embedded** (selection happens during model fitting):
- **Lasso / Elastic Net** — built-in feature selection
- **Boruta** — wrapper around Random Forest with a statistically elegant algorithm (Polish author!)
- **SHAP values** — explainable ML approach used for feature selection

**Wrapper** (search over feature subsets using CV):
- **Forward selection** — start with nothing, add the best feature each round.
- **Backward selection** — start with all, remove the worst each round.
- **Recursive Feature Elimination (RFE)** — like backward, uses feature importance from a model.

**Built-in feature importance:** Random Forest, XGBoost, CatBoost, LightGBM all expose feature importance — use it heavily in practice.

---

## 21. Class Rebalancing (Imbalanced Data)

The imbalance problem hits in two places:
1. **During training** — cost function focuses on the majority class.
2. **During evaluation** — accuracy & AUC ROC look misleadingly optimistic.

### Four families of solutions

1. **Cost-function modification** (class weights) — already covered with the algorithms.
2. **Undersampling** — reduce majority class.
3. **Oversampling** — grow minority class.
4. **Combination** of both.

### Undersampling

**Prototype generation** — synthesize new representatives:
- **Cluster centroids** — use K-means centroids of majority class as the new majority data.

**Prototype selection** — pick actual examples to keep:
- **Random undersampler** — fast, simple, can specify desired ratio.
- **Tomek's links** — a Tomek link = pair of nearest neighbors of opposite classes. Remove the majority-class member; cleans the boundary.
- **Edited Nearest Neighbours (ENN)** — remove majority-class examples whose class disagrees with their neighbors. Can be repeated → **Repeated ENN**.

### Oversampling

- **Random oversampler** — duplicate minority observations (bootstrap by default).
- **SMOTE (Synthetic Minority Over-sampling Technique)** — create new synthetic minority observations as **convex (≈ linear) combinations** of existing minority points and their nearest neighbors. Variants:
	- **Borderline SMOTE** — generate near the class boundary.
	- **SVM SMOTE** — uses SVM support vectors to guide generation.
	- **K-means SMOTE** — clusters minority class first, generates per cluster.
- **ADASYN (Adaptive Synthetic)** — like SMOTE but generates *more* samples for minority points that are harder to learn (uses a weighted distribution by local difficulty).

### Combination

- **SMOTETomek** — SMOTE + Tomek-link cleaning.
- **SMOTEENN** — SMOTE + Edited Nearest Neighbours cleaning.

### ⚠️ Critical warnings

- **Random undersampling** is often the practical baseline — always test variants.
- **Data leakage**: if doing CV, **rebalance each fold separately** — never rebalance before splitting.
- **SMOTE and Tomek only work in low-dimensional data.**

---

## 22. Ensemble Methods

> Combine multiple **weak models** to get one strong model.

### Four ensemble strategies

| Strategy | Idea | Example |
|---|---|---|
| **Bagging (Bootstrap Aggregating)** | Train models on bootstrap samples in parallel; aggregate predictions. **Reduces variance.** | **Random Forest** |
| **Boosting** | Train models sequentially; each new model focuses on errors of the previous ones. **Reduces bias** (and variance). | AdaBoost, XGBoost, LightGBM, CatBoost |
| **Stacking** | Predictions of base ("level-0") models become features for a **meta-learner** ("level-1"). Any model can be the meta-learner. | — |
| **Voting** | Combine *different* model types; use majority vote (hard) or average probabilities (soft). | — |

**AdaBoost** — adaptive boosting. After each round, increase weights on previously misclassified examples → next learner focuses on the hard cases.

---

## 23. Probability Calibration

A model is **well-calibrated** if, among predictions with probability ~$p$, roughly fraction $p$ are actually positive.

**Why we care:**
- Some models don't return probabilities (e.g., SVM).
- Some return probabilities but they're miscalibrated.
- Critical for risk-sensitive applications (e.g., credit scoring).

### Calibration of common classifiers

| Model | Calibration behavior |
|---|---|
| **Logistic regression** | Well-calibrated ✅ |
| **Naive Bayes** | Pushes probs to 0 or 1 (overconfident) |
| **Random Forest** | Peaks around 0.2 and 0.9 — rarely 0 or 1 |
| **SVM** | "Strong sigmoid" shape — miscalibrated |

### How to calibrate

Fit a **calibrator** (a regressor) that maps raw model output → calibrated probability in $[0, 1]$. Done inside **cross-validation** (to avoid bias — never fit calibrator on the same data as the classifier).

Two common calibrators (binary, extendable to multi-class via One-vs-Rest):
- **Sigmoid (Platt scaling)** — fit a logistic regression on raw scores.
- **Isotonic regression** — non-parametric, monotonic mapping. More flexible but needs more data.

**Quality of calibration:** check with **calibration curves** (predicted prob on x, observed frequency on y) and the **Brier score**.

---

## 24. Decision Trees (bonus / extra material)

### Core idea

> Learn and apply simple **decision rules** (if-else) from training data. The model is a piecewise-constant approximation of $f$.

### Family of tree algorithms (chronological)

- **ID3** (Iterative Dichotomiser 3) — categorical features, classification only.
- **C4.5** — adds support for continuous features.
- **C5.0** — improvement of C4.5.
- **CART** (Classification And Regression Trees) — both classification & regression.

### How a tree is built (CART)

At each node, pick the feature + threshold that **best separates** the training data according to a splitting criterion.

**Classification criteria:**
- **Gini impurity** — $1 - \sum p_k^2$
- **Entropy** — $-\sum p_k \log p_k$

Both measure class purity at a node; lower is better.

**Regression criteria:**
- **MSE** (variance reduction)
- **MAE**

Recursively split until a stopping criterion is met.

### Key hyperparameters

| Hyperparameter | What it controls |
|---|---|
| **max_depth** | How deep tree can grow. **Most important — risk of overfitting.** Start with 3. |
| **min_samples_split** | Min samples needed to split an internal node. Small → overfits; large → underfits |
| **min_samples_leaf** | Min samples per leaf. For classification with few classes, 1 is often best |
| **criterion** | Gini / entropy / MSE etc. |
| **max_features** | # features to consider per split — lower means more variance reduction but higher bias |

### Trees — pros & cons

| ✅ Pros | ❌ Cons |
|---|---|
| Very intuitive & visualizable | Easy to overfit |
| Handle continuous and categorical natively | Unstable — small data change → very different tree |
| Non-parametric | Bad with imbalanced data (basic implementation) |
| Auto feature selection + importance | Sensitive to outliers |
| Quick to train | High complexity in regression problems |
| Built-in pruning | |

---

## 25. Random Forest (bonus / extra material)

### Core idea

Random Forest = **bagging** of decision trees + **feature bagging** at each split.

Author: **Leo Breiman**.

Two sources of randomness:
1. **Bagging** — each tree trained on a bootstrap sample of the training set.
2. **Feature bagging** — at each split, only consider a random subset of features.

Both reduce variance + decorrelate the trees → big performance boost vs single tree.

### Out-of-Bag (OOB) error

When you bootstrap-sample, ~37% of original observations don't make it into each tree's training set. Use those "out-of-bag" samples to estimate generalization error **without separate CV**. Rare in practice but worth knowing.

### Extremely Randomized Trees (Extra Trees)

Like RF but at each split, instead of finding the optimal threshold for each candidate feature, **draw random thresholds** and pick the best of those. More variance reduction at the cost of slightly more bias. Faster too.

### Key RF hyperparameters

| Hyperparameter | Tip |
|---|---|
| **n_estimators (# trees)** | More is better, but with diminishing returns. Eventually plateaus. |
| **max_features per split** | Default rule of thumb: **all features** for regression, **$\sqrt{p}$** for classification |
| **bootstrap** | Yes — almost always |
| **n_jobs (parallelization)** | RF parallelizes trivially across CPUs |
| Plus all tree hyperparameters (depth, min samples, etc.) | |

### RF — pros & cons

| ✅ Pros | ❌ Cons |
|---|---|
| Inherits tree strengths, fixes tree weaknesses | Not fully interpretable (many trees → black box for non-experts) |
| Lower variance → more resistant to overfitting | Many hyperparameters |
| Robust to outliers | Computationally expensive (time + memory) |
| Handles linear & non-linear relationships | Not great for sparse linear problems |
| Great accuracy & bias-variance balance | |
| Built-in feature importance (impurity decrease) | |

---

## 26. Exam Cheat Sheet — Top Things to Remember

> The 10-minute pre-exam refresh.

### Fundamentals
- $Y = f(X) + \epsilon$; we estimate $\hat{f}$.
- Reducible error (bias) vs irreducible error (noise).
- **Training = minimizing cost function.** Loss is per-example; cost is over the dataset (possibly + regularization).
- Gradient descent: $\theta_{t+1} = \theta_t - \eta \nabla J(\theta_t)$.
- **Batch / SGD / Mini-batch** GD trade-offs.

### Models
- **Linear regression** — predict continuous y. OLS = $(X^TX)^{-1}X^Ty$. Adjusted R² penalizes extra features.
- **Logistic regression** — predict binary y via sigmoid. Cost = log-loss. Linear in the logit. Multiclass → one-vs-all OR softmax.
- **KNN** — lazy, non-parametric. Tune $k$, distance metric, weights. **Must scale features.** Curse of dimensionality.
- **SVM** — max-margin hyperplane via support vectors. Hyperparams: $C$ (regularization), kernel + its params. **Must scale features.** Soft margin with slack variables.

### Evaluation
- **Classification confusion matrix** → recall, precision, specificity, F1, FPR, MCC.
- **Accuracy is bad for imbalanced data.** Use F-beta or MCC.
- **ROC AUC** — good for balanced data, ranking. **PR AUC** — better for imbalanced.
- **Bias–Variance: simple → bias↑; complex → variance↑.** Error = Bias² + Variance + Noise.
- **Overfitting** → train ≪ val. Fix: simpler model, regularization, more data, **bagging**.
- **Underfitting** → both errors high. Fix: more complex model, **boosting**.

### Training methodology
- **Train/Val/Test split** — never evaluate on training data. Stratify for imbalanced classification.
- **K-Fold CV** — most common. Stratified for imbalance. Time-series CV for time-ordered data.
- **Nested CV** — outer for performance, inner for tuning. No leakage.

### Pipeline & tricks
- **Feature scaling** — required for KNN, SVM, neural nets.
- **One-hot vs ordinal encoding** — ordinal imposes ordering!
- **Regularization** — L1 (Lasso, feature selection), L2 (Ridge, multicollinearity), Elastic Net.
- **Hyperparameter tuning** — grid, random (often better), Bayesian (most efficient).
- **Imbalanced data** — class weights, undersampling (Tomek, ENN), oversampling (SMOTE, ADASYN), or combo (SMOTETomek). **Rebalance inside CV folds, not before!**
- **Ensembles** — Bagging (↓ variance, RF), Boosting (↓ bias, AdaBoost/XGBoost), Stacking (meta-learner), Voting.
- **Probability calibration** — sigmoid (Platt) or isotonic. LogReg is calibrated by default; RF, SVM, NB are not.

### Memorize these formulas

- $R^2_{adj} = 1 - (1-R^2)\frac{n-1}{n-p-1}$
- Sigmoid: $\sigma(z) = \frac{1}{1 + e^{-z}}$
- Log-odds: $\log\frac{p}{1-p} = \beta^T x$
- Binary cross-entropy: $-\frac{1}{n}\sum [y_i \log\hat{p}_i + (1-y_i)\log(1-\hat{p}_i)]$
- Precision = TP/(TP+FP), Recall = TP/(TP+FN)
- F1 = 2·P·R/(P+R)
- SVM hard margin: $\min \frac{1}{2}\|w\|^2$ s.t. $y_i(w^T x_i + b) \ge 1$
- Min-max: $z = (x-\min)/(\max-\min)$, Z-score: $z = (x-\mu)/\sigma$

---

## Quick conceptual links to your other coursework

- **Spatial ML in R**: the same bias-variance, train/test, and CV logic applies — and your `terra`/`sf` pipeline already follows the "fit transformations on train only" rule.
- **MySQL Titanic challenge**: that ~78–80% training accuracy from your SQL script is essentially a manually-built classifier with engineered features — useful baseline for comparing against logistic regression / RF.
- **Carbon markets work**: the asymmetric-loss point in §3 (overestimate vs underestimate cost) is directly relevant to EUA position sizing and CBAM hedge structuring.

---

> **Good luck on May 15. You've got this.** 🍀
