################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 9 ###########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Preparing for graphics creation ############################################

# Reading the data
getwd() # is the path set right?
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation") # change if necessary

life <- read.csv("data/dataset - life expectancy/Life Expectancy Data.csv")
head(life)


# set with observations regarding Poland
lifePL <- subset(life, Country == "Poland")
head(lifePL)

# overview of the whole dataset
View(lifePL)


# set with observations regarding Poland and Germany
lifePLDE <- subset(life, Country == "Poland" | Country == "Germany")
head(lifePLDE)

View(lifePLDE)



### Editing the graph ##########################################################

# Adding layers - step by step method


### 1st plot
# First layer - life expectancly plot in Poland
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"])



### 2nd plot
# Adding a second layer - plot with life expectancy in Germany 

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"])
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"])



### 3rd plot
# Improving the range so that the line is visible 
# we need to change the first/original plot, as it dictates
# what happens in the plotting window

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90))
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"])



### 4th plot
# Changing the plot type to lines and changing the line styling

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)



### 5th plot
# Adding a legend

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))



### 6th plot
# Chaning the axis titles

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))



### 7th plot 
# Adding a title

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))
title("Life expectancy in Poland and in Germany")



### 8th plot 
# Adding a vertical line
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))
title("Life expectancy in Poland and in Germany")
abline(v = 2004)



### 9th plot
# Line modification and adding a text note
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))



### 10th plot
# Adding an arrow
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")



### 11th plot
# Changing the line colour

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, col = "mediumpurple3")
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3")) 
       #zmiana kolorów również w legendzie
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")



### 12th plot
# Changing the line thickness

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =c(2)) 
       #changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")



### 13th plot
# Adding a point

max(lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"]) #89
lifePLDE[lifePLDE$Life.expectancy==89,"Year"] #2014

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
       #changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23)



### 14th plot
# Changing the features of the point

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
       #changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23, col = "blue4", bg = "blue2", cex = 2)



### 15th plot
# Changing the rotation of axis labels 

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2, las = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
       #changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23, col = "blue4", bg = "blue2", cex = 2)


### 16th plot
# Changing the style of lables and their placing (align to left)

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2, las = 2,
     font.lab = 3, adj = 0)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
       #changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23, col = "blue4", bg = "blue2", cex = 2)



### Exporting the plot #########################################################

# In RStudio -> export button, in the header of the graphics area


# With functions: 

# 1. Creating the file for saving
jpeg("Life expectancy plot", width = 765, height = 555)

# Possible file extentions:
# pdf(“rplot.pdf”): file pdf
# png(“rplot.png”): file png
# jpeg(“rplot.jpg”): file jpeg
# postscript(“rplot.ps”): file postscript 
# bmp(“rplot.bmp”): file bmp (bitmap) 
# win.metafile(“rplot.wmf”): windows metafile


# 2. Creating the graphics
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2, las = 2,
     font.lab = 3, adj = 0)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
       #changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23, col = "blue4", bg = "blue2", cex = 2)

# 3. Closing the file
dev.off()

# Source: http://www.sthda.com/english/wiki/creating-and-saving-graphs-r-base-graphs



### Using colour palettes in R #################################################

barplot(1:10, col = "blue")


# Built-in palettes
paletteRainbow <- rainbow(10)

barplot(1:10, col = paletteRainbow)

barplot(1:10, col = terrain.colours(3)) # shorter vector of colours will be reused (recycling rule!)



# palette virdis
#install.packages("viridis")
library("viridis")

barplot(1:10, col = viridis(5)) 
legend("topleft", legend = c(1:10), fill = viridis(5)) 

barplot(1:10, col = viridis(10)) 
legend("topleft", legend = c(1:10), fill = viridis(10)) # using the palette in legend


# palette Wesanderson
#install.packages("wesanderson")
library(wesanderson)

barplot(1:10, col = wes_palette("Royal2", 5, type = c("discrete"))) 
# consecutive colours from a palette - reused, twice

barplot(1:10, col = wes_palette("Royal2", 10, type = c("continuous"))) 
# colour gradient between colours of the original paletter


# palette RcolourBrewer
#install.packages("RColorBrewer")
library(RColorBrewer)

display.brewer.all(colourblindFriendly = TRUE)

paletteBrewer1 <- brewer.pal(n = 10, name = "Set2")
# impossible - to little colours in the palette

