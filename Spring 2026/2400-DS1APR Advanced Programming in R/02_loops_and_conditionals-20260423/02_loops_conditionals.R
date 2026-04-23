#---------------------------------------------------------#
#                Advanced Programming in R                #
#             Class 2: loops and conditionals             #
#                 Academic year 2023/2024                 #
#                  Classes conducted by:                  #
#                Maria Kubara & Monika Kot                # 
#        Class 2 materials based on Ewa Weychert          #
#---------------------------------------------------------# 

Sys.setenv(LANG = "en")

# 1. Relational and logical expressions - reminder -----------------------------

# Before we move to conditionals and loops, we must understand how R evaluates
# logical conditions. Control flow (if, while, for) always depends on logical
# values (TRUE/FALSE). Therefore, we first revise relational operators,
# logical operators, and logical helper functions.


## 1.1 Relational operators ----------------------------------------------------

# Used to compare values. Always return TRUE or FALSE.

# ==  equal
# !=  not equal
# <   less than
# <=  less than or equal
# >   greater than
# >=  greater than or equal


## 1.2 Logical operators -------------------------------------------------------

# Logical operators combine or modify logical values (TRUE / FALSE).
# They are fundamental for building conditional statements.

### Basic logical operators ----

# |   disjunction (OR)   -> TRUE if at least one side is TRUE
# &   conjunction (AND)  -> TRUE only if both sides are TRUE
# !   negation (NOT)     -> reverses logical value


## Disjunction (OR)

# TRUE if at least one side is TRUE
TRUE  | TRUE   # TRUE
TRUE  | FALSE  # TRUE
FALSE | TRUE   # TRUE
FALSE | FALSE  # FALSE


## Conjunction (AND)

# TRUE only if both sides are TRUE
TRUE  & TRUE   # TRUE
TRUE  & FALSE  # FALSE
FALSE & TRUE   # FALSE
FALSE & FALSE  # FALSE


### Vectorised vs scalar logical operators ----

# & and | are vectorised (elementwise evaluation)
# && and || evaluate only the first element (used in control flow)

c(TRUE, FALSE) | c(FALSE, FALSE)   # elementwise
c(TRUE, FALSE) & c(FALSE, TRUE)

# Scalar operators (&&, ||) evaluate only the first element 
# vector as an argument is not accepted

c(TRUE, FALSE) || c(FALSE, FALSE)
c(TRUE, FALSE) && c(FALSE, TRUE)

# IMPORTANT:
# In if() statements, it is safer to use && or ||,
# because control flow requires a single TRUE/FALSE value.


### Exclusive OR ----

# xor(x, y)
# Logical exclusive OR.
# Returns TRUE if exactly one of the arguments is TRUE.
# Returns FALSE if both values are the same (both TRUE or both FALSE).

xor(TRUE, FALSE)  # TRUE
xor(FALSE, TRUE)  # TRUE
xor(TRUE, TRUE)   # FALSE
xor(FALSE, FALSE) # FALSE

# Logical identity showing how xor() works internally:
# (A & !B) | (!A & B)
# TRUE if A is TRUE and B is FALSE,
# OR if A is FALSE and B is TRUE.
(T & !F) | (!T & F)

# Also equivalent to:
TRUE != FALSE


## 1.3 Logical aggregation functions ------------------------------------------

# any(...)
# Returns TRUE if at least one element in a logical vector is TRUE.
# Often used for validation checks ("does any problem occur?").

a <- c(3, 8, -2, 0, 5)

any(a > 100)
# The output will be FALSE, since none of the elements of a are greater than 100.

any(a > 6)
# The output will be TRUE, since 8 is greater than 6


# all(...)
# Returns TRUE only if all elements in a logical vector are TRUE.
# Frequently used in defensive programming ("are all conditions satisfied?").

all(T,T,T)
# all are TRUE so return TRUE

all(T,F,T)
# one FALSE so return FALSE

rep(T,100)

all(rep(T,100))

all(rep(T,100), F)


first <- any(1 + 2 == 3, 2 + 3 == 4, 3 + 4 == 5)
first

second <- 2 + 3 == 5
second

third <- 3 + 4 == 7
third


all(first, second, third)


# We can use any() and all together as well :)
all(any(1 + 2 == 3, 2 + 3 == 4, 3 + 4 == 5), 2 + 3 == 5, 3 + 4 == 7)


## 1.4 Special numeric values: Inf and NaN ------------------------------------

# is.na() - missing values
# is.nan() - NaN (Not a Number) (impossible values)
# is.infinite() - infinite values
# is.finite() - finite values

# Division by zero produces special values in R.

