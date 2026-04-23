#---------------------------------------------------------#
#                Advanced Programming in R                #
#                Class 5: functions part 1                #
#                 Academic year 2025/2026                 #
#                  Classes conducted by:                  #
#                Maria Kubara & Monika Kot                # 
#        Class 5 materials based on Ewa Weychert          #
#---------------------------------------------------------# 

Sys.setenv(LANG = "en")


# 1. Why functions? ------------------------------------------------------------

# In previous classes we wrote code step by step.
# Today we move to one of the most important programming tools in R: functions.

# Functions allow us to:
# - avoid repeating the same code many times,
# - separate inputs (arguments) from the algorithm,
# - make scripts shorter and easier to read,
# - write reusable solutions,
# - prepare code that is easier to test and debug.

# A good mental model:
# a function is a small machine:
# 1) we give it inputs,
# 2) it performs some operations,
# 3) it gives us an output.


# 2. Basic syntax --------------------------------------------------------------

# General form:

# name_of_function <- function(arguments) {
#   code
#   return(result)
# }

# function(...) creates the function
# <- assigns this function to an object name
# { } contains the body of the function, that is, the code executed inside it

add_two_numbers <- function(x, y) {
  # x and y are input arguments
  # the function adds them together
  return(x + y)
}

# Call the function with two numbers
add_two_numbers(2, 3)

# The same function can be reused with different values
add_two_numbers(328, 567)

# Usually we assign the result to an object if we want to use it later.
result <- add_two_numbers(10, 5)
result

# 3. What does a function return? ---------------------------------------------

# A function always returns one object.

# If return() is not used explicitly, R returns the last evaluated expression.
# This often works, but at the beginning it is good to state output explicitly,
# because it makes the code easier to read.

double_value <- function(x) {
  # The last evaluated expression is x * 2
  # so this value will be returned automatically
  x * 2
}

double_value(4)

# Example: the last line decides what comes out of the function.
strange_function <- function(x) {
  # This line is evaluated, but its value is not returned,
  # because it is not the last line.
  x
  
  # This line is also evaluated, but again not returned.
  x * 2
  
  # This is the last evaluated expression,
  # so this is what the function returns.
  100
}

strange_function(4)
strange_function(10)

# Example: no value returned by the function
unclear_return <- function(x) {
  y <- x * 2
}

unclear_return(4)

# Cleaner version:
clear_return <- function(x) {
  # First compute an intermediate result
  y <- x * 2
  
  # Then return it explicitly
  return(y)
}

clear_return(4)

# 4. Returning more than one object -------------------------------------------

# A function returns one object.
# But this one object can be a list that contains many elements.

# This is a very common pattern in R:
# instead of returning several separate objects,
# we return one list that stores them together.

basic_summary <- function(x) {
  # Create a list with three named components
  out <- list(
    minimum = min(x),   # smallest value in x
    maximum = max(x),   # largest value in x
    average = mean(x)   # arithmetic mean
  )
  
  # Return the whole list as one object
  return(out)
}

summary_result <- basic_summary(c(4, 8, 10, 12))
summary_result

# Accessing list elements:
summary_result$average      # using $
summary_result[["maximum"]] # using [[ ]]

# 5. Function arguments --------------------------------------------------------

# Arguments are the inputs that control how the function works.

# 5.1 Required arguments -------------------------------------------------------

# Here both x and y are required.
# If we do not provide them, the function cannot work.

rectangle_area <- function(x, y) {
  return(x * y)
}

rectangle_area(4, 6)

rectangle_area(4)   # Error: argument "y" is missing

# 5.2 Default arguments --------------------------------------------------------

# Here x and y have default values.
# This means the user may omit them.

rectangle_area2 <- function(x = 1, y = 1) {
  return(x * y)
}

# No arguments given -> defaults are used
rectangle_area2()

# Only y is changed, x stays at its default value
rectangle_area2(y = 4)

# Both defaults are replaced
rectangle_area2(x = 3, y = 7)

# 5.3 Named arguments ----------------------------------------------------------

# Naming arguments improves readability and reduces the risk of mistakes.
# It becomes especially useful when a function has many arguments.

rectangle_area3 <- function(width = 1, height = 1) {
  return(width * height)
}

rectangle_area3()
rectangle_area3(width = 4)
rectangle_area3(width = 3, height = 7)

# Compare:
rectangle_area3(3, 7)                 # works by position
rectangle_area3(height = 7, width = 3) # works by name, order no longer matters

# 5.4 Optional arguments with NULL ---------------------------------------------

# Sometimes an argument is optional, but we do not want to assign
# a fixed numeric default.
# In such cases NULL is often used to mean:
# "the user did not supply an additional value"

add_optional_bonus <- function(x, bonus = NULL) {
  # Check whether bonus was provided
  if (is.null(bonus)) {
    # If bonus is NULL, return x unchanged
    return(x)
  } else {
    # Otherwise add the bonus
    return(x + bonus)
  }
}

