# =============================================================================
# COMPLETE WINE SUITABILITY ANALYSIS - WORLDCLIM CONSISTENT RESOLUTION
# Historical (1970-2000) vs Future Scenarios
# =============================================================================

# -----------------------------------------------------------------------------
# 1. SETUP
# -----------------------------------------------------------------------------

rm(list = ls())
gc()

library(terra)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(leaflet)
library(htmlwidgets)
library(raster)

# -----------------------------------------------------------------------------
# 2. PATHS
# -----------------------------------------------------------------------------

base_path <- "~/Documents/General/Studies/Diploma Thesis/data"
hist_wc_path <- file.path(base_path, "Historical/World_Clim")
output_path <- file.path(base_path, "outputs")
dir.create(output_path, showWarnings = FALSE)

europe_ext <- ext(-25, 45, 35, 72)
europe_sf <- ne_countries(scale = "medium", continent = "Europe", returnclass = "sf")

# -----------------------------------------------------------------------------
# 3. LOAD WORLDCLIM HISTORICAL DATA (1970-2000)
# -----------------------------------------------------------------------------

cat("============================================================\n")
cat("LOADING WORLDCLIM HISTORICAL BASELINE (1970-2000)\n")
cat("============================================================\n\n")

# Load individual monthly files and stack them
load_worldclim_historical <- function(var_folder, var_prefix) {
  files <- list.files(var_folder, pattern = "\\.tif$", full.names = TRUE)
  files <- sort(files)  # Ensure correct month order
  
  cat("  Loading", length(files), "monthly files for", var_prefix, "\n")
  
  # Stack all months
  stack <- rast(files)
  return(stack)
}

# Load tmin, tmax, prec (2.5 arc-min resolution)
tmin_hist <- load_worldclim_historical(
  file.path(hist_wc_path, "wc2.1_2.5m_tmin"), "tmin"
)
tmax_hist <- load_worldclim_historical(
  file.path(hist_wc_path, "wc2.1_2.5m_tmax"), "tmax"
)
prec_hist <- load_worldclim_historical(
  file.path(hist_wc_path, "wc2.1_2.5m_prec"), "prec"
)

cat("\nHistorical data loaded:\n")
cat("  Resolution: 2.5 arc-min (~", round(res(tmin_hist)[1] * 111, 0), "km)\n")
cat("  Bands (months):", nlyr(tmin_hist), "\n")
cat("  NOTE: Same resolution as future WorldClim data - no resampling artifacts!\n")

# Crop to Europe
tmin_hist <- crop(tmin_hist, europe_ext)
tmax_hist <- crop(tmax_hist, europe_ext)
prec_hist <- crop(prec_hist, europe_ext)

cat("  Cropped to Europe extent.\n")

# -----------------------------------------------------------------------------
# 4. CALCULATE INDICES - FUNCTIONS
# -----------------------------------------------------------------------------

calculate_huglin <- function(tmin, tmax) {
  # Days per month (April-September)
  days <- c(30, 31, 30, 31, 31, 30)
  
  # Growing season: bands 4-9 (April-September)
  tmin_gs <- tmin[[4:9]]
  tmax_gs <- tmax[[4:9]]
  tavg_gs <- (tmin_gs + tmax_gs) / 2
  
  # Huglin formula
  hi_monthly <- ((tavg_gs - 10) + (tmax_gs - 10)) / 2
  hi_monthly <- ifel(hi_monthly < 0, 0, hi_monthly)
  
  for (i in 1:6) {
    hi_monthly[[i]] <- hi_monthly[[i]] * days[i]
  }
  
  huglin <- app(hi_monthly, sum, na.rm = TRUE)
  
  # K factor (latitude correction)
  lat_rast <- init(huglin, "y")
  K <- 1 + (lat_rast - 40) * 0.006
  K <- clamp(K, lower = 1.0, upper = 1.06)
  huglin <- huglin * K
  
  return(huglin)
}

