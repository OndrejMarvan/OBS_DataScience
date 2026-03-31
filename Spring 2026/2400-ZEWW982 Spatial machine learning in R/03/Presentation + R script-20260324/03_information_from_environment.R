################################################################################
# Spatial Machine Learning in R — Session 3
# Obtaining information from the environment
# MA Monika Kot
################################################################################


################################################################################
# 1. Packages & Setup ----
################################################################################

# Installing the packages
# install.packages(c("spdep"))

# Loading the packages
library(tidyverse)  # data manipulation & visualization
library(sf)         # spatial operations
library(spdep)      # spatial weight matrices


# Setting the path to working directory
getwd()     # current working directory
# setwd()   # set to desired working directory

# Showing the error messages in English
Sys.setenv(LANG = "en")

# Turning off the scientific notation
options(scipen = 999)


################################################################################
# 2. Data Import ----
################################################################################

## Administrative boundaries for whole Poland (polygons) -----------------------
# voivodeships: 16 polygons (voi)
# poviats: 380 polygons (pov)

# 4326 = WGS84 (geographical CRS)

voi <- st_read("data/wojewodztwa.shp") %>% st_transform(4326)

pov <- st_read("data/powiaty.shp") %>% st_transform(4326)
pov <- st_make_valid(pov)


## Fragment of maps for Lubelskie region --------------------------------------

voi.lub <- voi %>% filter(JPT_NAZWA_ == "lubelskie")


## Point data for firms in Lubelskie region ------------------------------------

firms <- read.csv("data/firms_data_utf8.csv", row.names = 1)

# Transforming to sf object
firms.sf <- firms %>% 
  st_as_sf(coords = c("crds.x", "crds.y"), crs = 4326)
head(firms.sf)


################################################################################
# 3. Spatial weight matrices
################################################################################

# Understanding neighbourhood structure is a key element of spatial modelling.
# It defines "who influences whom" in space.

# A spatial weights matrix (W) is an n x n table (matrix), where:
# - n = number of spatial units (regions, points, etc.)
# - rows represent unit i
# - columns represent unit j

# Each element w_ij describes the relationship between unit i and unit j.

# Important rules:
# - w_ii = 0 (a unit is NOT its own neighbour)
# - If units are neighbours → w_ij > 0
# - If units are NOT neighbours → w_ij = 0

# STEP 1: Define WHO is a neighbour (neighbourhood matrix: 0/1)
# STEP 2: Define HOW STRONG the relationship is (weights + standardisation)

# In practice:
# - "nb" object → structure (who is neighbour of whom)
# - "listw" object → weighted matrix used for calculations


# ------------------------------------------------------------------------------
## 3.1 Contiguity matrix (polygons share common border) ----

# IDEA:
# Two regions are neighbours if they share a common boundary (border).
# This approach is mainly used for polygon (areal) data.

# Neighbourhood definition (binary form):
# w_ij = 1  if regions i and j share a border
# w_ij = 0  otherwise
# w_ii = 0  (diagonal is always zero)

# This creates a BINARY neighbourhood matrix (0/1).

# STANDARDISATION:
# Usually we apply ROW-STANDARDISATION (style = "W"):
# Each row is divided by the number of neighbours.

# After standardisation:
# - Each row sums to 1
# - Each neighbour gets weight = 1 / (number of neighbours)

# Interpretation:
# The influence of neighbours becomes a weighted average.
# Regions with many neighbours do not automatically have stronger total influence.

# Order of neighbourhood:
# - First-order: only direct neighbours
# - Second-order: neighbours of neighbours


# matrix of neighbourhood according to the contiguity criterion
cont.nb <- poly2nb(pov, queen = TRUE) # class nb
# queen=TRUE counts shared borders AND corners; queen=FALSE only shared borders (rook)

# spatial weights matrix, row-standardised to one
cont.listw <- nb2listw(cont.nb, style = "W") # class listw
cont.listw # summary of the weight matrix

# sf plot of neighbourhood structure
crds.sf <- st_centroid(st_geometry(pov)) # centroids
plot(st_geometry(pov)) # contour map
plot(cont.nb, crds.sf, add = TRUE) # links

