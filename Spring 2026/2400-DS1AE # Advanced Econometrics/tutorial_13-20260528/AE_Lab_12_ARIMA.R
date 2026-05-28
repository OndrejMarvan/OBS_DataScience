###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#   Materials based on dr Piotr Wojcik Time Series Analysis for QF        #
#                                                                         #
#                 Lab 12: ARIMA                                           #
#                                                                         #
###########################################################################

# options
Sys.setenv(LANG = "en")

# libraries
library(lmtest)
library(fBasics)
library(urca)
library(xts)
install.packages("forecast")
library(forecast)
library(quantmod)

# lets introduce penalty on the scientific notation
options(scipen = 20)


######## RANDOM WALK WITHOUT DRIFT

# lets remind a continuous normal random walk without a drift
cnrw <- rep(0, 1000)

# now the random disturbance comes from a N(0,1) distribution
e <- rnorm(1000, mean = 0, sd = 1)

for(i in 2:1000){
cnrw[i] <- cnrw[i-1] + e[i]
}


# plot of continuous normal random walk 
plot(cnrw, type = "l", 
   col = "blue", lwd = 2, 
   main = "Continuous normal random walk")

##################################################################################
# simulated AR, MA and ARMA processes and their characteristics
##################################################################################
# cnrw created before:  y_t = y_{t-1} + e_t

# lets change the way the plots look like
acf(cnrw, 
    lwd = 5, # line width
    col = "dark green", # color
    main = "ACF for cnrw")

pacf(cnrw, 
     lwd = 5, # line width
     col = "dark green", # color
     main = "PACF for cnrw")

# pacf for lag 1 is by definition equal to 1 
# we can squeeze the scale to see the remaining ones better

pacf(cnrw, 
     lwd = 5, # line width
     col = "dark green", # color
     main = "PACF for cnrw",
     ylim = c(-0.2, 0.2)) # limits for y axis


# lets put it together in one window
# parameter mfrow defines how the graphical window
# is divided - we provide the number of rows and colums

# the graphical window will be divided into 
# two rows and one column (all panels of the same size)
par(mfrow = c(2,1)) 
acf(cnrw, lwd = 5, col = "dark green", 
    main = "ACF for cnrw")
pacf(cnrw, lwd = 5, col = "dark green", 
     main = "PACF for cnrw", ylim = c(-0.2, 0.2) )
# at the end we restore the default graphical window definition
par(mfrow = c(1,1))

# ACF is exponentially decreasing but very very slowly
# only one lag of PACF significant (and equal to 1, 
# which is the autoregressive parameter here!)  
# PACF lag 1 = 1.0 — yes, yesterday directly affects today, coefficient exactly 1
# PACF lag 2 = ≈ 0 — two days ago has no direct effect, only indirect through yesterday
# PACF lag 3 = ≈ 0 — same reason
# All others = ≈ 0
# The ACF tells you something is wrong (non-stationary). The PACF tells you exactly what — it is AR(1) with ϕ=1\phi = 1
# ϕ=1. Together they diagnose a random walk perfectly.

##################################################################################
# lets generate a stationary autoregressive process
# of order 1:  y_t = 0.8 * y_{t-1} + e_t

ar1 <- rep(0, 1000)

# now the random disturbance comes from a N(0,1) distribution
e <- rnorm(1000, mean = 0, sd = 1)

for(i in 2:1000) {
  ar1[i] <- 0.8 * ar1[i-1] + e[i]
}
  
# plot of a stationary autoregressive process 
plot(ar1, type = "l", 
     col = "blue", lwd = 2, 
     main = "AR(1): y_t = 0.8 * y_{t-1} + e_t")

par(mfrow = c(2,1))
acf(ar1, lwd = 5, col = "dark green", main = "ACF")
pacf(ar1, lwd = 5, col = "dark green", main = "PACF")
par(mfrow = c(1,1))

