# ==============================================================================
# 03_plots.R
# All figures for the report. Run after 02_analysis.R.
# Saves PNGs (300 dpi) to output/.
# ==============================================================================

source("00_setup.R")

df <- read_csv(file.path(OUTPUT_DIR, "df_clean.csv"), show_col_types = FALSE) %>%
  arrange(date)
res <- if (file.exists(file.path(OUTPUT_DIR, "analysis_results.rds")))
         readRDS(file.path(OUTPUT_DIR, "analysis_results.rds")) else NULL
has_brent <- "ln_brent" %in% names(df)

theme_set(theme_minimal(base_size = 12))
save_fig <- function(p, name, w = 9, h = 5) {
  ggsave(file.path(OUTPUT_DIR, name), p, width = w, height = h, dpi = 300)
  message("  saved ", name)
}

# ── Fig 1: EUR/PLN and interest rate differential over time ───────────────────
p_eur <- ggplot(df, aes(date, eurpln)) +
  geom_line(colour = COL_EURRPLN, linewidth = 0.7) +
  labs(title = "EUR/PLN exchange rate", x = NULL, y = "PLN per EUR")

p_diff <- ggplot(df, aes(date, rate_diff)) +
  geom_line(colour = COL_DIFF, linewidth = 0.7) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey50") +
  labs(title = "NBP - ECB interest rate differential",
       x = NULL, y = "percentage points")

save_fig(p_eur / p_diff, "fig1_series.png", h = 7)

# ── Fig 2: Policy rates ───────────────────────────────────────────────────────
rates_long <- df %>%
  select(date, nbp_rate, ecb_rate) %>%
  pivot_longer(-date, names_to = "series", values_to = "rate")

p_rates <- ggplot(rates_long, aes(date, rate, colour = series)) +
  geom_line(linewidth = 0.7) +
  scale_colour_manual(values = c(nbp_rate = COL_EURRPLN, ecb_rate = COL_DIFF),
                      labels = c(ecb_rate = "ECB MRR", nbp_rate = "NBP reference")) +
  labs(title = "Central bank policy rates", x = NULL, y = "%", colour = NULL) +
  theme(legend.position = "top")

save_fig(p_rates, "fig2_rates.png")

# ── Fig 3: First difference of log EUR/PLN (monthly returns) ──────────────────
df_d <- df %>% mutate(d_ln = c(NA, diff(ln_eurpln))) %>% filter(!is.na(d_ln))
p_ret <- ggplot(df_d, aes(date, d_ln)) +
  geom_line(colour = COL_EURRPLN, linewidth = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey50") +
  labs(title = "First difference of log EUR/PLN (monthly log-returns)",
       x = NULL, y = expression(Delta~ln(EUR/PLN)))
save_fig(p_ret, "fig3_returns.png")

# ── Fig 4: ACF / PACF of log EUR/PLN (level and difference) ───────────────────
a1 <- forecast::ggAcf(df$ln_eurpln)  + labs(title = "ACF: ln(EUR/PLN) level")
a2 <- forecast::ggAcf(diff(df$ln_eurpln)) + labs(title = "ACF: differenced")
p1 <- forecast::ggPacf(df$ln_eurpln) + labs(title = "PACF: ln(EUR/PLN) level")
p2 <- forecast::ggPacf(diff(df$ln_eurpln)) + labs(title = "PACF: differenced")
save_fig((a1 | a2) / (p1 | p2), "fig4_acf_pacf.png", h = 7)

# ── Fig 5: ARDL actual vs fitted ──────────────────────────────────────────────
if (!is.null(res) && !is.null(res$ardl_model)) {
  fit_df <- tibble(
    date   = df$date[(nrow(df) - length(fitted(res$ardl_model)) + 1):nrow(df)],
    actual = df$ln_eurpln[(nrow(df) - length(fitted(res$ardl_model)) + 1):nrow(df)],
    fitted = as.numeric(fitted(res$ardl_model))
  ) %>% pivot_longer(-date, names_to = "type", values_to = "value")

  p_fit <- ggplot(fit_df, aes(date, value, colour = type)) +
    geom_line(linewidth = 0.6) +
    scale_colour_manual(values = c(actual = COL_EURRPLN, fitted = COL_FITTED)) +
    labs(title = "ARDL model: actual vs fitted ln(EUR/PLN)",
         x = NULL, y = "ln(EUR/PLN)", colour = NULL) +
    theme(legend.position = "top")
  save_fig(p_fit, "fig5_ardl_fit.png")
}

# ── Fig 6: ARIMA forecast vs realised (holdout) ───────────────────────────────
if (!is.null(res) && !is.null(res$arima_fit)) {
  h <- 12
  y  <- ts(df$ln_eurpln, start = c(year(min(df$date)), month(min(df$date))),
           frequency = 12)
  fc <- forecast::forecast(res$arima_fit, h = h)
  png(file.path(OUTPUT_DIR, "fig6_arima_forecast.png"),
      width = 9, height = 5, units = "in", res = 300)
  plot(fc, main = "ARIMA baseline: 12-month forecast vs realised",
       xlab = NULL, ylab = "ln(EUR/PLN)")
  lines(y, col = COL_DIFF)
  dev.off()
  message("  saved fig6_arima_forecast.png")
}

# ── Fig 7: CUSUM parameter-stability test on the long-run OLS ─────────────────
if (!is.null(res) && !is.null(res$eg_ols)) {
  ocus <- strucchange::efp(formula(res$eg_ols), data = df, type = "OLS-CUSUM")
  png(file.path(OUTPUT_DIR, "fig7_cusum.png"),
      width = 9, height = 5, units = "in", res = 300)
  plot(ocus, main = "OLS-CUSUM stability test (long-run relationship)")
  dev.off()
  message("  saved fig7_cusum.png")
}

message("All figures written to output/.")
