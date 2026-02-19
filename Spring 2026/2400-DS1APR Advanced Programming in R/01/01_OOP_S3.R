#---------------------------------------------------------#
#                 Advanced Programming in R               #
#                Object oriented programming              #
#                 classes and methods, S3 system          #
#              materials by: dr Maria Kubara              #
#---------------------------------------------------------# 

# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')


# A useful tool that we will use for checking
# object classes is the pryr package 

install.packages('pryr')
library(pryr)

# Sadly, this package has retired from CRAN in January 2026. 
# You can get it from the R Archive, but sometimes still it fails. 

# Here is a quick function to check if something is from S3 (a workaround across this)
is_s3 <- function(x) {
      !isS4(x) &&  # check if not S4
           !inherits(x, "R6") && # check if not R6
           !is.null(attr(x, "class")) #check if not an empty attribute of "class" - this is typical for BASE objects (level below S3)
}


### Base types - building blocks of R ##########################################

# To check which class system the object belongs to we can use the 
# otype() function from the pryr package


# Let's check simple numeric vector
numericVector <- 1:10

# It comes from base 
#otype(numericVector) # from retired pryr - it was showing "base" as output 

# Even though function class returns a value...
class(numericVector)

# our variable is not an object from OOP point of view - it does not have class attribute
attr(numericVector, "class")

is_s3(numericVector)

# Base elements like numeric, character, list are implemented in the R core. 
# They are used to build all the other objects in R. They are rarely changed
# and the new classes are very rarely created. 

# Most useful extensions of base types that we use very early in our R journey
# are implemented in S3. Let's check.



### S3 Classes #################################################################

# The S3 system of classes in the simplest way of defining own classes in R.

# each S3 object is in fact a LIST with the CLASS attribute assigned.

# Because of the radical simplicity, the S3 classes are widely used in R. 
# Still most classes in R are created in S3 system.

dframe <- data.frame(x = 1:10,
                     y = letters[1:10])

#otype(dframe)  # from retired pryr -> was returing value S3 here

class(dframe)
attr(dframe, "class")
is_s3(dframe)
# data.frame() is therefore an class defined in S3 system



# We can use the unclass() function to see what's behind a class definition

unclass(dframe)
# Now we can see a list structure with elements x and y
# We also have an additional attribute which is row.names

class(unclass(dframe))
# It turns out that behind the data frame object is just a list structure
# with a little bit more restrictions imposed.

# This discovery is actually the heart of the S3 system.



### Your own class in S3 #######################################################

# How to define own S3 class and create new objects of this class?

# lets create a sample list including elements of different types

k <- list(fname = "John",
          lname = "Smith",
          age = 35,
          gender = "M",
          married = TRUE)

class(k)

# otype(k)  # from retired pryr - was returing "base" here

attr(k, "class")
# EMPTY -> specific class from S3 still not implemented

# list is an object defined in the base system of classes

is_s3(k) # still not an S3 object

# we can use the function class() to assign a new value of this attribute (class)

class(k) <- "client"

class(k)

#otype(k) # from retired pryr - was returing "S3" here
is_s3(k) # we added class attribute - it is S3 already

attr(k, "class")
#now this field is full - we defined a new S3 class "client"

# we just created a new class of S3 system!



### Extracting fields of S3 objects ############################################

# In S3 system we refer to individual fields of the object
# using the $ symbol (same as for the list, which this object 
# in fact is)

str(k)

k$fname

k$lname

k$married



### Possible issues with S3 ####################################################

# You can see that in S3 system classes are defined ad hoc.

# Simplicity is an advantage, but also a disadvantage 
# of this system, because  the consistency of the objects 
# in a given class is not verified at all here.

# You can freely assign a class to an object, and thus assign 
# the same class to objects with completely different structure
# (fields).

class(dframe) <- "client"

class(dframe)

#otype(dframe) 
is_s3(dframe)

# here, changing the class will change the way the data frame 
# is displayed (which as we remember is an example of a list)

dframe

# let's change the class of the dframe object back to data.frame
# - we can also do it with the structure() function
# from the base package

dframe <- structure(dframe, # object
                    class = "data.frame") # class

# structure() is worth using when creating your own
# functions to make sure the resulting object will be
# assigned the appropriate class

class(dframe)

#otype(dframe)
is_s3(dframe)

dframe



# we can also add our class as an additional one using the append() function
# This is possible because in S3 the class definition is a character vector

class(dframe) <- append(class(dframe), "client")

class(dframe)

# An object might have multiple classes and their order matters 
# This will be discussed later with inheritance 



### Constructor function in S3 #################################################

# Although S3 does not require any formal class definition it is good to create
# a new function named as our new class which will be used for creating 
# new class instances

client <- function(fname, lname, age, gender, married) {
  new_object <- list(fname = fname,
                     lname = lname,
                     age = age, 
                     gender = gender,
                     married = married)
  
  # it is convenient to assign a class 
  # attribute by calling the structure function
  
  new_object <- structure(new_object, class = "client")
  
  return(new_object)
}

