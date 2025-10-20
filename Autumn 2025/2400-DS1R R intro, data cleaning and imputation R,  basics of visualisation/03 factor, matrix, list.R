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