pi / 0     # Inf  (non-zero divided by zero)
0 / 0      # NaN  (indeterminate form)

# Detection functions:
is.infinite(pi / 0)
is.nan(0 / 0)
is.finite(100)

# Inf represents infinity.
# NaN represents an undefined numerical result.


## 1.5 Type checking functions -------------------------------------------------

# Many R object types have corresponding is.*() functions.

is.character("Programming in R")
is.numeric(3)
is.data.frame(iris)

# We can check object class directly:
class(iris)
class(5)
class("abc")




# 2. If statements -------------------------------------------------------------

# Conditional statements allow a program to make decisions.
# Depending on whether a logical expression evaluates to TRUE or FALSE,
# different blocks of code are executed.
#
# The if statement is one of the fundamental control-flow tools in R.

## 2.1 The if instruction ------------------------------------------------------

# IMPORTANT:
# - if() expects a single logical value (TRUE or FALSE)
# - for control flow, prefer && and || (scalar operators)

### Syntax overview ----

## if syntax 
# if (condition) {
#   code executed if condition is TRUE
# }

## if - else syntax 
# if (condition) {
#   code executed if condition is TRUE
# } else {
#   code executed if condition is FALSE
# }

## if – else if – else syntax 
# else if allows us to test multiple conditions sequentially.

# if (condition1) {
#   code_if_condition1_is_TRUE
# } else if (condition2) {
#   code_if_condition2_is_TRUE
# } else {
#   code_if_all_previous_conditions_are_FALSE
# }

# Key idea:
# Conditions are evaluated from top to bottom.
# Once a TRUE branch is executed, the remaining branches are skipped.

## 2.2 Examples: basic if / if-else -------------------------------------------

# Example 1: if-else with OR (||)
# At least one of the conditions must be TRUE to return "Hello".
if (2 + 2 == 5 || 1 + 3 == 5) {
  "Hello"
} else {
  "World"
}

# Example 2: if-else with AND (&&)
# Both conditions must be TRUE to return "Hello".
if (2 + 2 == 4 && 1 + 3 == 5) {
  "Hello"
} else {
  "World"
}

# Note:
# You can write if statements in one line, but it reduces readability.
# It is better to use curly brackets in your projectss.

# One-line version (valid, but not recommended):
if (2 + 2 == 4 || 1 + 3 == 5) "Hello" else "World"
if (2 + 2 == 4 && 1 + 3 == 5) "Hello" else "World"


## 2.3 Example: else if (multiple branches) -----------------------------------

# Example 3: classify a number using else if
# This is a typical pattern: mutually exclusive conditions.
x <- -3

if (x > 0) {
  "Positive number"
} else if (x == 0) {
  "Zero"
} else {
  "Negative number"
}

# Example 4: why order matters in else if
# The first TRUE condition "wins".
x <- 5

if (x > 0) {
  "Greater than zero"
} else if (x > 3) {
  "Greater than three"
}

# Even though x > 3 is TRUE,
# it is never checked because x > 0 was already TRUE.


## 2.4 Practical example: modifying an object ---------------------------------

a <- 3
b <- 1
c <- 4

matrix1 <- matrix(0, nrow = 5, ncol = 2)
matrix1

# Example 5: simple if (execute only when condition is TRUE)
# If a == 3, fill row 3, column 1 with 100.
if (a == 3) {
  matrix1[a, 1] <- 100
}
matrix1

# Example 6: if-else
# If b == 2 set row b, column 1 to 1, otherwise set it to 101.
if (b == 2) {
  matrix1[b, 1] <- 1
} else {
  matrix1[b, 1] <- 101
}
matrix1

# Example 7: if-else if-else with combined conditions
# Notice the use of parentheses for readability.
if (a == 4 || (b == 2 && c == 4)) {
  matrix1[a, 1] <- 105
} else if (c == 4) {
  matrix1[c, 1] <- 110
} else {
  matrix1[b, 1] <- 101
}
matrix1


## 2.5 Common pitfall: vector conditions in if() -------------------------------

# if() uses only the FIRST element of a logical vector.
# This can lead to subtle bugs if you accidentally pass a vector condition.

if (c(TRUE, FALSE)) {
  "This runs because only the first element is used."
}

# Takeaway:
# Always ensure the condition inside if() is a single TRUE/FALSE value.
# When working with vectors, combine conditions using any() / all().



# 3. ifelse(): vectorised conditional ------------------------------------------

# In R, the if statement is NOT vectorised: it expects a single TRUE/FALSE.
# When we need to apply a condition elementwise over a vector,
# we can use ifelse(), which is vectorised.

## 3.1 Syntax ------------------------------------------------------------------

# ifelse(test, yes, no)

