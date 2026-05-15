#---------------------------------------------------------#
#                 Advanced Programming in R               #
#                    Rcpp - C++ in R  01                  #
#              materials by: dr Maria Kubara              #
#---------------------------------------------------------# 


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')


# The use of C ++ in R programs is facilitated by the Rcpp package 
# install.packages("Rcpp")
library(Rcpp)

# lets also load the package rbenchmark - for evaluation of codes
library(rbenchmark)



### Preparation of the environment for C++ #####################################

# C++ needs a compiler. 

# Compiler for C++ in R is provided:
# - (on Windows) by the Rtools 
# - (on Mac) by Xcode application from the AppStore
# - (on Linux) by compiler which can be installed with 
#                 sudo apt-get install r-base-dev or similar.


# Availability of Rtools can be checked with find_rtools() function
# from the package pkgbuild.

# install.packages("pkgbuild")
pkgbuild::find_rtools()

# The result TRUE means that these tools have been already installed and are ready to use.


# If they are not installed or there is a need to update them,
# one can install them manually downloading a source file from the website:
# https://cran.r-project.org/bin/windows/Rtools/

# Make sure to get the latest Rtools (and R...) installed.


# One can also install Rtools automatically using 
# the function install.Rtools() from the installr package.

# install.packages ("installr")
library(installr)

# !!!! DO NOT RUN below line if 
# pkgbuild::find_rtools() showed TRUE !!!

install.Rtools()



### First steps with C ++ ######################################################

# cppFunction() function from Rcpp allows 
# you to write functions in C++ from the level of R


# The C++ function is similar to the R function:
# - we give a set of input data to the function
#   (function arguments),
# - we run some code on them,
# - we return a single object.

# However, C++ is a different language than R. There are some syntax 
# differences which we will need to follow.

# Check the slides for the comparison of R and C++ languages.

# Most important part: C++ is counting from 0!!!

# Other differences (in short):
# - every command must be terminated with a semicolon;
# - we must declare types of objects on which we work
# - function must have a clear return statement
# - assignment operator in C++ is =. The operator ->, <- is incorrect in C++.
# - comments in C++ will be written as follows:
#    - one-line comment can be created using // ...
#    - multiline comments are created using /*...*/
# - finding lenght of vector is possible with .size() method, which returns an integer.
# - the for() statement has different syntax in C++: 
#   for (init; check; increment).
#   After each iteration we have to increase the value of init 
#   (usually by one),
# - we have in-place modifications with ++ (like i++), -=, *=, /=.



### First function in C++ ######################################################

# C++ code can be embedded in R if we pass it as a (character) input to cppFunction()
# cppFunction automatically includes Rcpp namespace which incorporates all classes 
# necessary to translate your R code to C++

# We define function within the C++ code. After compiling (running cppFunction with
# C++ code inside) the function will be available in R workspace (standard way by its name).

cppFunction("int multiplyBy2(int x) {
            int result = x * 2;
            return result;
            }")

# This function will return integer (int)
# It is named multiplyBy2
# It takes single integer input (x)
# And creates integer result which multiplies the value x.
# Result is returned at the end of the function.

# We can run this function from R:

multiplyBy2(5)
multiplyBy2(-12)

# It will work with non integer... simply by droping the decimal part
# (forces coersion to integer from decimal input)

multiplyBy2(4.00001)
multiplyBy2(4.99999)



### 1. Function without input data - returning a scalar ########################

# function without arguments always returning integer of 10:

# in R
tenR <- function() {
  10L
}

# C++ equivalent
cppFunction('int tenC() {
              return 10;
            }')

# Differences between R and C++?
# in C++ we need to declare type of function result
# we just use function name to define it (no assignment symbol)
# return statement needs to be defined in C++
# each C++ statement ends with semicolon

# both functions can be used in the same way in R

tenR()

tenC()



### 2. Argument and results are scalars (single values) ########################

# we create a function that returns a sign of a number
# (equivalent to the standard sign() function)

# code in R

signR <- function(x) {
  if (x > 0) 1 else 
    if (x == 0) 0 else -1
}

# let's write it in a way similar to the below C++ code

signR <- function(x) {
  if (x > 0) {
    1
  } else if (x == 0) {
    0
  } else {
    -1
  }
}

