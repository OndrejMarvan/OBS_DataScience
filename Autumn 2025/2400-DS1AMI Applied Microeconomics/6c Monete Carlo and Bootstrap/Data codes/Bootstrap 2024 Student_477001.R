###### Bootstrap Contest Solution ######################################
###### Student: [YOUR NAME]
###### Method: Remove outliers + Bootstrap with median
########################################################################

# load packages (same as original)
requiredPackages = c("readr", "RColorBrewer")
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE)}

# load data
sample_2024 <- read_csv("sample_2024.csv")

par(mfrow=c(2,2))

########################################################################
# STEP 1: First do simple regression to find outliers
########################################################################
mnk <- lm(sample_2024$y ~ sample_2024$x)

# calculate residuals (how far each point is from the line)
residuals <- abs(sample_2024$y - predict(mnk))

# find threshold - keep only points with small residuals (top 85%)
threshold <- quantile(residuals, 0.85)

# remove outliers - keep only "good" points
clean_data <- sample_2024[residuals <= threshold, ]

cat("Original points:", nrow(sample_2024), "\n")
cat("After removing outliers:", nrow(clean_data), "\n")

########################################################################
# STEP 2: Bootstrap on clean data (similar to original code)
########################################################################
B <- 2000  # more iterations for better result
alfa_b <- 0
beta_b <- 0

set.seed(123)  # for same result every time

for(i in 1:B){
  # resample with replacement (same as original)
  sample_b_ind <- sample(1:nrow(clean_data), nrow(clean_data), replace=TRUE)
  sample_b <- clean_data[sample_b_ind,]
  
  # regression on bootstrap sample
  mnk_b <- lm(sample_b$y ~ sample_b$x)
  
  # save coefficients
  alfa_b[i] <- summary(mnk_b)$coefficients[,1][1]
  beta_b[i] <- summary(mnk_b)$coefficients[,1][2]
}

########################################################################
# STEP 3: Use MEDIAN instead of mean (more robust)
########################################################################
alfa_final <- median(alfa_b)
beta_final <- median(beta_b)

cat("\n========== FINAL RESULT ==========\n")
cat("alpha =", round(alfa_final, 2), "\n")
cat("beta =", round(beta_final, 4), "\n")
cat("===================================\n")

########################################################################
# PLOTS
########################################################################

# plot 1: original data with outliers in red
plot(sample_2024$x, sample_2024$y, pch=19, col="gray",
     main="Data with outliers (red = removed)")
points(sample_2024$x[residuals > threshold], 
       sample_2024$y[residuals > threshold], col="red", pch=19)
abline(mnk, col="blue", lwd=2)

# plot 2: clean data only
plot(clean_data$x, clean_data$y, pch=19, col="darkgreen",
     main=paste0("Clean data (", nrow(clean_data), " points)"))
abline(lm(clean_data$y ~ clean_data$x), col="blue", lwd=2)

# plot 3: histogram of alpha
hist(alfa_b, main="Histogram of alpha", col="lightblue", breaks=50)
abline(v=alfa_final, col="red", lwd=2)

# plot 4: histogram of beta
hist(beta_b, main="Histogram of beta", col="lightgreen", breaks=50)
abline(v=beta_final, col="red", lwd=2)
