#---------------------------------------------------------#
#                 Advanced Programming in R               #
#                Object oriented programming              #
#                 classes and methods, R6 system          #
#              materials by: dr Maria Kubara              #
#---------------------------------------------------------# 


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')


# Let's start by loading package R6 (it is not implemented in base R)

#install.packages("R6")
library(R6)


### R6 Classes #################################################################

# R6 system is introducing encapsulated OOP in R (it is based on S3 system).

# Classes are created with R6Class() function, which requires defining 
# formal structure of the class.
# R6 supports using public and private fields, as well as active fields.
# Methods belong to the class definition and are created along the class. 
# Because R6 is based on S3, one can use S3 generics to work with R6 objects.

### New R6 class ###############################################################

# Let's define the class called "client6" - equivalent to the class "client" from 
# the S3 system from previous topic having analogous fields - this time we also 
# have to define their type (class)

client6 <- R6Class("client6",
                   public = list(
                     fname = NULL, # we need to specify default values here
                     lname = NULL,
                     age = 18,
                     gender = NA,
                     married = NA
                   ))

# Creating of new R6 objects with new:
k6 <- client6$new()
k6 # all default fields


# Let's check if we can fill up the fields
k6 <- client6$new(fname = "John",
                  lname = "Smith",
                  age = 35,
                  gender = "M",
                  married = TRUE)

# not possible yet. We need to define the initialize method



### Creating the constructor function with initialize ##########################

client6 <- R6Class("client6",
                   public = list(
                     fname = NULL, 
                     lname = NULL,
                     age = 18,
                     gender = NA,
                     married = NA,
                     
                     initialize = function(fname, lname, age, 
                                           gender, married){
                       
                       self$fname = fname
                       self$lname = lname
                       self$age = age
                       self$gender = gender
                       self$married = married
                       
                       invisible(self) 
                       # this statement is a default one for R6
                       # invisible returning of the object 
                       # we work on 
                     }
                   ))


# Let's check if we can fill up the fields
k6 <- client6$new(fname = "John",
                  lname = "Smith",
                  age = 35,
                  gender = "M",
                  married = TRUE)
k6



### Adding validity checker to constructor #####################################

# We can add some validity checkers to the constructor
# We need to do it on our own - just like in S3

client6 <- R6Class("client6",
                   public = list(
                     fname = NULL, # we need to specify default values here
                     lname = NULL,
                     age = 18,
                     gender = NA,
                     married = NA,
                     initialize = function(fname, lname, age, gender, married){
                       # first some validity checking
                       stopifnot(is.character(fname), is.character(lname))
                       stopifnot(is.numeric(age), round(age,0)==age) #two conditions - if decimal?
                       stopifnot(gender %in% c("M", "F"))
                       stopifnot(is.logical(married))
                       
                       self$fname = fname
                       self$lname = lname
                       self$age = age
                       self$gender = gender
                       self$married = married
                       
                       invisible(self) 
                     }
                   ))


# Let's check if validity works
k6wrong <- client6$new(fname = "John",
                  lname = "Smith",
                  age = 40.5,
                  gender = "Z",
                  married = TRUE)
k6wrong

k6wrong <- client6$new(fname = "John",
                       lname = "Smith",
                       age = 40,
                       gender = "Z",
                       married = TRUE)
k6wrong



### Adding a method to a class definition ######################################

# functions in R are actually stored within variables... 
# see when we are creating a function the behaviour is almost the same
# as when creating a variable

myVar <- "variable content"
myFun <- function(x) print("function content")

# We can check the content of both "variables"
myVar
myFun # "variable" named myFun stores a function definition
myFun() # function is run when () are used



# Using this characteristic we can add method-fields within our class definition 
# (within the list of different fields). Content of such field will now 
# include a defined function. Exactly in the same way as the myFun variable.

# We will call these method-fields in the same way as the standard fields from
# lists - just by using $ sign. 

# What R6 gives us is the ability to call the content of the objects that the 
# function works on - with the operator self. 

client6 <- R6Class("client6",
                   public = list(
                     fname = NULL, # we need to specify default values here
                     lname = NULL,
                     age = 18,
                     gender = NA,
                     married = NA,
                     initialize = function(fname, lname, age, gender, married){
                       # first some validity checking
                       stopifnot(is.character(fname), is.character(lname))
                       stopifnot(is.numeric(age), round(age,0)==age) #two conditions - if decimal?
                       stopifnot(gender %in% c("M", "F"))
                       stopifnot(is.logical(married))
                       
                       self$fname = fname
                       self$lname = lname
                       self$age = age
                       self$gender = gender
                       self$married = married
                       
                       invisible(self) 
                       }, #comma because we are adding another field
                     
                       # new element in the class - makeOlder function
                       # which by default makes the client older by one year
                       makeOlder = function(olderBy=1){
                         self$age <- self$age + olderBy
                         invisible(self) #return statement without printing 
                       }
                   ))