# Or even closer:

signR <- function(x) {
  if (x > 0) {
    return(1)
  } else if (x == 0) {
    return(0)
  } else {
    return(-1)
  }
}



# C++ equivalent will look very similar

cppFunction('int signC(double x) {
              if (x > 0) {
                return 1;
              } else if (x == 0) {
                return 0;
              } else {
                return -1;
              }
            }')

# in the C++ version:
# - we declare the type of each argument and result type 
#    - thanks to this the function is more readable - it 
#    is known what type of argument is required.
# - the syntax of the if() command is IDENTICAL in R and C++
# - comparison operator == is identical in C++ and R (similarly !=)


# see how the function works

z <- rnorm(20)

# default R function

sign(z) # good with vectors too

# our R function
signR(z) # problems with vectors

# because if() is used inside of the function, it has some problems with 
# dealing with vectors. Depending on the R version this function will work 
# on the first argument of the input vector (older R) or simply
# throw an error (like in version 4.2.2)

# to work with vector input we need *apply() or purr:map()

sapply(z, signR)
purrr::map_dbl(z, signR)

# the same for signC:

signC(z) # cannot work with vectors - as it should! we made it work on double input (scalar)

# working with vectors like with signR() - thorugh vectorisation functions
sapply(z, signC)
purrr::map_dbl(z, signC)

# here map_int() works as well
purrr::map_int(z, signC)



### 3. Vector as argument, and scalar as result ################################

# The big difference between R and C++ is that there is time overhead of 
# a loop in R is very large, and in C++ much smaller. (However, this gets 
# better with each new R version).

# We will compare loop effectivness on calculating mean from a vector 
# We will introduce our own implementation of mean() function - which is already
# optimized and very efficient.

# We will use R loop and C++ loop to see the improvement in time efficiency.

myMeanR = function(x) {
  sum = 0
  n = length(x)
  for(i in 1:n)
    sum = sum + x[i]
  sum/n
}

# C++ equivalent

cppFunction('double myMeanC(NumericVector x) {
  int i;
  double sum = 0;
  int n = x.size();

  for(int i=0; i<n; i++) {
    sum = sum + x[i];
  }
  return sum/n;
}')

# notice how the loop iterator i is defined within 
# the for loop call (int i) - it can be defined before in the function
# or straight within the loop definition in for() command

# The function version in C++ is similar to R, but:
# - in C++ we find the length of the vector using the .size() method
# - the for() loop has a different syntax in C++:
#   for(init; check; increment).
#    - in C++, INDEXING VECTORS STARTS FROM 0!
#    - the loop is initiated by creating an index variable
#      init (in our case: i) with the value 0
#    - before each iteration we check if i<n, and finish the loop,
#      if condition is NOT met.
#    - after each iteration the value of i is increased by 1 using
#      special increment operator i++, which increases the value by 1.
# - i++ is the operator that modifies the value of i "in place":
# - similarly we can rewrite part of the loop as: sum += x[i] ;.
# - other in place modifying operators: -=, *= and /=
# - for the assignment operation in C++ we use 
#   the equality sign = , not <-

# The myMeanC function is a good example of where C++ is much more efficient than R.

# lets compare the calculation speed of myMeanR(), myMeanC(), 
# and the built-in R: mean() function (already optimised and very efficient)

# first we generate a vector of one million random
# values from the normal distribution

x <- rnorm(1e6)

benchmark("mean" = mean(x),
          "myMeanR" = myMeanR(x),
          "myMeanC" = myMeanC(x)
)[, 1:4]

# function in C++ is much better than the function in R,
# comparison between C++ and built-in mean() is less obvious :)
# Conclusion: built-in R functions are already well optimised,
# don't try to break the open door and use them as much as you can.



### 4. Recursive function ######################################################

# Consider the Fibonacci sequence - a sequence of natural numbers
# specified recursively as follows:
# - the first word is equal to 0, the second is equal to 1,
# - each next is the sum of the previous two:

# F(n) = n for n <= 1
#      = F(n-1) + F(n-2) for n > 1

# implementation in R

fiboR <- function(n) {
  if (n <= 1) n else
    fiboR(n-1) + fiboR(n-2)
}

# lets apply the function for the first eleven
# natural numbers

