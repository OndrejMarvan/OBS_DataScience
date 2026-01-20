################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 5 ###########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Text data manipulation #####################################################

text <- c("Anna", "smith", "chair", "TABLE")

text_small <- tolower(text)
text_small

text_big <- toupper(text)
text_big



# How to create a word with only the first letter as the upper case?

first_letters <- substr(text, 1,1)
first_letters

word_remaining <- substr(text,2, 100) # big number at the end -> ensures reaching the end of each word 
word_remaining

# Binding text data  -> paste and paste0
paste("a", "b")
paste0("a", "b")

?paste

text_firstbig <- paste0(toupper(first_letters), tolower(word_remaining))
text_firstbig



# Removing last two characters (elements) from a word

text2 <- paste0(text, "23") # pasting additional two numbers to each vector element
text2

nchar(text2) # text length in each element of the character vector 
length(text2) # length of the total vector (how many elements it consists of)

text2_correction <- substr(text2,1,nchar(text2)-2) # correcting by removing last two elements

text == text2_correction # checking if the correction was successful



### Merging data - join operations #############################################

set1 = data.frame(IdClient = c(1:6, 8), Product = c(rep("Bike", 4), rep("TV", 3)))
set2 = data.frame(IdClient = c(1, 2, 5, 9), Region = c(rep("western", 3), rep("eastern", 1)))

set1
set2


# Inner join (common part)
merge(set1, set2)

# Outer join (joining all data elements)
set12 <- merge(x = set1, y = set2, by = "IdClient", all = TRUE)
set12 

# Left outer join (fitting to the data from the left table)
merge(x = set1, y = set2, by = "IdClient", all.x = TRUE)

# Right outer join (fitting to the data from the right table)
merge(x = set1, y = set2, by = "IdClient", all.y = TRUE)



### Transposing data ###########################################################


t(set1) # data transposition

ten <- 1:10
ten # vector (default: vertical)
t(ten) # vector with two dimensions -> now written horizontally



### Sorting ####################################################################

set1

set1[1:7,] # sorting by indices
set1[7:1,]

# sorting data by its values
sort(set1$IdClient, decreasing = FALSE)

set1[sort(set1$IdClient, decreasing = FALSE),]
# why do we see empty values in the last row?


# Ordering data with order function 

#order(set1[, "IdClient"])
order(set1$IdClient)

set1[order(set1$IdClient),]
set1[order(set1$IdClient, decreasing = TRUE),]



### Filtering ##################################################################


set12[2,] # second row

set12[2,2] # second row, second column 

set12[,2] # second column 

set12[set12$Product == "Bike",] # choosing rows which satisfy the condition
set12[set12$IdClient == 5,]


# creating a subset

setBikeA <- set12[set12$Product == "Bike",] 

setBike <- subset(set12, Product == "Bike")
setBike



### Using categorical data #####################################################

summary(set12)

set12$Product <- as.factor(set12$Product)
set12$Region <- as.factor(set12$Region)

summary(set12)

# mean value in given group 

mean(set12[set12$Product=="TV", "IdClient"])


# More resources:
# http://www.yanqixu.com/My_R_Cheatsheet/data_cleaning_cheatsheet.html



### Imputing the missing data ##################################################

# checking which values are empty (NA)
is.na(set12$Region)

# using is.na() we can filter by (non)missing observations 
set12[is.na(set12$Region),]


# Trying to imput data:
set12[is.na(set12$Region),"Region"] <- "lack" 
# impossible, variable was already converted to a factor


# how to solve it? 
# 1. convert to character
set12$Region <- as.character(set12$Region)

is.na(set12$Region)

# 2. replace the value
set12[is.na(set12$Region),"Region"] <- "lack" 

# 3. convert back to factor -> new level will be included
set12$Region <- as.factor(set12$Region)



# different function - complete.cases

# creating a "helper" set
setMissing = data.frame(IdClient = c(1:10), 
                            Region = c(rep("western", 2), rep(NA, 2), 
                                       rep("eastern", 1), rep(NA, 5)),
                            Wages = c(seq(2000,3500, 500), NA, seq(4000,5000, 500), rep(NA,2)))


setMissing

# how does complete.cases() work?
complete.cases(setMissing)

setMissing[complete.cases(setMissing),] # only full data rows
setMissing[!complete.cases(setMissing),] # rows which have at least one missing value 


# replicating with is.na()
setMissing[is.na(setMissing$Region) | is.na(setMissing$Wages),] # rows which have at least one missing value 

