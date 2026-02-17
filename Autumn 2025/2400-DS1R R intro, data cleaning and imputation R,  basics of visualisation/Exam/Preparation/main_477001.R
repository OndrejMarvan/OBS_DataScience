# Exam 477001

# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

##############################################################################
getwd()

# Load libraries 
library(tidyverse)
library(dplyr)

# Read the data
data <- read.csv("secondhand_fashion.csv", sep = "%", dec = ",")

id <- 477001  
set.seed(id)
myData <- as.data.frame(data[sample(1:10000, 500, replace = FALSE), ])

# Checking the data and its structure
names(data)
head(data)
summary(data)
str(data)

##############################################################################
# TASK 1 - Variable types analysis
##############################################################################
# Current types:
# Col - Current Type -> Target type
# SaleDate - chr  -> Date
# BrandTier - chr -> factor
# SellerRating - num  -> numeric
# DiscountApplied - chr -> factor
# FinalPrice - chr  -> numeric

##############################################################################
# TASK 2 - Rename ItemDetails to ListingInfo
##############################################################################

names(myData)[names(myData) == "ItemDetails"] <- "ListingInfo"

# Check
names(myData)
head(myData$ListingInfo)

#############################################################################
# TASK 3 - Listing Info Split into Category and Condition
##############################################################################

split_info <- strsplit(myData$ListingInfo, "_")

myData$Category <- sapply(split_info, function(x) x[1])
myData$Condition <- sapply(split_info, function(x) x[2])

# Check
head(myData)

##############################################################################
# TASK 4 - Transforming SaleDate to date format
##############################################################################
# "2023//11//02"

# Removing //
myData$SaleDate <- gsub("//", "-", myData$SaleDate)

# Transormation
myData$SaleDate <- as.Date(myData$SaleDate, format = "%Y-%m-%d")

# Check
head(myData$SaleDate)
str(myData$SaleDate)

##############################################################################
# TASK 5 - Removing mixed data types in FinalPrice and converitng to num
##############################################################################

# Removing USD and conversion to num
myData$FinalPrice <- gsub(" USD", "", myData$FinalPrice)
myData$FinalPrice <- as.numeric(myData$FinalPrice)

# Check
head(myData$FinalPrice)
str(myData$FinalPrice)

##############################################################################
# TASK 6 - Average FinalPrice for sellerRating > 4.6 in range 1–5 (meaning high rate)
##############################################################################

high_rated <- myData[myData$SellerRating > 4.6, ]
avg_price_high_rated <- mean(high_rated$FinalPrice)
avg_price_high_rated

##############################################################################
# TASK 7 - Adding PricePerDayListed variable (FinalPrice / DaysListed )
##############################################################################

myData$PricePerDayListed <- myData$FinalPrice / myData$DaysListed

# Check
head(myData)

##############################################################################
# TASK 8 - Listing Max FinalPrice for New items in Premium tier
##############################################################################

new_premium <- myData[myData$Condition == "New" & myData$BrandTier == "Premium", ]

max_price_new_premium <- max(new_premium$FinalPrice)
max_price_new_premium

##############################################################################
# TASK 9 - Three Histograms (FinalPrice for different values of BrandTier)
##############################################################################

# Setup
par(mfrow = c(1, 3))

# Three Hist
hist(myData$FinalPrice[myData$BrandTier == "Low"],
     main = "Low",
     xlab = "Final price",
     ylab = "",
     col = "gray")

hist(myData$FinalPrice[myData$BrandTier == "Mid"],
     main = "Mid",
     xlab = "Final price",
     ylab = "",
     col = "gray")

hist(myData$FinalPrice[myData$BrandTier == "Premium"],
     main = "Premium",
     xlab = "Final price",
     ylab = "",
     col = "gray")

# Restoring Plots
par(mfrow = c(1, 1))

##############################################################################
# TASK 10 - Linear Fuction
##############################################################################

myModel <- lm(FinalPrice ~ BrandTier + Category + Condition + DaysListed + SellerRating + DiscountApplied + ShippingMethod, data = myData)

# Sumarry
summary(myModel)

# Extracting the coefficient for DiscountApplied + meaning
coef(myModel)["DiscountAppliedYes"]
# -10.28607
# The coefficient for DiscountAppliedYes shows how much the FinalPrice changes in average when a discount is applied compared to no discount.
# If -, items with discount sell for less money.
# If +, items with discount sell for more money.

##############################################################################
# TASK 11 - Summary table by Category and Condition
##############################################################################

summary_table <- data.frame(
  Category = summary_table$Category,
  Condition = summary_table$Condition,
  AveragePrice = summary_table$FinalPrice[, "mean"],
  MaxDaysListed = summary_table$DaysListed[, "max"]
)

# Summary
print(summary_table)

##############################################################################
# TASK 12 - Introduce NA values and replace by median
##############################################################################

# Every 32nd item NA
myData$FinalPrice[seq(32, nrow(myData), by = 32)] <- NA

# Sum NAs
sum(is.na(myData$FinalPrice))

# Calculating median (ignoring NA values)
median_price <- median(myData$FinalPrice, na.rm = TRUE)
median_price

##############################################################################
# TASK Bonus
##############################################################################

# According to Task 6, the higher rating, the higher average prices, meaning buyers trust high rated sellers and are willing to pay more. 
# This would increase seller revenue. My recommendation is based on evidence from the analysis. 