# test: a logical vector (e.g., length 5)
# yes : value(s) returned where test is TRUE
# no  : value(s) returned where test is FALSE
#
# The result is a vector of the same length as `test`.

## 3.2 Why we need ifelse() ----------------------------------------------------

# Example: checking odd/even for many numbers
# The condition below produces a logical vector of length 5.

1:5 %% 2 == 1  # TRUE FALSE TRUE FALSE TRUE

# if() is not vectorised, so using it with a vector condition is a mistake:
# (it uses only the first element and may warn you)
if (1:5 %% 2 == 1) { 
  print("odd") 
} else { 
  print("even") 
}

# Correct vectorised approach:
ifelse(1:5 %% 2 == 1, "odd", "even")


## 3.3 ifelse() on data frames -------------------------------------------------

# ifelse() is often used to create new columns based on conditions.

df <- data.frame(
  team = c("A", "A", "B", "B", "B", "C", "D"),
  points = c(4, 7, 8, 8, 8, 9, 12),
  rebounds = c(3, 3, 4, 4, 6, 7, 7)
)
df

# Example 1: simple two-category label
# If team == "A" -> "great", otherwise -> "bad"
df$rating <- ifelse(df$team == "A", "great", "bad")
df


## 3.4 Nested ifelse(): more than 2 categories --------------------------------

# When you need more than two categories, you can nest ifelse() calls.
# NOTE: nesting works, but can quickly become hard to read for many categories.

# Example 2: three-category label
# A -> "great"
# B -> "OK"
# otherwise -> "bad"
df$rating <- ifelse(df$team == "A", "great",
                    ifelse(df$team == "B", "OK", "bad"))
df


## 3.5 ifelse() inside dplyr pipelines -----------------------------------------

# In tidy workflows, ifelse() is commonly used inside mutate().
# (For larger projects, you will later prefer dplyr::case_when() for readability.)

library(dplyr)

iris_1 <- iris

# Example 3: simple binary coding
iris_1$new_column_1 <- ifelse(iris_1$Species == "versicolor", 1, 2)
iris_1

# Example 4: nested conditions
# versicolor -> 1
# virginica AND Sepal.Length > 7.6 -> 2
# otherwise -> 3
iris_1$new_column_2 <- ifelse(
  iris_1$Species == "versicolor", 1,
  ifelse(iris_1$Species == "virginica" && iris_1$Sepal.Length > 7.6, 2, 3)
)
# IMPORTANT BUG NOTE:
# The line above uses && which is NOT vectorised.
# For elementwise conditions inside ifelse(), use & not &&.

# Correct vectorised version:
iris_1$new_column_2 <- ifelse(
  iris_1$Species == "versicolor", 1,
  ifelse(iris_1$Species == "virginica" & iris_1$Sepal.Length > 7.6, 2, 3)
)
iris_1

# Same idea in a pipeline:
iris_2 <- iris %>%
  mutate(
    new_column_1 = ifelse(Species == "versicolor", 1, 2),
    new_column_2 = ifelse(Species == "versicolor", 1,
                          ifelse(Species == "virginica" & Sepal.Length > 7.6, 2, 3))
  )
head(iris_2)

# Quick summaries to check the result:
iris_2 %>%
  group_by(new_column_1) %>%
  summarise(n = n(), .groups = "drop") %>%
  mutate(
    total = sum(n),
    percent = paste0(round(100 * (n / total), 2), " %")
  )


## 3.6 Key takeaways ------------------------------------------------------------

# - if() is for single TRUE/FALSE conditions (control flow).
# - ifelse() is vectorised and works elementwise over vectors.
# - Use & and | inside ifelse() conditions (not && / ||).
# - Nested ifelse() works, but for many categories consider case_when().


# 4. For loops ---------------------------------------------------------------

# A for loop repeats a block of code for each value in a sequence.
# It is used when you need explicit iteration (especially for debugging,
# simulation, or when iteration is clearer than vectorisation).

## 4.1 Basic syntax ------------------------------------------------------------

# for (i in sequence) {
#   code using i
# }

wek <- 1:20
wek

# Example 1: print the loop counter (useful for tracing/debugging)
for (i in 1:5) {
  print(i)
}

# Example 2: print a constant object each iteration (usually not useful,
# but demonstrates that the loop body runs multiple times)
for (i in 1:3) {
  print(wek)
}

## 4.2 Iterating over indices vs values ---------------------------------------

# Example 3: iterate over indices and print element i
for (i in 1:10) {
  print(wek[i])
}

# Example 4: iterate over values directly (often cleaner)
for (value in wek[1:10]) {
  print(value)
}

# Note:
# - use index iteration when you need positions
# - use value iteration when you only need the values

