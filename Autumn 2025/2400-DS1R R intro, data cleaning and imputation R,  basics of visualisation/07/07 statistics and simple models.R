################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 7 ###########################################
################################################################################

# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################
#Notes_OM
?str() # Check structure
?min() # Smallest value
?max() # Largest value
?mean() # Mean
?median()Median
quantile(X, p=0.25)Quantile (of given percentage)
IQR()Interquartile range
sd() # Standard deviation
var()Variance

### Basic statistics ###########################################################

setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets")
water <- read.csv("graphics - water quality/water_potability.csv", sep = ",", dec=".")
head(water) 

# Data structure

str(water) # structure of dataset

# Minimum and maximum values
min(water$ph, na.rm = TRUE)
max(water$ph, na.rm = TRUE)

# automatic showing of min and max
range(water$ph, na.rm = TRUE)

# range
max(water$ph, na.rm = TRUE) - min(water$ph, na.rm = TRUE)

# mean
mean(water$ph, na.rm = TRUE)

# truncated mean
mean(water$ph, na.rm = TRUE, trim = 0.1)

# median
median(water$ph, na.rm = TRUE)

# quantiles
quantile(water$ph, 0.25, na.rm = TRUE)

quantile(water$ph, 0.5, na.rm = TRUE)

quantile(water$ph, 0.75, na.rm = TRUE)

# IQR - interquartile range
IQR(water$ph, na.rm = TRUE)

# standard deviation
sd(water$ph, na.rm = TRUE) 

# variance
var(water$ph, na.rm = TRUE)

# automatic calculation of statistics for variables -> lapply 
lapply(water[, 1:3], mean, na.rm = TRUE)

# summarizing the dataset
summary(water)

# additional function with statistical summary 
install.packages("pastecs")
library(pastecs)

stat.desc(water) # issue with readability of the data

options(scipen = 999) # turning off the matematical notation
stat.desc(water)

round(stat.desc(water),2) # rounding the results 


### Modelling ##################################################################

# Build-in dataset longley
summary(longley)
str(longley)



# Building a linear regression model

cor(longley$GNP, longley$Employed)

model <- lm(GNP ~ Employed, data = longley)
model

summary(model)
str(model)

# analysis the structure of the output

# List elements can be called with $ notation by its names
model$coefficients
model[[1]] # same result

# Data frame
model$model

# how to get only one variable from this dataframe?
model$model$GNP # calling the location one by one
model[[12]]$GNP
model[[12]][,1] #alternative notations



# Adding one more variable

model1 <- lm(GNP ~ Employed + Armed.Forces, data = longley)

summary(model1)
str(model1) # structure is similar -> this results from lm() function call

# more coefficients because the model is richer
model1$coefficients
model1[[1]] # same result

# how to get the intercept?
model1$coefficients[1]
model1[[1]][1] # same result
model1$coefficients['(Intercept)'] # same result

# We usually use the $ notation with names, for as long as we can for given
# output object. This gives much more clarity in the code about what is being read



### Clustering #################################################################

set.seed(123)

# k-means function has problems with missing data, let's put them aside
waterNoMiss <- water[complete.cases(water),]

clustering <- kmeans(waterNoMiss, 4)
summary(clustering)

str(clustering)
clustering$centers

# let's add clustering vector to our data
clustering$cluster # vector with assignment to k-means groups of each observations
waterNoMiss$kmeans <- clustering$cluster #creating a new variable with clusters

# Getting the mean of water Hardness in each group
tapply(waterNoMiss$Hardness, waterNoMiss$kmeans, mean)



### Small spoiler:
# 1. Getting the mean for groups with tidyverse

# library(tidyverse)
# waterNoMiss %>% group_by(kmeans) %>% summarize(mean = mean(Hardness))

# 2. Graphics - using the clustering result as a "coloring" factor 

# plot(waterNoMiss$Hardness, waterNoMiss$ph, col=waterNoMiss$kmeans)


### Tasks ######################################################################

# 1. a) Load the dataset "Life Expectancy Data.csv" into R and name it "life" 
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets/dataset - life expectancy")
life <- read.csv("Life Expectancy Data.csv")


# b) Preview its structure and summarise the values (two lines of code).
str(life)
summary(life)


# c) Filter the dataset - show data for 2013 only (use the $ notation where you can).
# Summarize the values of the subset (summary()) without saving the data to a 
# separate intermediate variable.
summary(life[life$Year == 2013, ])



# d) Calculate median of life.expectancy for Developing Countries (status variable) 
# in 2010. Use only one line of code, with no intermediate objects. Get the numerical result.
median(life$Life.expectancy[life$Status == "Developing" & life$Year == 2010], na.rm = TRUE)

# e) What the average Polio vaccination share was over the world in the year 2014?
mean(life$Polio[life$Year == 2014], na.rm = TRUE)

# 2. a) Create a subset of "life" dataset for year 2008 only, name it life2008.
life2008 <- life[life$Year == 2008, ]


# b) Remove rows which include missing values from your dataset.
life2008 <- life2008[complete.cases(life2008), ]

# c) Build a linear model for the "life2008" dataset, in which the dependent (y) variable
# will be the GDP, and the regressors (x) will be Polio, Alcohol and infant.deaths
# (in that order). Name the output object model2008.
model2008 <- lm(GDP ~ Polio + Alcohol + infant.deaths, data = life2008)

# d) Check the summary of the modelling results and the structure of output.
summary(model2008)
str(model2008)

# e) Print out the coeficient for infant.deaths (use $ notation where possible).
model2008$coefficients["infant.deaths"]
# OR accessing by index if position is known, but name is safer

# f) Calculate the variance of the absolute difference between real GDP values 
# and the values fitted by your model (fitted.values element). Hint: use abs() function.
var(abs(life2008$GDP - model2008$fitted.values))


