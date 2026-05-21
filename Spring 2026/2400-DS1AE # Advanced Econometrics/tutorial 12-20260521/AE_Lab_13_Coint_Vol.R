###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#   Materials based on dr Piotr Wojcik Time Series Analysis for QF        #
#                                                                         #
#                 Labs 6:                                                 #
#                                                                         #
###########################################################################
# Cointegration in time series
# Error Correction Model (ECM)
# Volatility modeling
#############################################################################


# We start with defining path to current working directory
Sys.setenv(LANG = "en")

# we used to teach Granger causality with package MSBVAR
# but it seems to be unavailable at cran repository any more.
# install.packages("MSBVAR") # for tests of Granger causality

library(xts)
library(lmtest) # for BG test
library(fBasics) # e.g. basicStats()
library(urca) # for DF tests, also Johansen test
#library(MSBVAR)
library("lmtest")

# lets load additional function prepared by the lecturer
source("function_testdf2.R")


################################################################################
# Data concerning price indices:
#   CPI - Consumer Price Index for All Urban Consumers: Energy, 1982=100
#   PPI - Producer Price Index: Finished Energy Goods, 1982=100 
# Montly data: 01.1986-01.2017
# Source: U.S. Department of Labor: Bureau of Labor Statistics
# Economic Data - FRED(R) II - http://research.stlouisfed.org/fred2/
################################################################################


# penalty on scientific penalty
options(scipen = 12)

# importing data
ppi_cpi <- read.csv("ppi_cpi.csv")

head(ppi_cpi)
tail(ppi_cpi)

# lets format date as date
ppi_cpi$date <- as.Date(ppi_cpi$date, format = "%Y-%m-%d")

# transformation into an xts object
ppi_cpi <- xts(ppi_cpi[,-1], ppi_cpi$date)

#  creating first differences of variables
ppi_cpi$dppi <- diff.xts(ppi_cpi$ppi)
ppi_cpi$dcpi <- diff.xts(ppi_cpi$cpi)


#  plotting variables on the graph 
plot(ppi_cpi$ppi, ylim = c(50,280), 
     main = 'PPI and CPI indices')
lines(ppi_cpi$cpi, col = "blue")
legend("topleft", c("PPI", "CPI"), 
       col = c("black", "blue"), lty = 1)


# testing integration order
# "c" constant or drift - ADF 2nd type - random walk with drift vs staionarity
testdf2(variable = ppi_cpi$cpi, test.type = "c", 
        max.augmentations = 12, max.order = 12)
# "nc" no constant - ADF 1st type - random walk vs stationarity
testdf2(variable = ppi_cpi$dcpi, test.type = "nc", 
        max.augmentations = 12, max.order = 12)

testdf2(variable = ppi_cpi$ppi, test.type = "c", 
        max.augmentations = 12, max.order = 12)
testdf2(variable = ppi_cpi$dppi, test.type = "nc", 
        max.augmentations = 12, max.order = 12)

# "ct linear trend - ADF 3rd type - random walk around quadratic trend vc trendstationarity

# Both variables are I(1) so we can check 
# whether they are cointegrated.

# Let us now assume that the first differences of 
# the ppi index are stationary

# Estimating cointegrating vector
model.coint <- lm(cpi~ppi, data = ppi_cpi)

summary(model.coint)

# Testing stationarity of residuals 
# What is the proper ADF statistic? 

testdf2(variable = residuals(model.coint), test.type="nc",
       max.augmentations = 4, max.order = 4)

# What is the test statistic equal to?
# 2nd line - all p-values exceed 5% threshold
# Test statistic = -5.962723
# We cannot use the p-value that is printed here!
# We have to use special tables to find appropriate critical value!
length(residuals(model.coint))
# critical value for 375 obs is
-(4.30+4.18)/2
# Critical interval
# (-infinity; -4.24)
# Our test statistic = -5.962723
# lies in the interval, and we have to reject the null hypothesis
# that the residuals are non-stationary
# They are stationary, and those two variables are cointegrated.

# What is the result of cointegration test?
# What is the cointegrating vector? 


# The cointegrating vector is [1, - 10.700397, -1.229102]
# model.coint: cpi~constant+ppi
# cpi = 10.7 + 1.229*ppi + epsilon
# epsilon is I(0)
# epsilon = cpi-10.7-1.229ppi ~ I(0) stationary

# which defines the cointegrating relationship as:
# 1 * cpi - 10.700397 - 1.229102 * ppi

# Creating first lags of residuals
# and adding it to the dataset

ppi_cpi$lresid <- lag.xts(residuals(model.coint))


# Estimating ECM
model.ecm <- lm(dcpi~dppi + lresid - 1, 
                # -1 means a model without a constant
                data = ppi_cpi) 

summary(model.ecm)
# Error-Correction Mechanism model
# delta(cpi)=beta_1*delta(ppi)+beta_2*(lagged residuals) + epsilon
# delta(cpi) = 1.15103*delta(ppi) -0.21743*(lagged residuals) + epsilon

