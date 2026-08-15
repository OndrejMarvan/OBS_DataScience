---
title: ML1 - Past Exam Practice (May 15, 2026)
course: 2400-DS1ML1
midterm_date: 2026-05-15
tags: [machine-learning, exam, practice, retake, midterm]
related: ["[[ML1_Midterm_Study_Notes]]", "[[ML1_Lab_Notes]]", "[[ML1_Code_CheatSheet]]"]
---

# ML1 — Past Exam Practice (May 15, 2026)

> **All 80 questions from Groups A/B/C/D of the original midterm**, with correct answers and short explanations. This is the highest-yield file for retake prep — the retake will likely draw from the same question bank with light rewording.

## How to use this file

1. **First pass (blind attempt):** cover the answer and explanation columns, work through each question, write your answer down.
2. **Compare:** check against the answer key. For every wrong or shaky answer, read the explanation carefully.
3. **Cross-reference:** each question links to the concept file where the topic is explained.
4. **Second pass 2-3 days later:** re-do only the ones you got wrong.

**Pass mark:** 11/20 (55%). To be safe on retake, aim for 17+/20 on this practice.

**Score tracking template** (fill in after each attempt):

| Attempt | Date | Group A | Group B | Group C | Group D | Overall |
|---|---|---|---|---|---|---|
| 1 | | ___/20 | ___/20 | ___/20 | ___/20 | ___/80 |
| 2 | | ___/20 | ___/20 | ___/20 | ___/20 | ___/80 |

---

## Answer key summary (single-line view)

```
Group A:  B D A B C A D B C D  C A C A C D B D A B
Group B:  B A C D B A B C B C  D C A D A D A C D B
Group C:  D C A B C D B C D B  A D A C B D B A C A
Group D:  A C D C D A C D B A  B C B D B A C B D A
```

---

# GROUP A

## A1. What does a *supervised* learning task require? → **B**

A. Unlabeled inputs only, with no target information
B. **Labeled examples with known input-output pairs** ✅
C. A clustering routine that creates the targets internally
D. A reinforcement signal from interaction with an environment