# conversion to class matrix
cont.mat <- nb2mat(cont.nb)
cont.mat[1:8, 1:8]

# general summary
summary(cont.listw)

# most connected regions 
pov$JPT_NAZWA_[8]
pov$JPT_NAZWA_[112]

# two of the least connected regions (out of 31)
pov$JPT_NAZWA_[23]
pov$JPT_NAZWA_[25]

# ------------------------------------------------------------------------------
## 3.2 K nearest neighbours (knn) matrix  ----

# IDEA:
# Each spatial unit is connected to its k closest neighbours
# based on distance between centroids (or points).

# This method is especially useful for POINT DATA,
# where there are no shared borders.

# Neighbourhood definition:
# For each unit i:
# - Select k closest units
# - w_ij = 1 for those k neighbours
# - w_ij = 0 for all others
# - w_ii = 0

# Important:
# The KNN matrix is often NOT symmetric:
# If j is among the k nearest neighbours of i,
# i is not necessarily among the k nearest neighbours of j.

# Therefore:
# We often "make it symmetric" before converting to listw.

# STANDARDISATION:
# Usually row-standardised (style = "W"):
# Each of the k neighbours receives weight = 1/k.
#
# Interpretation:
# Each unit is influenced by exactly k neighbours,
# and total neighbour influence equals 1.
#
# Choosing k:
# - Small k → very local structure
# - Large k → more global structure
# - k should be chosen analytically (not randomly)

# ------------------------------------------------------------------------------
### 3.2.1 knn matrix for aerial data ----

# 1) Calculate centroids of regions (poviats)
crds.sf <- st_centroid(st_geometry(pov)) 

# 2) Find k nearest neighbours for each poviat (k = 4)
pov.knn.sf <- knearneigh(crds.sf, k = 4) 
pov.knn.sf

# 3) Convert knn object to neighbour list (nb class)
pov.knn.nb.sf <- knn2nb(pov.knn.sf)
pov.knn.nb.sf # each region has exactly 4 neighbours

is.symmetric.nb(pov.knn.nb.sf)
# the structure is NOT symmetric - if A selects B, B does NOT have to select A

# 4) Force symmetry
pov.knn.sym.nb <- make.sym.nb(pov.knn.nb.sf)
# After symmetry:
# - If A selects B, B is forced to connect back to A
# -  Some regions may now have more neighbours than k, because several regions 
#    can select the same closest neighbour (after symmetry).

# 5) Convert to spatial weight matrix (listw class)
pov.knn.sym.listw <- nb2listw(pov.knn.sym.nb)
summary(pov.knn.sym.listw)

# - Average number of links ≈ 4.72
#   (greater than 4 because symmetry adds reciprocal links)

# - Link distribution 
#   Regions with more links are those that are the closest
#   neighbour for multiple other regions.

# sf plot of neighbourhood structure
plot(st_geometry(pov))
plot(knn2nb(pov.knn.sf), crds.sf, add = TRUE)

# conversion to class matrix
cont.mat.knn <- nb2mat(pov.knn.sym.nb)
cont.mat.knn[1:8, 1:8]

# ------------------------------------------------------------------------------
### 3.2.2 knn matrix for point data ----

# Now the goal is to create knn matrix for point data, not for centroids of regions
# For that we use a subset of data on business locations (n=100, randomly selected)

set.seed(123)
firms.sub <- slice_sample(firms, n = 100, replace = FALSE) 
dim(firms.sub)

# matrix k = 4 nearest neighbours for point data - knn class object
points.knn <- knearneigh(as.matrix(firms.sub[, c("crds.x", "crds.y")]), k = 4)
points.knn.nb <- knn2nb(points.knn)
points.knn.nb

# plot of knn: region + points + links
plot(voi.lub$geometry) # plot a single region
plot(points.knn.nb, as.matrix(firms.sub[,c("crds.x", "crds.y")]), add = TRUE)

# this matrix is also asymmetric, but we can change it using make.sym.nb()
is.symmetric.nb(points.knn.nb)
points.knn.sym.nb <- make.sym.nb(points.knn.nb)
is.symmetric.nb(points.knn.sym.nb)

# create a listw class object
points.knn.sym.listw <- nb2listw(points.knn.sym.nb)
summary(points.knn.sym.listw)