# beta_2 from above should be in (-2, 0)
# (-1, 0)
# (-2, -1)
# beta_2 = -1.5
# the dog is 1 kilometer far away - on the left hand side of the drunk
# next period: the dog will correct its position by 1.5 kilometers
# as a result: the dog will be 0.5 kilometers on the right hand side
# of the drunk
# the next period: the dog will correct itself
# 0.75 kilometers = 1.5*0.5km
# as a result: the dog will be 0.25 km on the right hand side of his lady

# How would you interpret results of the model above?

# parameter 1.15103 describes a short term relationship
# between cpi and ppi, so if ppi increases by 1, 
# cpi in the SHORT RUN will increase by 1.15103

# the long run relationship is described by the parameter
# 1.229102 from the cointegrating relationship:
# so if ppi increases by 1 in the LONG RUN cpi will 
# increase by 1.229102

# -0.21743 is the adjustment coefficient
# its sign is negative (as expected)
# its value means that 21.7% of the unexpected 
# error (increase in gap) will be corrected 
# in the next period, so any unexpected deviation
# should be corrected finally within about 4.5 periods (1/21.7%) 


################################################################################
# CPI_PPI - Granger causality test                                            
################################################################################

# Now let's check, whether PPI Granger causes CPI and vice versa.
# What is the proper lag length in this case? 

# x_1 and x_2 variables
# Is x_1 a Granger cause to X_2?
# In other words: Do lagged values of x_1 improve forecasts of x_2?

names(ppi_cpi)

# 3 lags
grangertest(x=ppi_cpi$dppi, y=ppi_cpi$dcpi, order = 3)
# H0: the first, the second, and the third lags of ppi are insignificant
# ppi lags are inignificant
# ppi does not cause cpi

# 4 lags
grangertest(x=ppi_cpi$dppi, y=ppi_cpi$dcpi, order = 4)

# 5 lags
grangertest(x=ppi_cpi$dppi, y=ppi_cpi$dcpi, order = 5)

# and the other way round
grangertest(x=ppi_cpi$dcpi, y=ppi_cpi$dppi, order = 5)
# So the lags of cpi are significant
# cpi is a granger cause to ppi

# cpi -> ppi


# What is the conclusion? 
# At 5% significance level
# 1. PPI does not Granger-cause CPI
# 2. CPI does Granger-cause PPI

# Bonferroni correction!

#############################################################################
# Exercises 8
# Please perform similar analyses for variables R3M and R10Y 
# from the dataset "mrates.csv"
# Data:
#   R3M:  3-Month Treasury Constant Maturity Rate,
#   R10Y: 10-Year Treasury Constant Maturity Rate.
# Montly data: 01.1986-03.2017
# Source: Board of Governors of the Federal Reserve System
# Economic Data - FRED(R) II - http://research.stlouisfed.org/fred2/ 


#############################################################################
# Exercise 8.1
# Apply the test for cointegration of r3m and r10y - interpret its results
mrates = read.csv(file="mrates.csv", sep=",", header=TRUE)

plot(log(mrates$r10y), ylim=c(0,10),
     main = 'r10y and r3m indices', type="l")
lines(log(mrates$r3m), col = "blue")
legend("topleft", c("r10y", "r3m"), 
       col = c("black", "blue"), lty = 1)

testdf2(variable=mrates$r10y, test.type = "c", max.augmentations = 4, max.order = 4)
testdf2(variable=diff(mrates$r10y), test.type = "nc", max.augmentations = 4, max.order = 4)
# r10y ~ I(1)

testdf2(variable=mrates$r3m, test.type = "c", max.augmentations = 4, max.order = 4)
testdf2(variable=diff(mrates$r3m), test.type = "nc", max.augmentations = 4, max.order = 4)
# r3m ~ I(1)

model.coint = lm(r10y~r3m, data=mrates)
summary(model.coint)

testdf2(variable=residuals(model.coint), test.type = "nc", max.augmentations = 4, max.order = 4)
# the test statistic = -2.62
-(4.30+4.18)/2
# critical value
# critical region = (-infinity; -4.24)
# the residuals are non-stationary
# the variables are NOT cointegrated


#############################################################################
# Exercise 8.2
# Estimate and interpret an ECM model for these two variables
# 1. Prepare the variables (differenced and lagged)
# We use the residuals from the long-run model (model.coint) as the 'gap'
gap_lagged = residuals(model.coint)[1:(nrow(mrates)-1)]

# Differenced variables (short-run changes)
d_r10y = diff(mrates$r10y)
d_r3m = diff(mrates$r3m)

# 2. Estimate the ECM
# Formula: ΔR10Y = β1 * ΔR3M + β2 * gap_{t-1}
model.ecm = lm(d_r10y ~ d_r3m + gap_lagged)

# 3. View results
summary(model.ecm)