# ACF is exponentially decreasing to 0 (some first lags significant)
# (ACF lag 0 always equal to 1 - check the lecture slides)
# only the first lag of PACF significant (and close to 0.8, 
# which is the autoregressive parameter here!)  

# lets check its stationarity
# we will use the testdf() function
# written by the lecturer
# lets load it from the external file

source("function_testdf2.R")
testdf2(variable = ar1, test.type = "nc", 
        max.augmentations = 6, max.order = 4)

# Getting smaller every lag — exponential decay. Eventually crosses the significance 
# line and becomes statistically zero. 
# Compare this to random walk where it never reaches zero.

# we strongly reject the null about non-stationarity
# which variant of the DF test should we use here?


# There are three variants:
# VariantCodeWhen to useNo constant, no trend"nc"Series fluctuates around zero
# Constant, no trend"c"Series fluctuates around a non-zero mean
# Constant + trend"ct"Series has a visible upward/downward trend

# For AR(1) with no drift, the series bounces around zero → "nc" is correct here. 
#  "nc" was chosen — look at the plot, series around zero, no trend → "nc" makes sense.

# You generate 1000 observations of yt=0.8yt−1+εty_t = 0.8y_{t-1} + \varepsilon_t
# yt​=0.8yt−1​+εt​, plot it, and it bounces around zero (stationary). 
# ACF decays exponentially (shrinks by factor 0.8 each lag).
# PACF has exactly one spike at lag 1 equal to 0.8 — directly revealing the AR(1) 
# structure and the coefficient. ADF test confirms stationarity by rejecting the null 
# of a unit root. The "nc" variant is used because the series has no drift and no trend.

# In AR(1) there is literally only one direct connection in the formula — yt−1y_{t-1}
# yt−1​. Everything else is just an echo of that. PACF strips the echoes away and shows you the raw formula structure.

##################################################################################
# lets generate a stationary autoregressive process of order 2:  
# y_t = 0.6 * y_{t-1} + 0.2 * y_{t-2} + e_t

ar2 <- rep(0, 1000)

# now the random disturbance comes from a N(0,1) distribution
e <- rnorm(1000, mean = 0, sd = 1)

for(i in 3:1000){
  ar2[i] <- 0.6 * ar2[i-1] + 0.2 * ar2[i-2] + e[i]
}
  
# plot of a stationary autoregressive process of order 2
plot(ar2, type = "l", 
     col = "blue", lwd = 2, 
     main = "AR(2): y_t = 0.6 * y_{t-1} + 0.2 * y_{t-2} + e_t")

par(mfrow = c(2,1))
acf(ar2, lwd = 5, col = "dark green", main = "ACF")
pacf(ar2, lwd = 5, col = "dark green", main = "PACF")
par(mfrow = c(1,1))


# ACF is exponentially decreasing to 0 (some first lags significant)
# (ACF lag 0 always equal to 1)
# TWO first lags of PACF significant (and close to 0.7 and 0.2, 
# which are the autoregressive parameters here!)  

# lets check its stationarity

testdf2(variable = ar2, test.type = "nc", max.augmentations = 2, max.order = 4)

# we strongly reject the null about non-stationarity
# which variant of the DF test should we use here?



##################################################################################
# lets generate a stationary moving average process
# of order 1:  y_t = e_t - 0.9 * e_{t-1}

ma1 <- rep(0, 1000)

# now the random disturbance comes from a N(0,1) distribution
e <- rnorm(1000, mean = 0, sd = 1)

for(i in 2:1000){
  ma1[i] <- e[i] - 0.9 * e[i-1]
}
  

# plot of a stationary moving average process
plot(ma1, type = "l", 
     col = "blue", lwd = 2, 
     main = "MA(1): y_t = e_t - 0.9 * e_{t-1}")

par(mfrow = c(2,1))
acf(ma1, lwd = 5, col = "dark green", main = "ACF")
pacf(ma1, lwd = 5, col = "dark green", main = "PACF")
par(mfrow = c(1,1))