# IMPORTANT: Choosing k in KNN matrices

# There is no universally "correct" k — it depends on the spatial process

# k controls how "local" the spatial interaction is.
# Too small k → fragmented system.
# Too large k → over-connected system.
# Best k is usually selected by comparing model performance (e.g. AIC).

# Nice resource by dr Kubara & prof Kopczewska
# https://www.tandfonline.com/doi/full/10.1080/17421772.2023.2176539

# In R, analytical selection of W is implemented in the
# spatialWarsaw:: package (function bestW()):

# install.packages("devtools") # install spatialWarsaw:: from GitHub
# devtools::install_github("poktam/spatialWarsaw")
# library(spatialWarsaw)
# help(bestW)

# ------------------------------------------------------------------------------
## 3.3 Neighbourhood matrix in radius of d km  ----

# IDEA:
# Two units are neighbours if the distance between them
# is less than or equal to a chosen threshold d (in km).

# Neighbourhood definition:
# w_ij = 1  if distance(i,j) ≤ d
# w_ij = 0  if distance(i,j) > d
# w_ii = 0

# This creates a binary distance-based neighbourhood matrix.

# Important:
# If d is too small:
# - Some units may have NO neighbours (called "islands")
# - This may cause problems in modelling

# STANDARDISATION:
# Usually row-standardised (style = "W"):
# Each neighbour receives weight = 1 / (number of neighbours within d)

# Interpretation:
# Influence comes only from units inside the selected radius.
# The choice of d defines the spatial range of interaction.

# spatial weights matrix of neighbours in a radius of d=30 km

# 1) Calculating centroids of regions (poviats)
crds.sf <- st_centroid(st_geometry(pov)) 

# 2) Calculating neighbours in radius of 30 km (clss nb)
#    d1 = lower distance bound
#    d2 = upper distance bound
conti.d.30 <- dnearneigh(crds.sf, d1 = 0, d2 = 30)

# 3) Creating a spatial weight matrix (class listw)
# argument zero.policy = TRUE is crucial when some of the regions don't have links
conti.d.30.listw <- nb2listw(conti.d.30, zero.policy = TRUE)
conti.d.30.listw

# 4) Visualising the results

# visualisation of the links
plot(st_geometry(pov)) 
plot(conti.d.30, st_coordinates(crds.sf), add = TRUE) 

# visualisations for the number of links 

# number of neighbours within 30 km
n_links_d30 <- card(conti.d.30)

# add to sf object
pov$n_links_d30 <- n_links_d30

# indicator: regions with zero neighbours
pov$no_links_d30 <- ifelse(n_links_d30 == 0, 1, 0)

# visualising zero-link regions
ggplot(pov) +
  geom_sf(aes(fill = factor(no_links_d30))) +
  scale_fill_manual(values = c("0" = "lightgrey", "1" = "red"),
                    labels = c("Has neighbours", "No neighbours"),
                    name = "30 km radius") +
  theme_minimal()

# visualising number of neighbours
ggplot(pov) +
  geom_sf(aes(fill = n_links_d30)) +
  scale_fill_viridis_c(option = "viridis") +
  labs(fill = "Number of neighbours\n(30 km)") +
  theme_minimal()


# for which distance d all regions have at least one neighbour?

# by default k=1, list of nearest neighbours
kkk <- knn2nb(knearneigh(crds.sf))

# distances between nearest neighbours 
all_dist <- unlist(nbdists(kkk, crds.sf))

# what is the max distance to the nearest neighbour?
max(all_dist)

# This can be used also for point data (similar approach as in knn matrix above)

# ------------------------------------------------------------------------------
## 3.4 Inverse distance matrix  ----

# IDEA:
# In distance-decay weights, influence decreases with distance:
# nearby units influence each other more than distant units.
#
# Common functional forms:
# - inverse distance:            w_ij = 1 / d_ij
# - inverse squared distance:    w_ij = 1 / d_ij^2
# - exponential decay:           w_ij = exp(-lambda * d_ij)
#
# For polygon data, distances are typically measured between centroids.
# For point data, distances are calculated directly between coordinates.

# Properties:
# - No clear "cut-off" distance
# - Influence gradually decreases
# - Often dense matrix (many non-zero values)

