################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 8 ###########################################
################################################################################

# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Preparing for graphics creation ############################################

# Reading the data
getwd() # is the path set right?
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation") # change if necessary
getwd()
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


LifePLDE <- subset(life, Country == "Poland" | Country == "Germany")
View(lifePLDE)



### Graphics with plot function ################################################

?plot
plot(lifePL$Life.expectancy) # point plot, subsequent values of the variable

lifePL[,c("Year", "Life.expectancy")] # year - descending

plot(x = lifePL$Year, y = lifePL$Life.expectancy) # year - ascending


# line plot
plot(lifePL$Year, lifePL$Life.expectancy, type = "l") 


# line plot with points
plot(lifePL$Year, lifePL$Life.expectancy, type = "b") 


# step plot
plot(lifePL$Year, lifePL$Life.expectancy, type = "s") 


# changing the range of x variable  
plot(lifePL$Year, lifePL$Life.expectancy, type = "b", xlim = c(2005, 2010)) 


# changing the range of x and y (zooming the plot) 
plot(lifePL$Year, lifePL$Life.expectancy, type = "b", 
     xlim = c(2005, 2010), ylim = c(75, 76.5)) 



### GDP plot - modifying the plot details ######################################

plot(lifePL$Year, lifePL$GDP, type = "b")

# adding a title
plot(lifePL$Year, lifePL$GDP, type = "b", main = "GDP in Poland")


# using logarithmic transformation of y variable 
plot(lifePL$Year, lifePL$GDP, type = "b", log = "y") 
plot(lifePL$Year, log(lifePL$GDP), type = "b") # second version


# adding a title and subtitle
plot(lifePL$Year, lifePL$GDP, type = "b", log = "y", main = "GDP in Poland", 
     sub = "GDP values are log-transformed") 


# adding the axis titles
plot(lifePL$Year, lifePL$GDP, type = "b", log = "y", main = "GDP in Poland", 
     sub = "GDP values are log-transformed",
     xlab = "Year", ylab = "log GDP") 



### Density plot ###############################################################

density(lifePL$Life.expectancy)
plot(density(lifePL$Life.expectancy))



### Bar plot ###################################################################

barplot(lifePL$Life.expectancy)
barplot(lifePL$Life.expectancy, ylim = c(0, 80))
barplot(lifePL$Life.expectancy, ylim = c(0, 80), 
        col = "aquamarine") #changing colors



### Histogram ##################################################################
?hist()

hist(lifePL$Life.expectancy) # frequency representation
hist(lifePL$Life.expectancy, freq = TRUE)  

hist(lifePL$Life.expectancy, 
     freq = FALSE) # probability representation (area of histogram = 1)

hist(lifePL$Life.expectancy, breaks = c(50, 60, 70, 80, 90))
hist(lifePL$Life.expectancy, breaks = seq(70,80, 2))


# function lines allows to add new lines to the plot 
# function points is for adding points

# histogram and density plot combined
hist(lifePL$Life.expectancy, freq = TRUE)
lines(density(lifePL$Life.expectancy)) 
# unmatched scale - we need to compare the same units 

# correction - comparing probabilities 
hist(lifePL$Life.expectancy, freq = FALSE)
lines(density(lifePL$Life.expectancy))

# changing the scale of the plot
hist(lifePL$Life.expectancy, freq = FALSE, breaks = seq(70,80, 1))
lines(density(lifePL$Life.expectancy))



### Box plot ###################################################################

summary(lifePLDE$Life.expectancy)

boxplot(lifePLDE$Life.expectancy)



### Summarizing data with group comparison #####################################

boxplot(lifePLDE$Life.expectancy ~ lifePLDE$Country)

boxplot(lifePLDE$Life.expectancy ~ lifePLDE$Country, names = c("DE", "PL")) # labels for groups

boxplot(lifePLDE$Life.expectancy ~ lifePLDE$Country, names = c("Germany", "Poland"),
        xlab = "Country", ylab = "Life expectancy", 
        main = "Comparison of life expectancy in Poland and in Germany",
        sub = "Values for 2000-2015")


boxplot(lifePLDE$Life.expectancy ~ lifePLDE$Country, names = c("Germany", "Poland"),
        xlab = "Country", ylab = "Life expectancy", 
        main = "Comparison of life expectancy in Poland and in Germany",
        sub = "Values for 2000-2015", 
        col = "lightgreen") # color change



### Violin plot ################################################################

#install.packages("vioplot")
library(vioplot)

vioplot(lifePLDE$Life.expectancy)

vioplot(lifePLDE$Life.expectancy ~ lifePLDE$Country) # syntax like in boxplot

vioplot(lifePLDE$Life.expectancy ~ lifePLDE$Country,
        col = "lightgray")



