###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 1                             #
#                 Solutions to exercises for Students             #
###################################################################

###################################################################
#Exercise 1
###################################################################
#Use data on White House staff salaries as for 2010. 
setwd("C:\\Users\\Adminpc\\Documents\\ZAJECIA_2017_2018\\Statistics_EDA\\Lecture_4") #Desktop

ess <-read.csv("ESS_data.csv", 
              header=T, 
              sep=",",
              dec="." ,
              row.names=NULL) 
str(ess)
View(ess)
#a)	The variable ‘cgtsmke’ contains data on smoking behavior of individuals.
#Assign labels to data on smoking behavior as follows: 
#1 ”I smoke daily”,
#2 ”I smoke but not every day”,
#3 “I don't smoke now but I used to”, 
#4 ”I have only smoked a few times,
#5 “ I have never smoked“. 

ess$smoke <- as.factor(ess$cgtsmke)
levels(ess$smoke) <- c("I smoke daily", "I smoke but not every day","I don't smoke now but I used to", "I have only smoked a few times", "I have never smoked")



#b)	Summarize the distribution of the smoking behavior of European using relevant charts.
bars <- table(ess$smoke) #get the table of data that will be plottted
barplot(bars, 
        col=c("red","red"), 
        main="Smoking behavior", 
        xlab="")

library(ggplot2)
library(tidyverse)