calculate_winkler <- function(tmin, tmax) {
  days <- c(30, 31, 30, 31, 31, 30)
  
  tmin_gs <- tmin[[4:9]]
  tmax_gs <- tmax[[4:9]]
  tavg_gs <- (tmin_gs + tmax_gs) / 2
  
  wi_monthly <- tavg_gs - 10
  wi_monthly <- ifel(wi_monthly < 0, 0, wi_monthly)
  
  for (i in 1:6) {
    wi_monthly[[i]] <- wi_monthly[[i]] * days[i]
  }
  
  winkler <- app(wi_monthly, sum, na.rm = TRUE)
  return(winkler)
}

calculate_precipitation <- function(prec) {
  # Sum April-September precipitation
  prec_gs <- prec[[4:9]]
  precip <- app(prec_gs, sum, na.rm = TRUE)
  return(precip)
}

# Suitability functions - using classify() instead of nested ifel()

huglin_suitability <- function(hi) {
  # Create score raster
  score <- hi * 0  # Initialize with zeros
  
  # Apply scoring rules
  score <- ifel(hi < 1200, 0, score)
  score <- ifel(hi >= 1200 & hi < 1500, (hi - 1200) / 300 * 50, score)
  score <- ifel(hi >= 1500 & hi < 1800, 50 + (hi - 1500) / 300 * 50, score)
  score <- ifel(hi >= 1800 & hi < 2100, 100, score)
  score <- ifel(hi >= 2100 & hi < 2400, 100 - (hi - 2100) / 300 * 20, score)
  score <- ifel(hi >= 2400 & hi < 3000, 80 - (hi - 2400) / 600 * 50, score)
  score <- ifel(hi >= 3000, 30 - (hi - 3000) / 500 * 30, score)
  
  # Clamp to 0-100
  score <- clamp(score, lower = 0, upper = 100)
  return(score)
}

winkler_suitability <- function(wi) {
  score <- wi * 0
  
  score <- ifel(wi < 850, 0, score)
  score <- ifel(wi >= 850 & wi < 1110, (wi - 850) / 260 * 40, score)
  score <- ifel(wi >= 1110 & wi < 1390, 40 + (wi - 1110) / 280 * 30, score)
  score <- ifel(wi >= 1390 & wi < 1670, 70 + (wi - 1390) / 280 * 30, score)
  score <- ifel(wi >= 1670 & wi < 1940, 100, score)
  score <- ifel(wi >= 1940 & wi < 2220, 100 - (wi - 1940) / 280 * 25, score)
  score <- ifel(wi >= 2220 & wi < 2500, 75 - (wi - 2220) / 280 * 35, score)
  score <- ifel(wi >= 2500, 40 - (wi - 2500) / 500 * 40, score)
  
  score <- clamp(score, lower = 0, upper = 100)
  return(score)
}

precipitation_suitability <- function(prec) {
  score <- prec * 0
  
  score <- ifel(prec < 150, 20, score)
  score <- ifel(prec >= 150 & prec < 250, 20 + (prec - 150) / 100 * 30, score)
  score <- ifel(prec >= 250 & prec < 350, 50 + (prec - 250) / 100 * 40, score)
  score <- ifel(prec >= 350 & prec < 500, 90 + (prec - 350) / 150 * 10, score)
  score <- ifel(prec >= 500 & prec < 600, 100, score)
  score <- ifel(prec >= 600 & prec < 800, 100 - (prec - 600) / 200 * 30, score)
  score <- ifel(prec >= 800 & prec < 1000, 70 - (prec - 800) / 200 * 30, score)
  score <- ifel(prec >= 1000, 40 - (prec - 1000) / 500 * 40, score)
  
  score <- clamp(score, lower = 0, upper = 100)
  return(score)
}

calculate_suitability <- function(huglin, winkler, precip,
                                  w_huglin = 0.40,
                                  w_winkler = 0.35,
                                  w_precip = 0.25) {
  hi_score <- huglin_suitability(huglin)
  wi_score <- winkler_suitability(winkler)
  pr_score <- precipitation_suitability(precip)
  
  composite <- (hi_score * w_huglin) + (wi_score * w_winkler) + (pr_score * w_precip)
  
  return(list(
    composite = composite,
    huglin_score = hi_score,
    winkler_score = wi_score,
    precip_score = pr_score
  ))
}

