#Class 1 
# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

#### Variable and assigning values #############################################

varA

varA <- 1

varA

# sign <- is used for assigning values

varB = 1

varB


### Basic information about functions ##########################################

# function(argument1, argument2, argument3, ...)
# function is a command recognisable by a computer (written in a programming
# language - in the base version or extended by a package), 
# which triggers specific actions (calculations), written in 
# the function's definition and returns a result. 

# Function -> takes parameters/arguments as input, triggers action, returns result.

# The simplet function print() 
# it can take a text variable as an input (and many other variables) 

print("Hello world")

print(varC)

#### Looking for the help regarding a certain function  ########################

# 1. Using the help() command, which takes the name of the function as an argument
help(print)

# 2. Running the code as ?functionName 
?print

# 3. Highlighting or clicking on the function name and using the key F1

### Vector #####################################################################

# Vector - variable, which stores multiple elements of the same type inside

# basic function creating a vector c() --- combine

a <- 1
vectorA <- c(1)

a
vectorA

# Double equal sign means - check if two objects are equal (the same) 

a == vectorA 

# Yes! This means that behind these two vector names there is the same content.
# Both are vectors with the length one.
# In R every single variable (single number, single text sign) is a vector.

# We can also create longer vectors:

vectorLonger <- c(1,2,3)
vectorLonger

# Vectors can contain text:

vectorText <- c("first element", '2nd element', "Third element")
vectorText

# There are functions which allow for creating longer vectors automatically

vectorOneFive <- c(1,2,3,4,5)
vectorOneFiveAuto <- c(1:5) # specifying the range of numbers in a sequence - from 1 to 5

vectorOneFiveAuto2 <- seq(1, 5,1) # using new function seq()
vectorOneFiveAuto3 <- seq(from = 1, to = 5, by = 1) 

vectorOneFiveAuto3BIS <- seq(to = 5, by = 1) 

vectorOneFive
vectorOneFiveAuto
vectorOneFiveAuto2
vectorOneFiveAuto3

help(seq)

# Function which allows for generating repeating sequences rep()

vectorWithReps <- rep(1, times = 3)
vectorWithReps

vectorWithReps2 <- rep(c(1,2), each = 3)
vectorWithReps2

vectorWithReps3 <- rep(c(1,2), times = 3)
vectorWithReps3

vectorWithReps4 <- c(rep(c(1,2), times = 3),5)
vectorWithReps4 

vectorWithReps4BIS <- c(vectorWithReps3,5)
vectorWithReps4BIS 

help(rep)
?rep

### Tasks ######################################################################


# 5. Find documentation regarding the function runif(). What does it do? What are
# the possibilities? What can you do with it? 
?runif

# 6. You have a vector "a" below. Use function sum() on it. What is the result? Try to 
# get a numerical result instead of NA. TIP: look into the documentation. 

a <- c(5,8,10, NA)
sum(a, na.rm = TRUE)

# Reminder:

# commenting with a hash symbol

# function(argument1, argument2, argument3, ...)

a <- "assigning value to a variable"
b = "alternative way of assigning values"
c <- 2
d = 3

a
b
c
d


### Data types #################################################################

### Numeric ####

# basic type for numerical data 
a <- 1.5
a
class(a) # check the class (type) of variable a
b <- 10
b
class(b) # check the class (type) of variable b

### Integer ####

# 'special' type of numerical data - integers
a <- as.integer(5) # in order to create a variable with 'integer' type you need to force it 
class(a) 
is.integer(a) # check if a is an integer 
is.numeric(a) # check if a is a numeric
# integer is a subclass of numeric

b <- 6.89
b
class(b)
b <- as.integer(b) # converting the current b type to the integer 
b # converting the numeric type to integer will remove the decimal part 

### Logical ####
# Datatype storing logical information - true-false
# True values in R: TRUE, T, 1
# False values in R: FALSE, F, 0
a <- 5; b <- 3 # we can run two operations in one line, dividing them with a semicolon
z = a < b # z will be the result of the operation checking if a is smaller than b 
z
class(z)

### Logical operators: ###
# & (and) conjunction 
# | (or) alternative
# ! (not) negation

a <- TRUE
b <- FALSE

a & a
a & b 
a | a
a | b 
b | b
!a
!b

### Character ###

# Datatype for storing text values.
# In other languages (R) character is the equivalent of string. 
# Character data in R are shown within quotation symbols. 

a <- "z"
b <- "Longer text with spaces."
class(a)
class(b)

c <- "9.66"
c # look at the quotation signs when printing this value 

class(c)
is.numeric(c)
as.numeric(c) # Only after converting to the numeric quotations are disappearing 
as.numeric(b) # Converting text to the numeric makes no sense - it will produce empty values NA

### Date ###

# There are many possibilities for date processing in R. The most basic one is 
# as.Date() function for Date class. Dates are stored as number of days since 
# 1970-01-01, with negative values for earlier dates. This format stores date-only data. 

dates1 <- c("2022-08-18", "1998-01-30", "2020-03-18")
class(dates1)

as.numeric(dates1) # this is only text data - NAs created

# using as.Date() function
dates1.Date <- as.Date(dates1)
class(dates1.Date)

as.numeric(dates1.Date) # conversion to number is possible now

dates1.Date - as.Date("1970-01-01") 

# date format is specified with a formatting code from format() function
# for Date specific abbreviations check ?strftime() documentation 

dates2 <- c("11/20/80", "11/20/91", "11/20/1993", "09/10/93")
dates2.Date <- as.Date(dates2)
dates2.Date <- as.Date(dates2, format = "%m/%d/%y")
dates2.Date

# commonly used date notation with integers is used in Excel
# however the starting point is set differently than in R. In Excel the days 
# are counted starting from 1899-12-30. In order to process that we need to change
# the origin parameter in as.Date() function. 

datesFromExcel <- c(42710, 43133, 39999, 41223)
as.Date(datesFromExcel, origin = "1899-12-30")

# We can change the date formatting with format() function

today <- Sys.Date() # returns today's date
today

# we can change the format of the date

todayFormatted <- format(today, format = "%A %d %B %Y")
todayFormatted


### Data structures ############################################################

### Vector ###

vectorInteger <- c(1:10)
vectorInteger
class(vectorInteger)

vectorNumeric <- c(1.5:3.5)
vectorNumeric
class(vectorNumeric)

vectorCharacter <- c('a', 'b', 'c')
#vectorCharacter2 <- c(a, b, c) # <- Tells R: go find the variable named a and use whatever value is stored inside it. 
vectorCharacter
class(vectorCharacter)

vectorLogical <- c(TRUE, FALSE, F, T, T)
vectorLogical
class(vectorLogical)

# General info:
# - single datatype
# - as long as you wish
# - basic command c() - combine
# - additional useful commands - rep()-repeat and seq()-sequence

# Example vectors

w1 <- 2
w2 <- c(2)
w3 <- c(2,3,7)
w4 <- c(1:10)
w5 <- c(1:4, 10)
w6 <- c(2:7, "nana", "20", 1) # Because elements of class character were added, the whole vector was converted to character 
w7 <- rep(3, times = 500)
w8 <- seq(from = 7, to = 90, by =3)
w9 <- c('a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8', 'a9', 'a10')
w10 <- c(T, F, F, T) # vector of logical values

### Operations on vectors  #####################################################

w1; w2; w3 # calling few elements in one line - with semicolon

w123 <- c(w1, w2, w3) # combining vectors 
w123 

### Arithmetical operations ####################################################

# values in vectors can be multiplied, added, subtracted, divided, etc.  
w123 + 2
w123/2
w123 * 5

# we can also add vectors together (in the simplest case - when they have equal length)
w1 + w2
c(5,2,3) + c(10,20,30)

### Recycling rule in vectors ##################################################

# if we try to do an operation on vectors with different lengths R tries to reuse
# values from the shorter vector so that the length of the vectors will be equal. 
# It is done by copying the values from the shorter vector X times, so that 
# lengthLonger = x*lengthShorter. 

w1 
w1 + c(1,2) # 2 + (1,2) -> (1+2, 2+2)
c(1, 2, 3) + c(5, 6, 7, 1, 2, 3) # (5+1, 6+2, 7+3, 1+1, 2+2, 3+3)
c(1, 2, 3) + c(5, 6, 7, 1, 2)  # ERROR! Longer vector's length is not a multiplication of the shorter vector's length. 
# Operation will not be successful. 

### Taking values from the vectors - indexing ##################################

w9
w9[1]
w9[5]
w9[-2] # excluding the value from the second position 
w9[12] # index out of range

### Extracting values by a vector of indexes ###################################

indexes <- c(2,5,10)
w9[indexes]
w9[c(2,5,10)] # shorter version - without declaring the vector first 

indexes2 <- 2:6 # shorter version of creating a vector - the same as c(2:6)
w9[indexes2]
w9[2:6] # indicating a group of indexes - shorter version 

# WARNING! 
w9[2,5,10] # ERRPR - incorrect number of dimensions -> important later, for matrixes 
w9[c(2,5,10)] # Extracting values by a vector of indexes - correct version

### Indexing by logical values #################################################

# We declare a vector with TRUE/FALSE values with the length equal to the 
# length of the analysed vector. TRUE - show the value, FALSE - omit the value. 
# It is an important feature for the filtering. 

indexes3 <- c(T, T, T, F, T, F, F, F, F, T)
w9[indexes3]
w9[c(T, T, T, F, T, F, F, F, F, T)] # shorter version

### Indexing by names ##########################################################

vectorNamed <- c("Anna", "Smith", "46 years old")
names(vectorNamed) <- c("name", "surname", "age")

vectorNamed

vectorNamed["surname"]

### Modifying vectors ##########################################################

vectorSimple <- c(1,2,3)
vectorText <- c("a", "b")

vectorCombined <- c(vectorSimple, vectorText)
vectorCombined # combining two vectors

vectorSimple[4] <- 5 # adding new value at the new position 
vectorSimple

