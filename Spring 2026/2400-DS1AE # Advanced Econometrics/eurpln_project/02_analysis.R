# ==============================================================================
# 02_analysis.R
# Econometric analysis: unit roots -> cointegration -> ARDL/VECM -> ARIMA
# Run after 01_data.R (reads output/df_clean.csv)
# ==============================================================================

source("00_setup.R")

# Load the clean dataset produced by 01_data.R.
# (Reading the saved CSV avoids re-hitting the NBP API on every run.)
if (file.exists(file.path(OUTPUT_DIR, "df_clean.csv"))) {
  df <- read_csv(file.path(OUTPUT_DIR, "df_clean.csv"), show_col_types = FALSE)
} else {
  stop("output/df_clean.csv not found - run 01_data.R first.")
}

df <- df %>% arrange(date)
n  <- nrow(df)
message(sprintf("Loaded %d monthly observations (%s to %s)",
                n, min(df$date), max(df$date)))

# Does the dataset include the Brent control?
has_brent <- "ln_brent" %in% names(df)
if (has_brent) message("Brent control detected - running multivariate model.")

# Helper for tidy section headers in the console
section <- function(txt) {
  cat("\n", strrep("=", 78), "\n", txt, "\n", strrep("=", 78), "\n", sep = "")
}

# ==============================================================================
# STEP 1 - UNIT ROOT / STATIONARITY TESTS
# ==============================================================================
# We test each series for a unit root with two complementary tests:
#   - ADF  (urca::ur.df): H0 = unit root (non-stationary)
#   - KPSS (urca::ur.kpss): H0 = stationary
# Agreement between the two gives a confident classification of I(0) vs I(1).
# We test levels first, then first differences.
section("STEP 1: Unit root tests (ADF & KPSS)")

test_series <- list(
  ln_eurpln = df$ln_eurpln,
  rate_diff = df$rate_diff
)
if (has_brent) test_series$ln_brent <- df$ln_brent

# Run ADF (with drift+trend on levels) and KPSS, in levels and 1st differences
unit_root_report <- function(x, name) {
  x  <- as.numeric(x)
  dx <- diff(x)

  # --- ADF: type "trend" for levels, "drift" for differences ---
  adf_lvl <- ur.df(x,  type = "trend", selectlags = "AIC")
  adf_dif <- ur.df(dx, type = "drift", selectlags = "AIC")

  # --- KPSS: "tau" (trend-stationary) for levels, "mu" for differences ---
  kpss_lvl <- ur.kpss(x,  type = "tau")
  kpss_dif <- ur.kpss(dx, type = "mu")

  cat(sprintf("\n--- %s ---\n", name))
  cat(sprintf("ADF  level : tstat = %6.3f | 5%% crit = %6.3f\n",
              adf_lvl@teststat[1], adf_lvl@cval[1, "5pct"]))
  cat(sprintf("ADF  diff  : tstat = %6.3f | 5%% crit = %6.3f\n",
              adf_dif@teststat[1], adf_dif@cval[1, "5pct"]))
  cat(sprintf("KPSS level : tstat = %6.3f | 5%% crit = %6.3f\n",
              kpss_lvl@teststat[1], kpss_lvl@cval["5pct"]))
  cat(sprintf("KPSS diff  : tstat = %6.3f | 5%% crit = %6.3f\n",
              kpss_dif@teststat[1], kpss_dif@cval["5pct"]))

  # Simple rule-of-thumb classification (ADF: reject H0 if tstat < crit)
  adf_lvl_stat <- adf_lvl@teststat[1] < adf_lvl@cval[1, "5pct"]
  adf_dif_stat <- adf_dif@teststat[1] < adf_dif@cval[1, "5pct"]
  verdict <- if (!adf_lvl_stat && adf_dif_stat) "I(1)" else
             if (adf_lvl_stat) "I(0)" else "check higher order"
  cat(sprintf(">> Likely order of integration: %s\n", verdict))
  invisible(verdict)
}

orders <- mapply(unit_root_report, test_series, names(test_series))
print(orders)

# IMPORTANT METHOD NOTE (read in report):
# Cointegration requires all series to be I(1). If rate_diff turns out I(0),
# Engle-Granger / Johansen are invalid for it, and the ARDL bounds test
# (valid for a mix of I(0)/I(1)) becomes the MAIN model - see Step 3b.

# ==============================================================================
# STEP 2 - DESCRIPTIVE TIME-SERIES OBJECTS
# ==============================================================================
section("STEP 2: Build ts objects")

start_y <- year(min(df$date)); start_m <- month(min(df$date))
y  <- ts(df$ln_eurpln, start = c(start_y, start_m), frequency = 12)
x1 <- ts(df$rate_diff, start = c(start_y, start_m), frequency = 12)
if (has_brent) x2 <- ts(df$ln_brent, start = c(start_y, start_m), frequency = 12)
message("ts objects created (monthly, frequency = 12).")

# ==============================================================================
# STEP 3a - ENGLE-GRANGER & JOHANSEN COINTEGRATION
# ==============================================================================
section("STEP 3a: Cointegration tests")

# --- Engle-Granger via Phillips-Ouliaris (designed for cointegration) ---
# po.test uses the correct cointegration critical values (unlike a plain ADF
# on residuals with standard CVs).
eg_matrix <- if (has_brent) cbind(y, x1, x2) else cbind(y, x1)
po <- tseries::po.test(eg_matrix)
cat("\nPhillips-Ouliaris cointegration test:\n")
print(po)

