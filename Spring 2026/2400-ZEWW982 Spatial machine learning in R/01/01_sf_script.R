################################################################################
# Spatial Machine Learning in R — Session 1
# Working with spatial data: sf foundations
# Dr Maria Kubara
#
################################################################################

# Setup

# install.packages("tidyverse")
# install.packages("sf")

library(tidyverse)
library(sf)

# setting the path to working directory
getwd()
#setwd()
Sys.setenv(LANG = "en") #show the error messages in English

#sf_use_s2(FALSE)  # keeps behaviour predictable for some operations (esp. in class)


################################################################################
#### Before we start: ##########################################################

### What is a pipeline operator %>% ? #####

# Functional programming is a commonly used standard in many programming 
# languages (eg. Java, C#, Python). It allows you to do many transformations 
# on one object in just one line. It is a useful convention that allows you to 
# save space and get a more readable code. In most cases it is done by adding 
# a dot to the name of the objects and after that the name of the function.

# Here is some example (for Python Pandas). 
# Imagine you have a dataset of students. You want to see the first 5 people
# sorted in an alphabetic order. You will do
# students.sort_values('name').head()
# In one step (one line) you have sorted the data and retrieved those
# interesting values. You could have done that without the function stacking,
# but that would take more lines and won't be as readable.

# In R it was the tidyverse project that introduced the style of 'functional 
# programming' with the usage of pipes (%>%). It is a useful tool to have
# and if you like it - you are highly encouraged to use it in your coding. 
# It allows you to send the resulting object from a previous operation to the
# next one, without the need to store them in temporary objects in the 
# partial stages.

# In the sf package you have the opportunity to use pipes. Sf datasets are
# build intact with the tidy data manifesto. Practically, this means they are
# well integrated with the methods in tidyverse packages (like dplyr – 
# for data cleaning). 

# I will use pipes in that tutorial to show you a different approach to 
# coding in R. Remember that you can always omit the pipes and stack the
# functions with the usual R way. 

# Those notations are equivalent:
# function3(function2(function1(object)))
# object %>% function1() %>% function2() %>% function3()



### Short side note about ggplot2: #####

# ggplot2 is a modern way to create advanced visualizations in R. It is based 
# on the rules of 'Grammar of Graphics'. It allows one to build a plot layer 
# by layer with different function calls. There are a lot of materials in the 
# Internet concerning that issue. Try:
# http://www.sthda.com/english/wiki/ggplot2-essentials 
# http://r-statistics.co/Complete-Ggplot2-Tutorial-Part1-With-R-Code.html 

# Brief introduction of the ggplot logic:

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point()

# Start by initializing the plot with ggplot() command. In that part you can 
# specify the features that will be shared for all your layers. We specify the
# data set and indicate which variables should be mapped where. Then we call the
# function of our choice, that will determine the type of the plot - for us this
# is a simple scatter plot. 

ggplot() + 
  geom_point(data = iris, aes(x = Sepal.Length, y = Sepal.Width))

# Another option to do the same, but in this case there is no shared knowledge
# for all plot layers. We specify the dataset and axis mapping at the micro level.

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point(color = 'blue')
# We can color our points with a given color

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point(aes(color = Species))

# We can also color them by a specific factor variable

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point(aes(color = Species)) + 
  labs(title = 'Simple iris visualisation', x = 'Sepal length', y = 'Sepal Width')

# We can add more elements to the plot with the + operator. Here we have added
# the main title and axis titles. 




################################################################################
#### Point data ################################################################

# We will start the exploration of sf package by the simplest sf data type -  
# spatial points. We will read them from the excel file

support <- read.csv("data/support_centres.csv")

# data set with the locations of support centers for start-ups in Warsaw
# additional information: if the center provides training, office space,
# networking opportunities, if it is built within academic structures

str(support)
head(support)

### Creating the first sf object

# We need to specify the columns that are responsible for the coordinates.
# That step is needed to create the geometry column in a proper way.

support.sf <- st_as_sf(support, coords = c("long", "lat"), 
                       crs = "+proj=longlat +datum=NAD83")

support.sf

# object includes 37 features - as we had 37 support centers locations
# for each feature we have specified 5 fields (attributes): ID, training,
# office, networking, academic. Additionally we have the geometry column.



# NOTE: transformation sf -> sp
# object.sp <- as(object.sf, "Spatial")

# NOTE: transformation sp -> sf
# object.sf <- st_as_sf(object.sp)