# only the first lag of ACF significant (lag=0 always equal to 1)
# (ACF lag 0 always equal to 1)
# PACF is exponentially decreasing to 0 in absolute terms 
# (some first lags significant)

# lets check its stationarity

testdf2(variable = ma1, test.type = "nc", max.augmentations = 5, max.order = 4)

# we strongly reject the null about non-stationarity
# which variant of the DF test should we use here?


# MA(1) has only ONE past shock in the formula — εt−1\varepsilon_{t-1} εt−1.
# This means:
#   
# Today shares εt−1\varepsilon_{t-1}
# εt−1 with yesterday → correlated → ACF lag 1 is big
# Today shares nothing with 2 days ago → ACF lag 2 = exactly zero
# Today shares nothing with 3 days ago → ACF lag 3 = exactly zero

# MA(1) has only one past shock in its formula so ACF cuts off cleanly after lag 1 — directly revealing 
# the MA(1) structure. PACF decays in an alternating pattern (positive/negative/positive...) 
# getting smaller in absolute terms — you cannot read the order from it. ADF test strongly 
# rejects non-stationarity which makes sense because MA processes are always stationary. 
# The "nc" variant is correct because the series fluctuates around zero with no drift or trend.

##################################################################################
# lets generate a stationary moving average process
# of order 2:  y_t = e_t + 0.6 * e_{t-1} + 0.2 * e_{t-2}

ma2 <- rep(0, 1000)

# now the random disturbance comes from a N(0,1) distribution
e <- rnorm(1000, mean = 0, sd = 1)

for(i in 3:1000){
  ma2[i] <- e[i] + 0.6 * e[i-1] + 0.2 * e[i-2]
}
  

# plot of continuous normal random walk 
plot(ma2, type = "l", 
     col = "blue", lwd = 2, 
     main = "MA(2): y_t = e_t + 0.6 * e_{t-1} + 0.2 * e_{t-2}")

par(mfrow = c(2,1))
acf(ma2, lwd = 5, col = "dark green", main = "ACF")
pacf(ma2, lwd = 5, col = "dark green", main = "PACF")
par(mfrow = c(1,1))

# only the first two lags of ACF significant 
# (lag=0 always equal to 1)
# (ACF lag 0 always equal to 1)
# PACF does not show a clear exponential decreasing pattern
# (some first lags significant)

# lets check its stationarity

testdf2(variable = ma2, test.type = "nc", max.augmentations = 2, max.order = 4)

# we strongly reject the null about non-stationarity
# which variant of the DF test should we use here?

##################################################################################
# lets generate a stationary ARMA process
# of order (3,2):  y_t = 0.5 * y_{t-1} + 0.2 * y_{t-2} + 0.05 * y_{t-3} +
#                        + e_t + 0.8 * e_{t-1} + 0.1 * e_{t-2}

arma32 <- rep(0, 1000)

# now the random disturbance comes from a N(0,1) distribution
e <- rnorm(1000, mean = 0, sd = 1)

for(i in 4:1000) 
  arma32[i] <-  0.5 * arma32[i-1] + 0.2 * arma32[i-2] + 0.05 * arma32[i-3] +
  e[i] + 0.8 * e[i-1] + 0.1 * e[i-2]

# plot of continuous normal random walk 
plot(arma32, type = "l", 
     col = "blue", lwd = 2, 
     main = "ARMA(3,2)")

par(mfrow = c(2,1))
acf(arma32, lwd = 5, col = "dark green", main = "ACF")
pacf(arma32, lwd = 5, col = "dark green", main = "PACF")
par(mfrow = c(1,1))

a = pacf(arma32, lwd = 5, col = "dark green", main = "PACF")
plot(abs(a$acf), type="b", main="PACF of ARMA(3,2)")
# Both ACF and PACF are exponentialy decreasing to 0
# (PACF in absolute terms)
# but ACF slower, which may indicate 
# that AR effect is stronger than the MA effect

