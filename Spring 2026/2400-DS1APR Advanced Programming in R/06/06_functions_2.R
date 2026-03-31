#---------------------------------------------------------#
#                Advanced Programming in R                #
#                Class 6: functions part 2                #
#                 Academic year 2025/2026                 #
#                  Classes conducted by:                  #
#                Maria Kubara & Monika Kot                #
#        Class 6 materials based on Ewa Weychert          #
#---------------------------------------------------------#

Sys.setenv(LANG = "en")

# 1. From writing functions to designing good functions ------------------------

# In the previous class we learned:
# - what a function is,
# - how to define arguments,
# - what a function returns,
# - how to use default values,
# - how to write wrapper functions,
# - how to pass a function as an argument,
# - and how to make first simple checks of input.

# Today we move one step further.

# A function may work correctly for correct input,
# but in real life users often provide:
# - wrong types,
# - missing values,
# - empty vectors,
# - data in an unexpected format,
# - arguments that technically exist but do not make sense.

# Therefore, in this class we focus on writing functions that are:
# - safer,
# - clearer,
# - easier to debug,
# - more useful in larger projects.

# This approach is often called defensive programming.

# A good function should not only "compute something".
# It should also:
# - protect itself from bad input,
# - communicate clearly with the user,
# - fail early when something is seriously wrong,
# - and behave predictably.


# 2. Why defensive programming? ------------------------------------------------

# Let us begin with a simple function which computes a mean.

simple_mean <- function(x) {
  mean(x)
}

# With correct numeric input, everything is fine.
simple_mean(c(1, 2, 3, 4, 5))

# But what happens in less ideal situations?

# Character input:
simple_mean("abc") # Warning message:
In mean.default(x) : argument is not numeric or logical: returning NA

# Missing values:
simple_mean(c(1, 2, NA, 4, 5))

# Empty vector:
simple_mean(numeric(0))

# The function itself is short and valid,
# but it is not very informative or protective.

# Let us build a safer version.

safe_mean <- function(x, na.rm = FALSE) {
  # Step 1: check the type of the input
  if (!is.numeric(x)) {
    stop("Argument x must be numeric.")
  }
  
  # Step 2: check whether the vector is empty
  if (length(x) == 0) {
    stop("Argument x must not be empty.")
  }
  
  # Step 3: inform the user about missing values
  if (any(is.na(x)) && !na.rm) {
    warning("x contains missing values and na.rm = FALSE, so the result may be NA.")
  }
  
  # Step 4: compute the result
  return(mean(x, na.rm = na.rm))
}

safe_mean(c(1, 2, 3, 4, 5))
safe_mean(c(1, 2, NA, 4, 5))
safe_mean(c(1, 2, NA, 4, 5), na.rm = TRUE)

# Error examples:
safe_mean("abc")
safe_mean(numeric(0))

# Important idea:
# checks are usually placed near the beginning of the function.
# This way the function stops early,
# before wasting time on meaningless calculations.


# 3. stop(), warning(), message() ---------------------------------------------

# These three functions help us communicate with the user.

# stop()    -> critical problem, execution stops immediately
# warning() -> something may be wrong, but execution continues
# message() -> informative note, not necessarily a problem

# A small illustrative function:

log_user <- function(x) {
  # Check whether x is numeric
  if (!is.numeric(x)) {
    stop("x must be numeric.")
  }
  
  # If x is negative, log(x) will not produce an ordinary real result
  if (x < 0) {
    warning("x is negative. The result may be NaN.")
  } else {
    message("Input looks correct. Computing logarithm.")
  }
  
  # Return the logarithm
  return(log(x))
}

log_user(10)
log_user(1)
log_user(-10)

# Error example:
log_user("ten")

# Another example:
# Suppose we want a function that computes a standard deviation,
# but standard deviation is meaningful only if we have enough observations.

safe_sd <- function(x, na.rm = FALSE) {
  # Type check
  if (!is.numeric(x)) {
    stop("x must be numeric.")
  }
  
  # Inform the user about missing values
  if (any(is.na(x))) {
    if (na.rm) {
      message("Missing values will be removed before computing standard deviation.")
    } else {
      warning("x contains missing values and na.rm = FALSE, so the result may be NA.")
    }
  }
  
  # If na.rm = TRUE, we remove missing values for further checks
  x_clean <- x[!is.na(x)]
  
  # Check whether enough non-missing observations remain
  if (length(x_clean) < 2) {
    stop("At least two non-missing observations are required.")
  }
  
  # Compute and return the result
  return(sd(x, na.rm = na.rm))
}

