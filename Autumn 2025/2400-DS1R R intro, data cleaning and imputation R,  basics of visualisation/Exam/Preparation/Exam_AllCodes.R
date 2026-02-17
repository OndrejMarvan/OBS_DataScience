################################################################################
#########################  Maria Kubara MA #####################################
########################## RIntro 2024/25 ######################################
############################ Class 2 ###########################################
################################################################################

# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

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

### Numeric ####################################################################


# basic type for numerical data 

a <- 1.5
a
class(a) # check the class (type) of variable a
b <- 10
b
class(b) # check the class (type) of variable b

c <- "OndrejMarvan"
c
class(c)

c <- as.integer(integer)
class(c)


e <- 10
e

d <- c + 1
d

### Integer ####################################################################

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


### Logical #################################################################### 


# Datatype storing logical information - true-false
# True values in R: TRUE, T, 1
# False values in R: FALSE, F, 0

a <- 5; b <- 3 # we can run two operations in one line, dividing them with a semicolon
z = a < b # z will be the result of the operation checking if a is smaller than b 
z
class(z)

# Logical operators

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


### Character ##################################################################


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
c <- as.numeric
class(c)


as.numeric(b) # Converting text to the numeric makes no sense - it will produce empty values NA



### Date #######################################################################

# There are many possibilities for date processing in R. The most basic one is 
# as.Date() function for Date class. Dates are stored as number of days since 
# 1970-01-01, with negative values for earlier dates. This format stores date-only data. 

dates1 <- c("2022-08-18", "1998-01-30", "2020-03-18")
class(dates1)

as.numeric(dates1) # this is only text data - NAs created


as.date
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

as.Date(datesFromExcel, origin = "1895-12-30") # literally default date and adds on that


# We can change the date formatting with format() function

today <- Sys.Date() # returns today's date
today

tomorrow <- today + 1 
tomorrow

# we can change the format of the date

todayFormatted <- format(today, format = "%A %d %B %Y")
todayFormatted



### Data structures ############################################################

### Vector #####################################################################

vectorInteger <- c(1:10)
vectorInteger
class(vectorInteger)

vectorNumeric <- c(1.5:3.5)
vectorNumeric
class(vectorNumeric)

vectorCharacter <- c('a', 'b', 'c')
#vectorCharacter2 <- c(a, b, c)
vectorCharacter
class(vectorCharacter)

vectorLogical <- c(TRUE, FALSE, F, T, T)
vectorLogical
class(vectorLogical)

# General info:
# - single datatype
# - as long as you wish
# - basic command c() - combine
# - additional useful commands - rep() and seq()

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

w7 # this goe crazy

### Operations on vectors  #####################################################

w1; w2; w3 # calling few elements in one line - with semicolon

w123 <- c(w1, w2, w3) # combining vectors 
w123 



### Arithmetical operations ####################################################

# values in vectors can be multiplied, added, substracted, divided, etc.  
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
c(1, 2, 3) + c(5, 6, 7, 1, 2) 
# ERROR! Longer vector's length is not a multiplication of the shorter vector's length. Operation will not be successful. 



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

# Create a numerical value with a decimal part
num <- 4.75
num

class(num)

# Convert it to an integer
num_int <- as.integer(num)
num_int

class(num_int)

# Convert it to a character
num_char <- as.character(num_int)
num_char

class(num_char)

# 2. Create two variables with text. Check the documentation of paste() and try
# to use it on created vectors. Compare the results of paste() function and c(). 
# What are the differences? Why?

# Create two text variables
text1 <- "Lorem"
text2 <- "Ipsum"

# Use paste()
help(paste)
result_paste <- paste(text1, text2, sep = " ") # combines strings into one
result_paste

# Use c() 
result_c <- c(text1, text2) # collects items into a list (vector)
result_c



# 3. a) Convert vector vecDate <- c("09:12:12", "28:02:16", "31:05:22") to Date class. 
# b) Calculate number of days between these dates and today's date. 

# Part a: Convert to Date class
vecDate <- c("09:12:12", "28:02:16", "31:05:22")
vecDate_Date <- as.Date(vecDate, format = "%d:%m:%y")
vecDate_Date

# Part b: Calculate days difference
today <- Sys.Date()
days_diff <- today - vecDate_Date
days_diff


