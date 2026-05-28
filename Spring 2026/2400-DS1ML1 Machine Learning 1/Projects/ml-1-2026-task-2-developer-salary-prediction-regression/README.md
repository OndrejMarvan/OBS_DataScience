# Project 1 — Restaurants (Classification)

**Machine Learning 1** · WNE UW · academic year 2025/2026

In this project we predict whether a restaurant has closed (`status_closed = 1`) or is still open (`status_closed = 0`).

---

## The dataset

- **Training set**: 33,296 rows × 86 columns (85 features + the target)
- **Test set**: 8,325 rows × 85 columns (no target — that's what we predict)
- The data is **very imbalanced**: about 90% of restaurants are still open, only 10% have closed.

The features describe each restaurant in different ways:

- **Numeric** features (74 columns) — things like average rating, number of user ratings, how many other restaurants are nearby, the age of the place, the number of residents in the area, etc.
- **Categorical** features (3 columns) — restaurant category (Pizzeria, Kebab, Sushi, etc.) and two yes/no flags about opening days.
- **Boolean** features (7 columns) — true/false flags like "has a photo", "is a bar", "offers takeaway".

---

## The metric: balanced accuracy

Kaggle grades our submissions using **balanced accuracy**:

$$\text{balanced accuracy} = \frac{\text{sensitivity} + \text{specificity}}{2}$$

This is what we should use whenever classes are imbalanced. Plain accuracy is misleading here — a model that just predicts "open" for every restaurant would get 90% plain accuracy but only 0.5 balanced accuracy.

---

## What we did

### Step 1 — Exploratory Data Analysis (`01_eda.ipynb`)

We looked at the data and made the most important findings:

1. The target is very imbalanced (~90% open, ~10% closed).
2. Many columns have missing values (some up to 72%).
3. The strongest predictors look like **engagement features** (number of user ratings, recent activity), **restaurant age**, and **restaurant category**.
4. Many numeric features are correlated in groups — we will let regularization handle this instead of removing them manually.

### Step 2 — Preprocessing decisions

| Type of column | What we do |
|---|---|
| Numeric | Fill missing with the median, then standardize (subtract mean, divide by standard deviation) |
| Categorical | Fill missing with the most frequent value, then one-hot encode |
| Boolean | Pass through as-is (already 0/1) |

All preprocessing happens **inside a scikit-learn `Pipeline`**, so during cross-validation the imputer and scaler are fitted only on the training portion of each fold. This avoids data leakage.

### Step 3 — Model comparison (`02_search.ipynb`)

We compared three algorithms (the assessment requires at least three), all from the ML1 syllabus:

1. **Logistic Regression** with L1 and L2 regularization
2. **K-Nearest Neighbors** (KNN)
3. **Linear SVM** (LinearSVC)

For all of them we:

- Used **5-fold stratified cross-validation** with `scoring="balanced_accuracy"`.
- Tuned hyperparameters on a **logarithmic grid** (e.g. `C ∈ {0.001, 0.01, 0.1, 1, 10}`).
- Set `class_weight="balanced"` to handle the imbalance — this tells the model to care equally about both classes during training.

### Why not SVM with the RBF kernel?

Our first idea was to use SVM with the RBF kernel, but it scales as O(n²) with the number of training samples. On our 33,000-row dataset, a single fit takes about 80 seconds, so the full cross-validation grid would take over two hours. We benchmarked it on smaller samples and chose to use **LinearSVC** (linear-kernel SVM) on the full data instead. It still counts as an SVM with one of the "various kernels" from the syllabus, and it finishes in under a minute.

---

## Final results

| Model | Best hyperparameters | CV balanced accuracy | Validation balanced accuracy |
|---|---|---|---|
| Dummy (always predicts open) | — | — | 0.500 |
| **Logistic Regression** | **C=10, penalty=L1** | **0.6608** | **0.6598** |
| Linear SVM | C=0.1 | 0.6566 | 0.6565 |
| KNN | k=5, weights=distance | 0.5124 | 0.5084 |

**Our winner: Logistic Regression with L1 (Lasso) penalty and C=10.**

Expected Kaggle score (private leaderboard): about **0.66**.

### A note on KNN

KNN almost did not do better than random guessing. The reason is the **curse of dimensionality**: with over 100 features after one-hot encoding, the distances between points become similar, so "nearest neighbors" stop being meaningful. We include this result honestly in the comparison — it shows that not every algorithm fits every problem.

---

## Files in this folder

```
task1-restaurants/
├── 01_eda.ipynb              ← exploratory analysis with plots and decisions
├── 02_search.ipynb           ← model comparison and hyperparameter tuning
├── 03_final_pipeline.py      ← trains the winning model and produces submission.csv
├── README.md                 ← this file
├── data/
│   ├── restaurants_train.csv          ← training data (from Kaggle)
│   ├── restaurants_test.csv           ← test data (from Kaggle)
│   └── restaurant_sample_submission.csv   ← Kaggle's example of the right format
└── outputs/
    ├── model_comparison.csv  ← summary table of all models we tried
    └── submission.csv        ← the file we upload to Kaggle
```

The `01_eda.ipynb` and `02_search.ipynb` notebooks are the "search code" — they show our whole experimentation process. The `03_final_pipeline.py` is the "single best algorithm" code — it just trains the winning model and produces predictions. This separation matches what the assessment asks for.

---

## How to run

### What you need

- **Python 3.12 or newer**
- The libraries `pandas`, `numpy`, `scikit-learn`, `matplotlib`, `seaborn`, `imbalanced-learn`, `jupyter`

### Quick way (using pip)

```bash
# 1. Go to this project folder
cd task1-restaurants

# 2. Create a virtual environment
python3 -m venv .venv

# 3. Turn it on
source .venv/bin/activate            # Linux / macOS
# .venv\Scripts\activate              (on Windows)

# 4. Install the libraries
pip install pandas numpy scikit-learn matplotlib seaborn imbalanced-learn jupyter

# 5. Run the final script
python 03_final_pipeline.py
```

When the script finishes, you find your predictions in `outputs/submission.csv`. This is the file to upload to Kaggle.

To open the notebooks:

```bash
jupyter lab
```

When you are done, type `deactivate` to leave the virtual environment.

### Recommended way (using uv)

[`uv`](https://docs.astral.sh/uv/) is the tool the course material uses. It is faster and easier than pip.

```bash
# 1. Install uv (only needed once on your computer)
curl -LsSf https://astral.sh/uv/install.sh | sh           # Linux / macOS
# powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"   (Windows)

# 2. Restart your terminal

# 3. Go to this project folder
cd task1-restaurants

# 4. Run the script
uv run --with pandas --with scikit-learn --with numpy python 03_final_pipeline.py

# To open the notebooks:
uv run --with pandas --with scikit-learn --with numpy --with matplotlib --with seaborn --with imbalanced-learn jupyter lab
```

---

## What the script prints

When you run `03_final_pipeline.py`, it tells you what it is doing at each step:

```
======================================================================
COMPLETE PIPELINE — Restaurants classification (Task 1)
======================================================================

[STEP 1] Loading training and test data
  Training set: 33296 rows, 86 columns
  Test set:     8325 rows, 85 columns
  Target class proportions: {0: 0.9019, 1: 0.0981}

[STEP 2] Identifying feature types
  Numeric features:      74
  Categorical features:  3
  Boolean features:      7

[STEP 3] Building preprocessing pipeline
[STEP 4] Building final model pipeline
[STEP 5] Training on full training data
  Training time: 28.4 seconds
  Training balanced accuracy: 0.6711

[STEP 6] Predicting on the Kaggle test set
[STEP 7] Saving submission file
  Wrote outputs/submission.csv

DONE. Total time: 28.9 seconds
```

The whole script takes about 30 seconds to run.

---

## How to submit to Kaggle

1. Run `03_final_pipeline.py` to produce `outputs/submission.csv`.
2. Go to the competition page: https://www.kaggle.com/competitions/ml-1-2026-task-1-predicting-restaurant-survival-classification
3. Click **"Submit Predictions"** and upload `outputs/submission.csv`.
4. Kaggle gives you a public leaderboard score based on 30% of the test set. The final grade uses the other 70%.

**Deadline: May 28, 2026, 23:55.**

---

## A few choices explained

### Why pipelines everywhere?

A `Pipeline` keeps preprocessing and the model together as one object. The big benefit is that during cross-validation, the imputer's median and the scaler's mean are computed **only from the training portion of each fold**. If we did the preprocessing once on the whole dataset before splitting, information from the validation set would leak into the training process and our cross-validation scores would be too optimistic.

### Why `liblinear` solver for Logistic Regression?

scikit-learn offers several solvers for Logistic Regression. The `liblinear` solver:

- Supports both L1 and L2 penalties (which we want to compare).
- Is fast on this dataset size.
- Was used in the course's logistic regression notebook.

### Why a logarithmic grid for `C`?

The regularization parameter `C` works on a multiplicative scale. Trying linear values like `[1, 2, 3, 4, 5]` is wasteful because 1 vs 2 is a big change but 1000 vs 1001 is tiny. A logarithmic grid `[0.001, 0.01, 0.1, 1, 10]` covers a much wider range with the same number of trials. This is the standard practice and what the course material uses.

### Why does the final script not split the data?

We did the train/validation split inside `02_search.ipynb` — that was for **choosing** the best model. Once we know which model wins, we train it on **all** the available training data to make the best possible predictions on the Kaggle test set. This is standard practice.

### Why does the script predict more "closed" restaurants than the original rate?

The training data is ~10% closed, but our model predicts about 40% of test restaurants as closed. This is **expected behavior** when we use `class_weight="balanced"`. The model is optimizing balanced accuracy, not predicting the original class proportions — so it deliberately catches more closed restaurants at the cost of some false positives. Balanced accuracy rewards exactly this behavior. If we wanted to match the original 10% rate, we would lose a lot of true positives on the closed class.

---

## Reproducibility

We set `random_state=42` everywhere (the train/validation split, the cross-validation folds, the model). Running the code twice on the same machine should produce the same `submission.csv`.

If you run the script on a different machine, the results might differ very slightly due to:

- Different versions of scikit-learn or its dependencies.
- Different BLAS/LAPACK numerical libraries.

We tested with **scikit-learn 1.8 or newer** and **Python 3.12**.