# We can easily convert it to the sp object
support.sp <- as(support.sf, "Spatial")

class(support.sp)
str(support.sp) # compare sp with sf
str(support.sf)

# We can extend the collection with a point of our choice. 

# We will start by creating a single spatial data point on our own. We will 
# firstly need some coordinates. We can retrieve them from google maps. 

# an arbitrary point chosen
# 52.1626901,20.8712145

library(data.table)
point <- data.table(
  X = 38,
  lat = 52.1588409,
  long = 20.9037899, 
  training = 0, 
  office = 0, 
  networking = 0, 
  academic = 0)

point.sf  <- st_as_sf(point, coords = c("long", "lat"), 
                      crs = "+proj=longlat +datum=NAD83") #longitude latitude

support.sf2 <- rbind(support.sf, point.sf)
support.sf2
# we have successfully added the new feature to the collection.

# Now we will plot our collection of points

# the general plot command prints the most basic plot of those points with 
# respect to their non-spatial attributes

plot(support.sf2)

# we can also plot a single attribute

plot(support.sf["networking"])

# Standard visualization methods in sf package are quite similar to the 
# usual base R plotting. You can learn more about that here: 
# https://r-spatial.github.io/sf/articles/sf5.html

# We will not go into much details with these commands. We will focus more on 
# the sf-ggplot2 integration and explore the possibilities the simple features
# give us. 


################################################################################
#### sf point visualization ####################################################

# As a short recap, we can build a simple a-spatial plot of our initial data.frame

ggplot(data = support, aes(x = long, y =lat)) + # just a scatter plot
  geom_point()

ggplot(data = support, aes(x = long, y =lat)) + # geographical visualisation
  geom_point(aes(color = networking))


# And now the same points can be better visualized with usage of sf object

# Why better? Because by using coordinate system and geometry column we are 
# actually tracing the projected coordinates (as they present themselves on a map)
# rather than just plot points, assuming the same distance between degrees as if 
# they were points. Observe the difference here:

#simplest plot

ggplot(data = support.sf2) + geom_sf()

ggplot() + geom_sf(support.sf2, mapping = aes(geometry=geometry))

# Those two function calls are equivalent in that particular case. First one
# may look simpler (it makes all the necessary assumptions about the geometry
# in the background), but it is important to remember the second one as well.
# It will come in handy when we will try to build more advanced plots with more
# layers.


# Again we have the opportunity to use ggplot features, e.g. coloring points 
# with respect to some variable

ggplot() + 
  geom_sf(support.sf2, mapping = aes(geometry=geometry, col = networking))



################################################################################
#### Exercise 1 ################################################################



# Read radom-tattoo.csv file which stores the information about tattoo studios 
# in Radom, Poland including the information whether they provide tattoos with 
# "lineart" technique (this information is randomly generated :))

# Read random-tattoo.csv file
tattoo <- read.csv("data/radom-tattoo.csv")

head(tattoo)

# 1. Create sf object which will store the information about those points
# We add 'crs = 4326' to define the coordinate system (WGS84)
tattoo.sf <- st_as_sf(tattoo, coords = c("long", "lat"), crs = 4326)

# 2. Create ggplot graphic with the points 
# Basic plotting using geom_sf()
ggplot(data = tattoo.sf) +
  geom_sf()

# 3. Adjust your graphic, coloring points with respect to the lineart variable
# Map the color to the 'lineart' column inside aes()
ggplot(data = tattoo.sf) +
  geom_sf(aes(color = lineart)) +
  labs(title = "Tattoo Studios in Radom", 
       subtitle = "Availability of Lineart Technique") +
  theme_minimal()

# 4. Additionally, you can modify the color palette :)
# Manual color adjustment (assuming values are "Yes"/"No" or similar)
ggplot(data = tattoo.sf) +
  geom_sf(aes(color = lineart), size = 3) +
  scale_color_manual(values = c("Yes" = "#9b5de5", "No" = "#00bbf9")) +
  theme_minimal() +
  labs(title = "Tattoo Studios in Radom", color = "Lineart?")

################################################################################
#### Line data #################################################################

# A LINESTRING is defined as an ordered sequence of points.
# In sf, a line is literally built from POINT coordinates connected by straight
# line segments.

# We'll create a few arbitrary points inside Warsaw that will define the line.
# Note: line coordinates must be provided in (x, y) order = (long, lat).

line1_coords <- matrix(
  c(20.90, 52.23,   # point 1 (long, lat)
    20.93, 52.25,   # point 2
    20.97, 52.27,   # point 3
    21.02, 52.29),  # point 4 
  ncol = 2,
  byrow = TRUE)

