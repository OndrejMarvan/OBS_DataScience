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

as.numeric(b) # Converting text to the numeric makes no sense - it will produce empty values NA



### Date #######################################################################

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

# Convert it to an integer
num_int <- as.integer(num)
num_int

# Convert it to a character
num_char <- as.character(num_int)
num_char

class(num_char)

# 2. Create two variables with text. Check the documentation of paste() and try
# to use it on created vectors. Compare the results of paste() function and c(). 
# What are the differences? Why?

# Create two text variables
text1 <- "Hello"
text2 <- "World"

# Use paste()
help(paste)
result_paste <- paste(text1, text2, sep = " ")
result_paste

# Use c()
result_c <- c(text1, text2)
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


