# association rules
###
###
###

# Sommerville data analysis
# General survey of happiness of inhabitants of the city

#Original data is from:
#https://catalog.data.gov/dataset/somerville-happiness-survey-responses-2011-2013-2015 
#Statistical analysis can be found at:
#https://synopticsignals.com/index.php/2018/05/13/exploratory-data-analysis-part-2/ 

# based on the example by Prof. Katarzyna Kopczewska

# read the data
data<-read.csv("Somerville_Happiness_Survey_responses_-_2011__2013__2015.csv", header=TRUE, sep=";")
names(data)

table(data$Year) # majority of data is from 2011

data<-data[data$Year==2011,] 
summary(data)# see that many variables are empty–below we clean the data
head(data)
names(data)

data<-data[, c(2:7, 11, 13, 15,17, 28:30, 32, 38,39)] # limited data

data

names(data)

# recoding of some columns – an example

# How.happy.do.you.feel.right.now. - column 2
data$happy.now<-ifelse(data[,2]<4, "not happy now", ifelse(data[,2]<7, "so-so happy now", ifelse(data[,2]<11, "very happy now", NA)))

# How.satisfied.are.you.with.your.life.in.general.- column 3
data$happy.life<-ifelse(data[,3]<4, "not happy with life", ifelse(data[,3]<7, "so-so happy with life", ifelse(data[,3]<11, "very happy with life", NA)))

# [4] "How.satisfied.are.you.with.Somerville.as.a.place.to.live."  - column 4 
data$happy.Somerville<-ifelse(data[,4]<4, "not happy in Somerville", ifelse(data[,3]<7, "so-so happy in Somerville", ifelse(data[,3]<11, "very happy in Somerville", NA)))

names(data)

# another limiting of the data and saving the file
data.sel<-data[, c(11:19)] 
write.csv(data.sel, file="Sommer.csv")

install.packages("arules")
library(arules)
trans1<-read.transactions("Sommer.csv", format="basket", sep=",", skip=0) # reading the file as transactions
trans1
inspect(trans1)
size(trans1) 
length(trans1)

# What is the profile of people that are happy in Somerville?
rules.VeryHappySommer<-apriori(data=trans1, parameter=list(supp=0.001, conf=0.08), appearance=list(default="lhs", rhs="very happy in Somerville"), control=list(verbose=F)) 

rules.VeryHappySommer.byconf<-sort(rules.VeryHappySommer, by="confidence", decreasing=TRUE)
inspect(head(rules.VeryHappySommer.byconf))

# People who are happy in Sommerville are mostly generally happy, they are White & non-Hispanic/Asian/Pacific Islanders, they are rather wealthy ($100.000+)

# What is the profile of unhappy people living in Somerville?
rules.UnHappySommer<-apriori(data=trans1, parameter=list(supp=0.001, conf=0.08), appearance=list(default="lhs", rhs="not happy in Somerville"), control=list(verbose=F)) 
rules.UnHappySommer.byconf<-sort(rules.UnHappySommer, by="confidence", decreasing=TRUE)
inspect(head(rules.UnHappySommer.byconf))

# People who are unhappy in Sommerville are mostly erderly (61+), generally non happy with life, often widowed 

# Who earns a lot in Sommerville?
rules.wealthy<-apriori(data=trans1, parameter=list(supp=0.001, conf=0.08), appearance=list(default="lhs", rhs="100,000 and up"), control=list(verbose=F)) 
rules.wealthy.byconf<-sort(rules.wealthy, by="confidence", decreasing=TRUE)
inspect(head(rules.wealthy.byconf))

# People who are wealthy, live in Sommerville for lat 5 years, the are around 51-60 years old, mostly married, white 

# Who recently moved to Sommerville?
rules.newcomers<-apriori(data=trans1, parameter=list(supp=0.001, conf=0.08), appearance=list(default="lhs", rhs="0-5 Years"), control=list(verbose=F)) 
rules.newcomers.byconf<-sort(rules.newcomers, by="confidence", decreasing=TRUE)
inspect(head(rules.newcomers.byconf))

# Newcomers to Sommerville are young people – but very different, happy & not happy, rich & poor