# Create a single LINESTRING geometry from those points
line1_sfg <- st_linestring(line1_coords)

# Wrap it into a geometry column (sfc) and attach CRS
line1_sfc <- st_sfc(line1_sfg, crs = "+proj=longlat +datum=NAD83")

# Create an sf object (a data.frame with geometry)
line1.sf <- st_sf(name = "Line 1",
                  type = "demo_route",
                  geometry = line1_sfc)

line1.sf
plot(line1.sf)  # basic plot


################################################################################
#### A collection of lines #####################################################

# Often we want multiple lines: e.g., two routes, two borders, two trajectories.
# There are two common ways:
#  (A) MULTILINESTRING = one feature that contains multiple lines
#  (B) sf with multiple rows, each row is a LINESTRING

# Let's create a second line (also inside Warsaw bbox)
line2_coords <- matrix(
  c(20.88, 52.16,
    20.91, 52.18,
    20.95, 52.20,
    20.99, 52.22),
  ncol = 2,
  byrow = TRUE)

line2_sfg <- st_linestring(line2_coords)

# (A) MULTILINESTRING: one geometry containing multiple lines
multi_sfg <- st_multilinestring(list(line1_coords, line2_coords))

multi.sf <- st_sf(
  name = "Two demo routes",
  geometry = st_sfc(multi_sfg, crs = "+proj=longlat +datum=NAD83")
)

multi.sf
plot(multi.sf)

# (B) Two separate LINESTRING features (recommended for most analyses)
lines.sf <- st_sf(name = c("Line 1", "Line 2"),
                  type = c("demo_route", "demo_route"),
  geometry = st_sfc(line1_sfg, line2_sfg, crs = "+proj=longlat +datum=NAD83"))

lines.sf
plot(lines.sf)


################################################################################
#### Visual intuition: "line = points connected by points" #####################
# Let's also create an sf POINT object with the vertices used to build the line.
# This makes the definition really visible: a line is just a set of points
# connected in order.

line1_vertices <- data.table(
  id = paste0("P", 1:nrow(line1_coords)),
  long = line1_coords[, 1],
  lat  = line1_coords[, 2]
)

line1_vertices.sf <- st_as_sf(
  line1_vertices,
  coords = c("long", "lat"),
  crs = "+proj=longlat +datum=NAD83"
)

# Plot: points (vertices) + the line built from them
ggplot() +
  geom_sf(data = line1.sf) +
  geom_sf(data = line1_vertices.sf, size = 2) +
  ggtitle("A LINESTRING is an ordered sequence of points")


################################################################################
#### Overlay with  support points ##############################################
# Now we can show the line together with your support centres:

ggplot() +
  geom_sf(data = support.sf2, aes(col = networking)) +
  geom_sf(data = lines.sf) +
  ggtitle("Support centres (points) + demo routes (lines)")




################################################################################
#### Polygon data ##############################################################

### Read shapefile directly to sf

#library(sf)
#library(tidyverse)

# Read shapefile directly to sf collection
#pov.sf <- st_read("powiaty.shp")
pov.sf <- st_read("data/powiaty.shp")
pov.sf <- st_transform(pov.sf, crs = "+proj=longlat +datum=NAD83") # changing CRS

# explore the new object
pov.sf
summary(pov.sf) 
class(pov.sf)
head(pov.sf, 10)



# Two ways of extracting the Warsaw poviat

# standard R
waw.pov.sf1 <- pov.sf[pov.sf$JPT_NAZWA_=='powiat Warszawa',]

# dplyr (tidyverse)
waw.pov.sf <- pov.sf %>% filter(JPT_NAZWA_=='powiat Warszawa') 

#you can do it also without the pipes
waw.pov.sf <- filter(pov.sf, JPT_NAZWA_=='powiat Warszawa')



################################################################################
#### sf polygon visualization ##################################################



# Plotting only the geometry of the object (only spatial attributes - border)

plot(st_geometry(waw.pov.sf))



# ggplot2 visualization - almost the same code works as or the point data :)

ggplot(waw.pov.sf) + geom_sf()
ggplot() + geom_sf(waw.pov.sf, mapping = aes(geometry=geometry)) 


# see how we can stack the map layers
ggplot() + geom_sf(waw.pov.sf, mapping = aes(geometry=geometry)) + # polygon
  geom_sf(lines.sf, mapping = aes(geometry=geometry), col = "blue") +  # lines
  geom_sf(support_sf, mapping = aes(geometry=geometry), col = "navyblue") # points


