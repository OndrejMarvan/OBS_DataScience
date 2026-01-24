# Simulated hourly demand throughout the day
set.seed(789)
hours <- 0:23
demand <- round(50 + 30 * sin((hours - 6) * pi / 12) + rnorm(24, mean = 0, sd = 5))  # Fluctuating demand

# Function to find the optimal price for a given demand level
optimal_price <- function(demand) {
  price_range <- seq(5, 20, by = 0.5)  # Possible price points
  revenues <- price_range * pmin(demand, 200 / price_range)  # Revenue calculation
  return(price_range[which.max(revenues)])  # Return price that maximizes revenue
}

# Calculate dynamic prices and revenues
prices <- sapply(demand, optimal_price)
revenues <- prices * demand

# Visualize using base R
par(mfrow = c(3, 1))
plot(hours, demand, type = "o", col = "blue", pch = 19,
     xlab = "Hour of the Day", ylab = "Demand",
     main = "Hourly Demand")

plot(hours, prices, type = "o", col = "red", pch = 19,
     xlab = "Hour of the Day", ylab = "Price",
     main = "Dynamic Pricing")

plot(hours, revenues, type = "o", col = "green", pch = 19,
     xlab = "Hour of the Day", ylab = "Revenue",
     main = "Revenue under Dynamic Pricing")
par(mfrow = c(1, 1))