safe_sd(c(1, 2, 3, 4, 5))
safe_sd(c(1, 2, NA, 4, 5))
safe_sd(c(1, 2, NA, 4, 5), na.rm = TRUE)

# Error examples:
safe_sd("abc")
safe_sd(c(10, NA), na.rm = TRUE)


# 4. stopifnot() and simple assertions ----------------------------------------

# A condition that checks whether input has the expected form
# is often called an assertion.

# We can write assertions manually with if(...) stop(...),
# which is very flexible and usually gives the nicest user messages.

# R also provides stopifnot(),
# which is a shorter way to stop execution if a condition is not TRUE.

positive_square_root <- function(x) {
  # stopifnot() checks conditions one by one.
  # If any condition is FALSE, the function stops.
  stopifnot(is.numeric(x))
  stopifnot(length(x) > 0)
  stopifnot(all(!is.na(x)))
  stopifnot(all(x >= 0))
  
  return(sqrt(x))
}

positive_square_root(c(1, 4, 9, 16))

# Error examples:
positive_square_root("abc")
positive_square_root(c(1, NA, 9))
positive_square_root(c(1, -4, 9))

# stopifnot() is compact and useful,
# especially when we want to enforce internal assumptions.

# However, for beginners and for user-facing code,
# explicit if(...) stop("custom message") is often easier to read.


# 5. Building a more realistic safe function ----------------------------------

# Let us write a more complete function:
# z-score standardisation:
# z = (x - mean(x)) / sd(x)

z_score_safe <- function(x, na.rm = FALSE) {
  # Check whether x is numeric
  if (!is.numeric(x)) {
    stop("x must be numeric.")
  }
  
  # Check whether x is not empty
  if (length(x) == 0) {
    stop("x must not be empty.")
  }
  
  # Inform the user about missing values
  if (any(is.na(x))) {
    if (na.rm) {
      message("Missing values will be removed when computing mean and standard deviation.")
    } else {
      warning("x contains missing values and na.rm = FALSE, so the result may contain NA.")
    }
  }
  
  # Standard deviation will be computed on the cleaned data
  x_clean <- x[!is.na(x)]
  
  # We need at least two non-missing values
  if (length(x_clean) < 2) {
    stop("x must contain at least two non-missing observations.")
  }
  
  # Check whether standard deviation is not zero
  s <- sd(x, na.rm = na.rm)
  
  if (is.na(s) || s == 0) {
    stop("Standard deviation is zero or undefined, so z-scores cannot be computed.")
  }
  
  # Compute z-scores
  result <- (x - mean(x, na.rm = na.rm)) / s
  
  # Return the result
  return(result)
}

z_score_safe(c(10, 12, 15, 18, 20))
z_score_safe(c(10, 12, NA, 18, 20))
z_score_safe(c(10, 12, NA, 18, 20), na.rm = TRUE)

# Error examples:
z_score_safe("abc")
z_score_safe(numeric(0))
z_score_safe(c(5, 5, 5, 5))


# 6. try(): continue even if an error occurs ----------------------------------

# Normally, if an error occurs inside a function, execution stops immediately.

demo_try_1 <- function(x) {
  sqrt(x)
  print("This line is after sqrt(x).")
}

demo_try_1(16)

# Error example:
demo_try_1("abc")

# If x is invalid, the function stops before reaching print().

# Now let us use try().

demo_try_2 <- function(x) {
  try(sqrt(x))
  print("This line is after try(sqrt(x)).")
}

demo_try_2(16)
demo_try_2("abc")

# Important:
# try() does not magically fix the error.
# It only allows the code to continue.

# This can be useful when:
# - we want to test code,
# - we want to inspect many computations,
# - we do not want one failure to stop everything immediately.

# The result of try() can be stored in an object.

good_result <- try(2 + log(2))
good_result

bad_result <- try(2 + log("2"))
bad_result

# If an error occurs, try() returns an object of class "try-error".
class(bad_result)
attributes(bad_result)

# It can also work silently:
bad_result_silent <- try(2 + log("2"), silent = TRUE)
bad_result_silent

# We can test whether an object contains an error.
inherits(bad_result_silent, "try-error")

# Example:
if (inherits(bad_result_silent, "try-error")) {
  print("A problem occurred. Please check the input.")
}


# 7. try() in repeated computations -------------------------------------------

# Suppose we want to apply the same operation to many elements.

elements <- list(1:10, c(-1, 10), c(TRUE, FALSE), letters)
elements

# Let us first inspect the square root of each element manually.
sqrt(elements[[1]])
sqrt(elements[[2]])
sqrt(elements[[3]])

