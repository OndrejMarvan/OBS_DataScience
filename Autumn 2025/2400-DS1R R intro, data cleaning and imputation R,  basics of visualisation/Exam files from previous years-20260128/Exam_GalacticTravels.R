################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 1 ###########################################
################################################################################

# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

# Libraries
library(tidyverse)
library(lubridate)

# Set seed
id <- 477001
set.seed(id)
myData <- as.data.frame(data[sample(1:10000,500,replace=FALSE),])

# ==========================================
# EXAM SOLUTION (BASIC R)
# ==========================================

# --- 1. Load Data ---
# We use 'dec = ","' so R understands the prices are numbers (e.g., 100,50)
df <- read.csv("galacticTravel.csv", 
               sep = ";", 
               dec = ",", 
               stringsAsFactors = FALSE)

# --- 2. Rename Column ---
# We find the column named "PromoTokens" and change it to "PromotionTokens"
names(df)[names(df) == "PromoTokens"] <- "PromotionTokens"

# --- 3. Separate Destination ---
# We use 'sub' to chop the text strings
# Get the part BEFORE the underscore
df$DestinationPlace <- sub("_.*", "", df$Destination)
# Get the part AFTER the underscore
df$StationOrPlanet  <- sub(".*_", "", df$Destination)

# --- 4. Transform TravelDate ---
df$TravelDate <- as.Date(df$TravelDate, format = "%Y_%m_%d")

# --- 5. High Promotion Count (Task 5) ---
high_promo <- subset(df, PromotionTokens >= 8)
print("Task 5 - Species Count:")
# table() counts the occurrences
print(sort(table(high_promo$Species), decreasing = TRUE))

# --- 6. Price Per Day (Task 6) ---
df$PricePerDay <- df$Price / df$Duration

# --- 7. Median Price to Venus (Task 7) ---
# We use standard subsetting with brackets
venus_luxury <- subset(df, DestinationPlace == "Venus" & TravelClass == "Luxury")
print("Task 7 - Median Price (Venus, Luxury):")
print(median(venus_luxury$Price))

# --- 8. Histogram (Task 8) ---
hist(df$Price, 
     main = "Distribution of Prices", 
     xlab = "Price", 
     col = "lightblue")

# --- 9. Linear Model (Task 9) ---
model <- lm(Price ~ DestinationPlace + StationOrPlanet + TravelClass + Duration + PromotionTokens + Species, 
            data = df)
print("Task 9 - Model Summary:")
# We only print the coefficients to keep it short, or use summary(model)
print(summary(model)$coefficients)

# --- 10. Summary Table (Task 10) ---
# Calculate Average Price per group
avg_data <- aggregate(Price ~ Species + TravelClass, data = df, FUN = mean)
names(avg_data)[3] <- "averagePrice" 

# Calculate Max Tokens per group
max_data <- aggregate(PromotionTokens ~ Species + TravelClass, data = df, FUN = max)
names(max_data)[3] <- "maxPromoTokens"

# Merge the two small tables together
summary_table <- merge(avg_data, max_data)
print("Task 10 - Summary Table:")
print(head(summary_table))

# --- 11. MySpeciesAverage (Task 11) ---
# This ONE LINE creates the new column. It MUST run successfully.
df$MySpeciesAverage <- ave(df$Price, df$Species, FUN = mean)

# We check if the column exists before printing
if("MySpeciesAverage" %in% names(df)) {
  print("Task 11 - Success! First 5 rows:")
  # We select specific columns to verify
  print(head(df[c("Species", "Price", "MySpeciesAverage")]))
} else {
  print("Error: The column MySpeciesAverage was not created.")
}