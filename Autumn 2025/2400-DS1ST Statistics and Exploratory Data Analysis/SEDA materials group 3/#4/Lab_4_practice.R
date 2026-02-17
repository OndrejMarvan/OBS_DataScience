###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 4                             #
#                 Graphical analysis of data (I)                  #
###################################################################


#Set English in R
Sys.setenv(LANG = "en")

#Set working directory
setwd("C:\\Users\\mchle\\Dysk Google\\WNE Przedmioty\\SEDA\\Statistics and Explanatory Data Analysis\\4") #Desktop


###################################################################
###Graphs for categorical variables###
###################################################################
#Excercise 1:
#Install package „car” and use the dataset „Salaries” from that package. 
#The dataset contains salaries of the nine-month academic salary for Assistant Professors, 
#Associate Professors and Professors in a college in the U.S. Using the dataset:
#identify categorical variables
#visualize the data using the graphs for categorical variables.

# install.packages("car") #install package "car"
library(car) #load the package
data(Salaries) #get data on Salaries of professors
Salaries %>% as_tibble()

#Identify categorical variables
str(Salaries)
View(Salaries)

####################
#Bar charts#########
###################
#simple bar charts
##################
#use built-in functions in R
#Number of Professors by sex
bars <- table(Salaries$sex) #get the table of data that will be plottted
barplot(bars, 
        col=c("grey","red"), 
        main="Sex distribution", 
        xlab="sex")

# use ggplot package
# install.packages('ggplot2')
# install.packages('tidyverse')
library(ggplot2)
library(tidyverse)

ggplot(data=Salaries, aes(x=sex,)) + 
  geom_bar(fill="red",stat="count") + #define bar chart and color of the bar
  labs(x = "sex") + #add the title for x axis
  ggtitle("Sex distribution") #add the title of the graph

###################
#stacked bar charts
###################
#Number of Professors by sex and by the discipline they teach
bars <- table(Salaries$sex, Salaries$discipline)
barplot(bars,
        col=c("red","blue"), 
        main="Sex distribution by discipline", 
        xlab="Discipline",
        legend = rownames(bars))

#the same using ggplot
ggplot(data=Salaries, aes(x=discipline, fill=sex))+
  geom_bar(stat="count") + #define bar chart
  labs(x = "Discipline") + #add the title for x axis
  ggtitle("Sex distribution by discipline") + #add the title of the graph
  scale_fill_manual(values=c("magenta", "cyan")) # define colors of bars

###################
#grouped bar charts
###################
bars <- table(Salaries$sex, Salaries$discipline)
barplot(bars,
        beside=TRUE, #add besides to have groups next to each other
        col=c("red","blue"), 
        main="Sex distribution by discipline", 
        xlab="Discipline",legend = rownames(bars)) 

#the same using ggplot
ggplot(data=Salaries, aes(x=discipline, fill=sex))+
  geom_bar(stat="count", position="dodge") + #add position="dodge" to geom_bar to have the groups next to each other
  labs(x = "Discipline")+
  ggtitle("Sex distribution by discipline") +
  scale_fill_manual(values=c("red", "blue")) 

###################
#spine plots
###################
spineplot(Salaries$sex~Salaries$discipline, 
          col=c("red","blue"), 
          main="Sex distribution by discipline", 
          xlab="Discipline", 
          ylab="") 

#the same using ggplot
ggplot(data=Salaries, aes(x=discipline, fill=sex))+
  geom_bar(stat="count", position="fill") + #add position="fill" to geom_bar to have the groups in %
  labs(x = "Discipline")+
  ggtitle("Sex distribution by discipline") +
  scale_fill_manual(values=c("red", "blue")) 


###################
#pie charts
###################
slices <- table(Salaries$rank) #get the table of data that will be plottted
slices
pie(slices, 
    col=c("red", "gray", "darkgreen"), 
    main="Distribution of positions")           

#the same using ggplot
p <- ggplot(data=Salaries, aes(x="", fill=rank))+
  geom_bar() #create bar chart that will be tranformed to pie chart

p

p + coord_polar(theta="y", start=0) +  #make a pie
    scale_x_discrete("") + #specify no x axis
    ggtitle("Distribution of positions") #add the title of the graph



###################################################################
###Graphs for continous variables###
###################################################################
#Exercise 2:
#Use the dataset „Salaries”.
#Use simple dot plot to visualize data on Professors’ salaries.  
#What can you say about the distribution of the salaries based on this plot? 
plot(Salaries$salary, 
     type='p', 
     xlab = "", 
     ylab="Salary")

