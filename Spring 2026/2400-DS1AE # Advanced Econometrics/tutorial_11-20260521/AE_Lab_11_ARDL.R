###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#                                                                         #
#                 Lab 12: (AR)DL Linear regression                        #
#                                                                         #
###########################################################################

if(!require(lmtest)){install.packages("lmtest")}
library(lmtest) 

if(!require(dynlm)){install.packages("dynlm")}
library(dynlm)

# install.packages("devtools")
library(devtools)
install_github("fcbarbi/ardl", force=TRUE)
library(ardl)

if(!require(AER)){install.packages("AER")}
library(AER)

if(!require(zoo)){install.packages("zoo")}
library(zoo)

if(!require(xts)){install.packages("xts")}
library(xts)

if(!require(fBasics)){install.packages("fBasics")}
library(fBasics)

Sys.setenv(LANG = "en")
options(scipen=5)

##########################################################
# Exploratory data analysis
#########################################################

# Quarterly US macroeconomic data from 1950(1) ? 2000(4)
# provided by USMacroG, a ?ts? time series. Contains 
# dpi --> disposable income
# consumption --> consumption (in billion USD).

data(USMacroG)

data(package = "AER")

USA<-as.zoo(USMacroG)


#plotting DPI and consuption
colors_ <- c("black", "red")

plot(USA[,c("dpi","consumption")], plot.type = "single",
   col = colors_,   # colors for subsequent lines
   ylab = "dpi/consumtion", xlab = "time", # axes labels
   main = "DPI & Consumption in the USA 1950 - 2000") # title above the plot

# separately we add a legend definition
legend("topleft",     # legend position - combination of top, bottom and left, right
     names(USA[,c("dpi","consumption")]), # legend elements (names of the series)
     text.col = colors_)     # colors (the same as in plot() function above)

#Conclusions?
# 1. Those 2 variables follows probably the same trend, in regression we would find this relation, but probably nothig more
# What to do?
# differentiation - is there relation between devianece from the trend?
# we want to work on stationary TS

#plotting first difference of DPI and consuption
plot(diff(USA[,c("dpi","consumption")]), plot.type = "single",
     col = colors_,   # colors for subsequent lines
     ylab = "dpi/consumtion", xlab = "time", # axes labels
     main = "DPI & Consumption in the USA 1950 - 2000") # title above the plot

# separately we add a legend definition
legend("topleft",     # legend position - combination of top, bottom and left, right
       names(USA[,c("dpi","consumption")]), # legend elements (names of the series)
       text.col = colors_)     # colors (the same as in plot() function above)


# for log-transformed data
plot(diff(log(USA[,c("dpi","consumption")])), plot.type = "single",
     col = colors_,   # colors for subsequent lines
     ylab = "dpi/consumtion", xlab = "time", # axes labels
     main = "DPI & Consumption in the USA 1950 - 2000") # title above the plot

# separately we add a legend definition
legend("topleft",     # legend position - combination of top, bottom and left, right
       names(USA[,c("dpi","consumption")]), # legend elements (names of the series)
       text.col = colors_)     # colors (the same as in plot() function above)



#stationarity testing
source("function_testdf2.R")

testdf2(variable = diff(USA[,c("dpi")]), # vector tested
       test.type = "nc", # test.type = "nc",
       max.augmentations = 7, # maximum number of augmentations added
       max.order=5) # maximum order of residual lags for BG 

# H0: diff(dpi) ~ I(1)
# H1: diff(dpi) ~ I(0), dpi~I(1)

options(scipen=999)
testdf2(variable = diff(USA[,c("consumption")]), # vector tested
        test.type = "nc", # test.type = "nc",
        max.augmentations = 3,  # maximum number of augmentations added
        max.order=5) # maximum order of residual lags for BG test
# H0: diff(consumption) ~ I(1)
# we cannot reject this hypothesis


# first-differences seem to have increasing variance
# thus, let us analyse the first difference of the log-transformed
# first differences

testdf2(variable = diff(log(USA[,c("dpi")])), # vector tested
        test.type = "nc", # test.type = "nc",
        max.augmentations = 5, # maximum number of augmentations added
        max.order=5) # maximum order of residual lags for BG test

testdf2(variable = diff(log(USA[,c("consumption")])), # vector tested
        test.type = "nc", # test.type = "nc",
        max.augmentations = 7,  # maximum number of augmentations added
        max.order=5) # maximum order of residual lags for BG test
# again the same result
# that diff(log(consumption)) are non-stationary
# we should analyse diff(diff(log(consumption)))

View(USA[41:204, ])
testdf2(variable = diff(log(USA[41:204,c("consumption")])), # vector tested
        test.type = "nc", # test.type = "nc",
        max.augmentations = 7,  # maximum number of augmentations added
        max.order=5) # maximum order of residual lags for BG test