sapply(0:10, fiboR)

# see how the time efficiency changes
# with an increase in the number of recursive calls

benchmark(fiboR(10), 
          fiboR(15), 
          fiboR(20), 
          replications = 500)[, 1:4]

# C++ equivalent

cppFunction('int fiboC(int n) {
            if (n <= 1) return(n); else
            return(fiboC(n-1) + fiboC(n-2)); }')

# lets apply the function for the first eleven
# natural numbers

sapply(0:10, fiboC)

# comparison of efficiency betweeb C++ and R

benchmark(fiboR(25), fiboC(25))[, 1:4]

# nice acceleration...

# lets check if for C++ function computational 
# complexity grows as fast as in R

benchmark(fiboC(10), 
          fiboC(15), 
          fiboC(20), 
          replications = 10000)[, 1:4]

# NO!!!



### 5.  Vector as the function argument and its result #########################

# Assume that we are to assess the quality of forecasts
# obtained from many models for one observation with a single real value
# (vector of forecasts from differnt models - single real value for comparison)

# we will calculate a relative forecast error for vector predictions and one real value:
# (check how much each of these models was wrong)

# function in R
relerrorR <- function(real, forecasts) {
  abs(real - forecasts)/real
}

# it is not obvious here that the function expects a real argument as a scalar (single value)
# in R should be explained in the documentation for the function.

# This function uses vectorised operations - where R shines the most!


# in the C++ version we must clearly declare the types of arguments
# this really gives the clarity about the function purpose

cppFunction('NumericVector relerrorC(double real, 
                                     NumericVector forecasts) {      
             int n = forecasts.size();
             NumericVector relerror(n);
              
             for(int i = 0; i < n; i++) {
              relerror[i] = fabs(real - forecasts[i])/real;
              }
              return relerror;
              }')

# This function introduces two new elements:
# - we create a new numeric vector with the length of n using the constructor: 
#    NumericVector relerror(n);
#   Another convenient way to create a vector is copying existing vector: 
#   NumericVector new = clone(existing).
# - if we want to calculate the absolute value in C++ and get the result of 
#   class double, we must use fabs() or std::abs().
#   Using just abs() returns the value of the int type - rounded to integer!
#   (in C++ there are several different functions for calculating the absolute 
#   value for different types of input data)

# see how functions work on artificially generated data

set.seed(1234556789)

r <- rnorm(1) # "real" value

f <- rnorm(100) # results of 100 "forecasts"

# lets check if result is the same

relerrorR(r, f)
relerrorC(r, f)  

identical(relerrorR(r, f),
          relerrorC(r, f))

# it is the same

benchmark("R" = relerrorR(rnorm(1), rnorm(100)),
          "C" = relerrorC(rnorm(1), rnorm(100)),
          replications = 50000
)

# So, not always a function written in C++ will work (much) faster 
# than its R equivalent. Even if it works several times faster, one needs
# to take into account tha writing a counterpart in C++ also takes some time.



### 5.  Matrix as the function argument ########################################

# Each vector type has its matrix equivalent:
# - NumericMatrix
# - IntegerMatrix
# - CharacterMatrix
# - LogicalMatrix

# let's create a C++ version of the colMeans(x) function, 
# which calculates mean separately for each column of a matrix or table

cppFunction('NumericVector colMeansC(NumericMatrix x) {
                int nrow = x.nrow(), ncol = x.ncol();
                NumericVector colMeans(ncol);
                
                for (int j = 0; j < ncol; j++) {
                  double total = 0;
                  for (int i = 0; i < nrow; i++) {
                    total += x(i, j);
                    }
                  colMeans[j] = total/nrow;
                }
                return colMeans;
              }')

# New elements in the above example:
# - in C++, we reference to the element/subset of a MATRIX with () and not [].
# - in C++, we use the .nrow() and .ncol() methods to get dimensions of the matrix.

# check how the function works in C++ compared to R

# create a large matrix with 10 columns

x <- matrix(rnorm(5e6),
            ncol = 10)

colMeans(x)

colMeansC(x)

# results seem to be the same

identical(colMeans(x), colMeansC(x))

# but it is not the same - why?
# check the differences

colMeans(x) - colMeansC(x)