vectorSimple[10] <- 29 # missing indexes will be filled with NA
vectorSimple

### Tasks ######################################################################

# 1. Create a numerical value with decimal part. Convert it to integer and then
# to character. See what are the changes (in values and printing). 
a <- 2.3
is.numeric(a)
as.integer(a)
as.character(a)

# 2. Create two variables with text. Check the documentation of paste() and try
# to use it on created vectors. Compare the results of paste() function and c(). 
# What are the differences? Why?
a <- "text1"
b <- "text2"
paste(a,b)
c(a,b)

# 3. a) Convert vector vecDate <- c("09:12:12", "28:02:16", "31:05:22") to Date class. 
# HINT: DONT CHANGE ANYTHING BY HAND in the original data. Make sure to utilise function parameters. 
vecDate <- c("09:12:12", "28:02:16", "31:05:22")
convertedDates <- as.Date(vecDate, format = "%d:%m:%y")

# b) Calculate number of days between these dates and today's date.
# HINT: is there a function that will get the "today's date" automatically?
Sys.Date() - convertedDates

# 4. Create a vector "vec1" which will include numbers from 2 to 8 and from 17 to 30. 
# Use the shortest code possible.
vec1<-c(2:8,17:30)
vec1
# 5. Create a vector "vec2" with given structure: (2,  8, 14, 20, 26, 32). Use seq() function. 
vec2<-seq(2,32,6)
vec2
# 6. Create a vector with given structure: "2", "7", "a", "2", "7", "a", "2", "7", "a". TIP: rep()
vec3<-rep(c("2", "7", "a"),3)
vec3
# 7. Create a vector of length 100, which will store consecutive numbers divisible by three.
vec4 <- seq(from = 3, by = 3, length.out = 100)
vec4

# 8. Using only one line of code create a vector "vec3" with following structure:
# HINT: work smartly - if something can be done with a function or with appropriate argument of
# a fuction - use it, rather than typing it down manually.  
# (1, 1, 3, 3, 5, 5, 7, 7, 9, 9, 1, 1, 3, 3, 5, 5, 7, 7, 9, 9, 1, 1, 3, 3, 5, 5, 7, 7, 9, 9). 
vec5 <- rep(seq(1, 9, by = 2), each = 2, times = 3)
# 9. Generate a vector "vec4" of 50 numbers with the usage of runif() function. What does
# it do? Use generated numbers to create a vector of 50 random integer values from the 
# range 0-20. 
vec6<-runif(50,min=0,max=20)
vec6 <- as.integer(vec6)
# 10. Print values from the 5th, 10th and 26th element of previously created vector (from task 9).
vec6[c(5,10,26)]

# 11. Print values of every second element from the previously created vector, 
# starting from the 5th element of the vector. TIP: seq(). 
vec6[c(seq(5,50,by=2))]


### Factor #####################################################################

# Vector of factor class - stores categorical data, with given levels. 
# Levels can be ordered or unordered. It's an important datatype for 
# dividing observations into groups. 

### Unordered factor ###########################################################

?factor

variableLevel <- factor(c("boat", "car", "boat", 
                          "boat", "car", "device"), # vector with text
                        levels = c("boat", "car", "device"), # levels
                        ordered = F) # version - unordered factor
variableLevel


variableLevelBIS <- factor(c("boat", "car", "boat", 
                             "boat", "car", "device"), # vector with text
                           levels = c("boat", "car", "device"), # levels
                           labels = c("boat", "car", "device"),
                           ordered = F) # version - unordered factor
variableLevelBIS

str(variableLevel) 
# for R it is no longer a vector with text data
# this vector now stores numbers with certain labels (every level has a label)

levels(variableLevel)

### Ordered factor #############################################################

variableLevel2 <- factor(c("small", "medium", "small", "small", "medium", "big"), 
                         levels = c("small", "medium", "big"),
                         ordered = T) # ordered - ordering of levels is important

str(variableLevel2)  # Ord. factor -> factor variable with ordered levels 
levels(variableLevel2)

### Matrix #####################################################################

# Set of ordered elements of the same type in two-dimensional rectangular shape. 

elements <- c(2,7,8,11,4,1,2,3)
length(elements)

A <- matrix(elements,       # vector with elements
            nrow=2,        # number of rows
            ncol=4,        # number of columns
            byrow = TRUE)  # storing values one by one by row 

A

B <- matrix(elements,       # vector with elements
            nrow=4,        # number of rows
            ncol=2,        # number of columns
            byrow = FALSE) # storing values one by one by column  

B

C <- matrix(NA,            # creating a matrix with empty values
            nrow=3,        # of given size (dimensions)
            ncol=2)
C

D <- matrix(nrow=3, ncol=2)

# Indexing the matrix elements

# rule: matrix[RowNumber, ColNumber]
A
A[2,4]    # value from the 2nd row and 4th column 
A[2,]     # all the values from the 2nd row
A[,4]     # all the values from the 4th column 
A[1,2:3]  # values from the 1st row and columns 2nd and 3rd (range) 

# assigning values to the matrix (for given position)

C
C[1,2] <- 3
C

C[,1] <- 4 # vector of 4 (automatically setting the size - by recycling rule)
C

C[3,] <- c(9,15)
C

### List #######################################################################

# List can be seen as a more general/flexible vector, which can store 
# diversified elements. A list can store a set of vectors, matrixes, dataframes, etc. 

# List elements can have different types, sizes, lengths and number of dimensions

first <- c("I'm", "a vector", "of type", "character")
second <- c(1,7,20.5) # vector with numbers (numeric)
third <- c(TRUE, TRUE, TRUE, FALSE) # logical vector
fourth <- 0 # single number 
fifth <- matrix(5, nrow=2, ncol=3)

listObject <- list(first, second, third, fourth, fifth)

listObject

# Indexing the list elements
listObject[1] # element on the first position
listObject[[1]] # content of the element on the first position
listObject[[1]][2] # second element of the object stored at the first position of the list  
listObject[[5]][2,3] # element from the 2nd row and 3rd column of the object stored at the fifth position of the list 

# Modifying the list elements 
listObject[1] <- c("Exchanging", "first", "vector") # Error! We want to change the content
listObject[[1]] <- c("Exchanging", "first", "vector")
listObject[[5]][2,3] <- 20 # exchanging the value within the matrix stored at the fifth position 

listObject[[6]] <- c("Adding", "a new", "element")
<-
listObject

### Tasks ######################################################################

# 1. Create a factor with values "a", "b", "c" of length 7. Add labels "Letter A",
# "Letter B", "Letter C". Summarize factor values. 

# 2. Create a numeric vector with values 1-4 and length 10. You can use any function
# for creating the vector. Values can be ordered randomly. Summarize the variable 
# and check its type. Then use this vector to create an ordered factor. Set levels
# to "low" "medium" "high" "very high". Summarize the value and compare it to the initial vector. 

# 3. Create a matrix with 5 rows and 2 columns, filled with zeros. Save it to "table" 
# variable. 

matrix <- matrix(data=0,nrow=5,ncol=2)
matrix
# a) fill 1st column with values 3, 
matrix[1:5,2]<-3
# b) set 3rd element of 2nd column to 20. 
matrix[3,2]<-20
# c) Print values of the 2nd column. Check the type of the values in this column. 
# d) Change the 4th element of the 2nd column to "twelve". Print values of the 
matrix[4,2]<-"twelve"
# second column again. Check their type. What is different? 
# e) What is the type of the values of the first column? Why?
mode(Matrix)

# 4. Create four variables with different types (vectors, matrices, single values).
vector<-c(1,4,3,5,2)
Matrix4<-matrix(data=1:9,nrow=3,ncol=3)
value<-12

# Create a list out of these objects named "myList". 
myList<-list(vector,Matrix4,value)

# a) Now get the second element of the list and add an additional value to it. 
myList[[2]]<- cbind(myList[[2]], 10:12) 
myList[[2]]

# Save the change so that it will be visible in the list.
myList
# b) Add new elements at the end of the list - make it a 6-element vector of any type.
vector2<-c(1:6)
myList<-list(vector,Matrix4,value,vector2)
# c) Print the 4th element of the last object in the list. 
myList[[4]][4]
# d) Change the value of the 5th element of that last object to NA. 
myList[[4]][5]<-NA
myList[[4]][5]


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
index<-c(1:8)
name<-c("a","b","c", "d", "e", "f","g","h")
age<-c(21:28)
pet<-c("dog","cat","dog","cat","dog","cat","dog","cat")
pet.age<-c(5:12)

mySet1<-data.frame(index,name,age,pet,pet.age)
mySet1
# a) Show the 5th row of created dataframe. 

mySet1$pet.age

# b) Change the name of the second column of mySet1 dataframe to "column02"
names(mySet1)[2] <- "column02"

# c) Show 7 first rows of mySet1 dataframe. Use two different methods - with 
# indexes and with a function.
mySet1[1:7,]
head(mySet1,7)

# 2. Use iris dataset. Using indexing show values of every 3rd row between 
# 40th and 120th observations. Try to use a one-liner (shorten the code so that 
# it fits in one line only, without any intermediate steps).
iris[seq(40,120,by=3),]

# 3. Use built-in "women" dataset. 
# a) Change type of the first column to character.
women$weight<-is.character(women$height)
str(women)
# b) Add two new rows to the dataset with made-up numbers. Make sure that you 
# don't loose the types of variables in the main dataframe in the process.
  
# c) Add new variable to the dataset and name it "shoe_size". Using runif function
# create the values for this variable. Shoe size must be an integer between 35 and 42. 
women$shoe_size<-as.integer(runif(nrow(women),min=35,max=42))
women

### Data from different sources ################################################


# Absolute path, basic functions:


# file location

# Windows path: C:\Users\maria\Desktop\RIntro\data\notepadData.txt

# transformation1: C:\\Users\\maria\\Desktop\\RIntro\\data\\notepadData.txt

# transformation2: C:/Users/maria/Desktop/RIntro/data/notepadData.txt


