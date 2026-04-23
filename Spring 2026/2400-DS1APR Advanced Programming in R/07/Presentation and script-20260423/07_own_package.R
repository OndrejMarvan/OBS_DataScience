#---------------------------------------------------------#
#                 Advanced Programming in R               #
#                    Creating own package                 #
#                 classes and methods, S3 system          #
#              class taught by: dr Maria Kubara           #
#        materials by: Piotr Wójcik, Piotr Ćwiakowski     #
#---------------------------------------------------------#     

# lets load needed packages

install.packages("devtools") 
install.packages("roxygen2")

library(devtools)
library(pkgbuild)
library(roxygen2)

# See:
# https://www.tidyverse.org/articles/2018/10/devtools-2-0-0/
# https://devtools.r-lib.org/


# lets check if Rtools are installed
pkgbuild::find_rtools()

# set the path for the packages 
# If you create more packages - it's good to have one separate folder
# to store all of them. Here we will use new folder in which we will 
# create folders with new packages (as a part of the larger path)
# (remember to put slash `/` at the end)

path_to_packages <- "E:/10 own package/packages/"

# IMPORTANT! Path cannot include special characters


# some examples of packages

# 1. MyFirstPackage
# The simplest package, containing only standard 
# functions - no new classes.

# We create the package skeleton in the given path.
# The `create_package()` function is used for this
# from the `usethis` package

create_package(path = paste0(path_to_packages, 
                             "MyFirstPackage"))

# Once a skeleton is created RStudio opens a new
# window, but we can close it and still run 
# everything from this window

# let's see what makes up the skeleton of our package

# let's look at the file "_to_package/my_mean2.R"
# it contains the function code with additional 
# markers of the roxygen2 package

# copy this file to the "MyFirstPackage/R" folder

# then lets run the command

roxygenise(package.dir = paste0(path_to_packages, 
                                "MyFirstPackage"))
# or
devtools::document(pkg = paste0(path_to_packages, 
                                "MyFirstPackage"))

# the "man" folder and a function documentation file
# have been added to the package

# the "NAMESPACE" file has also been modified 
# - let's look into it

# It would be good to change the package description
# in the DESCRIPTION file

# the next step is to validate the package

devtools::check(paste0(path_to_packages, 
                       "MyFirstPackage"))

# ERROR! despite the declaration, we don't use
# the ggplot2 function at all

# remove from the file "R/my_mean2.R" a line
# #' @import ggplot2
# and one more directly above

# and try once again

devtools::check(paste0(path_to_packages, 
                       "MyFirstPackage"))

# we have 1 error and one warning

# error applies to unused function arguments
# this is the third example in the function code:
# "R/my_mean2.R"
# my_mean2(1:50, rnorm(20), FALSE, TRUE)

# replace this line with:
# my_mean2(c(1:50, rnorm(20), FALSE, TRUE))

# we need to regenerate the documentation

roxygenise(package.dir = paste0(path_to_packages, 
                                "MyFirstPackage"))

# warning applies to license information
# in DESCRIPTION file

# WARNING: 
# Non-standard license specification:
# `use_mit_license()`, `use_gpl3_license()` or friends 
# to pick a license

# now the entry looks like this:
# License: `use_mit_license()`, `use_gpl3_license()` 
# or friends to pick a license

# let's change this line to:
# License: GPL-2

# three times lucky :)

devtools::check(paste0(path_to_packages, 
                       "MyFirstPackage"))

# now there are no errors, warnings or notes :)

# let's install the new package by loading it immediately
# (Note! It should be written in the path without 
# special characters)

devtools::install(pkg = paste0(path_to_packages, 
                               "MyFirstPackage"), 
                  reload = TRUE)

library(MyFirstPackage)

# let's try to use a function from this package

MyFirstPackage::my_mean2(1:30)

# lets see the function help

?my_mean2

# we can save the package to a single
# source file ("build it")

devtools::build(paste0(path_to_packages, 
                       "MyFirstPackage"))

# and send this file to anyone you want
# your package with


#------------------------------------------------------------
# 2. The simplest package, also containing new S3 classes,
#    generic functions and methods.

# create the skeleton of the package in the path provided

create_package(path = paste0(path_to_packages, 
                             "MySecondPackage"))

# let's look at the file "_to_package/clientS3.R"
# it contains the function code with additional
# markers of roxygen2 package

# let's copy this file to the folder "MySecondPackage/R"

# and run the command

roxygenise(package.dir = paste0(path_to_packages, 
                                "MySecondPackage"))
# or
devtools::document(pkg = paste0(path_to_packages,
                                "MySecondPackage"))

# the "man" folder and a function documentation file
# have been added to the package

# the "NAMESPACE" file has also been modified - let's look at it

# It would be good to change the package description 
# in the DESCRIPTION file

# let's change at least the license information in it:
# License: GPL-2

# let's check the correctness of the package

devtools::check(paste0(path_to_packages, 
                       "MySecondPackage"))

# we have no errors, but there is 1 warning:

# checking S3 generic/method consistency ... WARNING

# is due to the fact that methods must include
# all arguments of generic functions.

# let's check how it is in our case

print
print.client

# method print.client() has just one argument (x),
# and a generic function in addition has an argument ...

mean
mean.client

# the same applies to generic function mean 
# and our method mean.client

# lets add an argument ... in our methods
# mean.client and print.client (in the file "R/clientS3.R")

# and let's check the package again

devtools::check(paste0(path_to_packages, 
                       "MySecondPackage"))

# now everything is OK!

# let's install the new package by loading it immediately
# (Note! It should be written in the path
# without special characters)

devtools::install(pkg = paste0(path_to_packages, 
                               "MySecondPackage"), 
                  reload = TRUE)

library(MySecondPackage)

# let's see help for the client class/function

?client

# lets try to use the function client()

MySecondPackage::client("Joan", 
                        "Warren", 
                        24, 
                        "F", 
                        FALSE)

# the appropriate print() method worked immediately

# let's see help for function age()

?age

# we can save the package to 
# a single source file ("build it")

devtools::build(paste0(path_to_packages, 
                       "MySecondPackage"))


#---------------------------------------------------------
# 3. The simplest package, also containing new S4 classes,
#    generic functions and methods.

# create the skeleton of the package in the path

create_package(path = paste0(path_to_packages,
                             "MyThirdPackage"))

# let's look at the file "_to_package/clientS4.R"
# it contains the function code with additional
# markers of roxygen2 package

# let's copy this file to the folder "MyThirdPackage/R"

# and then run the command

roxygenise(package.dir = paste0(path_to_packages, 
                                "MyThirdPackage"))
# or
devtools::document(pkg = paste0(path_to_packages, 
                                "MyThirdPackage"))

# the "man" folder and a function documentation file
# have been added to the package

# the "NAMESPACE" file has also been modified - let's look at it

# It would be good to change the package description 
# in the DESCRIPTION file

# let's change at least the license information in it:
# License: GPL-2

# check the correctness of the package

devtools::check(paste0(path_to_packages,
                       "MyThirdPackage"))

# we only have one note that the package
# methods has been used but is not declared

# we can ignore it at the moment

# let's install the new package by loading it immediately
# (Note! It should be written in the path 
# without special characters)

devtools::install(pkg = paste0(path_to_packages, 
                               "MyThirdPackage"), 
                  reload = TRUE)

library(MyThirdPackage)

# let's see help for the client4 class/function

??client4

?age4

#--------------------------------------------------------------
# Sources and additional materials
# See - html file