### Dotchart - identification of the outliers ##################################

dotchart(lifePL$Life.expectancy)

dotchart(lifePL$BMI) # identification of the outlier

# Division into groups (grouping variable must be a factor) 
dotchart(lifePLDE$BMI, groups = factor(lifePLDE$Country))




### Investigating the relations between variables ############################## 

plot(lifePL)

str(lifePL)

pairs(lifePL[, c("Life.expectancy", "GDP", "Population", "Schooling")])
names(lifePL)

pairs(lifePL[, c(4,17:18, 22)])

pairs(lifePL[, c(4,17:18, 22)], panel = panel.smooth)



### Correlation plot ###########################################################

install.packages("PerformanceAnalytics")
library("PerformanceAnalytics")
chart.Correlation(lifePL[, c(4,17:18, 22)], histogram = TRUE, pch = 19)

install.packages("corrplot")
library(corrplot)

#corrplot(lifePL[, c(4,17:18, 22)], type = "upper", order = "hclust")

corrplot(cor(lifePL[, c(4,17:18, 22)]))
corrplot(cor(lifePL[, c(4,17:18, 22)]), type = "lower", order = "hclust")
corrplot(cor(lifePL[, c(4,17:18, 22)]), type = "upper", order = "hclust",
         method = "number", add = TRUE)

?corrplot.mixed
corrplot.mixed(cor(lifePL[, c(4,17:18, 22)]), upper = "number", 
               lower = "circle", order = "alphabet")


### Additional resources #######################################################

# https://rstudio-pubs-static.s3.amazonaws.com/84527_6b8334fd3d9348579681b24d156e7e9d.html

# https://ramnathv.github.io/pycon2014-r/visualize/base_graphics.html

# https://statsandr.com/blog/descriptive-statistics-in-r/#mosaic-plot



### Tasks ######################################################################

# 1. a) Using USArrests data (built-in dataset) draw a histogram to show the 
# distribution of the Assault variable.
# b) Add labels above the bins (check the documentation)
# c) Add a title "USA assault distribution" to the plot created in point 1a).

# 1a
hist(USArrests$Assault)

# 1b 
hist(USArrests$Assault,labels=TRUE)

# 1c
hist(USArrests$Assault,main="USA assault distribution", labels=TRUE)

# Or

hist(USArrests$Assault, 
     labels = TRUE, 
     main = "USA assault distribution")

# 2. a) Load the insurance.csv dataset into R (medical cost folder) and name it 
# insurance. Check if data is properly loaded and the types of variables are correct.
# b) Convert sex variable into factor type.
# c) Do the same to the smoker and region variables.
insurance <- read.csv("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/graphics - medical cost personal dataset/insurance.csv") # Adjust path if necessary
head(insurance)
str(insurance)

# 2b. Convert sex to factor
insurance$sex <- as.factor(insurance$sex)

# 2c. Convert smoker and region to factor
insurance$smoker <- as.factor(insurance$smoker)
insurance$region <- as.factor(insurance$region)

# Verify the changes (types should now say 'Factor')
str(insurance)

# 3. a) Using the insurance dataset prepare a correlation graph between age, 
# bmi and charges. When calling the columns use the indexing by column names. 
# Make it so that your graph is created by only one line of code. Use the 
# default parameters of corrplot function (don't change anything yet).
# Hint: use the corrplot() function from the corrplot package. You can assume
# that corrplot package in loaded in R.
# Hint 2: remember to draw the graph from the correlation table 
#made with the cor() function.

library(corrplot)
corrplot(cor(insurance[, c("age", "bmi", "charges")]))

# b) Arrange the variables on the graph using the order given by hierarchical
# clustering algorithm (hclust).

corrplot(cor(insurance[, c("age", "bmi", "charges")]), order = "hclust")

# c) Modify the plot that was created in b). Change the area of the graph so 
# that the lower triangle shows the numerical values and the upper triangle 
# shows the representation using circles. 
# Hint: look at the function corrplot.mixed(). 

corrplot.mixed(cor(insurance[, c("age", "bmi", "charges")]), 
               lower = "number", 
               upper = "circle", 
               order = "hclust")

# d) Prepare a boxplot of the variable charges by region. Change the axis 
# titles to "Medical charges" and "Region"

boxplot(insurance$charges ~ insurance$region, 
        xlab = "Region", 
        ylab = "Medical charges")

# e) Modify the boxplot and add more styling to it. Name the axis, change 
# color of the elements, etc. Play with the arguments of plot function.

boxplot(insurance$charges ~ insurance$region, 
        xlab = "Region", 
        ylab = "Medical charges",
        main = "Distribution of Medical Charges by Region",
        col = "lightblue",
        border = "darkblue")
