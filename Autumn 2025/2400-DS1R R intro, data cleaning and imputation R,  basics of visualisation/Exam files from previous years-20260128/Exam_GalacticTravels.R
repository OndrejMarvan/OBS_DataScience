################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 1 ###########################################
################################################################################

# RIntro Exam Solutions - Galactic Travel Agency
# Practice code for learning R

# ============================================
# SETUP: Reading the data
# ============================================

# Read the CSV file - IMPORTANT: separator is ";" and decimal is ","
data <- read.csv("galacticTravel.csv", sep = ";", dec = ",")

# Set your student ID and create subset (use your own ID!)
id <- 477001  # YOUR ID HERE
set.seed(id)
myData <- as.data.frame(data[sample(1:10000, 500, replace = FALSE), ])

# ============================================
# TASK 1: Check variable types with str()
# ============================================

str(myData)

# Answer for Task 1:
# Variable       | Type (currently) | Target type in R
# ---------------|------------------|------------------
# TravelDate     | character        | Date
# Species        | character        | factor
# TravelClass    | character        | factor
# Duration       | integer          | numeric (or integer is fine)
# Price          | numeric          | numeric

# ============================================
# TASK 2: Rename 'PromoTokens' to 'PromotionTokens'
# ============================================

# Find the column name and rename it
names(myData)[names(myData) == "PromoTokens"] <- "PromotionTokens"

# Check if it worked
names(myData)

# ============================================
# TASK 3: Separate Destination into two variables
# ============================================

# Look at Destination variable first
head(myData$Destination)
# It contains: Planet_S or Planet_P (S = Station, P = Planet)

# Method 1: Using strsplit (base R)
split_dest <- strsplit(as.character(myData$Destination), "_")
myData$DestinationPlace <- sapply(split_dest, function(x) x[1])
myData$StationOrPlanet <- sapply(split_dest, function(x) x[2])

# Check the result
head(myData[, c("Destination", "DestinationPlace", "StationOrPlanet")])
head(myData)

# ============================================
# TASK 4: Transform TravelDate to Date type
# ============================================

# Current format is "2024_05_08" - need to convert
myData$TravelDate <- as.Date(myData$TravelDate, format = "%Y_%m_%d")

# Check if it worked
class(myData$TravelDate)
head(myData$TravelDate)

# ============================================
# TASK 5: Species analysis for travels with 8+ promo tokens
# ============================================

# Filter travels with at least 8 promotion tokens
filtered_data <- myData[myData$PromotionTokens >= 8, ]

# Convert Species to factor and look at the levels
filtered_data$Species <- factor(filtered_data$Species)

# See how many of each species
table(filtered_data$Species)

# Or use summary
summary(factor(filtered_data$Species))

# ============================================
# TASK 6: Add PricePerDay variable
# ============================================

myData$PricePerDay <- myData$Price / myData$Duration

# Check result
head(myData[, c("Price", "Duration", "PricePerDay")])

# ============================================
# TASK 7: Median price of Venus Luxury travel
# ============================================

# Filter for Venus destination and Luxury class
venus_luxury <- myData[myData$DestinationPlace == "Venus" & 
                         myData$TravelClass == "Luxury", ]

# Calculate median price
median_venus_luxury <- median(venus_luxury$Price)
print(median_venus_luxury)

# ============================================
# TASK 8: Two histograms side by side (Mars and Venus)
# ============================================

# Filter data for Mars and Venus
mars_data <- myData[myData$DestinationPlace == "Mars", ]
venus_data <- myData[myData$DestinationPlace == "Venus", ]

# Set up plotting area for 2 plots side by side
par(mfrow = c(1, 2))

# Plot histogram for Mars (red)
hist(mars_data$Duration, 
     col = "red", 
     main = "Travel Duration to Mars",
     xlab = "Duration (Standard Galactic Days)")

# Plot histogram for Venus (blue)
hist(venus_data$Duration, 
     col = "blue", 
     main = "Travel Duration to Venus",
     xlab = "Duration (Standard Galactic Days)")

# Reset plotting area
par(mfrow = c(1, 1))

# ============================================
# TASK 9: Linear model for Price
# ============================================

# Build the linear model
myModel <- lm(Price ~ DestinationPlace + StationOrPlanet + TravelClass + 
                Duration + PromotionTokens + Species, 
              data = myData)

# See all coefficients
summary(myModel)

# Extract the coefficient for Duration
duration_coef <- coef(myModel)["Duration"]
print(duration_coef)

# ============================================
# TASK 10: Group comparison summary table
# ============================================

# Method 1: Using aggregate (base R)
summary_table <- aggregate(
  cbind(averagePrice = Price, maxPromoTokens = PromotionTokens) ~ Species + TravelClass,
  data = myData,
  FUN = function(x) c(mean = mean(x), max = max(x))
)

# This creates a complex structure, so let's do it step by step:

# Calculate average price
avg_price <- aggregate(Price ~ Species + TravelClass, 
                       data = myData, 
                       FUN = mean)
names(avg_price)[3] <- "averagePrice"

# Calculate max promo tokens
max_tokens <- aggregate(PromotionTokens ~ Species + TravelClass, 
                        data = myData, 
                        FUN = max)
names(max_tokens)[3] <- "maxPromoTokens"

# Merge the two tables
summary_table <- merge(avg_price, max_tokens, by = c("Species", "TravelClass"))

# View the result
print(summary_table)

# ============================================
# TASK 11: Add MySpeciesAverage variable
# ============================================

# Calculate average price per species
species_avg <- aggregate(Price ~ Species, data = myData, FUN = mean)
names(species_avg)[2] <- "MySpeciesAverage"

# Merge back to main data (one line of code version)
myData <- merge(myData, species_avg, by = "Species")

# Check result - same species should have same MySpeciesAverage
head(myData[order(myData$Species), c("Species", "Price", "MySpeciesAverage")], 20)

# Alternative one-liner using ave() function:
# myData$MySpeciesAverage <- ave(myData$Price, myData$Species, FUN = mean)

# ============================================
# BONUS TASK: Pricing Strategy (brief explanation)
# ============================================

# Look at the model coefficients
summary(myModel)

# Key insights from the model:
# 1. Check which destinations/classes have highest/lowest prices
# 2. See how Duration and PromotionTokens affect price

# Example pricing analysis:
cat("\n=== Pricing Strategy Insights ===\n")
cat("Model R-squared:", summary(myModel)$r.squared, "\n")
cat("Duration coefficient:", coef(myModel)["Duration"], "\n")

# The written analysis would go in your exam submission form