ggplot(subset(ess, !is.na(smoke), aes(x=smoke,)) +  #to remove missing values fromm the plot
  geom_bar(fill="red",stat="count") + #define bar chart and color of the bar
  labs(x = "") + #add the title for x axis
  ggtitle("Smoking behavior") + #add the title of the graph
  theme(axis.text.x = element_text(angle = 90))
  
 
#c)	Compare the distribution of smoking behavior of
#Polish people and other European nation (whichever you want) on one graph. 
###################
#stacked bar charts (one on top of the other)
###################
ess$cntry
PL_NO <- ess %>% select(smoke, cntry) %>%  filter(cntry=="PL"|cntry=="NO")

PL_NO$Country <- ifelse(PL_NO$cntry=="PL"|PL_NO$cntry=="NO", PL_NO$cntry,"")
PL_NO$Country <- as.factor(PL_NO$Country)
levels(PL_NO$Country) <-c("NO", "PL") 
       
bars <- table(PL_NO$Country, PL_NO$smoke)
bars
barplot(bars,
        col=c("red","blue"), 
        main="Smoking behavior by country", 
        xlab="",
        legend = rownames(bars))

#the same using ggplot
ggplot(subset(PL_NO, !is.na(smoke), aes(x=smoke, fill=Country))+ #to remove missing values fromm the plot
  geom_bar(stat="count") + #define bar chart
  labs(x = "") + #add the title for x axis
  ggtitle("Smoking behavior by country") + #add the title of the graph
  scale_fill_manual(values=c("red", "blue")) + # define colors of bars
  theme(axis.text.x = element_text(angle = 90))

#grouped bar charts

#PLOT: add beside=TRUE, #add besides to have groups next to each other
#GGPLOT: add   geom_bar(stat="count", position="dodge") 

#SPINEPLOT
###################
#spine plots
###################
spineplot(Salaries$sex~Salaries$discipline, 
          col=c("red","blue"), 
          main="Sex distribution by discipline", 
          xlab="Discipline", 
          ylab="") 

#the same using ggplot
ggplot(data=subset(PL_NO, !is.na(smoke)), aes(x=smoke, fill=Country))+ #to remove missing values fromm the plot
  geom_bar(stat="count", position="fill") + #define bar chart
  labs(x = "") + #add the title for x axis
  ggtitle("Smoking behavior by country") + #add the title of the graph
  scale_fill_manual(values=c("red", "blue")) + # define colors of bars
  theme(axis.text.x = element_text(angle = 90))


#d)	The variable ‘fclcntr’ contains answers to the question 
#“How close do you feel to your country?”. 
#Assign labels to this variable as follows: 
#1 “Very close”, 
#2 “Close”, 
#3”Not very close”, 
#4 “Not close at all”.

ess$feel <- as.factor(ess$fclcntr)
levels(ess$feel) <- c("Very close", "Close","Not very close", "Not close at all")

#e)	Prepare a graph describing the variation across 
#European countries in their attachment to the home country.

#calculate mean attachment by country
agg_data <- ess %>% select(feel, cntry) %>% group_by(cntry) %>% summarise(Attachment=mean(as.integer(feel), na.rm=TRUE))

ggplot(agg_data, aes(x=Attachment, y=reorder(cntry, Attachment))) +
  geom_point(size=3) + 
  labs(x="Attachment")+ 
  labs(y="")


#f)	Plot the distribution of age (agea) for Poland and Germany. 
#Use both histogram and density plots.
#Compare the distributions of the Polish and German populations by age
#– is there any noticeable pattern? What about other countries?
sample <- ess %>% select(agea, cntry) %>%  filter(cntry=="PL"|cntry=="DE")

sample$Country <- ifelse(sample$cntry=="DE"|sample$cntry=="PL", PL_NO$cntry,"")
sample$Country <- ifelse(sample$cntry=="DE", 1, 2)
sample$Country <- as.factor(sample$Country)
levels(sample$Country) <-c("DE", "PL") 


ggplot(sample, aes(agea, fill=Country, color=Country)) + 
  geom_histogram(aes(y=..density..), #if want to plot density and histogram on one grpah need to rescale y axis to density
                 color="black",
                 position="identity",  #position=identity makes the bars in the same position (overplotting)
                 alpha=0.5)  + #apha makes the bars that are in the same position transparent
  geom_density(alpha=0.2) #makes the density plot transparent


#g)	Summarize the distribution of the education level measured by 
#the years of completed education (edulvlb) by country. 
#In which European country study the longest?

#calculate mean years of schooling by country
agg_data <- ess %>% select(eduyrs, cntry) %>% group_by(cntry) %>% summarise(Years=mean(eduyrs, na.rm=TRUE))

ggplot(agg_data, aes(x=Years, y=reorder(cntry, Years))) +
  geom_point(size=3) + 
  labs(x="Years of schooling")+ 
  labs(y="")



#Exercsie 2:
#•	What is the proportion of Europeans that is at most 160 cm high (height variable)
ggplot(ess, aes(height)) + 
  geom_histogram(color="black", fill="red", aes(y=(..count..)/sum(..count..))) + 
  ylab("%")

#•	What is the proportion of Poles that feels “very close” to their country?
ggplot(subset(ess, !is.na(feel)&cntry=="PL"), aes(feel)) + 
  geom_bar(color="black", fill="red", aes(y=(..count..)/sum(..count..))) + 
  ylab("%")

#•	What is the proportion of Portuguese that declares that they “have never smoked”?
ggplot(subset(ess, !is.na(smoke)&cntry=="PT"), aes(smoke)) + 
  geom_bar(color="black", fill="red", aes(y=(..count..)/sum(..count..))) + 
  ylab("%")  +
  theme(axis.text.x = element_text(angle = 90))


#•	What is the proportion of men in the Czech Republic that weights more than 100kg? What about women?
ggplot(subset(ess, gndr==1&cntry=="CZ"), aes(weight)) + 
  geom_histogram(color="black", fill="red", aes(y=(..count..)/sum(..count..))) + 
  ylab("%")


#Exercise 3
# Create the boxplot for weight (for all countries).
# Based on your graph answer to the following questions:
#  •	What are the range, the three quartiles and the interquartile range? 
# Check your answers with calculating the relevant quartiles
#•	About how many outliers can you identify in the data?

boxplot(ess$weight)


ggplot(ess, aes(x="", y=weight)) + 
  geom_boxplot(fill="red") +
  scale_y_continuous(breaks=seq(0,200,by=5))


quantile(ess$weight, probs=c(0.25, 0.5, 0.75), na.rm = TRUE)
IQR(ess$weight, na.rm=TRUE)

#•	About how many outliers can you identify in the data?
#all observations that are +/-1.5*IQR from the median are outliers
#outliers are above: 
74+1.5*21
#outliers are below:
74-1.5*21

#count how many:
ess %>% filter(weight>105.5|weight<42.5) %>% nrow()