# -----------------------------------------------------------------------------
# 5. CALCULATE HISTORICAL BASELINE INDICES
# -----------------------------------------------------------------------------

cat("\n============================================================\n")
cat("CALCULATING HISTORICAL BASELINE INDICES\n")
cat("============================================================\n\n")

hi_baseline <- calculate_huglin(tmin_hist, tmax_hist)
wi_baseline <- calculate_winkler(tmin_hist, tmax_hist)
pr_baseline <- calculate_precipitation(prec_hist)

suit_baseline <- calculate_suitability(hi_baseline, wi_baseline, pr_baseline)

cat("Historical Baseline (1970-2000):\n")
cat("  Huglin mean:", round(global(hi_baseline, "mean", na.rm = TRUE)$mean, 0), "\n")
cat("  Winkler mean:", round(global(wi_baseline, "mean", na.rm = TRUE)$mean, 0), "\n")
cat("  Precipitation mean:", round(global(pr_baseline, "mean", na.rm = TRUE)$mean, 0), "mm\n")
cat("  Suitability mean:", round(global(suit_baseline$composite, "mean", na.rm = TRUE)$mean, 1), "\n")

# Save baseline
writeRaster(hi_baseline, file.path(output_path, "huglin_baseline_worldclim.tif"), overwrite = TRUE)
writeRaster(wi_baseline, file.path(output_path, "winkler_baseline_worldclim.tif"), overwrite = TRUE)
writeRaster(pr_baseline, file.path(output_path, "precip_baseline_worldclim.tif"), overwrite = TRUE)
writeRaster(suit_baseline$composite, file.path(output_path, "suitability_baseline_worldclim.tif"), overwrite = TRUE)

# -----------------------------------------------------------------------------
# 6. LOAD AND PROCESS FUTURE SCENARIOS
# -----------------------------------------------------------------------------

cat("\n============================================================\n")
cat("PROCESSING FUTURE SCENARIOS\n")
cat("============================================================\n\n")

process_future_scenario <- function(period, ssp, model, base_path, reference_rast) {
  
  path <- file.path(base_path, period, model, ssp)
  
  tmin_file <- file.path(path, paste0("wc2.1_2.5m_tmin_", model, "_", ssp, "_", period, ".tif"))
  tmax_file <- file.path(path, paste0("wc2.1_2.5m_tmax_", model, "_", ssp, "_", period, ".tif"))
  prec_file <- file.path(path, paste0("wc2.1_2.5m_prec_", model, "_", ssp, "_", period, ".tif"))
  
  if (!all(file.exists(c(tmin_file, tmax_file, prec_file)))) {
    return(NULL)
  }
  
  tmin <- rast(tmin_file)
  tmax <- rast(tmax_file)
  prec <- rast(prec_file)
  
  # Crop to Europe
  tmin <- crop(tmin, europe_ext)
  tmax <- crop(tmax, europe_ext)
  prec <- crop(prec, europe_ext)
  
  # Calculate indices
  huglin <- calculate_huglin(tmin, tmax)
  winkler <- calculate_winkler(tmin, tmax)
  precip <- calculate_precipitation(prec)
  
  # Resample to match baseline resolution (5 arc-min)
  huglin <- resample(huglin, reference_rast, method = "bilinear")
  winkler <- resample(winkler, reference_rast, method = "bilinear")
  precip <- resample(precip, reference_rast, method = "bilinear")
  
  # Calculate suitability
  suit <- calculate_suitability(huglin, winkler, precip)
  
  return(list(
    huglin = huglin,
    winkler = winkler,
    precip = precip,
    suitability = suit$composite
  ))
}

# Process all scenarios
scenarios <- expand.grid(
  period = c("2021-2040", "2041-2060"),
  ssp = c("ssp245", "ssp585"),
  model = c("ACCESS-CM2", "EC-Earth3-Veg", "MPI-ESM1-2-HR"),
  stringsAsFactors = FALSE
)

future_results <- list()