k2 <- client("John", "Doe", 42, "M", FALSE)
k2error <- client("John", 999, 42, "M", FALSE)


# No validation is used at this point. Only validation in S3 is used 
# if some defensive programming will be applied in the construction function. 


client <- function(fname, lname, age, gender, married) {
  # Simple error handling with stopifnot
  stopifnot(is.character(fname))
  stopifnot(is.character(lname))
  stopifnot(is.numeric(age))
  stopifnot(is.logical(married))
  
  # For more detailed checking of gender we can use an if statement
  if(!(gender == "F" | gender == "M")) stop("Gender must be F or M")
  
  new_object <- list(fname = fname,
                     lname = lname,
                     age = age, 
                     gender = gender,
                     married = married)
  
  # it is convenient to assign a class 
  # attribute by calling the structure function
  
  new_object <- structure(new_object, class = "client")
  
  return(new_object)
}

k2 <- client("John", "Doe", 42, "M", FALSE) # it is ok to create this one

k2error <- client("John", 999, 42, "M", FALSE) # error occured triggerd by stopifnot()

k2errorBIS <- client("John", "Doe", 42, "X", FALSE) # error occured triggerd by stop()



### Methods and generic functions in S3 ########################################

# If we call the object name in R as a command, it will be displayed in the console.

k

# by default R calls the print() function on the object

# In loops or inside functions the automatic printing is off. 
# In such case, one has to use directly the print() command

print(k)

# One can use different arguments of the print() 
# function: a vector, matrix, data frame, model result, etc. 
# and the result will be displayed differently, 
# DEPENDING ON THE CLASS of the object being the argument

print(dframe)

print(1:10)

print(lm(1:10~rnorm(10)))

# How does the print() function know what result to show depending on the type of object?

# The answer is: print() is a GENERIC function (also called POLYMORPHIC function)
# In fact, it is a collection of many METHODS appropriate for objects of different CLASSES.

# The only task of the generic function is to recognize the class (type) of 
# input object and transfer the execution to the appropriate method.

# When we call the generic function print() on an object of class "data.frame", 
# the execution is forwarded to print.data.frame() method,
# for the object of class "lm" the print.lm() method is used, etc.

# So in the S3 system the name of the method consists of the name of the generic 
# function and (after a dot!) the name of the class to which it is applied.

# To find out if a function is a generic function, one can display its source 
# code (invoke the command being the name of this function).

print

# If the the displayed source code includes a command
# UseMethod(), with the appropriate method as an argument,
# then the function being analysed is a generic function.


#--- pryr retired :( ###
# we can also use the ftype() function from the pryr package
#ftype(print) 
# it is a generic function from S3 system

#ftype(print.data.frame)
# method in S3 system for generic function print() and objects of class "data.frame"

is_s3_generic <- function(f) {
  is.function(f) &&
    any(grepl("UseMethod", deparse(body(f)))) # generic functions in S3 have UseMethod in their body
}

is_s3_generic(print) # this is a generic function 

is_s3_generic(print.data.frame) # this is already a method (specific implementation for data.frame class)

# lets check all the methods available for the generic function print()

methods(print)

# methods with an asterisk at the end of their name
# are "invisible" - their source code is not automatically displayed

print.ts

# but one can display them knowing the package they come from and using ::: (THREE colons!)

stats:::print.ts

# or without having to know the package

getAnywhere(print.ts)

# you can also view all available methods for the selected class

methods(class = "data.frame")

methods(class = "client")

# no methods for our new class...

# what happens when we apply the generic function print()
# on the object of class client?

print(k)

# the object was displayed despite no method assigned


# Here the default method was used: print.default()
# This is a method that is called, if no match was found 
# (if there is no method defined for the class
# of the object being the argument of the generic function).

# Each generic function has a default method.

# R has a lot of generic functions defined in S3 system.
# You can display them all using the command:

methods(class = "default")



### New method for existing generic ############################################

# How to create your own method for an existing generic function?

# just write the appropriate function whose name will be
# a combination of generic function name and object class

# Let's create the function print.client()


print.client <- function(x) {
  # print first name and last name and go to the new line 
  
  cat(x$fname, x$lname, "\n") # cat allows for printing and concatenating strings 
  
  cat("age:", x$age, "years\n") # it also recognises special characters like \n newline
 
  cat("gender:", x$gender, "\n")

  cat("married:", ifelse(x$married, "Yes", "No"), "\n")
}

# Now this method will be called every time when we display an object of the class "client".

# let's check how it works

print(k)

k



# Let's create a new client object using a previously defined constructor

k2 <- client("Joan",
             "Warren",
             24,
             "F",
             FALSE)

# lets apply the print method

print(k2)



# Add the method mean.client() simply returning client's age

mean.client <- function(x) x$age

mean(k)