# lets check its stationarity
testdf2(variable = arma32, test.type = "nc", max.augmentations = 4,
        max.order = 4)

# we strongly reject the null about non-stationarity
# which variant of the DF test should we use here?


#############################################################################
# Real data example
##############################################################################

# lets import the data with prices of SP500
# directly from Yahoo finance
# by the getSymbols() function from quantmod
# we need to know a correct ticker
# for world indices check:
# https://finance.yahoo.com/world-indices
# ^GSPC for S&P500 index

getSymbols("^GSPC",             # ticker
           from = "1970-01-01", # starting date
           to = "2017-03-29")   # end date

head(GSPC)
tail(GSPC)

# lets keep just the close price (Adjusted)
# not for close but for adjusted price
# then 6 should be substituted with 4

GSPC <- GSPC[,6]

head(GSPC)

# and change its name to SP500
names(GSPC) <- "SP500"

# lets calculate first differences 
GSPC$dSP500 <- diff.xts(GSPC$SP500)

# plot of the original and differenced series
plot(as.zoo(GSPC), 
     main = "Original and differenced data for S&P500")

# lets put a "penalty" on scientific notation
options(scipen  =  10)

# lets test integration level - d parameter 
# using testdf function 
# the third version of the test
testdf2(variable = GSPC$SP500, test.type = "ct",
       max.augmentations = 7,max.order = 5)
# the second version of the test
testdf2(variable = GSPC$SP500, test.type = "c",
        max.augmentations = 7,max.order = 5)

# the first differences of the index
testdf2(variable = GSPC$dSP500, test.type = "nc",
        max.augmentations = 7, max.order = 5)


plot(log(GSPC$SP500))
GSPC$lnSP500 = log(GSPC$SP500)
GSPC$dlnSP500 = diff.xts(GSPC$lnSP500)
plot(GSPC$dlnSP500)

# H0 (about non-stationarity) cannot be rejected 
# (we use ADF with 1 augmentation),  
#  so we turn to test for 1st differences 

testdf2(variable = log(GSPC$lnSP500), test.type = "c",
        max.augmentations = 2, max.order = 5)
testdf2(variable = GSPC$dlnSP500, test.type = "nc",
        max.augmentations = 2, max.order = 5)

# 1st differences are already stationary
# (here we can use a basic DF test), 
# so SP500 close price is an I(1) process - d = 1 

#######################################################################
# below we apply the Box-Jenkins procedure

#######################################################################
# step 1. INITIAL IDENTIFICATION of parameters p and q 

# lets see ACF and PACF for non-stationary variable
# ACF and PACF are calculated up to 36th lag
# lets plot them together and limit the scale of ACF
par(mfrow = c(2,1)) 
acf(GSPC$dSP500,
    lag.max = 36, # max lag for ACF
    ylim = c(-0.1,0.1),    # limits for the y axis - we give c(min,max)
    lwd = 5,               # line width
    col = "dark green",
    na.action = na.pass)   # do not stop if there are missing values in the data
pacf(GSPC$dSP500, 
     lag.max = 36, 
     lwd = 5, col = "dark green",
     na.action = na.pass)
par(mfrow = c(1,1)) # we restore the original single panel

# if there are missing values in the data we need 
# to add an additional option na.action = na.pass (see below)

# ACF and PACF suggest that maybe ARIMA (5,1,5) could be
#	a sensible model for SP500, probably without lags 3 and 4

# ARIMA(5,1,5) without lags 3 and 4 because: significant spikes appear at lags 1, 2 
# and 5 in both plots (→ need both AR and MA up to order 5), nothing significant 
# at lags 3 and 4 (→ set those to zero), and the level series needs one difference to become stationary (→ d=1).

# lets compare different models with AIC criteria 


