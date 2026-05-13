---
title: ML1 - Key Derivations & Proofs
course: 2400-DS1ML1
tags: [machine-learning, derivations, math, midterm]
related: "[[ML1_Midterm_Study_Notes]]"
---

# ML1 — Key Derivations & Proofs

> **Why this note exists:** Conceptual notes get you to "I understand X." Derivations get you to "I can re-derive X under exam pressure." Most ML1 theoretical exams include at least one derivation question. Practice writing these out by hand — fluency comes from the pen, not the eyes.

## Contents

- [[#1 OLS Closed-Form Solution]]
- [[#2 Why Linear Regression Fails on Binary Targets]]
- [[#3 Logistic Regression — Deriving the Cost from MLE]]
- [[#4 Logistic Regression — Gradient of Log-Loss]]
- [[#5 Softmax — Derivation & Cross-Entropy]]
- [[#6 Bias-Variance Decomposition of MSE]]
- [[#7 SVM — Margin Width = 2/‖w‖]]
- [[#8 SVM — Lagrangian & Why Only Support Vectors Matter]]
- [[#9 SVM — Why the Kernel Trick Works]]
- [[#10 KNN — Curse of Dimensionality (Intuition)]]
- [[#11 Gini & Entropy — Why They Measure Impurity]]

---

## 1. OLS Closed-Form Solution

### Setup

Linear model in matrix form:

$$y = X\beta + \epsilon$$

where:
- $y \in \mathbb{R}^n$ (target vector)
- $X \in \mathbb{R}^{n \times p}$ (design matrix; rows = observations, columns = features)
- $\beta \in \mathbb{R}^p$ (parameter vector)
- $\epsilon \in \mathbb{R}^n$ (error vector)

### Cost function

OLS minimizes the **sum of squared residuals** (RSS):

$$J(\beta) = \sum_{i=1}^{n} (y_i - x_i^T \beta)^2 = (y - X\beta)^T (y - X\beta)$$

### Derivation step-by-step

**Step 1.** Expand:

$$J(\beta) = y^T y - y^T X\beta - \beta^T X^T y + \beta^T X^T X \beta$$

The middle two terms are scalars and equal to each other ($y^T X\beta = \beta^T X^T y$):

$$J(\beta) = y^T y - 2\beta^T X^T y + \beta^T X^T X \beta$$

**Step 2.** Take the gradient with respect to $\beta$ (FOC):

$$\frac{\partial J}{\partial \beta} = -2 X^T y + 2 X^T X \beta$$

Use these matrix calculus rules:
- $\frac{\partial}{\partial \beta}(\beta^T A) = A$
- $\frac{\partial}{\partial \beta}(\beta^T A \beta) = 2A\beta$ (when $A$ is symmetric; $X^T X$ always is)

**Step 3.** Set to zero and solve:

$$-2 X^T y + 2 X^T X \beta = 0$$
$$X^T X \beta = X^T y$$

These are the **normal equations**.

**Step 4.** Assuming $X^T X$ is invertible (no perfect multicollinearity):

$$\boxed{\hat{\beta}_{OLS} = (X^T X)^{-1} X^T y}$$

**Step 5.** Verify it's a minimum (SOC): the Hessian is $2 X^T X$, which is positive semi-definite → confirmed minimum.

### Exam-ready takeaways

- The closed form exists because the cost is **quadratic and convex** in $\beta$.
- $(X^T X)^{-1}$ exists ⇔ columns of $X$ are linearly independent ⇔ no perfect multicollinearity.
- Computationally, never invert $X^T X$ directly — use QR or SVD decomposition. (Numerical issue, not theoretical.)

---

## 2. Why Linear Regression Fails on Binary Targets

If $y \in \{0, 1\}$ and we fit $\hat{y} = \beta^T x$:

**Problem 1 — Range.** $\hat{y}$ can be any real number, but we want a probability in $[0, 1]$. Predictions like 1.7 or −0.4 are meaningless.

**Problem 2 — Linear relationship is wrong.** Going from $P = 0.50 \to 0.51$ is small. Going from $P = 0.98 \to 0.99$ doubles the *odds*. Linear regression treats both jumps as equally easy. Reality says the second is much harder.

**Problem 3 — Heteroscedasticity.** $\text{Var}(y \mid x) = p(x)(1 - p(x))$ depends on $x$. OLS assumes constant variance → standard errors and inference become invalid.

**Solution.** Squash the linear predictor through a sigmoid so output is always in $[0, 1]$, and reframe the linear relationship in **log-odds space** (where it actually is linear).

---

## 3. Logistic Regression — Deriving the Cost from MLE

### Setup

Model: $P(y = 1 \mid x) = \sigma(\beta^T x) = \frac{1}{1 + e^{-\beta^T x}}$.

Denote $\hat{p}_i = \sigma(\beta^T x_i)$. Then $P(y_i = 1 \mid x_i) = \hat{p}_i$ and $P(y_i = 0 \mid x_i) = 1 - \hat{p}_i$.

### Combine both cases into one expression

This trick is critical:

$$P(y_i \mid x_i) = \hat{p}_i^{y_i} (1 - \hat{p}_i)^{1 - y_i}$$

Check: if $y_i = 1$, RHS = $\hat{p}_i \cdot 1 = \hat{p}_i$. If $y_i = 0$, RHS = $1 \cdot (1 - \hat{p}_i) = 1 - \hat{p}_i$. ✅

### Likelihood

Assuming observations are i.i.d.:

$$L(\beta) = \prod_{i=1}^{n} \hat{p}_i^{y_i} (1 - \hat{p}_i)^{1 - y_i}$$

### Log-likelihood

Take log (products → sums, much friendlier):

$$\ell(\beta) = \sum_{i=1}^{n} \left[ y_i \log \hat{p}_i + (1 - y_i) \log(1 - \hat{p}_i) \right]$$

### From likelihood to cost

MLE: **maximize** $\ell(\beta)$. Equivalently, **minimize** $-\ell(\beta)$. Normalize by $n$ for the average:

$$\boxed{J(\beta) = -\frac{1}{n} \sum_{i=1}^{n} \left[ y_i \log \hat{p}_i + (1 - y_i) \log(1 - \hat{p}_i) \right]}$$

This is **binary cross-entropy** (also called log-loss).

### Why this and not MSE?

If you tried $J = \frac{1}{n}\sum (y_i - \hat{p}_i)^2$ with the sigmoid: the resulting cost is **non-convex** in $\beta$ → gradient descent gets stuck in local minima. Log-loss is **convex** → guaranteed global minimum.

---

## 4. Logistic Regression — Gradient of Log-Loss

Useful: the sigmoid derivative property:

$$\sigma'(z) = \sigma(z)(1 - \sigma(z))$$

### Derivation

Let $z_i = \beta^T x_i$ and $\hat{p}_i = \sigma(z_i)$.

$$\frac{\partial J}{\partial \beta} = -\frac{1}{n} \sum_i \left[ \frac{y_i}{\hat{p}_i} - \frac{1 - y_i}{1 - \hat{p}_i} \right] \cdot \frac{\partial \hat{p}_i}{\partial \beta}$$

Using $\frac{\partial \hat{p}_i}{\partial \beta} = \sigma'(z_i) \cdot x_i = \hat{p}_i (1 - \hat{p}_i) x_i$:

$$\frac{\partial J}{\partial \beta} = -\frac{1}{n} \sum_i \left[ \frac{y_i (1 - \hat{p}_i) - (1 - y_i) \hat{p}_i}{\hat{p}_i (1 - \hat{p}_i)} \right] \hat{p}_i (1 - \hat{p}_i) x_i$$

The $\hat{p}_i (1 - \hat{p}_i)$ cancels:

$$\frac{\partial J}{\partial \beta} = -\frac{1}{n} \sum_i (y_i - \hat{p}_i) x_i$$

$$\boxed{\nabla_\beta J = \frac{1}{n} \sum_i (\hat{p}_i - y_i) x_i = \frac{1}{n} X^T (\hat{p} - y)}$$

**Beautiful result:** the gradient has the same form as in linear regression — `feature times residual`. This is no accident; it falls out of the GLM framework.

### Gradient descent update

$$\beta^{(t+1)} = \beta^{(t)} - \eta \cdot \frac{1}{n} X^T (\hat{p}^{(t)} - y)$$

---

## 5. Softmax — Derivation & Cross-Entropy

### Setup

For $k$ classes, define $k$ linear predictors $z_j = \beta_j^T x$. We want $P(y = j \mid x)$ for each $j \in \{1, \dots, k\}$ such that:
1. Each is in $[0, 1]$
2. They sum to 1

### Softmax function

$$P(y = j \mid x) = \frac{e^{z_j}}{\sum_{l=1}^{k} e^{z_l}}$$

**Check property 1:** $e^{z_j} > 0$ and denominator is the sum of all $e^{z_l}$, so ratio is in $(0, 1)$. ✅
**Check property 2:** $\sum_j P(y = j) = \frac{\sum_j e^{z_j}}{\sum_l e^{z_l}} = 1$. ✅

### Relation to sigmoid

When $k = 2$: with one logit $z$ (set the other to 0):

$$P(y = 1) = \frac{e^z}{e^z + e^0} = \frac{e^z}{e^z + 1} = \frac{1}{1 + e^{-z}} = \sigma(z)$$

So **sigmoid is just softmax with $k = 2$**.

### Cross-entropy cost

Let $y_{ij}$ be 1 if observation $i$ is in class $j$, else 0 (one-hot encoding). The log-likelihood generalizes:

$$\ell = \sum_i \sum_j y_{ij} \log \hat{p}_{ij}$$

Cost (negative average log-likelihood):

$$\boxed{J = -\frac{1}{n} \sum_i \sum_j y_{ij} \log \hat{p}_{ij}}$$

This is **categorical cross-entropy**.

---

## 6. Bias-Variance Decomposition of MSE

> The single most likely derivation to appear on the exam. Write this one out three times before exam day.

### Setup

True data-generating process: $y = f(x) + \epsilon$, where $E[\epsilon] = 0$, $\text{Var}(\epsilon) = \sigma^2$.

We have an estimator $\hat{f}(x)$ trained on a random sample. Consider a fixed test point $x_0$.

**Expected test MSE:**

$$\text{MSE}(x_0) = E\left[(y_0 - \hat{f}(x_0))^2\right]$$

Expectation is over both the random training set (which makes $\hat{f}$ random) and the random noise $\epsilon$ in $y_0$.

### Derivation

**Step 1.** Substitute $y_0 = f(x_0) + \epsilon$:

$$E\left[(f(x_0) + \epsilon - \hat{f}(x_0))^2\right]$$

**Step 2.** Add and subtract $E[\hat{f}(x_0)]$ inside the brackets:

$$E\left[(f(x_0) - E[\hat{f}(x_0)] + E[\hat{f}(x_0)] - \hat{f}(x_0) + \epsilon)^2\right]$$

Let:
- $A = f(x_0) - E[\hat{f}(x_0)]$ → this is the **bias** (deterministic, constant)
- $B = E[\hat{f}(x_0)] - \hat{f}(x_0)$ → this has zero mean (variance-like)
- $C = \epsilon$ → noise, zero mean, independent of everything

**Step 3.** Expand $(A + B + C)^2 = A^2 + B^2 + C^2 + 2AB + 2AC + 2BC$ and take expectations:

- $E[A^2] = A^2 = (f(x_0) - E[\hat{f}(x_0)])^2 = \text{Bias}^2$
- $E[B^2] = E[(\hat{f}(x_0) - E[\hat{f}(x_0)])^2] = \text{Var}(\hat{f}(x_0))$
- $E[C^2] = \sigma^2$ (irreducible noise)
- $E[AB] = A \cdot E[B] = A \cdot 0 = 0$
- $E[AC] = A \cdot E[\epsilon] = 0$
- $E[BC] = E[B] \cdot E[\epsilon] = 0$ (independence + zero means)

**Step 4.** Combine:

$$\boxed{\text{MSE}(x_0) = \underbrace{(f(x_0) - E[\hat{f}(x_0)])^2}_{\text{Bias}^2} + \underbrace{\text{Var}(\hat{f}(x_0))}_{\text{Variance}} + \underbrace{\sigma^2}_{\text{Irreducible noise}}}$$

### Interpretation

| Component | What it measures | How to reduce |
|---|---|---|
| **Bias²** | Systematic error from wrong functional form | Use a more complex model |
| **Variance** | Sensitivity to the training sample | Use a simpler model, more data, **bagging**, regularization |
| **Noise** | Irreducible randomness in $y$ | **Cannot reduce** |

A more complex model lowers bias but raises variance. The sweet spot minimizes the sum.

---

## 7. SVM — Margin Width = 2/‖w‖

### Setup

Hyperplane: $w^T x + b = 0$. Two margin hyperplanes (the "edges of the street"):

- Positive margin: $w^T x + b = +1$
- Negative margin: $w^T x + b = -1$

(The 1 is just a scaling convention — we can always rescale $w$ and $b$ to make it so.)

### Derive the distance

Pick any point $x^+$ on the positive margin and any point $x^-$ on the negative margin. We want the distance between the two parallel hyperplanes — equivalently, the projection of the vector $(x^+ - x^-)$ onto the unit normal $w / \|w\|$.

**Step 1.** From margin definitions:

$$w^T x^+ + b = 1 \implies w^T x^+ = 1 - b$$
$$w^T x^- + b = -1 \implies w^T x^- = -1 - b$$

Subtract:

$$w^T (x^+ - x^-) = 2$$

**Step 2.** Project onto unit normal:

$$\text{margin width} = \frac{w^T (x^+ - x^-)}{\|w\|} = \frac{2}{\|w\|}$$

$$\boxed{\text{margin width} = \frac{2}{\|w\|}}$$

### Optimization problem

**Maximize margin** = maximize $\frac{2}{\|w\|}$ = minimize $\|w\|$ = minimize $\frac{1}{2}\|w\|^2$ (squaring keeps it convex and differentiable; the $\frac{1}{2}$ makes the derivative clean).

Subject to: all points correctly classified outside the margin:

$$y_i (w^T x_i + b) \ge 1 \quad \forall i$$

So the SVM (hard margin) optimization is:

$$\boxed{\min_{w, b} \frac{1}{2}\|w\|^2 \quad \text{s.t.} \quad y_i (w^T x_i + b) \ge 1, \;\; \forall i}$$

---

## 8. SVM — Lagrangian & Why Only Support Vectors Matter

### Lagrangian

Constrained optimization → introduce Lagrange multipliers $\alpha_i \ge 0$ for each constraint:

$$\mathcal{L}(w, b, \alpha) = \frac{1}{2}\|w\|^2 - \sum_i \alpha_i \left[ y_i (w^T x_i + b) - 1 \right]$$

### KKT conditions

Set partial derivatives to zero:

$$\frac{\partial \mathcal{L}}{\partial w} = w - \sum_i \alpha_i y_i x_i = 0 \implies \boxed{w = \sum_i \alpha_i y_i x_i}$$

$$\frac{\partial \mathcal{L}}{\partial b} = -\sum_i \alpha_i y_i = 0 \implies \boxed{\sum_i \alpha_i y_i = 0}$$

### The key insight — complementary slackness

A KKT condition: for each $i$,

$$\alpha_i \left[ y_i (w^T x_i + b) - 1 \right] = 0$$

This means **either**:
- $\alpha_i = 0$ (the point doesn't contribute to $w$), **or**
- $y_i (w^T x_i + b) = 1$ (the point sits exactly on the margin → it's a **support vector**)

So in $w = \sum_i \alpha_i y_i x_i$, only support vectors have $\alpha_i > 0$. **Everything else is discarded.** That's why SVM is memory-efficient — once trained, it only stores the support vectors.

### Dual problem

Substituting $w = \sum_i \alpha_i y_i x_i$ back into $\mathcal{L}$ yields the **dual**:

$$\max_\alpha \sum_i \alpha_i - \frac{1}{2}\sum_i \sum_j \alpha_i \alpha_j y_i y_j (x_i^T x_j)$$

subject to $\alpha_i \ge 0$ and $\sum_i \alpha_i y_i = 0$.

Two important things about the dual:
1. It's a **quadratic programming** problem in $\alpha$ — efficient solvers exist.
2. Training data appears **only as dot products $x_i^T x_j$** → opens the door to the kernel trick.

---

## 9. SVM — Why the Kernel Trick Works

### The problem

Some data isn't linearly separable in input space. Idea: map $x \mapsto \phi(x)$ into a higher-dimensional space where it becomes separable, then run linear SVM there.

The catch: $\phi(x)$ might be very high-dimensional (even infinite). Computing it explicitly is expensive or impossible.

### The trick

The SVM dual depends on training data **only through dot products** $x_i^T x_j$. In the lifted space, we'd need $\phi(x_i)^T \phi(x_j)$.

A **kernel** is a function $K(x_i, x_j) = \phi(x_i)^T \phi(x_j)$ that lets us compute that dot product **without ever computing $\phi$ explicitly**.

### Examples

| Kernel | $K(x, x')$ | Implicit $\phi$ |
|---|---|---|
| Linear | $x^T x'$ | identity |
| Polynomial (degree $d$) | $(x^T x' + c)^d$ | all polynomial features up to degree $d$ |
| RBF (Gaussian) | $\exp(-\gamma \|x - x'\|^2)$ | **infinite-dimensional**! |

### Why it's valid

Mercer's theorem: any symmetric positive semi-definite function $K$ corresponds to a valid inner product in **some** feature space. We don't need to know which space — we just need $K$ to satisfy Mercer's condition.

### Practical implications

- $\gamma$ in RBF: controls how localized each support vector's influence is.
	- Large $\gamma$ → narrow influence → can overfit (high variance).
	- Small $\gamma$ → broad influence → can underfit (high bias).
- Kernel choice + its hyperparameters → must be tuned via cross-validation.

---

## 10. KNN — Curse of Dimensionality (Intuition)

KNN works because "close in feature space" implies "similar label". In high dimensions, **nothing is close to anything**.

### Mini "proof" — volume of the unit cube

Consider $n$ points uniformly drawn in the $d$-dimensional unit hypercube $[0, 1]^d$. To capture a fraction $r$ of the data around a query point, you need a neighborhood of side length:

$$\ell = r^{1/d}$$

| $d$ | $r = 0.01$ (1% of data) | Neighborhood as % of feature range |
|---|---|---|
| 1 | $0.01^{1/1} = 0.01$ | 1% |
| 10 | $0.01^{1/10} \approx 0.63$ | **63%** |
| 100 | $0.01^{1/100} \approx 0.955$ | **95.5%** |

To find the 1% "nearest" neighbors in 100 dimensions, you have to scan 95.5% of each feature's range. **There is no local neighborhood any more.**

### Implications for KNN

- "Similar" loses meaning → KNN performance degrades sharply.
- All distances trend toward the same value → can't reliably rank neighbors.
- **Mitigations:** dimensionality reduction (PCA), feature selection, bagging (subspace methods), more data (exponentially more).
- **When KNN survives in high dim:** sparse data, image-like data with strong correlations across dimensions.

---

## 11. Gini & Entropy — Why They Measure Impurity

For a node with class proportions $p_1, p_2, \dots, p_k$:

### Gini impurity

$$G = 1 - \sum_{j=1}^{k} p_j^2 = \sum_{j \neq l} p_j p_l$$

**Interpretation:** probability of misclassifying a randomly chosen example if you label it according to the node's class distribution.

- All same class ($p_j = 1$ for some $j$) → $G = 0$ (pure).
- Two classes balanced ($p_1 = p_2 = 0.5$) → $G = 1 - 0.5 = 0.5$ (max impurity, binary case).

### Entropy

$$H = -\sum_{j=1}^{k} p_j \log_2 p_j$$

(Convention: $0 \log 0 = 0$.)

**Interpretation:** average number of bits needed to encode the class of a random example. Measures uncertainty.

- All same class → $H = 0$.
- Two classes balanced → $H = -0.5 \log_2 0.5 - 0.5 \log_2 0.5 = 1$ bit.

### Information gain (used for splitting)

$$\text{IG} = H(\text{parent}) - \sum_{c \in \text{children}} \frac{|c|}{|\text{parent}|} H(c)$$

The split that maximizes IG is chosen. Same idea with Gini.

### Gini vs entropy in practice

| | Gini | Entropy |
|---|---|---|
| Computational cost | Faster (no log) | Slower |
| Result quality | Very similar | Very similar |
| When they differ | Entropy slightly more sensitive to class probability changes | |

In practice, the choice rarely matters much. **Gini is the default in scikit-learn** for that reason.

---

## How to use this note for the exam

1. **Pick the top 3 derivations most likely to appear** — my bet: bias-variance decomposition, OLS closed form, logistic MLE → log-loss.
2. **Write each one out by hand 3x** without looking at the note. Slow first time, faster each round.
3. **Practice the "explain the intuition" version** of each. Many profs accept a clear conceptual proof if you frame the structure correctly (e.g., for bias-variance: "we add and subtract the expected estimator, expand the square, cross terms vanish because residual has zero mean…")
4. On exam day, if a derivation is asked, **always state assumptions first** (e.g., for OLS: linearity, no perfect multicollinearity), then proceed step by step.
