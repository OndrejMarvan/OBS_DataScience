"""Final pipeline for the developer salary regression project.

Trains the winning model (Elastic Net with alpha=0.1, l1_ratio=0.1, on a
log-transformed target via TransformedTargetRegressor) on the full training
data and writes predictions for the Kaggle test set.

The model and its hyperparameters were chosen in `02_search.ipynb` after
comparing Elastic Net, KNN regressor, and Linear SVR with 5-fold cross-validation
scored on RMSE. Elastic Net was the best model on both:
- CV RMSE on USD scale: $90,024 (vs $92,536 for KNN, $93,430 for LinearSVR)
- Validation RMSE on log scale: 1.371 (vs 1.465 KNN, 1.447 LinearSVR)

Note on the metric: RMSE on the original USD scale is dominated by a handful
of extreme high earners (one row reports $4.77M). This makes the score noisy
on individual splits. On the log scale, which is what the model actually
optimizes, Elastic Net clearly beats both other algorithms and the
"predict-the-median" baseline.

Usage
-----
From the `task2-salary/` folder:

    python 03_final_pipeline.py

The script reads `data/train.csv` and `data/test.csv` and writes
`outputs/submission.csv` in the format expected by Kaggle.

Project: ML1 2025/2026 — WNE UW — Task 2 (developer salary regression)
"""

import time
import warnings
from pathlib import Path

import numpy as np
import pandas as pd
from pandas.api.types import is_numeric_dtype
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.compose import ColumnTransformer, TransformedTargetRegressor
from sklearn.impute import SimpleImputer
from sklearn.linear_model import ElasticNet
from sklearn.metrics import mean_squared_error
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import MultiLabelBinarizer, OneHotEncoder, StandardScaler

warnings.filterwarnings("ignore")

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
PROJECT_DIR = Path(__file__).parent
DATA_DIR = PROJECT_DIR / "data"
OUTPUT_DIR = PROJECT_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

RANDOM_STATE = 42
TARGET = "annual.pay.usd"
ID_COL = "id"

# Best hyperparameters found in 02_search.ipynb
BEST_PARAMS = {
    "alpha": 0.1,
    "l1_ratio": 0.1,
    "max_iter": 5000,
    "random_state": RANDOM_STATE,
}


# ---------------------------------------------------------------------------
# Custom transformer for multi-label semicolon-separated columns
# ---------------------------------------------------------------------------
class MultiLabelColumnEncoder(BaseEstimator, TransformerMixin):
    """Apply MultiLabelBinarizer to each column independently.

    Each column is expected to hold semicolon-separated tokens (e.g. "A;B;C").
    The transformer creates one binary column per unique token in the training
    data. Unseen tokens at transform time are simply ignored.
    """

    def fit(self, X, y=None):
        X = pd.DataFrame(X)
        self.encoders_ = {}
        self.column_names_ = []
        for col in X.columns:
            tokens = X[col].fillna("").astype(str).apply(lambda s: s.split(";") if s else [])
            mlb = MultiLabelBinarizer()
            mlb.fit(tokens)
            self.encoders_[col] = mlb
            self.column_names_.extend([f"{col}__{c}" for c in mlb.classes_])
        return self

    def transform(self, X):
        X = pd.DataFrame(X)
        parts = []
        for col in X.columns:
            tokens = X[col].fillna("").astype(str).apply(lambda s: s.split(";") if s else [])
            parts.append(self.encoders_[col].transform(tokens))
        return np.hstack(parts)

    def get_feature_names_out(self, input_features=None):
        return np.array(self.column_names_)