add_optional_bonus(10)
add_optional_bonus(10, bonus = 5)

# 6. Vectorisation in functions ------------------------------------------------

# Many base R operations are vectorised.
# This means they work on whole vectors, not only single values.

# If we use vectorised operations inside our own function,
# our function will often work on vectors automatically.

score_formula <- function(a, b, c) {
  # Multiplication and addition in R are vectorised
  return(a + b * c)
}

# First try with single numbers
score_formula(1, 2, 3)

# Now try with vectors of the same length
v1 <- 1:5
v2 <- 6:10
v3 <- 2:6

score_formula(v1, v2, v3)

# There is no loop written by us,
# but R still performs the computation element by element:
# result[1] = v1[1] + v2[1] * v3[1]
# result[2] = v1[2] + v2[2] * v3[2]
# and so on.

# This is one of the main strengths of R:
# often we can avoid writing explicit loops for simple computations.


# 7. First contact with defensive programming ---------------------------------

# What happens if the user gives the wrong type of input?
score_formula(1, 2, "3")

# A basic defensive version:

score_formula_safe <- function(a, b, c) {
  # Check whether all inputs are numeric
  if (!is.numeric(a) || !is.numeric(b) || !is.numeric(c)) {
    stop("All arguments must be numeric!")
  }
  
  # Only if the check passes, compute the result
  return(a + b * c)
}

score_formula_safe(1, 2, 3)
score_formula_safe(1, 2, "3")

# stop() immediately interrupts function execution
# and displays an error message.

# We will come back to defensive programming in more detail next class.

# 8. Argument matching and inspecting functions --------------------------------

# You can inspect the formal arguments of a function with args().
# This is useful when you do not remember the argument names.

args(score_formula)
args(rectangle_area3)
args(mean)

# R matches supplied arguments to formal arguments in several ways.

# 1) exact name
seq(from = 10, to = 100, by = 0.8)

# 2) position
# Here 10 is matched to from, 100 to to, and 0.8 to by
seq(10, 100, 0.8)

# This still works syntactically, but it means something different,
# because the values are matched by position, not by meaning
seq(0.8, 100, 10)

# 3) sometimes partial matching
# R may accept a shortened argument name
# if it can match it unambiguously to one formal argument.

my_fun <- function(long_argument_name = 10) {
  long_argument_name * 2
}

my_fun(long = 5)

# This works, but is NOT recommended in real code
# because it may become ambiguous and hard to read.

# 9. Lazy evaluation -----------------------------------------------------------

# In R, arguments are evaluated only when they are actually needed.
# This is called lazy evaluation.

lazy_example <- function(x, y) {
  # Only x is used here
  return(x + 1)
}

lazy_example(5)

# y is supplied, but never used
lazy_example(5, 3)

# We still supplied y, but the function never touches it,
# so R does not need to evaluate it.

lazy_example(5, "3")

# Even though y is not numeric, the function works,
# because y is never used inside the function body.
#
# Important precision:
# this is not "an error hidden by magic" -
# it is simply that evaluation of y never happens.

# More realistic example:
# ggplot objects are often described as "plot recipes".
# Creating the object usually stores instructions,
# while the actual drawing happens when the object is printed.

library(ggplot2)

p_ok <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  theme_classic()

# Printing the object displays the plot
p_ok

p_bad <- ggplot(iris, aes(x = Sepal.Length2, y = Sepal.Width, color = Species)) +
  geom_point() +
  theme_classic()

# No error yet - the plot object was created as a recipe.
# The problem appears when ggplot tries to render the plot.
p_bad

# 10. Wrappers and ... ---------------------------------------------------------

# A wrapper is a function that calls another function,
# often with some defaults chosen by us.

# This is useful when:
# - we repeatedly use the same settings,
# - we want a simpler interface,
# - we want to standardise style or output.

x <- 1:100
y <- x^2

# Base plot with default settings
plot(x, y)

# Base plot with some manually added settings
plot(x, y, type = "l", col = "red")

simple_plot <- function(x, y) {
  # This wrapper always draws a red line plot
  plot(x, y, type = "l", col = "red")
}

simple_plot(x, y)


# Problem:
# The wrapper is too rigid.
# We cannot easily pass additional graphical arguments.
# simple_plot(x, y, lwd = 2)

# Solution: use ...
# ... means "accept additional arguments and pass them forward"

smart_plot <- function(x, y, type = "l", ...) {
  # type has a default value
  # ... collects all extra arguments supplied by the user
  plot(x, y, type = type, ...)
}

smart_plot(x, y)

# Additional arguments are forwarded to plot()
smart_plot(x, y, lwd = 3, col = "steelblue", main = "Wrapped plot")
smart_plot(x, y, type = "p", pch = 19)

# Many base R functions and many package functions use ...
# especially in graphics and modelling.

args(plot)
args(ggplot)

# 11. A function can take another function as input ----------------------------

