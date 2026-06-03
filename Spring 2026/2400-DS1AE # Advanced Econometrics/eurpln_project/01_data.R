# ==============================================================================
# 01_data.R
# Load, clean, and merge EUR/PLN, interest rates, and Brent
# Run after 00_setup.R
# ==============================================================================

source("00_setup.R")

# ==============================================================================
# DATA SOURCES
# ==============================================================================
# 1. EUR/PLN  : NBP Table A archive CSVs in data/ (archiwum_tab_a_YYYY.csv)
# 2. NBP rate : built-in reference-rate change history (see table below)
# 3. ECB rate : ECB Data Portal CSV in data/ (any filename containing "ECB")
# 4. Brent    : fetched from stooq.com (fallback data/brent.csv)
# ==============================================================================

# ── 1. EUR/PLN from NBP Table A archive CSVs ──────────────────────────────────
message("Loading EUR/PLN from NBP Table A archive CSVs...")

tab_a_files <- list.files(DATA_DIR, pattern = "archiwum_tab_a_\\d{4}\\.csv$",
                          full.names = TRUE)
if (length(tab_a_files) == 0)
  stop("No archiwum_tab_a_YYYY.csv files found in ", DATA_DIR)

read_tab_a <- function(path) {
  # NBP archive: ';'-separated, comma decimals, date as YYYYMMDD, header row
  # like "data;1USD;1EUR;...". A trailing footer row is dropped by the date filter.
  raw <- readr::read_delim(
    path, delim = ";",
    locale = locale(decimal_mark = ",", encoding = "Latin1"),
    col_types = cols(.default = col_character()),
    trim_ws = TRUE, show_col_types = FALSE, name_repair = "unique_quiet"
  )
  names(raw) <- tolower(trimws(names(raw)))

  date_col <- names(raw)[grepl("data|date", names(raw))][1]
  eur_col  <- names(raw)[grepl("eur", names(raw))][1]
  if (is.na(eur_col)) stop("No EUR column found in ", basename(path))

  raw %>%
    transmute(
      date_raw = .data[[date_col]],
      eur_raw  = .data[[eur_col]]
    ) %>%
    filter(grepl("^\\d{8}$", date_raw)) %>%          # keep real data rows only
    mutate(
      date   = ymd(date_raw),
      eurpln = as.numeric(gsub(",", ".", eur_raw))
    ) %>%
    select(date, eurpln) %>%
    filter(!is.na(date), !is.na(eurpln))
}

eurpln_daily <- map_dfr(tab_a_files, read_tab_a) %>% arrange(date)

# Aggregate to monthly (last available rate per month)
eurpln <- eurpln_daily %>%
  mutate(ym = floor_date(date, "month")) %>%
  group_by(ym) %>%
  slice_tail(n = 1) %>%
  ungroup() %>%
  select(date = ym, eurpln)

message(sprintf("  EUR/PLN: %d monthly obs, %s to %s",
                nrow(eurpln), min(eurpln$date), max(eurpln$date)))

# ── 2. NBP reference rate (built-in change history) ───────────────────────────
# Source: NBP Monetary Policy Council decisions. Values are the reference rate
# (%) effective from each change date. If you have an official CSV, drop it in
# as data/nbp_rate.csv (cols: date, nbp_rate) and it will override this table.
#
# >>> VERIFY THE 2025Q4–2026 ROWS against the NBP archive: the bank kept cutting
#     from 4.75% (Sep 2025) to 3.75% (by Mar 2026). The 4.50%/4.00% intermediate
#     steps below are best-estimates of the dated moves and should be confirmed.
message("Building NBP reference rate series...")

