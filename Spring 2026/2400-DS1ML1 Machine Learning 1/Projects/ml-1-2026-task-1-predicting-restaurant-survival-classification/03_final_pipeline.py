"""Final pipeline for the restaurants classification project.

Trains the winning model (Logistic Regression with L1 regularization,
C=10, class_weight="balanced") on the full training data and writes
predictions for the Kaggle test set.

The model and its hyperparameters were chosen in `02_search.ipynb` after
comparing Logistic Regression, KNN, and Linear SVM with 5-fold stratified
cross-validation. Logistic Regression with L1 penalty (C=10) was the best
model, with a cross-validated balanced accuracy of 0.6608 and a held-out
validation balanced accuracy of 0.6598.

Usage
-----
From the `task1-restaurants/` folder:

    python 03_final_pipeline.py

The script reads `data/restaurants_train.csv` and `data/restaurants_test.csv`
and writes `outputs/submission.csv` in the format expected by Kaggle.

Project: ML1 2025/2026 — WNE UW — Task 1 (restaurants classification)
"""

import time
import warnings
from pathlib import Path

import numpy as np
import pandas as pd
from pandas.api.types import is_bool_dtype, is_numeric_dtype
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

warnings.filterwarnings("ignore")

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
PROJECT_DIR = Path(__file__).parent
DATA_DIR = PROJECT_DIR / "data"
OUTPUT_DIR = PROJECT_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

RANDOM_STATE = 42
TARGET = "status_closed"
ID_COL = "restaurant_id"

# Best hyperparameters found in 02_search.ipynb
BEST_PARAMS = {
    "solver": "liblinear",
    "penalty": "l1",
    "C": 10.0,
    "class_weight": "balanced",
    "max_iter": 2000,
    "random_state": RANDOM_STATE,
}


# ---------------------------------------------------------------------------
def main() -> None:
    print("=" * 70)
    print("COMPLETE PIPELINE — Restaurants classification (Task 1)")
    print("=" * 70)

    t_start = time.time()

    # -----------------------------------------------------------------------
    print("\n[STEP 1] Loading training and test data")
    # -----------------------------------------------------------------------
    train = pd.read_csv(DATA_DIR / "restaurants_train.csv")
    test = pd.read_csv(DATA_DIR / "restaurants_test.csv")

    print(f"  Training set: {train.shape[0]} rows, {train.shape[1]} columns")
    print(f"  Test set:     {test.shape[0]} rows, {test.shape[1]} columns")
    print(f"  Target class proportions: {dict(train[TARGET].value_counts(normalize=True).round(4))}")

    # -----------------------------------------------------------------------
    print("\n[STEP 2] Identifying feature types")
    # -----------------------------------------------------------------------
    feature_cols = [c for c in train.columns if c not in {ID_COL, TARGET}]
    bool_cols = [c for c in feature_cols if is_bool_dtype(train[c])]
    numeric_cols = [c for c in feature_cols if is_numeric_dtype(train[c]) and not is_bool_dtype(train[c])]
    categorical_cols = [c for c in feature_cols if c not in bool_cols + numeric_cols]

    print(f"  Numeric features:      {len(numeric_cols)}")
    print(f"  Categorical features:  {len(categorical_cols)}  -> {categorical_cols}")
    print(f"  Boolean features:      {len(bool_cols)}")
    print(f"  Total features:        {len(feature_cols)}")

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
            ("cat", categorical_pipe, categorical_cols),
            ("bool", "passthrough", bool_cols),
        ],
        remainder="drop",
    )
    print("  Numeric  -> SimpleImputer(median) + StandardScaler")
    print("  Categor. -> SimpleImputer(most_frequent) + OneHotEncoder(handle_unknown='ignore')")
    print("  Boolean  -> passthrough")

    # -----------------------------------------------------------------------
    print("\n[STEP 4] Building final model pipeline")
    # -----------------------------------------------------------------------
    print("  Model: Logistic Regression with L1 regularization")
    print("  Hyperparameters (from 02_search.ipynb):")
    for k, v in BEST_PARAMS.items():
        print(f"    {k} = {v}")

    final_pipeline = Pipeline([
        ("preprocessor", preprocessor),
        ("classifier", LogisticRegression(**BEST_PARAMS)),
    ])

    # -----------------------------------------------------------------------
    print("\n[STEP 5] Training on full training data")
    # -----------------------------------------------------------------------
    X_train = train[feature_cols]
    y_train = train[TARGET].values

    t0 = time.time()
    final_pipeline.fit(X_train, y_train)
    print(f"  Training time: {time.time() - t0:.1f} seconds")

    # Report training balanced accuracy as a sanity check
    from sklearn.metrics import balanced_accuracy_score
    train_bal_acc = balanced_accuracy_score(y_train, final_pipeline.predict(X_train))
    print(f"  Training balanced accuracy: {train_bal_acc:.4f}")
    print("  (Expected on Kaggle private leaderboard: around 0.66, based on CV in 02_search.ipynb)")

    # -----------------------------------------------------------------------
    print("\n[STEP 6] Predicting on the Kaggle test set")
    # -----------------------------------------------------------------------
    X_test = test[feature_cols]
    test_predictions = final_pipeline.predict(X_test)

    submission = pd.DataFrame({
        ID_COL: test[ID_COL],
        TARGET: test_predictions.astype(int),
    })

    print(f"  Predictions made: {len(submission)}")
    print(f"  Predicted class proportions: {dict(submission[TARGET].value_counts(normalize=True).round(4))}")

    # -----------------------------------------------------------------------
    print("\n[STEP 7] Saving submission file")
    # -----------------------------------------------------------------------
    submission_path = OUTPUT_DIR / "submission.csv"
    submission.to_csv(submission_path, index=False)
    print(f"  Wrote {submission_path}")
    print(f"  Preview:")
    print(submission.head().to_string(index=False))

    print("\n" + "=" * 70)
    print(f"DONE. Total time: {time.time() - t_start:.1f} seconds")
    print("=" * 70)


if __name__ == "__main__":
    main()