#Use Wilkinson dot plot to visualize data on Professors' salaries. 
#What can you say about the distrubtion of the salaries based on this plot?
ggplot(Salaries, aes(x=salary)) +
  geom_dotplot() + 
  labs(x="Salaries") + 
  labs(y="")+
  theme(axis.text.y =element_blank() )

#can also use BHH package
# install.packages("BHH2")
library(BHH2)
dotPlot(Salaries$salary)

#Try to use Cleveland dot plot to visualize data on Professor’s salaries. 
#this is rather usesell 
#we could instead plot mean salaries by position and sex

agg_data <- Salaries %>% select(rank, sex, salary) %>% group_by(rank, sex) %>% summarise(mean_s=mean(salary, na.rm=TRUE))
agg_data$groups <- with(agg_data, interaction(rank,  sex, sep = " & "))

dotchart(agg_data$mean_s)

yticks <- c(1, 2, 3, 4, 5, 6) #define y ticks
op <- par(mar = c(5, 10, 4, 2) + 0.1) #define setting for margins of the graph
dotchart(agg_data$mean_s)
axis(2, at=yticks, labels =agg_data$groups, las=2) #add names of the groups to y axis and make it horizontal
par(op) #change the margins of the graph
agg_data$groups<-factor(agg_data$groups, level=c("AsstProf & Female", "AsstProf & Male","AssocProf & Female", "AssocProf & Male",   "Prof & Female","Prof & Male"))
ggplot(agg_data, aes(x=mean_s, y=groups)) +
  geom_point(size=3) + 
  labs(x="Groups by position and sex")+ 
  labs(y="")

#Exercise 3
#Use the dataset „Salaries”.
#Create histograms and density plots for Professors’ salaries
#Create histograms and density plots for Professors’ salaries by sex/rank/discipline
#Intepret the graphs.

#Create histograms for Professors’ salaries
#using built-in R function
hist(Salaries$salary)

#using ggplot (nice) histogram
ggplot(Salaries, aes(salary)) + 
  geom_histogram(color="black", fill="red")

#if want to have % on y axis write:
ggplot(Salaries, aes(salary)) + 
  geom_histogram(color="black", fill="red", aes(y=(..count..)/sum(..count..)),binwidth=20000) + 
  ylab("%")


#Create density plots for Professors’ salaries
#using built-in R function
d <- density(Salaries$salary) 
plot(d, main = "Density plot", xlab = "salary", ylab = "density")

#using ggplot
ggplot(Salaries, aes(salary)) + 
  geom_density() 

#you can try different bandwidth with bw option
ggplot(Salaries, aes(salary)) + 
  geom_density(bw=10000) #changing bandwidth weight

#create histogram and density on one plot
ggplot(Salaries, aes(salary)) + 
  geom_histogram(aes(y=..density..),
                 fill="white", 
                 color="black") + 
  geom_density(fill="red", 
               alpha=0.25) #makes the density plot transparent

#####################################################################################
#Create histograms and density plots for Professors’ salaries by sex/rank/discipline
####################################################################################
ggplot(Salaries, aes(salary, fill=sex)) + 
  geom_histogram(aes(y=..ncount..), #..ncount.. rescales the maximum to 1 (normalization),
                 color="black",
                 position="dodge")  #position=dodge makes the bars next to each other

#add density plot
ggplot(Salaries, aes(salary, fill=sex, color=sex)) + 
  geom_histogram(aes(y=..density..), #if want to plot density and histogram on one grpah need to rescale y axis to density
                 color="black",
                 position="identity",  #position=identity makes the bars in the same position (overplotting)
                 alpha=0.5)  + #apha makes the bars that are in the same position transparent
  geom_density(alpha=0.2) #makes the density plot transparent


#you can do the same for rank (position) and sex - try it yourself!

###########################################
###########################################
#Exercise 5:
###########################################
###########################################
#Create the boxplot for salaries data.

#boxplot using built-in R functions
boxplot(Salaries$salary)

#boxplot using ggplot
ggplot(Salaries, aes(x="", y=salary)) + 
  geom_boxplot(fill="red") +
  scale_y_continuous(breaks=seq(50000,300000,by=25000))

#What are the range, the three quartiles and the interquartile range?
#Check your answers with calculating the relevant quartiles
quantile(Salaries$salary, probs=c(0.25, 0.5, 0.75))

#About how many outliers can you identify in the data?
outliers <- Salaries %>% filter(salary>200000)
View(outliers)
#or
Salaries %>% filter(salary>200000) %>% nrow()
