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

mad_manual <- function(x, na.rm = FALSE) {
  # Check that x is numeric
  if (!is.numeric(x)) {
    stop("x must be numeric.")
  }
  
  # Compute the median of x
  med <- median(x, na.rm = na.rm)
  
  # Compute absolute deviations from the median
  abs_dev <- abs(x - med)
  
  # Return the median of absolute deviations
  return(median(abs_dev, na.rm = na.rm))
}

mad_manual(x)
mad_manual(y)
mad_manual(y, na.rm = TRUE)


## Exercise 2 ##################################################################

# Write a function called exam_result() with arguments:
# points, max_points = 100, pass_threshold = 0.5

# The function should:
# - compute percentage result,
# - return "pass" if the student reached the threshold,
# - return "fail" otherwise.

exam_result <- function(points, max_points = 100, pass_threshold = 0.5) {
  # Basic checks
  if (!is.numeric(points) || !is.numeric(max_points) || !is.numeric(pass_threshold)) {
    stop("All arguments must be numeric.")
  }
  
  if (max_points <= 0) {
    stop("max_points must be greater than 0.")
  }
  
  # Compute percentage result
  percentage <- points / max_points
  
  # Decide whether the student passed
  if (percentage >= pass_threshold) {
    return("pass")
  } else {
    return("fail")
  }
}

# Test examples
exam_result(45)
exam_result(60)
exam_result(60, max_points = 80)
exam_result(60, max_points = 80, pass_threshold = 0.75)

# Extension:
# return a list with both percentage and decision with function exam_results2.

exam_result2 <- function(points, max_points = 100, pass_threshold = 0.5) {

  if (!is.numeric(points) || !is.numeric(max_points) || !is.numeric(pass_threshold)) {
    stop("All arguments must be numeric.")
  }
  
  if (max_points <= 0) {
    stop("max_points must be greater than 0.")
  }
  
  # Compute percentage
  percentage <- points / max_points
  
  # Make decision
  decision <- if (percentage >= pass_threshold) "pass" else "fail"
  
  # Return both results as a list
  return(list(
    percentage = percentage,
    decision = decision
  ))
}

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

grouped_cv <- function(data, variable, group, na.rm = TRUE) {
  # Check that data is a data frame
  if (!is.data.frame(data)) {
    stop("data must be a data.frame.")
  }
  
  # Check that variable exists in data
  if (!variable %in% names(data)) {
    stop("variable is not a column in data.")
  }
  
  # Check that group exists in data
  if (!group %in% names(data)) {
    stop("group is not a column in data.")
  }
  
  # Extract variables
  x <- data[[variable]]
  g <- data[[group]]
  
  # Check numeric
  if (!is.numeric(x)) {
    stop("Selected variable must be numeric.")
  }
  
  # Split data
  split_x <- split(x, g)
  
  # Prepare empty result vector
  result <- numeric(length(split_x))
  names(result) <- names(split_x)
  
  # Loop over groups
  for (i in seq_along(split_x)) {
    z <- split_x[[i]]
    result[i] <- sd(z, na.rm = na.rm) / mean(z, na.rm = na.rm)
  }
  
  return(result)
}

# Test data:
library(MASS)
data(survey)

grouped_cv(survey, variable = "Height", group = "Sex")
grouped_cv(survey, variable = "Pulse", group = "Sex")
