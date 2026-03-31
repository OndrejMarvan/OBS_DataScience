################################################################################
# Spatial Machine Learning in R — Session 4
# Degree of Urbanisation (DEGURBA) with flexurba
# MA Monika Kot
################################################################################

# https://flexurba-spatial-networks-lab-research-projects--e74426d1c66ecc.pages.gitlab.kuleuven.be/index.html

################################################################################
# 1. Packages & Setup ----
################################################################################

# Installing packages (if needed)
# install.packages("tidyverse")
# install.packages("sf")
# install.packages("terra")
# install.packages("tidyterra")
# install.packages("flexurba")

# Loading packages
library(tidyverse)   # data manipulation & plotting
library(sf)          # vector spatial data
library(terra)       # raster data
library(tidyterra)   # plotting SpatRaster with ggplot
library(flexurba)    # DEGURBA workflow

# Setting the working directory
getwd()
# setwd("...")

# Showing error messages in English
Sys.setenv(LANG = "en")

# Turning off scientific notation
options(scipen = 999)

# Increasing timeout for large downloads
options(timeout = 500)


################################################################################
# 2. Data Import ----
################################################################################

## Administrative boundaries ---------------------------------------------------
# We use:
# - voivodeships (voi)
# - poviats (pov)

voi <- st_read("data/wojewodztwa.shp") %>% st_transform(4326)
pov <- st_read("data/powiaty.shp") %>% st_transform(4326)

# Make sure geometries are valid
voi <- st_make_valid(voi)
pov <- st_make_valid(pov)


## Study area: Lubelskie voivodeship -------------------------------------------

region.voi <- voi %>% filter(JPT_NAZWA_ == "lubelskie")

## Poviats in Lubelskie --------------------------------------------------------

# In the Polish TERYT administrative coding system, the first two digits
# of the territorial unit ID identify the voivodeship.
# Code "06" corresponds to Lubelskie, so selecting codes starting with "06"
# returns all poviats located in this region.

region.pov <- pov %>% filter(startsWith(JPT_KOD_JE, "06"))

## Optional: firm-level point data ---------------------------------------------
# This will be used later for linking firms to DEGURBA classes

firms <- read.csv("data/firms_data_utf8.csv", row.names = 1)

firms.sf <- firms %>%
  st_as_sf(coords = c("crds.x", "crds.y"), crs = 4326)


################################################################################
# 3. Downloading GHSL Data ----
################################################################################

# DEGURBA requires three raster layers:
# - built-up surface grid (built-up area per cell)
# - population grid (number of people per cell)
# - land grid (land area per cell)

# The flexurba function downloads the global GHSL datasets.
# They are saved locally in the folder specified by `output_directory`.

# output_directory:
# folder where the downloaded raster files will be stored

# filenames:
# names that will be given to the downloaded files on your computer
# (one file for built-up surface, population, and land area)

# The official flexurba workflow downloads the global GHSL layers first,
# and then crops them to the study area.

download_GHSLdata(output_directory = "data/global",
                  filenames = c("built.tif", "pop.tif", "land.tif"))

# After downloading, the files will be available in:
# data/global/built.tif
# data/global/pop.tif
# data/global/land.tif
  
################################################################################
# 4. Cropping GHSL Data to the Study Area ----
################################################################################

# GHSL rasters are provided in the Mollweide projection (ESRI:54009).
# To correctly crop the rasters, the study area must be in the same CRS.

region.voi.moll <- region.voi %>% st_transform("ESRI:54009")

# Crop the global GHSL rasters to the study area

# extent:
# the bounding box of the study region used to clip the global rasters

# global_directory:
# folder where the previously downloaded global GHSL files are stored

# global_filenames:
# names of the global raster files that will be cropped

# output_directory:
# folder where the cropped rasters for our study region will be saved

# output_filenames:
# names of the cropped raster files created for the Lubelskie region

crop_GHSLdata(extent = ext(region.voi.moll),
              global_directory = "data/global",
              global_filenames = c("built.tif", "pop.tif", "land.tif"),
              output_directory = "data/lubelskie_region",
              output_filenames = c("built_lub.tif", "pop_lub.tif", "land_lub.tif"))
  


################################################################################
# 5. Pre-processing the Grids ----
################################################################################

# DEGURBA classification relies on three types of information:
# population distribution, built-up surface, and land area.
# These datasets together allow us to estimate population density
# and identify urban clusters.

# Pre-processing ensures that the datasets are consistent and ready
# for the classification algorithm.