# there are differences, but only on the 17th place after the comma 
# which results from the differences in rounding values in R and 
# C++ (precision of storing double values) - it's always worth checking 
# when converting code between programming languages

benchmark("R" = colMeans(x),
          "C" = colMeansC(x),
          replications = 1000
)

# here also the use of C++ does not help much - because
# the colMeans() function is already written in C++




### 6.  Using sourceCpp() ######################################################

# Up to now we've created functions in C++ using cppFunction()
# This gives the C++ code presentation simplicity, but in practice 
# it also has disadvantages - eg lack of C++ syntax highlighting, 
# which would make the work easier.

# In practice, to define functions in R using C++ more conveniently
# one can save them in separate files (*.cpp) and compile
# "remotely" using the sourceCpp() function.


# CAUTION!
# to edit *.cpp files one can use RStudio !!!!
# choose File/New File/C++ File
# and look at the example script created
# (it is not saved yet, so there is no .cpp extension)

# we can also look into the file "myMeanC2.cpp"

# In the *.cpp file we have to put several lines of headings:

# #include <Rcpp.h>
# this command gives us access to the Rcpp functions.
# The "Rcpp.h" file contains a list of function and class definitions provided by Rcpp.
# To refer to functions from the Rcpp package we can use the syntax: Rcpp::function_name

# using namespace Rcpp;
# this command loads the namespace of the Rcpp package,
# which allows avoid using Rcpp:: when referencing
# to the functions from this package - just the function_name will be enough

# Above EVERY function that we want to export
# / use in R, we add a tag:
# // [[Rcpp::export]]
# WARNING! space after // is NECESSARY!

# You can also embed the R code in special comment blocks
# inside the *.cpp file


# /*** R
# # This is R code
# */

# It is very convenient if after compiling the function
# and transferring it to R we want to run the test code.


# lets load a function that calculates the average 
# and handles missing data using the vector function 
# is_na() from "sugar" Rcpp;
# is_na() takes the vector as its argument and returns 
# the logical vector (LogicalVector).

sourceCpp("myMeanC2.cpp")

# check how previously defined myMeanC() works 
# on missing data 

myMeanC(c(1:10, NA))

# returns a missing value

myMeanC2(c(1:10, NA))

# and this correctly handles missing values




### Tasks ######################################################################

# Exercise 1.
# For each function included in the file "Exercise1_functionsC.cpp":
# - try to recognize what are the equivalents of the following 
#   functions in base R
# - compare their time efficiency with base R functions
#  (Do not worry if you do not understand all the elements of the code)

sourceCpp("Exercise1_functionsC.cpp")




# Exercise 2.
# Convert the following R functions into equivalents written in C++.
# For simplicity, you can assume that the input data does not contain
# missing values.
# - min()
# - cummax().
# - range()




# Exercise 3.
# Write functions in R and C++ that calculate:
# - kurtosis based on the value vector: 
#   https://en.wikipedia.org/wiki/Kurtosis
# - factorial based on an argument being a natural number
#   https://en.wikipedia.org/wiki/Factorial




#------------------------------------------------------------------------------
# Sources and additional materials:
# - official Rcpp website: http://www.rcpp.org/
# - Rcpp gallery: http://gallery.rcpp.org/
# - website of Dirk Edelbuettel: http://dirk.eddelbuettel.com/
# - Hadley Wickham "Advanced R": http://adv-r.had.co.nz/Rcpp.html
# - Masaki E. Tsuda "Rcpp for evertyone": https://teuder.github.io/rcpp4everyone_en/
# - Colin Gillespie, Robin Lovelace "Efficient R programming"
#   https://csgillespie.github.io/efficientR/rcpp.html
# - Rcpp intro: http://www.mjdenny.com/Rcpp_Intro.html
# - Dirk Eddelbuettel "Seamless R and C++, Integration" (2013)
#   https://github.com/jpneto/Markdowns/blob/master/benchmarking/Eddelbuettel%20-%20Seamless%20R%20and%20C++,%20Integration%20w.Rcpp%20(2013).pdf
# - stackoverflow: https://stackoverflow.com/questions/tagged/rcpp

# self-learning of C++
# - http://www.learncpp.com/ 
# - http://www.cplusplus.com/.
# - https://www.sololearn.com/Course/CPlusPlus/

