################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 4 ###########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Data frame #################################################################

# Data structure used for storing tabular data (the most common structure used
# for statistical analysis and machine learning).

# It can be seen as a list of vectors of equal length (usually with unique names).
# The most important basic structure in tidyverse environment. 



### Creating data frame ########################################################

# Vectors must have equal length, but can have different types
column1 <- c(1:3)
column2 <- c("Anna", "Tom", "Sue")
column3 <- c(T, T, F)

dataset1 <- data.frame(column1, column2, column3)
dataset1

colnames(dataset1) # names of vectors are stored as column names
colnames(dataset1)[2] <- "name"
dataset1


### Adding new row #############################################################
dataset1

newRow <- c(4, "Jim", T)

# using rbind
dataset2 <- rbind(dataset1, newRow)
str(dataset2)
str(dataset1) # see the change in variable types


# How to avoid the loss of formatting?
newRowDF <- data.frame(4, "Jim", T)
str(newRowDF)

# beware of the column names when merging two DF!
dataset3 <- rbind(dataset1, newRowDF) 


# Creating new dataframe to be combined
names(newRowDF) <- c("column1", "name", "column3")
dataset3 <- rbind(dataset1, newRowDF)
str(dataset3)
str(dataset1) # compare the result now



### Adding new column ##########################################################
dataset1

newColumn <- c("a", "b", "c")

# Using cbind
dataset4 <- cbind(dataset1, newColumn)

dataset5 <- cbind(newColumn, dataset1)

# Compare the outcome
dataset4
dataset5



# Another option with new column
dataset1Copy <- dataset1

# Create new column by direct specification of column name
dataset1Copy$newValue <- 1 # additionally - recycling rule
dataset1Copy



### Getting data from data frame ###############################################

# by index - like in matrix
dataset1[3,2] # 3rd row, 2nd column

# by colum names
dataset1["name"] # the whole name vector
dataset1[, "name"] # alternative notation
dataset1$name # convinient notation

dataset1[3, "name"] # only name from the 3rd row

# by row names 
rownames(dataset1) <- c("girl", "boy", "teacher", "parent")
dataset1
dataset1["teacher", "name"]



### Build-in data frames #######################################################

# all built-in datasets in base R
data()


iris # dataset about flowers - build in R


# Usufull functions allowing for quick data inspection

head(iris) # show 6 first rows

head(iris, 10) # show 10 first rows

tail(iris) # show last 6 rows

str(iris) # summarizing data structure with variable types

summary(iris) # summarizing values of the dataset 


# Extraction of data works the same way as in the small dataset

head(iris$Species) # show first 6 rows of Species column

head(iris[,2:3]) # show first 6 rows from the 2nd and 3rd column
head(iris[,c("Sepal.Width", "Petal.Length")]) # alternative notation with column names



### Modifying column types #####################################################

# dataset CO2 -  Carbon Dioxide Uptake in Grass Plants

str(CO2)
summary(CO2)

head(CO2)

# How to change type of a column?

CO2$Type
class(CO2$Type)

CO2$Type <- as.character(CO2$Type)
class(CO2$Type)
str(CO2)



### Tasks ######################################################################

# 1. Create and add unique names to five vectors of length 8. Make their types 
# diverse. Create a dataframe named "mySet1" out of created vector. 
# a) Show the 5th row of created dataframe. 
# b) Change the name of the second column of mySet1 dataframe to "column02"
# c) Show 7 first rows of mySet1 dataframe. Use two different methods - with 
# indexes and with a function. 

# 2. Use iris dataset. Using indexing show values of every 3rd row between 
# 40th and 120th observations. Try to use a one-liner (shorten the code so that 
# it fits in one line only, without any intermediate steps).

# 3. Use built-in "women" dataset. 
# a) Change type of the first column to character.
# b) Add two new rows to the dataset with made-up numbers. Make sure that you 
# don't loose the types of variables in the main dataframe in the process. 
# c) Add new variable to the dataset and name it "shoe_size". Using runif function
# create the values for this variable. Shoe size must be an integer between 35 and 42. 

  