# Specifically, this step:
# - aligns the raster grids (same resolution and cell structure)
# - ensures all rasters share the same CRS
# - calculates population density based on permanent land area
# - prepares the data structure required by the flexurba functions

data.lub <- DoU_preprocess_grid(directory = "data/lubelskie_region",
                                c("built_lub.tif", "pop_lub.tif", "land_lub.tif"))
  

# The output is a list containing the processed raster layers
# used for DEGURBA classification.

# Check the structure of the output object
str(data.lub)

# Inspect the individual raster layers

# built → built-up surface per grid cell
data.lub$built

# land → permanent land area per grid cell
data.lub$land

# pop → population per grid cell
data.lub$pop


################################################################################
# 6. DEGURBA Classification - Level 1 ----
################################################################################

# Level 1 classifies each grid cell based on population density
# and settlement structure.

# The output assigns one of four classes to every grid cell:
# 0 = water grid cell
# 1 = rural grid cell
# 2 = urban cluster
# 3 = urban centre

# The classification is applied to every cell in the population grid.

degurba.level.1.voi <- DoU_classify_grid(data = data.lub)

# The result is a raster where each cell contains the DEGURBA class
degurba.level.1.voi


# Visualising the classification 

# Basic plot of the classified raster
# Each color corresponds to one DEGURBA category
DoU_plot_grid(degurba.level.1.voi)


# Improved map with additional elements
# - scalebar helps interpret spatial scale
# - title clarifies the classification level and study area
# - administrative boundary is added for spatial reference

DoU_plot_grid(degurba.level.1.voi, scalebar = TRUE,
              title = "DEGURBA L1 for Lubelskie") +
  geom_sf(data = region.voi.moll, fill = NA, linewidth = 0.2, color = "black")


################################################################################
# 7. DEGURBA Classification - Level 2 ----
################################################################################

# DEGURBA Level 2 classification provides a more detailed description
# of the settlement structure than Level 1.

# Instead of only distinguishing rural areas, urban clusters,
# and urban centres, Level 2 further separates areas based on
# population density and settlement intensity.

# Each grid cell is assigned one of the following classes:

# 10 = water grid cell
# 11 = very low density rural grid cell
# 12 = low density rural grid cell
# 13 = rural cluster
# 21 = suburban / peri-urban grid cell
# 22 = semi-dense urban cluster
# 23 = dense urban cluster
# 30 = urban centre


# Run the classification algorithm

# Setting level1 = FALSE tells flexurba to apply
# the more detailed Level 2 classification rules.

degurba.level.2.voi <- DoU_classify_grid(data = data.lub, level1 = FALSE)

# The output is again a raster where each cell
# contains the DEGURBA Level 2 category

degurba.level.2.voi

# Visualising the Level 2 classification

# The plotting function is the same as before,
# but we specify level1 = FALSE so the correct
# legend and colour scheme are used.

DoU_plot_grid(degurba.level.2.voi, scalebar = TRUE, level1 = FALSE,
              title = "DEGURBA L2 for Lubelskie") +
  geom_sf(data = region.voi.moll, fill = NA, linewidth = 0.3, color = "black")

# Level 2 is often used in research because it captures
# the gradient between rural areas, suburban zones,
# and dense urban cores.

################################################################################
# 8. Zooming in to a Selected Area ----
################################################################################

# So far we plotted the classification for the entire Lubelskie region.
# Sometimes it is easier to interpret the results by zooming in to a smaller area.

# Example: powiat Lublin

# Select the administrative boundary of the chosen powiat

border.Lublin <- pov[pov$JPT_NAZWA_ == "powiat Lublin", ]

# Transform the boundary to Mollweide projection so it matches the raster CRS

border.Lublin.moll <- border.Lublin %>% st_transform("ESRI:54009")

# Level 1 zoom ---------------------------------------------------------------

# The argument `extent` defines the spatial window of the map.
# Here we use the bounding box of poviat Lublin, which limits
# the plot to this smaller area.

DoU_plot_grid(degurba.level.1.voi, scalebar = TRUE, title = "DEGURBA L1",
              extent = terra::ext(border.Lublin.moll)) +
  geom_sf(data = border.Lublin.moll, fill = NA, linewidth = 0.2, color = "black")

# Level 2 zoom ---------------------------------------------------------------

# The same zoom can be applied to the Level 2 classification
# to see the more detailed settlement structure within the poviat.