#######################################################################
# steps 2 and 3 interchangeably. MODEL ESTIMATION and DIAGNOSTICS


###############################################################################
# lets start with ARIMA(1,1,1)

arima111 <- arima(GSPC$SP500,  # variable
                  order = c(1,1,1)  # (p,d,q) parameters
)
summary(arima111)
# the model on differenced data (d = 1) is always 
# estimated by arima() function without a constant term
# (assuming that first differences fluctuate arround 0)

# lets use coeftest() function from the lmtest package
# to test for significance of model parameters
coeftest(arima111)

# both are highly significant

# however, using that syntax produces a model without a constant term
# the constant is included when d = 0

# if one wishes to include a constant also when d = 1
# they should use Arima() function from the forecast package

arima111_2 <- Arima(GSPC$SP500,  # variable
                    order = c(1,1,1),  # (p,d,q) parameters
                    include.constant = TRUE)  # including a constant

summary(arima111_2)

# a constant for a model with d = 1 is reported as a drift parameter

coeftest(arima111_2)
# it is statistically significant here at 5% level!!!
# mean(GSPC$dSP500, na.omit=TRUE)
a = GSPC$dSP500
a = na.omit(a)
mean(a)
plot(GSPC$dSP500)

# are residuals of arima111 model white noise? 
# resid() function applied to model results returns residuals

par(mfrow = c(2,1))  
acf(resid(arima111_2), 
    lag.max = 36,
    ylim = c(-0.1,0.1), 
    lwd = 5, col = "dark green",
    na.action = na.pass)
pacf(resid(arima111_2), 
     lag.max = 36, 
     lwd = 5, col = "dark green",
     na.action = na.pass)
par(mfrow = c(1,1))

# significance of lag 2 disappeared, but 
# there are some other still significant (5, 10, 12, 15, 16...)

# Ljung-Box test (for a maximum of 10 lags)
Box.test(resid(arima111_2),
         type = "Ljung-Box", lag = 10)

# we reject the null about residuals being white noise!
# so the model is not complete - it can be still extended to account
# for this autocorrelation inside the model

# lets compare with other models 
#	-> are AIC "better" (lower)?
#	-> are new parameters significant? 

###############################################################################
# lets try ARIMA(5,1,5)
arima515 <- Arima(GSPC$SP500, 
                  order = c(5,1,5), 
                  include.constant = TRUE)

summary(arima515)

coeftest(arima515)

# lag 5 does not seem to be significant

# Ljung-Box test for autocorrelation of model residuals

Box.test(resid(arima515),
         type = "Ljung-Box",lag = 10)
# null cannot be rejected !

# ACF and PACF for residuals
par(mfrow = c(2,1))  
acf(resid(arima515), 
    lag.max = 36, 
    ylim = c(-0.1,0.1), 
    lwd = 7, col = "dark green",
    na.action = na.pass)
pacf(resid(arima515), 
     lag.max = 36, 
     lwd = 7, col = "dark green",
     na.action = na.pass)
par(mfrow = c(1,1))

# lags of ACF and PACF up to 10 are not significant any more
# some higher lags are significant, but difficult to explain 


###############################################################################
# lets try ARIMA(5,1,5) model without lags 3 and 4

# intermediate lags can be set to 0 by using the fixed argument
arima515_2 <- Arima(GSPC$SP500,
                    order = c(5,1,5),
                    fixed = c(NA,NA,0,0,NA,  # vector of the same
                              NA,NA,NA,0,0,NA), # length as the total number of parameters
                    include.constant = TRUE  # last is for the intercept (if included)
)                         # NA means no restriction on a parameter

summary(arima515_2)

coeftest(arima515_2)
# lag 1 appears not to be statistically significant
# although initial ACF and PACF showed something different
# lag 5 is now significant both in case of AR and MA

# Ljung-Box test
Box.test(resid(arima515_2),
         type = "Ljung-Box",lag = 10)