for (i in 1:nrow(scenarios)) {
  s <- scenarios[i, ]
  key <- paste(s$model, s$ssp, s$period, sep = "_")
  
  cat("Processing:", key, "...\n")
  
  result <- process_future_scenario(s$period, s$ssp, s$model, base_path, hi_baseline)
  
  if (!is.null(result)) {
    future_results[[key]] <- result
    cat("  Huglin:", round(global(result$huglin, "mean", na.rm = TRUE)$mean, 0),
        " Suitability:", round(global(result$suitability, "mean", na.rm = TRUE)$mean, 1), "\n")
  } else {
    cat("  Files not found, skipping.\n")
  }
}

# -----------------------------------------------------------------------------
# 7. CREATE ENSEMBLE MEANS
# -----------------------------------------------------------------------------

cat("\n============================================================\n")
cat("CREATING MULTI-MODEL ENSEMBLE MEANS\n")
cat("============================================================\n\n")

create_ensemble <- function(future_results, ssp, period, variable = "huglin") {
  models <- c("ACCESS-CM2", "EC-Earth3-Veg", "MPI-ESM1-2-HR")
  
  rasters <- list()
  for (m in models) {
    key <- paste(m, ssp, period, sep = "_")
    if (key %in% names(future_results)) {
      rasters[[m]] <- future_results[[key]][[variable]]
    }
  }
  
  if (length(rasters) == 0) return(NULL)
  
  stack <- rast(rasters)
  ensemble <- app(stack, mean, na.rm = TRUE)
  return(ensemble)
}

# Create ensembles for all combinations
ensemble <- list()

for (ssp in c("ssp245", "ssp585")) {
  for (period in c("2021-2040", "2041-2060")) {
    for (var in c("huglin", "winkler", "precip", "suitability")) {
      key <- paste(var, ssp, period, sep = "_")
      ensemble[[key]] <- create_ensemble(future_results, ssp, period, var)
      
      if (!is.null(ensemble[[key]])) {
        cat(key, ":", round(global(ensemble[[key]], "mean", na.rm = TRUE)$mean, 1), "\n")
      }
    }
  }
}

# -----------------------------------------------------------------------------
# 8. CALCULATE DELTA MAPS (CHANGE FROM BASELINE)
# -----------------------------------------------------------------------------

cat("\n============================================================\n")
cat("CALCULATING DELTA MAPS\n")
cat("============================================================\n\n")

delta <- list()

for (ssp in c("ssp245", "ssp585")) {
  for (period in c("2021-2040", "2041-2060")) {
    
    # Huglin delta
    hi_key <- paste("huglin", ssp, period, sep = "_")
    if (!is.null(ensemble[[hi_key]])) {
      delta_key <- paste("delta_huglin", ssp, period, sep = "_")
      delta[[delta_key]] <- ensemble[[hi_key]] - hi_baseline
      cat(delta_key, ": mean change =", 
          round(global(delta[[delta_key]], "mean", na.rm = TRUE)$mean, 0), "\n")
    }
    
    # Winkler delta
    wi_key <- paste("winkler", ssp, period, sep = "_")
    if (!is.null(ensemble[[wi_key]])) {
      delta_key <- paste("delta_winkler", ssp, period, sep = "_")
      delta[[delta_key]] <- ensemble[[wi_key]] - wi_baseline
      cat(delta_key, ": mean change =", 
          round(global(delta[[delta_key]], "mean", na.rm = TRUE)$mean, 0), "\n")
    }
    
    # Suitability delta
    suit_key <- paste("suitability", ssp, period, sep = "_")
    if (!is.null(ensemble[[suit_key]])) {
      delta_key <- paste("delta_suitability", ssp, period, sep = "_")
      delta[[delta_key]] <- ensemble[[suit_key]] - suit_baseline$composite
      cat(delta_key, ": mean change =", 
          round(global(delta[[delta_key]], "mean", na.rm = TRUE)$mean, 1), "\n")
    }
  }
}

# -----------------------------------------------------------------------------
# 9. COLOR PALETTES
# -----------------------------------------------------------------------------

# Index palettes
huglin_colors <- colorRampPalette(c("#313695", "#4575B4", "#74ADD1", "#ABD9E9",
                                    "#E0F3F8", "#FFFFBF", "#FEE090", "#FDAE61",
                                    "#F46D43", "#D73027", "#A50026"))(100)

