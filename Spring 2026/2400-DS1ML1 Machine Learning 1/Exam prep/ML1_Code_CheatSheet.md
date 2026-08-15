---
title: ML1 - Code Cheat Sheet (sklearn / imblearn / skopt / statsmodels)
course: 2400-DS1ML1
tags: [machine-learning, python, sklearn, cheatsheet, midterm]
related: ["[[ML1_Lab_Notes]]", "[[ML1_Past_Exam_Practice]]"]
---

# ML1 — Code Cheat Sheet

> **Why this note exists:** The exam has multiple questions that test specific sklearn API behavior (`cross_val_score` returns what? `class_weight='balanced'` does what? `method='isotonic'` fits what?). This file catalogues the APIs the labs use, grouped by the topic they test.

## Contents

- [[#1 Imports (Standard Set)]]
- [[#2 Data Loading & Splitting]]
- [[#3 Feature Scaling]]
- [[#4 Categorical Encoding]]
- [[#5 Imputation]]
- [[#6 ColumnTransformer]]
- [[#7 Pipelines (sklearn vs imblearn)]]
- [[#8 KNN]]
- [[#9 SVM & SVR]]
- [[#10 Linear Regression]]
- [[#11 Logistic Regression]]
- [[#12 Regularized Regression]]
- [[#13 statsmodels (Inference)]]
- [[#14 Cross-Validation]]
- [[#15 Hyperparameter Search]]
- [[#16 Class Rebalancing]]
- [[#17 Feature Selection]]
- [[#18 Ensembles]]
- [[#19 Calibration]]
- [[#20 Evaluation Metrics]]
- [[#21 Drift Detection]]
- [[#22 Common Gotchas & API Quirks]]

---

## 1. Imports (Standard Set)

```python
# Core
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Sklearn core
from sklearn.model_selection import (
    train_test_split, cross_val_score, cross_validate,
    KFold, StratifiedKFold, LeaveOneOut, LeavePOut,
    RepeatedKFold, RepeatedStratifiedKFold,
    TimeSeriesSplit, GroupKFold,
    GridSearchCV, RandomizedSearchCV,
    validation_curve, learning_curve,
)
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.compose import ColumnTransformer

# Preprocessing
from sklearn.preprocessing import (
    StandardScaler, MinMaxScaler, RobustScaler,
    QuantileTransformer, PowerTransformer,
    OneHotEncoder, OrdinalEncoder, TargetEncoder, LabelEncoder,
    KBinsDiscretizer, PolynomialFeatures, SplineTransformer,
)
from sklearn.impute import SimpleImputer, KNNImputer, MissingIndicator
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer

# Models
from sklearn.linear_model import (
    LinearRegression, LogisticRegression,
    Ridge, Lasso, ElasticNet,
    RidgeCV, LassoCV, ElasticNetCV, LogisticRegressionCV,
)
from sklearn.neighbors import KNeighborsClassifier, KNeighborsRegressor
from sklearn.svm import SVC, SVR, LinearSVC
from sklearn.tree import DecisionTreeClassifier, DecisionTreeRegressor
from sklearn.ensemble import (
    RandomForestClassifier, RandomForestRegressor,
    BaggingClassifier, VotingClassifier, StackingClassifier,
    AdaBoostClassifier, GradientBoostingClassifier,
)

# Feature selection
from sklearn.feature_selection import (
    VarianceThreshold, SelectKBest, SelectPercentile,
    f_classif, chi2, mutual_info_classif,
    f_regression, mutual_info_regression,
    RFE, RFECV, SequentialFeatureSelector, SelectFromModel,
)

# Calibration
from sklearn.calibration import CalibratedClassifierCV, calibration_curve

# Metrics
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score, fbeta_score,
    confusion_matrix, classification_report, matthews_corrcoef,
    roc_auc_score, roc_curve, precision_recall_curve, average_precision_score,
    log_loss, brier_score_loss,
    mean_squared_error, mean_absolute_error, r2_score,
    mean_absolute_percentage_error, median_absolute_error,
)

# Imbalanced-learn
from imblearn.pipeline import Pipeline as ImbPipeline
from imblearn.over_sampling import (
    RandomOverSampler, SMOTE, BorderlineSMOTE, SVMSMOTE, KMeansSMOTE, ADASYN,
)
from imblearn.under_sampling import (
    RandomUnderSampler, TomekLinks, EditedNearestNeighbours,
    RepeatedEditedNearestNeighbours, ClusterCentroids,
)
from imblearn.combine import SMOTETomek, SMOTEENN

# Bayesian search
from skopt import BayesSearchCV
from skopt.space import Real, Integer, Categorical

# Statsmodels (for inference)
import statsmodels.api as sm
import statsmodels.formula.api as smf
```

---

## 2. Data Loading & Splitting

```python
# Toy datasets from sklearn
from sklearn.datasets import (
    load_iris, load_diabetes, load_wine, load_breast_cancer,
    make_classification, make_regression, make_blobs,
)
iris = load_iris()
X, y = iris.data, iris.target

# Read from disk
df = pd.read_csv('data.csv')
X = df.drop('target', axis=1)
y = df['target']

# Basic split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Stratified split (for classification with imbalanced classes)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y  # <— KEY
)

# Three-way split (train/val/test)
X_temp, X_test, y_temp, y_test = train_test_split(X, y, test_size=0.2, stratify=y)
X_train, X_val, y_train, y_val = train_test_split(X_temp, y_temp, test_size=0.25, stratify=y_temp)
# 60/20/20 split
```

---

## 3. Feature Scaling

```python
# Standard (z-score): mean=0, std=1
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
scaler.fit(X_train)                    # learn μ, σ from training
X_train_scaled = scaler.transform(X_train)
X_test_scaled  = scaler.transform(X_test)     # apply same μ, σ
# Or in one step:
X_train_scaled = scaler.fit_transform(X_train)

# Min-max: rescale to [0, 1]
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler(feature_range=(0, 1))

# Robust: median & IQR (outlier-robust)
from sklearn.preprocessing import RobustScaler
scaler = RobustScaler()

# Quantile: map to uniform or normal distribution
from sklearn.preprocessing import QuantileTransformer
scaler = QuantileTransformer(output_distribution='uniform')  # or 'normal'

# Power: reduce skew (approx Gaussian)
from sklearn.preprocessing import PowerTransformer
scaler = PowerTransformer(method='yeo-johnson')  # or 'box-cox' (positive only)
```

**Attributes to inspect:**
- `scaler.mean_`, `scaler.scale_` — for StandardScaler
- `scaler.min_`, `scaler.data_range_` — for MinMaxScaler
- `scaler.center_`, `scaler.scale_` — for RobustScaler

---

## 4. Categorical Encoding

```python
# One-hot (nominal categorical)
from sklearn.preprocessing import OneHotEncoder
enc = OneHotEncoder(
    sparse_output=False,          # dense array
    handle_unknown='ignore',      # test time: unknown → all-zeros row
    drop='first',                 # drop one column to avoid multicollinearity in linear models
)
X_encoded = enc.fit_transform(X_cat)

# Ordinal (only for TRULY ordinal features)
from sklearn.preprocessing import OrdinalEncoder
enc = OrdinalEncoder(categories=[['low', 'medium', 'high']])  # specify order explicitly!
X_encoded = enc.fit_transform(X_ordinal)

# Target encoder (high-cardinality categoricals)
from sklearn.preprocessing import TargetEncoder
enc = TargetEncoder(target_type='binary', smooth='auto')
X_encoded = enc.fit_transform(X_cat, y)

# Label encoder (ONLY for the TARGET variable, not features!)
from sklearn.preprocessing import LabelEncoder
le = LabelEncoder()
y_encoded = le.fit_transform(y)
```

**Common trap:** `LabelEncoder` should NEVER be used on features. It's only for the target `y`. For nominal features, use `OneHotEncoder`; for ordinal, use `OrdinalEncoder`.

---

## 5. Imputation

```python
# Univariate: mean / median / mode / constant
from sklearn.impute import SimpleImputer
imp = SimpleImputer(strategy='mean')          # for numeric
imp = SimpleImputer(strategy='median')        # robust to outliers
imp = SimpleImputer(strategy='most_frequent') # for categorical
imp = SimpleImputer(strategy='constant', fill_value=-1)

# Adds a "missing indicator" column
imp = SimpleImputer(strategy='median', add_indicator=True)

# KNN-based imputation (multivariate)
from sklearn.impute import KNNImputer
imp = KNNImputer(n_neighbors=5, weights='distance')

# MICE-style iterative imputation
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer
imp = IterativeImputer(random_state=42, max_iter=10)

# Standalone missing indicator
from sklearn.impute import MissingIndicator
mi = MissingIndicator()
X_missing = mi.fit_transform(X)  # returns just the binary indicator matrix
```

**Time series (pandas):**
```python
df.fillna(method='ffill')           # forward fill (LOCF)
df.interpolate(method='linear')     # linear interpolation
df.interpolate(method='spline', order=3)
```

---

## 6. ColumnTransformer

Apply different transformations to different columns in one step:

```python
from sklearn.compose import ColumnTransformer

numeric_features = ['age', 'income', 'balance']
categorical_features = ['country', 'gender']

ct = ColumnTransformer([
    ('num', StandardScaler(), numeric_features),
    ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features),
], remainder='drop')  # or 'passthrough' to keep other columns

X_transformed = ct.fit_transform(X)
```

Then wrap in a Pipeline:
```python
pipe = Pipeline([
    ('preprocess', ct),
    ('model', LogisticRegression()),
])
```

---

## 7. Pipelines (sklearn vs imblearn)

**Standard sklearn Pipeline:**
```python
from sklearn.pipeline import Pipeline
pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('model', SVC(kernel='rbf')),
])
pipe.fit(X_train, y_train)
pipe.predict(X_test)
```

**Shortcut (`make_pipeline`, auto-names steps):**
```python
from sklearn.pipeline import make_pipeline
pipe = make_pipeline(StandardScaler(), SVC())
```

**imblearn Pipeline — REQUIRED if you have resampling steps:**
```python
from imblearn.pipeline import Pipeline as ImbPipeline

pipe = ImbPipeline([
    ('scaler', StandardScaler()),
    ('smote', SMOTE(random_state=42)),
    ('model', LogisticRegression()),
])
# In cross-validation, SMOTE fits only on the training fold each round.
```

**Access individual steps:**
```python
pipe.named_steps['scaler']          # the StandardScaler instance
pipe.named_steps['model'].coef_     # the fitted logistic regression coefficients
```

**Access hyperparameters in GridSearchCV via double underscore:**
```python
param_grid = {
    'model__C': [0.01, 0.1, 1, 10],
    'scaler__with_std': [True, False],
}
```

---

## 8. KNN

```python
from sklearn.neighbors import KNeighborsClassifier, KNeighborsRegressor

# Classification
knn = KNeighborsClassifier(
    n_neighbors=5,
    weights='uniform',        # or 'distance' for inverse-distance weighting
    metric='minkowski',       # default; equivalent to Euclidean when p=2
    p=2,                       # Manhattan=1, Euclidean=2
    algorithm='auto',         # 'ball_tree', 'kd_tree', 'brute', 'auto'
)

# Regression
knn = KNeighborsRegressor(n_neighbors=5, weights='distance')

# Fit and predict
knn.fit(X_train_scaled, y_train)   # ⚠️ MUST scale features first!
y_pred = knn.predict(X_test_scaled)

# Access neighbors
distances, indices = knn.kneighbors(X_test_scaled[:1], n_neighbors=3)
```

---

## 9. SVM & SVR

```python
from sklearn.svm import SVC, SVR, LinearSVC

# Classification with RBF kernel
svc = SVC(
    C=1.0,                # regularization: higher = less regularized
    kernel='rbf',         # 'linear', 'poly', 'rbf', 'sigmoid'
    gamma='scale',        # 'scale' = 1/(n_features * X.var()), 'auto' = 1/n_features
    class_weight=None,    # or 'balanced' for imbalanced data
    probability=False,    # set to True for predict_proba (adds Platt calibration → slower)
    random_state=42,
)

# Linear SVM (faster, more scalable for large data)
lsvc = LinearSVC(C=1.0, penalty='l2', loss='squared_hinge')

# Regression with ε-tube
svr = SVR(
    C=1.0,
    kernel='rbf',
    epsilon=0.1,          # tube width: errors inside |ŷ - y| ≤ ε don't count
    gamma='scale',
)

# Fit and predict
svc.fit(X_train_scaled, y_train)   # ⚠️ MUST scale features first!
y_pred = svc.predict(X_test_scaled)

# Support vector attributes
svc.support_vectors_   # the SVs themselves
svc.n_support_          # number of SVs per class
svc.dual_coef_          # α_i × y_i for each SV
```

**Log-scale search for C and gamma:**
```python
param_grid = {
    'C': np.logspace(-3, 3, 7),      # 0.001, 0.01, ..., 1000
    'gamma': np.logspace(-4, 1, 6),
}
```

---

## 10. Linear Regression

```python
from sklearn.linear_model import LinearRegression

lr = LinearRegression(fit_intercept=True)
lr.fit(X_train, y_train)

lr.coef_          # β_1, β_2, ...
lr.intercept_     # β_0
lr.score(X_test, y_test)   # returns R²

y_pred = lr.predict(X_test)
```

**Access residuals:**
```python
residuals = y_test - y_pred
```

**Manual normal equation (from-scratch reference):**
```python
X_with_intercept = np.hstack([np.ones((X.shape[0], 1)), X])
beta = np.linalg.inv(X_with_intercept.T @ X_with_intercept) @ X_with_intercept.T @ y
```

---

## 11. Logistic Regression

```python
from sklearn.linear_model import LogisticRegression

lr = LogisticRegression(
    penalty='l2',           # 'l1', 'l2', 'elasticnet', 'none'
    C=1.0,                  # inverse of regularization strength (smaller = more reg)
    solver='lbfgs',         # 'lbfgs', 'liblinear', 'saga', 'newton-cg'
    l1_ratio=None,          # only for elasticnet: 0=L2, 1=L1
    class_weight=None,      # or 'balanced'
    max_iter=1000,
    multi_class='auto',     # 'ovr' (one-vs-rest) or 'multinomial' (softmax)
    random_state=42,
)

lr.fit(X_train_scaled, y_train)

# Outputs
y_pred_class = lr.predict(X_test_scaled)          # class labels
y_pred_proba = lr.predict_proba(X_test_scaled)    # [P(y=0), P(y=1), ...]
y_pred_log_proba = lr.predict_log_proba(X_test_scaled)

# Access coefficients
lr.coef_       # shape (n_classes, n_features) for multiclass; (1, n_features) for binary
lr.intercept_
```

**Solver × penalty compatibility:**

| Solver | L2 | L1 | Elastic Net | None |
|---|---|---|---|---|
| `lbfgs` (default) | ✅ | ❌ | ❌ | ✅ |
| `liblinear` | ✅ | ✅ | ❌ | ❌ |
| `saga` | ✅ | ✅ | ✅ | ✅ |
| `newton-cg` | ✅ | ❌ | ❌ | ✅ |

---

## 12. Regularized Regression

```python
# Ridge (L2)
from sklearn.linear_model import Ridge
ridge = Ridge(alpha=1.0)   # alpha = regularization strength (larger = more reg)

# Lasso (L1) — feature selection
from sklearn.linear_model import Lasso
lasso = Lasso(alpha=0.1, max_iter=10000)

# Elastic Net (L1 + L2)
from sklearn.linear_model import ElasticNet
en = ElasticNet(alpha=0.1, l1_ratio=0.5)   # l1_ratio=0 → Ridge, l1_ratio=1 → Lasso

# Built-in CV variants — auto-select best alpha
from sklearn.linear_model import RidgeCV, LassoCV, ElasticNetCV

ridge_cv = RidgeCV(alphas=np.logspace(-3, 3, 20), cv=5)
lasso_cv = LassoCV(alphas=np.logspace(-3, 3, 20), cv=5)
en_cv = ElasticNetCV(alphas=np.logspace(-3, 3, 20), l1_ratio=[0.1, 0.5, 0.9], cv=5)

# For logistic regression
from sklearn.linear_model import LogisticRegressionCV
lr_cv = LogisticRegressionCV(Cs=np.logspace(-3, 3, 20), cv=5, penalty='l2')
```

**Coefficient paths:**
```python
# For visualizing how coefficients shrink as alpha changes
alphas = np.logspace(-3, 3, 100)
coefs = []
for a in alphas:
    ridge = Ridge(alpha=a).fit(X, y)
    coefs.append(ridge.coef_)
coefs = np.array(coefs)
plt.plot(alphas, coefs)
plt.xscale('log')
```

---

## 13. statsmodels (Inference)

**When you need p-values, confidence intervals, and statistical inference — not just prediction.**

```python
import statsmodels.api as sm

# OLS — need to manually add intercept!
X_with_const = sm.add_constant(X)
model = sm.OLS(y, X_with_const).fit()
print(model.summary())
# Extract specific values
model.params           # coefficients
model.pvalues          # p-values per coefficient
model.rsquared         # R²
model.rsquared_adj     # Adjusted R²
model.fvalue, model.f_pvalue    # F-statistic, its p-value
model.conf_int()       # 95% CI per coefficient

# Logistic regression via GLM
model = sm.GLM(y, X_with_const, family=sm.families.Binomial()).fit()
# Or via Logit
model = sm.Logit(y, X_with_const).fit()

# Regularized fit
model = sm.OLS(y, X_with_const).fit_regularized(alpha=1.0, L1_wt=0.5)
```

**Formula API (R-style):**
```python
import statsmodels.formula.api as smf
model = smf.ols('house_price ~ sqft + bedrooms + C(neighborhood)', data=df).fit()
# C(x) treats x as categorical → automatic dummy encoding
# You can also do 'y ~ x1 * x2' for interactions
```

**Interpretation of statsmodels output:**
- `coef` — estimated $\hat{\beta}$
- `std err` — standard error of the estimate
- `t` (or `z` for GLM) — test statistic
- `P>|t|` — p-value (compare to 0.05)
- `[0.025, 0.975]` — 95% confidence interval
- Bottom: R², Adjusted R², F-statistic, AIC, BIC, Durbin-Watson (autocorr)

---

## 14. Cross-Validation

```python
# Basic K-Fold
from sklearn.model_selection import KFold, StratifiedKFold, cross_val_score

# Regression / general
kf = KFold(n_splits=5, shuffle=True, random_state=42)

# Classification with imbalanced classes
skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

# Fast score (single metric)
scores = cross_val_score(model, X, y, cv=skf, scoring='roc_auc')
print(f"AUC: {scores.mean():.3f} ± {scores.std():.3f}")
# Returns: array of length n_splits — one score per fold ← ⚠️ Group D Q16

# Multiple metrics
from sklearn.model_selection import cross_validate
results = cross_validate(model, X, y, cv=skf, scoring=['accuracy', 'f1', 'roc_auc'])
# Returns dict with keys: fit_time, score_time, test_accuracy, test_f1, test_roc_auc

# Time series
from sklearn.model_selection import TimeSeriesSplit
tscv = TimeSeriesSplit(n_splits=5)                    # expanding window
tscv = TimeSeriesSplit(n_splits=5, max_train_size=100) # rolling window

# Leave-one-out (tiny datasets only)
from sklearn.model_selection import LeaveOneOut
loo = LeaveOneOut()
scores = cross_val_score(model, X, y, cv=loo)

# Repeated for stability
from sklearn.model_selection import RepeatedKFold, RepeatedStratifiedKFold
rkf = RepeatedKFold(n_splits=5, n_repeats=10, random_state=42)

# Group-aware (multiple rows per entity)
from sklearn.model_selection import GroupKFold
gkf = GroupKFold(n_splits=5)
scores = cross_val_score(model, X, y, cv=gkf, groups=patient_ids)
```

**Nested CV (unbiased performance under tuning):**
```python
from sklearn.model_selection import GridSearchCV, cross_val_score, KFold

outer_cv = KFold(n_splits=5, shuffle=True, random_state=42)
inner_cv = KFold(n_splits=3, shuffle=True, random_state=42)

inner_search = GridSearchCV(model, param_grid, cv=inner_cv, scoring='roc_auc')
nested_scores = cross_val_score(inner_search, X, y, cv=outer_cv, scoring='roc_auc')
```

**Diagnostic curves:**
```python
from sklearn.model_selection import validation_curve, learning_curve

# validation_curve: score vs one hyperparameter
train_scores, val_scores = validation_curve(
    model, X, y, param_name='C', param_range=np.logspace(-3, 3, 10),
    cv=5, scoring='accuracy'
)

# learning_curve: score vs training-set size
train_sizes, train_scores, val_scores = learning_curve(
    model, X, y, train_sizes=np.linspace(0.1, 1.0, 10), cv=5
)
```

---

## 15. Hyperparameter Search

```python
# Grid search — try all combinations
from sklearn.model_selection import GridSearchCV
gs = GridSearchCV(
    estimator=SVC(),
    param_grid={'C': [0.1, 1, 10], 'gamma': [0.01, 0.1, 1]},
    cv=5,
    scoring='accuracy',
    n_jobs=-1,          # parallelize across cores
    refit=True,         # refit best on full training set
)
gs.fit(X_train, y_train)
gs.best_params_
gs.best_score_
gs.best_estimator_
gs.cv_results_      # detailed dict for analysis

# Random search — sample from distributions
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import loguniform, uniform, randint

rs = RandomizedSearchCV(
    estimator=SVC(),
    param_distributions={
        'C': loguniform(1e-3, 1e3),
        'gamma': loguniform(1e-4, 1e1),
        'kernel': ['rbf', 'poly'],
    },
    n_iter=100,
    cv=5,
    random_state=42,
)

# Bayesian search
from skopt import BayesSearchCV
from skopt.space import Real, Integer, Categorical

bs = BayesSearchCV(
    estimator=SVC(),
    search_spaces={
        'C': Real(1e-3, 1e3, prior='log-uniform'),
        'gamma': Real(1e-4, 1e1, prior='log-uniform'),
        'kernel': Categorical(['rbf', 'poly']),
    },
    n_iter=30,
    cv=5,
    random_state=42,
)

# Successive halving (resource-efficient)
from sklearn.experimental import enable_halving_search_cv
from sklearn.model_selection import HalvingGridSearchCV, HalvingRandomSearchCV
hs = HalvingGridSearchCV(model, param_grid, factor=3, cv=5)
```

**Common scoring strings (all sklearn searches):**
- Classification: `'accuracy'`, `'f1'`, `'f1_macro'`, `'roc_auc'`, `'average_precision'`, `'neg_log_loss'`, `'matthews_corrcoef'`
- Regression: `'neg_mean_squared_error'`, `'neg_mean_absolute_error'`, `'r2'`, `'neg_mean_absolute_percentage_error'`

Note the `neg_` prefix: sklearn maximizes scores, so error metrics are negated.

---

## 16. Class Rebalancing

```python
from imblearn.over_sampling import (
    RandomOverSampler, SMOTE, BorderlineSMOTE,
    SVMSMOTE, KMeansSMOTE, ADASYN,
)
from imblearn.under_sampling import (
    RandomUnderSampler, TomekLinks, EditedNearestNeighbours,
    RepeatedEditedNearestNeighbours, ClusterCentroids,
)
from imblearn.combine import SMOTETomek, SMOTEENN

# Oversampling minority class
smote = SMOTE(random_state=42, k_neighbors=5)
X_res, y_res = smote.fit_resample(X_train, y_train)

# Variants
b_smote = BorderlineSMOTE(kind='borderline-1', k_neighbors=5)
svm_smote = SVMSMOTE(k_neighbors=5)
adasyn = ADASYN(n_neighbors=5)

# Undersampling
tl = TomekLinks(sampling_strategy='majority')
enn = EditedNearestNeighbours(n_neighbors=3)
cc = ClusterCentroids(random_state=42)   # replaces majority with K-means centroids
rus = RandomUnderSampler(random_state=42)

# Combination
smotetomek = SMOTETomek(random_state=42)
smoteenn = SMOTEENN(random_state=42)

# ⚠️ CRUCIAL: use with imblearn.pipeline.Pipeline, not sklearn.pipeline.Pipeline
from imblearn.pipeline import Pipeline as ImbPipeline
pipe = ImbPipeline([
    ('scaler', StandardScaler()),
    ('smote', SMOTE(random_state=42)),
    ('model', LogisticRegression()),
])
# Now cross_val_score will apply SMOTE inside each CV fold correctly.
```

**Alternative: class weights (no resampling):**
```python
model = LogisticRegression(class_weight='balanced')
# Or manual weights
model = LogisticRegression(class_weight={0: 1.0, 1: 10.0})
```

---

## 17. Feature Selection

```python
# 1. Variance Threshold — remove near-constants
from sklearn.feature_selection import VarianceThreshold
vt = VarianceThreshold(threshold=0.01)
X_reduced = vt.fit_transform(X)

# 2. Univariate: pick best K features
from sklearn.feature_selection import SelectKBest, SelectPercentile
from sklearn.feature_selection import f_classif, chi2, mutual_info_classif
kbest = SelectKBest(f_classif, k=10)
X_reduced = kbest.fit_transform(X, y)

# 3. Recursive Feature Elimination
from sklearn.feature_selection import RFE, RFECV
rfe = RFE(estimator=LogisticRegression(), n_features_to_select=10, step=1)
rfecv = RFECV(estimator=LogisticRegression(), cv=5, scoring='accuracy')

# 4. Sequential (forward or backward)
from sklearn.feature_selection import SequentialFeatureSelector
sfs = SequentialFeatureSelector(
    estimator=LogisticRegression(),
    n_features_to_select=10,
    direction='forward',   # or 'backward'
    scoring='accuracy',
    cv=5,
)

# 5. Embedded — use model's built-in importance
from sklearn.feature_selection import SelectFromModel
sfm = SelectFromModel(Lasso(alpha=0.01), threshold='median')

# All follow: .fit(X, y), .transform(X), .get_support() (boolean mask), .get_feature_names_out()
```

---

## 18. Ensembles

```python
# Bagging
from sklearn.ensemble import BaggingClassifier
bag = BaggingClassifier(
    estimator=DecisionTreeClassifier(),
    n_estimators=100,
    max_samples=1.0,        # bootstrap sample size = training size
    bootstrap=True,          # sample with replacement
    n_jobs=-1,
)

# Random Forest — bagging + random feature subsets at splits
from sklearn.ensemble import RandomForestClassifier
rf = RandomForestClassifier(
    n_estimators=100,
    max_depth=None,         # unrestricted
    min_samples_split=2,
    max_features='sqrt',    # sqrt(n_features) for classification, n_features for regression
    bootstrap=True,
    oob_score=True,         # out-of-bag error estimation (no separate CV needed)
    n_jobs=-1,
    random_state=42,
)
rf.fit(X, y)
rf.feature_importances_
rf.oob_score_

# Voting (multiple different models)
from sklearn.ensemble import VotingClassifier
vc = VotingClassifier([
    ('lr', LogisticRegression()),
    ('rf', RandomForestClassifier()),
    ('svm', SVC(probability=True)),
], voting='soft')   # 'hard' = majority label vote; 'soft' = average probabilities

# Stacking
from sklearn.ensemble import StackingClassifier
sc = StackingClassifier(
    estimators=[('rf', RandomForestClassifier()), ('svm', SVC())],
    final_estimator=LogisticRegression(),  # meta-learner
    cv=5,
)

# Boosting
from sklearn.ensemble import AdaBoostClassifier, GradientBoostingClassifier
ada = AdaBoostClassifier(n_estimators=100)
gb = GradientBoostingClassifier(n_estimators=100, learning_rate=0.1, max_depth=3)
```

---

## 19. Calibration

```python
from sklearn.calibration import CalibratedClassifierCV, calibration_curve

# Wrap an existing classifier
cal = CalibratedClassifierCV(
    estimator=SVC(),
    method='sigmoid',   # Platt scaling
    # method='isotonic',  # non-parametric monotone
    cv=5,               # cross-validated calibration
)
cal.fit(X_train, y_train)
cal.predict_proba(X_test)

# Calibration curve (reliability diagram)
prob_pos = model.predict_proba(X_test)[:, 1]
prob_true, prob_pred = calibration_curve(y_test, prob_pos, n_bins=10, strategy='uniform')
plt.plot(prob_pred, prob_true, marker='o')
plt.plot([0, 1], [0, 1], 'k--')  # perfect calibration line

# Brier score
from sklearn.metrics import brier_score_loss
bs = brier_score_loss(y_test, prob_pos)   # lower is better
```

---

## 20. Evaluation Metrics

**Classification:**
```python
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score, fbeta_score,
    confusion_matrix, classification_report, matthews_corrcoef,
    roc_auc_score, roc_curve, precision_recall_curve, average_precision_score,
    log_loss, brier_score_loss,
)

accuracy_score(y_true, y_pred)
precision_score(y_true, y_pred, average='binary')  # or 'macro', 'micro', 'weighted'
recall_score(y_true, y_pred, average='binary')
f1_score(y_true, y_pred, average='binary')
fbeta_score(y_true, y_pred, beta=2)               # F2 (recall-heavy)
matthews_corrcoef(y_true, y_pred)

cm = confusion_matrix(y_true, y_pred)
# Format: [[TN, FP], [FN, TP]]  when labels=[0,1]

print(classification_report(y_true, y_pred))
# Prints precision, recall, f1 per class + averages

roc_auc_score(y_true, y_proba)
log_loss(y_true, y_proba)
average_precision_score(y_true, y_proba)   # PR AUC

# For plotting
fpr, tpr, thresholds = roc_curve(y_true, y_proba)
precision, recall, thresholds = precision_recall_curve(y_true, y_proba)
```

**Regression:**
```python
from sklearn.metrics import (
    mean_squared_error, mean_absolute_error, r2_score,
    mean_absolute_percentage_error, median_absolute_error,
    mean_squared_log_error,
)

mean_squared_error(y_true, y_pred)                          # MSE
mean_squared_error(y_true, y_pred, squared=False)           # RMSE
mean_absolute_error(y_true, y_pred)                         # MAE
r2_score(y_true, y_pred)                                    # R²
mean_absolute_percentage_error(y_true, y_pred)              # MAPE
median_absolute_error(y_true, y_pred)                       # MedAE
mean_squared_log_error(y_true, y_pred)                      # MSLE
```

---

## 21. Drift Detection

```python
# Kolmogorov-Smirnov test (categorical yes/no)
from scipy.stats import ks_2samp
statistic, p_value = ks_2samp(train_feature, prod_feature)
# p_value < 0.05 → distributions likely different

# Wasserstein distance (magnitude of shift)
from scipy.stats import wasserstein_distance
d = wasserstein_distance(train_feature, prod_feature)
# Same units as the feature; interpretable magnitude
```

---

## 22. Common Gotchas & API Quirks

Things the exam has tested (or is likely to test):

1. **`cross_val_score` returns an array**, not a single float. Take `.mean()` yourself.
2. **`class_weight='balanced'`** doesn't oversample — it re-weights the loss.
3. **`OneHotEncoder(handle_unknown='ignore')`** is essential — otherwise unseen categories at test time raise errors.
4. **`OrdinalEncoder`** imposes ordering. Use only for truly ordinal features.
5. **`LabelEncoder`** is for the **target** only, never features.
6. **Elastic Net logistic regression** requires `solver='saga'`.
7. **SVM `predict_proba`** requires `probability=True` at construction — this adds internal cross-validated Platt scaling and slows fitting significantly.
8. **`fit_transform` on test data is a bug**. Always `fit` on train, `transform` on test.
9. **imblearn `SMOTE` in `sklearn.pipeline.Pipeline`** fails silently or misbehaves — use `imblearn.pipeline.Pipeline`.
10. **`RidgeCV`/`LassoCV`/`ElasticNetCV`** don't need `GridSearchCV` — they select alpha internally with CV, much faster.
11. **`GridSearchCV`** with `refit=True` (default) auto-refits the best model on the full training set — `gs.best_estimator_` is ready to use.
12. **`neg_mean_squared_error`** — sklearn negates loss metrics because it maximizes by convention.
13. **`fit_intercept=False`** disables the intercept — usually you want it True (default).
14. **`predict_proba`** returns shape `(n, n_classes)`; for binary, `y_proba[:, 1]` is the positive class probability.
15. **`statsmodels` requires manual intercept** via `sm.add_constant(X)`.
16. **`sklearn.pipeline.Pipeline`** step name comes from `str.lower(ClassName)` when using `make_pipeline`. For named pipelines, use dict-style access with `__` for hyperparameters (`'model__C'`, `'scaler__with_mean'`).

---

## Minimum viable exam workflow (template)

If asked to "write code that trains and evaluates a model":

```python
import numpy as np
from sklearn.model_selection import train_test_split, StratifiedKFold, GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, roc_auc_score

# 1. Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

# 2. Pipeline
pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('model', LogisticRegression(max_iter=1000, class_weight='balanced')),
])

# 3. Hyperparameter tuning with CV
param_grid = {'model__C': np.logspace(-3, 3, 7)}
skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
gs = GridSearchCV(pipe, param_grid, cv=skf, scoring='roc_auc', n_jobs=-1)
gs.fit(X_train, y_train)

# 4. Evaluate on held-out test
y_pred = gs.predict(X_test)
y_proba = gs.predict_proba(X_test)[:, 1]

print(f"Best C: {gs.best_params_}")
print(f"Test AUC: {roc_auc_score(y_test, y_proba):.3f}")
print(classification_report(y_test, y_pred))
```

Cover this template cold and you'll have the answer to any "write the code" style question.