# In R, functions are first-class objects.
# This means that a function can be:
# - stored in an object,
# - passed as an argument,
# - returned from another function.
#
# By convention, an argument that expects a function
# is often called FUN.

apply_once <- function(x, FUN, ...) {
  # Call the function stored in FUN on x
  # ... allows us to pass extra arguments to FUN
  FUN(x, ...)
}

# mean is passed as an argument
apply_once(1:10, mean)

# median is passed as an argument
apply_once(1:10, median)

# paste is passed as an argument,
# and collapse = "-" is forwarded through ...
apply_once(letters[1:5], paste, collapse = "-")

# This idea is very important,
# because many tools in R (for example apply-family functions)
# rely on passing functions as arguments.

# 12. Mini case study: writing a useful function -------------------------------


# Example: coefficient of variation (CV) for a numeric vector.
# Formula:
# CV = sd(x) / mean(x)

# This is a nice example because it combines:
# - arguments,
# - checks,
# - optional behaviour,
# - return value.

cv_vector <- function(x, na.rm = FALSE, percent = FALSE) {
  # Step 1: check that x is numeric
  if (!is.numeric(x)) {
    stop("x must be numeric.")
  }
  
  # Step 2: compute the coefficient of variation
  # sd() and mean() both receive the na.rm argument
  value <- sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
  
  # Step 3: optionally convert to percentages
  if (percent) {
    value <- value * 100
  }
  
  # Step 4: return the result
  return(value)
}

cv_vector(c(10, 12, 14, 16))
cv_vector(c(10, 12, 14, 16), percent = TRUE)
cv_vector(c(10, 12, NA, 16), na.rm = TRUE, percent = TRUE)

# Extension: now we write a slightly more practical version
# that works on a data frame and a selected column name.

cv_data_frame <- function(data, variable, na.rm = FALSE, percent = FALSE) {
  # Check 1: the input must be a data frame
  if (!is.data.frame(data)) {
    stop("data must be a data.frame.")
  }
  
  # Check 2: the selected variable name must exist in the data frame
  if (!variable %in% names(data)) {
    stop("variable is not a column in data.")
  }
  
  # Extract the selected column by name
  x <- data[[variable]]
  
  # Check 3: the selected column must be numeric
  if (!is.numeric(x)) {
    stop("Selected column must be numeric.")
  }
  
  # Compute CV
  value <- sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
  
  # Optionally convert to percent
  if (percent) {
    value <- value * 100
  }
  
  # Return final value
  return(value)
}

library(MASS)
data(survey)

cv_data_frame(survey, "Height", na.rm = TRUE)
cv_data_frame(survey, "Height", na.rm = TRUE, percent = TRUE)

# Misspelled column name
cv_data_frame(survey, "Heigh", na.rm = TRUE, percent = TRUE)

# Wrong type of first argument: x is not a data frame here
cv_data_frame(x, "Height", na.rm = TRUE, percent = TRUE)

# 13. Key takeaways ------------------------------------------------------------

# - functions package reusable code,
# - arguments can be required, default, or optional,
# - return() makes the output explicit,
# - lists are useful when returning many values,
# - many functions in R are vectorised,
# - ... passes additional arguments forward,
# - FUN means that a function can be passed as an argument,
# - defensive checks are worth starting early.





# EXERCISES ####################################################################

## Exercise 1 ##################################################################

# Write a function called mad_manual() that computes median absolute deviation:
# MAD = median(|x - median(x)|)

# Requirements:
# - the function should work for a numeric vector,
# - include an argument na.rm = FALSE,
# - return one numeric value.

# Test vectors:
x <- c(100, 1, 30, 40, 2, 1000, 3)
y <- c(100, 1, 30, 40, 2, 1000, NA)



















## Exercise 2 ##################################################################

# Write a function called exam_result() with arguments:
# points, max_points = 100, pass_threshold = 0.5

# The function should:
# - compute percentage result,
# - return "pass" if the student reached the threshold,
# - return "fail" otherwise.



















# Test examples
exam_result(45)
exam_result(60)
exam_result(60, max_points = 80)
exam_result(60, max_points = 80, pass_threshold = 0.75)


# Extension:
# return a list with both percentage and decision with function exam_results2.























# Test examples
exam_result2(45)
exam_result2(60)
exam_result2(60, max_points = 80)


## Exercise 3 ##################################################################

# Write a function called grouped_cv() that works on a data frame.
# The function should take:
# - data        -> a data frame,
# - variable    -> name of a numeric column,
# - group       -> name of a grouping column,
# - na.rm = TRUE

# It should return the coefficient of variation of `variable`
# separately for each group in `group`.

# Suggested steps:
# 1) split the numeric variable by group,
# 2) compute CV in each subgroup,
# 3) return the result as a named vector or list.




























# Test data:
library(MASS)
data(survey)

grouped_cv(survey, variable = "Height", group = "Sex")
grouped_cv(survey, variable = "Pulse", group = "Sex")