# null cannot be rejected again - so the model seems 
# to include enough lags


# ACF and PACF for residuals
par(mfrow = c(2,1))  
acf(resid(arima515_2), lag.max = 36, 
    ylim = c(-0.1,0.1), 
    lwd = 7, 
    col = "dark green",
    na.action = na.pass)
pacf(resid(arima515_2), 
     lag.max = 36, 
     lwd = 7, 
     col = "dark green",
     na.action = na.pass)
par(mfrow = c(1,1))

# ACF lag 3 is close to the  border of significance
# - lets add MA(3) component to the latest model

###############################################################################
# lets apply ARIMA(5,1,5) model without selected lags

# intermediate lags can be set to 0 by using the fixed argument
arima515_3 <- Arima(GSPC$SP500,
                    order = c(5,1,5),
                    fixed = c(NA,NA,0,0,NA,  # vector of the same
                              0,NA,0,0,0,NA), # length as the total number of parameters
                    include.constant = TRUE  # last is for the intercept (if included)
)                         # NA means no restriction on a parameter

summary(arima515_3)

coeftest(arima515_3)
# MA3 not significant at 5% level

# Ljung-Box test
Box.test(resid(arima515_3),
         type = "Ljung-Box",lag = 10)

# null cannot be rejected 

# ACF and PACF for residuals
par(mfrow = c(2,1))  
acf(resid(arima515_3), 
    lag.max = 36, 
    ylim = c(-0.1,0.1), 
    lwd = 7, 
    col = "dark green",
    na.action = na.pass)
pacf(resid(arima515_3), 
     lag.max = 36, 
     lwd = 7, 
     col = "dark green",
     na.action = na.pass)
par(mfrow = c(1,1))


###############################################################################
# lets also try pure AR(5) model without lag 4
# for comparisons

# intermediate lags can be set to 0 by using the fixed argument

arima510 <- Arima(GSPC$SP500,
                  order = c(5,1,0),
                  include.constant = T,
                  fixed = c(NA,NA,NA,0,NA,
                            NA)) 

summary(arima510)

coeftest(arima510)
# AR3 not significant at 5% level

# Ljung-Box test
Box.test(resid(arima510), 
         type = "Ljung-Box", lag = 10)

# null about lack of autocorrelation rejected,
# so just AR(5) is not a complete model

###############################################################################
# lets also try a basic MA(5) model without lag 4

# intermediate lags can be set to 0 by using the fixed argument
arima015 <- Arima(GSPC$SP500,
                  order = c(0,1,5),
                  include.constant = T,
                  fixed = c(NA,NA,NA,0,NA, 
                            NA)) 

summary(arima015)

coeftest(arima015)
# MA3 not significant

# Ljung-Box test
Box.test(resid(arima015),
         type = "Ljung-Box",lag = 10)

# null about lack of autocorrelation not rejected,
# but only at 1% level 

###############################################################################
# lets compare AIC for all models estimated so far
# CAUTION! for some of them rediduals are not white noise!

# Based on AIC which model is best? 

AIC(arima111_2, arima515, arima515_2, 
    arima515_3, arima510, arima015)
# arima515

# lets do the same for BIC
BIC(arima111_2, arima515, arima515_2, 
    arima515_3, arima510, arima015)
# arima111_2


# there is also a way to automatically find the best model
arima.best.AIC <- auto.arima(GSPC$SP500,
                             d = 1,             # parameter d of ARIMA model
                             max.p = 7,        # Maximum value of p
                             max.q = 7,        # Maximum value of q
                             max.order = 8,    # maximum p+q
                             start.p = 1,       # Starting value of p in stepwise procedure
                             start.q = 1,       # Starting value of q in stepwise procedure
                             ic = "aic",        # Information criterion to be used in model selection.
                             stepwise = FALSE,  # if FALSE considers all models
                             allowdrift = TRUE, # include a constant
                             trace = TRUE)      # show summary of all models considered