# 4. Create a vector "vec1" which will include numbers from 2 to 8 and from 17 to 30. 
# Use the shortest code possible.

vec1 <- c(2:8, 17:30)
vec1


# 5. Create a vector "vec2" with given structure: (2,  8, 14, 20, 26, 32). Use seq() function. 
vec2 <- seq(from = 2, by = 6, length.out = 6)
vec2


# 6. Create a vector with given structure: "2", "7", "a", "2", "7", "a", "2", "7", "a". TIP: rep()
help(rep)
vec3 <- rep(c("2", "7", "a"), times = 3)
vec3


# 7. Create a vector of length 100, which will store consecutive numbers divisible by three. 
help(seq)
vec4 <- seq(from = 3, by = 3, length.out = 100)
vec4


# 8. Using only one line of code create a vector "vec3" with following structure: 
# (1, 1, 3, 3, 5, 5, 7, 7, 9, 9, 1, 1, 3, 3, 5, 5, 7, 7, 9, 9, 1, 1, 3, 3, 5, 5, 7, 7, 9, 9). 

vec3 <- rep(c(1, 1, 3, 3, 5, 5, 7, 7, 9, 9), times = 3)
vec3

# 9. Generate a vector "vec4" of 50 numbers with the usage of runif() function. What does
# it do? Use generated numbers to create a vector of 50 random integer values from the 
# range 0-20. 

# Generate 50 random numbers from uniform distribution
vec4 <- runif(50, min = 0, max = 20)
vec4

# Convert to integers
vec4_int <- as.integer(vec4)
vec4_int


# 10. Print values from the 5th, 10th and 26th element of previously created vector.

vec4_int[c(5, 10, 26)]


# 11. Print values of every second element from the previously created vector, 
# starting from the 5th element of the vector. TIP: seq(). 

vec4_int[seq(from = 5, to = length(vec4_int), by = 2)]



# 1. Create a numerical value with decimal part. Convert it to integer and then
# to character. See what are the changes (in values and printing). 
num <- 1.1
num
class(num)

num_int <- as.integer(num)
num_int
class(num_int)

num_char <- as.character(num_int)
num_char
class(num_char)

################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 3 ###########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

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

listObject



### Tasks ######################################################################

# 1. Create a factor with values "a", "b", "c" of length 7. Add labels "Letter A",
# "Letter B", "Letter C". Summarize factor values. 
x <- c("a","b","c","a","b","c","a")
fac_abc <- factor(x,
                  levels = c("a","b","c"),
                  labels = c("Letter A","Letter B","Letter C"))

fac_abc
summary(fac_abc)
str(fac_abc)

# 2. Create a numeric vector with values 1-4 and length 10. You can use any function
# for creating the vector. Values can be ordered randomly. Summarize the variable 
# and check its type. Then use this vector to create an ordered factor. Set levels
# to "low" "medium" "high" "very high". Summarize the value and compare it to the initial vector. 

v <- sample(1:4, size = 10, replace = TRUE)  # simple & okay if values vary each run
v
summary(v)
typeof(v)   # check numeric type

fac_ord <- factor(v,
                  levels = 1:4,
                  labels = c("low","medium","high","very high"),
                  ordered = TRUE)
fac_ord
summary(fac_ord)
str(fac_ord)


# 3. Create a matrix with 5 rows and 2 columns, filled with zeros. Save it to "table" 
# variable. 

table <- matrix(0, nrow = 5, ncol = 2)
table

# a) fill 1st column with 3
table[, 1] <- 3
table

# b) set 3rd element of 2nd column to 20
table[3, 2] <- 20
table

# c) print 2nd column + type
table[, 2]
typeof(table[, 2])

# d) change 4th element of 2nd column to "twelve"
table[4, 2] <- "twelve"
table
typeof(table[, 2])  # now character

# e) type of 1st column? why?
typeof(table[, 1])  # also character
# Matrices hold one atomic type; adding a character coerced all entries to character.

# 4. Create four variables with different types (vectors, matrices, single values).
# Create a list out of these objects named "myList". 

vec_char <- c("a","b","c")               # character vector
vec_num  <- c(10, 20, 30)                # numeric vector
mat_num  <- matrix(1:6, nrow = 2, ncol = 3)  # numeric matrix
single   <- TRUE                          # single logical value