# beware the order of layers! -> one stack on top of the others (line gets hidden here)
ggplot() + 
  geom_sf(lines.sf, mapping = aes(geometry=geometry), col = "blue") +  # line
  geom_sf(waw.pov.sf, mapping = aes(geometry=geometry)) + # polygon
  geom_sf(support_sf, mapping = aes(geometry=geometry), col = "navyblue") # points



################################################################################
#### Adding attributes to the polygons #########################################

# We will add the unemployment rate to the list of attributes for our polygons
data <- read.table("data/data_nts4_2019.csv", sep=";", dec=",", header=TRUE)
summary(data)

# extract only the data that is of interest for us
data.unempl <- data[,c("ID_MAP", "XA21", "year")]
head(data.unempl)

# convert the data format from long to wide
data.unempl2 <- data.unempl %>% 
  pivot_wider(names_from = year, values_from = XA21, names_prefix = "unempl")
data.unempl2 %>% head()

# We will add the ID_MAP variable to the pov.sf object (utilizing the fact that 
# the data is already sorted). You can use different keys while merging - like 
# the poviat name or (shortened) GUS code. You just need a key that will
# uniquely match the polygon with its attribute. 

pov.sf$ID_MAP <- 1:380 

# merge two datasets by the appropriate key
pov.sf.merged <- merge(pov.sf, data.unempl2, by = "ID_MAP")
pov.sf.merged

# let's plot the newly obtained attributes
ggplot() +
  geom_sf(pov.sf.merged, mapping = aes(geometry=geometry, fill = unempl2012))

ggplot() +
  geom_sf(pov.sf.merged, mapping = aes(geometry=geometry, fill = unempl2012))+
  scale_fill_gradient(low = "yellow",  high = "red")



################################################################################
#### Exercise 2 ################################################################

# read shapefile regarding the voivodeships in Poland
# use additional option to fix the encoding in the file

voi.sf <- st_read("data/wojewodztwa.shp", options = "ENCODING=WINDOWS-1252")

# make appropriate transformation

# voi.sf <- st_transform(...)


# explore the object (structure and first rows)
str(voi.sf)


# check the levels of JPT_NAZWA_ variable (name variable of regions) - treat it as factor



# filter out only the mazowieckie region and save it as a separate object

# maz.voi.sf <- ...


#plot the outline of mazowieckie region

library(sf)
library(ggplot2)
library(dplyr) # Useful for filtering

# read shapefile regarding the voivodeships in Poland
# use additional option to fix the encoding in the file
voi.sf <- st_read("data/wojewodztwa.shp", options = "ENCODING=WINDOWS-1252")

# make appropriate transformation
# EPSG 2180 is the standard coordinate system for Poland (PUWG 1992)
voi.sf <- st_transform(voi.sf, crs = 2180)

# explore the object (structure and first rows)
str(voi.sf)
head(voi.sf)

# check the levels of JPT_NAZWA_ variable (name variable of regions) - treat it as factor
voi.sf$JPT_NAZWA_ <- as.factor(voi.sf$JPT_NAZWA_)
levels(voi.sf$JPT_NAZWA_)

]# filter out only the mazowieckie region and save it as a separate object
# Note: Check if the level is "mazowieckie" or "MAZOWIECKIE" (uppercase) in your data
maz.voi.sf <- subset(voi.sf, JPT_NAZWA_ == "mazowieckie") 

# Alternatively using dplyr:
# maz.voi.sf <- voi.sf %>% filter(JPT_NAZWA_ == "mazowieckie")

# plot the outline of mazowieckie region
ggplot(data = maz.voi.sf) +
  geom_sf() +
  labs(title = "Mazowieckie Voivodeship") +
  theme_minimal()



################################################################################
#### Geometrical operations  #####################################################

# Now we can play a little bit with the spatial properties of our objects.
# We will create additional polygon of poviat pruszkowski (neighbor of Warsaw).

waw.pov.sf <- pov.sf %>% filter(JPT_NAZWA_=='powiat Warszawa')
pru.pov.sf <- pov.sf %>% filter(JPT_NAZWA_=='powiat pruszkowski' ) 

pru.pov.sf

ggplot() + 
  geom_sf(waw.pov.sf, mapping = aes(geometry=geometry), col = 'blue') + 
  geom_sf(pru.pov.sf, mapping = aes(geometry=geometry), col = 'red')

