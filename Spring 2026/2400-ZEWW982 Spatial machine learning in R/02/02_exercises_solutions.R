# ------------------------------------------------------------------------------
# Exercise 1 
# ------------------------------------------------------------------------------

# Calculate number of firms per sector in each of the grids in Lubelskie 
# (SEC_agri variable), use already created objects: grid.lub.2 & firms.joined 

# 1. Count firms by polygon and sector (type)
# Hint: group by JPT_NAZWA_ & SEC_agg

firms.by.sector <- firms.joined.grid %>% 
  st_drop_geometry() %>%
  group_by(grid_ID, SEC_agg) %>%
  summarise(n = n(), .groups = "drop")
firms.by.sector

# 2. Covert from long to wide format

firms.by.sector.wide <- firms.by.sector %>%
  pivot_wider(names_from = SEC_agg,
              values_from = n,
              values_fill = 0)
firms.by.sector.wide

# 3. Merge to polygons (poviats), replace NA's wth 0's and calculate share of
# agriculture firms (agri) in grid
grid.lub.3 <- grid.lub.2 %>%
  left_join(firms.by.sector.wide, by = "grid_ID") %>% 
  mutate(agri = replace_na(agri, 0), 
         serv = replace_na(serv, 0),
         constr = replace_na(constr, 0), 
         prod = replace_na(prod, 0)) %>% 
  mutate(share_agri = if_else(n_firms > 0, agri / n_firms, 0))
grid.lub.3

# 4. Visualise share of agriculture firms in grids and try to play with the color
# palette and ordering
ggplot(grid.lub.3) +
  geom_sf(aes(fill = share_agri),
          color = "grey70",
          linewidth = 0.1) +
  scale_fill_viridis_c(option = "A", direction = -1, labels = scales::percent) +
  theme_minimal() +
  labs(title = "Share of agriculture firms per grid",
       fill = "")
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Exercise 2
# ------------------------------------------------------------------------------

# Create a raster for poviat Chełm in Lubelskie in projected crs for Poland 
# (crs = 2180), where you will represent the number of firms

# 1. Create the separate object for poviat Chełm
# (filter it out of object pov by selecting JPT_KOD_JE == "0662")

pov.chelm <- pov %>% filter(JPT_KOD_JE == "0662")
pov.chelm

# 2. Filter out firms that are located in that poviat

firms.chelm <- st_filter(firms.sf, pov.chelm, .predicate = st_intersects)
firms.chelm

# 3. Change the projection for both object to crs = 2180

pov.chelm.pl <- st_transform(pov.chelm, crs = 2180)
firms.chelm.pl <- st_transform(firms.chelm, crs = 2180)

pov.chelm.pl
firms.chelm.pl

# 4. Prepare inputs for rasterization (coordinates + bounding box)

xy.chelm <- st_coordinates(firms.chelm.pl)

bb.chelm <- st_bbox(pov.chelm.pl)

# 5. Create an empty raster template over poviat Chełm
# Hint 1: In EPSG:2180, units are meters, so you can define:
# - either nrows/ncols (e.g., 50 x 50 - nrows = 50, ncols = 50) OR
# - resolution in meters (e.g., 1500 m cells - resolution = 1500)

# Option A (same as Lublin example): fixed number of rows/cols
rast.chelm.temp.A <- rast(nrows = 50, ncols = 50,
                        xmin = bb.chelm["xmin"], xmax = bb.chelm["xmax"],
                        ymin = bb.chelm["ymin"], ymax = bb.chelm["ymax"],
                        crs  = st_crs(pov.chelm.pl)$wkt)

# Option B (recommended for projected CRS): fixed cell size (e.g. 500 m)
rast.chelm.temp.B <- rast(xmin = bb.chelm["xmin"], xmax = bb.chelm["xmax"],
                        ymin = bb.chelm["ymin"], ymax = bb.chelm["ymax"],
                        resolution = 500,   
                        crs = st_crs(pov.chelm.pl)$wkt)

# 6. Rasterize: count firms per cell
# Hint 2: Create a vector of ones  firms.chelm.pl$ones <- 1 OR instead use fun = length
firms.chelm.pl$ones <- 1
r.chelm <- rasterize(xy.chelm, rast.chelm.temp.A, firms.chelm.pl$ones, fun = sum, background = 0)
#OR
r.chelm <- rasterize(xy.chelm, rast.chelm.temp.B, fun = "length", background = 0)

# 7. Plot raster + boundary 
# Hint 3: Use plot() for terra rasters, then add polygon outline with add=TRUE
plot(r.chelm, main = "Firms per raster cell (poviat Chełm, EPSG:2180)")
plot(st_geometry(pov.chelm.pl), add = TRUE)
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