# Error:
sqrt(elements[[4]])

# If we try all at once with lapply(),
# one error may make the process inconvenient to inspect.

results_try <- lapply(elements, function(x) {
  try(sqrt(x), silent = TRUE)
  })

results_try

# Now we can detect which elements produced an error.

is_error <- function(x) {
  inherits(x, "try-error")
}

lapply(results_try, is_error)

# Notice:
# lapply() is used here only as a practical tool for repeated function calls.
# We are not discussing the whole apply family in detail yet.
# We will come back to this topic in a later class.


# 8. tryCatch(): define what to do in different situations --------------------

# try() is useful, but it mainly helps with errors.
# A more flexible tool is tryCatch().

# tryCatch() allows us to specify different behavior for:
# - errors,
# - warnings,
# - messages.

example_tryCatch <- function(code) {
  tryCatch(code,
    error = function(e) "An error occurred.",
    warning = function(w) "A warning occurred.",
    message = function(m) "A message occurred."
  )
}

example_tryCatch(log(-2))
example_tryCatch(log("a"))

# A more practical example:

safe_log <- function(x) {
  tryCatch(
    {
      log(x)
    },
    error = function(e) {
      message("Error caught inside safe_log(). Returning NA.")
      return(NA_real_)
    },
    warning = function(w) {
      message("Warning caught inside safe_log(). Returning NA.")
      return(NA_real_)
    }
  )
}

safe_log(10)
safe_log(-10)
safe_log("abc")

# Here the function does not stop with a visible crash.
# Instead, it handles the problem and returns NA.

# This is useful when:
# - we want a function to be robust inside a larger workflow,
# - we prefer a substitute value instead of complete interruption,
# - we want to control the user message ourselves.


# 9. on.exit(): make sure cleanup always happens -------------------------------

# Sometimes a function changes global settings temporarily.
# For example, plot settings created by par().

# If the function ends normally, we may remember to restore the old settings.
# But what if an error occurs in the middle?

# on.exit() allows us to guarantee that some code will be executed
# when the function finishes,
# even if an error occurs.

plot_with_layout <- function(x, y) {
  # Save current graphical parameters
  old_par <- par(mfrow = c(2, 2))
  
  # Make sure the original settings are restored at the end
  on.exit(par(old_par))
  
  # Produce several plots
  plot(x, y, main = "Scatter plot")
  hist(y, main = "Histogram of y")
  boxplot(y, main = "Boxplot of y")
  plot(density(y), main = "Density of y")
}

# Example:
plot_with_layout(cars$speed, cars$dist)

# After the function call, plotting layout should be restored.
plot(cars$speed, cars$dist)

# Another example:
plot_with_big_margins <- function(...) {
  # Save current graphical parameters
  old_par <- par(mar = c(10, 9, 9, 7))
  
  # Ensure restoration at the end
  on.exit(par(old_par))
  
  # Create the plot
  plot(...)
}

plot_with_big_margins(cars$speed, cars$dist)
plot(cars$speed, cars$dist)

# Main idea:
# if the function "borrows" some setting from the global environment,
# it should also clean up after itself.


# 10. invisible(): return an object without printing it -----------------------

# Some functions are useful because they produce a side effect:
# - a plot,
# - printed output,
# - a file,
# - a message.

# But at the same time, we may still want them to return an object
# that can be stored and reused later.

# invisible() is very useful in such cases.

reg_plot <- function(formula, data) {
  # Estimate regression model
  fit <- lm(formula, data)
  
  # Save current plotting layout
  old_par <- par(mfrow = c(2, 2))
  
  # Make sure layout is restored
  on.exit(par(old_par))
  
  # Draw diagnostic plots
  plot(fit)
  
  # Print model summary
  print(summary(fit))
  
  # Return the fitted model invisibly
  invisible(fit)
}

# If we only call the function,
# we see plots and printed summary.
reg_plot(Sepal.Length ~ Sepal.Width, iris)

# But we can also assign the returned model to an object.
model_1 <- reg_plot(Sepal.Length ~ Sepal.Width, iris)

# Now model_1 contains the fitted lm object.
class(model_1)
coef(model_1)

# Another well-known example from base R:
hist(iris$Sepal.Length)

# hist() draws a plot,
# but it also returns useful information.
hist_object <- hist(iris$Sepal.Length)

# The returned object is a list with details about breaks and counts.
str(hist_object)


# 11. A practical mini case study ---------------------------------------------

# Let us combine several ideas in one function.

# We will write a function that compares two numeric vectors
# and computes Root Mean Squared Error (RMSE).

