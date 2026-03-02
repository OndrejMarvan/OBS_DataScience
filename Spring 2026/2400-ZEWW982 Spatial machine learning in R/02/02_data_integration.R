################################################################################
# Spatial Machine Learning in R — Session 2
# Integration of spatial data of different types and granularity
# MA Monika Kot
################################################################################


################################################################################
# 1. Packages & Setup
################################################################################

# Installing the packages
# install.packages(c("tidyverse", "sf", "terra"))

# Loading the packages
library(tidyverse)  # data manipulation & visualization
library(sf)         # spatial operations
library(terra)      # rasters

# Setting the path to working directory
getwd()     # current working directory
# setwd()   # set to desired working directory

# Showing the error messages in English
Sys.setenv(LANG = "en")

# CRS (Coordinate Reference Systems) setup

# EPSG:2180 — Projected CRS for Poland (ETRS89 / Poland CS92)
# Units: meters
crs.pl <- 2180

# EPSG:4326 — Geographic CRS (WGS84)
# Units: degrees (longitude / latitude)
crs.geo <- 4326

################################################################################
# 2. Data Import
################################################################################

# ------------------------------------------------------------------------------
## 2.1 Administrative boundaries for whole Poland(polygons) ----
# voivodeships: 16 polygons
# poviats: 380 polygons

voi <- st_read("data/wojewodztwa.shp") %>% st_transform(crs.geo)
head(voi)

pov <- st_read("data/powiaty.shp") %>% st_transform(crs.geo)
head(pov)

# ------------------------------------------------------------------------------
## 2.2 Firms in Lubelskie voivodeship (points) ----

firms <- read.csv("data/firms_data_utf8.csv", row.names = 1)
head(firms)

# Transforming to sf object
firms.sf <- firms %>% 
  st_as_sf(coords = c("crds.x", "crds.y"), crs = crs.geo)
head(firms.sf)

# ------------------------------------------------------------------------------
## 2.3 Grid (1km2) with population measures for whole Poland (polygons) ----

grid.pop <- st_read("data/population_grid_2021.shp") %>% st_transform(crs.geo)
head(grid.pop)

# ------------------------------------------------------------------------------
## 2.4 Poviat-level (non-spatial) indicators ----

data <- read.table("data/regional_dataset.csv", sep = ";", dec = ",", header = TRUE)
head(data)

################################################################################
# 3. Visual Exploration
################################################################################

# ------------------------------------------------------------------------------
## 3.1 Poland: voivodeships + poviats ----

# Poland overview - voivodeships
ggplot() +
  geom_sf(data = voi, fill = "grey90", color = "grey70", linewidth = 0.3) +
  theme_minimal() +
  labs(title = "Administrative boundaries: voivodeships (NTS2)")

# Poland overview - voivodeships + poviats
ggplot() +
  geom_sf(data = voi, fill = "grey95", color = "black", linewidth = 0.4) +
  geom_sf(data = pov, fill = NA, color = "grey50", linewidth = 0.1) +
  theme_minimal() +
  labs(title = "Administrative boundaries: voivodeships (NTS2) & poviats (NTS4)")


# ------------------------------------------------------------------------------
## 3.2 Lubelskie voivodeship boundary + firms points ----

# Each voivodeship is a separate feature (row) in the voi sf object.
# So we can filter one region using its attribute (here: name).

voi.lub <- voi %>% filter(JPT_NAZWA_ == "lubelskie")
head(voi.lub) 

# Plot the Lubelskie polygon alone (to check boundary and shape)
ggplot() +
  geom_sf(data = voi.lub, fill = "grey95", color = "grey70", linewidth = 0.3) +
  theme_minimal() +
  labs(title = "Lubelskie voivodeship") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# Plot firm locations alone (points)
# At this stage we only inspect the point distribution (no background).
ggplot(data = firms.sf) +
  geom_sf(alpha = 0.5, size = 0.8) +
  theme_minimal()