# Reading data from txt file with basic function read.table

# checking the arguments of the function
?read.table

table1 <- read.table("C:/Users/maria/Desktop/RIntro/data/notepadData.txt", 
                     header = TRUE, sep = " ")

table1

# now we can use the data we have read
summary(table1$price)

# reading data with relative paths

# path to the data folder:  "C:/Users/maria/Desktop/RIntro/data"

# setting the 'working directory' 
setwd("C:/Users/maria/Desktop/RIntro/data")

# checking the path to the working directory 
getwd()

# location can be stored with a text variable which stores the path to the folder
locationWD <- c("C:/Users/maria/Desktop/RIntro")

setwd(locationWD)

getwd() # we get the same result

# now we can use the relative paths:

table1a <- read.table("data/notepadData.txt", 
                      header = TRUE, sep = " ")

table1a # success! the same table has been read

# path location can be chosen with the interactive function file.choose()

table1b <- read.table(file.choose(), header = TRUE, sep = " ")
table1b

### Reading data of other types ################################################

# reading the csv file with read.csv() function

water <- read.csv("data/dataset - water quality/water_potability.csv", sep = ";", dec=".")

# good practice! always glimpse at the data that you have just read
# check if they are read in the proper format 
head(water)

# Problem! there was a wrong separator chosen 

water <- read.csv("data/dataset - water quality/water_potability.csv", sep = ",", dec=".")

head(water) # now the data looks properly

# reading data from Excel file with read_excel function

# staring with installing the new package
install.packages("readxl")

# loading it to the current R session
# now its functions will be available in this R session
library(readxl)

?read_excel

# automatic loading of the first sheet 
loanEXCEL1 <- read_excel("data/dataset - loan prediction/loan_prediction_excel.xlsx")
loanEXCEL1

loanEXCEL2 <- read_excel("data/dataset - loan prediction/loan_prediction_excel.xlsx", sheet = 2)
loanEXCEL2

loanEXCEL3 <- read_excel("data/dataset - loan prediction/loan_prediction_excel.xlsx", sheet = "LoanPred")
loanEXCEL3

class(loanEXCEL1) # to tibble - specific data types, extending the data.frame possibilities

loanEXCEL1 <- as.data.frame(loanEXCEL1)
class(loanEXCEL1)

# cleaning the environment from unnecessary files - function remove()
remove(loanEXCEL3)
loanEXCEL3 # reading error: this object is no longer available in the memory

### Saving and reading R objects ###############################################

# Saving and reading objects between R sessions 

ls() # listing all the objects loaded in the memory 

# saving all loaded objects to the file (to use them in the next session)
save(list = ls(all.names = TRUE), file= "data/all.rda")

rm(list = ls(all.names = TRUE)) # cleaning the whole memory

loanEXCEL1 # lack of object

load("data/all.rda")

loanEXCEL1 # object read again 

# saving single object to a file  
save(loanEXCEL1, file = "data/loanEXCEL_inR.rda")

rm(loanEXCEL1)

head(loanEXCEL1)

load("data/loanEXCEL_inR.rda")

head(loanEXCEL1)

# saving a few objects -> to the RData file
save(loanEXCEL1, loanEXCEL2, file = "data/loanEXCEL12_inR.RData")
load("data/loanEXCEL12_inR.RData")


rm(list = ls(all.names = TRUE)) # cleaning the enviroment

################################################################################
### Cleaning data - case study #################################################

# Loading data and reviewing its overall structure

alcohol <- read.csv("data/dataset - student alcohol consumption/student-alcohol.csv")
head(alcohol)
str(alcohol)

# The first column is simply an index - it can be removed

head(alcohol[,-1]) # omit the first column

alcohol <- alcohol[,-1] # overwriting the object

# Revisiting the structure

str(alcohol)
summary(alcohol)
# lots of text variables that should be converted to 'factor'
# there are also numeric variables that are also factors

### 1. Missing data ############################################################

# is there missing data?
alcohol[!complete.cases(alcohol),]

# age and Mjob variables

summary(alcohol$age)
median(alcohol$age)

median(alcohol$age, na.rm = TRUE)

# Filling in with median

alcohol$age[is.na(alcohol$age)] <- median(alcohol$age, na.rm = TRUE)

# Check if there are any missing observations left
alcohol$age[is.na(alcohol$age)]

# Which date still needs to be completed?
alcohol[!complete.cases(alcohol),] # MJob in line 63

# What values does mjob take
summary(alcohol$Mjob)

summary(factor(alcohol$Mjob))
# The missing value can be filled in by the most frequent observation or the overall level - here 'other'

alcohol$Mjob[63]
alcohol$Mjob[63] <- 'other'

# Are there any more missing dates?
alcohol[!complete.cases(alcohol),] # No - zero rows

### 2. Transforming categorical data ###########################################
str(alcohol)

# School
# check if there are no errors in the labels
summary(factor(alcohol$school))
alcohol$school <- factor(alcohol$school, levels = c("GP", "MS"), 
                         labels = c("Gabriel Pereira", "Mousinho da Silveira"))

# Sex
summary(factor(alcohol$sex))
alcohol$sex <- factor(alcohol$sex, levels = c("F", "M"), 
                      labels = c("female", "male"))
# Address
summary(factor(alcohol$address))
alcohol$address <- factor(alcohol$address, levels = c("R", "U"), 
                          labels = c("rural", "urban"))

# Family size
summary(factor(alcohol$famsize))
alcohol$famsize <- factor(alcohol$famsize, levels = c("GT3", "LE3"), 
                          labels = c("more than 3", "less or equal to 3"))

# Parent's cohabitation status
summary(factor(alcohol$Pstatus))
alcohol$Pstatus <- factor(alcohol$Pstatus, levels = c("A", "T"), 
                          labels = c("living apart", "living together"))

# Mother's education
# Pierwszy factor zapisany liczbami
summary(factor(alcohol$Medu))
alcohol$Medu <- factor(alcohol$Medu, levels = c(0, 1, 2, 3, 4), 
                       labels = c("none", "primary",
                                  "primary higher", "secondary",
                                  "higher"), ordered = TRUE)
# Father's education
summary(factor(alcohol$Fedu))
alcohol$Fedu <- factor(alcohol$Fedu, levels = c(0, 1, 2, 3, 4), 
                       labels = c("none", "primary",
                                  "primary higher", "secondary",
                                  "higher"), ordered = TRUE)
# Reason to choose this school
summary(factor(alcohol$reason))
alcohol$reason <- factor(alcohol$reason)

# Checking the structure after the first corrections
str(alcohol)
summary(alcohol)

# Guardian
summary(factor(alcohol$guardian))
alcohol$guardian <- factor(alcohol$guardian)

# Travel time
summary(alcohol$traveltime)
summary(factor(alcohol$traveltime))

#numeric: 1 - <15 min., 2 - 15 to 30 min., 3 - 30 min. to 1 hour, or 4 - >1 hour

alcohol$traveltime <- factor(alcohol$traveltime, levels = c(1, 2, 3, 4), 
                             labels = c("0-15 min", "15-30 min",
                                        "30-60 min", "above 60 min"),
                             ordered = TRUE)

# Study time
summary(alcohol$studytime)
summary(factor(alcohol$studytime))

# 1 - <2 hours, 2 - 2 to 5 hours, 3 - 5 to 10 hours, or 4 - >10 hours) 

alcohol$studytime <- factor(alcohol$studytime, levels = c(1, 2, 3, 4), 
                            labels = c("0-2 hours", "2-5 hours",
                                       "5-10 hours", "above 10 hours"),
                            ordered = TRUE)

# School support
summary(factor(alcohol$schoolsup))
alcohol$schoolsup <- factor(alcohol$schoolsup, levels = c("no", "yes"))

# other variables with the same structure - we will try to automate this

# 16.	schoolsup - extra educational support (binary: yes or no) 
# 17.	famsup - family educational support (binary: yes or no) 
# 18.	paid - extra paid classes within the course subject (Math or Portuguese) (binary: yes or no) 
# 19.	activities - extra-curricular activities (binary: yes or no) 
# 20.	nursery - attended nursery school (binary: yes or no) 
# 21.	higher - wants to take higher education (binary: yes or no) 
# 22.	internet - Internet access at home (binary: yes or no) 
# 23.	romantic - with a romantic relationship (binary: yes or no) 

binaryVariables <- c('famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic')

# Levles overview:

lapply(alcohol[,binaryVariables], summary)


lapply(alcohol[,binaryVariables], function(x){summary(factor(x))})

# Problem with variable internet - many levels, database errors

# We will start with levels stored using numbers:
alcohol$internet[alcohol$internet==0]
alcohol$internet[alcohol$internet==0] <- "no"

alcohol$internet[alcohol$internet==1] 
alcohol$internet[alcohol$internet==1] <- "yes"

summary(factor(alcohol$internet))

# Problem with levels written in capital letters
alcohol$internet <- tolower(alcohol$internet) 

summary(factor(alcohol$internet)) 
# The levels are already in homogeneous form

# We check again whether the variables are suitable for conversion:
lapply(alcohol[,binaryVariables], function(x){summary(factor(x))})

alcohol[,binaryVariables] <- lapply(alcohol[,binaryVariables], factor, levels = c("no", "yes"))

str(alcohol)

# Conversion of other variables

# Quality of family relations
summary(alcohol$famrel)
summary(factor(alcohol$famrel))

alcohol$famrel <- factor(alcohol$famrel, levels = c(1, 2, 3, 4, 5), 
                         labels = c("very bad", "bad", "average",
                                    "good", "excellent"),
                         ordered = TRUE)

# A group of variables with the same record:

# 25.	freetime - free time after school (numeric: from 1 - very low to 5 - very high) 
# 26.	goout - going out with friends (numeric: from 1 - very low to 5 - very high) 
# 27.	Dalc - workday alcohol consumption (numeric: from 1 - very low to 5 - very high) 
# 28.	Walc - weekend alcohol consumption (numeric: from 1 - very low to 5 - very high) 