DoU_plot_grid(degurba.level.2.voi, scalebar = TRUE, title = "DEGURBA L2",
              level1 = FALSE, extent = terra::ext(border.Lublin.moll)) +
  geom_sf(data = border.Lublin.moll, fill = NA, linewidth = 0.2, color = "black")

# Zooming helps us see the internal structure of settlements
# that may not be visible when plotting the entire region.

################################################################################
# 9. Inspecting DEGURBA Parameters ----
################################################################################

# The DEGURBA classification is based on a set of predefined parameters
# such as population density thresholds and minimum population sizes
# for identifying urban clusters and urban centres.

# flexurba allows us to inspect these parameters.

# Level 1 parameters
# (used to distinguish rural areas, urban clusters and urban centres)

DoU_get_grid_parameters(level1 = TRUE)

# Level 2 parameters
# (used for the more detailed classification of settlement types)

DoU_get_grid_parameters(level1 = FALSE)


################################################################################
# 10. Sensitivity Analysis - Adapting the Parameters ----
################################################################################

# In some research applications we may want to test how sensitive
# the classification is to changes in the parameters.

# This step modifies several thresholds used in the classification
# algorithm to see how the results change.

# NOTE:
# For official comparisons (e.g. Eurostat statistics) the default
# parameters should always be used.

degurba.level.1.voi.adapt <- DoU_classify_grid(
  data = data.lub,
  level1 = TRUE,
  parameters = list(
    # Minimum population density for urban centres
    UC_density_threshold = 1650,   # default = 1500
    
    # Minimum population size for an urban centre
    UC_size_threshold = 60000,     # default = 50000
    
    # Number of neighbouring cells considered contiguous
    UC_contiguity_rule = 8,        # default = 4
    
    # Whether built-up density must also be satisfied
    UC_built_criterium = FALSE,    # default = TRUE
    
    # Minimum density for urban clusters
    UCL_density_threshold = 200,   # default = 300
    
    # Minimum population size for urban clusters
    UCL_size_threshold = 4000      # default = 5000
  )
)

# Compare the adapted classification with the default classification

# Cells that changed classification will receive value 1
# Cells that stayed the same will receive value 0

degurba.level.1.voi.diff <- terra::ifel(
  degurba.level.1.voi.adapt != degurba.level.1.voi, 1, 0)

# Convert the raster to a categorical variable for easier plotting
degurba.level.1.voi.diff.fac <- terra::as.factor(degurba.level.1.voi.diff)

# Assign labels to the categories
levels(degurba.level.1.voi.diff.fac) <- data.frame(
  ID = c(0, 1),
  changed = c("Unchanged", "Reclassified"))

# Plot adapted classification
DoU_plot_grid(degurba.level.1.voi.adapt) +
  geom_sf(data = region.voi.moll, fill = NA, linewidth = 0.2, color = "black")

# Plot reclassified cells
ggplot() +
  tidyterra::geom_spatraster(data = degurba.level.1.voi.diff.fac) +
  scale_fill_manual(values = c("Unchanged" = "grey95", 
                               "Reclassified" = "grey30"),
                    name = NULL) +
  geom_sf(data = region.voi.moll, fill = NA, linewidth = 0.25, color = "black") +
  theme_void() +
  theme(legend.position = "bottom",
        legend.direction = "horizontal")


################################################################################
# 11. Converting DEGURBA Raster to Grid Cells (sf) ----
################################################################################

# Raster data are efficient for calculations,
# but sometimes we want each grid cell represented as a polygon
# so that we can use vector-based spatial operations.

# This is particularly useful for spatial joins
# or aggregating results to administrative units.

# This step converts each raster cell into a polygon.

degurba.L1.pols <- terra::as.polygons(degurba.level.1.voi,
                                      dissolve = FALSE,
                                      na.rm = TRUE)

degurba.L1.pols

# Convert the object to an sf dataset
# and rename the classification column
degurba.L1.sf <- sf::st_as_sf(degurba.L1.pols) %>%
  dplyr::rename(degurba.L1 = layer) %>%
  dplyr::mutate(
    degurba.L1 = factor(degurba.L1,
                        levels = c(0, 1, 2, 3),
                        labels = c("water cell", "rural cell", 
                                   "urban cluster", "urban centre")))

degurba.L1.sf

