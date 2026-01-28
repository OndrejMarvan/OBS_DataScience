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
df <- read.csv("galacticTravel.csv",
               sep = ";",
               dec = ",",
               stringsAsFactors = FALSE)
# Set seed
id <- 477001
set.seed(id)
myData <- as.data.frame(data[sample(1:10000,500,replace=FALSE),])

# Check structure
str(df)

# --- Task 2: Rename PromoTokens ---
# Access column names vector directly
names(df)[names(df) == "PromoTokens"] <- "PromotionTokens"

# --- Task 3: Separate Destination ---
# We use strsplit to break the string by "_", then loop to extract parts
dest_split <- strsplit(df$Destination, "_")

# Create new columns by extracting the 1st and 2nd elements of the split list
df$DestinationPlace <- sapply(dest_split, `[`, 1)
df$StationOrPlanet  <- sapply(dest_split, `[`, 2)

# --- Task 4: Transform TravelDate ---
# Base R date conversion
df$TravelDate <- as.Date(df$TravelDate, format = "%Y_%m_%d")

# --- Task 5: Filter & Count Species ---
# subset() creates the filter, table() counts frequencies
high_promo_df <- subset(df, PromotionTokens >= 8)
species_counts <- sort(table(high_promo_df$Species), decreasing = TRUE)

print(species_counts)

# --- Task 6: Create PricePerDay ---
# Direct vector arithmetic
df$PricePerDay <- df$Price / df$Duration

# --- Task 7: Median Price to Venus (Luxury) ---
# Filter using boolean indexing
venus_luxury_prices <- df$Price[df$DestinationPlace == "Venus" & df$TravelClass == "Luxury"]
print(median(venus_luxury_prices))

# --- Task 8: Histogram of Price ---
hist(df$Price, 
     main = "Distribution of Travel Prices", 
     xlab = "Price", 
     col = "steelblue", 
     border = "white")

# --- Task 9: Linear Model ---
# This part is identical in Base R
model <- lm(Price ~ DestinationPlace + StationOrPlanet + TravelClass + Duration + PromotionTokens + Species, data = df)
summary(model)

# --- Task 10: Group Summary Table ---
# aggregate() is the Base R equivalent of group_by + summarise
avg_price <- aggregate(Price ~ Species + TravelClass, data = df, FUN = mean)
max_promo <- aggregate(PromotionTokens ~ Species + TravelClass, data = df, FUN = max)

# Merge the two aggregations together
summary_table <- merge(avg_price, max_promo, by = c("Species", "TravelClass"))

# Rename columns for clarity (optional but good practice)
names(summary_table)[3:4] <- c("averagePrice", "maxPromoTokens")
print(head(summary_table))

# --- Task 11: MySpeciesAverage (One Line Calculation) ---
# ave() is a powerful Base R function for group-wise transformations
df$MySpeciesAverage <- ave(df$Price, df$Species, FUN = mean)

# Verify
head(df[c("Species", "Price", "MySpeciesAverage")])