myList <- list(vec_char, vec_num, mat_num, single)
myList

# a) take 2nd element (numeric vector) and add a value; save back
myList[[2]] <- c(myList[[2]], 99)
myList[[2]]

# b) add a NEW element at the end: a 6-element vector (any type)
myList[[length(myList) + 1]] <- c(1,2,3,4,5,6)
myList

# c) print 4th element of the LAST object in the list
myList[[length(myList)]][4]

# d) change the 5th element of that LAST object to NA
myList[[length(myList)]][5] <- NA
myList[[length(myList)]]

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
column1 <- c(1:8)
column2 <- c("Ania", "Tom", "Ewa", "Piotr", "Jan", "Ola", "Adam", "Zuza")
column3 <- c(T, T, F, F, T, T, T, F)
column4 <- c(10, 15, 12, 18, 20, 14, 11, 17) 
column5 <- c("A", "B", "A", "B", "A", "B", "A", "B") 

mySet1 <- data.frame(column1, column2, column3, column4, column5)

str(mySet1)

# a) Show the 5th row of created dataframe. 
mySet1[5, ]


# b) Change the name of the second column of mySet1 dataframe to "column02"
colnames(mySet1) # names of vectors are stored as column names
# Use colnames() just as in the lesson example
colnames(mySet1)[2] <- "column02"

# Check the result
print(mySet1)

# c) Show 7 first rows of mySet1 dataframe. Use two different methods - with 
# indexes and with a function. 
# Method 1: Using the head() function
head(mySet1, 7)

# Method 2: Using indexing (specifying rows 1 through 7)
mySet1[1:7, ]

# 2. Use iris dataset. Using indexing show values of every 3rd row between 
# 40th and 120th observations. Try to use a one-liner (shorten the code so that 
# it fits in one line only, without any intermediate steps).

iris[seq(from = 40, to = 120, by = 3), ]


# 3. Use built-in "women" dataset. 
# Load and inspect the dataset
data(women)
str(women)

# a) Change type of the first column to character.
# Use the $ operator to select the column and as.character() to change it
women$height <- as.character(women$height)

# Verify the change
str(women)

# b) Add two new rows to the dataset with made-up numbers. Make sure that you 
# don't loose the types of variables in the main dataframe in the process. 
# To preserve types, we must add a data.frame, not a vector.
# This new data.frame must have the exact same column names: "height" and "weight"
# Remember 'height' is now a character, so the new values must be in quotes.
new_rows <- data.frame(height = c("70", "71"), 
                       weight = c(170, 175))

# Use rbind() to combine the old and new dataframes
women <- rbind(women, new_rows)

# Check the end of the dataframe to see the new rows
tail(women)


# c) Add new variable to the dataset and name it "shoe_size". Using runif function
# create the values for this variable. Shoe size must be an integer between 35 and 42. 
# The lesson uses runif, so we will too.

# 1. Get the number of rows
num_rows <- nrow(women)

# 2. Use runif(n, min, max) to get decimals from 35 up to (but not including) 43
# We use 43 because floor() always rounds down, so floor(42.99) becomes 42.
random_decimals <- runif(num_rows, min = 35, max = 43)

# 3. Use floor() to convert the decimals to integers (e.g., 35.8 becomes 35)
shoe_sizes <- floor(random_decimals)

# 4. Add the new vector as a column using the $ operator
women$shoe_size <- shoe_sizes

# Check the final dataframe
head(women)
str(women)

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
setBikeA

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
sort(CO2$uptake, decreasing = TRUE)

# 2. Show the rows of CO2 dataset, where the Type is set to Quebec and Treatment to chilled.
head(CO2)
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

################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 6 ###########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Data from different sources ################################################


# Absolute path, basic functions:


# file location

# Windows path: C:\Users\maria\Desktop\RIntro\data\notepadData.txt

# transformation1: C:\\Users\\maria\\Desktop\\RIntro\\data\\notepadData.txt

# transformation2: C:/Users/maria/Desktop/RIntro/data/notepadData.txt


# Reading data from txt file with basic function read.table

# checking the arguments of the function
?read.table
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data")
getwd()