leveledVariables <- c("freetime", "goout", "Dalc", "Walc")

# Checking levels:

lapply(alcohol[,leveledVariables], summary)

lapply(alcohol[,leveledVariables], function(x){summary(factor(x))})
# everything looks good


# Conversion to an ordered class of a categorical variable:

alcohol[,leveledVariables] <- lapply(alcohol[,leveledVariables], factor, 
                                     levels = c(1, 2, 3, 4, 5), 
                                     labels = c("very low", "low", "average",
                                                "high", "very high"),
                                     ordered = TRUE)
str(alcohol)

# The last categorical variable
# Current health status:

# numeric: from 1 - very bad to 5 - very good
summary(alcohol$health)
summary(factor(alcohol$health))

alcohol$health <- factor(alcohol$health, levels = c(1, 2, 3, 4, 5), 
                         labels = c("very bad", "bad", "average",
                                    "good", "very good"),
                         ordered = TRUE)

str(alcohol)


setwd("/Users/aleksandrastawicka/Downloads")


### Tasks ######################################################################

# 1. read the description of the clients' personality analysis data and load it 
# into R (clients.csv file) as a variable named "clients". 
clients<-read.csv("clients.csv")

# 2. preview the structure of the data and check what classes have been assigned 
# to the variables in question.
head(clients)

# 3. Check if there are any missing observations in the set. 
# a) Which variables include missing values?
clients[is.na(clients)]
colSums(is.na(clients))
# b) Input the missing values with the mean or median value from the variable.
clients$Variable[is.na(clients$Variable)] <- round(mean(clients$Variable, na.rm = TRUE))

# Before completing the values, consider what values the variable takes. 
# If they are numbers, are they integers (e.g. year of birth)? If so, complete 
# these values according to the nature of the variable (we don't want the year 
# 1995.832, do we? ;)).
# c) What code do you use to fill the missing values of Year_Birth (if any)?
clients$Year_Birth[is.na(clients$Year_Birth)]<-round(mean(clients$Year_Birth, na.rm = TRUE))

# 4. a) Check that all missing observations have been completed. If not, repeat step 3. 
colSums(is.na(clients))
# b) What code would you use to show all the rows which still have some missing data?
clients[!complete.cases(clients),]
# 5. a) Consider which variables are worth converting to a "factor" type? 
# Hint: these will usually be text variables with a few specific, recurring 
# values. They can also be variables that are represented by numbers, but do 
# not have a "numerical sense" - e.g. the variable "education" and the values 
# 2, 3, 4, which actually represent successive stages of education (logical sense) 
# rather than the exact number of years of education (numerical sense). 

# b) What code would you use to transform the Marital_Status variable (shortest code possible)?
clients$Marital_Status<-as.factor(clients$Marital_Status)

# 6. a) Consider which of the previously identified variables would be worth 
# converting to an 'ordered factor' type (ordered categorical variable).
# Hint: An 'ordered factor' type variable should contain a logical order of 
# levels - e.g. an 'education' variable with values of 'primary', 'secondary' 
# and 'tertiary'. In this case, it may be worthwhile to keep the different 
# levels in order. Another typical example of an ordered factor variable is survey 
# responses recorded using a Likert scale (https://en.wikipedia.org/wiki/Likert_scale). 

# b) What code would you use to transform the Education variable? Let's assume that 
# 2n means secondary education and graduation is equal to BA defence.
clients$Education<-factor(clients$Education,levels=c("Basic","2n Cycle","Graduation","Master","PhD"),ordered=TRUE)
# 7. Transform the variables identified in steps 5 and 6 into the appropriate classes.

# 8. Save results for future reference! Use an RData file with name "clientsInR".

### Basic statistics ###########################################################

water <- read.csv("data/graphics - water quality/water_potability.csv", sep = ",", dec=".")
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
setwd("/Users/aleksandrastawicka/Downloads")
life<-read.csv("Life Expectancy Data.csv")

# b) Preview its structure and summarise the values (two lines of code).
str(life)
summary(life)

# c) Filter the dataset - show data for 2013 only (use the $ notation where you can).
life$Year[2013]summary(life[life$Year==2013,])
# Summarize the values of the subset (summary()) without saving the data to a 
# separate intermediate variable.
median(life$Life.expectancy[life$Status == "Developing" & life$Year == 2010], na.rm = TRUE)
# d) Calculate median of life.expectancy for Developing Countries (status variable) 
# in 2010. Use only one line of code, with no intermediate objects. Get the numerical result.
median(life$Life.expectancy[life$Status=="Developing"&life$Year==2010],na.rm=TRUE)

# e) What the average Polio vaccination share was over the world in the year 2014?
mean(life$Polio[life$Year==2014],na.rm=TRUE)

# 2. a) Create a subset of "life" dataset for year 2008 only, name it life2008.
life2008<-life[life$Year==2008,]

# b) Remove rows which include missing values from your dataset.
life2008 <- na.omit(life2008)

# c) Build a linear model for the "life2008" dataset, in which the dependent (y) variable
# will be the GDP, and the regressors (x) will be Polio, Alcohol and infant.deaths
# (in that order). Name the output object model2008.
model2008<-lm(GDP~Polio+Alcohol+infant.deaths,data=life2008)

# d) Check the summary of the modelling results and the structure of output.
summary(model2008)
str(model2008)
# e) Print out the coeficient for infant.deaths (use $ notation where possible).
model2008<-lm(GDP~Polio+Alcohol+infant.deaths,data=life2008)


# f) Calculate the variance of the absolute difference between real GDP values 
# and the values fitted by your model (fitted.values element). Hint: use abs() function.
var(abs(life2008$GDP-model2008$fitted.values))

### Preparing for graphics creation ############################################

# Reading the data
getwd() # is the path set right?
#setwd() # change if necessary

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
hist(USArrests$Assault)
# b) Add labels above the bins (check the documentation)
hist(USArrests$Assault)->h;text(h$mids,h$counts,labels=h$counts,pos=3)
# c) Add a title "USA assault distribution" to the plot created in point 1a).
title(main="USA assault distribution")

# 2. a) Load the insurance.csv dataset into R (medical cost folder) and name it 
# insurance. Check if data is properly loaded and the types of variables are correct.
setwd("~/Downloads")
insurance<-read.csv("insurance.csv")
str(insurance)
# b) Convert sex variable into factor type.
insurance$sex<-as.factor(insurance$sex)
# c) Do the same to the smoker and region variables.
insurance$smoker<-as.factor(insurance$smoker)
insurance$region<-as.factor(insurance$region)

# 3. a) Using the insurance dataset prepare a correlation graph between age, 
# bmi and charges. When calling the columns use the indexing by column names. 
# Make it so that your graph is created by only one line of code. Use the 
# default parameters of corrplot function (don't change anything yet).
# Hint: use the corrplot() function from the corrplot package. You can assume
# that corrplot package in loaded in R.
# Hint 2: remember to draw the graph from the correlation table 
#made with the cor() function.
library(corrplot)
corrplot(cor(insurance[,c("age","bmi","charges")]))
?cor
# b) Arrange the variables on the graph using the order given by hierarchical
# clustering algorithm (hclust).
corrplot(cor(insurance[,c("age","bmi","charges")]),order="hclust")
# c) Modify the plot that was created in b). Change the area of the graph so 
# that the lower triangle shows the numerical values and the upper triangle 
# shows the representation using circles. 
# Hint: look at the function corrplot.mixed(). 
?corrplot.mixed
corrplot.mixed(cor(insurance[,c("age","bmi","charges")]),lower="number",upper="circle",order="hclust")
# d) Prepare a boxplot of the variable charges by region. Change the axis 
# titles to "Medical charges" and "Region"
?boxplot
boxplot(charges~region,data=insurance,ylab="Medical charges",xlab="Region")
# e) Modify the boxplot and add more styling to it. Name the axis, change 
# color of the elements, etc. Play with the arguments of plot function.

### Preparing for graphics creation ############################################

# Reading the data
getwd() # is the path set right?
#setwd() # change if necessary

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

View(lifePLDE)

### Editing the graph ##########################################################

# Adding layers - step by step method


### 1st plot
# First layer - life expectancly plot in Poland
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"])

### 2nd plot
# Adding a second layer - plot with life expectancy in Germany 

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"])
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"])

### 3rd plot
# Improving the range so that the line is visible 
# we need to change the first/original plot, as it dictates
# what happens in the plotting window

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90))
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"])

### 4th plot
# Changing the plot type to lines and changing the line styling

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)

### 5th plot
# Adding a legend

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))

### 6th plot
# Chaning the axis titles

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))

### 7th plot 
# Adding a title

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))
title("Life expectancy in Poland and in Germany")

### 8th plot 
# Adding a vertical line
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))
title("Life expectancy in Poland and in Germany")
abline(v = 2004)

### 9th plot
# Line modification and adding a text note
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))

### 10th plot
# Adding an arrow
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4)
legend("topleft", c("Poland", "Germany"), lty = c(2,4))
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")

### 11th plot
# Changing the line colour

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3")
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, col = "mediumpurple3")
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3")) 
#zmiana kolorów również w legendzie
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")

### 12th plot
# Changing the line thickness

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =c(2)) 
#changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")

### 13th plot
# Adding a point

max(lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"]) #89
lifePLDE[lifePLDE$Life.expectancy==89,"Year"] #2014

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
#changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23)

### 14th plot
# Changing the features of the point

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
#changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23, col = "blue4", bg = "blue2", cex = 2)

### 15th plot
# Changing the rotation of axis labels 

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2, las = 2)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
#changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23, col = "blue4", bg = "blue2", cex = 2)

### 16th plot
# Changing the style of lables and their placing (align to left)

plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2, las = 2,
     font.lab = 3, adj = 0)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
#changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23, col = "blue4", bg = "blue2", cex = 2)