# Delta palette (diverging)
delta_colors <- colorRampPalette(c("#2166AC", "#67A9CF", "#D1E5F0", "#F7F7F7",
                                   "#FDDBC7", "#EF8A62", "#B2182B"))(100)

# Suitability palette
suit_colors <- colorRampPalette(c("#D73027", "#FC8D59", "#FEE090",
                                  "#D9EF8B", "#91CF60", "#1A9850"))(100)

# Suitability delta (green = improvement, brown = decline)
suit_delta_colors <- colorRampPalette(c("#8C510A", "#BF812D", "#DFC27D", "#F6E8C3",
                                        "#F5F5F5", "#C7EAE5", "#80CDC1", 
                                        "#35978F", "#01665E"))(100)

# -----------------------------------------------------------------------------
# 10. STATIC PLOTS
# -----------------------------------------------------------------------------

cat("\n============================================================\n")
cat("CREATING PLOTS\n")
cat("============================================================\n\n")

# ----- PLOT 1: Huglin Index Comparison -----
par(mfrow = c(2, 3), mar = c(2, 2, 3, 4))

plot(hi_baseline, main = "Huglin Index\nBaseline (1970-2000)",
     col = huglin_colors, range = c(500, 4500))
plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)

if (!is.null(ensemble[["huglin_ssp245_2041-2060"]])) {
  plot(ensemble[["huglin_ssp245_2041-2060"]], main = "Huglin Index\nSSP245 (2041-2060)",
       col = huglin_colors, range = c(500, 4500))
  plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)
}

if (!is.null(ensemble[["huglin_ssp585_2041-2060"]])) {
  plot(ensemble[["huglin_ssp585_2041-2060"]], main = "Huglin Index\nSSP585 (2041-2060)",
       col = huglin_colors, range = c(500, 4500))
  plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)
}

# Delta plots
plot.new()  # Empty for layout

if (!is.null(delta[["delta_huglin_ssp245_2041-2060"]])) {
  plot(delta[["delta_huglin_ssp245_2041-2060"]], main = "Huglin Change\nSSP245 (2041-2060)",
       col = delta_colors, range = c(-200, 800))
  plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)
}

if (!is.null(delta[["delta_huglin_ssp585_2041-2060"]])) {
  plot(delta[["delta_huglin_ssp585_2041-2060"]], main = "Huglin Change\nSSP585 (2041-2060)",
       col = delta_colors, range = c(-200, 800))
  plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)
}

# ----- PLOT 2: Suitability Comparison -----
par(mfrow = c(2, 3), mar = c(2, 2, 3, 4))

plot(suit_baseline$composite, main = "Wine Suitability\nBaseline (1970-2000)",
     col = suit_colors, range = c(0, 100))
plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)

if (!is.null(ensemble[["suitability_ssp245_2041-2060"]])) {
  plot(ensemble[["suitability_ssp245_2041-2060"]], main = "Wine Suitability\nSSP245 (2041-2060)",
       col = suit_colors, range = c(0, 100))
  plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)
}

if (!is.null(ensemble[["suitability_ssp585_2041-2060"]])) {
  plot(ensemble[["suitability_ssp585_2041-2060"]], main = "Wine Suitability\nSSP585 (2041-2060)",
       col = suit_colors, range = c(0, 100))
  plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)
}

# Suitability delta
plot.new()

if (!is.null(delta[["delta_suitability_ssp245_2041-2060"]])) {
  plot(delta[["delta_suitability_ssp245_2041-2060"]], 
       main = "Suitability Change\nSSP245 (2041-2060)",
       col = suit_delta_colors, range = c(-40, 40))
  plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)
}

if (!is.null(delta[["delta_suitability_ssp585_2041-2060"]])) {
  plot(delta[["delta_suitability_ssp585_2041-2060"]], 
       main = "Suitability Change\nSSP585 (2041-2060)",
       col = suit_delta_colors, range = c(-40, 40))
  plot(st_geometry(europe_sf), add = TRUE, border = "gray40", lwd = 0.3)
}

# -----------------------------------------------------------------------------
# 11. INTERACTIVE MAPS
# -----------------------------------------------------------------------------

cat("Creating interactive maps...\n")

