# EXERCISES ####################################################################

## Exercise 1 ##################################################################

# Write a function safe_median() which:
# - accepts a numeric vector x,
# - has argument na.rm = FALSE,
# - stops if x is not numeric,
# - stops if x is empty,
# - displays a warning if x contains missings and na.rm = FALSE,
# - returns the median.

safe_median <- function(x, na.rm = FALSE) {
  if (!is.numeric(x)) {
    stop("x must be numeric.")
  }
  
  if (length(x) == 0) {
    stop("x must not be empty.")
  }
  
  if (any(is.na(x)) && !na.rm) {
    warning("x contains missing values and na.rm = FALSE, so the result may be NA.")
  }
  
  return(median(x, na.rm = na.rm))
}

# Check your function:
safe_median(c(1, 5, 2, 9, 7))
safe_median(c(1, 5, NA, 9, 7))
safe_median(c(1, 5, NA, 9, 7), na.rm = TRUE)


## Exercise 2 ##################################################################

# Improve the function below which calculates mean absolute error (MAE).
# Add:
# - type checks,
# - equal length check,
# - handling of missing values,
# - a message saying how many observations were removed,
# - a stop if nothing remains after removing missings.

simple_mae <- function(y, pred) {
  mean(abs(y - pred))
}

improved_mae <- function(y, pred, remove_missing = TRUE) {
  if (!is.numeric(y) || !is.numeric(pred)) {
    stop("Both y and pred must be numeric.")
  }
  
  if (length(y) != length(pred)) {
    stop("y and pred must have the same length.")
  }
  
  if (length(y) == 0) {
    stop("Vectors must not be empty.")
  }
  
  missing_rows <- is.na(y) | is.na(pred)
  
  if (any(missing_rows)) {
    n_missing <- sum(missing_rows)
    
    if (remove_missing) {
      message(paste("Removing", n_missing, "observation(s) with missing values."))
      y <- y[!missing_rows]
      pred <- pred[!missing_rows]
    } else {
      warning("Missing values detected and remove_missing = FALSE, so the result may be NA.")
    }
  }
  
  if (length(y) == 0) {
    stop("No complete observations remain after removing missing values.")
  }
  
  return(mean(abs(y - pred)))
}

# Check your function:
improved_mae(c(3, 5, 2, 7), c(2.8, 4.9, 2.3, 6.5))
improved_mae(c(3, 5, NA, 7), c(2.8, 4.9, 2.3, 6.5))


## Exercise 3 ##################################################################

# Write a function glm_report() which:
# - fits a logistic regression model with glm(..., family = binomial),
# - prints the summary,
# - returns the fitted model invisibly.

glm_report <- function(formula, data) {
  fit <- glm(formula = formula, data = data, family = binomial)
  
  print(summary(fit))
  
  invisible(fit)
}

# Example data for logistic regression:
data(mtcars)
mtcars$am <- as.integer(mtcars$am)

# Check your function:
glm_report(am ~ mpg + wt, mtcars)
glm_model <- glm_report(am ~ mpg + wt, mtcars)
class(glm_model)
glm_model


## Exercise 4 ##################################################################

# Write a function safe_cor() which:
# - takes two vectors: x and y
# - has argument use_complete = TRUE
# - stops if x or y is not numeric
# - stops if x and y do not have the same length
# - stops if x and y are empty
# - if there are missing values:
#     * and use_complete = TRUE, remove incomplete observations
#       and display a message saying how many were removed
#     * and use_complete = FALSE, display a warning
# - stops if fewer than 2 complete observations remain
# - returns the correlation between x and y

safe_cor <- function(x, y, use_complete = TRUE) {
  # your code here
}


safe_cor <- function(x, y, use_complete = TRUE) {
  # 1. Check types 
  if (!is.numeric(x) || !is.numeric(y)) {
    stop("Both x and y must be numeric.")
  }
  
  # 2. Check lengths 
  if (length(x) != length(y)) {
    stop("x and y must have the same length.")
  }
  
  # 3. Check for empty vectors 
  if (length(x) == 0) {
    stop("x and y must not be empty.")
  }
  
  # 4. Handle missing values 
  missing_rows <- is.na(x) | is.na(y)
  
  if (any(missing_rows)) {
    n_missing <- sum(missing_rows)
    
    if (use_complete) {
      message(paste("Removing", n_missing, "observation(s) with missing values."))
      
      # Keep only complete observations
      x <- x[!missing_rows]
      y <- y[!missing_rows]
    } else {
      warning("Missing values detected and use_complete = FALSE, so the result may be NA.")
    }
  }
  
  # 5. Check number of remaining observations 
  if (length(x) < 2) {
    stop("At least two complete observations are required.")
  }
  
  # 6. Compute correlation 
  result <- cor(x, y)
  
  # 7. Return result 
  return(result)
}

# Check your function:
safe_cor(c(1, 2, 3), c(1, 5, 7))
safe_cor(c(1, 2, NA, 4), c(1, 5, 7, 10))
safe_cor(c(1, 2, NA, 4), c(1, 5, 7, 10), use_complete = FALSE)

safe_cor("abc", 1:3)
safe_cor(1:3, 1:2)
safe_cor(numeric(0), numeric(0))
safe_cor(c(NA, NA), c(NA, NA))