table1 <- read.table("notepadData.txt", header = TRUE, sep = " ")

# now we can use the data we have read
summary(table1$price)
summary(table1$price)


# reading data with relative paths

# path to the data folder:  "C:/Users/maria/Desktop/RIntro/data"

# setting the 'working directory' 
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data")

# checking the path to the working directory 
getwd()


# location can be stored with a text variable which stores the path to the folder
locationWD <- c("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data")

setwd(locationWD)

getwd() # we get the same result



# now we can use the relative paths:

table1a <- read.table("notepadData.txt", 
                      header = TRUE, sep = " ")

table1a <- read.table("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets/notepadData.txt", 
                      header = TRUE, sep = " ")

table1a # success! the same table has been read



# path location can be chosen with the interactive function file.choose()

table1b <- read.table(file.choose(), header = TRUE, sep = " ")
table1b



### Reading data of other types ################################################

# reading the csv file with read.csv() function
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data")

getwd()

water <- read.csv("graphics - water quality/water_potability.csv", sep = ";", dec=".")
water <- read.table(file.choose(), header = TRUE, sep = ",", dec=".")

# good practice! always glimpse at the data that you have just read
# check if they are read in the proper format 
head(water)

# Problem! there was a wrong separator chosen 

water <- read.csv(file.choose(), sep = ",", dec=".")

head(water) # now the data looks properly



# reading data from Excel file with read_excel function

# staring with installing the new package
install.packages("readxl")

# loading it to the current R session
# now its functions will be available in this R session
library(readxl)

?read_excel

# automatic loading of the first sheet 
loanEXCEL1 <- read_excel("dataset - loan prediction/loan_prediction_excel.xlsx")
loanEXCEL1

loanEXCEL2 <- read_excel("dataset - loan prediction/loan_prediction_excel.xlsx", sheet = 2)
loanEXCEL2

loanEXCEL3 <- read_excel("dataset - loan prediction/loan_prediction_excel.xlsx", sheet = "LoanPred")
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
save(list = ls(all.names = TRUE), file= "~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/all.rda")

rm(list = ls(all.names = TRUE)) # cleaning the whole memory

loanEXCEL1 # lack of object

load("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/all.rda")

loanEXCEL1 # object read again 

# saving single object to a file  
save(loanEXCEL1, file = "~/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data")

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

alcohol <- read.csv("/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - student alcohol consumption/student-alcohol.csv")
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

# Levels overview:

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




### Tasks ######################################################################

# 1. read the description of the clients' personality analysis data and load it 
# into R (clients.csv file) as a variable named "clients". 

clients <- read.csv("clients.csv")

head(clients)

# 2. preview the structure of the data and check what classes have been assigned 
# to the variables in question.

str(clients)

# 3. Check if there are any missing observations in the set. 

# a) Which variables include missing values?
summary(clients)

# b) Input the missing values with the mean or median value from the variable. 
# Before completing the values, consider what values the variable takes. 
# If they are numbers, are they integers (e.g. year of birth)? If so, complete 
# these values according to the nature of the variable (we don't want the year 
# 1995.832, do we? ;)).

clients$Year_Birth[is.na(clients$Year_Birth)] <- round(mean(clients$Year_Birth, na.rm = TRUE), 0)


# c) What code do you use to fill the missing values of Year_Birth (if any)?

clients$Year_Birth[is.na(clients$Year_Birth)] <- round(mean(clients$Year_Birth, na.rm = TRUE), 0)

# 4. a) Check that all missing observations have been completed. If not, repeat step 3. 

sum(is.na(clients))

# b) What code would you use to show all the rows which still have some missing data?

clients[!complete.cases(clients), ]

# 5. a) Consider which variables are worth converting to a "factor" type? 
# Hint: these will usually be text variables with a few specific, recurring 
# values. They can also be variables that are represented by numbers, but do 
# not have a "numerical sense" - e.g. the variable "education" and the values 
# 2, 3, 4, which actually represent successive stages of education (logical sense) 
# rather than the exact number of years of education (numerical sense). 





# b) What code would you use to transform the Marital_Status variable (shortest code possible)?

clients$Marital_Status <- as.factor(clients$Marital_Status)