# Visualisation with ggplot
ggplot() +
  geom_sf(data = degurba.L1.sf, aes(fill = degurba.L1), color = NA) +
  geom_sf(data = region.voi.moll, fill = NA, linewidth = 0.3) +
  scale_fill_manual(values = c("water cell" = "#7AB5F5",
                               "rural cell" = "#73B273",
                               "urban cluster" = "#FFAA00",
                               "urban centre" = "#FF0000")) +
  theme_minimal() +
  labs(fill = "DEGURBA Level 1")
    


################################################################################
# 12. Restricting the Grid to the Exact Region Boundary ----
################################################################################

# The classification was originally calculated for a rectangular
# bounding box around the study area.

# Some cells may therefore fall outside the actual region boundary.
# We remove them using a spatial filter.

degurba.L1.sf.lub <- sf::st_filter(degurba.L1.sf,
                                   region.voi.moll,
                                   .predicate = st_intersects)

degurba.L1.sf.lub

# Count how many cells belong to each DEGURBA class
table(degurba.L1.sf.lub$degurba.L1)

# Calculate the percentage share of each class
shares <- table(degurba.L1.sf.lub$degurba.L1) / dim(degurba.L1.sf.lub)[1] * 100
round(shares, 2)

# Plot in Mollweide
ggplot() +
  geom_sf(data = degurba.L1.sf.lub, aes(fill = degurba.L1), color = NA) +
  geom_sf(data = region.voi.moll, fill = NA, linewidth = 0.3) +
  scale_fill_manual(values = c("water cell" = "#7AB5F5",
                               "rural cell" = "#73B273",
                               "urban cluster" = "#FFAA00",
                               "urban centre" = "#FF0000")) +
  theme_minimal() +
  theme(legend.position = "none")
    

# Transform to WGS84
degurba.L1.sf.lub.4326 <- sf::st_transform(degurba.L1.sf.lub, 4326)

# Plot in WGS84
ggplot() +
  geom_sf(data = degurba.L1.sf.lub.4326, aes(fill = degurba.L1), color = NA) +
  geom_sf(data = st_transform(region.voi.moll, 4326), fill = NA, linewidth = 0.3) +
  scale_fill_manual(values = c(
    "water cell" = "#7AB5F5",
    "rural cell" = "#73B273",
    "urban cluster" = "#FFAA00",
    "urban centre" = "#FF0000")) +
  theme_minimal() +
  labs(fill = "DEGURBA Level 1")


################################################################################
# 13. Linking DEGURBA to Point Data ----
################################################################################

# We can assign a DEGURBA class to individual observations
# (for example firms, households or events) based on the grid cell
# in which the point is located.

# IMPORTANT:
# Both datasets must use the same coordinate reference system.

st_crs(firms.sf) == st_crs(degurba.L1.sf.lub.4326)

# If needed:
# firms.sf <- st_transform(firms.sf, st_crs(degurba.L1.sf.lub.4326))

# Spatial join:
# each firm inherits the DEGURBA class of the grid cell it falls into

points.sf.degurba <- sf::st_join(firms.sf,
                                 degurba.L1.sf.lub.4326,
                                 join = st_within)

# Example output
points.sf.degurba[, c("ID", "SEC_agg", "poviat", "degurba.L1")]

# Number of firms in each DEGURBA class
table(points.sf.degurba$degurba.L1)


################################################################################
# 14. Aggregating DEGURBA to Spatial Units - Level 1 ----
################################################################################

# DEGURBA is fundamentally a grid-based classification.
# However, many analyses require classifications at the level
# of administrative units (e.g. municipalities or poviats).

# Transform poviats to Mollweide so they match the raster CRS
region.pov.moll <- region.pov %>% st_transform("ESRI:54009")

# Prepare the units for classification
data.poviats.L1 <- DoU_preprocess_units(units = region.pov.moll,
                                        classification = degurba.level.1.voi,
                                        pop = data.lub$pop)

# Identify the column containing the unit ID
region.pov.moll$JPT_NAZWA_

# Classify each unit according to DEGURBA rules
poviats.class.L1 <- DoU_classify_units(data.poviats.L1, id = "JPT_NAZWA_",
                                       filename = "data/lubelskie_region/poviats_L1.csv")

# Preview the first rows of the resulting table
head(poviats.class.L1)


# The output table contains several types of information:

# JPT_NAZWA_
# name of the administrative unit (here: poviat)

# Tot_Pop
# total population of the unit calculated from the population grid

# UCentre_Pop
# population living in cells classified as urban centres

# UCluster_Pop
# population living in urban clusters

# Urban_Pop
# total population living in urban areas (urban centres + clusters)

# Rural_Pop
# population living in rural grid cells


