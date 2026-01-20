################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 1 ###########################################
################################################################################

# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

# Script in RStudio makes it easier to write code in R

# Hash symbol starts a comment (not runnable)

# Shortcut ctrl+shift+C allows for commenting/uncommenting 
# a bigger block of text



### Calculations in R ##########################################################

1+2

3*15

# Activating (running) the code:
# highlighting lines to be run + clicking on Run button
# you can also use the shortcut ctrl+enter



#### Variable and assigning values #############################################

varA

varA <- 1

varA

# sign <- is used for assigning values

varB = 1

varB

# you can also use the equal sign

varC <- "variable with text"

varC

varD = "variable with text 2nd version"

varD

varE <- "LoremIpsum"

varE

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

# Creating a vector and printing it
c <- c(1,2,3,4,5,6,7,8,9,10)
print(c)


### Tasks ######################################################################

# 1. Install the newest version of R on your personal computer. If you already 
# have R installed, update it to the newest version. 

# 2. Install RStudio. 

# 3. Create a project in RStudio which will store all files for this course "RIntro"

# 4. Create a new script in this project in which you will paste the content 
# of these tasks or your notes from this class.

# 5. Find documentation regarding the function runif(). What does it do? What are
# the possibilities? What can you do with it? 

# 6. You have a vector "a" below. Use function sum() on it. What is the result? Try to 
# get a numerical result instead of NA. TIP: look into the documentation. 

a <- c(5,8,10, NA)
# My code
sum(a, na.rm = TRUE)