# Formula:
# RMSE = sqrt(mean((y - pred)^2))

rmse_safe <- function(y, pred, remove_missing = TRUE) {
  # 1. Check types
  if (!is.numeric(y) || !is.numeric(pred)) {
    stop("Both y and pred must be numeric.")
  }
  
  # 2. Check lengths before any further work
  if (length(y) != length(pred)) {
    stop("y and pred must have the same length.")
  }
  
  # 3. Check whether vectors are not empty
  if (length(y) == 0) {
    stop("y and pred must not be empty.")
  }
  
  # 4. Deal with missing values
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
  
  # 5. Check lengths again after removing missings
  if (length(y) != length(pred)) {
    stop("Internal error: lengths differ after removing missing values.")
  }
  
  # 6. Check whether enough data remain
  if (length(y) == 0) {
    stop("No complete observations remain after removing missing values.")
  }
  
  # 7. Compute RMSE
  result <- sqrt(mean((y - pred)^2))
  
  # 8. Return the result
  return(result)
}

rmse_safe(c(3, 5, 2, 7), c(2.8, 4.9, 2.3, 6.5))
rmse_safe(c(3, 5, NA, 7), c(2.8, 4.9, 2.3, 6.5))
rmse_safe(c(3, 5, NA, 7), c(2.8, 4.9, 2.3, 6.5), remove_missing = FALSE)

# Error examples:
rmse_safe("abc", c(1, 2, 3))
rmse_safe(c(1, 2, 3), c(1, 2))
rmse_safe(c(NaN, NaN), c(1, 2))


# 12. Optional advanced topic: custom operators -------------------------------

# In R, operators are also functions.
# For example, +, -, %in% are all functions.

# Users can define their own operators.
# Such an operator must start and end with %.

# A useful example:
# %notin% means "is not in".

`%notin%` <- Negate(`%in%`)

letters[1:5]
letters[1:5] %in% c("a", "c", "z")
letters[1:5] %notin% c("a", "c", "z")

# Another example:
# a short operator that behaves like head()

`%h%` <- function(x, y) {
  head(x, y)
}

1:10 %h% 4
iris %h% 3

# Every operator in R is actually a function with TWO arguments:
# left-hand side (x) and right-hand side (y)

# When we write:
1:10 %h% 4

# R interprets it as:
`%h%`(1:10, 4)

# So:
# x -> object on the LEFT side
# y -> object on the RIGHT side

# Another example:
# check if values are between two numbers

`%between%` <- function(x, range) {
  x >= range[1] & x <= range[2]
}

1:10 %between% c(3, 7)

# Note:
# custom operators can be elegant,
# but they should be used carefully.
# In most projects, readability is more important than being clever.

# We should especially NEVER overwrite basic operators such as +.
# Even if it is technically possible, it is a very bad idea.


# 13. Summary of today's lesson -----------------------------------------------

# Today we saw that a good function should:
# - check whether the input makes sense,
# - stop with a clear message if the problem is critical,
# - warn the user if something suspicious happens,
# - sometimes inform the user with a message(),
# - handle errors gracefully when needed,
# - clean up temporary settings with on.exit(),
# - and sometimes return objects invisibly.

# These ideas are very important in real projects.
# They become especially useful when:
# - code becomes longer,
# - functions are reused many times,
# - other people use our code,
# - functions are later included in packages or applications.







# EXERCISES ####################################################################

## Exercise 1 ##################################################################

# Write a function safe_median() which:
# - accepts a numeric vector x,
# - has argument na.rm = FALSE,
# - stops if x is not numeric,
# - stops if x is empty,
# - displays a warning if x contains missings and na.rm = FALSE,
# - returns the median.










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










# Check your function:
improved_mae(c(3, 5, 2, 7), c(2.8, 4.9, 2.3, 6.5))
improved_mae(c(3, 5, NA, 7), c(2.8, 4.9, 2.3, 6.5))


## Exercise 3 ##################################################################

# Write a function glm_report() which:
# - fits a logistic regression model with glm(..., family = binomial),
# - prints the summary,
# - returns the fitted model invisibly.










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










# Check your function:
safe_cor(c(1, 2, 3), c(1, 5, 7))
safe_cor(c(1, 2, NA, 4), c(1, 5, 7, 10))
safe_cor(c(1, 2, NA, 4), c(1, 5, 7, 10), use_complete = FALSE)

safe_cor("abc", 1:3)
safe_cor(1:3, 1:2)
safe_cor(numeric(0), numeric(0))
safe_cor(c(NA, NA), c(NA, NA))
