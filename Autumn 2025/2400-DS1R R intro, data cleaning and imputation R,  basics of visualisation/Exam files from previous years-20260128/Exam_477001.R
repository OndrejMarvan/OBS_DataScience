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

##### Data Load & Check data types 
setwd("/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Exam files from previous years-20260128")
getwd()

# Set seed
id <- 477001
set.seed(id)
myData <- as.data.frame(data[sample(1:10000,500,replace=FALSE),])

# --- 1. Load Data (Start Fresh) ---
# We reload the data to make sure we have a clean slate.
df <- read.csv("galacticTravel.csv", 
               sep = ";", 
               dec = ",", 
               stringsAsFactors = FALSE)

# --- 2. Rename PromoTokens ---
# We change the column name to what we need
names(df)[names(df) == "PromoTokens"] <- "PromotionTokens"

# --- 3. Separate Destination ---
# We use 'sub' to split the text. 
# It's a basic R function that substitutes text based on a pattern.
df$DestinationPlace <- sub("_.*", "", df$Destination)
df$StationOrPlanet  <- sub(".*_", "", df$Destination)

# --- 4. Fix TravelDate ---
# Convert text to Date format
df$TravelDate <- as.Date(df$TravelDate, format = "%Y_%m_%d")

# --- 5. Filter for High Promotion Users ---
high_promo <- subset(df, PromotionTokens >= 8)
print("Task 5 - Species count:")
print(sort(table(high_promo$Species), decreasing = TRUE))

# --- 6. Calculate Price Per Day ---
df$PricePerDay <- df$Price / df$Duration

# --- 7. Median Price to Venus (Luxury) ---
venus_lux <- subset(df, DestinationPlace == "Venus" & TravelClass == "Luxury")
print("Task 7 - Median Price (Venus, Luxury):")
print(median(venus_lux$Price))

# --- 8. Histogram ---
hist(df$Price, main="Price Distribution", col="lightblue", xlab="Price")

# --- 9. Linear Model ---
model <- lm(Price ~ DestinationPlace + StationOrPlanet + TravelClass + Duration + PromotionTokens + Species, data = df)
print("Task 9 - Model Summary:")
summary(model)

# --- 10. Summary Table ---
# We calculate mean and max separately
avg_price <- aggregate(Price ~ Species + TravelClass, data = df, FUN = mean)
max_promo <- aggregate(PromotionTokens ~ Species + TravelClass, data = df, FUN = max)

# Rename the columns so they look nice
names(avg_price)[3] <- "averagePrice"
names(max_promo)[3] <- "maxPromoTokens"

# Merge them together (R finds the matching columns automatically)
summary_table <- merge(avg_price, max_promo)
print("Task 10 - Group Summary:")
print(head(summary_table))

# --- 11. MySpeciesAverage ---
# THIS is the line that must run before you can print the result.
# 'ave' calculates the mean Price for each Species group.
df$MySpeciesAverage <- ave(df$Price, df$Species, FUN = mean)

# Now this print command will work because the column exists
print("Task 11 - Check:")
# We verify it worked by showing the Species, the Price, and the new Average
print(head(df[c("Species", "Price", "MySpeciesAverage")]))