# STANDARDISATION:
# Can be:
# - "raw" (no row standardisation)
# - Row-standardised ("W") so rows sum to 1

# Interpretation:
# Very close neighbours strongly influence the unit.
# Distant units have very small impact.

# ------------------------------------------------------------------------------
### 3.4.1 Manual approach: build nb -> compute distances -> transform -> listw ----

# 1) Calculating centroids of regions (poviats)
crds.sf <- st_centroid(st_geometry(pov)) 

# 2) Creating an nb structure where ALL regions are neighbours
# For 380 regions, each region is linked to the other 379 regions.
pov.knn.all <- knearneigh(st_coordinates(crds.sf), k = 379)
pov.nb.all  <- knn2nb(pov.knn.all)

# 3) Computing distances between neighbours 
dist.all <- nbdists(pov.nb.all, crds.sf)
dist.all

# 4) Transforming distances into weights (distance decay)
# Inverse distance: w_ij = 1 / d_ij
inv.dist <- lapply(dist.all, function(x) 1 / x)

# Optional variants:
# inv.dist2 <- lapply(dist_all, function(x) x^(-2))        # inverse squared distance
# exp.dist  <- lapply(dist_all, function(x) exp(-1.5 * x)) # exponential decay (lambda = 1.5)

# 5) Building a listw object using glist = custom weights
pov.inv.listw  <- nb2listw(pov.nb.all, glist = inv.dist)
pov.inv.listw

# ------------------------------------------------------------------------------
### 3.4.2 Shortcut: nb2listwdist() ----

# nb2listwdist() builds distance-decay weights directly.
# type options:
# - "idw"  : inverse distance
# - "exp"  : exponential decay
# - "dpd"  : double-power distance

inv.dist <- nb2listwdist(pov.nb.all, crds.sf,
                         type = "idw", style = "raw",
                         alpha = 1, dmax = NULL)

# dpd.dist <- nb2listwdist(pov.nb.all, crds.sf,
#                          type = "dpd", style = "raw",
#                          alpha = 0, dmax = 200)
# 
# exp.dist <- nb2listwdist(pov.nb.all, crds.sf,
#                          type = "exp",style = "raw",
#                          alpha = 0, dmax = NULL)

inv.dist

inv.dist.mat <- listw2mat(inv.dist) # convert from listw to matrix class

# map of weights for a given region – Warsaw, row 355
pov$inv.dist.WAW <- inv.dist.mat[,355] 
ggplot() + 
  geom_sf(data = pov, aes(fill = inv.dist.WAW)) +
  scale_fill_viridis_c(option = "viridis") +
  theme_minimal()


# ------------------------------------------------------------------------------
## 3.5 Spatial weights matrix for point data based on tesselation  ----

# IDEA:
# For point data, there are no borders, so "contiguity" is not naturally defined.
# Voronoi tessellation solves this by creating artificial polygons (tiles) around points:
# - each point becomes the "seed" of a polygon
# - every location inside a polygon is closer to its seed point than to any other point

# Once we have Voronoi polygons, we can define neighbours exactly like for regions:
# - two polygons are neighbours if they share a border (contiguity)
#
# This converts POINT DATA → POLYGON DATA → CONTIGUITY-based weights matrix.

# Why it’s useful:
# - works well for dense / irregular point patterns
# - avoids arbitrary distance thresholds
# - gives a polygon-style neighbourhood structure for points

# 1)  Install & load spatialWarsaw package
install.packages("devtools")      # if needed
devtools::install_github("poktam/spatialWarsaw")
library(spatialWarsaw)

# 2) Tesselation for selected number of points

# We need:
# points_sf    : POINT sf object (firms)
# region_sf    : boundary polygon within which tessellation is built (Lubelskie)
# sample_size  : number of points used (tessellation can be heavy for very large n)

# Sample points - 1000 observations
set.seed(123)
selector <- sample(1:dim(firms.sf)[1], 1000, replace = FALSE) # 1000 points
firms.sf.sub <- firms.sf[selector, ] # subset

# tessW() workflow (behind the scenes):
# 1) builds Voronoi polygons for the points within the boundary region
# 2) finds contiguity neighbours between Voronoi polygons (poly2nb)
# 3) converts to spatial weights matrix (nb2listw, usually style="W")