k6 # so far our client does not have this method
# it was created before the changes to the class were made

# Let's create our client again

k6 <- client6$new(fname = "John",
                  lname = "Smith",
                  age = 35,
                  gender = "M",
                  married = TRUE)

k6 # there is a new field - makeOlder function

k6$makeOlder() # we can use methods on top of our objects

k6 
k6$age # see that age is now higher -> our object was modified in place
# it is mutable - we are using a method on top of the object, and changes
# are applied and saved. No need to use assignment symbol here 



### Method chaining in R6 ######################################################

# Because methods in R6 change the object in place and return it invisibly
# we can chain the methods - use them again and again to make further 
# changes to the object

# It is similar to the pipeline operator (where we could create chained 
# flows as well). The difference is that in R6 the changes are saved automatically
# to our object. We don't have to use assignment symbol to update the object.


# Let's chain the makeOlder method:
# age is 36 now, lets make it older twice 
k6$makeOlder()$makeOlder()

k6$age # age is 38 now, changes of both operations have been saved to the object!

k6$ # useful notation with line splitting like with %>% 
  makeOlder()$
  makeOlder(olderBy = 2)

k6$age # age is 41 -> older by one year, and then by two with changing the argument



### Adding new methods after the class is created ##############################

# Before we needed to update the class definition everytime we wanted to 
# add a new method for client6 class.

# It is not an ideal solution as it makes class definition very lengthy 
# and requires constant recreation of objects.

# We have another way to add fields (and methods) to existing class
# with $set() on the class name. 

# This function takes the visibility (public or private), the name of the field, 
# and its content. 

client6$set("public", "ID", 1) 
# adding an exemplary field with its default

client6$set("public", "makeMarried", function(){ 
  # see that the field name is within quotes
  self$married <- TRUE
  invisible(self)
})
# after running this code the class constructor is modified as has the additional
# field - makeMarried method

client6


k6$makeMarried() # doesn't work yet, as the changes were made after obejct creation

# Let's make John again, this time unmarried :)
k6 <- client6$new(fname = "John",
                  lname = "Smith",
                  age = 35,
                  gender = "M",
                  married = FALSE)

k6 # there is a new field - makeOlder function 

k6$makeMarried()

k6 # changes were applied


# Let's add another method which will be used in the following section
client6$set("public", "sayHello", function(){ 
  cat("Hi, my name is", self$fname, self$lname, "\n")
  cat("I am", self$age, "years old.", "\n")
  invisible(self)
})


k6 <- client6$new(fname = "John",
                  lname = "Smith",
                  age = 35,
                  gender = "M",
                  married = FALSE)

k6$sayHello()



### Inheritance ################################################################

# Inheritance is done by modifying the inherit field in R6Class().
# All fields are taken from the parent's class, as long as they are not 
# overriden.

client6Premium <- R6Class("client6Premium", 
                             inherit = client6,
                             public = list(
                               sayHello = function() {
                                 super$sayHello() 
                                 # We can call the superclass (parent class)
                                 # implementation here with super$...
                                 # like with NextMethod() from S3.
                                 
                                 # Then our printing behaviour can be modified
                                 cat("I am a premium client", "\n")
                               }
                             )
)

# $sayHello() overrides the superclass (parent class) implementation
# We can use the parent's implementation (and enhance it if necessary)
# by calling super$ - this works like NextMethod() in S3.

### Private fields #############################################################

# R6 OOP supports visibility modification of the fields within class. 
# If we want our fields to be called from the "outside" (within the console,
# by the end user) - we will put them in the public section. 

# e.g. we would like to use sayHello function on our object, and this function
# (as it introduces our object) should be available for the user in the console
# In public field we can call them by their names: object$publicField

k6$sayHello() # public method
k6$age # public field

# However, if users have access to all the fields, they can also override their 
# values. And this overriding happens without any checking - unwanted action can 
# happen, like changing age to be a negative number

k6$age <- -20
k6$age

