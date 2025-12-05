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
#setwd() # change if necessary

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

# 1. a) Using USArrests data (built-in dataset) draw a histogram to show the 
# distribution of the Murder variable.
# b) Select the Zissou1 palette from wesanderson and use a vector of 10 continuous 
# colours from this set to change the colour of the histogram bars.
# When submitting the answer you can assume that the package is already loaded.
# c) Create a histogram for the Rape variable and color the bins with Moonrise1
# palette - discrete colours, vector with 4 colours, that will be reused in the plot.
# d) Change the graphical environment settings (two columns, one row)
# e) Draw the two graphs side by side. 
# f) reset the graphical environment

# 2. a) Load the insurance.csv dataset into R (medical cost folder) and name it 
# insurance. Check if data is properly loaded and the types of variables are correct.
# Convert sex, smoker and region variables into factor type.
# b) Prepare a boxplot of the variable charges by region. Change the axis 
# titles to "Medical charges" and "Region"
# c) Change the colour of the 'boxes' according to the region and add an 
# appropriate legend. Use a palette viridis with 4 discrete colors. You can assume
# that the viridis package is loaded when submitting the answer.
# d) Create a legend in the topright corner of the plot. Name the elements exactly
# as the names of the categories are shown in your plot. Hint: you can use the levels()
# function to get the names automatically.
# Make sure that the colours of your legend match the colours of the boxes.
# When submitting the answer provide just the line of code with legend creation.

# 3. a) Load the Tokyo 2021 dataset dataset from the olympic games folder 
# and store it in the games variable.
# b) We will prepare a bar chart showing, in sequence, the ten countries that 
# have won the most silver Olympic medals. Start by creating a new dataset "silver10"
# that will store the 10 countries that have won the most Silver medals,
# and order that dataset by the Silver.Medal variable in decreasing order. First
# create a dataset sorted by the Silver Medal variable, and then limit it 
# to the first 10 observations only. Try to combine these steps and to this
# operation in one line only. Submit the shortest code that works for you.
# c) Using function barplot prepare a plot for the Silver Medal variable.
# d) Add lables under the bars (check the names.arg parameter in the barplot function)
# For the labels use the values of NOCCode function.
# e) Add title "Top 10 silver medals".
# f) Modify the style of the text, change the axis title. Add a chosen colour 
# palette and make the plot more interesting. Play with modification of different 
# plot elements. Export your plot to png file and name it by your 
# student ID number. Submit that plot to the test :)

