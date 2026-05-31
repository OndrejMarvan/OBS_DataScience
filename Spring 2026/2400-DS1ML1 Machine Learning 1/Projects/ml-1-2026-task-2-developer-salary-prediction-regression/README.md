# Project 2 — Developer Salary (Regression)

**Machine Learning 1** · WNE UW · academic year 2025/2026

In this project we predict the annual salary (in USD) of software developers based on their personal details, skills, and work setup.

---

## The dataset

- **Training set**: 2,512 rows × 41 columns (40 features + the target `annual.pay.usd`)
- **Test set**: 628 rows × 41 columns (40 features + an `id` column for matching predictions)
- The target is **very right-skewed**: median salary is around $40,000, but the maximum is $4.77 million.

The features describe each developer in different ways:

- **Numeric** features (4 columns) — years of coding (total and professional), years of work experience, and a job satisfaction score from 0 to 10.
- **Plain categorical** features (21 columns) — region, age group, education, employment type, company size, etc. One value per row.
- **Multi-label** features (15 columns) — programming languages, databases, cloud platforms, tools, etc. **Each cell can contain multiple values separated by semicolons**, like `"Python;SQL;JavaScript;TypeScript"`. These need special handling.

---

## The metric: RMSE

Kaggle grades our submissions using **Root Mean Squared Error (RMSE)** in USD:

$$\text{RMSE} = \sqrt{\frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y}_i)^2}$$

Lower is better. RMSE is in the same units as the target — an RMSE of $35,000 means our average prediction error is about $35k.

**Important caveat for this dataset**: RMSE squares the errors, so a single $4M outlier contributes $16 trillion to the loss. This makes the RMSE metric **very noisy** on this dataset — a single extreme earner falling into or out of a fold can change the score by a factor of 5.

---

## What we did

### Step 1 — Exploratory Data Analysis (`01_eda.ipynb`)

We looked at the data and made the most important findings:

1. The target is **extremely right-skewed** (skewness = 33). A few million-dollar earners stretch the right tail far beyond where most developers actually earn. **This forces us to log-transform the target.**
2. Many columns have missing values, especially AI-related questions (30-35% missing).
3. **15 columns are multi-label** (semicolon-separated lists). These need a custom encoder.
4. The strongest predictors look like **region**, **education**, **years of professional coding**, **age group**, **company size**, and specific **programming languages**.

### Step 2 — Preprocessing decisions

| Type of column | What we do |
|---|---|
| Numeric | Fill missing with the median, then standardize (subtract mean, divide by standard deviation) |
| Plain categorical | Fill missing with the most frequent value, then one-hot encode |
| Multi-label | Custom `MultiLabelColumnEncoder` — splits on `;` and creates one binary column per unique token |
| Target (`annual.pay.usd`) | Wrap in `TransformedTargetRegressor` — predict `log1p(salary)`, then `expm1` to get back to USD |

All preprocessing happens **inside a scikit-learn `Pipeline`**, so during cross-validation the imputer and scaler are fitted only on the training portion of each fold. This avoids data leakage.

### Why multi-label encoding matters

A column like `prog.languages` might contain `"Python;JavaScript;SQL"`. Standard one-hot encoding would treat each unique combination as a separate category — but there are **1,355 unique combinations** of languages across the dataset, even though there are only **40 unique individual languages**.

Our `MultiLabelColumnEncoder` splits each cell on `;` and creates one 0/1 column per unique token. So `prog.languages` becomes `lang_Python`, `lang_JavaScript`, `lang_SQL`, etc. — about 40 columns. The model can then learn "knowing Python is worth +X dollars" and apply it to anyone who lists Python, regardless of what other languages they listed.

Across the 15 multi-label columns, this produces about **200+ binary features**.

### Why we log-transform the target

The salary distribution has skewness of 33 — extreme right tail. If we trained on the raw USD scale, the few million-dollar earners would dominate the loss and the model would ignore the typical $40k developer.

We use scikit-learn's `TransformedTargetRegressor`, which:
- Applies `np.log1p` to the target before fitting (safer than `log` when values might be zero)
- Trains the model on the log-transformed target
- Applies `np.expm1` to predictions to get back to USD
- Lets us still compute RMSE on the original USD scale (which is what Kaggle grades)

After log-transformation, target skewness drops from 33 to about −1.6 — much closer to normal.