# Overlay: polygon (Lubelskie) + firm points
# This is our first example of integrating different geometry types in one map.
ggplot() +
  geom_sf(data = voi.lub, fill = "grey95", color = "grey50", linewidth = 0.3) +
  geom_sf(data = firms.sf, alpha = 0.3, size = 0.5, color = "blue") +
  theme_minimal() +
  labs(title = "Firms (points) in Lubelskie voivodeship") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# Firms colored by attributes
# We can map attributes to aesthetics (e.g. color) to see spatial patterns.
head(firms.sf)

# Example 1: color = distance to central city (continuous variable)
ggplot() +
  geom_sf(data = voi.lub, fill = "grey95", color = "grey50", linewidth = 0.3) +
  geom_sf(data = firms.sf, alpha = 0.5, size = 0.5, aes(color = dist.lublin)) +
  scale_color_viridis_c(option = "plasma", direction = -1) +
  theme_minimal() +
  labs(title = "Firms and their distance to central city", color = "") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), legend.position = "bottom")

# Example 2: color = firm type (categorical variable)
# dummy_agri is 0/1 so we convert it to factor to treat it as categories.
ggplot() +
  geom_sf(data = voi.lub, fill = "grey95", color = "grey60", linewidth = 0.3) +
  geom_sf(data = firms.sf, aes(color = factor(dummy_agri)), size = 0.8, alpha = 1) +
  scale_color_manual(
    values = c("0" = "orchid4", "1" = "springgreen4"),
    labels = c("0" = "Non-agriculture", "1" = "Agriculture"),
    name = "Firm type") +
  labs(title = "Firms in Lubelskie voivodeship") +
  theme_minimal()


# ------------------------------------------------------------------------------
## 3.3 Population grid ----

# We want to visualize the grid for Lubelskie region and one of it main cities.
# The population grid covers whole Poland, so we want to select only those grid 
# cells that lie inside (or intersect) the Lubelskie voivodeship boundary.

# st_filter(x, y, .predicate = ...)
# → keeps features from object x that satisfy a spatial relationship with y
# → here: we keep only grid cells (grid.1km) that intersect the Lubelskie polygon

grid.lub <- st_filter(grid.pop, voi.lub, .predicate = st_intersects)
head(grid.lub)

# Grid geometry for the Lubelskie voivodeship + boundary outline
ggplot() + 
  geom_sf(data = grid.lub) + 
  geom_sf(data = voi.lub, fill = NA, color = "red", linewidth = 0.5) + 
  theme_minimal()

# Choropleth: fill grid cells by population variable
# linewidth=0 makes the grid look smoother (no visible borders).
ggplot(grid.lub) + 
  geom_sf(aes(fill = res), linewidth=0) + 
  scale_fill_viridis_c(option = "C") + 
  theme_minimal() + 
  labs(fill = "Population (res)")

# Zooming in:
# We select one poviat (Lublin city) and compute its bounding box.
# Then coord_sf() zooms the map to that box.

pov.lublin <- pov %>% filter(JPT_NAZWA_ == "powiat Lublin")
pov.lublin

bb <- st_bbox(pov.lublin)
bb

ggplot() + 
  geom_sf(data = grid.lub, aes(fill = res), linewidth = 0) +
  geom_sf(data = pov.lublin, fill = NA, color = "black", linewidth = 0.8) +
  coord_sf(xlim = c(bb["xmin"], bb["xmax"]), 
           ylim = c(bb["ymin"], bb["ymax"]), expand=FALSE) + 
  scale_fill_viridis_c(option = "C") + 
  theme_minimal() + 
  labs(fill="Population (TOT)")


# ------------------------------------------------------------------------------
## 3.4 Poviat level indicators ----

# Object data is a non-spatial table (no geometry). It contains yearly indicators.
head(data)
table(data$year)

# Select one year for mapping (example: 2021)
data.2021 <- data %>% filter(year == 2021)
head(data.2021)

# To map indicators we need geometries, so we merge the non-spatial table with
# poviat polygons. Here we use ID_MAP = 1:380 only because both datasets are
# already in the same order!

pov$ID_MAP <- 1:380
data.sf <- merge(pov, data.2021, by = "ID_MAP")
data.sf

# We check if the geomtries are valid
table(st_is_valid(data.sf))
data.sf <- st_make_valid(data.sf)