# 6. a) Consider which of the previously identified variables would be worth 
# converting to an 'ordered factor' type (ordered categorical variable).
# Hint: An 'ordered factor' type variable should contain a logical order of 
# levels - e.g. an 'education' variable with values of 'primary', 'secondary' 
# and 'tertiary'. In this case, it may be worthwhile to keep the different 
# levels in order. Another typical example of an ordered factor variable is survey 
# responses recorded using a Likert scale (https://en.wikipedia.org/wiki/Likert_scale). 

# The Education variable is the clear choice.

# b) What code would you use to transform the Education variable? Let's assume that 
# 2n means secondary education and graduation is equal to BA defence.

edu_levels <- c("Basic", "2n Cycle", "Graduation", "Master", "PhD")

clients$Education <- factor(clients$Education, 
                            levels = edu_levels, 
                            ordered = TRUE)

# 7. Transform the variables identified in steps 5 and 6 into the appropriate classes.

# Apply the transformation from Step 5
clients$Marital_Status <- as.factor(clients$Marital_Status)

# Apply the transformation from Step 6
# Define the correct logical order
edu_levels <- c("Basic", "2n Cycle", "Graduation", "Master", "PhD")

# Transform the variable
clients$Education <- factor(clients$Education, 
                            levels = edu_levels, 
                            ordered = TRUE)

# --- Optional: Check your work ---
# Notice 'Marital_Status' is now 'Factor' and 'Education' is 'Ord.factor'
str(clients)


# 8. Save results for future reference! Use an RData file with name "clientsInR".

save(clients, file = "clientsInR.RData")

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

setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data")
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
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - life expectancy")
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


################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 8 ###########################################
################################################################################

# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Preparing for graphics creation ############################################

# Reading the data
getwd() # is the path set right?
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation") # change if necessary
getwd()
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


LifePLDE <- subset(life, Country == "Poland" | Country == "Germany")
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
# b) Add labels above the bins (check the documentation)
# c) Add a title "USA assault distribution" to the plot created in point 1a).

# 1a
hist(USArrests$Assault)

# 1b 
hist(USArrests$Assault,labels=TRUE)

# 1c
hist(USArrests$Assault,main="USA assault distribution", labels=TRUE)

# Or

hist(USArrests$Assault, 
     labels = TRUE, 
     main = "USA assault distribution")

# 2. a) Load the insurance.csv dataset into R (medical cost folder) and name it 
# insurance. Check if data is properly loaded and the types of variables are correct.
# b) Convert sex variable into factor type.
# c) Do the same to the smoker and region variables.
getwd()
insurance <- read.csv("data/graphics - medical cost/insurance.csv") # Adjust path if necessary
head(insurance)
str(insurance)

# 2b. Convert sex to factor
insurance$sex <- as.factor(insurance$sex)

# 2c. Convert smoker and region to factor
insurance$smoker <- as.factor(insurance$smoker)
insurance$region <- as.factor(insurance$region)

# Verify the changes (types should now say 'Factor')
str(insurance)

# 3. a) Using the insurance dataset prepare a correlation graph between age, 
# bmi and charges. When calling the columns use the indexing by column names. 
# Make it so that your graph is created by only one line of code. Use the 
# default parameters of corrplot function (don't change anything yet).
# Hint: use the corrplot() function from the corrplot package. You can assume
# that corrplot package in loaded in R.
# Hint 2: remember to draw the graph from the correlation table 
#made with the cor() function.

library(corrplot)
corrplot(cor(insurance[, c("age", "bmi", "charges")]))

# b) Arrange the variables on the graph using the order given by hierarchical
# clustering algorithm (hclust).

corrplot(cor(insurance[, c("age", "bmi", "charges")]), order = "hclust")

# c) Modify the plot that was created in b). Change the area of the graph so 
# that the lower triangle shows the numerical values and the upper triangle 
# shows the representation using circles. 
# Hint: look at the function corrplot.mixed(). 

corrplot.mixed(cor(insurance[, c("age", "bmi", "charges")]), 
               lower = "number", 
               upper = "circle", 
               order = "hclust")

# d) Prepare a boxplot of the variable charges by region. Change the axis 
# titles to "Medical charges" and "Region"

boxplot(insurance$charges ~ insurance$region, 
        xlab = "Region", 
        ylab = "Medical charges")