nbp_changes <- tribble(
  ~date,         ~nbp_rate,
  "2012-01-01",  4.50,   # level at start of sample
  "2012-05-10",  4.75,
  "2012-11-08",  4.50,
  "2012-12-06",  4.25,
  "2013-01-10",  4.00,
  "2013-02-07",  3.75,
  "2013-03-07",  3.25,
  "2013-05-09",  3.00,
  "2013-06-06",  2.75,
  "2013-07-04",  2.50,
  "2014-10-09",  2.00,
  "2015-03-05",  1.50,
  "2020-03-18",  1.00,
  "2020-04-09",  0.50,
  "2020-05-29",  0.10,
  "2021-10-07",  0.50,
  "2021-11-04",  1.25,
  "2021-12-09",  1.75,
  "2022-01-05",  2.25,
  "2022-02-09",  2.75,
  "2022-03-09",  3.50,
  "2022-04-07",  4.50,
  "2022-05-06",  5.25,
  "2022-06-09",  6.00,
  "2022-07-08",  6.50,
  "2022-09-08",  6.75,
  "2023-09-07",  6.00,
  "2023-10-05",  5.75,
  "2025-05-07",  5.25,
  "2025-07-02",  5.00,
  "2025-09-03",  4.75,
  "2025-11-05",  4.50,   # VERIFY
  "2026-01-01",  4.00,   # VERIFY (intermediate Q4'25–Q1'26 steps)
  "2026-03-04",  3.75    # VERIFY
) %>% mutate(date = as.Date(date))

# Override with an official file if the user provides one
nbp_file <- file.path(DATA_DIR, "nbp_rate.csv")
if (file.exists(nbp_file)) {
  message("  Found data/nbp_rate.csv — using it instead of the built-in table.")
  nf <- read_delim(nbp_file, delim = ";",
                   locale = locale(decimal_mark = ","), show_col_types = FALSE)
  names(nf) <- tolower(names(nf))
  nbp_changes <- nf %>%
    select(1, 2) %>%
    setNames(c("date", "nbp_rate")) %>%
    mutate(date = as.Date(parse_date_time(date, orders = c("ymd", "dmy"))),
           nbp_rate = as.numeric(nbp_rate)) %>%
    filter(!is.na(date), !is.na(nbp_rate)) %>%
    arrange(date)
}

# Map each month to the rate IN EFFECT at MONTH-END, to match the
# end-of-month EUR/PLN observation (otherwise a mid-month rate change would
# be misattributed to the following month).
nbp_changes <- nbp_changes %>% arrange(date)
monthly_grid <- tibble(date = seq(floor_date(min(eurpln$date), "month"),
                                  floor_date(max(eurpln$date), "month"),
                                  by = "month"))
month_end <- ceiling_date(monthly_grid$date, "month") - days(1)
idx <- findInterval(month_end, nbp_changes$date)
nbp_rate_monthly <- monthly_grid %>%
  mutate(nbp_rate = ifelse(idx >= 1, nbp_changes$nbp_rate[idx], NA_real_)) %>%
  filter(!is.na(nbp_rate))

message(sprintf("  NBP rate: %d monthly obs, %s to %s",
                nrow(nbp_rate_monthly), min(nbp_rate_monthly$date),
                max(nbp_rate_monthly$date)))

# ── 3. ECB main refinancing rate ──────────────────────────────────────────────
# ECB Data Portal export: columns TIME_PERIOD and OBS_VALUE.
# Dates can be daily ("2005-01-03") or monthly ("2005-01").
message("Loading ECB rate...")

ecb_file <- list.files(DATA_DIR, pattern = "ECB.*\\.csv$", full.names = TRUE)[1]
if (is.na(ecb_file)) ecb_file <- file.path(DATA_DIR, "ecb_rate.csv")
ecb_rate_raw <- read_csv(ecb_file, show_col_types = FALSE)
names(ecb_rate_raw) <- tolower(names(ecb_rate_raw))
nm <- names(ecb_rate_raw)

date_col <- if ("time_period" %in% nm) "time_period" else nm[grepl("date|time|period", nm)][1]
val_col  <- if ("obs_value"   %in% nm) "obs_value"   else nm[grepl("obs_value|value|rate|mrr", nm)][1]

parse_ecb_date <- function(z) {
  z <- as.character(z)
  z <- ifelse(grepl("^\\d{4}-\\d{2}$", z), paste0(z, "-01"), z)
  as.Date(z)
}

ecb_rate <- ecb_rate_raw %>%
  transmute(
    date_raw = .data[[date_col]],
    ecb_rate = as.numeric(.data[[val_col]])
  ) %>%
  mutate(date = parse_ecb_date(date_raw)) %>%
  filter(!is.na(date), !is.na(ecb_rate)) %>%
  mutate(ym = floor_date(date, "month")) %>%
  group_by(ym) %>%
  slice_tail(n = 1) %>%
  ungroup() %>%
  select(date = ym, ecb_rate)