# Because the field was public, user could do anything to it. That's not perfect.
# It would be better if the possibility to change the age was guarded by 
# function like changeAge(), in which we can put some defensive programming 
# (assertions, error checkers) to be sure that the action is allowed.
# In such case we will build public methods showAge() - for displaying age
# and changeAge() - for age modification. As for the field age - it will be 
# set to private to restrict unwanted access. 


client6 <- R6Class("client6",
                   private = list(age = 18), # introducing private field
                   # it can only be accessed within the class (by its methods)
                   
                   # in later fields we will be referring to age via
                   # private$age rather than self$age - private fields are 
                   # called via private$ syntax
                   
                   public = list(
                     fname = NULL, # we need to specify default values here
                     lname = NULL,
                     gender = NA,
                     married = NA,
                     initialize = function(fname, lname, age, gender, married){
                       # first some validity checking
                       stopifnot(is.character(fname), is.character(lname))
                       stopifnot(is.numeric(age), round(age,0)==age) #two conditions - if decimal?
                       stopifnot(gender %in% c("M", "F"))
                       stopifnot(is.logical(married))
                       
                       self$fname = fname
                       self$lname = lname
                       self$gender = gender
                       self$married = married
                       
                       private$age = age
                       
                       invisible(self) 
                     }, 
                     
                     makeOlder = function(olderBy=1){
                       private$age <- private$age + olderBy
                       invisible(self) #return statement without printing 
                     },
                     
                     showAge = function(){
                       return(private$age) #visibly return age
                     },
                     
                     changeAge = function(newAge){
                       stopifnot(is.numeric(newAge)) # numeric
                       stopifnot(newAge>0) # positive
                       stopifnot(newAge==round(newAge,0)) # no decimal
                       
                       private$age <- newAge
                       
                       invisible(self)

                     }
                   )
                   )

k6 <- client6$new(fname = "John",
                  lname = "Smith",
                  age = 35,
                  gender = "M",
                  married = FALSE)

k6$age # we have no access to the age field

k6$showAge() # we can only read it through showAge() function

k6$changeAge(-10)
k6$showAge()

k6$changeAge(40)
k6$showAge()

k6$makeOlder()
k6$showAge()



### Active fields ##############################################################

# Different approach to access modification is via the active fields in R6.
# They allow you to define components which look like field (you can call them
# via object$field), but are actually defined with functions. 

# Active fields are created by active bindings - functions that take a single
# argument called value. If the value is not provided (can be checked by
# missing(value)) its content will be retrieved (like just checking the 
# name). Otherwise it will be modified (but with additional checking for the
# validity of the changes).

# Active fields are highlighted in R6 definition with dots. 


client6 <- R6Class("client6",
                   private = list(age = 18,
                                  .fname = NULL, # with dots we specify the active fields
                                  .lname = NULL), 
                   
                   active = list(
                     fname = function(value){
                       if(missing(value)){
                         private$.fname
                       } else {
                         stopifnot(is.character(value))
                         private$.fname <- value
                         invisible(self)
                       }
                     },
                     lname = function(value){
                       if(missing(value)){
                         private$.lname
                       } else {
                         stop("Last name is for read only! No modification")
                       }
                     }
                   ),
                   
                   public = list(
                     gender = NA,
                     married = NA,
                     initialize = function(fname, lname, age, gender, married){
                       # first some validity checking
                       stopifnot(is.character(fname), is.character(lname))
                       stopifnot(is.numeric(age), round(age,0)==age) #two conditions - if decimal?
                       stopifnot(gender %in% c("M", "F"))
                       stopifnot(is.logical(married))
                       
                       private$.fname = fname
                       private$.lname = lname
                       self$gender = gender
                       self$married = married
                       
                       private$age = age
                       
                       invisible(self) 
                     }
                   )
)
                   
# Additional methods defined with set for more readability 
client6$set("public", "makeOlder", function(olderBy=1){ 
  private$age <- private$age + olderBy
  invisible(self) #return statement without printing 
})


client6$set("public", "showAge", function(){
  return(private$age) #visibly return age
})

client6$set("public", "changeAge", function(newAge){
  stopifnot(is.numeric(newAge)) # numeric
  stopifnot(newAge>0) # positive
  stopifnot(newAge==round(newAge,0)) # no decimal
  
  private$age <- newAge
  
  invisible(self)
})


# (Re)creating new object

k6 <- client6$new(fname = "John",
                  lname = "Smith",
                  age = 35,
                  gender = "M",
                  married = FALSE)

k6$age # we have no access to the age field - this is just private

k6$fname # it seems as if fname was public field - we can read it
k6$fname <- 749 # however when we try to change it the true character is revealed
# we are actually calling the method fname, which uses the validity checking

