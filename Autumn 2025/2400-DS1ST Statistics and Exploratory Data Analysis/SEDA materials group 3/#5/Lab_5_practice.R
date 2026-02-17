###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 5                             #
#                 Graphical analysis of data (II)                 #
###################################################################


#Set English in R
Sys.setenv(LANG = "en")

#Set working directory
setwd("C:/Users/mchle/OneDrive - Wydział Nauk Ekonomicznych Uniwersytet Warszawski/!PRZEDMIOTY/SEDA/#5") #Desktop

#load the packages
library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)
library(datasets)

###################################################################
###Run charts###
###################################################################

#########################################
#Exercise 1: Use data on air quality that is available in R. 
#Graph the temperature and wind data over time. 
#What can say about the stationarity and autocorrelation in these data?
#get the data
library(help = "datasets") #what other datasets are available?
database <- airquality
str(database) #check the variables in the dataset
database %>% as_tibble()

#create data variable
database$Year <- 1973
database <- database %>% mutate(date = make_date(Year, Month, Day))

as.Date(database$date, "%d%b%Y")

ggplot(database, aes(x=date, y=Temp)) +
  geom_line() + 
  xlab("date") 

ggplot(database, aes(x=date, y=Wind)) +
  geom_line() + 
  xlab("date")

acf(database$Temp)
pacf(database$Temp)


#or in one plot
ggplot(database) + geom_line(aes(x=date, y=Temp, col="Temp")) +
  geom_line(aes(x=date, y=Wind, col="Wind"))



Sys.setlocale("LC_TIME", "C") # if want to display months in English

########################################################
#Exercise 2:
#Install package „car” and use the dataset „Salaries” from that package. 
#The dataset contains salaries of the nine-month academic salary for Assistant Professors, 
#Associate Professors and Professors in a college in the U.S. 

#get the data
#install.packages("car") #install package "car"
library(car) #load the package
data(Salaries) #get data on Salaries of professors
Salaries

#Create the mosaic plot for the discipline and sex
table(Salaries$sex, Salaries$discipline) 
table(Salaries$sex, Salaries$discipline) -> table1
#1st method
#install.packages("vcd")
library(vcd)
doubledecker(Salaries$sex ~Salaries$discipline)

#2nd method:
mosaicplot(table1)
                               
#Create the mosaic plot for the discipline, rank and sex
table(Salaries$sex, Salaries$discipline, Salaries$rank )
table(Salaries$sex, Salaries$discipline, Salaries$rank ) -> table2

doubledecker(Salaries$sex ~ Salaries$rank + Salaries$discipline)

#2nd method:
mosaicplot(table2)

install.packages("ggmosaic")
library(ggmosaic)

ggplot(data = Salaries) +
  geom_mosaic(aes(x = product(rank, discipline), fill=sex, offset = 0.02)) + 
  labs( title="Mosaic plot") +
  theme(axis.text.y = element_text(),
        axis.ticks.y=element_blank(),
        axis.text.x = element_text(angle = 90),
        legend.position = "right")


########################################################
#Exercise 3: Use data on diamonds that are avialable in R
########################################################
diamonds <- diamonds

##############################################################
#depict the relation between the number of carats and the price
##############################################################
#scatterplot
ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + labs(title="Scatterplot", x="Carat", y="Price") 

##############################################################
#depict the relation between the number of carats, 
#the price and the quality of the cut
##############################################################
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + labs(title="Scatterplot", x="Carat", y="Price") 

#or we can do the same by creating 5 scatter plots for each cut quality
gg1 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + labs(title="Scatterplot", x="Carat", y="Price") 

gg1 + facet_wrap( ~ cut, ncol=3)

##############################################################
#check graphically whether the price of the diamonds 
#is normally distributed
##############################################################
ggplot(diamonds, aes(sample=price))+stat_qq()

qqnorm(diamonds$price) 
qqline(diamonds$price) 

##############################################################
#summarize the distribution and the density of the diamonds 
#price by cut quality
ggplot(diamonds, aes(cut, price/carat, fill=cut)) + geom_boxplot()

ggplot(diamonds, aes(cut, price/carat, fill=cut)) + geom_violin() + geom_boxplot(width=0.05)

ggplot(diamonds, aes(cut, price/carat, fill=cut)) + geom_violin() + geom_boxplot(width=0.05) + scale_y_log10()

