---
title: ML1 - Worked Examples & Numerical Problems
course: 2400-DS1ML1
tags: [machine-learning, exercises, midterm, practice]
related: "[[ML1_Midterm_Study_Notes]]"
---

# ML1 — Worked Examples & Numerical Problems

> **Why this note exists:** Theoretical exams in ML1 almost always include a numerical or scenario question. "Given this confusion matrix, compute…" or "Here are these data points, which class does KNN predict?" Reading the formulas isn't enough — you need to have *done* the calculations. Work through these without peeking at solutions first.

## Contents

- [[#Problem 1 — Confusion Matrix Basics]]
- [[#Problem 2 — Imbalanced Data — Why Accuracy Lies]]
- [[#Problem 3 — F-beta Trade-off]]
- [[#Problem 4 — KNN by Hand (Classification)]]
- [[#Problem 5 — KNN by Hand (Regression with Weighting)]]
- [[#Problem 6 — Why Scaling Matters (KNN Demonstration)]]
- [[#Problem 7 — Sigmoid & Decision Boundary]]
- [[#Problem 8 — Log-Loss Calculation]]
- [[#Problem 9 — Bias-Variance Decomposition (Numerical)]]
- [[#Problem 10 — Information Gain for a Decision Tree Split]]
- [[#Problem 11 — Gini Impurity for the Same Split]]
- [[#Problem 12 — Reading an ROC Curve]]
- [[#Problem 13 — Cross-Validation Folds]]
- [[#Problem 14 — Choosing the Right Metric (Scenario)]]
- [[#Problem 15 — Why Rebalancing Inside CV Folds Matters]]

---

## Problem 1 — Confusion Matrix Basics

### Setup

A spam filter is evaluated on 1,000 emails. Results:

|  | Predicted Spam | Predicted Ham |
|---|---|---|
| **Actually Spam (200)** | 160 | 40 |
| **Actually Ham (800)** | 30 | 770 |

Compute: accuracy, precision, recall, specificity, F1.

### Solution

Identify the four cells (positive class = spam):
- TP = 160, FN = 40, FP = 30, TN = 770

**Accuracy** = $(TP + TN) / \text{total} = (160 + 770)/1000 = 0.930$

**Precision** = $TP / (TP + FP) = 160 / 190 \approx 0.842$
→ Of emails flagged as spam, 84.2% really are spam.

**Recall (TPR)** = $TP / (TP + FN) = 160 / 200 = 0.800$
→ Of all real spam, we caught 80%.

**Specificity (TNR)** = $TN / (TN + FP) = 770 / 800 = 0.9625$
→ Of all real ham, we correctly let 96.25% through.

**F1** = $\frac{2 \cdot P \cdot R}{P + R} = \frac{2 \cdot 0.842 \cdot 0.800}{0.842 + 0.800} \approx \frac{1.3472}{1.642} \approx 0.820$

---

## Problem 2 — Imbalanced Data — Why Accuracy Lies

### Setup

A medical test for a rare disease (1% prevalence) gives results on 10,000 patients:

|  | Predicted Disease | Predicted Healthy |
|---|---|---|
| **Actually Disease (100)** | 5 | 95 |
| **Actually Healthy (9,900)** | 50 | 9,850 |

The model has high accuracy. But is it actually useful?

### Solution

**Accuracy** = $(5 + 9850) / 10000 = 0.9855 = 98.55\%$ — looks great!

**Recall** = $5 / 100 = 0.05 = 5\%$ — we miss 95% of sick patients!

**Precision** = $5 / 55 \approx 0.091 = 9.1\%$ — most of our "disease" predictions are wrong.

**Naive baseline:** a model that predicts "healthy" for everyone would get:
- Accuracy = $9900 / 10000 = 99\%$ — even higher!
- Recall = 0%, Precision = undefined

**Lesson:** Accuracy is dominated by the majority class. For rare events, use **recall**, **F-beta** (with $\beta > 1$ to favor recall), **PR AUC**, or **MCC**.

---

## Problem 3 — F-beta Trade-off

### Setup

A model has precision = 0.6 and recall = 0.9. Compute F1, F2, and F0.5. Which scenarios prefer which?

### Solution

General formula: $F_\beta = (1 + \beta^2) \cdot \frac{P \cdot R}{\beta^2 P + R}$

**F1** ($\beta = 1$): $\frac{2 \cdot 0.6 \cdot 0.9}{0.6 + 0.9} = \frac{1.08}{1.5} = 0.720$

**F2** ($\beta = 2$, favors recall): $\frac{5 \cdot 0.6 \cdot 0.9}{4 \cdot 0.6 + 0.9} = \frac{2.7}{3.3} \approx 0.818$
→ Higher score because recall is what we have lots of.

**F0.5** ($\beta = 0.5$, favors precision): $\frac{1.25 \cdot 0.6 \cdot 0.9}{0.25 \cdot 0.6 + 0.9} = \frac{0.675}{1.05} \approx 0.643$
→ Lower score because precision is what we're weak on.

### When to use which

| Metric | Use case |
|---|---|
| **F1** | Balanced precision/recall importance |
| **F2** | Recall matters more: medical screening, fraud detection, predicting machine failure |
| **F0.5** | Precision matters more: spam filter (don't lose real email), recommendation systems |

---

## Problem 4 — KNN by Hand (Classification)

### Setup

Training data:

| Point | Feature 1 | Feature 2 | Class |
|---|---|---|---|
| A | 1 | 1 | 🔴 |
| B | 2 | 2 | 🔴 |
| C | 4 | 4 | 🔵 |
| D | 5 | 5 | 🔵 |
| E | 1 | 5 | 🔵 |

Classify query point $Q = (3, 3)$ using KNN with $k = 3$, Euclidean distance, uniform weights.

### Solution

Compute Euclidean distance from Q to each point:

- $d(Q, A) = \sqrt{(3-1)^2 + (3-1)^2} = \sqrt{8} \approx 2.83$
- $d(Q, B) = \sqrt{(3-2)^2 + (3-2)^2} = \sqrt{2} \approx 1.41$
- $d(Q, C) = \sqrt{(3-4)^2 + (3-4)^2} = \sqrt{2} \approx 1.41$
- $d(Q, D) = \sqrt{(3-5)^2 + (3-5)^2} = \sqrt{8} \approx 2.83$
- $d(Q, E) = \sqrt{(3-1)^2 + (3-5)^2} = \sqrt{8} \approx 2.83$

Sort ascending: B (1.41), C (1.41), A (2.83), D (2.83), E (2.83)

**3 nearest neighbors:** B (🔴), C (🔵), A (🔴)

**Vote:** 🔴 = 2, 🔵 = 1 → predict **🔴**

### What changes with $k = 1$?

Closest is a tie B vs C. Tie-breaking is implementation-specific (sklearn picks by training order). With $k=1$ and breaking by ID, prediction depends on the tie rule — illustrating why **odd $k$ is preferred** for binary classification.

### What changes with $k = 5$?

All 5 points are neighbors. Vote: 🔴 = 2 (A, B), 🔵 = 3 (C, D, E) → predict **🔵**

**Lesson:** $k$ controls the bias-variance trade-off. The "right" $k$ comes from CV.

---

## Problem 5 — KNN by Hand (Regression with Weighting)

### Setup

Predict house price for $Q$ using KNN with $k = 3$ and **inverse-distance weighting**.

| Point | Distance to Q | Price |
|---|---|---|
| A | 1 | 100k |
| B | 2 | 200k |
| C | 4 | 400k |

### Solution

**Uniform weighting (for comparison):**

$$\hat{y} = \frac{100 + 200 + 400}{3} = 233.3\text{k}$$

**Inverse-distance weighting:**

Weights: $w_i = 1 / d_i$
- $w_A = 1/1 = 1$
- $w_B = 1/2 = 0.5$
- $w_C = 1/4 = 0.25$

Sum: $1 + 0.5 + 0.25 = 1.75$

Weighted average:

$$\hat{y} = \frac{w_A \cdot 100 + w_B \cdot 200 + w_C \cdot 400}{w_A + w_B + w_C} = \frac{100 + 100 + 100}{1.75} = \frac{300}{1.75} \approx 171.4\text{k}$$

**Comparison:** uniform gave 233.3k, weighted gave 171.4k. Weighting pulled the prediction toward the nearest neighbor (A, the cheapest house). Makes sense — A is "more similar" to Q, so its price should matter more.

---

## Problem 6 — Why Scaling Matters (KNN Demonstration)

### Setup

A dataset has two features:
- **age** (range: 20–60)
- **salary** (range: 20,000–100,000)

Two training points:
- P1: age = 25, salary = 80,000, class = 🔴
- P2: age = 55, salary = 30,000, class = 🔵

Query: age = 30, salary = 70,000

**Without scaling**, which class does KNN predict (k=1, Euclidean)?

### Solution — without scaling

$$d(Q, P_1) = \sqrt{(30-25)^2 + (70000-80000)^2} = \sqrt{25 + 10^8} \approx 10000.001$$

$$d(Q, P_2) = \sqrt{(30-55)^2 + (70000-30000)^2} = \sqrt{625 + 1.6 \times 10^9} \approx 40000.008$$

P1 is closer → predict 🔴. **But the salary difference completely dominated** — the age difference (5 years vs 25 years!) was invisible.

### Solution — with min-max scaling

Scale both features to [0, 1]:
- age scaled = (age − 20) / 40
- salary scaled = (salary − 20000) / 80000

- P1 scaled: (0.125, 0.75)
- P2 scaled: (0.875, 0.125)
- Q scaled: (0.25, 0.625)

$$d(Q, P_1) = \sqrt{(0.25 - 0.125)^2 + (0.625 - 0.75)^2} = \sqrt{0.0156 + 0.0156} \approx 0.177$$

$$d(Q, P_2) = \sqrt{(0.25 - 0.875)^2 + (0.625 - 0.125)^2} = \sqrt{0.391 + 0.25} \approx 0.800$$

P1 still closer → predict 🔴. **But now the prediction reflects both features**, not just salary.

**Lesson:** Without scaling, KNN (and SVM!) behave as if features with larger ranges are "more important". Scaling fixes this. Same applies to neural networks and any distance-based or gradient-based method.

---

## Problem 7 — Sigmoid & Decision Boundary

### Setup

A trained logistic regression model:

$$P(y = 1 \mid x) = \sigma(-2 + 0.5 \cdot x_1 + 1.0 \cdot x_2)$$

(a) Compute the predicted probability for $x_1 = 4, x_2 = 1$.
(b) What's the decision boundary equation if we use cut-off 0.5?
(c) For point (1, 1), what cut-off would we need to classify it as positive?

### Solution

**(a)** Compute the logit: $z = -2 + 0.5(4) + 1.0(1) = -2 + 2 + 1 = 1$

$$\sigma(1) = \frac{1}{1 + e^{-1}} = \frac{1}{1 + 0.368} \approx 0.731$$

So $P(y=1) \approx 73.1\%$ → predict class 1 at cut-off 0.5.

**(b)** Decision boundary: cut-off 0.5 corresponds to $\sigma(z) = 0.5$, which means $z = 0$:

$$-2 + 0.5 x_1 + 1.0 x_2 = 0 \implies x_2 = 2 - 0.5 x_1$$

A straight line — confirming logistic regression has a **linear** decision boundary.

**(c)** For (1,1): $z = -2 + 0.5 + 1 = -0.5$, $\sigma(-0.5) = \frac{1}{1 + e^{0.5}} = \frac{1}{1.649} \approx 0.378$.

So $P(y=1) \approx 37.8\%$. To classify it as positive, the cut-off would have to be **below 0.378**.

This illustrates the **threshold choice problem**: the same model gives different classifications depending on where we set the cut-off. ROC and PR curves help us pick.

---

## Problem 8 — Log-Loss Calculation

### Setup

A classifier produces these predictions on a test set of 5:

| i | y (true) | p̂ (predicted P(y=1)) |
|---|---|---|
| 1 | 1 | 0.9 |
| 2 | 1 | 0.6 |
| 3 | 0 | 0.2 |
| 4 | 0 | 0.7 |
| 5 | 1 | 0.4 |

Compute the binary cross-entropy (log-loss).

### Solution

$$J = -\frac{1}{n} \sum_i [y_i \log \hat{p}_i + (1 - y_i) \log(1 - \hat{p}_i)]$$

Per-observation losses (using natural log):

- i=1: $-[1 \cdot \log(0.9) + 0] = -\log(0.9) \approx 0.105$
- i=2: $-\log(0.6) \approx 0.511$
- i=3: $-\log(1 - 0.2) = -\log(0.8) \approx 0.223$
- i=4: $-\log(1 - 0.7) = -\log(0.3) \approx 1.204$ ← **big penalty for confident wrong prediction**
- i=5: $-\log(0.4) \approx 0.916$ ← wrong direction, but less confident

Sum: $0.105 + 0.511 + 0.223 + 1.204 + 0.916 = 2.959$

Average: $J = 2.959 / 5 = 0.592$

**Lesson:** observation 4 (true=0, predicted 0.7) contributes most. Log-loss heavily punishes **confident incorrect** predictions. A perfectly calibrated honest "I don't know" (0.5) is preferable to a confidently wrong prediction.

---

## Problem 9 — Bias-Variance Decomposition (Numerical)

### Setup

True function: $f(x_0) = 10$. We train 4 models on 4 different bootstrap samples and get predictions at $x_0$:

$$\hat{f}_1 = 8, \quad \hat{f}_2 = 9, \quad \hat{f}_3 = 11, \quad \hat{f}_4 = 12$$

Irreducible noise: $\sigma^2 = 1$. Compute Bias², Variance, and total expected MSE.

### Solution

**Average prediction:** $E[\hat{f}(x_0)] = (8 + 9 + 11 + 12)/4 = 10$

**Bias:** $f(x_0) - E[\hat{f}(x_0)] = 10 - 10 = 0$ → **Bias² = 0** ✅ (unbiased estimator)

**Variance:** $\frac{1}{4}\sum (\hat{f}_i - 10)^2 = \frac{4 + 1 + 1 + 4}{4} = \frac{10}{4} = 2.5$

**Total Expected MSE:** $0 + 2.5 + 1 = 3.5$

### Variation — biased estimator

Suppose models gave $\{12, 12, 13, 11\}$ instead.
- Average = 12 → Bias = $10 - 12 = -2$ → Bias² = 4
- Variance = $\frac{1 + 0 + 1 + 1}{4} = 0.5$
- Total MSE = $4 + 0.5 + 1 = 5.5$

This model has **lower variance but higher bias** — and its total error is worse. Bias-variance is a *trade-off*, not a one-sided minimization.

---

## Problem 10 — Information Gain for a Decision Tree Split

### Setup

Parent node: 10 examples — 6 class A, 4 class B.

Split candidate divides them into:
- Left child: 5 examples (4 A, 1 B)
- Right child: 5 examples (2 A, 3 B)

Compute the information gain using **entropy**.

### Solution

**Step 1 — Parent entropy:**

$p_A = 0.6, p_B = 0.4$

$$H(\text{parent}) = -0.6 \log_2(0.6) - 0.4 \log_2(0.4)$$

Compute:
- $\log_2(0.6) = -0.737$
- $\log_2(0.4) = -1.322$

$$H = 0.6 \cdot 0.737 + 0.4 \cdot 1.322 = 0.442 + 0.529 = 0.971 \text{ bits}$$

**Step 2 — Left child entropy:**

$p_A = 0.8, p_B = 0.2$

$$H(\text{left}) = -0.8 \log_2(0.8) - 0.2 \log_2(0.2)$$
$$= 0.8 \cdot 0.322 + 0.2 \cdot 2.322 = 0.258 + 0.464 = 0.722 \text{ bits}$$

**Step 3 — Right child entropy:**

$p_A = 0.4, p_B = 0.6$

$$H(\text{right}) = -0.4 \log_2(0.4) - 0.6 \log_2(0.6) = 0.971 \text{ bits}$$

(Same as parent — split didn't help on this side.)

**Step 4 — Weighted child entropy:**

$$H_{\text{children}} = \frac{5}{10} \cdot 0.722 + \frac{5}{10} \cdot 0.971 = 0.361 + 0.486 = 0.847$$

**Step 5 — Information Gain:**

$$\text{IG} = 0.971 - 0.847 = 0.124 \text{ bits}$$

The tree picks the split with the **highest IG** across all candidate splits.

---

## Problem 11 — Gini Impurity for the Same Split

Reusing the data from Problem 10:

### Solution

**Parent Gini:** $1 - (0.6^2 + 0.4^2) = 1 - (0.36 + 0.16) = 1 - 0.52 = 0.48$

**Left Gini:** $1 - (0.8^2 + 0.2^2) = 1 - (0.64 + 0.04) = 0.32$

**Right Gini:** $1 - (0.4^2 + 0.6^2) = 1 - 0.52 = 0.48$

**Weighted child Gini:** $0.5 \cdot 0.32 + 0.5 \cdot 0.48 = 0.16 + 0.24 = 0.40$

**Gini gain:** $0.48 - 0.40 = 0.08$

### Comparison with entropy

| | Parent | Weighted children | Gain |
|---|---|---|---|
| Entropy | 0.971 | 0.847 | 0.124 |
| Gini | 0.480 | 0.400 | 0.080 |

Both favor this split (positive gain). For ranking *competing splits*, they almost always agree. Gini wins in practice because it's cheaper to compute (no log).

---

## Problem 12 — Reading an ROC Curve

### Setup

A classifier produces these probabilities on 6 test examples:

| i | true y | p̂ |
|---|---|---|
| 1 | 1 | 0.9 |
| 2 | 1 | 0.7 |
| 3 | 0 | 0.6 |
| 4 | 1 | 0.5 |
| 5 | 0 | 0.3 |
| 6 | 0 | 0.1 |

Construct the ROC curve.

### Solution

3 positives total, 3 negatives total. Try each threshold from high to low:

| Threshold | TP | FP | TPR = TP/3 | FPR = FP/3 |
|---|---|---|---|---|
| > 0.9 | 0 | 0 | 0 | 0 |
| > 0.7 | 1 | 0 | 0.333 | 0 |
| > 0.6 | 2 | 0 | 0.667 | 0 |
| > 0.5 | 2 | 1 | 0.667 | 0.333 |
| > 0.3 | 3 | 1 | 1.000 | 0.333 |
| > 0.1 | 3 | 2 | 1.000 | 0.667 |
| ≥ 0 | 3 | 3 | 1.000 | 1.000 |

The ROC curve passes through these (FPR, TPR) points. Sketching: from (0,0) up to (0, 0.667), right to (0.333, 0.667), up to (0.333, 1), right to (1, 1). Nice top-left hugging shape.

### AUC computation

Use the trapezoid rule across segments. Going left-to-right by FPR:

- (0, 0) → (0, 0.667): vertical, area = 0
- (0, 0.667) → (0.333, 0.667): rectangle, area = $0.333 \cdot 0.667 = 0.222$
- (0.333, 0.667) → (0.333, 1): vertical, area = 0
- (0.333, 1) → (1, 1): rectangle, area = $0.667 \cdot 1 = 0.667$

**AUC = 0.889**

### Interpretation

AUC = 0.889 → if you pick a random positive and a random negative, there's an 88.9% chance the positive has a higher predicted probability than the negative. (Perfect = 1, random = 0.5.)

---

## Problem 13 — Cross-Validation Folds

### Setup

You have 100 observations. Compute:
(a) How many models do you train with 5-fold CV?
(b) Size of each train/validation split?
(c) How many models with **nested** CV (outer = 5-fold, inner = 3-fold) for hyperparameter tuning over 10 candidates?

### Solution

**(a)** 5-fold CV: train 5 models, each on 80 obs, validate on 20.

**(b)** Train = $100 \cdot 4/5 = 80$, Validation = $100 \cdot 1/5 = 20$.

**(c)** Nested CV total models:
- Outer loop: 5 iterations
- Inside each outer iteration: try 10 candidates × 3 inner folds = 30 models, then refit the best 1 on the full outer training set
- Total per outer iteration: 30 + 1 = 31
- Grand total: $5 \cdot 31 = 155$ models

→ Nested CV is **expensive** but gives an honest performance estimate.

**Compare with regular CV + grid search:** $5 \cdot 10 = 50$ models — less honest but 3× faster.

---

## Problem 14 — Choosing the Right Metric (Scenario)

> Scenario questions are likely on the exam. Practice the *reasoning*, not just memorizing rules.

### Scenarios

For each, choose the best metric and justify in 2 sentences.

**(a) Bank credit risk model**: 5% of customers default. Cost of approving a defaulter (false negative) is ~10× the cost of rejecting a good customer (false positive).

→ **Recall** as primary, **PR AUC** for ranking, **F2-score** for combined metric. Imbalanced + asymmetric costs favoring detection of positives. ROC AUC misleadingly optimistic on imbalanced data.

**(b) Predicting house prices** (continuous, no outliers).

→ **RMSE** (or **R²** for relative measure). Squared error penalty makes sense for prices, no outliers means MAE wouldn't be needed for robustness.

**(c) Predicting house prices** with some extreme luxury homes that may distort training.

→ **MAE** or **MedAE**. Robust to outliers. Don't let one $50M outlier dominate the model evaluation.

**(d) Multi-class classification of news articles into 20 balanced categories**.

→ **Accuracy** is fine (balanced classes), or **macro-averaged F1** for per-class fairness.

**(e) Sales forecasting where consistent under-prediction would lead to lost sales**, and over-prediction is moderate cost.

→ Custom **asymmetric cost function** during training; for evaluation, **MSLE** (penalizes under-prediction more than over-prediction).

**(f) Probability calibration matters** (e.g., the bank uses your predicted probabilities directly in pricing models).

→ **Log-loss / cross-entropy** as primary, plus **Brier score** and **calibration curve** inspection.

---

## Problem 15 — Why Rebalancing Inside CV Folds Matters

### Setup

A dataset has 1,000 observations: 50 positives, 950 negatives. You decide to use SMOTE to balance to 50/50, then run 5-fold CV.

**Wrong approach:** SMOTE first → split → CV.
**Right approach:** split first → SMOTE inside each fold → CV.

Why does the wrong approach inflate performance?

### Solution

**Wrong approach mechanism:**

1. SMOTE generates synthetic positives as interpolations of existing positives + their neighbors.
2. After SMOTE, your dataset has 50 real + 900 synthetic positives = 950 positives + 950 negatives = 1900 obs.
3. You split this 1900 into 5 folds. Each validation fold contains ~190 examples, ~95 of which are synthetic.
4. **Crucially:** because synthetic points were created from neighbors of real points, the validation fold contains synthetic versions of points whose "parents" are in the training fold.

**Result:** the model is being evaluated on near-duplicates of its training data → optimistically biased performance.

**Right approach:**

1. Split first: each fold has the original imbalance (40 pos / 760 neg in train, 10 pos / 190 neg in val).
2. SMOTE applied **only to the training fold** of each iteration.
3. Validation fold is left untouched → honest evaluation on the realistic class distribution.

### General rule

> **Any data-dependent transformation must be fit on the training fold only**, then applied to validation/test.

This includes:
- SMOTE / ADASYN / Tomek links / ENN
- Scalers (StandardScaler, MinMaxScaler)
- Imputers (mean/median imputation)
- Encoders that learn from data (TargetEncoder, CatBoost encoder)
- Feature selection methods

If you forget this, your CV scores are inflated and you'll be sad when the model bombs in production.

---

## How to study with this note

1. **Cover the solution** with your hand or a sticky note.
2. **Solve each problem on paper.** Time yourself if you want — most should take 3–6 minutes.
3. **Check.** If you got it wrong, re-read the relevant section in the main study notes, then redo the problem from scratch the next day.
4. **Make up variants.** Change the numbers in Problem 1's confusion matrix. Recompute. The fluency target is "I see a confusion matrix and within 60 seconds I have all 6 metrics."

Most-likely-to-appear on a 40-point theoretical exam, ranked:

1. **Confusion matrix → metrics** (Problems 1, 2, 3) — almost guaranteed.
2. **Bias-variance scenario** (Problem 9) — very likely.
3. **KNN/SVM trade-offs** (Problem 4, 6) — likely.
4. **Metric choice scenario** (Problem 14) — likely as a discussion question.
5. **Tree split calculation** (Problems 10, 11) — possible if Decision Trees are in scope.
6. **CV mechanics** (Problems 13, 15) — possible.