### Exporting the plot #########################################################

# In RStudio -> export button, in the header of the graphics area
# With functions: 

# 1. Creating the file for saving
jpeg("Life expectancy plot", width = 765, height = 555)

# Possible file extentions:
# pdf(“rplot.pdf”): file pdf
# png(“rplot.png”): file png
# jpeg(“rplot.jpg”): file jpeg
# postscript(“rplot.ps”): file postscript 
# bmp(“rplot.bmp”): file bmp (bitmap) 
# win.metafile(“rplot.wmf”): windows metafile

# 2. Creating the graphics
plot(lifePLDE[lifePLDE$Country=="Poland", "Year"], 
     lifePLDE[lifePLDE$Country=="Poland", "Life.expectancy"], ylim = c(73,90), 
     type = "l", lty = 2,
     xlab = "Year", ylab = "Life expectancy", col = "mediumorchid3", lwd = 2, las = 2,
     font.lab = 3, adj = 0)
lines(lifePLDE[lifePLDE$Country=="Germany", "Year"], 
      lifePLDE[lifePLDE$Country=="Germany", "Life.expectancy"], lty = 4, 
      col = "mediumpurple3", lwd=2)
legend("topleft", c("Poland", "Germany"), lty = c(2,4), 
       col = c("mediumorchid3", "mediumpurple3"), lwd =2) 
#changing the line thickness in the legend as well
title("Life expectancy in Poland and in Germany")
abline(v = 2004, lty = 3, col = "lightblue4")
text(2002, 76.5,labels = c("Poland in EU"))
arrows(2002, 76, 2004, 75, col = "lightskyblue3")
points(x = 2014, y = 89, pch = 23, col = "blue4", bg = "blue2", cex = 2)

# 3. Closing the file
dev.off()

# Source: http://www.sthda.com/english/wiki/creating-and-saving-graphs-r-base-graphs

### Using colour palettes in R #################################################

barplot(1:10, col = "blue")

# Built-in palettes
paletteRainbow <- rainbow(10)

barplot(1:10, col = paletteRainbow)

barplot(1:10, col = terrain.colours(3)) # shorter vector of colours will be reused (recycling rule!)

# palette virdis
#install.packages("viridis")
library("viridis")

barplot(1:10, col = viridis(5)) 
legend("topleft", legend = c(1:10), fill = viridis(5)) 

barplot(1:10, col = viridis(10)) 
legend("topleft", legend = c(1:10), fill = viridis(10)) # using the palette in legend

# palette Wesanderson
#install.packages("wesanderson")
library(wesanderson)

barplot(1:10, col = wes_palette("Royal2", 5, type = c("discrete"))) 
# consecutive colours from a palette - reused, twice

barplot(1:10, col = wes_palette("Royal2", 10, type = c("continuous"))) 
# colour gradient between colours of the original paletter

# palette RcolourBrewer
#install.packages("RColorBrewer")
library(RColorBrewer)

display.brewer.all(colourblindFriendly = TRUE)

paletteBrewer1 <- brewer.pal(n = 10, name = "Set2")
# impossible - to little colours in the palette

paletteBrewer <- brewer.pal(n = 10, name = "Paired")
# choosing a longer palette 

barplot(1:10, col = paletteBrewer)

# If we need more colours it's better to choose continuous palettes 
# like viridis or wesanderson 

### Modification of the plotting field #########################################

# Plotting plots next to each other 

par(mfrow = c(1, 2)) # one row, two columns (like in matrix indexing) 
barplot(1:5)
plot(1:10)

# adding a common title 
barplot(1:5)
plot(1:10)
mtext("Two plots with one title", outer = TRUE)