**Why:** Supervised learning is defined by having labeled (X, y) pairs. A = unsupervised. C = self-generated labels are still not "supervised" in the strict sense (that's self-supervised). D = reinforcement learning.

## A2. Which problem is a *regression* task? → **D**

A. Predicting whether an incoming email is spam (classification)
B. Grouping customers into segments without labels (clustering)
C. Choosing the next action in a board game (reinforcement)
D. **Predicting tomorrow's stock return as a real number** ✅

**Why:** Regression = continuous numeric target. Real-valued stock return fits.

## A3. Which set is used to *fit* the model parameters? → **A**

A. **Training set** ✅
B. Validation set (tuning hyperparameters)
C. Test set (final unbiased evaluation)
D. Production data (deployment)

**Why:** Parameters (weights, coefficients) are estimated on the training set. Validation is for hyperparameter choice; test is untouched until the end.

## A4. The sigmoid function in logistic regression outputs: → **B**

A. The raw linear combination of the input features (that's the logit, before sigmoid)
B. **A number in (0, 1), interpreted as a probability** ✅
C. The signed distance to the SVM separating margin (SVM concept)
D. An integer class label after applying a threshold (that's after argmax/threshold)

**Why:** $\sigma(z) = 1/(1+e^{-z}) \in (0, 1)$ — interpretable as $P(y = 1 \mid x)$.

## A5. Which metric is appropriate for a *regression* problem? → **C**

A. F1-score (classification)
B. ROC AUC (classification)
C. **Mean Squared Error** ✅
D. Precision (classification)

## A6. Why can accuracy be misleading on an imbalanced dataset? → **A**

A. **A majority-class predictor can still reach high accuracy** ✅
B. The metric is not differentiable on the logit scale (irrelevant — no metric is used for training gradients)
C. Its value depends on decision threshold and calibration (partly true but not the core issue)
D. It penalizes FPs more than FNs (accuracy weighs both equally)

**Why:** In a 99:1 dataset, predicting "always majority" gives 99% accuracy — a useless model can look great.

## A7. SMOTE balances classes primarily by: → **D**

A. Randomly dropping majority samples (that's random undersampling)
B. Increasing L2 regularization (unrelated)
C. Computing class weights (that's class_weight='balanced')
D. **Synthesizing minority samples between nearest neighbors in feature space** ✅

**Why:** SMOTE creates new points as convex combinations of a minority point and its k nearest minority neighbors.

## A8. As k in K-Nearest Neighbors is increased, the model tends to: → **B**

A. Overfit more and have higher variance (small k does this)
B. **Produce smoother boundaries with higher bias** ✅
C. Become more sensitive to outliers (small k does this)
D. Ignore feature scales (KNN never ignores scales — that's why scaling matters)

**Why:** Larger k → averaging over more neighbors → smoother, more biased boundary.

## A9. In SVM, the regularization parameter C controls: → **C**

A. RBF kernel width (that's gamma)
B. Kernel family choice (that's the `kernel` parameter)
C. **Trade-off between margin width and training errors** ✅
D. Number of support vectors (auto-determined; not directly controlled)

**Why:** Small C → wide margin, more errors tolerated. Large C → narrow margin, fewer errors allowed.

## A10. The main purpose of k-fold cross-validation is to: → **D**

A. Enlarge training data (it doesn't — same data, rearranged)
B. Replace test set (never — you still need one)
C. Make training deterministic (CV adds randomness)
D. **Obtain a more reliable estimate of out-of-sample error** ✅

## A11. The curse of dimensionality hurts KNN because, in high dimensions: → **C**

A. KNN defaults to Manhattan (false)
B. Cosine replaces Euclidean automatically (false)
C. **Nearest-neighbor distances become nearly equal and lose information** ✅
D. Feature scaling matters less (opposite — scaling is always essential)

## A12. How does L1 (Lasso) differ from L2 (Ridge)? → **A**

A. **L1 can drive some coefficients exactly to zero, enabling feature selection** ✅
B. L1 shrinks proportionally like L2 (false — L1 induces sparsity)
C. L2 yields sparse vectors (false — L2 shrinks but doesn't zero)
D. L2 requires subgradient methods (false — L2 is smooth, has closed form)

## A13. Bagging (Bootstrap Aggregating) primarily aims to: → **C**

A. Increase bias via depth restriction (no — bagging targets variance)
B. Replace CV with bootstrapping (no)
C. **Reduce ensemble variance by averaging bootstrap-trained models** ✅
D. Sequentially update residuals (that's boosting)

## A14. In an RBF-kernel SVM, γ controls: → **A**

A. **The reach of a single training point's influence on predictions** ✅
B. Same as C (no — γ is kernel scale, C is regularization)
C. Number of SVs (no — auto-determined)
D. Loss function family (no — hinge in all cases)

**Why:** Large γ → each point influences only a tiny neighborhood → wiggly boundary. Small γ → smooth boundary.

## A15. Stratified k-fold is preferred over plain k-fold when: → **C**

A. Classes perfectly balanced (unnecessary then)
B. Regression on real-line target (no — stratification is for categorical y)
C. **Classes are imbalanced and proportions should hold per fold** ✅
D. No temporal order (unrelated — that's about TimeSeriesSplit)

## A16. Nested cross-validation is used primarily to: → **D**

A. Parallelize (parallelization is a side benefit, not the purpose)
B. Replace stratification (unrelated)
C. Avoid inner-loop preprocessing (backwards)
D. **Give an unbiased generalization estimate after hyperparameter tuning** ✅

## A17. Standard random k-fold CV is inappropriate for time-series because: → **B**

A. sklearn doesn't support it (false — it just shouldn't be used)
B. **Random folds mix future data into training, leaking information** ✅
C. Class labels can't be stratified (unrelated)
D. MSE undefined on time-ordered samples (false)

## A18. A classifier where predicted probability of 0.9 corresponds to only 60% empirical positives is: → **D**

A. Perfectly calibrated (definitely not — 90% ≠ 60%)
B. Accurate at all thresholds (no)
C. Affected by imbalance not miscalibration (no — this IS miscalibration)
D. **Over-confident and can be repaired by Platt scaling or isotonic regression** ✅

## A19. The kernel trick in the dual SVM allows: → **A**

A. **Computing inner products in a high-dimensional space without an explicit map** ✅
B. Removing SVs (no — kernel trick doesn't do that)
C. Turning any non-linear kernel into linear via coord change (false — impossible in general)
D. Replacing margin with softmax (no)

## A20. Concept drift differs from data (covariate) drift because: → **B**

A. Same phenomenon (no — different definitions)
B. **Data drift changes P(X); concept drift changes P(Y | X)** ✅
C. Concept drift only in training (no — occurs in production)
D. Data drift is unmeasurable (false — cheap to detect)

---

# GROUP B

## B1. A classification task differs from a regression task because: → **B**

A. Higher learning rate (unrelated)
B. **Its target variable takes categorical values instead of continuous ones** ✅
C. Every input feature must be one-hot encoded (false)
D. Loss surface is convex vs regression's non-convex (false — both can be either)

## B2. In ML vocabulary, a *feature* is: → **A**

A. **An input variable used to predict the target** ✅
B. A hyperparameter (that's a different thing)
C. A regularization term (that's a penalty)
D. A component of the loss function (that's the loss)

## B3. The *validation* set is primarily used to: → **C**

A. Fit final model parameters (that's training set)
B. Provide unbiased final estimate (that's test set)
C. **Tune hyperparameters and compare candidate models** ✅
D. Compute gradient during backprop (that's training set)

## B4. The standard training loss of logistic regression is: → **D**

A. Mean squared error (that's linear regression)
B. Hinge loss (that's SVM)
C. 0-1 loss (not differentiable — not used for training)
D. **Binary cross-entropy (log-loss)** ✅

## B5. The F1-score is: → **B**

A. Arithmetic mean of precision and recall (no — that's just their average, not F1)
B. **Harmonic mean of precision and recall** ✅
C. Equal to accuracy when classes balanced (no — different metrics)
D. Area under ROC (no — that's AUC)

**Why:** $F_1 = 2 \cdot \frac{P \cdot R}{P + R}$ — harmonic mean.

## B6. Training error low but validation error much higher indicates: → **A**

A. **Overfitting and high variance** ✅
B. Underfitting (would have BOTH errors high)
C. Perfect calibration (unrelated)
D. Leakage-free (opposite — could suggest overfitting, not calibration)

## B7. One-hot encoding is most appropriate for: → **B**

A. Continuous numeric on comparable scale (no — that's scaling territory)
B. **Nominal (unordered) categorical variables** ✅
C. Ordinal variables (that's ordinal encoding)
D. Time-stamps (that's temporal features)

## B8. Combining oversampling with cleaning (SMOTE + Tomek links) is known as: → **C**

A. Random oversampling (no)
B. Class weighting (no)
C. **Hybrid resampling (SMOTE-Tomek / SMOTEENN)** ✅
D. Stacking resamplers (no — that's ensembling term)

## B9. Min-max scaling transforms features to: → **B**

A. Zero mean, unit variance (that's z-score)
B. **A bounded range, typically [0, 1]** ✅
C. Integer buckets (that's discretization)
D. Rank-based percentiles (that's quantile transformer)

## B10. ROC AUC measures: → **C**

A. Accuracy at 0.5 threshold across folds (no — AUC is threshold-independent)
B. Precision when recall = 100% (no)
C. **The quality of ranking positives versus negatives across thresholds** ✅
D. MSE of probabilities (that's Brier score)

**Interpretation:** AUC = probability that a random positive scores higher than a random negative.

## B11. According to bias-variance trade-off, increasing model flexibility usually: → **D**

A. Raises both (rarely — usually opposite trade)
B. Lowers both (only up to a point; the whole idea is trade-off)
C. No relationship (wrong)
D. **Lowers bias while raising variance** ✅

## B12. Which statement about Ridge (L2) regression is correct? → **C**

A. Enforces sparsity by zeroing small entries (that's L1)
B. No closed-form solution (false — Ridge HAS a closed form)
C. **It shrinks coefficients toward zero without setting any to zero** ✅
D. Invariant to feature scale (false — Ridge is scale-sensitive; SCALE FIRST)

## B13. In CalibratedClassifierCV, setting method='isotonic' fits: → **A**

A. **A non-parametric piecewise calibration map on classifier scores** ✅
B. Parametric sigmoid via Newton's method (that's Platt scaling)
C. Linear regression on labels (nonsense)
D. Bayesian posterior over calibration parameters (no)

## B14. A soft-margin SVM introduces slack variables in order to: → **D**

A. Eliminate C (opposite — soft margin exists because of C)
B. Simplify to closed form (no — still QP)
C. Replace kernel with explicit map (unrelated)
D. **Allow some points inside the margin, traded off against C** ✅

## B15. Grid search vs random search: → **A**

A. **Grid explores a fixed discrete grid; random samples from a distribution** ✅
B. Random converges more slowly (opposite — random is often faster in high dim)
C. Grid bypasses CV (false — both use CV)
D. Random is reproducible without a seed (false — needs seed)

## B16. In an imbalanced classification pipeline, resampling should be applied: → **D**

A. Before the split, on combined data (LEAKAGE — worst option)
B. After model fit (wrong order)
C. Only when class weighting unavailable (false — both are valid options)
D. **Only within the training fold of each CV split, to avoid leakage** ✅

## B17. Under standard assumptions, Gauss-Markov states OLS is: → **A**

A. **The minimum-variance unbiased linear estimator (BLUE)** ✅
B. MLE under Gaussian errors (that's a different theorem — MLE property)
C. Optimal under heteroskedasticity (false — Gauss-Markov requires homoskedasticity)
D. Biased but asymptotically efficient (false — OLS is unbiased)

## B18. Recursive Feature Elimination (RFE) selects features by: → **C**

A. Ranking once by correlation (that's univariate filter)
B. Random subsets each iteration (that's bagging-style)
C. **Iteratively fitting an estimator and removing the least important feature** ✅
D. Adding features by information gain (that's forward selection)

## B19. Bayesian hyperparameter search (BayesSearchCV) differs from random search because it: → **D**

A. Evaluations completely independent (opposite — Bayesian uses history)
B. Skips CV with GP prior (false)
C. Lower per-evaluation cost (false — more expensive per eval)
D. **Uses a probabilistic surrogate model to propose the next configuration** ✅

## B20. The Brier score for binary classification is: → **B**

A. Arithmetic mean of probabilities (nonsense)
B. **The mean squared error between predicted probabilities and outcomes** ✅
C. Identical to log-loss (false — different formulas)
D. Only for perfect models (false — well-defined for any classifier)

**Formula:** $BS = \frac{1}{N} \sum (p_i - y_i)^2$

---

# GROUP C

## C1. Which is an example of *unsupervised* learning? → **D**

A. Predicting house prices (supervised regression)
B. Labeling emails with labeled training set (supervised classification)
C. Predicting credit default from labeled data (supervised classification)
D. **Clustering customers by purchase behavior without any labels** ✅

## C2. The *test* set should be used: → **C**

A. During training to update weights (that's training set)
B. To tune hyperparameters (that's validation set)
C. **At the very end, to estimate the generalization error** ✅
D. At every epoch to compute gradient (that's training set)

## C3. Ordinary Least Squares minimizes: → **A**

A. **The sum of squared residuals** ✅
B. Sum of absolute residuals (that's LAD regression)
C. Cross-entropy (that's logistic regression)
D. Decision margin (that's SVM)

## C4. Which is a *classification* metric? → **B**

A. R² (regression)
B. **Precision** ✅
C. MAE (regression)
D. MSE (regression)

## C5. An outlier-robust scaler is: → **C**

A. StandardScaler (uses mean & std — sensitive to outliers)
B. MinMaxScaler (extremely sensitive — min/max are outliers by definition)
C. **RobustScaler (median and IQR scaling)** ✅
D. Log Scaler (technically a transformation, not a scaler in outlier-robust sense — though useful for right-skewed data, not the intended answer here)

## C6. Overfitting can be mitigated by: → **D**

A. Increasing complexity (opposite)
B. Removing validation set (unrelated)
C. Training more epochs after plateau (opposite)
D. **Adding regularization, using more data, or proper cross-validation** ✅

## C7. Target encoding replaces a categorical value with: → **B**

A. Random integer (nonsense)
B. **A statistic of the target conditional on the category** ✅
C. One-hot indicator vector (that's one-hot encoding)
D. String character length (nonsense)

## C8. Which method generates synthetic minority samples by interpolating? → **C**

A. Random undersampling (removes majority)
B. Tomek links (removes majority near boundary)
C. **SMOTE** ✅
D. Class weighting (loss modification only)

## C9. Euclidean distance in KNN requires that: → **D**

A. Features are ordinal (false)
B. Target is continuous (false)
C. Data is linearly separable (false)
D. **The features are on comparable numeric scales** ✅

## C10. Precision is defined as: → **B**

A. TP/(TP + FN) (that's recall)
B. **TP/(TP + FP)** ✅
C. TN/(TN + FP) (that's specificity)
D. (TP + TN)/total (that's accuracy)

## C11. The `validation_curve` function plots: → **A**

A. **Training and validation scores as a function of one hyperparameter** ✅
B. Scores vs training-set size (that's `learning_curve`)
C. Fold count vs metric (nonsense)
D. Cumulative gain from adding features (that's feature importance)

## C12. Elastic Net combines: → **D**

A. Voting and bagging (unrelated)
B. Logistic and linear regression (unrelated)
C. Ridge and LASSO in sequence (no — combined in single objective)
D. **L1 and L2 penalties combined in a single regularization objective** ✅

**Formula:** $\alpha \cdot L_1 + (1 - \alpha) \cdot L_2$

## C13. Stacking combines base learners by: → **A**

A. **Training a meta-learner on the base models' predictions** ✅
B. Sequentially reweighting examples (that's boosting)
C. Choosing single best estimator (that's model selection, not ensembling)
D. Deterministic majority vote (that's hard voting)

## C14. When false negatives are more costly than false positives, a sensible metric is: → **C**

A. Plain accuracy (misses cost asymmetry)
B. F1 with β=1 (weighs P and R equally)
C. **Fβ with β > 1, weighting recall above precision** ✅
D. ROC AUC across all thresholds (doesn't reflect asymmetric cost either)

## C15. In logistic regression, $\beta_j$ is interpreted as: → **B**

A. Direct change in probability per unit (false — that's marginal effect, non-constant)
B. **Change in the log-odds of the positive class per unit of x_j** ✅
C. Slope of CDF at mean (nonsense)
D. Variance of x_j (nonsense)

## C16. TimeSeriesSplit differs from KFold because it: → **D**

A. Shuffles samples (opposite — never shuffles time series)
B. Stratifies by class (that's StratifiedKFold)
C. Bootstrap samples (that's bagging)
D. **Uses expanding training windows followed by a future validation block** ✅

## C17. Data leakage occurs when: → **B**

A. Imputation during preprocessing (imputation alone isn't leakage — done inside pipeline is fine)
B. **Information from outside the training set leaks into the model fit** ✅
C. Model is over-regularized (that's underfitting, not leakage)
D. CV is used to estimate performance (opposite — CV prevents leakage if done right)

## C18. Multi-collinearity between features in OLS mainly: → **A**

A. **Inflates the variance of the estimated coefficients** ✅
B. Reduces RSS to zero (false — doesn't affect fit quality)
C. Lowers bias (OLS is unbiased regardless; multicollinearity affects variance)
D. Forces rank one (only PERFECT collinearity, not multi-collinearity)

## C19. The Wasserstein distance is used in ML monitoring to: → **C**

A. Compress datasets (no)
B. Direct classification without a model (no)
C. **Quantify how much two distributions differ, useful for drift detection** ✅
D. Replace CV (no)

## C20. Isotonic regression, used as a calibration step: → **A**

A. **Fits a monotonic non-parametric mapping from scores to probabilities** ✅
B. Always outperforms Platt (false — depends on data size)
C. Requires linear classifier (false)
D. Parametric sigmoid (that's Platt, not isotonic)

---

# GROUP D

## D1. The dataset used to *fit* model parameters is the: → **A**

A. **Training set** ✅
B. Validation set (tuning)
C. Test set (final eval)
D. Production set (deployment data)

## D2. A *binary* classification problem has: → **C**

A. Continuous target (that's regression)
B. No labels (that's unsupervised)
C. **Exactly two possible class labels** ✅
D. Unbounded continuous output (nonsense for classification)

## D3. Mean Absolute Error (MAE) is: → **D**

A. Classification metric (false — MAE is regression)
B. Equal to MSE (false — different formulas)
C. Undefined for continuous targets (opposite — it's designed for them)
D. **The mean of absolute prediction-target differences** ✅

**Formula:** $\text{MAE} = \frac{1}{n}\sum |y_i - \hat{y}_i|$

## D4. Feature scaling matters *most* for: → **C**

A. Threshold-based tree splits (they're scale-invariant)
B. Constant-only predictors (no features used)
C. **Algorithms that compute distances or gradients in input space (KNN, SVM-RBF)** ✅
D. Memorization estimators (that would be KNN-like — but the answer here specifies KNN by name)

## D5. Logistic regression predicts: → **D**

A. A regression coefficient per feature (that's the parameters, not the prediction)
B. Class labels via rules (no — it's learned from data)
C. Only binary features after threshold (nonsense — features can be any type)
D. **A class probability via sigmoid of a linear combination** ✅

## D6. Recall (sensitivity) is defined as: → **A**

A. **TP/(TP + FN)** ✅
B. TP/(TP + FP) (that's precision)
C. TN/(TN + FP) (that's specificity)
D. (TP + FP)/total (nonsense)

## D7. The main reason to use a scikit-learn Pipeline is: → **C**

A. Tune hyperparameters automatically (not the main reason — GridSearchCV does that)
B. Speed up inference (not really — pipelines add small overhead)
C. **To chain preprocessing with the estimator and prevent fold leakage** ✅
D. Avoid CV during model selection (false — pipelines work WITH CV)

## D8. Applying z-score normalization yields values with: → **D**

A. Bounded [0, 1] (that's min-max)
B. Integer percentiles (that's quantile)
C. Log-shift (that's log transform)
D. **A mean of zero and a variance of one across samples** ✅

## D9. Setting `class_weight='balanced'` in sklearn: → **B**

A. Duplicates minority samples (that's random oversampling)
B. **Weights the loss inversely to class frequencies in training** ✅
C. Removes majority samples (that's undersampling)
D. Requires SMOTE beforehand (false — completely independent mechanism)

**Formula:** $w_c = n / (K \cdot n_c)$ where $n_c$ = class $c$ count, $K$ = number of classes.

## D10. A hard-voting classifier predicts: → **A**

A. **The majority class among the base estimators' predictions** ✅
B. Highest average probability (that's SOFT voting)
C. From single most accurate model (that's model selection)
D. Weighted by class frequency (unrelated)

## D11. The dual formulation of SVM is useful mainly when: → **B**

A. Fewer features than samples (opposite — primal is fine)
B. **One wants to apply the kernel trick for non-linear boundaries** ✅
C. Skip CV (unrelated)
D. Only linear kernels available (opposite — dual enables NON-linear)

## D12. Learning curves (error vs training-set size) can diagnose: → **C**

A. Only optimal kernel (no — narrower than "underfit vs overfit")
B. Only random seed effect (no)
C. **Underfitting (errors high and close) versus overfitting (large gap)** ✅
D. Whether stratification is needed (no — that's a fold-composition issue)

## D13. Variance Threshold feature selection removes features: → **B**

A. Most correlated with target (that's supervised univariate selection)
B. **Whose sample variance falls below a chosen threshold** ✅
C. Selected by forward stepwise (that's wrapper method)
D. With missing values after imputation (that's imputation-related, not variance threshold)

## D14. Why is log-loss a *proper* scoring rule? → **D**

A. Rewards any confident prediction (no — punishes CONFIDENT WRONG)
B. Equals zero for optimal training model (not the definition)
C. Ignores sign of error (false — sign matters)
D. **Because it is minimized in expectation by the true conditional probability** ✅

**Meaning:** proper scoring rule ↔ predicting the true $P(Y \mid X)$ gives the lowest expected score.

## D15. A fully *calibrated* classifier means that: → **B**

A. Decision threshold is 0.5 (unrelated — that's an operating point choice)
B. **Among predictions with probability p, about a fraction p are positive** ✅
C. Accuracy maximized over threshold (that's separately optimizable)
D. Precision = recall at every threshold (unrelated)

## D16. The `cross_val_score` function returns: → **A**

A. **An array of per-fold test scores** ✅
B. Mean score as single float (no — that's what you compute afterward)
C. The fitted estimator (no)
D. Optimal hyperparameters (no — that's GridSearchCV)

## D17. Adding a *missing indicator* column is useful because: → **C**

A. Imputation introduces bias (partly true, but not why the indicator helps)
B. Standardizes the column (false)
C. **The missingness pattern itself may carry predictive information** ✅
D. Acts as regularization (false)

## D18. In an RBF-kernel SVM, setting γ very *high* tends to: → **B**

A. Smoother boundary, underfit (opposite — low γ does that)
B. **Limit each training point's influence to a tight neighborhood (overfitting risk)** ✅
C. Equivalent to linear kernel (false)
D. Increase margin proportionally (unrelated to γ directly)

## D19. Compared with MSE, MAE as a loss function: → **D**

A. Squares each error (opposite — MSE does)
B. Smooth gradient at zero (false — MAE gradient is discontinuous at zero)
C. Equals MSE with Gaussian residuals (false — they never coincide algebraically)
D. **Is more robust to outliers in the target variable** ✅

## D20. In Platt scaling, calibration is obtained by: → **A**

A. **Fitting a logistic regression on classifier scores against true labels** ✅
B. Replacing softmax (false)
C. Rescaling features (unrelated to calibration)
D. Removing intercept (irrelevant)

---

## Topics you MUST know cold for retake

Based on the 80 questions above, the exam disproportionately tests:

| Topic | Group A | Group B | Group C | Group D | Total appearances |
|---|---|---|---|---|---|
| **Confusion matrix metrics** (precision, recall, F1) | 5 | 5, 10 | 4, 10, 14 | 6 | 8 |
| **Regularization** (L1/L2/EN, Ridge/Lasso) | 12 | 12 | 12 | — | 4 |
| **Feature scaling** (min-max, z-score, robust) | — | 9 | 5, 9 | 4, 8 | 5 |
| **Class rebalancing / imbalance** | 6, 7, 15 | 8, 16 | 8 | 9 | 7 |
| **KNN specifics** | 8, 11 | — | 9 | — | 3 |
| **SVM specifics** (C, γ, kernel, dual) | 9, 14, 19 | 14 | — | 11, 18 | 6 |
| **Logistic regression** | 4 | 4 | 15 | 5 | 4 |
| **Cross-validation variants** | 10, 15, 16, 17 | 16 | 16 | — | 6 |
| **Calibration** (Platt, isotonic, Brier) | 18 | 13, 20 | 20 | 20 | 5 |
| **Feature selection** | — | 18 | — | 13 | 2 |
| **Drift detection** | 20 | — | 19 | — | 2 |
| **Ensembles** (bagging, stacking, voting) | 13 | — | 13 | 10 | 3 |
| **Hyperparameter search** | — | 15, 19 | — | — | 2 |
| **Bias-variance & over/underfitting** | — | 6, 11 | 6 | 12 | 4 |
| **Basic definitions** (supervised, feature, y-type) | 1, 2 | 1, 2, 3 | 1, 2, 4 | 1, 2, 3, 5 | 12 |
| **Data leakage / pipelines** | — | 16 | 17 | 7, 17 | 4 |
| **Multi-collinearity / OLS assumptions** | — | 17 | 18 | — | 2 |

**Definitions and foundational concepts (12 appearances)** are essentially free points — memorize them cold.

**High-value study areas ranked by exam frequency:**

1. **Confusion matrix + P/R/F1** (8) — write out formulas from memory in 30 seconds
2. **Class rebalancing** (7) — SMOTE, class_weight, hybrid, inside-fold
3. **CV variants** (6) — K-fold, stratified, nested, time-series
4. **SVM parameters** (6) — C, γ, kernel, dual formulation
5. **Calibration** (5) — Platt vs isotonic, Brier
6. **Feature scaling** (5)
7. **Regularization** (4)

---

## Trap patterns to recognize

Looking at the wrong answer choices across all 80 questions, distractors tend to fall into a few classes:

**Class 1: "Swap two similar concepts"** — precision vs recall, MSE vs MAE, one-hot vs ordinal, Platt vs isotonic, gamma vs C, bagging vs boosting, hard vs soft voting, sigmoid output vs logit. Learn each pair as one flashcard, not two.

**Class 2: "Wrong dataset use"** — training set used for what validation set does, validation used for what test does, etc. The train→val→test hierarchy is tested repeatedly.

**Class 3: "Says the reverse of the truth"** — "L2 gives sparsity" (nope, L1 does), "L2 has no closed form" (nope, Ridge has one), "min-max gives mean 0 var 1" (nope, that's z-score). Pattern: whenever the answer is definitively true, one distractor states its opposite.

**Class 4: "Almost right but too narrow / too general"** — "accuracy misleading because threshold-dependent" (partly true, but not the CORE reason on imbalanced data). Read all four before choosing.

**Class 5: "Nonsense buzzwords"** — one distractor mixes correct terms in wrong ways ("Bayesian posterior over calibration parameters"). If it sounds impressive but doesn't quite parse, it's the trap.

---

## Retake strategy (based on 80-question analysis)

**Time discipline (20 minutes for 20 questions):**
- 30 seconds per easy definitional question (Q1-3 typically)
- 60 seconds per medium (most)
- 90 seconds max for hard ones — flag & move on
- 3 minutes for final review

**Confidence banding (write next to each answer):**
- ✓✓ = certain
- ✓ = likely correct
- ? = guessed

For every `?` do a second pass at the end. Eliminate two distractors even if you can't get to one.

**Priority reading list (retake week):**
1. [[ML1_Past_Exam_Practice]] — this file (2 hours)
2. [[ML1_Lab_Notes]] — lab-specific concepts (1 hour)
3. [[ML1_Exam_Day_QuickRef]] — the morning of (30 min)

**One-hour version if time is tight:** just re-read this file cover to cover.

---

Good luck on the retake, Ondřej. This time you have the whole question bank in your pocket. 🍀