### Step 3 — Model comparison (`02_search.ipynb`)

We compared three algorithms (the assessment requires at least three), all from the ML1 syllabus:

1. **Elastic Net** — combines L1 (Lasso) and L2 (Ridge) regularization
2. **K-Nearest Neighbors Regressor**
3. **Linear SVR** (Support Vector Regression with linear kernel)

For all of them we:

- Used **5-fold cross-validation** with `scoring="neg_root_mean_squared_error"`.
- Tuned hyperparameters on a **logarithmic grid** (e.g. `alpha ∈ {0.001, 0.01, 0.1, 1, 10}`).
- Wrapped each model in `TransformedTargetRegressor` for the log-transform.

### Why not SVR with the RBF kernel?

With ~485 features after encoding, kernel SVR would be slow and prone to overfitting on only 2,512 rows. **LinearSVR** is fast (full grid runs in seconds) and well-regularized, while still being an SVM with one of the "various kernels" from the syllabus.

---

## Final results

| Model | Best hyperparameters | CV RMSE (USD) | Val RMSE (USD) | Val RMSE (log scale) |
|---|---|---|---|---|
| Baseline (predict median) | — | — | $65,632 | ≈ 1.59 |
| **Elastic Net** | **α=0.1, l1_ratio=0.1** | **$90,024** | **$66,658** | **1.371** |
| LinearSVR | C=0.01 | $93,430 | $67,139 | 1.447 |
| KNN Regressor | k=11, weights=distance | $92,536 | $68,341 | 1.465 |

**Our winner: Elastic Net with α=0.1 and l1_ratio=0.1.**

The hyperparameters lean heavily toward Ridge (L2) — only 10% Lasso. This makes sense given our ~485 features: most carry partial signal, so we want stability across correlated features (L2) more than aggressive feature dropping (L1).

### A note on the noisy USD-scale RMSE

The CV RMSE ($90k) looks much worse than the validation RMSE ($67k). This happens because the dataset has a few extreme outliers (one developer reports $4.77M salary), and whether that point falls into a CV fold or the held-out validation set dramatically changes the score.

Looking at the **per-fold CV scores** for Elastic Net:

- Fold 1: $240,417 RMSE (this fold contains the $4.77M outlier)
- Fold 2: $39,856
- Fold 3: $36,444
- Fold 4: $60,544
- Fold 5: $72,859

One fold is 6× larger than the smallest. The mean is $90k but the standard deviation across folds is $76k. Both numbers are honest measurements of a noisy metric.

### The log-scale RMSE tells the cleaner story

On the log-scale RMSE (which is what the models actually optimize):

- Elastic Net: **1.371**
- LinearSVR: 1.447
- KNN: 1.465
- Baseline (predict median): ≈ 1.59

This is a **24% improvement** in log-scale RMSE over the baseline. KNN being slightly worse than LinearSVR matches our expectation (curse of dimensionality). LinearSVR being slightly worse than Elastic Net matches the usual result for heteroscedastic targets like salaries.

---

## Files in this folder

```
task2-salary/
├── 01_eda.ipynb              ← exploratory analysis with plots and decisions
├── 02_search.ipynb           ← model comparison and hyperparameter tuning
├── 03_final_pipeline.py      ← trains the winning model and produces submission.csv
├── README.md                 ← this file
├── data/
│   ├── train.csv             ← training data (from Kaggle)
│   ├── test.csv              ← test data (from Kaggle)
│   └── sample_submission.csv ← Kaggle's example of the right format
└── outputs/
    ├── model_comparison.csv  ← summary table of all models we tried
    └── submission.csv        ← the file we upload to Kaggle
```

The `01_eda.ipynb` and `02_search.ipynb` notebooks are the "search code" — they show our whole experimentation process. The `03_final_pipeline.py` is the "single best algorithm" code — it just trains the winning model and produces predictions. This separation matches what the assessment asks for.

---

## How to run

### What you need

- **Python 3.12 or newer**
- The libraries `pandas`, `numpy`, `scikit-learn`, `matplotlib`, `seaborn`, `jupyter`

### Quick way (using pip)