# The following columns show the shares of these populations
# relative to the total population of the unit:

# UCentre_share
# share of population living in urban centres

# UCluster_share
# share of population living in urban clusters

# Urban_share
# share of population living in urban areas

# Rural_share
# share of population living in rural areas


# flexurba_L1
# final DEGURBA Level 1 classification of the administrative unit
# (1 = rural area, 2 = town / urban cluster, 3 = city / urban centre)

# Plot unit classification
DoU_plot_units(region.pov.moll, classification = poviats.class.L1)

# Plot grid classification with poviat borders
DoU_plot_grid(degurba.level.1.voi) +
  geom_sf(data = region.pov.moll, fill = NA, linewidth = 0.2, color = "black")

# Plot units in WGS84
DoU_plot_units(region.pov, classification = poviats.class.L1)

# Which poviats are classified as cities (class 3)?
poviats.class.L1 %>% filter(flexurba_L1 == 3)

################################################################################
# 15. Aggregating DEGURBA to Spatial Units - Level 2 ----
################################################################################

# Same procedure, but using the Level 2 classification

data.poviats.L2 <- DoU_preprocess_units(units = region.pov.moll,
                                        classification = degurba.level.2.voi,
                                        pop = data.lub$pop)

poviats.class.L2 <- DoU_classify_units(data.poviats.L2,
                                       id = "JPT_NAZWA_",
                                       level1 = FALSE,
                                       filename = "data/lubelskie_region/poviats_L2.csv")

head(poviats.class.L2)

# Plot Level 2 unit classification
DoU_plot_units(region.pov.moll,
               classification = poviats.class.L2,
               level1 = FALSE)

# Plot Level 2 grid classification with poviat borders
DoU_plot_grid(degurba.level.2.voi, level1 = FALSE) +
  geom_sf(data = region.pov.moll, fill = NA, linewidth = 0.4, color = "black")

################################################################################
# 16. EXERCISE - DEGURBA Level 2 for Mazowieckie ----
################################################################################

# Goal:
# Prepare the DEGURBA Level 2 classification for the Mazowieckie voivodeship
# and zoom in to the poviat of Warsaw.

# In this exercise we repeat the same workflow as for Lubelskie:
# 1. select the study area
# 2. crop the GHSL rasters
# 3. preprocess the grids
# 4. run the Level 2 classification
# 5. plot the results for the full region
# 6. zoom in to Warsaw

################################################################################
# 16.1 Select the study area ----
################################################################################

# Select Mazowieckie from the voivodeship layer
# (JPT_NAZWA_ == "mazowieckie")
# Hint: use filter()

region.voi.maz <-
  

# Select poviats belonging to Mazowieckie
# In the TERYT system, code "14" corresponds to Mazowieckie
# # Hint: use filter() with startsWith()

region.pov.maz <- 

# Transform the study area to Mollweide projection ("ESRI:54009")
# because GHSL rasters use this CRS

region.voi.maz.moll <- 
  

################################################################################
# 16.2 Crop the GHSL rasters to Mazowieckie ----
################################################################################

# We use the bounding box of Mazowieckie to crop the global rasters.
# The cropped files will be saved in a separate folder.

crop_GHSLdata(
  extent = terra::ext(region.voi.maz.moll),
  global_directory = "data/global",
  global_filenames = c("built.tif", "pop.tif", "land.tif"),
  output_directory = "data/mazowieckie_region",
  output_filenames = c("built_maz.tif", "pop_maz.tif", "land_maz.tif")
)


################################################################################
# 16.3 Preprocess the cropped rasters ----
################################################################################

# This step aligns the grids and prepares them for classification.

data.maz <- 


################################################################################
# 16.4 Run DEGURBA Level 2 classification ----
################################################################################


degurba.level.2.maz <- 
  

# Inspect the output raster
degurba.level.2.maz


################################################################################
# 16.5 Plot DEGURBA Level 2 for Mazowieckie ----
################################################################################

# Plot the classification for the full voivodeship

DoU_plot_grid()


################################################################################
# 16.6 Select Warsaw and zoom in ----
################################################################################


# Select the Warsaw poviat / city county
# (JPT_NAZWA_ == "powiat Warszawa")

border.Warsaw <- 

# Transform Warsaw boundary to Mollweide
border.Warsaw.moll <- 


################################################################################
# 16.7 Zoom in to Warsaw ----
################################################################################

# Use the bounding box of Warsaw as the plotting extent

DoU_plot_grid()




