
# -----------------------------------------------------------------
# Exercise - Cointegration
# -----------------------------------------------------------------

# The exercise is based on an example from the book Principles of Econometrics, 4th Ed.

# The data set includes the federal funds rate 
# (the interest rate on overnight loans between banks), and the
# three-year bond rate (interest rate on a financial asset to be held for three years).

# Obs: 104, quarterly, (1984:1 - 2009.4)  
# gdp : real US gross domestic product
# inf : annual inflation rate
# F   : Federal Funds rate
# B   : 3-year Bond rate

# Source: Federal Reserve Economic Data, Federal Reserve Bank of St.Louis

#     Variable |       Obs        Mean    Std. Dev.       Min        Max
# -------------+--------------------------------------------------------
#          gdp |       104    8616.318    3313.988     3807.4    14484.9
#          inf |       104     5.08625    3.099548       1.28      13.55
#            f |       104    4.983846    2.568505        .12      11.39
#            b |       104    5.697115    2.483198       1.27      12.64

options(scipen=20)
Sys.setenv(LANG = "en")
library("xts")
library("lmtest")

setwd("C:\\Users\\Rafal\\WNE\\Advanced_Econometrics\\AE_Lab_15")
usa = read.csv(file="usa.csv", sep=",", header=TRUE)

# visual inspection of the data
plot(usa$f, type="l")
par(new = TRUE)
plot(usa$b, type="l", col="red")

# Stationarity analysis
usa$f = as.xts(usa$f)
usa$b = as.xts(usa$b)
# creating first differences of variables
usa$df <- diff.xts(usa$f)
usa$db <- diff.xts(usa$b)

# for levels
source("function_testdf2.R")
testdf2(variable = usa$f, test.type="c",
        max.augmentations = 4, max.order = 4)
testdf2(variable = usa$b, test.type="c",
        max.augmentations = 4, max.order = 4)

# for first differences
testdf2(variable = usa$df, test.type="nc",
        max.augmentations = 4, max.order = 4)
testdf2(variable = usa$db, test.type="nc",
        max.augmentations = 4, max.order = 4)

# Conclusion: f~I(1) and b~I(1)

model.coint = lm(f~b, data=usa)
testdf2(variable = residuals(model.coint), test.type="nc",
        max.augmentations = 4, max.order = 4)

# What is the test statistic equal to?
# 2nd line - all p-values exceed 5% threshold
# Test statistic = -3.950651
# We cannot use the p-value that is printed here!
# We have to use special tables to find appropriate critical value!
length(residuals(model.coint))
# critical value for 100 obs is
-3.37
# Critical interval
# (-infinity; -3.37)
# Our test statistic = -3.950651
# lies in the interval, and we have to reject the null hypothesis
# that the residuals are non-stationary.
# They are stationary, and those two variables are cointegrated.


# What is the cointegrating vector? 
summary(model.coint)

# The cointegrating vector is 
c(1, -model.coint$coefficients)
# [1.0000000,  +0.5897419,   -0.9783176]
# which defines the cointegrating relationship as:
# 1*f + 0.5897419 - 0.9783176*b
# Why?
# Model: f = -0.5897419 + 0.9783176*f+epsilon
# f = beta_0+beta_1*f+epsilon
# We found that residuals(model.coint) are I(0), i.e. stationary
# thus
# f-(-0.5897419)-0.9783176*b = epsilon ~ I(0)


# Creating first lags of residuals
# and adding it to the dataset
usa$lagged_resid <- lag.xts(residuals(model.coint))

# Estimating ECM
model.ecm <- lm(df~db + lagged_resid - 1, 
                # -1 means a model without a constant
                data = usa)

resids = as.numeric(residuals(model.ecm))
bgtest(resids~1, order = 5)
# We observe autocorrelation in the residuals.
# That is why we will extend model.ecm with lags of df variable.

usa$lagged_df = lag.xts(usa$df)
model.ecm <- lm(df~db + lagged_resid - 1 + lagged_df, 
                # -1 means a model without a constant
                data = usa)

resids = as.numeric(residuals(model.ecm))
bgtest(resids~1, order = 5)
# no-autocorrelation of orders up to 5
# We overcame the problem of autocorrelation in model.ecm
# So, valid specification of the error-correction mechanism is
# df~db+lagged_resid+lagged_df


# How would you interpret results of the model above?
summary(model.ecm)

# parameter 0.55693 describes a short term relationship
# between f and b, so if b increases by 1, 
# f in the SHORT RUN will increase by 0.55693

# the long run relationship is described by the parameter
# 0.9783176 from the cointegrating relationship:
# so if b increases by 1 in the LONG RUN f will 
# increase by 0.9783176

# -0.15755 is the adjustment coefficient
# its sign is negative (as expected)
# its value means that 15.7% of the unexpected 
# error (increase in f) will be corrected 
# in the next period, so any unexpected deviation
# should be corrected finally within about 6.3 periods (1/15.755%)


# Principles of Econometrics, 4th Ed.
# The result—that the federal funds and bond rates are cointegrated—has major economic
# implications! It means that when the Federal Reserve implements monetary policy by
# changing the federal funds rate, the bond rate will also change thereby ensuring that
# the effects of monetary policy are transmitted to the rest of the economy. In contrast, the
# effectiveness of monetary policy would be severely hampered if the bond and federal funds
# rates were spuriously related as this implies that their movements, fundamentally, have little
# to do with each other.