# e) Modify the boxplot and add more styling to it. Name the axis, change 
# color of the elements, etc. Play with the arguments of plot function.

boxplot(insurance$charges ~ insurance$region, 
        xlab = "Region", 
        ylab = "Medical charges",
        main = "Distribution of Medical Charges by Region",
        col = "lightblue",
        border = "darkblue")


################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 9 ###########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Preparing for graphics creation ############################################

# Reading the data
getwd() # is the path set right?
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation") # change if necessary

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

# --- Task 1: USArrests ---

# Load the required library
library(wesanderson) 

# 1d) Set up the environment for side-by-side plots (1 row, 2 columns)
par(mfrow = c(1, 2)) 

# 1a & 1b) Histogram of Murder with Zissou1 palette (continuous 10 colors)
hist(USArrests$Murder, 
     main = "Murder Arrests",
     xlab = "Arrests per 100,000",
     # generating 10 continuous colors from Zissou1
     col = wes_palette("Zissou1", 10, type = "continuous"))

# 1c) Histogram of Rape with Moonrise1 palette (discrete 4 colors)
# The recycling rule will apply here (4 colors repeated across the bins)
hist(USArrests$Rape,
     main = "Rape Arrests",
     xlab = "Arrests per 100,000",
     # generating 4 discrete colors
     col = wes_palette("Moonrise1", 4, type = "discrete"))

# 1f) Reset the graphical environment
par(mfrow = c(1, 1))

# --- Task 2: Insurance Data ---

setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation") # change if necessary

# 2a) Load data and convert to factors
# (Make sure the file path is correct for your computer)
insurance <- read.csv("data/graphics - medical cost/insurance.csv") 

# Converting variables to factor
insurance$sex <- as.factor(insurance$sex)
insurance$smoker <- as.factor(insurance$smoker)
insurance$region <- as.factor(insurance$region)

# 2b & 2c) Boxplot of charges by region with Viridis colors
library(viridis)

# We need 4 colors because there are 4 regions
region_colors <- viridis(4)

boxplot(charges ~ region, 
        data = insurance,
        main = "Insurance Charges by Region",
        xlab = "Region",
        ylab = "Medical charges",
        col = region_colors)

# 2d) Adding the legend
# We use levels(insurance$region) to get the names automatically.
legend("topright", 
       legend = levels(insurance$region), 
       fill = region_colors, 
       title = "Region")

# --- Task 3: Tokyo 2021 Olympics ---

# 3a) Load the dataset
# Setting the working directory to the folder you specified
setwd("/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/graphics - olympic games 2021")

# Reading the file (assuming the standard filename from the course materials)
games <- read.csv("Tokyo 2021 dataset.csv")

# 3b) Create "silver10" sorted and subsetted in ONE line
# Sorting by Silver Medal (decreasing) and taking the first 10 rows
silver10 <- games[order(games$Silver.Medal, decreasing = TRUE), ][1:10, ]

# 3c, 3d, 3e, 3f) Create and Export the Plot

# 1. Open the file device with your Student ID
png("477001.png", width = 800, height = 600)

# 2. Create the graphics
# Using the viridis palette for a nice look, as seen in the lecture
library(viridis)

barplot(silver10$Silver.Medal,
        names.arg = silver10$NOCCode,       # 3d: Labels from NOCCode
        main = "Top 10 silver medals",      # 3e: Title
        ylab = "Number of Silver Medals",   # 3f: Axis title
        col = viridis(10),                  # 3f: Interesting color palette
        las = 2,                            # 3f: Rotated labels (vertical)
        cex.names = 0.9,                    # Adjust label size
        font.lab = 2)                       # 3f: Bold axis labels

# 3. Close the file to save it
dev.off()


################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 10 ##########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################


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
# ============================================
# TASK 1: max75 function - returns 75% of max value
# ============================================

max75 <- function(variable){
  maximum75 <- max(variable) * 0.75
  return(maximum75)
}

# Test it
max75(c(10, 20, 100))  # should return 75


# ============================================
# TASK 2: Print only values divisible by 3
# ============================================

for(j in seq(2, 20, 4)){
  if(j %% 3 == 0) {
    print(j)
  }
}

# Answer for test: j %% 3 == 0


