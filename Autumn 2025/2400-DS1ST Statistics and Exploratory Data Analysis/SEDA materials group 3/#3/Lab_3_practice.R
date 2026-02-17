###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 3                             #
#           Measures of dispersion and shape                      #
###################################################################
# install.packages(tidyverse))
library(tidyverse)

#Set English in R
Sys.setenv(LANG = "en")

#Set working directory
setwd("C:/Users/mchle/OneDrive - Wydział Nauk Ekonomicznych Uniwersytet Warszawski/!PRZEDMIOTY/SEDA/#3") #Desktop

########################################################################################
###Measures of dispersion###
########################################################################################

########################################
#Excercise 1: Use data on airbnb offers 
#in Warsaw and Vienna (as for July 2017)
#Calculate the overall mean price and
#mean prices for various room types in both cities. 
#For each city summarize the variability of the prices for various types of rooms using:
#range, interquartile range, variance, standard deviation, MAD
#Identify the room type for which the variation in prices is the greatest
#Compare the variation in prices of various room types in Warsaw and in Vienna
#######################################

#Load data
Warsaw <-read.csv("Airbnb_Warsaw_July_2017.csv", 
                  header=T, 
                  sep=",",
                  dec="." ) 
str(Warsaw)

Vienna <-read.csv("Airbnb_Vienna_July_2017.csv", 
                header=T, 
                sep=",",
                dec="." ) 
str(Vienna)

#mean prices in each city
Vienna$price <- Vienna$price*4.9
mean(Warsaw$price)
mean(Vienna$price)

#mean prices by room type and city
Warsaw %>% group_by(room_type) %>% summarise(mean_price=mean(price),n=n())
Vienna %>% group_by(room_type) %>% summarise(mean_price=mean(price),n=n())

#summarize the variability of the prices by room type and city
#Prepare data
#Warsaw entire apartment
Warsaw %>% filter(room_type=="Entire home/apt") %>% select(price) -> waw1
#Warsaw private room 
Warsaw %>% filter(room_type=="Private room") %>% select(price) -> waw2
#Warsaw shared room 
Warsaw %>% filter(room_type=="Shared room") %>% select(price) -> waw3
#Vienna entire apartment
Vienna %>% filter(room_type=="Entire home/apt") %>% select(price) -> vien1
#Vienna private room 
Vienna %>% filter(room_type=="Private room") %>% select(price) -> vien2
#Vienna shared room 
Vienna %>% filter(room_type=="Shared room") %>% select(price) -> vien3

#Warsaw
#range
range_waw1 = max(waw1$price)-min(waw1$price)
range_waw2 = max(waw2$price)-min(waw2$price)
range_waw3 = max(waw3$price)-min(waw3$price)
range_waw1; range_waw2; range_waw3

#interquartile range
iqr_waw1 = IQR(waw1$price)
iqr_waw2 = IQR(waw2$price)
iqr_waw3 = IQR(waw3$price)
iqr_waw1; iqr_waw2; iqr_waw3
#variance
var_waw1 = var(waw1$price)
var_waw2 = var(waw2$price)
var_waw3 = var(waw3$price)
var_waw1; var_waw2; var_waw3
#standard deviation
sd_waw1 = sd(waw1$price)
sd_waw2 = sd(waw2$price)
sd_waw3 = sd(waw3$price)
sd_waw1; sd_waw2; sd_waw3
#MAD
mad_waw1 = mad(waw1$price)
mad_waw2 = mad(waw2$price)
mad_waw3 = mad(waw3$price)
mad_waw1; mad_waw2; mad_waw3

#Vienna
#range
range_vien1 = max(vien1$price)-min(vien1$price)
range_vien2 = max(vien2$price)-min(vien2$price)
range_vien3 = max(vien3$price)-min(vien3$price)
range_vien1; range_vien2; range_vien3
#interquartile range
iqr_vien1 = IQR(vien1$price)
iqr_vien2 = IQR(vien2$price)
iqr_vien3 = IQR(vien3$price)
iqr_vien1; iqr_vien2; iqr_vien3
#variance
var_vien1 = var(vien1$price)
var_vien2 = var(vien2$price)
var_vien3 = var(vien3$price)
var_vien1; var_vien2; var_vien3
#standard deviation
sd_vien1 = sd(vien1$price)
sd_vien2 = sd(vien2$price)
sd_vien3 = sd(vien3$price)
sd_vien1; sd_vien2; sd_vien3
#MAD
mad_vien1 = mad(vien1$price)
mad_vien2 = mad(vien2$price)
mad_vien3 = mad(vien3$price)
mad_vien1; mad_vien2; mad_vien3



######################################
#alternative way:
#####################################
#Warsaw variance and sd
Warsaw_var <-aggregate(Warsaw$price, by=list(room=Warsaw$room_type), 
                       FUN=var, na.rm=TRUE) #create a dataframe with variance by room type

