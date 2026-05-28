# ==============================================================================
# 00_setup.R
# EUR/PLN Exchange Rate & Interest Rate Differential — Advanced Econometrics
# Author: Ondřej [Surname]
# ==============================================================================

# ── Packages ──────────────────────────────────────────────────────────────────
required_packages <- c(
  "tidyverse",   # data wrangling & ggplot2
  "readr",       # CSV import
  "lubridate",   # date handling
  "tseries",     # ADF test (adf.test)
  "urca",        # unit root & cointegration (ur.df, ur.kpss, ca.jo)
  "vars",        # VAR / VECM models
  "ARDL",        # ARDL bounds test (ardl, bounds_f_test)
  "forecast",    # ARIMA (auto.arima, forecast)
  "lmtest",      # diagnostic tests (bgtest, bptest)
  "sandwich",    # robust standard errors
  "ggthemes",    # plot themes
  "patchwork"    # combining plots
)

# Install any missing packages
new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
if (length(new_packages) > 0) {
  message("Installing missing packages: ", paste(new_packages, collapse = ", "))
  install.packages(new_packages)
}

invisible(lapply(required_packages, library, character.only = TRUE))

# ── Global settings ───────────────────────────────────────────────────────────
options(scipen = 999)          # suppress scientific notation
Sys.setlocale("LC_TIME", "C") # consistent date parsing across OS

# ── Paths ─────────────────────────────────────────────────────────────────────
# Place raw CSV files in the data/ subfolder before running 01_data.R
DATA_DIR   <- "data/"
OUTPUT_DIR <- "output/"

dir.create(DATA_DIR,   showWarnings = FALSE)
dir.create(OUTPUT_DIR, showWarnings = FALSE)

# ── Colour palette (used in 03_plots.R) ───────────────────────────────────────
COL_EURRPLN  <- "#2C3E7A"   # dark blue — EUR/PLN rate
COL_DIFF     <- "#C0392B"   # red       — interest rate differential
COL_FITTED   <- "#888888"   # grey      — model fitted values

message("✔ Setup complete. Place data CSVs in '", DATA_DIR, "' and run 01_data.R.")