# Static long-run regression (the Engle-Granger first stage), for reference
eg_formula <- if (has_brent) { ln_eurpln ~ rate_diff + ln_brent } else { ln_eurpln ~ rate_diff }
eg_ols <- lm(eg_formula, data = df)
cat("\nStatic long-run (Engle-Granger 1st stage) OLS:\n")
print(summary(eg_ols))

# --- Johansen trace test ---
joh_data <- if (has_brent) { df[, c("ln_eurpln", "rate_diff", "ln_brent")] } else { df[, c("ln_eurpln", "rate_diff")] }
johansen <- ca.jo(joh_data, type = "trace", ecdet = "const", K = 2)
cat("\nJohansen trace test:\n")
print(summary(johansen))

# ==============================================================================
# STEP 3b - ARDL BOUNDS TEST (Pesaran, Shin & Smith 2001)
# ==============================================================================
# Valid whether regressors are I(0), I(1), or mixed - so this is our robust
# main specification regardless of the Step 1 outcome.
section("STEP 3b: ARDL bounds test")

ardl_formula <- if (has_brent) { ln_eurpln ~ rate_diff + ln_brent } else { ln_eurpln ~ rate_diff }

# Auto-select optimal lag orders by AIC
auto_fit <- ARDL::auto_ardl(
  ardl_formula, data = df,
  max_order = 4, selection = "AIC"
)
best_order <- auto_fit$best_order
cat(sprintf("\nSelected ARDL order (AIC): %s\n",
            paste(best_order, collapse = ", ")))

ardl_model <- auto_fit$best_model
cat("\nARDL model summary:\n")
print(summary(ardl_model))

# Bounds F-test for a long-run (levels) relationship.
# case = 3: unrestricted constant, no trend (standard for this kind of model)
bounds <- ARDL::bounds_f_test(ardl_model, case = 3)
cat("\nARDL bounds F-test (case 3: unrestricted constant, no trend):\n")
print(bounds)

# Long-run multipliers (the equilibrium relationship)
cat("\nLong-run multipliers:\n")
print(ARDL::multipliers(ardl_model))

# Error-correction (short-run) representation
ecm_model <- ARDL::recm(ardl_model, case = 3)
cat("\nError-correction model (short-run dynamics + speed of adjustment):\n")
print(summary(ecm_model))

# ==============================================================================
# STEP 3c - VECM (only meaningful if Johansen finds cointegration)
# ==============================================================================
section("STEP 3c: VECM (conditional on Johansen result)")

# Extract long-run (beta) vector from Johansen for reporting
vecm_ols <- cajorls(johansen, r = 1)   # assume rank 1; revisit per trace test
cat("\nVECM (rank = 1 assumed - confirm against the trace statistics above):\n")
print(vecm_ols)

# ==============================================================================
# STEP 4 - ARIMA BASELINE (forecast comparison)
# ==============================================================================
# A univariate ARIMA on ln_eurpln gives a benchmark: does adding the interest
# rate differential (and Brent) actually beat a pure time-series model?
section("STEP 4: ARIMA baseline")

# Hold out the last 12 months to compare forecast accuracy fairly
h <- 12
y_train <- window(y, end = time(y)[length(y) - h])
y_test  <- window(y, start = time(y)[length(y) - h + 1])

arima_fit <- forecast::auto.arima(y_train, seasonal = TRUE, stepwise = FALSE,
                                  approximation = FALSE)
cat("\nSelected ARIMA model:\n")
print(arima_fit)

arima_fc <- forecast::forecast(arima_fit, h = h)
arima_acc <- forecast::accuracy(arima_fc, y_test)
cat("\nARIMA out-of-sample accuracy (last 12 months):\n")
print(arima_acc)

# ==============================================================================
# STEP 5 - RESIDUAL DIAGNOSTICS (on the ARDL model)
# ==============================================================================
section("STEP 5: Diagnostics on the ARDL model")

cat("\nBreusch-Godfrey test for serial correlation (lags = 12):\n")
print(lmtest::bgtest(ardl_model, order = 12))

cat("\nBreusch-Pagan test for heteroskedasticity:\n")
print(lmtest::bptest(ardl_model))

cat("\nJarque-Bera test for residual normality:\n")
print(tseries::jarque.bera.test(residuals(ardl_model)))

cat("\nRamsey RESET test for functional form:\n")
print(lmtest::resettest(ardl_model, power = 2:3, type = "fitted"))

# Zivot-Andrews test: unit root allowing one endogenous structural break
# (robustness check promised in the proposal). Run on the log exchange rate.
cat("\nZivot-Andrews unit root test (one break in intercept):\n")
za <- ur.za(df$ln_eurpln, model = "intercept")
print(summary(za))

# ==============================================================================
# STEP 6 - SAVE KEY OBJECTS
# ==============================================================================
section("STEP 6: Save results")

saveRDS(
  list(
    unit_root_orders = orders,
    po_test          = po,
    eg_ols           = eg_ols,
    johansen         = johansen,
    ardl_model       = ardl_model,
    bounds           = bounds,
    ecm_model        = ecm_model,
    arima_fit        = arima_fit,
    arima_acc        = arima_acc,
    za               = za
  ),
  file.path(OUTPUT_DIR, "analysis_results.rds")
)
message("Results saved to output/analysis_results.rds")
message("Analysis complete. Run 03_plots.R for figures.")
