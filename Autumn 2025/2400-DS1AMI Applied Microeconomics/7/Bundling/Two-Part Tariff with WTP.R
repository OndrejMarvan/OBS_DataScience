# Number of customers and their usage
set.seed(123)  # Set seed for reproducibility of random data
customers <- 1000  # Total number of customers
usage <- rpois(customers, lambda = 20)  # Simulate usage using a Poisson distribution with mean = 10 units

# WTP (Willingness to Pay)
wtp <- rnorm(customers, mean = 150, sd = 30)  # Simulate WTP using a normal distribution (mean = 150, SD = 30)


par(mfrow=c(1,2))
# Plot the distribution of usage
hist(usage, breaks = 20, col = "skyblue", border = "black", freq = FALSE,  # freq = FALSE shows density instead of counts
     main = "Distribution of Usage (Poisson)",  # Title of the plot
     xlab = "Usage (units)",  # Label for the x-axis
     ylab = "Density")  # Label for the y-axis
grid()  # Add grid lines for better visualization

# Plot the distribution of WTP
hist(wtp, breaks = 20, col = "lightgreen", border = "black", freq = FALSE,  # freq = FALSE shows density instead of counts
     main = "Distribution of WTP (Willingness to Pay)",  # Title of the plot
     xlab = "Willingness to Pay",  # Label for the x-axis
     ylab = "Density")  # Label for the y-axis
grid()  # Add grid lines for better visualization

# Different fee structures
fixed_fee_options <- seq(0, 150, by = 1)  # Fixed fee options
unit_fee_options <- seq(0, 15, by = 0.5)     # Unit fee options
results <- expand.grid(fixed_fee = fixed_fee_options, unit_fee = unit_fee_options)

# Calculate revenues with WTP included
results$revenue <- mapply(function(f, u) {
  # Calculate total cost for each customer
  total_cost <- f + (usage * u)
  
  # Filter customers who are willing to pay (total cost <= WTP)
  willing_to_pay <- total_cost <= wtp
  
  # Calculate revenue only from customers who can afford it
  revenue <- sum(f * willing_to_pay) + sum((usage * u) * willing_to_pay)
  
  return(revenue)
}, results$fixed_fee, results$unit_fee)

# Reshape results into a matrix
matrix_revenue <- matrix(results$revenue, nrow = length(fixed_fee_options), ncol = length(unit_fee_options))

par(mfrow=c(1,1))
# Visualize results using base R
image(fixed_fee_options, unit_fee_options, matrix_revenue,
      col = heat.colors(12), xlab = "Fixed Fee", ylab = "Unit Fee",
      main = "Revenue under Two-Part Tariff with WTP")
contour(fixed_fee_options, unit_fee_options, matrix_revenue, add = TRUE)