# Output is a listw object
my.tess <- spatialWarsaw::tessW(points_sf = firms.sf.sub,
                                region_sf = voi.lub,
                                sample_size = nrow(firms.sf.sub))

my.tess
summary(my.tess)


# Sample points - 30 observations
set.seed(123)
selector <- sample(1:dim(firms.sf)[1], 30, replace = FALSE) # 30 points
firms.sf.sub <- firms.sf[selector, ] # subset

my.tess <- spatialWarsaw::tessW(points_sf = firms.sf.sub,
                                region_sf = voi.lub,
                                sample_size = nrow(firms.sf.sub))

my.tess

################################################################################
# 4. Spatial lags 
################################################################################

# A spatial lag is a spatially weighted average of a variable.

# Interpretation:
# The lag tells us what happens in the neighbourhood of i,
# according to the chosen spatial weights matrix.

# In R:
# lag.listw(listw_object, variable)
# computes the spatial lag Wy.

# Spatial lag: (Wy)_i = sum_j w_ij * y_j

# ------------------------------------------------------------------------------
## 4.1 Regional perspective – diffusion and higher-order neighbourhoods  ----

# Spatial lags are often used to model diffusion:
# shocks, innovations, crises spreading across regions.

# Create a shock variable
pov$JPT_NAZWA_ # display the names of regions
pov$SHOCK <- rep(0,380) # new variable with 0 only
pov$SHOCK[pov$JPT_NAZWA_=="powiat Łódź"] <- 1    # Łódź labelled with 1
pov$SHOCK[pov$JPT_NAZWA_=="powiat Warszawa"] <- 1 # Warszawa labelled with 1
pov$SHOCK[pov$JPT_NAZWA_=="powiat Gdańsk"] <- 1   # Gdańsk labelled with 1
pov$SHOCK[pov$JPT_NAZWA_=="powiat Poznań"] <- 1   # Poznań labelled with 1

# Visualise shock centres
ggplot(data=pov) + 
  geom_sf(aes(fill=SHOCK)) + 
  scale_fill_viridis_c(option = "magma") + 
  labs(fill = "SHOCK") + theme_minimal() 

# Spatial lag (1st order neighbours)
# Wy = spatially weighted average of SHOCK in neighbouring regions

pov$lag1 <- lag.listw(cont.listw, pov$SHOCK)
summary(pov$lag1)

# Interpretation:
# lag1 > 0 means region is surrounded by shocked regions.
# With row-standardised W, lag1 is a local average.

# effect of the shock on nearby regions - 1st order neighbours
ggplot(data = pov) + 
  geom_sf(aes(fill = lag1)) + 
  scale_fill_viridis_c(option = "magma") + 
  labs(fill = "lag1") + theme_minimal()


# Higher-order neighbours = neighbours of neighbours

# Create 2nd order neighbour structure
poviats.2.list <- nblag(cont.nb, 2)
poviats.2.nb <- nblag_cumul(poviats.2.list)

# Compute 2nd order lag
pov$lag2 <- lag.listw(nb2listw(poviats.2.nb), pov$SHOCK)

ggplot(data = pov) + 
  geom_sf(aes(fill = lag2)) + 
  scale_fill_viridis_c(option = "magma") + 
  labs(fill="lag2") + theme_minimal() 

# Interpretation:
# lag2 shows indirect diffusion (via neighbours of neighbours).

# IMPORTANT:
# Higher-order lags show how influence propagates through the network.
# 1st order  → direct neighbours
# 2nd order  → neighbours of neighbours
# 3rd order  → further diffusion

# ------------------------------------------------------------------------------
## 4.2 Point perspective – micro-geographical context  ----

# For point data, spatial lags describe LOCAL CONTEXT.
# Example: average ROA of firms within 5 km.

# Create a subsample of 200 firms
set.seed(123)
pts.sub.sf <- slice_sample(firms.sf, n = 200, replace = FALSE) 

# Use projected CRS for distance in meters
pts.m <- st_transform(pts.sub.sf, 2180)
coords.m <- st_coordinates(pts.m)