k6$fname
k6$fname <- "Bob"
k6$fname

k6$lname # the same happens for lname 
k6$lname <- "Some changes" # but here we defined that no modification is possible :)



### Using S3 generics ##########################################################

# R6 classes are implemented on the basis of S3 objects. 
# It is also visible in the class checking of R6 objects.

class(k6)
# we have our client6 class, which inherits from R6 class defined within 
# R6 package - it holds all the behaviour necessary for optimal object navigation

print(k6)

# we know that print() is an S3 generic function
# here we can see it working with an R6 object!

# Actually the print function is calling print.R6 method which holds the
# general printing method for all R6 objects.

# In a similar way we can define our own printing method for R6 object
# by setting new definition to print.clientR6 function - exactly how 
# methods in S3 were created.


# Make it to work with generic and with k6$print

print(k6)

print.client6 <- function(x){
  cat("This is client6 printing function", "\n")
  cat("Hi, my name is", x$fname, x$lname, "\n")
  cat("I am", x$age, "years old.", "\n")
  
}

print(k6) # wow, this actually worked!

# Because R6 is implemented on top of S3, we can utilize two approaches to 
# construct methods for R6 classes. If we want them to be called in a typical
# "R" way - via the call of function(myObject) - we can use the S3 syntax 
# for creating generics and methods

# If we want to utilize the encapsulated paradigm and use method chaining
# we will specify the methods within class definition, as class fields.
# In this way the methods will be called by myObject$function() and will
# be use the mutability of R6 objects - changes will be done in place



### Tasks ######################################################################

# Exercise 1
# (equivalent of the classes created in previous labs)
# a) Create a new class "student6" with the following fields: 
# first_name, last_name, student_id, year, grades (numeric vector)
# All the fields can be public right now.
# b) Add an initialize field which will create nice constructor of the class
# (with some validity checking).
# c) Add a method GPA which will calculate the average of grades of the student.
# Create two exemplary objects of your class.


# Exercise 2
# a) To student6 class add a public method addGrade() which will update the grades field 
# and prolong it with an additional grade at the end (TIP: c(grades, newGrade))
# Make sure that the additional grade "makes sense" - put some defensive programming here.
# Add method with $set() instead of copy pasting the whole class definition.
# b) Regenerate your student objects (to include new method) and add a few
# new grades to each of them using method chaining. 
# See how fields in your objects are mutating after an R6 method is used.


# Exercise 3
# Change year visibility from public to private. Write appropriate methods
# which will allow for reading the studnet's year information: showYear() 
# and for modifying the year: changeYear() - which will have some validity checking.
# Recreate your objects (to apply the changes in class structure)
# and see how new access restriction work.


# Exercise 4
# Change the student_id to an active field. Make sure it is read-only and no 
# changes can be applied after the object is created.
# Recreate your objects and play with the possibilities of active fields.


# Exercise 5
# Define a method print() for student6 class in two ways - 
# a) make it a method within the class definition - called with object$print()
# b) make it an S3 method which will be called print(object) 
# Make sure both behaviours work.
# Print method can be defined as you wish, just make sure to access at least 
# one public and one private field form the class structure. 


# Exercise 6
# Define class superStudent6 which will inherit from student6.
# Add a new field to superStudent6 scholarship with default set to TRUE.
# Modify the printing behavior for superStudent6 (by accessing parent class
# implementation) = the one called by object$print(). 
# Modification should add a new line to printing which will say:
# "I am a super student". Do not copy the print method from studnet6 class,
# refer to the implementation using super$. 


#---------------------------------------------------------------
# Sources and additional materials: 
# http://www.cyclismo.org/tutorial/R/s4Classes.html
# https://www.datamentor.io/r-programming/S4-class
# http://biecek.pl/R/RC/Jakub%20Derbisz%20R%20reference%20card%20classes.pdf

# System RC
# https://www.datamentor.io/r-programming/reference-class

# R6 Classes
# https://www.r-project.org/nosvn/pandoc/R6.html
# https://www.r-bloggers.com/the-r6-class-system/
# https://rstudio-pubs-static.s3.amazonaws.com/24456_042da2fcea0a405a9f07845a872ae7a6.html
# https://adv-r.hadley.nz/r6.html

# Better Shiny app navigation with R6 classes for creating modules
# https://zhuchcn.github.io/projects/posts/en/2019-03-25/
# https://jiwanheo.rbind.io/post/2022-02-06-pass-around-data-between-shiny-modules-with-r6/ 