ggplot() + 
  geom_sf(waw.pov.sf, mapping = aes(geometry=geometry), col = 'blue') + 
  geom_sf(pru.pov.sf, mapping = aes(geometry=geometry), col = 'red') +
  annotate("text", x = 21.05, y = 52.25, label = "poviat Warszawa") +
  annotate("text", x = 20.8, y = 52.15, label = "poviat pruszkowski")



### Merging polygons

wawpru.separated <- rbind(waw.pov.sf, pru.pov.sf) 
wawpru.separated 

#two multipolygons
ggplot(wawpru.separated) + geom_sf()

wawpru.union <- st_union(waw.pov.sf, pru.pov.sf)
wawpru.union

#one multipolygon with larger area
ggplot(wawpru.union) + geom_sf()



### Creating a buffer (smoothed margin) around the polygon

sf_use_s2(TRUE) # calculate projected distance - in meters

waw.buffer <- st_buffer(waw.pov.sf, dist = 200) #distance in meters

ggplot() + 
  geom_sf(waw.buffer, mapping = aes(geometry=geometry, col = 'buffer') )+
  geom_sf(waw.pov.sf, mapping = aes(geometry=geometry, col = 'poviat') ) +
  scale_colour_manual("Region plot", 
                      values = c("red", "blue"), 
                      labels = c('Buffer', 'Warsaw poviat'))+
  theme(legend.position="right")



### Get the centroids
pov.sf.centr <- st_centroid(pov.sf)
st_is_valid(pov.sf)
st_is_valid(pov.sf)[54]
pov.sf[54,]

pov.sf.centr <- st_centroid(st_make_valid(pov.sf))

ggplot()+
  geom_sf(pov.sf, mapping = aes(geometry=geometry))+
  #small addition - custom color for Warsaw poviat
  geom_sf(pov.sf %>% filter(JPT_NAZWA_ =='powiat Warszawa'), 
          mapping = aes(geometry=geometry), fill = "pink")+
  geom_sf(pov.sf.centr, mapping = aes(geometry=geometry))

#Remember to add the layers in an appropriate order:

ggplot()+
  geom_sf(pov.sf, mapping = aes(geometry=geometry))+
  geom_sf(pov.sf.centr, mapping = aes(geometry=geometry))+
  #small addition - custom color for Warsaw poviat
  geom_sf(pov.sf %>% filter(JPT_NAZWA_ =='powiat Warszawa'), 
          mapping = aes(geometry=geometry), fill = "pink")

#why don't we have the centroid for the Warsaw poviat in the 2nd plot?



################################################################################
#### Exercise 3 ################################################################

# Let's prepare three separate objects: 
radom.sf <- pov.sf %>% filter(JPT_NAZWA_ =='powiat Radom')
radomski.sf <- pov.sf %>% filter(JPT_NAZWA_ =='powiat radomski')
przysuski.sf <- pov.sf %>% filter(JPT_NAZWA_ =='powiat przysuski')

# Prepare graphics which will start with the mazowieckie voivodeship.
# On top of the mazowieckie layer plot the objects prepared in the previous lines
# Try to recognize where those regions are located (you may use colors)



# Merge przysuski.sf and radomski.sf into one polygon

# radprzy.union <- ...


# Prepare another visualization which will start with the previously prepared 
# object. Plot radom.sf object on top of it. Color the regions with different colors.




# Create an object which will store polygons radom.sf, radomski.sf and przysuski.sf
# as three separate elements. Use this new object to create a map, which will have
# a legend storing the names of regions (JPT_NAZWA_ variable). Change the color 
# scheme of the plot

# threePoly <- ...



################################################################################
#### Geometrical operations part 2 #############################################



### Check if two polygons intersect

#Warsaw poviat and poviat pruszkowski
st_intersects(waw.pov.sf, pru.pov.sf)

#they do intersect - the common the border

#Warsaw poviat and Lublin poviat (in a differen voivodeship)
st_intersects(waw.pov.sf, pov.sf %>% filter(JPT_NAZWA_=='powiat Lublin' ))

#no intersection (list is empty)

#Warsaw poviat and its buffered area
st_intersects(waw.buffer, waw.pov.sf)

# True - they are intersected.



### Calculate the true intersection of two geometries

# Be aware of the differences between st_intersect and st_intersection. First 
# one returns only a logical argument about whether those two geometries 
# intersects or not. The second one returns the common space for two geometries
# - as a result you have a new sf object that stores the intersected fragments
# of those geometries. That operation might take longer - it needs to prepare 
# a whole new object rather than simply return a logical indicator. 