# The title is invisible so far - we need to change the plot margins 
# and increase the margin above the text 
par(mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
barplot(1:5)
plot(1:10)
mtext("Two plots with one title", outer = TRUE)

# Changing the layout
par(mfrow = c(2, 1)) # two rows, one column
barplot(1:5)
plot(1:10)

# Resetting to the default parameters - one plot per window
par(mfrow = c(1,1))

# or -> (in R Studio) - resetting the graphical environment
dev.off() # helpful if there are some issues with resetting the default parameters

barplot(1:5)


### Tasks ######################################################################

# 1. a) Using USArrests data (built-in dataset) draw a histogram to show the 
# distribution of the Murder variable.
# b) Select the Zissou1 palette from wesanderson and use a vector of 10 continuous 
# colours from this set to change the colour of the histogram bars.
# When submitting the answer you can assume that the package is already loaded.
# a) & b) Murder histogram with 10 continuous Zissou1 colors
install.packages("wesanderson")
library(wesanderson)

cols_murder <- wes_palette("Zissou1", 10, type = "continuous")
hist(USArrests$Murder, 
     col = cols_murder, 
     main = "Distribution of Murder", 
     xlab = "Murder Rate")
# c) Create a histogram for the Rape variable and color the bins with Moonrise1
# palette - discrete colours, vector with 4 colours, that will be reused in the plot.
cols_rape <- wes_palette("Moonrise1", 4, type = "discrete")
hist(USArrests$Rape, 
     col = cols_rape, 
     main = "Distribution of Rape", 
     xlab = "Rape Rate")
# d) Change the graphical environment settings (two columns, one row)
par(mfrow=c(1,2))

# e) Draw the two graphs side by side. 
# f) reset the graphical environment
par(mfrow = c(1, 1))

# 2. a) Load the insurance.csv dataset into R (medical cost folder) and name it 
# insurance. Check if data is properly loaded and the types of variables are correct.
# Convert sex, smoker and region variables into factor type.
# b) Prepare a boxplot of the variable charges by region. Change the axis 
# titles to "Medical charges" and "Region"
boxplot(charges~region,data=insurance,xlab="Region",ylab="Medical charges")

# c) Change the colour of the 'boxes' according to the region and add an 
# appropriate legend. Use a palette viridis with 4 discrete colors. You can assume
# that the viridis package is loaded when submitting the answer.
cols<-viridis(4,option="D")
boxplot(charges ~ region, data = insurance, col = cols,
        xlab = "Region", ylab = "Medical charges")

install.packages("viridis")
# d) Create a legend in the topright corner of the plot. Name the elements exactly
# as the names of the categories are shown in your plot. Hint: you can use the levels()
# function to get the names automatically.
# Make sure that the colours of your legend match the colours of the boxes.
# When submitting the answer provide just the line of code with legend creation.
legend("topright",legend=levels(insurance$region),fill=cols)

# 3. a) Load the Tokyo 2021 dataset dataset from the olympic games folder 
# and store it in the games variable.
games <- read.csv("Tokyo 2021 dataset.csv")

# b) We will prepare a bar chart showing, in sequence, the ten countries that 
# have won the most silver Olympic medals. Start by creating a new dataset "silver10"
# that will store the 10 countries that have won the most Silver medals,
# and order that dataset by the Silver.Medal variable in decreasing order. First
# create a dataset sorted by the Silver Medal variable, and then limit it 
# to the first 10 observations only. Try to combine these steps and to this
# operation in one line only. Submit the shortest code that works for you.
silver10<-head(games[order(-games$Silver.Medal),],10)

# c) Using function barplot prepare a plot for the Silver Medal variable.
barplot(silver10$Silver.Medal)

# d) Add lables under the bars (check the names.arg parameter in the barplot function)
# For the labels use the values of NOCCode function.
barplot(silver10$Silver.Medal,names.arg=silver10$NOCCode)

# e) Add title "Top 10 silver medals".
barplot(silver10$Silver.Medal,names.arg=silver10$NOCCode,main="Top 10 silver medals")

# f) Modify the style of the text, change the axis title. Add a chosen colour 
# palette and make the plot more interesting. Play with modification of different 
# plot elements. Export your plot to png file and name it by your 
# student ID number. Submit that plot to the test :)
# f) Modify plot style, text, axis labels, colors, etc.
png("top10_silver_medals.png", width = 900, height = 600)

barplot(
  height = silver10$Silver.Medal,
  names.arg = silver10$NOCCode,
  col = viridis::viridis(10),       # colour palette
  main = "Top 10 Silver Medals",
  xlab = "Country (NOC Code)",
  ylab = "Number of Silver Medals",
  cex.main = 1.8,                   # bigger title
  cex.names = 1.2,                  # bigger x-axis labels
  cex.lab = 1.4,                    # bigger axis titles
  border = NA,                      # remove border of bars
  las = 2                           # rotate labels for readability
)

grid()  # optional grid for aesthetics

dev.off()

### Functions ##################################################################

# Own functions - allow you to add new features into R, that suit your needs best

# Example - calculating the range of a variable

max(iris$Sepal.Length) - min(iris$Sepal.Length)
max(iris$Sepal.Width) - min(iris$Sepal.Width)
max(iris$Petal.Length) - min(iris$Petal.Length)
max(iris$Petal.Width) - min(iris$Petal.Width)

# We are calculating the same result many times. We can wrap it up in a function:

### My first function ##########################################################

myRange <- function(variable){ # myRange is the name of our function
  # we have one argument that we can pass to our function, its "variable"
  
  rangeNum <- max(variable) - min(variable) # what this function is doing
  
  return(rangeNum) # we return the results of the operation
}

# We need to run the function code to compile it and make it usable.

myRange(iris$Sepal.Length)
# operation result is now shown in the console

rangeSepalLength <- myRange(iris$Sepal.Length) # we can save the result to new variable
rangeSepalLength

### Adding more controls #######################################################

# Easily we can add more control to our functions:

myRange2 <- function(variable, missingRemove = TRUE){ # myRange2 is the name of our function
  # we have two arguments now, the second one has the default value set to TRUE
  
  rangeNum <- max(variable, na.rm = missingRemove) - min(variable, na.rm = missingRemove) 
  # what this function is doing; now we are using both arguments, to extend
  # the control on our results
  
  return(rangeNum) # we return the results of the operation
}

newVector <- c(seq(1,20,4),NA)
newVector

myRange(newVector) # problem with the missing value

myRange2(newVector, missingRemove = TRUE)
myRange2(newVector) # we can skip the definition of missingRemove argument 
# the default value will be used there

# Now we can use our function eg. in lapply operations

lapply(iris[,1:4], myRange) # automatically calculate the range

lapply(iris, myRange) # error... our function is not robust to text or factor data
lapply(iris, myRange2) # the same here

### If statements - if you need more control, then... ##########################

# If statements allow you to modify your code depending on some logical conditions

# 1) TRUE FALSE values:
logicalVector <- c(T, F, T, T, F)

counter <- 0
for (i in 1:length(logicalVector)){
  
  if(logicalVector[i]){ 
    # we only execute this code if the condition is satisfied 
    # so -> when we have TRUE value in the brackets
    counter <- counter + 1
  }
}

print(counter) # 3 - there were 3 TRUE values, so the counter increased by 3

# 2) Conditional statement
numberVector <- c(3, 6, 7, 2, 8)

counter <- 0
for (i in 1:length(numberVector)){
  
  print(i) # here you can see how the iterator goes
  # having some prints when building your loop is great for debugging
  # just remember to remove them after you're done ;)
  # print() - good for debugging, bad for the console visibility :)
  
  if(numberVector[i] > 5){ 
    # we only execute this code if the condition is satisfied 
    # so -> when we have TRUE value in the brackets
    counter <- counter + 1
  }
}

print(counter) # 3 - there were 3 values above 5, so the counter increased by 3

# 2b) Conditional statement - iterating through a vector
numberVector <- c(3, 6, 7, 2, 8)

counter <- 0
for (valueInVector in numberVector){ 
  # our iterator now goes through values of the numberVector
  
  print(valueInVector) # here you can see how the iterator goes
  
  if(valueInVector > 5){ 
    # we only execute this code if the condition is satisfied 
    # so -> when we have TRUE value in the brackets
    counter <- counter + 1
  }
}

print(counter) # 3 - there were 3 values above 5, so the counter increased by 3

### Adding if statements to the function flow ##################################

myRange3 <- function(variable, missingRemove = TRUE){ 
  
  if(!is.numeric(variable)){ # conditional statement
    # if it happens to be true (variable is not numeric) we run this code here:
    
    return(NA) # value NA will be returned 
  }
  
  rangeNum <- max(variable, na.rm = missingRemove) - min(variable, na.rm = missingRemove) 
  
  return(rangeNum) # we return the results of the operation
}


lapply(iris[,1:4], myRange3) # all good here for numerical data

lapply(iris, myRange3) # no error here! function is more robust now

### Using next and break #######################################################

numberVector <- c(3, 6, 7, 2, 8)


# 1) next - skipping the iteration

counter <- 0
for (valueInVector in numberVector){ 
  # our iterator now goes through values of the numberVector
  
  #print(valueInVector) # here you can see how the iterator goes
  
  if(valueInVector > 5) {
    cat("What are we skipping? ", valueInVector, "\n")
    # cat function is helpful for writing debugging messages as well
    # check its documentation to now more :)
    next 
  }
  
  # if(valueInVector > 5) next # you can also write it in one line 
  
  cat("Which values we are actually considering? ", valueInVector, "\n")
  counter <- counter + 1
}

print(counter) # 2 - the counter increased by 2 because we only did two iterations
# the rest has been skipped, as values were higher than 5 

# 2) break - exiting the loop

counter <- 0
for (valueInVector in numberVector){ 
  # our iterator now goes through values of the numberVector
  
  #print(valueInVector) # here you can see how the iterator goes
  
  if(valueInVector > 6.5) {
    cat("Where are we exiting? ", valueInVector, "\n")
    break 
  }
  
  cat("Which values we are actually considering? ", valueInVector, "\n")
  counter <- counter + 1
}

print(counter) # 2 - the counter increased by 2 because we only did two iterations
# and then the loop has ended by the break instruction

### Tasks ######################################################################

# 1. Write your own function "max75" that returns the 75% of the maximum value of a 
# given variable. You can assume that the variable is a numeric. Use the name 
# maximum75 for the temporary calculations done in the function.

# Use the template:

max75 <- function(x){           # 1-definition
  maximum75 <- max(x) * 0.75  # 1-operation
  return(maximum75)      
}

# 2. Modify the loop so that it prints out only the values divisible by 3. 
# TIP: check out the %% symbol :)

for(j in seq(2,20,4)){
  if(j %% 3 == 0) { 
    print(j)
  }
}

# 3. Using the "next" instruction write a loop which will print out only the
# text values longer than 5 characters.
textVector <- c("Anna", "longitude", "bike", "car", "Sandra") 

for(text in textVector){
  if(nchar(text) <= 5) next
  print(text)
}

# 4. You have a matrix like so:
myMatrix <- matrix(NA, nrow=10, ncol=10)
myMatrix

# a) Create a loop which will go by row and fill in the values to look like this:
#      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]    1    2    3    4    5    6    7    8    9    10
# [2,]    1    2    3    4    5    6    7    8    9    10
# [3,]    1    2    3    4    5    6    7    8    9    10
# [4,]    1    2    3    4    5    6    7    8    9    10

# Use the following template:
for(row in 1:nrow(myMatrix)){
  myMatrix[row, ] <- 1:ncol(myMatrix) 
}

# b) Write a loop which will reassign the values within myMatrix to look like this:
#       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]     2    3    4    5    6    7    8    9   10    11
# [2,]     3    4    5    6    7    8    9   10   11    12
# [3,]     4    5    6    7    8    9   10   11   12    13
# [4,]     5    6    7    8    9   10   11   12   13    14
# [5,]     6    7    8    9   10   11   12   13   14    15
# [6,]     7    8    9   10   11   12   13   14   15    16
# [7,]     8    9   10   11   12   13   14   15   16    17
# [8,]     9   10   11   12   13   14   15   16   17    18
# [9,]    10   11   12   13   14   15   16   17   18    19
# [10,]   11   12   13   14   15   16   17   18   19    20

# Use the following template:
for(row in 1:nrow(myMatrix)){
  for(col in 1:ncol(myMatrix)){
    myMatrix[row, col] <- row + col 
  }
}

# c) Write a loop similar to the one in b) that will now reassign the values of 
# the matrix to look like this

#       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]    1    2    3    4    5    6    7    8    9    10
# [2,]    2    4    6    8   10   12   14   16   18    20
# [3,]    3    6    9   12   15   18   21   24   27    30
# [4,]    4    8   12   16   20   24   28   32   36    40
# [5,]    5   10   15   20   25   30   35   40   45    50
# [6,]    6   12   18   24   30   36   42   48   54    60
# [7,]    7   14   21   28   35   42   49   56   63    70
# [8,]    8   16   24   32   40   48   56   64   72    80
# [9,]    9   18   27   36   45   54   63   72   81    90
# [10,]   10   20   30   40   50   60   70   80   90   100

for(row in 1:nrow(myMatrix)){
  for(col in 1:ncol(myMatrix)){
    myMatrix[row, col] <- row * col
  }
}

# 5. Write a function myMulti which will create a matrix with multiplication 
# table of size n x n, where n will be the argument of your function.

# Use the following template for writing your answer:
myMulti <- function(n) { 
  myMatrix <- matrix(NA, nrow = n, ncol = n)
  for(row in 1:n) {
    for(col in 1:n) {
      myMatrix[row, col] <- row * col
    }
  }
  return(myMatrix)
}

# 6. Write a function which will take a text vector of package names from CRAN
# and will check if they are installed. If not - it will install them and load them,
# and if they are already installed - the function will just load them. 
smartLoad <- function(pkgVector) {
  for(pkg in pkgVector) {
    if(!require(pkg, character.only = TRUE)) {
      install.packages(pkg)
      library(pkg, character.only = TRUE)
    } else {
      # Package is already loaded by require()
      message(paste(pkg, "is already installed and loaded."))
    }
  }
}
smartLoad("ggplot2")
# Example usage:
# smartLoad(c("ggplot2", "wesanderson"))


### Getting into the tidyverse #################################################

library(tidyverse) # loading a full set of all tidyverse packages

library(dplyr) # data manipulation package -> the only one we need today 

# Read life expectancy data
# You can use a standard function read.csv

life <- read.csv("data/dataset - life expectancy/Life Expectancy Data.csv")
head(life)
class(life) # data.frame format

# Or load readr package and use read_csv function

library(readr)
life <- read_csv("Life Expectancy Data.csv")

# this function is definitely louder! It gives you much more feedback on the 
# things that happen in the background. This can be a good or a bad thing :)
# You can also make it "quieter" by using suppressMessages function

life.readr <- suppressMessages(read_csv("Life Expectancy Data.csv"))

head(life.readr) # new way of printing data! 
class(life.readr) # tibble class, which extends the possibilities of a data.frame

# We can use glimpse function to learn more about the data structure

glimpse(life.readr)
glimpse(life)

# You can easily transform a data.frame to a tibble

life2 <- as_tibble(life) # see how the underscore is used here instead of a dot!
# This is a common thing in tidyverse packages, underscore _ is used to specify
# the general family of functions that a method belongs to.

head(life2) # now our dataset is a tibble, its way of printing changes

### Dplyr - general info #######################################################

# The package dplyr contains functions for efficient processing
# of data in R - they work very fast also on large datasets

# That's why the package is currently a standard in the R-world
# and is a part of "tidyverse" - the universe of packages 
# developed by RStudio (for more information https://www.tidyverse.org/).

# The dplyr package tries to follow SQL language scheme.

# Let's get to some basic functions:
# - filter() - is used to select observations that meet
#               the specified conditions,
# - select() - select columns,
#    inside select() one can use:
#         contains()
#         starts_with()
#         ends_with()
# - rename() - allows you to rename columns,
# - arrange() - is used to sort data,
# - mutate() - is used to create new variables.
# - glimpse() - show structure of the data (alternative to str())
# - group_by() - is used to split data into groups using
#                selected columns (allows analysis in subgroups)
# - summarise() - summarizes data
#   inside summarise one can use for example:
#       n() - number of observations
#       n_distinct() - number of unique values
#       sample_n() - random sample (w/o replacement) - n elements
#       sample_frac() - random sample (w/o replacement) - fraction

# Each of these functions as the first argument expects 
# a data frame. Further arguments often require providing
# column names, which in these functions are NOT put in quotes.

# for more details see here:
# https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html
# http://dplyr.tidyverse.org/

### Dplyr - select #############################################################

colnames(life2)

# Let's select some initial variables

life2[,c("Country")] # standard way

select(life2, Country) # use of the select function

life2 %>% select(Country) # use of the pipeline operator
# it makes the previous element flow to the following function

# If we want to get more variables:

life2[,c("Country", "Year")]

?select # we have ... sign, we can put more names here

select(life2, Country, Year)
life2 %>% select(Country, Year)

# Select works on data.frames as well
life %>% select(Country)

life %>% select(Country) %>% head() # we can use head to limit the printout in the console

# output from the select command is a data.frame

# Compare these codes:
life %>% select(Country) %>% class() # data.frame
life[,"Country"] %>% class() # character vector
life$Country %>% class() # character vector

life2 %>% select(Country) %>% class() # tibble
life2[,"Country"] %>% class() # still a tibble!
life2$Country %>% class() # character vector

# Important! If you limit a tibble, your result will be still a tibble. 
# Functions which operate on vectors will need to be used in a bit more careful way.



# More examples of select
colnames(life2)

life2 %>% select(Country, Year, Status)
life2 %>% select(Country:Status) # range of values

life2 %>% select(starts_with("P")) # additional function -> select based on name string
life2 %>% select(ends_with("deaths"))
life2 %>% select(contains("co"))



### Dplyr - filter #############################################################

life2[life2$Country=="Poland",]

# Filter takes dataset and then the condition that needs to be met
filter(life2, Country == "Poland")

# it's like subset function, but filter is much more flexible
# subset(life2, Country == "Poland")



# filter can take more conditions
# in this case ALL should be met
filter(life2, Country == "Poland", Year > 2008)



# now we can build longer chains of code with the pipeline operator
life2 %>% filter(Country == "Poland", Year > 2008) %>% 
  select(Country, Year, BMI)

# without pipes:
select(filter(life2, Country == "Poland", Year > 2008), Country, Year, BMI)

# other notation:
life2[life2$Country == "Poland" & life2$Year > 2008, c("Country", "Year", "BMI")]

# You can choose what is more comfortable for you :)



### Dplyr - mutate #############################################################

# mutate allows for creating additional variables in the dataset
# the rule is -> specify the name of the new variable first, 
# and then specify which data should come there 

# warning! If you want your variable to be saved in the dataset you need to 
# use the assignment sign!

life2 %>% mutate(infant_adult_mortality = infant.deaths/Adult.Mortality) %>% 
  # we create a new variable using information already existing in the dataset
  select(Country, Year, Status, infant_adult_mortality)

colnames(life2) # our result was not saved -> the calculations were only done ad hoc

# if we want our change to be permanent, we need to save it to the dataset

life2 <- life2 %>% mutate(infant_adult_mortality = infant.deaths/Adult.Mortality) %>% 
  select(Country, Year, Status, infant_adult_mortality)

# Sometimes this notation is used with pipelines
life2 %>% mutate(infant_adult_mortality = infant.deaths/Adult.Mortality) %>% 
  select(Country, Year, Status, infant_adult_mortality) -> life2 # saving at the end
# this notation only works with arrows!

# Personally I don't recommend this notation, as it can be a bit misleading. 
# But, as always, you can choose what works for you.



# Ad hoc calculations are commonly used with pipes when some modifications are 
# needed in the data just for reporting purposes
# Sometimes there is no need to save the result in the main dataset (e.g. when
# we just want to calculate some statistic for a specific subset of data)

life2 %>% filter(Country == "Poland", Year > 2008) %>% 
  select(Country, Year, BMI) %>% 
  mutate(BMI_variation = BMI/mean(BMI)) 
# see how these calculations use only the context of this subset -> mean calculated
# here is only corresponding to the BMI values for Poland, in years 2009-2015


# We can use rename() to change the name of our variables
# rule: new first, older second.

life2 %>% filter(Country == "Poland", Year > 2008) %>% 
  select(Country, Year, BMI) %>% 
  mutate(BMI_variation = BMI/mean(BMI)) %>% 
  rename(BMI_to_mean = BMI_variation) # here the change is applied to the variable
# created in the previous step -> this improves the way the report table is presented

### Dplyr - summarize ##########################################################

# Summarize function extends the possibilities of preparing nice raport tables

# Let's create it step by step:
mean(life2$BMI)

mean(life2$BMI, na.rm=T)

# standard issue with the missing data
summarize(life2, mean(BMI))

summarize(life2, mean(BMI, na.rm=T)) # now it is reported but the printout is rather ugly...

summarize(life2, meanBMI = mean(BMI, na.rm=T)) # we can label the results

summarize(life2, meanBMI = mean(BMI, na.rm=T),
          sdBMI = sd(BMI, na.rm=T)) # we can also add more statistics

# Now, this is not saying much about our data. We have information
# across countries and years, which we can use to create a more comprehensive
# information about what's really going on in the dataset.

# For that, we will need to use group_by :)

### Dplyr - group_by ###########################################################

# let's start the grouping by Status variable (only two levels)
life2_grouped <- life2 %>% group_by(Status)

life2_grouped # we can see that Groups appear in the tibble printout
class(life2_grouped) # we have a new class -> grouped_df

# Now, if we try to use summarize, the results will be split across categories
summarize(life2_grouped, meanBMI = mean(BMI, na.rm=T)) 
# This happens, because after grouping our dataset is processed separately across
# categories. Here, the mean is calculated in the Developed and in the Developing
# group separately. 
# The result is also presented in this way. 

# Let's use the pipes to create a flow
life2 %>% group_by(Status) %>% 
  summarize(meanBMI = mean(BMI, na.rm=T)) # we got to the same result

life2 %>% group_by(Status) %>% 
  summarize(meanBMI = mean(BMI, na.rm=T),
            sdBMI = sd(BMI, na.rm=T)) # we can use more statistics

life2 %>% group_by(Year, Status) %>% 
  summarize(meanBMI = mean(BMI, na.rm=T),
            sdBMI = sd(BMI, na.rm=T)) 
# and prepare cross-comparison tables with more categories

life2 %>% group_by(Year, Status) %>% 
  summarize(meanBMI = mean(BMI, na.rm=T),
            sdBMI = sd(BMI, na.rm=T),
            inCategory = n()) # commonly used function n() to get counts in categories

# Group_by can be used for preparing new variables, which results will differ
# across categories. 

life2 %>% group_by(Status) %>% 
  mutate(BMI_mean_inGroup = mean(BMI, na.rm=T)) %>% 
  select(Country, Year, Status, BMI, BMI_mean_inGroup) %>% 
  filter(Year == 2011) # filtering needed to show that the result differers across categories

# Still, our data is grouped. If we would like to go back to the standard way
# of processing a tibble we need to use ungroup() function.

life2 %>% group_by(Status) %>% 
  mutate(BMI_mean_inGroup = mean(BMI, na.rm=T)) %>% 
  select(Country, Year, Status, BMI, BMI_mean_inGroup) %>% 
  filter(Year == 2011) %>% 
  ungroup() # now the tibble is ungrouped 

# Again, if we want to save the result we need to use assignment sign

life2 <- life2 %>% group_by(Status) %>% 
  mutate(BMI_mean_inGroup = mean(BMI, na.rm=T)) %>% 
  ungroup() # now the tibble is ungrouped 

glimpse(life2)

### Dplyr - arrange ############################################################

# We can change the way the data is presented by reordering the values
# for that we have dplyr command arrange

life2 # Arranged by country, and then Year (descending)

life2 %>% arrange(Country) # no change - by Country, ascending (alphabetic) order

life2 %>% arrange(Year) # arranged by year now, ascending order

life2 %>% arrange(Country, Year) #first by country, then ordered by year, ascending

life2 %>% arrange(Country, desc(Year)) #first by country, then ordered by year, descending 
# like in original data :)

### Side note on pipeline operator #############################################

# Normally, the pipeline allows to move the result from the previous operator
# to the first place in a given function (in tidyverse: exactly where the data should be)

# But we can control the behaviour of pipes with the dot symbol

# These codes return the same results:
runif(10) %>% 
  plot( y = 1:10)

runif(10) %>% 
  plot(., y = 1:10)

runif(10) %>% 
  plot(x =., y = 1:10)


# Here we can change the plot by placing a dot in a different place
runif(10) %>% 
  plot(x = 1:10, y = .)


# We can use the dot to get a vector out of a column in a tibble

# compare the results
life2 %>% .["BMI"] # tibble object
life2 %>% .[["BMI"]] # vector

# the function mean() will not work
# on the data frame (or tibble object)

mean(life2 %>% .["BMI"], na.rm=T)

# but works for a vector (numeric or logical)

mean(life2 %>% .[["BMI"]], na.rm=T)


### Tasks ######################################################################

### IMPORTANT! In these tasks please use tidyverse functions whenever possible!!!
### Use the pipeline notation!

# 1. Read the gapminder_full data to a tibble format (use readr package). Name 
# the variable "gapminder". 
gapminder<-read_csv("gapminder_full.csv")

# 2. Filter the dataset to get information on 1962 year only. 
# Please use the pipeline operator. 
gapminder[gapminder$year=="1962",]

gapminder%>%;filter(year==1962)

# 3. Create a new variable population1000 which will store the population numbers 
# in thousands. Use the mutate command and save the result to your dataset. 
# TIP: Divide raw numbers by 1000. 
gapminder<-gapgapminder %>%
  mutate(population1000 = population/1000)

# 4. Prepare a summary table which will sore the median population count on 
# each continent. Use one line of code with pipeline operators. 
# TIP: use group_by, and then summarize(). 
gapminder %>%
  group_by(continent) %>% 
  summarise(median(population, na.rm = TRUE))

# 5. In the full dataset prepare a variable maxCountry which will store the maximum 
# gdp value obtained for a specific country in the whole researched period.
# TIP: use group_by, and then mutate to do the calculations in groups. 
# Remember to ungroup your data at the end and store the result in the dataframe.
gapminder<-gapminder%>%
  group_by(country)%>%
  mutate(maxCountry=max(gdp_cap, na.rm = TRUE)) %>%
  ungroup()

# 6. Using previously created variable show for each country in each year 
# the gdp reached its maximum. 
# TIP: you can use comparison between gdp_cap and maxCountry variable
gapminder %>% 
  filter(gdp_cap == maxCountry)

# 7. Add a sorting step to the codes from the previous task. Arrange the filtered
# data to see for which country the maximum gdp was in the furthest moment of time.
# You will see which countries "developed backwards".
gapminder %>%
  filter(gdp_cap == maxCountry) %>%
  arrange(year)

### Loading pre-processed data #################################################

library(tidyverse)

load("datasetsTidyr.RData")
# Includes four datasets:
# onePanel and twoPanel for lecture showcase
# onePanelTask to be used in practice tasks
# tidyrData dataset for tidyr showcase and practice

### Pivoting data - one variable ###############################################

onePanel # one variable, 3 places, 3 years
# data in a wide form

# In case of one variable the job is simple, we just need to specify
# which columns we would like to pivot

onePanel %>% pivot_longer(cols = c("2011", "2012", "2013")) # specify what to use

onePanel %>% pivot_longer(cols = starts_with("20")) # specify what to use with pattern

onePanel %>% pivot_longer(cols = !City) # all but City, which identifies observations

# More parameters can be added to better control the shape of the output data

onePanel %>% pivot_longer(cols = c("2011", "2012", "2013"),
                          names_to = "year", values_to = "profit")

# For more variables it is a bit more tricky, but still doable :)

### Pivoting data - two variables + separate function ##########################

twoPanel # we have two values across 3-year time horizon
# names of the variables follow the same pattern
# first lets make the data long (as long as we can, we will fix it later)

twoPanel %>% pivot_longer(cols = !City) # we pivot all columns except for City

# now we can see that there is too much information carried in the variable name
# we have both year and type of the variable that defines our observations across time

# we will use the function separate (from tidyr) to divide this information
twoPanel %>% pivot_longer(cols = !City) %>% 
  separate(col = "name",  # which variable do we divide
           into = c("type", "year"),  # that will be the names of the new variables
           sep = "_") # what is the separator between names

# now we can clearly see that data is in the "super long" form
# we can make it simpler by moving Profit and People into their own variables
# for that we will use pivot_wider function

twoPanel %>% pivot_longer(cols = !City) %>% 
  separate(col = "name", into = c("type", "year"), sep = "_") %>% 
  pivot_wider(id_cols = c("City", "year"), 
              # we need to specify the columns which allow for unique identification 
              # of observations, here pair: year and place
              names_from = "type",  # where do we take the names from for the columns 
              values_from = "value") # where do we take the values from

# Now data is in a good form, we can save the result into a new variable

organisedTwoPanel <- twoPanel %>% pivot_longer(cols = !City) %>% 
  separate(col = "name", into = c("type", "year"), sep = "_") %>% 
  pivot_wider(id_cols = c("City", "year"), 
              # we need to specify the columns which allow for unique identification 
              # of observations, here pair: year and place
              names_from = "type",  # where do we take the names from for the columns 
              values_from = "value") # where do we take the values from

organisedTwoPanel

### Practice with separate and unite ###########################################

# Let's practice more with the tidyr functions
# We will use unite to combine data into one variable
# and then separate to revert the changes

tidyrData # for practice purposes we will unite information from weight and unit

tidyrData %>% unite(col = "weight_unit", # name of the new column
                    weight, unit, # names of columns to be united
                    sep = " ", # separator between values (default _)
                    remove = TRUE) # remove the original values used for uniting

# now in our dataset we have a new column weight_unit which stores both pieces of information

# Let's save this dataset and practice the separate function with it 
united <- tidyrData %>% unite(col = "weight_unit", # name of the new column
                              weight, unit, # names of columns to be united
                              sep = " ", # separator between values (default _)
                              remove = TRUE) # remove the original values used for uniting


# Separate works in a similar way as unite:
united2 <- united %>% separate(col = "weight_unit", # what are we separating
                               into = c("weight", "unit"), # into which variables we are transforming
                               sep = " ", # what is the separator between values 
                               remove = FALSE) # do not remove the original variable

united2

# Actually it would be best to just put the unit in the name of the variable
# or in the description of the dataset, as we don't have any variation in this 
# value. This variable is then redundant. Let's clean the data

united2 %>% select(-c("weight_unit", "unit")) %>% # remove these variables here
  rename(weight_in_kg = weight) # change the name of the variable to account for the untis

# if we are satisfied with the result we can update the tidyrData to its new shape

tidyrData <- united2 %>% select(-c("weight_unit", "unit")) %>% # remove these variables here
  rename(weight_in_kg = weight) # change the name of the variable to account for the untis

tidyrData

### Missing value handling with tidyr ##########################################

# we have three main functions for missing data handling in tidyr
#     drop_na() to remove rows with missing data
#     fill() to automatically fill the missings basing on the neighbouring information
#     replace_na() to specify the rule for NA replacement

# drop_na() allows to remove the rows with missing values form the dataset

tidyrData %>% drop_na() # all rows affected by missings were removed

tidyrData %>% drop_na(favMovie) # rows with missing in favMovie were removed

# fill() - useful function for handling text missing data, to fill in the gaps

?fill #fill missing based on the values that are near
tidyrData %>% select(favMovie) # three missing values in rows 2,3 and 6

tidyrData %>% fill(favMovie) # using the default parameters values were filled
# using what was above (1st row data duplicated in rows 2 and 3, and value from 5th row moved to the 6th)

tidyrData %>% fill(favMovie, .direction = "up") # changing the direction of replacing
# now data from 4th row moved to 2nd and 3rd, and data from 7th replicated in 6th



# replace_na()

tidyrData$favMovie %>% replace_na("no movie") # works very well on vectors

# for data.frames or tibbles it requires a list with specification 
# what to do with missings across different column
tidyrData %>% replace_na(list(favMovie = "no movie", # replacing for favMovie
                              favItalianDish = "no dish")) # replacing for favDish

### Nested columns - basic navigation ##########################################

# tibbles allow for storing lists within the column
# it broades the possibilities of storing data in R, especially in tabular form
# for example for spatial data in sf:: package, this property is used to represent
# spatial data in rows - all features are in standard columns, and the spatial properties
# are moved to the nested list column which stores all the specificities of the shape,
# geometry, coordinates, etc. 

# From our point of view it is important to understand how to extract nested
# information form the dataframes. If you remember that these nested columns 
# are in fact just lists, it will be much easier to operate with them. 

# Let's see the example

tidyrData # we have two nested columns - favFruit and favAnimal
# they store tibbles inside, and the type of these columns is shown as "list"

tidyrData$favAnimal %>% class() # if we check it with base function, the same appears

# how this data looks like:

tidyrData %>% select(favAnimal) 
# we see that these values are tibbles with one row and two columns each

tidyrData$favAnimal # in base R printing they are just a list with tibbles inside

# how to extract this data, knowing that it is a list?
tidyrData$favAnimal[1] # fraction of a list -> list from the first position, first box

tidyrData$favAnimal[[1]] # insides of the first list element -> inside of the first box, a tibble

tidyrData$favAnimal[[1]][1,2] # second element stored in this tibble, information from the second column

# in tidyr we have unnest() function which allows for extracting these data from lists

tidyrData %>% select(favAnimal) 

tidyrData %>% select(favAnimal) %>% unnest(cols = c(favAnimal)) 
# unnest extends this data by dropping the first level of complexity from the list
# extracts individual list elements and here transforms them to rows in the tibble

tidyrData %>% unnest(cols = c(favAnimal)) # if we do it on a full dataset we can see
# that this unnested tibble is enhancing our dataset now

# Nesting is a really important feature, which allows for fitting otherwise 
# non-tabular data into tabular format (which is easier for processing). 
# it is also used in grouping with group_by. 

# This section was just to present this idea and show how to operate with it 
# on the basic level. More details will be discussed next semester or 
# can be found in tidyverse tutorials and vignettes. 

# Unless dealing with very specific data, you will rarely see nested variables. 
# It is just important that you understand why they are here, and how they are
# implemented on the general level. So that when they occur (sometimes even from
# the faulty data reading from some specific sources), you will know where 
# to look for helpful functions and guidance. 

### Tasks ######################################################################

### IMPORTANT! In these tasks please use tidyverse functions whenever possible!!!
### Use the pipeline notation!

# 1. Using the onePanelTask dataset transform wide panel data to long format.
# name the numerical variable "Sales" and the time variable "Year". Try to do all 
# these transformations in just one function in one line. 
onePanelTask%>% 
  pivot_longer(cols = -1, names_to = "Year", values_to = "Sales")

# 2. Fill in the missing values in favItalianDish variable from the tidyrData to "pizza".
# Make sure that you are not making any changes in the favMovie variable. 
# Use tidyr function for that. 
tidyrData %>% 
  replace_na(list(favItalianDish = "pizza"))

# 3. Unite information from the year, month, day columns in tidyrData. Name 
# the created variable as "birthday" and convert it to Date type (as.Date)
tidyrData<-tidyrData%>%
  unite("birthday", year, month, day) %>%
  mutate(birthday=as.Date(birthday))

# 4. Extract the third favourite fruit of the person with ID equal to 3. 
tidyrData$favFruit[[3]][3]