# let's check the list of methods defined for the class client

methods(class = "client")


# In the S3 system, methods do NOT belong to an object or class, but to generic functions.
# The method will work as long as the appropriate object class is set.
# Deleting the class attribute will cause the use of the default method

unclass(k)

# now printed as a list



### Creating own generic functions #############################################

# One can also create own generic function, such as print(), plot() or mean().

# Let's first see how these functions are constructed.

print

plot

mean

# Each of them contains only a reference to the command
# UseMethod() with the name of the same generic function.

# This is a so called transfer function (dispatcher),
# which will handle all references.



# For the purposes of our example, let's create the generic function age().

age <- function(x) {
  UseMethod("age")
}

# The generic function is useless without any methods defined.

age(k)

# Let's create a default method just printing some information

age.default <- function(x) {
  message("This is a generic function")
}

age(k)

# then let's create a method for the class "client"

age.client <- function(x) x$age

# Sample use:

age(k)


# The way of creating method names in the S3 system
# (generic_function.class) causes that methods
# in this system can only have one argument
# - i.e. operate only on one object of selected class.





### Inheritance in S3 ##########################################################

# Inheritance is not well defined in S3 system. The way it is used mostly
# depends on the programmer's idea. 

# The most useful common practice is the inheritance of methods by children 
# class objects from the parent class methods - and this is implemented in R.

# Here we are using the characteristic of S3 class attribute - it is just a vector.
# The first element of the vector will be main, most specific class (child class).
# Remaining elements will be more general classes (parent class)


# Let's introduce a class clientPremium which will be an extension of the client class.

clientPremium <- function(fname, lname, age, gender, married, premium = TRUE) {
  new_object <- list(fname = fname,
                     lname = lname,
                     age = age, 
                     gender = gender,
                     married = married,
                     premium = premium) # new field showing the premium status
  
  # class definition will include two fields now - specific field and general field
  # child class - clientPremium and parent class - client
  
  new_object <- structure(new_object, class = c("clientPremium", "client"))
  
  return(new_object)
}

kP <- clientPremium("Angie", "Smith", 48, "F", TRUE) 
# see that we can omit the premium feature as this is 
# a default parameter with a predefined value

class(kP) # class of our object is defined with two fields

print(kP) # automatically the print function from client is applied
# because within the class definition there is a name client, for which
# a print behaviour (print method) is defined


# Let's include a new function for printing, specific for premium clients

print.clientPremium <- function(x) {
  # print first name and last name and go to the new line 
  
  cat(x$fname, x$lname, "\n") # cat allows for printing and concatenating strings 
  
  cat("age:", x$age, "years\n") # it also recognises special characters like \n newline
  
  cat("gender:", x$gender, "\n")
  
  cat("married:", ifelse(x$married, "Yes", "No"), "\n")
  
  cat("This is a client premium!") # addition to the printing function
}

print(kP) # now it is printed as clientPremium! 

# order in the class definition matters! It shows in which order 
# specific methods will be applied



# You can see that printing behaviour is only changed in the last line. 
# Otherwise the definition is exactly the same.
# We can use NextMethod() function to encapsulate such behaviour in our methods.

age(kP) # age for clientPremium is returned as for standard clients now

# Let's extend the age method definition by saying the age of the client 
# and adding a message that says "Premium clients should never be asked for their age".

age.clientPremium <- function(x) {
  message("Premium clients should never be asked for their age")
  
  clientAge <- NextMethod()
  
  return(clientAge)
}

# value of age is found using the age method defined for the next element
# in the class attribute - so the parent class

# In our case we are using age.client() within the NextMethod() call to 
# see the age of a client. We are extending the behaviour of a function 
# with additional elements, that are specific for the child class 
# Here it is a message prompt which warns users on how to operate with premium clients

age(kP)


### Tasks ######################################################################

# Exercise 1
# Check which method are defined for 
# a generic function predict()?




# Exercise 2
# Create a generic function add_all(), then the
# defaults method and two additional methods:
# - add_all.numeric() returning the sum of all elements
#   if argument is numeric - use the function sum()
# - add_all.character() returning concatenation of all elements
#   if argument is character - use the function paste()




# Exercise 3
# Create a new class "student" and two sample objects of this class.
# Let objects of class "student" have the following fields:
# first_name, last_name, student_id, year, grades (numeric vector)
# and seminar (logical value).
# Write your constructor function with elements of defensive programming.
# Define methods:
# - average - calculating the average grade,
# - information - displaying first name, last name 
#   and student ID number (in the parentheses) 




# Exercise 4
# Create a new class "greatStudent", which inherits from the student class. 
# Add a new field to the child class named scholarship, with default value TRUE. 
# Extend the definition of the information function so that at the end of the 
# printing it shows a prompt "This is an exceptional student".



################################################################################
# Sources and more information

# https://www.datamentor.io/r-programming/S3-class
# https://adv-r.hadley.nz/s3.html#s3 