paletteBrewer <- brewer.pal(n = 10, name = "Paired")
# choosing a longer palette 

barplot(1:10, col = paletteBrewer)


# If we need more colours it's better to choose continuous palettes 
# like viridis or wesanderson 



### Modification of the plotting field #########################################

# Plotting plots next to each other 

par(mfrow = c(1, 2)) # one row, two columns (like in matrix indexing) 
barplot(1:5)
plot(1:10)

# adding a common title 
barplot(1:5)
plot(1:10)
mtext("Two plots with one title", outer = TRUE)

# The title is invisible so far - we need to change the plot margins 
# and increase the margin above the text 
par(mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
barplot(1:5)
plot(1:10)
mtext("Two plots with one title", outer = TRUE)


# Changing the layout
par(mfrow = c(2, 1)) # two rows, one column
barplot(1:5)
plot(1:10)


# Resetting to the default parameters - one plot per window
par(mfrow = c(1,1))

# or -> (in R Studio) - resetting the graphical environment
dev.off() # helpful if there are some issues with resetting the default parameters

barplot(1:5)



### Tasks ######################################################################

# --- Task 1: USArrests ---

# Load the required library
library(wesanderson) 

# 1d) Set up the environment for side-by-side plots (1 row, 2 columns)
par(mfrow = c(1, 2)) 

# 1a & 1b) Histogram of Murder with Zissou1 palette (continuous 10 colors)
hist(USArrests$Murder, 
     main = "Murder Arrests",
     xlab = "Arrests per 100,000",
     # generating 10 continuous colors from Zissou1
     col = wes_palette("Zissou1", 10, type = "continuous"))

# 1c) Histogram of Rape with Moonrise1 palette (discrete 4 colors)
# The recycling rule will apply here (4 colors repeated across the bins)
hist(USArrests$Rape,
     main = "Rape Arrests",
     xlab = "Arrests per 100,000",
     # generating 4 discrete colors
     col = wes_palette("Moonrise1", 4, type = "discrete"))

# 1f) Reset the graphical environment
par(mfrow = c(1, 1))

# --- Task 2: Insurance Data ---

setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation") # change if necessary

# 2a) Load data and convert to factors
# (Make sure the file path is correct for your computer)
insurance <- read.csv("data/graphics - medical cost/insurance.csv") 

# Converting variables to factor
insurance$sex <- as.factor(insurance$sex)
insurance$smoker <- as.factor(insurance$smoker)
insurance$region <- as.factor(insurance$region)

# 2b & 2c) Boxplot of charges by region with Viridis colors
library(viridis)

# We need 4 colors because there are 4 regions
region_colors <- viridis(4)

boxplot(charges ~ region, 
        data = insurance,
        main = "Insurance Charges by Region",
        xlab = "Region",
        ylab = "Medical charges",
        col = region_colors)

# 2d) Adding the legend
# We use levels(insurance$region) to get the names automatically.
legend("topright", 
       legend = levels(insurance$region), 
       fill = region_colors, 
       title = "Region")

# --- Task 3: Tokyo 2021 Olympics ---

# 3a) Load the dataset
# Setting the working directory to the folder you specified
setwd("/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/graphics - olympic games 2021")

# Reading the file (assuming the standard filename from the course materials)
games <- read.csv("Tokyo 2021 dataset.csv")

# 3b) Create "silver10" sorted and subsetted in ONE line
# Sorting by Silver Medal (decreasing) and taking the first 10 rows
silver10 <- games[order(games$Silver.Medal, decreasing = TRUE), ][1:10, ]

# 3c, 3d, 3e, 3f) Create and Export the Plot

# 1. Open the file device with your Student ID
png("477001.png", width = 800, height = 600)

# 2. Create the graphics
# Using the viridis palette for a nice look, as seen in the lecture
library(viridis)

barplot(silver10$Silver.Medal,
        names.arg = silver10$NOCCode,       # 3d: Labels from NOCCode
        main = "Top 10 silver medals",      # 3e: Title
        ylab = "Number of Silver Medals",   # 3f: Axis title
        col = viridis(10),                  # 3f: Interesting color palette
        las = 2,                            # 3f: Rotated labels (vertical)
        cex.names = 0.9,                    # Adjust label size
        font.lab = 2)                       # 3f: Bold axis labels

# 3. Close the file to save it
dev.off()
