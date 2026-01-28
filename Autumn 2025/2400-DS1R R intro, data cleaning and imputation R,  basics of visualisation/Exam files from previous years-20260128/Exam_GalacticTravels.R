# ============================================
# RIntro Exam Solutions - Galactic Travel Agency
# Run this code from TOP to BOTTOM in order!
# ============================================

# SETUP: Reading the data
data <- read.csv("galacticTravel.csv", sep = ";", dec = ",")

id <- 123456  # PUT YOUR ID HERE
set.seed(id)
myData <- as.data.frame(data[sample(1:10000, 500, replace = FALSE), ])

# ============================================
# TASK 1: Check variable types
# ============================================
str(myData)

# Answer:
# TravelDate   - character  -> should be Date
# Species      - character  -> should be factor
# TravelClass  - character  -> should be factor
# Duration     - integer    -> numeric (integer is ok)
# Price        - numeric    -> numeric

# ============================================
# TASK 2: Rename PromoTokens to PromotionTokens
# ============================================
names(myData)[names(myData) == "PromoTokens"] <- "PromotionTokens"

names(myData)  # check it worked

# ============================================
# TASK 3: Separate Destination into two variables
# ============================================
split_dest <- strsplit(as.character(myData$Destination), "_")
myData$DestinationPlace <- sapply(split_dest, function(x) x[1])
myData$StationOrPlanet <- sapply(split_dest, function(x) x[2])

head(myData[, c("Destination", "DestinationPlace", "StationOrPlanet")])

# ============================================
# TASK 4: Transform TravelDate to Date type
# ============================================
myData$TravelDate <- as.Date(myData$TravelDate, format = "%Y_%m_%d")

class(myData$TravelDate)  # should say "Date"

# ============================================
# TASK 5: Species with 8+ promo tokens
# ============================================
filtered_data <- myData[myData$PromotionTokens >= 8, ]

table(filtered_data$Species)

# ============================================
# TASK 6: Add PricePerDay variable
# ============================================
myData$PricePerDay <- myData$Price / myData$Duration

head(myData[, c("Price", "Duration", "PricePerDay")])

# ============================================
# TASK 7: Median price Venus Luxury
# ============================================
venus_luxury <- myData[myData$DestinationPlace == "Venus" & 
                         myData$TravelClass == "Luxury", ]

median(venus_luxury$Price)

# ============================================
# TASK 8: Two histograms side by side
# ============================================
mars_data <- myData[myData$DestinationPlace == "Mars", ]
venus_data <- myData[myData$DestinationPlace == "Venus", ]

par(mfrow = c(1, 2))

hist(mars_data$Duration, 
     col = "red", 
     main = "Mars Travel Duration",
     xlab = "Duration (SGD)")

hist(venus_data$Duration, 
     col = "blue", 
     main = "Venus Travel Duration",
     xlab = "Duration (SGD)")

par(mfrow = c(1, 1))

# ============================================
# TASK 9: Linear model
# ============================================
myModel <- lm(Price ~ DestinationPlace + StationOrPlanet + TravelClass + 
                Duration + PromotionTokens + Species, 
              data = myData)

summary(myModel)

# Extract Duration coefficient
coef(myModel)["Duration"]

# ============================================
# TASK 10: Summary table by Species and TravelClass
# ============================================
avg_price <- aggregate(Price ~ Species + TravelClass, 
                       data = myData, 
                       FUN = mean)
names(avg_price)[3] <- "averagePrice"

max_tokens <- aggregate(PromotionTokens ~ Species + TravelClass, 
                        data = myData, 
                        FUN = max)
names(max_tokens)[3] <- "maxPromoTokens"

summary_table <- merge(avg_price, max_tokens, by = c("Species", "TravelClass"))

print(summary_table)

# ============================================
# TASK 11: Add MySpeciesAverage (one line!)
# ============================================
myData$MySpeciesAverage <- ave(myData$Price, myData$Species, FUN = mean)

# Check result
head(myData[, c("Species", "Price", "MySpeciesAverage")], 15)

# ============================================
# DONE! Check final structure
# ============================================
str(myData)
names(myData)