```bash
# 1. Go to this project folder
cd task2-salary

# 2. Create a virtual environment
python3 -m venv .venv

# 3. Turn it on
source .venv/bin/activate            # Linux / macOS
# .venv\Scripts\activate              (on Windows)

# 4. Install the libraries
pip install pandas numpy scikit-learn matplotlib seaborn jupyter

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
cd task2-salary

# 4. Run the script
uv run --with pandas --with scikit-learn --with numpy python 03_final_pipeline.py

# To open the notebooks:
uv run --with pandas --with scikit-learn --with numpy --with matplotlib --with seaborn jupyter lab
```

---

## What the script prints

When you run `03_final_pipeline.py`, it tells you what it is doing at each step:

```
======================================================================
COMPLETE PIPELINE — Developer Salary regression (Task 2)
======================================================================

[STEP 1] Loading training and test data
  Training set: 2512 rows, 41 columns
  Test set:     628 rows, 41 columns
  Target range: $1 to $4,773,360
  Target median: $40,829

[STEP 2] Identifying feature types
  Numeric features:        4
  Plain categorical:       21
  Multi-label categorical: 15
  Total features:          40

[STEP 3] Building preprocessing pipeline
[STEP 4] Building final model pipeline
[STEP 5] Training on full training data
  Training time: 1.2 seconds
  Training RMSE: $...

[STEP 6] Predicting on the Kaggle test set
[STEP 7] Saving submission file
  Wrote outputs/submission.csv

DONE. Total time: ~3 seconds
```

The whole script runs in just a few seconds.

---

## How to submit to Kaggle

1. Run `03_final_pipeline.py` to produce `outputs/submission.csv`.
2. Go to the competition page: https://www.kaggle.com/competitions/ml-1-2026-task-2-developer-salary-prediction-regression
3. Click **"Submit Predictions"** and upload `outputs/submission.csv`.
4. Kaggle gives you a public leaderboard score based on 30% of the test set. The final grade uses the other 70%.

**Deadline: May 28, 2026, 23:55.**

---

## A few choices explained

### Why pipelines everywhere?

A `Pipeline` keeps preprocessing and the model together as one object. The big benefit is that during cross-validation, the imputer's median, the scaler's mean, and the one-hot encoder's category list are computed **only from the training portion of each fold**. If we did the preprocessing once on the whole dataset before splitting, information from the validation set would leak into the training process and our cross-validation scores would be too optimistic.

### Why is the multi-label encoder custom?

scikit-learn's `OneHotEncoder` can split values into categories, but it doesn't know what to do with semicolon-separated lists. scikit-learn has `MultiLabelBinarizer` for this, but it expects a list of lists and doesn't fit cleanly inside a `ColumnTransformer`. So we wrote a small wrapper class (`MultiLabelColumnEncoder`) that applies `MultiLabelBinarizer` to each multi-label column independently and exposes a standard `fit`/`transform` interface. This way it works seamlessly inside our `Pipeline` and `GridSearchCV`.

### Why log-transform the target?

Salary distributions are right-skewed because of a few extreme earners. RMSE squares the residuals, so without log-transformation a single $4M miss contributes more to the loss than thousands of $20k misses combined. The model would learn to chase millionaires and ignore typical developers. Log-transformation compresses the extreme tail and gives the model a fair chance to learn the typical-developer signal.

### Why Elastic Net with l1_ratio = 0.1 (mostly Ridge)?

We have ~485 features after encoding — 4 numeric, ~120 from one-hot encoding categoricals, ~360 from multi-label binarization. Most of these features carry **partial** signal: most languages, tools, regions are at least somewhat informative. Lasso (l1_ratio = 1) would aggressively drop features, losing this distributed signal. Ridge (l1_ratio = 0) keeps everything but might let highly correlated features fight each other. A small bit of L1 (l1_ratio = 0.1) gives us mostly Ridge stability with a tiny bit of sparsity for the truly useless features.

### Why does the final script not split the data?

We did the train/validation split inside `02_search.ipynb` — that was for **choosing** the best model and hyperparameters. Once we know which model wins, we train it on **all** the available training data to make the best possible predictions on the Kaggle test set. This is standard practice.

---

## Reproducibility

We set `random_state=42` everywhere (the train/validation split, the cross-validation folds, the model). Running the code twice on the same machine should produce the same `submission.csv`.

If you run the script on a different machine, the results might differ very slightly due to:

- Different versions of scikit-learn or its dependencies.
- Different BLAS/LAPACK numerical libraries.

We tested with **scikit-learn 1.8 or newer** and **Python 3.12**.