# 4. Extract the speed of adjustment
beta2 = coef(model.ecm)["gap_lagged"]
cat("Speed of adjustment (beta2):", beta2, "\n")
cat("Half-life of a shock (months):", 1/abs(beta2), "\n")

# 1. Short-Run Dynamics (d_r3m)

# Coefficient: 0.5338
# Interpretation: There is a strong, immediate positive relationship. 
# If the 3-Month rate increases by 1 percentage point this month, the 
# 10-Year rate is expected to rise by about 0.53 percentage points in the same month. 
# This is highly significant (p<2e−16).
# 
# 2. The Speed of Adjustment (gap_lagged)
# Coefficient (β 2): −0.0268
# Interpretation: This is the "rubber band" effect. Since it is negative, the 
# system is self-correcting.
# The "Speed": The system corrects only 2.68% of the "error" or gap from the 
# previous month. This is quite slow, suggesting that the 10-year and 3-month 
# rates can stay "out of sync" for a very long time.
# Significance: With a p-value of 0.0319, this is significant at the 5% level. 
# This contradicts your earlier 8.1 finding slightly—it suggests that while 
# cointegration is weak, there is a measurable long-run tie between the two variables.
#
# 3. Persistence (Half-life)
# Result: 37.27 months.
# Interpretation: It takes over 3 years (37 months) to close the gap 
# between where the rates are and where the long-run equilibrium says they 
# should be. In the world of finance, this is considered high persistence; 
# the "leash" between the short-term and long-term interest rates is very 
# long and stretchy.

#############################################################################
# Exercise 8.3
# Test for Granger causality between the two variables in both directions

#############################################################################
# Exercise 8.3
# Test for Granger causality between the two variables in both directions

# We use the 'lmtest' package for the grangertest function
if(!require(lmtest)) install.packages("lmtest")
library(lmtest)

# 1. Does R3M Granger-cause R10Y?
# We use diff() because the original variables are I(1)
granger_3m_to_10y = grangertest(diff(mrates$r10y) ~ diff(mrates$r3m), order = 1)
print(granger_3m_to_10y)

# 1. R3M → R10Y (Short-term to Long-term)
# 
# P-value: 0.6761
# 
# Result: Fail to reject H0
# 
# Interpretation: Changes in the 3-Month rate from last month do not help 
# predict changes in the 10-Year rate today. The long-term rate seems to 
# move based on its own history or other external factors (like inflation expectations) 
# rather than following the immediate lead of short-term rates.

# 2. Does R10Y Granger-cause R3M?
granger_10y_to_3m = grangertest(diff(mrates$r3m) ~ diff(mrates$r10y), order = 1)
print(granger_10y_to_3m)

# R10Y → R3M (Long-term to Short-term)
# 
# P-value: 0.1492
# 
# Result: Fail to reject H0
# 
# Interpretation: Changes in the 10-Year rate from last month do not help predict 
# changes in the 3-Month rate today. While the p-value is much lower than the first 
# test, it still sits well above the 0.05 threshold.



# In econometrics, "Granger causality" is specifically about precedence and prediction. 
# Your results suggest that:
#   
# Information is absorbed quickly: In efficient markets, the 10Y and 3M rates 
# often move simultaneously. Because Granger tests look at whether past (lagged) 
# values predict current values, they often miss relationships where the two variables 
# react to news at the exact same time.
# 
# Order Matters: You used order = 1 (one month lag). It is possible that the 
# "causality" takes longer to manifest.
# 
# Independence in Differences: While the variables are linked in levels 
# (as seen in your ECM model), their monthly changes (Δ) appear largely 
# independent of each other's past.
# 
# Recommended Next Step
# 
# To be thorough, you should check if a longer history matters by increasing the order. Often, the Federal Reserve takes a few months to react to market signals, or long-term investors take time to digest policy shifts.


# Check with 3 months of lags
grangertest(diff(mrates$r10y) ~ diff(mrates$r3m), order = 3)
grangertest(diff(mrates$r3m) ~ diff(mrates$r10y), order = 3)



# Contemporaneous Correlation vs. Lagged Prediction: In Exercise 8.2, your d_r3m 
# coefficient was huge (0.53) and highly significant. This means when the 3-month 
# rate moves, the 10-year rate moves in the same month.
# 
# No "Echo" Effect: Granger causality only looks for "echoes"—does a move 
# today cause another move next month? Your results say no. Once the rates move 
# together in month T, the history of that move doesn't help predict month T+1.
# 
# The Yield Curve is Efficient: This is a classic sign of market efficiency. 
# If one rate "lagged" behind the other consistently, traders could make guaranteed 
# money by watching the 3-month rate and betting on the 10-year rate for next month. 
# The fact that they aren't Granger-causing each other means the market prices in 
# new information almost instantly.

# these two variables are "linked" (equilibrium) and "react together" (short-run), 
# but they don't "lead" each other over time. They are like two hikers walking the 
# same trail at the same time, rather than one following the other's footprints.
