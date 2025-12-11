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

# 1. Write your own function "max75" that returns the 75% of the maximum value of a 
# given variable. You can assume that the variable is a numeric. Use the name 
# maximum75 for the temporary calculations done in the function.

# Use the template:

# ... <- ....{           # paste that in 1-definition field in the test
#    maximum75<-...      # paste that in 1-operation field in the test
# return(maximum75)      
#}



# 2. Modify the loop so that it prints out only the values divisible by 3. 
# TIP: check out the %% symbol :)

for(j in seq(2,20,4)){
  if(.......) { # paste the condition that you wrote in the 2) field in the test
    print(j)
  }
}


# 3. Using the "next" instruction write a loop which will print out only the
# text values longer than 5 characters.

textVector <- c("Anna", "longitude", "bike", "car", "Sandra") 

for(text in textVector){
  # write here the code will manipulate the loop execution
  # try to limit your code here to one line  (check out the TIP in line 190)
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
# for(row in 1:nrow(myMatrix)){
#   ....... # paste your code for the body of the loop in the 4a) field in the test
# }


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

# for(row in 1:nrow(myMatrix)){
#   for(col in 1:ncol(myMatrix)){
#     .... # paste your code for the body of the loop in the 4b) field in the test
#   }
# }


# c) Write a loop similar to the one in b) that will now reassign the values of 
# the matrix to look like this

# [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
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



# 5. Write a function myMulti which will create a matrix with multiplication 
# table of size n x n, where n will be the argument of your function.

# Use the following template for writing your answer:

# myMulti <- ...... # paste the code from this line to slot 5a) in the test
#   myMatrix <- 
#   for(......)
#     for(........)
#        myMatrix....... # paste the code from this line to slot 5b) in the test
#   .....
#   return(...)


# 6. Write a function which will take a text vector of package names from CRAN
# and will check if they are installed. If not - it will install them and load them,
# and if they are already installed - the function will just load them. 