# Now, we can visualize the indicators for all of the poviats in Poland

# Map 1: core cities (categorical)
ggplot() +
  geom_sf(data = data.sf, linewidth = 0.1, color = "grey40",
          aes(fill = factor(core_city, levels = c(0,1),
                            labels = c("Non-core", "Core city")))) +
  scale_fill_manual(values = c("Non-core" = "grey85", "Core city" = "#440154FF"), name = "City type") +
  geom_sf(data = voi, fill = NA, color = "grey30", linewidth = 0.5) +
  theme_minimal()

# Map 2: distance to core cities (continuous)
ggplot() + 
  geom_sf(data = data.sf, aes(fill = dist)) + 
  labs(title = "Distance to the core cities") + 
  theme_minimal()
  
# Map 3: housing price per sqm (continuous)
ggplot() + 
  geom_sf(data = data.sf, aes(fill = housing_price_sqm_PLN)) + 
  labs(title = "Housing price per km2") + 
  scale_fill_viridis_c(option = "A") +
  theme_minimal()  


################################################################################
# 4. Spatial processing & integration 
################################################################################

# The goal here is to see how we can integrate information from multiple spatial
# datasets together.

# ------------------------------------------------------------------------------
## 4.1 Spatial relationships ----

# First important step before any spatial join:
# Make sure CRS is identical!

st_crs(firms.sf)
st_crs(grid.lub)

st_crs(firms.sf) == st_crs(grid.lub)

# If they are not the same we use st_transform(), for example:
# firms.sf <- st_transform(firms.sf, st_crs(pov.lub))


# Next, before performing spatial joins, we need to define how geometries are  
# considered related.

# Spatial predicates define *what counts as a match* in spatial operations.
# Note: the choice matters for border cases (points exactly on polygon/grid borders).

# - st_within(): point must be strictly inside (border excluded)
# - st_intersects(): more inclusive, includes borders
# - st_contains(): inverse of within (polygon contains point)
# - st_touches(): share boundary only
# - st_overlaps(): partial overlap (mostly polygon-polygon)

# Rule of thumb: do joins/plots in EPSG:4326 if you want, but do areas/distances 
# in meters (EPSG:2180 for Poland).
# ------------------------------------------------------------------------------
## 4.2 Integrating firm locations into areal units (Points → Polygons) ----

# As a first example we count how many firms lay in each each population grid in
# Lubelskie voivodeship. 

# We alredy prepared the grids for Lubelskie for the visualization
grid.lub

# Map of grids in Lubelskie + firms
ggplot() +
  geom_sf(data = grid.lub, fill = "grey99", color = "black", linewidth = 0.1) +
  geom_sf(data = firms.sf, size = 0.05, color = "black") +
  theme_minimal() +
  labs(title = "Firms in Lubelskie") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# We add IDs to the grids to be able to identify them
grid.lub$grid_ID <- seq_len(nrow(grid.lub)) 
grid.lub 

# We perform a spatial join
firms.joined.grid <- st_join(firms.sf, grid.lub, join = st_within)
firms.joined.grid # for each firm we know to which grid it belongs to (grid_ID)

# We calculate the number of firms per grid
firms.per.grid <- firms.joined.grid %>%
  st_drop_geometry() %>%  # geometry not needed for counting
  group_by(grid_ID) %>%   # group by the grid ID
  summarise(n_firms = n())
firms.per.grid # for each grid ID we have the number of firms that lays within it

# We can check if the number of firms is correct
sum(firms.per.grid$n_firms) == nrow(firms.sf) # TRUE

# Now we merge information about the number of firms to the grid dataset
grid.lub.1 <- grid.lub %>%
  left_join(firms.per.grid, by = "grid_ID") %>%
  mutate(n_firms = replace_na(n_firms, 0))  # grids with no firms get 0
grid.lub.1

ggplot() + 
  geom_sf(data = grid.lub.1, color = "grey70", linewidth = 0.1, aes(fill = n_firms)) + 
  labs(title = "Number of firms") + 
  scale_fill_viridis_c(option = "G", direction = -1) +
  theme_minimal()  