# ---------------------------------------------------------------------------
def main() -> None:
    print("=" * 70)
    print("COMPLETE PIPELINE — Developer Salary regression (Task 2)")
    print("=" * 70)

    t_start = time.time()

    # -----------------------------------------------------------------------
    print("\n[STEP 1] Loading training and test data")
    # -----------------------------------------------------------------------
    train = pd.read_csv(DATA_DIR / "train.csv")
    test = pd.read_csv(DATA_DIR / "test.csv")

    print(f"  Training set: {train.shape[0]} rows, {train.shape[1]} columns")
    print(f"  Test set:     {test.shape[0]} rows, {test.shape[1]} columns")
    print(f"  Target range: ${train[TARGET].min():,.0f} to ${train[TARGET].max():,.0f}")
    print(f"  Target median: ${train[TARGET].median():,.0f}")

    # -----------------------------------------------------------------------
    print("\n[STEP 2] Identifying feature types")
    # -----------------------------------------------------------------------
    feature_cols = [c for c in train.columns if c != TARGET]

    numeric_cols = [c for c in feature_cols if is_numeric_dtype(train[c])]
    text_cols = [c for c in feature_cols if c not in numeric_cols]

    def is_multi_label(series):
        return series.dropna().astype(str).str.contains(";").any()

    multi_label_cols = [c for c in text_cols if is_multi_label(train[c])]
    plain_cat_cols = [c for c in text_cols if c not in multi_label_cols]

    print(f"  Numeric features:        {len(numeric_cols)}")
    print(f"  Plain categorical:       {len(plain_cat_cols)}")
    print(f"  Multi-label categorical: {len(multi_label_cols)}")
    print(f"  Total features:          {len(feature_cols)}")

    # -----------------------------------------------------------------------
    print("\n[STEP 3] Building preprocessing pipeline")
    # -----------------------------------------------------------------------
    numeric_pipe = Pipeline([
        ("imputer", SimpleImputer(strategy="median")),
        ("scaler", StandardScaler()),
    ])

    categorical_pipe = Pipeline([
        ("imputer", SimpleImputer(strategy="most_frequent")),
        ("ohe", OneHotEncoder(handle_unknown="ignore", sparse_output=False)),
    ])

    preprocessor = ColumnTransformer(
        transformers=[
            ("num", numeric_pipe, numeric_cols),
            ("cat", categorical_pipe, plain_cat_cols),
            ("multi", MultiLabelColumnEncoder(), multi_label_cols),
        ],
        remainder="drop",
    )
    print("  Numeric    -> SimpleImputer(median) + StandardScaler")
    print("  Plain cat. -> SimpleImputer(most_frequent) + OneHotEncoder")
    print("  Multi-lab. -> custom MultiLabelColumnEncoder")

    # -----------------------------------------------------------------------
    print("\n[STEP 4] Building final model pipeline")
    # -----------------------------------------------------------------------
    print("  Model: Elastic Net regression on log-transformed target")
    print("  Wrapper: TransformedTargetRegressor with log1p / expm1")
    print("  Hyperparameters (from 02_search.ipynb):")
    for k, v in BEST_PARAMS.items():
        print(f"    {k} = {v}")

    final_pipeline = Pipeline([
        ("preprocessor", preprocessor),
        ("regressor", TransformedTargetRegressor(
            regressor=ElasticNet(**BEST_PARAMS),
            func=np.log1p,
            inverse_func=np.expm1,
        )),
    ])

    # -----------------------------------------------------------------------
    print("\n[STEP 5] Training on full training data")
    # -----------------------------------------------------------------------
    X_train = train[feature_cols]
    y_train = train[TARGET].values

    t0 = time.time()
    final_pipeline.fit(X_train, y_train)
    print(f"  Training time: {time.time() - t0:.1f} seconds")

    # Report training RMSE as a sanity check
    train_pred = final_pipeline.predict(X_train)
    train_pred = np.clip(train_pred, 0, None)
    train_rmse = np.sqrt(mean_squared_error(y_train, train_pred))
    print(f"  Training RMSE: ${train_rmse:,.0f}")
    print("  (Expected on Kaggle private leaderboard: around $90,000,")
    print("   based on 5-fold CV in 02_search.ipynb)")

    # -----------------------------------------------------------------------
    print("\n[STEP 6] Predicting on the Kaggle test set")
    # -----------------------------------------------------------------------
    X_test = test[feature_cols]
    test_predictions = final_pipeline.predict(X_test)

    # Salaries cannot be negative; clip to zero just in case.
    test_predictions = np.clip(test_predictions, 0, None)

    print(f"  Predictions made: {len(test_predictions)}")
    print(f"  Prediction range: ${test_predictions.min():,.0f} to ${test_predictions.max():,.0f}")
    print(f"  Prediction median: ${np.median(test_predictions):,.0f}")

    # -----------------------------------------------------------------------
    print("\n[STEP 7] Saving submission file")
    # -----------------------------------------------------------------------
    submission = pd.DataFrame({
        ID_COL: test[ID_COL],
        TARGET: test_predictions,
    })

    submission_path = OUTPUT_DIR / "submission.csv"
    submission.to_csv(submission_path, index=False)
    print(f"  Wrote {submission_path}")
    print("  Preview:")
    print(submission.head().to_string(index=False))

    print("\n" + "=" * 70)
    print(f"DONE. Total time: {time.time() - t_start:.1f} seconds")
    print("=" * 70)


if __name__ == "__main__":
    main()