testdf2(variable = diff(log(USA[41:204,c("dpi")])), # vector tested
        test.type = "nc", # test.type = "nc",
        max.augmentations = 5, # maximum number of augmentations added
        max.order=5) # maximum order of residual lags for BG test



plot(diff(log(USA[,c("consumption")])))
plot(diff(diff(USA[,c("consumption")])))

##########################################################
# Autoregressive Distributed Lagged Model
#########################################################

#  Distirbuted Lagged Model
# As regressors we use lags of explanatory variables
# start = c(1960, 1) is set to make comparison between models with different lag order possible

# diff(consumption) ~ diff(dpi)+lagged(diff(dpi))
# DL model
dl_1 <- dynlm(d(consumption) ~ d(dpi) + L(d(dpi)), data = USA, start = c(1960, 1))
summary(dl_1)
# short-term multiplier
# 0.37915
# long-term multiplier
sum(summary(dl_1)$coefficients[2:3,1])

# diff(consumption) ~ diff(dpi)+lagged(diff(dpi))+diff(cpi)+lagged(diff(cpi))


# alternative model for log-transformed variables
USA$ln_consumption = log(USA$consumption)
USA$ln_dpi = log(USA$dpi)
dl_ln1 <- dynlm(d(ln_consumption) ~ d(ln_dpi) + L(d(ln_dpi)), data = USA, start = c(1960, 1))
summary(dl_ln1)

# Diagnostics
# 1. Autocorrelation - Breusch-Godfrey test
# 2. Heteroskedasticity - Breusch-Pagan test
# 3. Linearity - Ramsey's RESET test
# 4. Normality of errors - Jarque-Bera test
# 5. Statibility test - Chow's test

acf(dl_1$residuals, type='correlation')
#in order to draw a conclusions based on the model we would like to sort out a problem with autocorrelation
#has this model sorted out autocorrelation issue? - nope
bgtest(residuals(dl_1)~1, order = 1)
bgtest(residuals(dl_1)~1, order = 2)
bgtest(residuals(dl_1)~1, order = 3)
bgtest(residuals(dl_1)~1, order = 4)
bgtest(residuals(dl_1)~1, order = 5)

# The residuals are autocorrelated.
# Autocorrelation (like heteroskedasticity) leads to biased estimators of Std.Errors.
# as a consequence, we do not know which variables are significant
# because we cannot trust to p-values

dl_5_all <- dynlm(d(consumption) ~ d(dpi) + L(d(dpi),c(1:5)), data = USA,start = c(1960, 1))
summary(dl_5_all)
dl_5 <- dynlm(d(consumption) ~ d(dpi) + L(d(dpi),c(1,2,5)), data = USA,start = c(1960, 1))
summary(dl_5) 

#check which model is better
# H0: the third lag estimate = the fourth lag estimate = 0
anova(dl_5_all,dl_5)
#conclusion? both are statistically equal so we prefer with more DF (less regressors)

summary(dl_5)

acf(dl_5$residuals, type='correlation')
#has this model sorted out autocorrelation issue? - nope
bgtest(residuals(dl_5)~1, order = 1)
bgtest(residuals(dl_5)~1, order = 2)
bgtest(residuals(dl_5)~1, order = 3)
bgtest(residuals(dl_5)~1, order = 4)
bgtest(residuals(dl_5)~1, order = 5)

# Autocorrelation issue has beed not solved, but in DL models the problem is only in inconsistent Variance - Covariance matrix
# Newey - Davis robust estimator can be used to update the results and draw conclusions

library(lmtest)
library(sandwich)
coeftest(dl_5, vcov=vcovHAC(dl_5))

# Maybe Autoregressive Distirbuted Lagged Model would help?
# Note: Autocorrelation in residuals for ARDL lead to inconsistency of estimators!


ardl_5_all <- dynlm(d(consumption) ~ L(d(consumption),c(1:5)) + d(dpi) + L(d(dpi),c(1,2,5)), 
                    data = USA, start = c(1960, 1))
summary(ardl_5_all)

ardl_5 <- dynlm(d(consumption) ~ L(d(consumption),c(2,3)) + d(dpi), data = USA, start = c(1960, 1))
summary(ardl_5)

#check which model is better:
anova(ardl_5_all,ardl_5)
# H0: all variables we removed are jointly insignificant
# we cannot reject the null

#conclusion? both are statistically equal so we prefer with more DF (less regressors)

acf(ardl_5$residuals, type='correlation')
#has this model sorted out autocorrelation issue? - Yes!!
bgtest(residuals(ardl_5_all)~1, order = 1)
bgtest(residuals(ardl_5_all)~1, order = 2)
bgtest(residuals(ardl_5_all)~1, order = 3)
bgtest(residuals(ardl_5_all)~1, order = 4)
bgtest(residuals(ardl_5_all)~1, order = 5)
 
