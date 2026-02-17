###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 1                             #
#                 Solutions to exercises for Students             #
###################################################################

###################################################################
#Exercise 1
###################################################################
#Use data on White House staff salaries as for 2010. 
setwd("...") #Desktop


#Load data
WH <-read.csv("White_house.csv", 
                  header=T, 
                  sep=",",
                  dec="." ,
                  row.names=NULL) 
str(WH)
View(WH)

#a)	Summarize the distribution of salaries using the appropriate measures of dispersion. 
min(WH$Salary)
max(WH$Salary)
var(WH$Salary)
sd(WH$Salary)
mad(WH$Salary)
#Which groups of workers (based on a position) exhibit the greatest variation in salaries?
aggdata <-aggregate(WH$Salary, by=list(position=WH$Position.Title), 
                    FUN=var, na.rm=TRUE) #create a dataframe with variance by position

arrange(aggdata, x) #display the dataframe in ascending order

#b)	Calculate the mean, median and mode of the salaries. 
#What can you say about the shape of the distribution of the salaries? 
#Verify your answer and calculate relevant measures of shape. 
#mean, median and mode
mean(WH$Salary, na.rm = TRUE)
median(WH$Salary, na.rm = TRUE)
d <- density(WH$Salary, na.rm = TRUE)
d$x[d$y==max(d$y)]
#distribution has long right tail (positive skewness)
skewness(WH$Salary, na.rm = TRUE)
kurtosis(WH$Salary, na.rm = TRUE)

#c)	Check your data for the presence of outliers using the three rules we covered during the class. 
#The IQR rule
max <- quantile(WH$Salary,0.75,na.rm = TRUE)+(IQR(WH$Salary, na.rm = TRUE)*1.5)
min <- quantile(WH$Salary,0.25,na.rm = TRUE)-(IQR(WH$Salary, na.rm = TRUE)*1.5)

WH$outlier1 <- factor(ifelse(WH$Salary>max|WH$Salary<min, 1,0))

#Z-score
WH$z_score <- scale(WH$Salary,center=TRUE, scale=TRUE)
WH$outlier2 <- factor(ifelse(WH$z_score>2, 1,0))
WH$outlier3 <- factor(ifelse(WH$z_score>3, 1,0))

#Modified Z-score
install.packages("spatialEco")
library(spatialEco)
WH$z_score_mod <-outliers(WH$Salary)
WH$outlier4 <- factor(ifelse(WH$z_score_mod>3.5, 1,0))

#Summarize results
table(WH$outlier1); table(WH$outlier2); table(WH$outlier3); table(WH$outlier4)

###################################################################
#Exercise 2
###################################################################
#Use data on fruit consumption per person by country for the years 1961-2013.
setwd("C:\\Users\\Adminpc\\Documents\\ZAJECIA_2017_2018\\Statistics_EDA\\Lecture_3") #Desktop

#Load data
fruits <-read.csv("Fruit_consumption.csv", 
              header=T, 
              sep=",",
              dec="." ,
              row.names=NULL) 
str(fruits)
View(fruits)

#a)	Identify countries that exhibit the maximum and minimum fruit consumption in 2013.
fruits %>% filter(Year==2013) %>% select(Entity, Consumption) -> cons_2013
max(cons_2013$Consumption)
min(cons_2013$Consumption)

cons_2013 %>% filter(Consumption==max(Consumption)) %>% select(Entity)-> a
a
cons_2013 %>% filter(Consumption==min(Consumption)) %>% select(Entity)-> b
b

#b)	For each country calculate variance and the standard deviation of fruit consumption. 
#variance
variance <-aggregate(fruits$Consumption, by=list(country=fruits$Code), 
                  FUN=var, na.rm=TRUE) #create a dataframe with range by country
View(varaince)
arrange(variance, x) #display the dataframe in ascending order


sd <-aggregate(fruits$Consumption, by=list(country=fruits$Code), 
                  FUN=sd, na.rm=TRUE) #create a dataframe with range by country
View(sd)
arrange(sd, x) #display the dataframe in ascending order


#c)	What can you say about the distribution of fruit consumption in the United States?
range %>% filter(country=="USA") 
variance %>% filter(country=="USA") 
sd %>% filter(country=="USA") 