# the result might be surprising

coeftest(arima.best.AIC)
# ARIMA(2,1,5) 

AIC(arima.best.AIC)
# AIC better than for the best manually selected model

BIC(arima.best.AIC)
# BIC worse than for the best manually selected model

# Ljung-Box test
Box.test(resid(arima.best.AIC),
         type = "Ljung-Box", lag = 10)

# but the automated procedure does not 
# exclude intermediate lags


# automated procedure is not necessarily better
# than step-by-step human approach

# Lets finally decide to select two models:
# arima515 - sensible, manually selected based on AIC
# arima515_2 - sensible, manually selected based on BIC
# ARIMA(6,1,8) - automated selection based on AIC

# for further comparisons (forecasts)

# these models have:
# - lowest information criteria (AIC or BIC)
# - their residuals are white noise
# - (almost) all parameters significant

# We will finally use these models for forecasting

#######################################################################

# lets see few last observations
tail(GSPC, 10)

# we cut last 8 observations (since 2017-03-20)
# and keep them aside as the out-of-sample
# to perform a forecasting exercise
# and have a possibility to assess it

GSPC.sample <- GSPC["/2017-03-17", 1]

tail(GSPC.sample)

# FORECAST for SP500 - model arima515

# estimate the model on shorter sample
arima515s <- Arima(GSPC.sample$SP500,  # variable
                   order = c(5,1,5),   # (p,d,q) parameters
                   include.constant = T)

arima515s

# lets make a prediction
forecast515  =  forecast(arima515s, # model for prediction
                         h = 8) # how many periods outside the sample

# lets see the result
forecast515

# the forecasts are indexed with a observation number, 
# not a date!

class(forecast515$mean)

# it is a ts object, not xts

# it includes:
# Point Forecast - predicted values
forecast515$mean

# 80% and 95% confidence intervals
forecast515$lower
forecast515$upper

# if we want to easily put together both real data
# and the forecast on the plot, we have to convert
# both to ts or both to xts objects

class(GSPC)

tail(GSPC, 10) # indexed by date

# ts() function does easily convert xts to ts object

class(ts(GSPC))

tail(ts(GSPC), 10) # indexed by observation number


# lets plot the figure with the forecast

# original data
plot(ts(GSPC[,1]), main = "8 day forecast of SP500")
# line at the end of a sample period (start of the forecast)
# observation number 11912
abline(v = 11912, lty = 2, col = "gray")
# line for the forecast
lines(forecast515$mean, col = "red", lwd = 2)
# line for the 95% confidence interval
# indexed by observation numbers from the forecast
lines(11912:11919,forecast515$lower[,2], col = "red", lty = 3)
lines(11912:11919,forecast515$upper[,2], col = "red", lty = 3)

# lets see its zoom
plot(ts(GSPC[,1]), main = "8 day forecast of SP500",
     xlim = c(11880,11919), ylim = c(2250, 2450))
abline(v = 11912, lty = 2, col = "gray")
lines(forecast515$mean, col = "red", lwd = 2)
lines(11912:11919,forecast515$lower[,2], col = "red", lty = 3)
lines(11912:11919,forecast515$upper[,2], col = "red", lty = 3)


# checking forecast quality 

# for simplicity of the following formulas
# lets define two new objects:

SP500.r <- tail(GSPC$SP500, 8)  # real values - last 8 observations
SP500.f <- as.numeric(forecast515$mean) # forecast

SP500_forecast <- data.frame(SP500.r, SP500.f)

# lets add the basis for different measures of the forecast error
SP500_forecast$mae  =  abs(SP500.r - SP500.f)
SP500_forecast$mse  =  (SP500.r - SP500.f)^2
SP500_forecast$mape  =  abs((SP500.r - SP500.f)/SP500.r)
SP500_forecast$amape  =  abs((SP500.r - SP500.f)/(SP500.r+SP500.f))