# ============================================
# TASK 3: Print only text longer than 5 characters
# ============================================

textVector <- c("Anna", "longitude", "bike", "car", "Sandra")

for(text in textVector){
  if(nchar(text) <= 5) next
  print(text)
}

# Only "longitude" and "Sandra" will be printed


# ============================================
# TASK 4a: Fill matrix rows with 1:10
# ============================================

myMatrix <- matrix(NA, nrow = 10, ncol = 10)

for(row in 1:nrow(myMatrix)){
  myMatrix[row, ] <- 1:10
}

myMatrix

# Answer for test: myMatrix[row, ] <- 1:10


# ============================================
# TASK 4b: Fill matrix with row + col
# ============================================

myMatrix <- matrix(NA, nrow = 10, ncol = 10)

for(row in 1:nrow(myMatrix)){
  for(col in 1:ncol(myMatrix)){
    myMatrix[row, col] <- row + col
  }
}

myMatrix

# Answer for test: myMatrix[row, col] <- row + col


# ============================================
# TASK 4c: Fill matrix with row * col (multiplication table)
# ============================================

myMatrix <- matrix(NA, nrow = 10, ncol = 10)

for(row in 1:nrow(myMatrix)){
  for(col in 1:ncol(myMatrix)){
    myMatrix[row, col] <- row * col
  }
}

myMatrix


# ============================================
# TASK 5: myMulti function - creates n x n multiplication table
# ============================================

myMulti <- function(n){
  myMatrix <- matrix(NA, nrow = n, ncol = n)
  for(row in 1:n){
    for(col in 1:n){
      myMatrix[row, col] <- row * col
    }
  }
  return(myMatrix)
}

# Test it
myMulti(5)
myMulti(10)

# Answer 5a): function(n){
# Answer 5b): myMatrix[row, col] <- row * col


# ============================================
# TASK 6: Install and load packages function
# ============================================

loadPackages <- function(packages){
  for(pkg in packages){
    if(!require(pkg, character.only = TRUE)){
      # Package not installed, so install it
      install.packages(pkg)
      # Then load it
      library(pkg, character.only = TRUE)
    }
  }
}

# Test it (don't run if you don't want to install)
# loadPackages(c("dplyr", "ggplot2", "tidyr"))

################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 12 ##########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Getting into the tidyverse #################################################

#library(tidyverse) # loading a full set of all tidyverse packages

library(dplyr) # data manipulation package -> the only one we need today 

# Read life expectancy data
# You can use a standard function read.csv

life <- read.csv("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - life expectancy/Life Expectancy Data.csv")
head(life)
class(life) # data.frame format

# Or load readr package and use read_csv function

library(readr)
life.readr <- read_csv("data/dataset - life expectancy/Life Expectancy Data.csv")

# this function is definitely louder! It gives you much more feedback on the 
# things that happen in the background. This can be a good or a bad thing :)
# You can also make it "quieter" by using suppressMessages function

life.readr <- suppressMessages(read_csv("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - life expectancy/Life Expectancy Data.csv"))

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
library(readr)
gapminder <- read_csv("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - gapminder world/gapminder_full.csv") # Assuming the standard data folder structure

# 2. Filter the dataset to get information on 1962 year only. 
# Please use the pipeline operator. 
gapminder %>% filter(year == 1962)

# 3. Create a new variable population1000 which will store the population numbers 
# in thousands. Use the mutate command and save the result to your dataset. 
# TIP: Divide raw numbers by 1000. 
gapminder <- gapminder %>% 
  mutate(population1000 = pop / 1000)

# 4. Prepare a summary table which will sore the median population count on 
# each continent. Use one line of code with pipeline operators. 
# TIP: use group_by, and then summarize(). 
gapminder %>% 
  group_by(continent) %>% 
  summarize(median_pop = median(pop, na.rm = TRUE))

# 5. In the full dataset prepare a variable maxCountry which will store the maximum 
# gdp value obtained for a specific country in the whole researched period.
# TIP: use group_by, and then mutate to do the calculations in groups. 
# Remember to ungroup your data at the end and store the result in the dataframe.
gapminder <- gapminder %>% 
  group_by(country) %>% 
  mutate(maxCountry = max(gdpPercap, na.rm = TRUE)) %>% 
  ungroup()