#intersected area
without.buffer <- st_intersection(waw.pov.sf, waw.buffer)
ggplot(without.buffer) + geom_sf(fill = 'navyblue') + 
  labs(title = "common area")

#disjoint area
only.buffer <- st_difference(waw.buffer, waw.pov.sf)
ggplot(only.buffer) + geom_sf(fill = 'navyblue') + 
  labs(title = "disjoint area")



### Manipulating with points 
# Check if points are within a polygon 

st_within(support.sf2, waw.pov.sf) #result in sparse matrix
st_within(support.sf2, waw.pov.sf, sparse = F) #result in a regular matrix

# as we can see the last point is outside of the Warsaw borders

# Get the object with the actual list of points inside of the Warsaw poviat
# first option with dplyr

dplyrInWaw <- support.sf2 %>% 
  filter(st_within(support.sf2, waw.pov.sf, sparse = F))

dplyrInWaw

# one feature less - our made-up point was dropped

#second option with st_intersection

supportInWaw <- st_intersection(waw.pov.sf, support.sf2)

supportInWaw

# What is the difference between those two? In the first one we only filter the
# initial object with some logical condition. We have the original table with 
# points narrowed down to the elements inside of Warsaw. In the second one the
# function is joining two datasets - we have more features for the points –
# they are taken from the features of polygon that the point is assigned in. 

# For larger datasets it is important to remember, that the logical filtering 
# will be less resource- and time-consuming than creating a join with the usage 
# of st_intersection().

supportInPru <- st_intersection(pru.pov.sf, support.sf2)
supportInPru
# only one feature there



### Two-layered graph with polygon and points plotted

#initial point collection
ggplot() + 
  geom_sf(waw.pov.sf, mapping = aes(geometry=geometry)) +
  geom_sf(support.sf2 , mapping = aes(geometry=geometry))

#points narrowed down to those in Warsaw
ggplot() + 
  geom_sf(waw.pov.sf, mapping = aes(geometry=geometry)) +
  geom_sf(supportInWaw , mapping = aes(geometry=geometry))

ggplot() + 
  geom_sf(waw.pov.sf, mapping = aes(geometry=geometry)) +
  geom_sf(dplyrInWaw , mapping = aes(geometry=geometry))



### Calculate distances between points

library(lwgeom) #additional dependency

st_distance(support.sf[1:5,],support.sf[1:5,])

################################
# more on the topic of Geometrical Operations: 
# https://r-spatial.github.io/sf/articles/sf3.html 



################################################################################
#### Exercise 4 ################################################################

# Check whether tattoo.sf points are within the radomski.sf object. Get a 
# new object which will store the points found in radomski.sf

# tattoo.radomski <- ...

# Check whether tattoo.sf points are within the radom.sf object. Get a 
# new object which will store the points found in radom.sf

# tattoo.radom <- ...

# What is the distribution of points? Prepare a visualization which will show 
# how the points from tatto.sf are located with respect to radomski.sf and radom.sf regions




################################################################################
#### Exercise 5 ################################################################

# Prepare an object which will store the poviats from the mazowieckie voivodeship only. 
# Plot a map which will show the poviats located in the mazowieckie voivodeship. 
# Try two methods: st_intersection and filtering with st_within. Compare their results
# with visualization. Which method gives better results? Why it might be the case?

# with intersection method:

# maz.pov <- ...


# with filtering method:

#maz.pov2 <- ...


# Using the better method (in this case) get the limited object with poviats 
# from mazowieckie region only. This time use the pov.sf.merged object in order to 
# get additional features. Plot the map to see if it is the same as in the previous step.

# maz.pov.merged <- ...



# Prepare a map with the unempl2008 values for the mazowieckie region on a poviat level.
# Adjust the color scheme and improve the names on the plot.


################################################################################
#### sf vs sp (necessary conversions) ##########################################
# We do NOT learn sp, but you may see it in older packages/papers.
# Conversion is sometimes needed for legacy functions (especially for econometric calculations).

# install.packages("sp")

library(sp)

# conversion to sp
support_sp <- as(support_sf2, "Spatial")
class(support_sp)

support_sp

# conversion back to sf
support_sf_again <- st_as_sf(support_sp)

# check if both objects the same
all.equal(st_as_text(st_geometry(support_sf2)),
          st_as_text(st_geometry(support_sf_again)))