# and calculate its averages
colMeans(SP500_forecast[,3:6])

# NOTICE!!!! Model which performs best in the sample 
#	will NOT NECESSARILY be best for forecasting.
#	One should compare forecasts for several models. 


# -------------------------------------------------------------
# Let's discuss an example process
# AR(3) process

T = 300
alpha1 = 1/2
alpha2 = 1/4
alpha3 = 1/8

ar3 = rep(0, times=T)
for(t in 4:T) {
  ar3[t] = alpha1*ar3[t-1]+alpha2*ar3[t-2]+alpha3*ar3[t-3]+rnorm(n=1)
}

plot(ar3, type="l")

# forecasting
ar3 = c(ar3, t(rep(0, times=50)))
for(t in (T+1):(T+50)) {
  ar3[t] = alpha1*ar3[t-1]+alpha2*ar3[t-2]+alpha3*ar3[t-3]
}

plot(ar3, type="l")
plot(ar3[301:350], type="l")





##################################################################################
# Exercises

################ 
# Exercise # 5.1
################
# Generate a stationary process AR(3) with at least one negative parameter.
# Plot and analyze its ACF and PACF functions - are there any clear patterns?
# Verify stationarity of the process with the ADF test.




################ 
# Exercise # 5.2
################
# Generate a NON-stationary process AR(3) with at least one negative parameter.
# Plot and analyze its ACF and PACF functions - are there any clear patterns?
# Verify non-stationarity of the process with the ADF test.





################ 
# Exercise # 5.3
################
# Generate a stationary process MA(4) with at least one negative parameter.
# Plot and analyze its ACF and PACF functions - are there any clear patterns?
# Verify stationarity of the process with the ADF test.




################ 
# Exercise # 5.4
################
# Generate a stationary process ARMA(4,1) with at least one negative parameter.
# Plot and analyze its ACF and PACF functions - are there any clear patterns?
# Verify stationarity of the process with the ADF test.





################ 
# Exercise # 5.5
################
# Generate a NON-stationary process ARMA(4,1) with at least one negative parameter.
# Plot and analyze its ACF and PACF functions - are there any clear patterns?
# Verify non-stationarity of the process with the ADF test.





################ 
# Exercise # 5.6 (***)
################
# Write a function (you may modify df.reg.sim() ) to simulate DF statistics 
# for a random walk with a drift and with a deterministic trend.
# Run the function for 1000 replications of a simulation and summarize the results.



################################################################################
# Exercises 6.			

################################################################################
# Exercise 6.1.
# # Import the data for any other financial asset and calculate 
# the	first differences 




################################################################################
# Exercise 6.2.
# using testdf function test integration level 
# of the series




################################################################################
# Exercise 6.3.
# plot ACF and PACF functions and decide 
# on potential orders of ARIMA model 




################################################################################
# Exercise 6.4.
# estimate selected model and test for autocorrelation
#	of residuals (formal test and correlogram). 




################################################################################
# Exercise 6.5.
# Estimate several alternative models - compare AIC and BIC.
#	Which model(s) is finally selected? 


###############################################################################
# Exercises 7.

# Exercise 7.1.
# Reestimate models arima515_2 and arima.best.AIC (check their parameters) 
# on the shorter sample GSPC.sample, perform forecasting for 8 periods
# and compare the quality of the forecasts also with the above model arima515.
# WHich model is best in forecasting exercise?




# Exercise 7.2.
# Plot forecasts from all 3 models on one graph in different colors
# (do not plot confidence intervals, just mean forecast) - concentrate
# just on last several days to see the forecasts well.




# Exercise 7.3.
# Apply similar forecasting check on the data used in exercises in lab 6
# and two different models (including the one selected as the best in Ex. 6.5).
# Cut last 10 observations aside and perform a forecasting exercise for
# these 10 periods estimateing models on smaller sample) 
# Assess the forecast quality. 
# Is the model best fitting the data also better in forecasting?