# 6. Using previously created variable show for each country in each year 
# the gdp reached its maximum. 
# TIP: you can use comparison between gdp_cap and maxCountry variable
gapminder %>% 
  filter(gdpPercap == maxCountry)

# 7. Add a sorting step to the codes from the previous task. Arrange the filtered
# data to see for which country the maximum gdp was in the furthest moment of time.
# You will see which countries "developed backwards".
gapminder %>% 
  filter(gdpPercap == maxCountry) %>% 
  arrange(year)


################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 12 ##########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Getting into the tidyverse #################################################

#library(tidyverse) # loading a full set of all tidyverse packages

library(dplyr) # data manipulation package -> the only one we need today 

# Read life expectancy data
# You can use a standard function read.csv

life <- read.csv("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - life expectancy/Life Expectancy Data.csv")
head(life)
class(life) # data.frame format

# Or load readr package and use read_csv function

library(readr)
life.readr <- read_csv("data/dataset - life expectancy/Life Expectancy Data.csv")

# this function is definitely louder! It gives you much more feedback on the 
# things that happen in the background. This can be a good or a bad thing :)
# You can also make it "quieter" by using suppressMessages function

life.readr <- suppressMessages(read_csv("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - life expectancy/Life Expectancy Data.csv"))

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
library(readr)
gapminder <- read_csv("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - gapminder world/gapminder_full.csv") # Assuming the standard data folder structure

# 2. Filter the dataset to get information on 1962 year only. 
# Please use the pipeline operator. 
gapminder %>% filter(year == 1962)

# 3. Create a new variable population1000 which will store the population numbers 
# in thousands. Use the mutate command and save the result to your dataset. 
# TIP: Divide raw numbers by 1000. 
gapminder <- gapminder %>% 
  mutate(population1000 = pop / 1000)

# 4. Prepare a summary table which will sore the median population count on 
# each continent. Use one line of code with pipeline operators. 
# TIP: use group_by, and then summarize(). 
gapminder %>% 
  group_by(continent) %>% 
  summarize(median_pop = median(pop, na.rm = TRUE))

# 5. In the full dataset prepare a variable maxCountry which will store the maximum 
# gdp value obtained for a specific country in the whole researched period.
# TIP: use group_by, and then mutate to do the calculations in groups. 
# Remember to ungroup your data at the end and store the result in the dataframe.
gapminder <- gapminder %>% 
  group_by(country) %>% 
  mutate(maxCountry = max(gdpPercap, na.rm = TRUE)) %>% 
  ungroup()

# 6. Using previously created variable show for each country in each year 
# the gdp reached its maximum. 
# TIP: you can use comparison between gdp_cap and maxCountry variable
gapminder %>% 
  filter(gdpPercap == maxCountry)

# 7. Add a sorting step to the codes from the previous task. Arrange the filtered
# data to see for which country the maximum gdp was in the furthest moment of time.
# You will see which countries "developed backwards".
gapminder %>% 
  filter(gdpPercap == maxCountry) %>% 
  arrange(year)


################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 13 ##########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Loading pre-processed data #################################################

library(tidyverse)


load("data/datasetsTidyr.RData")
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
# drop_na() to remove rows with missing data
# fill() to automatically fill the missings basing on the neighbouring information
# replace_na() to specify the rule for NA replacement



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

onePanelTask %>% pivot_longer(cols = -1, names_to = "Year", values_to = "Sales")

# 2. Fill in the missing values in favItalianDish variable from the tidyrData to "pizza".
# Make sure that you are not making any changes in the favMovie variable. 
# Use tidyr function for that. 

tidyrData %>% replace_na(list(favItalianDish = "pizza"))

# 3. Unite information from the year, month, day columns in tidyrData. Name 
# the created variable as "birthday" and convert it to Date type (as.Date)

tidyrData %>% 
  unite(col = "birthday", year, month, day, sep = "-") %>% 
  mutate(birthday = as.Date(birthday))

# 4. Extract the third favourite fruit of the person with ID equal to 3. 

tidyrData$favFruit[[3]][3, 1]

# Explanation:
# [[3]] selects the nested tibble for the 3rd person.
# [3, 1] selects the 3rd row (3rd fruit) and the 1st column (fruit name) of that nested tibble.