# We can also account for information about the firms in the grids, for example
# how many high-tech vs non-tech firms there are

# Creating readable labels
firms.joined.grid <- firms.joined.grid %>%
  mutate(tech_type = factor(if_high_tech, levels = c(0,1),
                            labels = c("non_tech", "high_tech")))
head(firms.joined.grid)
table(firms.joined.grid$tech_type)

# Counting firms by grid AND by type
firms.by.type <- firms.joined.grid %>%
  st_drop_geometry() %>%
  group_by(grid_ID, tech_type) %>% # grouping by grid ID and firm type
  summarise(n = n(), .groups = "drop") 
firms.by.type 
firms.by.type[100:110,] # long format

# Converting from long format to wide format
# (one column per firm type)
firms.by.type.wide <- firms.by.type %>%
  pivot_wider(names_from = tech_type,
              values_from = n,
              values_fill = 0)
firms.by.type.wide # wide format

# Merging the information back to the grids
grid.lub.2 <- grid.lub.1 %>%
  left_join(firms.by.type.wide, by = "grid_ID") %>%
  mutate(non_tech = replace_na(non_tech, 0), # replacing NAs with 0's
         high_tech = replace_na(high_tech, 0)) %>% 
  mutate(share_high_tech = if_else(n_firms > 0, high_tech / n_firms, 0))
grid.lub.2


# Visualising share of high-tech firms
ggplot(grid.lub.2) +
  geom_sf(aes(fill = share_high_tech),
          color = "grey70",
          linewidth = 0.1) +
  scale_fill_viridis_c(labels = scales::percent) +
  theme_minimal() +
  labs(title = "Share of high-tech firms per grid",
       fill = "")

summary(grid.lub.2$share_high_tech)

# Which grids only have high-tech frim within them?
grid.lub.2 %>% filter(share_high_tech == 1)


# ------------------------------------------------------------------------------
# Exercise 1 
# ------------------------------------------------------------------------------

# Calculate number of firms per sector in each of the grids in Lubelskie 
# (SEC_agri variable), use already created objects: grid.lub.2 & firms.joined 

# 1. Count firms by polygon and sector (type)
# Hint: group by JPT_NAZWA_ & SEC_agg

firms.by.sector <- 

  

  
  
# 2. Covert from long to wide format

firms.by.sector.wide <- 

  
  
  
  
  
# 3. Merge to polygons (poviats), replace NA's wth 0's and calculate share of
# agriculture firms (agri) in grid
  
grid.lub.3 <- 
  
  
  
  
  
  
# 4. Visualise share of agriculture firms in grids and try to play with the color
# palette and ordering
  
  
  
  
  
  
  
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
## 4.3 Calculating distances ----

# Another we could do to enrich our dataset is to calculate distance from each of
# grids to the central city in the region - Lublin

# Let's create a df with coordinates of Lublin
lublin.coords <- data.frame(lon = 22.568445, lat = 51.246452)
lublin.coords

# Creation of a spatial point object
lublin.sf <- st_as_sf(lublin.coords, coords = c("lon", "lat"), crs = crs.geo) 
lublin.sf

# Visualisation on the map
ggplot() +
  geom_sf(data = grid.lub, fill = "grey95", color = "grey50", linewidth = 0.3) +
  geom_sf(data = lublin.sf, color = "red") +
  theme_minimal() +
  labs(title = "Location of Lublin city") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))


# How can we calculate the distance? Easiest option is to calculate the distance
# from each grid's centroid to the city of Lublin.

# To get the most accurate distance, it's best to transform both the grid and the
# location of Lublin to the projection in meters (for Poland crs=2180)
grid.lub.pl <- st_transform(grid.lub, crs.pl)
lublin.sf.pl <- st_transform(lublin.sf, crs.pl)

grid.lub.pl
lublin.sf.pl

st_crs(grid.lub.pl) == st_crs(lublin.sf.pl)

# We compute centroids for the grids
grid.lub.centroids <- st_centroid(grid.lub.pl)
grid.lub.centroids