# Huglin delta palette
pal_delta <- colorNumeric(
  palette = c("#2166AC", "#67A9CF", "#D1E5F0", "#F7F7F7",
              "#FDDBC7", "#EF8A62", "#B2182B"),
  domain = c(-200, 800),
  na.color = "transparent"
)

# Suitability delta palette
pal_suit_delta <- colorNumeric(
  palette = c("#8C510A", "#BF812D", "#DFC27D", "#F5F5F5",
              "#80CDC1", "#35978F", "#01665E"),
  domain = c(-40, 40),
  na.color = "transparent"
)

# Suitability absolute palette
pal_suit <- colorNumeric(
  palette = c("#D73027", "#FC8D59", "#FEE090", "#D9EF8B", "#91CF60", "#1A9850"),
  domain = c(0, 100),
  na.color = "transparent"
)

# ----- Huglin Delta Map (SSP585 2041-2060) -----
if (!is.null(delta[["delta_huglin_ssp585_2041-2060"]])) {
  
  map_hi_delta <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
    setView(lng = 15, lat = 50, zoom = 4) %>%
    addRasterImage(raster(delta[["delta_huglin_ssp585_2041-2060"]]), 
                   colors = pal_delta, opacity = 0.75) %>%
    addLegend(position = "bottomright", pal = pal_delta,
              values = c(-200, 0, 200, 400, 600, 800),
              title = "Huglin Change<br>SSP585 2041-2060", opacity = 0.9) %>%
    addLayersControl(baseGroups = c("Light", "Satellite")) %>%
    addScaleBar(position = "bottomleft")
  
  print(map_hi_delta)
  saveWidget(map_hi_delta, file.path(output_path, "huglin_delta_ssp585_2041-2060_hires.html"), 
             selfcontained = TRUE)
}

# ----- Suitability Delta Map (SSP585 2041-2060) -----
if (!is.null(delta[["delta_suitability_ssp585_2041-2060"]])) {
  
  map_suit_delta <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
    setView(lng = 15, lat = 50, zoom = 4) %>%
    addRasterImage(raster(delta[["delta_suitability_ssp585_2041-2060"]]), 
                   colors = pal_suit_delta, opacity = 0.75) %>%
    addLegend(position = "bottomright", pal = pal_suit_delta,
              values = c(-40, -20, 0, 20, 40),
              title = "Suitability Change<br>SSP585 2041-2060", opacity = 0.9) %>%
    addLegend(position = "bottomleft",
              colors = c("#8C510A", "#F5F5F5", "#01665E"),
              labels = c("Decline", "No change", "Improvement"),
              title = "Direction", opacity = 0.9) %>%
    addLayersControl(baseGroups = c("Light", "Satellite")) %>%
    addScaleBar(position = "bottomleft")
  
  print(map_suit_delta)
  saveWidget(map_suit_delta, file.path(output_path, "suitability_delta_ssp585_2041-2060.html"), 
             selfcontained = TRUE)
}

# ----- Baseline Suitability Map -----
map_baseline <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
  setView(lng = 15, lat = 50, zoom = 4) %>%
  addRasterImage(raster(suit_baseline$composite), 
                 colors = pal_suit, opacity = 0.75) %>%
  addLegend(position = "bottomright", pal = pal_suit,
            values = c(0, 20, 40, 60, 80, 100),
            title = "Suitability Score<br>Baseline 1970-2000", opacity = 0.9) %>%
  addLayersControl(baseGroups = c("Light", "Satellite")) %>%
  addScaleBar(position = "bottomleft")

print(map_baseline)
saveWidget(map_baseline, file.path(output_path, "suitability_baseline_worldclim.html"), 
           selfcontained = TRUE)

# ----- Future Suitability Map (SSP585 2041-2060) -----
if (!is.null(ensemble[["suitability_ssp585_2041-2060"]])) {
  
  map_future <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
    setView(lng = 15, lat = 50, zoom = 4) %>%
    addRasterImage(raster(ensemble[["suitability_ssp585_2041-2060"]]), 
                   colors = pal_suit, opacity = 0.75) %>%
    addLegend(position = "bottomright", pal = pal_suit,
              values = c(0, 20, 40, 60, 80, 100),
              title = "Suitability Score<br>SSP585 2041-2060", opacity = 0.9) %>%
    addLayersControl(baseGroups = c("Light", "Satellite")) %>%
    addScaleBar(position = "bottomleft")
  
  print(map_future)
  saveWidget(map_future, file.path(output_path, "suitability_ssp585_2041-2060.html"), 
             selfcontained = TRUE)
}