setMissing[is.na(setMissing$Region) & is.na(setMissing$Wages),] # rows which have missing values in both variables



### Random numbers #############################################################

# Compare these vectors:
randomVector1 <- runif(20)
randomVector2 <- runif(20)
randomVector3 <- runif(20)

randomVector1; randomVector2; randomVector3 

# To these vectors:
set.seed(1)
randomVector1a <- runif(20)
randomVector2a <- runif(20)
randomVector3a <- runif(20)

randomVector1a; randomVector2a; randomVector3a 

# And to these vectors:
set.seed(1)
randomVector1b <- runif(20)
set.seed(1)
randomVector2b <- runif(20)
set.seed(1)
randomVector3b <- runif(20)

randomVector1b; randomVector2b; randomVector3b


# What is different? 
# Rerun the code above (starting from line 214 - section Random Numbers) and see what changes.

# What is the result of set.seed() on runif() function?


### Picking random rows from data ##############################################

# Creating a vector with 5 numbers from uniform distribution between 1 and 10
random <- runif(5,1,10)
random

# First version:
randomIndices1 <- order(random)
randomIndices1

setMissing[randomIndices1,]

# Second version:
randomIndices2 <- sort(unique(as.integer(random)))
randomIndices2

setMissing[randomIndices2,]



### Getting data from packages #################################################

# Using a package in R:

# 1. install the package when using it for the first time in given R version
# on a given computer

# Example with cluster package

install.packages("cluster")

# 2. load the package every time you'd like to use it - once per working R session
library("cluster")
library(cluster) #both notations are ok

# Re-installation of an already installed package allows to update it to the newest 
# version available on CRAN.



data(package="rpart")
data(Puromycin, package="datasets")

install.packages("Ecdat")
require("Ecdat")
data(HHSCyberSecurityBreaches, package="Ecdat") #GIT.



data(nuclearWeaponStates, package="Ecdat") # GIT. daty.
nuclearWeaponStates 

if(!require(mosaicData)){
  install.packages("mosaicData")
  library(mosaicData)
}

data(Gestation, package="mosaicData") # good for factor making
Gestation

data(Weather, package="mosaicData") # good for splitting text!!! and date



### Tasks ######################################################################



### Use the built-in dataset CO2 for the following tasks:

# 1. Print values of CO2 uptake from the largest to the smallest.
sort(CO2$uptake, decreasing = TRUE)

# 2. Show the rows of CO2 dataset, where the Type is set to Quebec and Treatment to chilled.
CO2[CO2$Type == "Quebec" & CO2$Treatment == "chilled", ]

# 3. Show the rows of CO2 dataset, where the uptake is higher than 40 and the 
# dataset is sorted by the conc value from the smallest to the largest.
# Bonus point for keeping the whole code in just one line. If you need to create
# an intermediate object - name it 'temp'.
# Bonus one-liner:
subset(CO2[order(CO2$conc), ], uptake > 40)

# 4. How to get a random ordering of a CO2 dataset? TIP: You may want to get a 
# vector with random indices that will come from order(unif(...)) results. 
# See section "Picking random rows from data" for reference.
# Bonus point for writing the code in just one line with no intermediate objects.
# Bonus one-liner:
CO2[order(runif(nrow(CO2))), ]


### Run this code before doing the next tasks
set.seed(123)
missCO2 <- CO2
missCO2[c(as.integer(runif(10)*nrow(missCO2)),14:16),"uptake"] <- NA
missCO2[c(as.integer(runif(10)*nrow(missCO2)),14:16),"conc"] <- NA
missCO2$weight <- paste0(as.integer(runif(nrow(missCO2))*30),"kg")


# 5. Show rows of missCO2 dataset, which have at lease one missing value.
missCO2[!complete.cases(missCO2), ]

# 6. Fill in the missing uptake values with value 20.
missCO2[is.na(missCO2$uptake), "uptake"] <- 20

# 7. Fill in the missing conc values with the mean of conc.
missCO2[is.na(missCO2$conc), "conc"] <- mean(missCO2$conc, na.rm = TRUE)

# 8. Extract the numeric values from weight variable and store them in the new 
# column "weightNumber". Bonus point for keeping the code in one line, 
# without any intermediate objects.
# Bonus one-liner:
missCO2$weightNumber <- as.integer(substr(missCO2$weight, 1, nchar(missCO2$weight) - 2))