arrange(Warsaw_var, x) #display the dataframe in ascending order

Warsaw_sd <-aggregate(Warsaw$price, by=list(room=Warsaw$room_type), 
                      FUN=sd, na.rm=TRUE) #create a dataframe with standard deviation by room type

arrange(Warsaw_sd, x) #display the dataframe in ascending order

#Vienna variance and sd
Vienna_var <-aggregate(Vienna$price, by=list(room=Vienna$room_type), 
                       FUN=var, na.rm=TRUE) #create a dataframe with variance by room type

arrange(Vienna_var, x) #display the dataframe in ascending order

Vienna_sd <-aggregate(Vienna$price, by=list(room=Vienna$room_type), 
                      FUN=sd, na.rm=TRUE) #create a dataframe with standard deviation by room type

arrange(Vienna_sd, x) #display the dataframe in ascending order



#Compare the variation in prices of various room types in Warsaw and in Vienna
#-->Calculate coeffiecients of variation (allows for unitless comparision)
#Warsaw
CV_waw1=(sd(waw1$price)/mean(waw1$price))*100
CV_waw2=(sd(waw2$price)/mean(waw2$price))*100
CV_waw3=(sd(waw3$price)/mean(waw3$price))*100
CV_waw1;CV_waw2;CV_waw3
#Vienna
CV_vien1=(sd(vien1$price)/mean(vien1$price))*100
CV_vien2=(sd(vien2$price)/mean(vien2$price))*100
CV_vien3=(sd(vien3$price)/mean(vien3$price))*100
CV_vien1;CV_vien2;CV_vien3


########################################################################################
###Measures of shape###
########################################################################################

#######################################
#Excercise 2: 
#Calculate mean, median and mode for 
#prices of rooms in Warsaw.
#What can you say about the shape of 
#the price distribution based on these measures?
#Verify your answer by calculating relevant measure of shape.
###############################################

#mean, median and mode price of rooms in Warsaw
mean(Warsaw$price)
median(Warsaw$price) # mean bigger than median -> we have outliers on the right side of distribution
d <- density(Warsaw$price)
d$x[d$y==max(d$y)]



#measures of shape
# install.packages("e1071")
library(e1071)
skewness(Warsaw$price)
kurtosis(Warsaw$price) 

kurtosis(rnorm(1000))

################################################
#Excercise 3: Calculate mean, median and mode 
#for the satisfaction of the travelers,
#who stayed with aribnb in Vienna.
#What can you say about the shape of the satisfaction 
#distribution based on these measures?
#Once again verify your answer by calculating relevant measure of shape.
###################################################

#mean, median and mode price of rooms in Warsaw
mean(Vienna$overall_satisfaction)
median(Vienna$overall_satisfaction)
table(Vienna$overall_satisfaction) #names(sort(-table(Vienna$overall_satisfaction)))[1]

#measures of shape
skewness(Vienna$overall_satisfaction)
kurtosis(Vienna$overall_satisfaction)
?kurtosis
kurtosis(rnorm(100000))

Desc(Vienna$overall_satisfaction)

########################################################################################
###Outliers###
########################################################################################

##########################################
#Excercise 4:Using three methods for 
#identifying outliers that we covered during the class 
#check data on room prices in Warsaw and determine potential outliers.
###########################################

#The IQR rule
max <- quantile(Warsaw$price,0.75,na.rm = TRUE)+(IQR(Warsaw$price, na.rm = TRUE)*1.5)
min <- quantile(Warsaw$price,0.25,na.rm = TRUE)-(IQR(Warsaw$price, na.rm = TRUE)*1.5)

Warsaw$outlier1 <- factor(ifelse(Warsaw$price>max|Warsaw$price<min, 1,0))

#Z-score
Warsaw$z_score <- scale(Warsaw$price,center=TRUE, scale=TRUE) # standarizing prices
Warsaw$outlier2 <- factor(ifelse(Warsaw$z_score>2, 1,0))
Warsaw$outlier3 <- factor(ifelse(Warsaw$z_score>3, 1,0))

#Modified Z-score
# install.packages("spatialEco")
# library(spatialEco)


MAD <- median(abs(Warsaw$price-median(Warsaw$price)))
Warsaw$z_score_mod <- ((0.6745*(Warsaw$price - median(Warsaw$price))) / MAD)

Warsaw$outlier4 <- factor(ifelse(Warsaw$z_score_mod>3.5, 1,0)|Warsaw$z_score_mod<(-3.5))

#Summarize results
table(Warsaw$outlier1); table(Warsaw$outlier2); table(Warsaw$outlier3); table(Warsaw$outlier4)
Warsaw %>% filter(Warsaw$outlier3==1)

library("DescTools")

Desc(Warsaw$price)