# Define 5 km neighbourhood
radius <- 5000  # 5 km in meters
nb.d <- dnearneigh(coords.m, d1 = 0, d2 = radius)

# Create row-standardised weights
lw.d <- nb2listw(nb.d, style = "W", zero.policy = TRUE)

# Spatial lag = average ROA in 5 km neighbourhood
pts.m$roa_neigh_mean <- lag.listw(lw.d, pts.m$roa, zero.policy = TRUE)

# Number of neighbours (local density)
pts.m$n_neigh <- card(nb.d)
head(pts.m[, c("roa", "roa_neigh_mean", "n_neigh")])

# roa_neigh_mean = average ROA among firms within 5 km.

# This variable captures local economic context
# and can be used as an explanatory variable in models.

################################################################################
# 5. Surroundings of neighbourhoods of points - radial zoning
################################################################################

# Radial zoning = describe the LOCAL CONTEXT around each point using a fixed radius.
# Example question:
# "How many firms from sector M are located within 1 km of each firm?"

# Main idea:
# 1) create a circular buffer around every point (radius = r)
# 2) find which other points fall inside each buffer
# 3) summarise attributes of those neighbours (counts / averages / proportions)

# NOTE:
# We use a projected CRS (meters) to make "1 km" really mean 1000 m.

# Create a subset of points for Lublin city
border.Lublin <- pov[pov$JPT_NAZWA_=="powiat Lublin", ]
firms.Lublin <- st_filter(firms.sf, border.Lublin, .predicate = st_within)
firms.Lublin # around 5k firms

# Use projected CRS for distance in meters
firms.Lublin.m <- st_transform(firms.Lublin, 2180)

# Create buffers (circular polygons), distance in metres (1000 m = 1 km)
firms.buffer.1km <- st_buffer(firms.Lublin.m, dist = 1000) 
firms.buffer.1km

# For each buffer, return the IDs of firms that fall inside it
firms.within.1km <- st_intersects(firms.buffer.1km, firms.Lublin.m, sparse = TRUE)
firms.within.1km

# Plot for intuition
# pick first 10 buffers & 10 points 
buf10 <- firms.buffer.1km[1:10, ]
pts10 <- firms.Lublin.m[1:10, ]

ggplot() +
  geom_sf(data = border.Lublin, fill = NA) +
  geom_sf(data = buf10, fill = NA, linewidth = 0.6, color = "red") +
  geom_sf(data = firms.Lublin.m, shape = 21, fill = "black", color = "black", size = 0.3) +
  geom_sf(data = pts10, shape = 21, fill = "red", color = "black", size = 2) +
  theme_minimal() +
  coord_sf(expand = FALSE) +
  labs(title = "Selected buffers of 1 km")

# Example: count neighbouring firms from a given sector (self-excluded) ----

# Example for ONE firm (i = 1)
i <- 1
sect <- "M"

idx <- firms.within.1km[[i]]  # neighbours inside 1 km (including itself)
idx <- idx[idx != i]          # remove itself

# Count neighbours in sector M
sum(firms.Lublin$SEC_PKD7[idx] == sect)

# Create a new variable: number of sector-M neighbours within 1 km ----

sect <- "M"
col_name <- paste0("firms_around_", sect)

firms.Lublin[[col_name]] <- sapply(seq_len(nrow(firms.Lublin)), function(i) {
  idx <- firms.within.1km[[i]]
  idx <- idx[idx != i]  # self-exclusion (important!)
  sum(firms.Lublin$SEC_PKD7[idx] == sect)
})

# Result:
# firms_around_M = local concentration of sector M within 1 km of each firm
head(firms.Lublin)

# (Optional) Loop over all sectors ----

# This produces one column per sector:
# firms_around_A, firms_around_B, ... (depending on your data)

sectors <- sort(unique(firms.Lublin$SEC_PKD7))
for (sect in sectors) {
  col_name <- paste0("firms_around_", sect)
  firms.Lublin[[col_name]] <- sapply(seq_len(nrow(firms.Lublin)), function(i) {
    idx <- firms.within.1km[[i]]
    idx <- idx[idx != i]
    sum(firms.Lublin$SEC_PKD7[idx] == sect)
  })
}

head(firms.Lublin)