#automatic procedure to find number of lags
USA$diff_consumption<-diff(USA[,c("consumption")])
USA$diff_dpi<-diff(USA[,c("dpi")])
ardl_auto <- ardl::auto.ardl(diff_consumption ~ diff_dpi, data=USA[-1,], 
                             ymax=10, xmax=10, verbose=TRUE, ic="aic")
summary(ardl_auto)


#fitted values and residuals
plot(merge(as.zoo(diff(USA[,"consumption"])), fitted(ardl_5),
              fitted(dl_1), 0, residuals(ardl_5),
              residuals(dl_1)), screens = rep(1:2, c(3, 3)),
              col = rep(c(1, 2, 4), 2), xlab = "Time",
              ylab = c("Fitted values", "Residuals"), main = "")
              legend(0.05, 0.95, c("observed", "ardl_5", "dl_1"),
              col = c(1, 2, 4), lty = 1, bty = "n")


###################################################################################################      
#Diagnostics other than Autocorrelation
###################################################################################################

# Diagnostics plots    

par(mfrow=c(2,2))
plot(ardl_5)
par(mfrow=c(1,1))

# 1. Residuals vs Fitted
# 
# This plot shows if residuals have non-linear patterns. 
# There could be a non-linear relationship between predictor variables and an outcome variable 
# and the pattern could show up in this plot if the model doesn?t capture the non-linear relationship. 
# If you find equally spread residuals around a horizontal line without distinct patterns,
# that is a good indication you don?t have non-linear relationships.

# 2. Normal Q-Q
# 
# This plot shows if residuals are normally distributed. 
# Do residuals follow a straight line well or do they deviate severely? 
# It?s good if residuals are lined well on the straight dashed line.

#residuals normality test
# install.packages("interp")
jbTest(as.matrix(residuals(ardl_5)))
# install.packages("tseries")
library("tseries")
jarque.bera.test(residuals(ardl_5))
# H0: variable is normally distributed


# 3. Scale-Location
# 
# It?s also called Spread-Location plot. 
# This plot shows if residuals are spread equally along the ranges of predictors. 
# This is how you can check the assumption of equal variance (homoscedasticity). 
# It?s good if you see a horizontal line with equally (randomly) spread points.

# 4. Residuals vs Leverage
# 
# This plot helps us to find influential cases (i.e., subjects) if any. 
# Not all outliers are influential in linear regression analysis (whatever outliers mean). 
# Even though data have extreme values, they might not be influential to determine a regression line. 
# That means, the results wouldn?t be much different if we either include or exclude them from analysis. 
# They follow the trend in the majority of cases and they don?t really matter; they are not influential. 
# On the other hand, some cases could be very influential even if they look to be within a reasonable range of the values. 
# They could be extreme cases against a regression line and can alter the results if we exclude them from analysis. 
# Another way to put it is that they don?t get along with the trend in the majority of the cases.
# 
# Unlike the other plots, this time patterns are not relevant. 
# We watch out for outlying values at the upper right corner or at the lower right corner. 
# Those spots are the places where cases can be influential against a regression line. 
# Look for cases outside of a dashed line, Cook?s distance.
# When cases are outside of the Cook?s distance (meaning they have high Cook?s distance scores), 
# the cases are influential to the regression results. The regression results will be altered if we exclude those cases.
# 

# http://data.library.virginia.edu/diagnostic-plots/


## Breusch-Pagan
bptest(ardl_5,data=USA, studentize=TRUE)
bptest(ardl_5,data=USA)


## Variance Inflation Ratio
vif(ardl_5,data=USA)


############################################################

#    upload a dataset form AER package named USConsump1993
#    in the dataset relation between income and expenditure
#    in the USE years 1950-1993 are stored

##########################################################

data(USConsump1993)
USA<-as.zoo(USConsump1993)    

 
#    Excersie 4




# 4.1
# Asses wheter time series are stationary or not 
# and prepared data to (AR)DL model for expenditure 


# 4.2 
# Choose the best model from (AR)DL family




# 4.3
# Perform diagnostics analysis to check whether the chosen model fulfills assumptions




# 0-------------------------------------------------------------------------

x = rep(6, times=21)
z = rep(12, times=21)
# now it is in the steady state
par(mfrow=c(2,1))
barplot(x)
barplot(z)  

# a unitary shock

x[14] = x[14]+1
for(t in 14:21) {
z[t] = 1 + x[t] + 2/3*x[t-1] + 1/6*x[t-2]
}

par(mfrow=c(2,1))
barplot(x)
barplot(z)    

par(mfrow=c(1,1))