ggplot(data = grid.lub.centroids) +
  geom_sf(size = 0.05, color = "black") +
  theme_minimal()

# And now we can calculate the distance from each grid's centroid to the city of
# Lublin with st_distance()

dist_Lublin_m <- as.numeric(st_distance(grid.lub.centroids, lublin.sf.pl)) # result in metres
dist_Lublin_km <- dist_Lublin_m / 1000  # convert to kilometres (km), 1 km = 1000 m

# We add those values to our object grid.lub.3
grid.lub.3$dist_Lublin_km <- dist_Lublin_km
grid.lub.3

# Visualising the result
ggplot(grid.lub.3) +
  geom_sf(aes(fill = dist_Lublin_km),
          color = "grey70",
          linewidth = 0.1) +
  scale_fill_viridis_c(option = "A", direction = -1) +
  theme_minimal() +
  labs(title = "Distance to Lublin",
       fill = "km")


# ------------------------------------------------------------------------------
## 4.4 Incorporating data from poviats to grids (Polygons -> Polygons) ----

# Problem:
# Some indicators are only available for large administrative units (poviats),
# but we want to analyse patterns on a finer grid (1 km cells).

# Idea:
# Transfer ("downscale") poviat-level values to grid cells.
# - For grid cells that fall entirely inside one poviat, the value is copied 
#   directly.
# - For grid cells that cross poviat borders, we apply a dominant-area rule: for 
#   each grid cell, we assign the value of the poviat that covers the largest 
#   share of that grid cell.

# We already have spatial data on 2021 indicators at the poviat level
data.sf

# Let's filter out only the fetures for the Lubelskie region
data.sf.lub <- data.sf %>% filter(region_name == "lubelskie")
data.sf.lub # 24 poviats = 24 features

# We'd like to incorporate the information about the housing prices into the grid
ggplot() + 
  geom_sf(data = data.sf.lub, aes(fill = housing_price_sqm_PLN)) + 
  geom_sf(data = grid.lub, fill = NA, color = "grey50", linewidth = 0.3) +
  labs(title = "Housing price per km2") + 
  scale_fill_viridis_c(option = "A") +
  labs(fill = "PLN") +
  theme_minimal()  

# For calculation of the area it's best to also use the projected CRS in meters
grid.lub.pl <- st_transform(grid.lub, crs.pl)
data.lub.pl <- st_transform(data.sf.lub, crs.pl)

# We will also need grid IDs we which we already prepared earlier (grid_ID)
grid.lub.pl

# Unique poviat IDs are also needed (ID_map)
data.lub.pl

# We calculate the intersections
grid.pov.overlap <- st_intersection(
  grid.lub.pl %>% select(grid_ID),
  data.lub.pl  %>% select(ID_MAP, housing_price_sqm_PLN))

grid.pov.overlap # each row is one piece of a grid cell inside exactly one poviat

# We compute the overlap area
grid.pov.overlap$overlap_area <- st_area(grid.pov.overlap)
grid.pov.overlap

# And keep only the largest overlap per grid
largest.overlap <- grid.pov.overlap %>%
  st_drop_geometry() %>%
  group_by(grid_ID) %>%
  slice_max(overlap_area, n = 1, with_ties = FALSE) %>%
  ungroup()
largest.overlap

nrow(largest.overlap) == nrow(grid.lub.pl)

# We attach the information to our grid
grid.lub.4 <- grid.lub.3 %>%
  left_join(largest.overlap %>% select(grid_ID, housing_price_sqm_PLN),
            by = "grid_ID")
grid.lub.4

ggplot() + 
  geom_sf(data = grid.lub.4, aes(fill = housing_price_sqm_PLN)) + 
  labs(title = "Housing price per km2") + 
  scale_fill_viridis_c(option = "A") +
  labs(fill = "PLN") +
  theme_minimal()  



# ------------------------------------------------------------------------------
## 4.5 Aggregation of points into a raster (point density/counts) ----

# Goal: create a raster surface representing the number of firms per raster cell
# within the administrative boundary of Lublin city ("powiat Lublin"). It is similar
# in structure to thegrid we use, but we can can create it directly in R

# What is a raster?

