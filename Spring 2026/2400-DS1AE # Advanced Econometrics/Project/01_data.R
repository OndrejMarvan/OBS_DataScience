# ==============================================================================
# 01_data.R
# Load, clean, and merge EUR/PLN and interest rate differential data
# Run after 00_setup.R
# ==============================================================================

source("00_setup.R")

# ==============================================================================
# DATA SOURCES
# ==============================================================================
#
# 1. EUR/PLN monthly exchange rate — fetched automatically via NBP API
#    No download needed.
#
# 2. NBP Reference Rate — manual download required
#    URL: https://nbp.pl/polityka-pieniezna/decyzje-rpp/podstawowe-stopy-procentowe-nbp/
#    → Click "Archiwum podstawowych stóp procentowych NBP od 1998"
#    → Copy the table into Excel, keep columns: date, reference rate only
#    → Save as: data/nbp_rate.csv  (columns: date, nbp_rate)
#    → Date format: YYYY-MM-DD, rate in % (e.g. 5.75)
#
# 3. ECB Main Refinancing Rate — manual download required
#    URL: https://data.ecb.europa.eu/data/datasets/FM/FM.B.U2.EUR.4F.KR.MRR_FR.LEV
#    → Click Export → CSV
#    → Save as: data/ecb_rate.csv
#
# ==============================================================================

# ── 1. EUR/PLN via NBP API ────────────────────────────────────────────────────
message("Fetching EUR/PLN from NBP API...")

# NBP API allows max 367 days per call — we loop year by year
fetch_eurpln_year <- function(year) {
  start <- paste0(year, "-01-01")
  end   <- paste0(year, "-12-31")
  url   <- paste0("https://api.nbp.pl/api/exchangerates/rates/a/eur/",
                  start, "/", end, "/?format=json")
  resp  <- tryCatch(jsonlite::fromJSON(url), error = function(e) NULL)
  if (is.null(resp)) {
    message(sprintf("  No data for %d (possibly future year)", year))
    return(NULL)
  }
  resp$rates %>%
    as_tibble() %>%
    transmute(date = as.Date(effectiveDate), eurpln = mid)
}

years    <- 2005:year(Sys.Date())
eurpln_list <- vector("list", length(years))

for (i in seq_along(years)) {
  message(sprintf("  Fetching %d...", years[i]))
  eurpln_list[[i]] <- fetch_eurpln_year(years[i])
  Sys.sleep(0.3)  # polite pause
}

eurpln_daily <- bind_rows(eurpln_list)

# Aggregate to monthly (last available rate per month)
eurpln <- eurpln_daily %>%
  mutate(ym = floor_date(date, "month")) %>%
  group_by(ym) %>%
  slice_tail(n = 1) %>%
  ungroup() %>%
  select(date = ym, eurpln)

message(sprintf("  EUR/PLN: %d monthly obs, %s to %s",
                nrow(eurpln), min(eurpln$date), max(eurpln$date)))

# ── 2. Load NBP Reference Rate ────────────────────────────────────────────────
message("Loading NBP reference rate...")

nbp_rate_raw <- read_delim(
  file.path(DATA_DIR, "nbp_rate.csv"),
  delim = ";",
  locale = locale(decimal_mark = ","),
  show_col_types = FALSE
)

# The NBP archive lists rate-change dates (not monthly)
# We forward-fill to get end-of-month values
nbp_rate <- nbp_rate_raw %>%
  rename_with(tolower) %>%
  select(1, 2) %>%
  setNames(c("date_raw", "nbp_rate")) %>%
  mutate(
    date     = parse_date_time(date_raw, orders = c("dmy", "ymd")),
    date     = as.Date(date),
    nbp_rate = as.numeric(nbp_rate)
  ) %>%
  filter(!is.na(date), !is.na(nbp_rate)) %>%
  arrange(date)

# Forward-fill to monthly grid
monthly_grid <- tibble(date = seq(as.Date("2005-01-01"),
                                  as.Date(paste0(year(Sys.Date()), "-12-01")),
                                  by = "month"))

nbp_rate_monthly <- monthly_grid %>%
  left_join(nbp_rate, by = "date") %>%
  tidyr::fill(nbp_rate, .direction = "down") %>%
  filter(!is.na(nbp_rate))

message(sprintf("  NBP rate: %d monthly obs, %s to %s",
                nrow(nbp_rate_monthly), min(nbp_rate_monthly$date),
                max(nbp_rate_monthly$date)))

# ── 3. Load ECB Rate ──────────────────────────────────────────────────────────
message("Loading ECB rate...")

ecb_rate_raw <- read_csv(
  file.path(DATA_DIR, "ecb_rate.csv"),
  show_col_types = FALSE
)

ecb_rate <- ecb_rate_raw %>%
  rename_with(tolower) %>%
  select(matches("date|time|period"), matches("obs|value|rate")) %>%
  setNames(c("date_raw", "ecb_rate")) %>%
  mutate(
    date     = as.Date(date_raw),
    ecb_rate = as.numeric(ecb_rate)
  ) %>%
  filter(!is.na(date), !is.na(ecb_rate)) %>%
  mutate(ym = floor_date(date, "month")) %>%
  group_by(ym) %>%
  slice_tail(n = 1) %>%
  ungroup() %>%
  select(date = ym, ecb_rate)

message(sprintf("  ECB rate: %d monthly obs, %s to %s",
                nrow(ecb_rate), min(ecb_rate$date), max(ecb_rate$date)))

# ── 4. Merge & compute differential ──────────────────────────────────────────
message("Merging datasets...")

df <- eurpln %>%
  inner_join(nbp_rate_monthly, by = "date") %>%
  inner_join(ecb_rate, by = "date") %>%
  mutate(
    rate_diff = nbp_rate - ecb_rate,    # interest rate differential (pp)
    ln_eurpln = log(eurpln)             # log exchange rate
  ) %>%
  arrange(date) %>%
  filter(date >= as.Date("2005-01-01"))

message(sprintf("  Merged dataset: %d monthly obs, %s to %s",
                nrow(df), min(df$date), max(df$date)))

# ── 5. Summary & save ─────────────────────────────────────────────────────────
print(summary(df))

na_check <- df %>% summarise(across(everything(), ~sum(is.na(.))))
if (any(na_check > 0)) warning("NAs found — check data sources")
print(na_check)

write_csv(df, file.path(OUTPUT_DIR, "df_clean.csv"))
message("✔ Clean dataset saved to output/df_clean.csv")