# ECB MRR changes only on decision dates; map to month-end (as with NBP)
ecb_grid <- tibble(date = monthly_grid$date)
ecb_idx  <- findInterval(ceiling_date(ecb_grid$date, "month") - days(1), ecb_rate$date)
ecb_rate <- ecb_grid %>%
  mutate(ecb_rate = ifelse(ecb_idx >= 1, ecb_rate$ecb_rate[ecb_idx], NA_real_)) %>%
  filter(!is.na(ecb_rate))

message(sprintf("  ECB rate: %d monthly obs, %s to %s",
                nrow(ecb_rate), min(ecb_rate$date), max(ecb_rate$date)))

# ── 4. Brent crude oil (control) ──────────────────────────────────────────────
message("Loading Brent crude (control)...")

brent_url <- "https://stooq.com/q/d/l/?s=cb.f&i=m"
brent_raw <- tryCatch(read_csv(brent_url, show_col_types = FALSE),
                      error = function(e) NULL)
if (is.null(brent_raw) || nrow(brent_raw) == 0) {
  message("  stooq fetch failed — falling back to data/brent.csv")
  brent_raw <- read_csv(file.path(DATA_DIR, "brent.csv"), show_col_types = FALSE)
}

# Robust to both stooq (Date,Open,High,Low,Close,Volume; YYYY-MM-DD) and
# investing.com (Date,Price,...,Change %; MM/DD/YYYY) exports.
names(brent_raw) <- tolower(gsub("\ufeff", "", trimws(names(brent_raw))))
bnm <- names(brent_raw)
bdate_col  <- bnm[grepl("date", bnm)][1]
bprice_col <- if ("close" %in% bnm) "close" else bnm[grepl("price|close|brent", bnm)][1]

# Deterministic date parsing: try investing.com MM/DD/YYYY first, then ISO.
parse_brent_date <- function(z) {
  z   <- as.character(z)
  out <- as.Date(z, format = "%m/%d/%Y")   # investing.com
  na  <- is.na(out)
  out[na] <- as.Date(z[na])                # stooq ISO YYYY-MM-DD
  out
}

brent <- brent_raw %>%
  transmute(
    date_raw = .data[[bdate_col]],
    brent    = as.numeric(gsub("[, ]", "", .data[[bprice_col]]))
  ) %>%
  mutate(date = parse_brent_date(date_raw)) %>%
  filter(!is.na(date), !is.na(brent)) %>%
  mutate(ym = floor_date(date, "month")) %>%
  group_by(ym) %>%
  slice_tail(n = 1) %>%
  ungroup() %>%
  select(date = ym, brent)

message(sprintf("  Brent: %d monthly obs, %s to %s",
                nrow(brent), min(brent$date), max(brent$date)))

if (min(brent$date) > as.Date("2013-01-01")) {
  warning("Brent history looks too short (starts ", min(brent$date),
          "). You likely downloaded a narrow date range. Re-download the FULL ",
          "monthly history (see README) or the merge will drop almost everything.")
}

# ── 5. Merge & compute differential ──────────────────────────────────────────
message("Merging datasets...")

df <- eurpln %>%
  inner_join(nbp_rate_monthly, by = "date") %>%
  inner_join(ecb_rate, by = "date") %>%
  inner_join(brent, by = "date") %>%
  mutate(
    rate_diff = nbp_rate - ecb_rate,
    ln_eurpln = log(eurpln),
    ln_brent  = log(brent)
  ) %>%
  arrange(date)

message(sprintf("  Merged dataset: %d monthly obs, %s to %s",
                nrow(df), min(df$date), max(df$date)))

# ── 6. Summary & save ─────────────────────────────────────────────────────────
print(summary(df))
na_check <- df %>% summarise(across(everything(), ~sum(is.na(.))))
if (any(na_check > 0)) warning("NAs found — check data sources")
print(na_check)

write_csv(df, file.path(OUTPUT_DIR, "df_clean.csv"))
message("Clean dataset saved to output/df_clean.csv")