## 4.3 seq_along(): robust indexing -------------------------------------------

# 1:length(x) can be dangerous when x is empty:
1:length(c())   # returns 1:0 (not what we usually want)
seq_along(c())  # returns integer(0) (safe)

# Example 5: safe iteration over all elements
for (i in seq_along(wek)) {
  print(wek[i])
}

for (i in 1:length(wek)) {
  print(wek[i])
}



## 4.4 Choosing specific indices ----------------------------------------------

# Example 6: manually chosen indices
for (i in c(2, 8, 14, 20)) {
  print(wek[i])
}

interesting_numbers <- c(2, 8, 14, 20)

# Example 7: print a labeled message (helpful later in exercises)
for (i in interesting_numbers) {
  print(paste0("Index = ", i, ", value = ", wek[i]))
}

## 4.5 Custom step sizes -------------------------------------------------------

# Example 8: iterate over every second element
for (i in seq(1, length(wek), by = 3)) {
  print(paste0("i = ", i, ", wek[i] = ", wek[i]))
}

## 4.6 Iteration over characters ----------------------------------------------

# Example 9: iterate over letters and build labels
for (i in letters[1:5]) {
  print(paste0("section_", i))
}

## 4.7 break and next (flow control inside loops) ------------------------------

# break stops the loop immediately
for (i in 1:25) {
  if (i > 10) {
    print("Loop is broken!")
    break
  }
  print(paste0("i = ", i, ", wek[i] = ", wek[i]))
}

# next skips the rest of the current iteration and moves on
for (i in 1:25) {
  if (i > 10 && i < 20) {
    print(paste0("Skipping i = ", i))
    next
  }
  # Note: wek has only 20 elements, so guard indexing for i > 20
  if (i <= length(wek)) {
    print(paste0("i = ", i, ", wek[i] = ", wek[i]))
  } else {
    print(paste0("i = ", i, " is out of wek bounds -> not printing wek[i]"))
  }
}

## 4.8 Nested loops ------------------------------------------------------------

# Nested loops are useful for working with matrices, grids, simulations, etc.

matrix1 <- matrix(0, 10, 2)
matrix1
number <- 1

for (i in 1:nrow(matrix1)) {
  for (j in 1:ncol(matrix1)) {
    matrix1[i, j] <- number
    
    # Example 10: print progress (useful for debugging nested loops)
    print(paste0("Filled cell [", i, ", ", j, "] with ", number))
    
    number <- number + 1
  }
}
matrix1

## 4.9 Printing formatted messages (placeholders) ------------------------------

# These examples show ways to print clean messages inside loops.
# This will be useful later for debugging, logging, and progress tracking.

# Base R: paste0()
for (i in 1:5) {
  print(paste0("This is placeholder: ", i, "."))
}

# stringr::str_interp()
library(stringr)
for (i in 1:5) {
  print(str_interp("This is placeholder: ${i}."))
}

# glue::glue()
library(glue)
for (i in 1:5) {
  print(glue("This is placeholder: {i}."))
}



# EXERCISES ####################################################################


## Exercise 1 ##################################################################

# Write if statement, which will return sum of a and b variables (if they are 
# numbers), or their concatenation (if they are strings) and "error" in other 
# cases.

a <- 4
b <- "3"


## Exercise 2 ##################################################################

# Write a loop, which will work with any dataset (which is a data.frame object) 
# and for each integer variable in the database create a boxplot, for numeric 
# variable histogram, and for factor variables barplot. 


# Dataset for examples:
library(MASS)
data(survey)
head(survey)
help(survey)


# Hints for graphs:
# boxplot(survey$Wr.Hnd)
# boxplot(survey[, 2])
# hist(survey$Wr.Hnd)
# hist(survey[, 2])
# barplot(table(survey$Sex))
# barplot(table(survey[, 2]))



## Exercise 3 ##################################################################

# A. Read the data in csv format from a folder read_data using classical for loop 
# as a separate file into R. Name the file in R space as "dataset_" + file number 

# B. Read the data in csv format from a folder read_data using classical for loop 
# and append then into one dataset

# C. What is the name of additional file in a folder read_data? What command in R 
# can you use to find out?




## Exercise 4 ##################################################################
# Create loop that prints a tree made of stars (*) with tree trunk equal to two stars (**)

# Hints:
# - use two nested steps per row: (1) print spaces, (2) print stars
# - spaces count decreases each row; stars count increases each row
# - helpful tools: rep(), paste(..., collapse = ""), cat()
# - star count pattern: 1, 3, 5, 7, ... -> (2*row - 1)
# - trunk can be printed after the loop (or when row == tree_height)

tree_height <- 10