# -----------------------------------------------------------------------------
# 12. SUMMARY STATISTICS
# -----------------------------------------------------------------------------

cat("\n")
cat("============================================================\n")
cat("SUMMARY STATISTICS\n")
cat("============================================================\n\n")

summary_df <- data.frame(
  Scenario = "Baseline (1970-2000)",
  Huglin_Mean = round(global(hi_baseline, "mean", na.rm = TRUE)$mean, 0),
  Winkler_Mean = round(global(wi_baseline, "mean", na.rm = TRUE)$mean, 0),
  Precip_Mean = round(global(pr_baseline, "mean", na.rm = TRUE)$mean, 0),
  Suitability_Mean = round(global(suit_baseline$composite, "mean", na.rm = TRUE)$mean, 1),
  HI_Change = 0,
  Suit_Change = 0
)

for (ssp in c("ssp245", "ssp585")) {
  for (period in c("2021-2040", "2041-2060")) {
    hi_key <- paste("huglin", ssp, period, sep = "_")
    wi_key <- paste("winkler", ssp, period, sep = "_")
    pr_key <- paste("precip", ssp, period, sep = "_")
    suit_key <- paste("suitability", ssp, period, sep = "_")
    
    if (!is.null(ensemble[[hi_key]])) {
      hi_mean <- global(ensemble[[hi_key]], "mean", na.rm = TRUE)$mean
      wi_mean <- global(ensemble[[wi_key]], "mean", na.rm = TRUE)$mean
      pr_mean <- global(ensemble[[pr_key]], "mean", na.rm = TRUE)$mean
      suit_mean <- global(ensemble[[suit_key]], "mean", na.rm = TRUE)$mean
      
      hi_base <- global(hi_baseline, "mean", na.rm = TRUE)$mean
      suit_base <- global(suit_baseline$composite, "mean", na.rm = TRUE)$mean
      
      summary_df <- rbind(summary_df, data.frame(
        Scenario = paste(toupper(ssp), period),
        Huglin_Mean = round(hi_mean, 0),
        Winkler_Mean = round(wi_mean, 0),
        Precip_Mean = round(pr_mean, 0),
        Suitability_Mean = round(suit_mean, 1),
        HI_Change = round(hi_mean - hi_base, 0),
        Suit_Change = round(suit_mean - suit_base, 1)
      ))
    }
  }
}

print(summary_df)
write.csv(summary_df, file.path(output_path, "climate_analysis_summary.csv"), row.names = FALSE)

# -----------------------------------------------------------------------------
# 13. SAVE ALL RASTERS
# -----------------------------------------------------------------------------

cat("\nSaving rasters...\n")

# Save ensembles
for (key in names(ensemble)) {
  if (!is.null(ensemble[[key]])) {
    writeRaster(ensemble[[key]], file.path(output_path, paste0(key, "_ensemble.tif")), overwrite = TRUE)
  }
}

# Save deltas
for (key in names(delta)) {
  if (!is.null(delta[[key]])) {
    writeRaster(delta[[key]], file.path(output_path, paste0(key, ".tif")), overwrite = TRUE)
  }
}

# -----------------------------------------------------------------------------
# 14. COMPLETE
# -----------------------------------------------------------------------------

cat("\n")
cat("============================================================\n")
cat("ANALYSIS COMPLETE!\n")
cat("============================================================\n\n")

cat("All outputs saved to:", output_path, "\n\n")

cat("Key files:\n")
cat("  - suitability_baseline_worldclim.html\n")
cat("  - suitability_ssp585_2041-2060.html\n")
cat("  - suitability_delta_ssp585_2041-2060.html\n")
cat("  - huglin_delta_ssp585_2041-2060_hires.html\n")
cat("  - climate_analysis_summary.csv\n")