# A raster is a regular grid of equally sized rectangular cells.
# Each cell stores ONE value.

# Conceptually:
# - Raster = matrix + spatial reference (extent + CRS)
# - Every cell has:
#     * a location (x, y position)
#     * a size (resolution)
#     * a value (e.g. count, temperature, elevation)

# In contrast:
# - Vector data stores exact geometries (points, lines, polygons)
# - Raster data approximates space using fixed cells

# Here, we will convert POINTS (firms) into a RASTER surface
# representing the number of firms per cell.


# Choose the polygon - we already have the polygon for Lublin city
pov.lublin

# Select firms inside Lublin city with st_filter()
firms.lublin <- st_filter(firms.sf, pov.lublin, .predicate = st_intersects)

# Add a helper column of ones (useful for counting via sum)
firms.lublin$ones <- 1

# Prepare inputs for rasterization (coordinates + bounding box)
# st_coordinates() extracts point coordinates into a matrix (x, y).
xy <- st_coordinates(firms.lublin)

# Bounding box defines the raster extent (xmin, ymin, xmax, ymax)
bb <- st_bbox(pov.lublin)


# Create an empty raster template (50 x 50 cells) over the bounding box
# IMPORTANT:
# - if you use lon/lat (EPSG:4326), cell size is in degrees (not meters).
# - that's OK for a visualization example, but for "real" density/area analysis
#   you would transform to a projected CRS (e.g., EPSG:2180) first.
rast.temp <- rast(nrows = 50, ncols = 50,
                  xmin = bb["xmin"], xmax = bb["xmax"],
                  ymin = bb["ymin"], ymax = bb["ymax"],
                  crs  = st_crs(firms.lublin)$wkt)
rast.temp


# Rasterize = count points per cell

# We count points by summing the 'ones' field inside each raster cell.
# terra::rasterize can take point coordinates (xy) + a vector of values.
r.count <- rasterize(xy, rast.temp, firms.lublin$ones, fun = sum)

# Inspect raster summary
r.count


# Plot raster + (optional) visible grid + city outline

plot(r.count, main = "Firms per raster cell (Lublin city)")

# Overlay the boundary polygon
plot(st_geometry(pov.lublin), add = TRUE)

# Optional: show cell grid using sf (same nrows/ncols as raster)
# st_make_grid() creates a polygon grid based on the boundary's bbox by default.
grid_vis <- st_make_grid(pov.lublin, n = c(50, 50))
plot(grid_vis, add = TRUE, border = "grey85")


# ------------------------------------------------------------------------------
# Exercise 2
# ------------------------------------------------------------------------------

# Create a raster for poviat Chełm in Lubelskie in projected crs for Poland 
# (crs = 2180), where you will represent the number of firms

# 1. Create the separate object for poviat Chełm
# (filter it out of object pov by selecting JPT_KOD_JE == "0662")

pov.chelm <- 
  
  
  

# 2. Filter out firms that are located in that poviat

firms.chelm <- 
  
  
  
  

# 3. Change the projection for both object to crs = 2180

pov.chelm.pl <- 
firms.chelm.pl <- 


  

# 4. Prepare inputs for rasterization (coordinates + bounding box)

xy.chelm <- 

bb.chelm <- 

# 5. Create an empty raster template over poviat Chełm
# Hint: In EPSG:2180, units are meters, so you can define:
# - either nrows/ncols (e.g., 50 x 50 - nrows = 50, ncols = 50) OR
# - resolution in meters (e.g., 1500 m cells - resolution = 1500)

# Option A (same as Lublin example): fixed number of rows/cols
rast.chelm.temp.A <-
  
  
  

# Option B (recommended for projected CRS): fixed cell size (e.g. 500 m)
rast.chelm.temp.B <-
  
  
  
  
# 6. Rasterize: count firms per cell
# Hint: Create a vector of ones  firms.chelm.pl$ones <- 1 OR instead use fun = length
firms.chelm.pl$ones <- 1

r.chelm 


# 7. Plot raster + boundary 
# Hint: Use plot() for terra rasters, then add polygon outline with add=TRUE
plot()
plot()


