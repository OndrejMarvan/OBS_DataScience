########################################################
# GARCH models
################################################################################


# install new and load needed libraries
install.packages("tseries")
install.packages("car")
install.packages("FinTS")
install.packages("fGarch")

library(xts)
library(fBasics) # e.g. basicStats()
library(tseries)# e.g. jarque.bera.test()
library(car) # e.g. durbinWatsonTest()
library(FinTS) # e.g. ArchTest()
library(fGarch) # e.g. garchFit()
library(quantmod) # e.g. getSymbol()

# lets load additional function prepared by the lecturer
# to easily compare ICs for GARCH models

source("function_compareICs.GARCH.R")

###################
# stylized facts      
###################

# lets import the data with prices of SP500
# directly from Yahoo finance
# by the getSymbols() function from quantmod
# we need to know a correct ticker
# for world indices check:
# https://finance.yahoo.com/world-indices
# ^GSPC for S&P500 index

getSymbols("^GSPC",             # ticker
           from = "1970-01-01", # starting date
           to = "2017-05-09")   # end date

head(GSPC)
tail(GSPC)

# lets keep just the close price (Adjusted)
# as a new object SP500

SP500 <- GSPC[,6]

# and change its name to SP500
names(SP500) <- "SP500"

# lets add log-returns to the data
SP500$r <- diff.xts(log(SP500$SP500))

# lets limit our data to days since the beginning of 2000
SP500 <- SP500["2000/",] 

# lets plot the close price
plot(SP500$SP500, main = "Daily close price of SP500")

# ... and it's log-returns
plot(SP500$r, main = "Log-returns of SP500")
abline(h = 0, col = "gray", lty = 2)

# lets also plot the ACF function of log-returns
acf(SP500$r, lag.max = 36, 
    na.action = na.pass,
    ylim = c(-0.1,0.1), # we rescale the vertical axis
    col = "darkblue", lwd = 7, 
    main = "ACF of log-returns of SP500")

# this indicates some autoregressive/MA relations among returns
# which can be used to build an ARIMA model

# and do the same for the SQUARED log-returns
acf(SP500$r^2, lag.max = 36, 
    na.action = na.pass,
    ylim = c(0,0.5), # we rescale the vertical axis
    col = "darkblue", lwd = 7, 
    main = "ACF of SQUARED log-returns of SP500")

# this in turn indicates some autoregressive relations 
# among SQUARED returns (their variance!) which 
# can be used to build a (G)ARCH model

# Do log-returns follow a normal distribution?

basicStats(SP500$r)

# what about skewness and kurtosis?

# Let's also examine:
# *) Jarque-Bera statistic
jarque.bera.test(SP500$r)

# null about normality strongly rejected

# *) Durbin-Watson statistic
# the durbinWatsonTest() function requires 
# the linear model as an argument
# (it checks autocorrelation of residuals from a regression)

# lets simulate a model with just a constant term
# in such a case distribution of residuals is the same as
# the distribution of the dependent variable

# the function works long on xts object
# lets convert our data to pure numeric vector
# by the coredfata() function

durbinWatsonTest(lm(coredata(SP500$r) ~ 1),
                 max.lag = 5) # lets check autocorrelation up to order 5

# lack of autocorrelation in returns strongly rejected 
# for lag 1,2 and 5 !!!

# *) ARCH effects among log-returns

ArchTest(SP500$r,  # here we use a vector of returns as input
         lags = 5) # and maximum order of ARCH effect

# null about lack of ARCH effects strongly rejected!

# we can also apply a DW test for squared returns
durbinWatsonTest(lm(as.numeric(SP500$r^2) ~ 1),
                 max.lag = 5) # lets check first 5 orders

# here ALL lags significant !!!



################################################
# Choosing the proper order of GARCH(q, p) model 
################################################


# ARCH(1)

k.arch1 <- garchFit(~garch(1, 0), 
                    # formula describing the mean and variance equation 
                    # of the ARMA-GARCH - we assume that returns
                    # follow an ARCH(1) process
                    data = SP500$r,
                    # conditional distribution of errors
                    cond.dist = "norm", 
                    # if we don't want to see the history of iterations
                    trace = FALSE) 

# summary of results and some diagnostic tests
summary(k.arch1)

# mu - constant term in the mean equation
# omega - constant term in the variance equation
# alpha1 - arch1 parameter in the variance equation

# The intercept in the mean equation of the model above 
# is not significant at 5% level so we can drop it.

k.arch1 <- garchFit(~garch(1, 0), 
                    data = SP500$r, 
                    # remove intercept term in the mean equation
                    include.mean = F, 
                    # conditional distribution of errors
                    cond.dist = "norm",
                    trace = FALSE)

# summary of results and some diagnostic tests
summary(k.arch1)

# Let's examine squares of standardized residuals.

# we can automatically plot several parts of results

plot(k.arch1)

# 10: ACF of Standardized Residuals,
# 11: ACF of Squared Standardized Residuals; 
# 2: Conditional SD
# to quit press ESC - remember to QUIT before you continue !!!

# squared residuals still have significant ACF for lags: 2-10...


# lets try if ARCH(5) is enough to catch these phenomenon

k.arch5 <- garchFit(~garch(5, 0),
                    data = SP500$r,
                    include.mean = F,
                    cond.dist = "norm", 
                    trace = FALSE) 

summary(k.arch5)

# all parameters are significant
# Ljung-box tests for R and R^2 show 
# there is still autocorrelation 

# lets plot the ACF of standardized residuals
# and standardized squared residuals (plots 10, 11)
# ESC to exit

plot(k.arch5)


# lags nr 3-5, 8, 10 in ACF for squared residuals 
# seem to be still significant

# lets estimate ARCH(10) model

k.arch10 <- garchFit(~garch(10, 0),
                     data = SP500$r,
                     include.mean = F,
                     cond.dist = "norm", 
                     trace = FALSE) 

summary(k.arch10)


# again all parameters are significant at 5% level
# Ljung-box test for R^2 shows there is no more
# autocorrelation between the current and past 
# standardized SQUARED residuals (variance)

# lets plot the ACF of standardized residuals
# and standardized squared residuals (plots 10, 11)
# ESC to exit

plot(k.arch10)

# looks like no further extension of
# the variance equation is needed.
# however, one can consider adding some 
# AR part in the mean equation


# lets compare it with GARCH(1,1)

k.garch11 <- garchFit(~garch(1, 1),
                      data = SP500$r,
                      include.mean = F,
                      cond.dist = "norm", 
                      trace = FALSE) 

summary(k.garch11)

# all parameters significant
# Ljung-box test for R^2 does not show autocorrelation 
# at 5% level between the current and past
# standardized squared residuals (variance) !!!
# (but p-values are just above 5%)

# lets plot the ACF of standardized residuals
# and standardized squared residuals (plots 10, 11)
# ESC to exit

plot(k.garch11)

# ACF for R^2 of order 2 seems to be significant

# lets check higher order GARCH(2,1)

k.garch21 <- garchFit(~garch(2,1),
                      data = SP500$r,
                      include.mean = F,
                      cond.dist = "norm",
                      trace = F)

summary(k.garch21)

# all parameters significant
# Ljung-box test for R^2 shows there is 
# no more autocorrelation between the current
# and past standardized squared residuals (variance)
# (p-values are much larger now)

# lets plot the ACF of standardized residuals
# and standardized squared residuals (plots 10, 11)
# ESC to exit

plot(k.garch21)

# variance equation seems to be complete, but 
# ACF plot of residuals indicates we may still 
# improve the model by adding AR components 
# in the mean equation


# lets add AR5 model into the mean equation
k.ar5garch21 <- garchFit(~arma(5, 0) + garch(2, 1),
                         data = SP500$r,
                         include.mean = F,
                         cond.dist = "norm",
                         trace = F)

summary(k.ar5garch21)

# only ar1 and ar5 parameters are significant
# Ljung-box test for R^2 shows there is 
# no more autocorrelation between the current 
# and past standardized squared residuals (variance)
# similarly there is no autocorrelation 
# between R after adding AR part now !!!

# lets plot the ACF of standardized residuals
# and standardized squared residuals (plots 10, 11)
# ESC to exit

plot(k.ar5garch21)

# both ACF figures show no significant lags

# Which model has most favourable 
# information criteria AIC and SBC?

# function written by the lecturer
# requires a list of names of EXISTING 
# (g)arch model results as an argument

compare.ICs.GARCH(c("k.arch1", "k.arch5", "k.arch10", 
                    "k.garch11", "k.garch21", "k.ar5garch21"))

# most criteria give the same result:
# every next model is better than the previous one 
# and finally AR(5)-GARCH(2,1) is the best
# (only BIC/SBC indicates differently)

# Let's assume that the final model is AR(5)-GARCH(2,1) 
str(k.ar5garch21)

# Do standardized residuals follow normal distribution?
# standardized residuals are residuals 
# divided by conditional stdev

stdres <- k.ar5garch21@residuals/sqrt(k.ar5garch21@h.t)

# Jarque-Bera test
jarque.bera.test(stdres)

# normality strongly rejected!

# Durbin Watson test
durbinWatsonTest(lm(stdres~1),
                 max.lag = 5) # lets check first 5 orders

# lack of autocorrelation cannot be rejected for any lag

# ARCH effects among standardized residuals
ArchTest(stdres, lags = 5)

# the lack of further ARCH effects cannot be rejected



################################################################################
# Exercises 11

# Perform similar analysis for any other time series 
# downloaded from Yahoo finance

################################################################################
# Exercise 11.1
# Get the data for a selected asset. Compute log-returns.
# Present the data on the plot




################################################################################
# Exercise 11.2
# Check normality of returns using a formal test. 
# Test for autocorrelation of returns and
# squared returns of the analyzed asset.




################################################################################
# Exercise 11.3
# Find the best GARCH(q,p) model (possibly with AR 
# or/and MA component added).
# What criteria did you use for model selection?
# Does the model pass all the diagnostic checks?




################################################################################
# Exercise 11.4
# For a finally selected model check if its standardized residuals
# follow a normal distribution and are not autocorrelated.




# install new and load needed libraries
install.packages("rugarch")

# load an additional needed library
library(rugarch) # e.g. ugarchfit()

# !!! Introduction to the rugarch package 
# and a detailed description of all models available in it
# http://cran.r-project.org/web/packages/rugarch/vignettes/Introduction_to_the_rugarch_package.pdf


# lets load additional functions prepared by the lecturer
# to easily compare ICs for GARCH models

source("function_compareICs.GARCH.R")
source("function_compare.ICs.ugarchfit.R")


# lets do the diagnostics of the final GARCH model
# (part copied from labs 11)

# we finally selected AR(5)-GARCH(2,1) 

compare.ICs.GARCH(c("k.arch1", "k.arch5", "k.arch10", 
                    "k.garch11", "k.garch21", "k.ar5garch21"))

# Let's check its structure
str(k.ar5garch21)

# Do standardized residuals follow normal distribution?
# standardized residuals are residuals 
# divided by conditional stdev

stdres <- k.ar5garch21@residuals/sqrt(k.ar5garch21@h.t)
# or 
stdres <- k.ar5garch21@residuals/k.ar5garch21@sigma.t

# Jarque-Bera test
jarque.bera.test(stdres)

# normality strongly rejected!

# Durbin Watson test
durbinWatsonTest(lm(stdres~1),
                 max.lag = 5) # lets check first 5 orders

# lack of autocorrelation cannot be rejected for any lag

# ARCH effects among standardized residuals
ArchTest(stdres, lags = 5)

# the lack of further ARCH effects cannot be rejected


############################################################
# lets move to testing GARCH extensions

############################################################
# The EGARCH model

# Let's examine whether conditional variance reacts asymmetrically 
# to the news arriving to the market.
# Below estimation of the AR(5)-EGARCH(2,1) model.

# ugarchfit() from rugarch package
# - more flexible than garchFit - allows also for extensions

# here we first define a model specification
spec <- ugarchspec(# variance equation
  variance.model = list(model = "eGARCH", 
                        garchOrder = c(2,1)),
  # sGARCH would stand for standard GARCH model
  # mean equation - lets use AR(5) as previously
  mean.model = list(armaOrder = c(5,0), 
                    include.mean = F), 
  # assumed distribution of errors
  distribution.model = "norm")

# function ugarchfit() doesn't accept missing values
k.ar5egarch21 <- ugarchfit(spec = spec, 
                           data = na.omit(SP500$r))

k.ar5egarch21

# ar2 to ar5 are not statistically significant !!!
# lets remove them and estimate a simpler model AR(1)-EGARCH(2,1)

spec <- ugarchspec(# variance equation
  variance.model = list(model = "eGARCH", 
                        garchOrder = c(2,1)),
  # sGARCH would stand for standard GARCH model
  # mean equation - lets use AR(1) as previously
  mean.model = list(armaOrder = c(1,0), 
                    include.mean = F), 
  # assumed distribution of errors
  distribution.model = "norm")

# function ugarchfit() doesn't accept missing values
k.ar1egarch21 <- ugarchfit(spec = spec, 
                           data = na.omit(SP500$r))

k.ar1egarch21

# now all the parameters are statistically significant

# coefficient alpha1 is the assymetry term 
# of EGARCH model.
# It is negative and significant, 
# so the asymmetry is found!

# no further autocorrelation in R and R^2, 
# no further ARCH effects

# Nyblom stability test verifies the null 
# that all parameters or each parameter 
# separately are stable over time 
# (no structural breaks in the model)
# if test statistic > critical value => null is rejected

# Sign Bias Test - verifies the null hypothesis
# if there is still some assymetric reaction
# of variance of residuals to shocks
# (if null not rejected - assymetry caught correctly
# in the estimated model)

plot(k.ar1egarch21)

# 3:  Conditional SD (vs |returns|)
# 11: ACF of Squared Standardized Residuals 
# 12: News-Impact curve
# ESC to exit


############################################################
# The GARCH-in-Mean model    

# lets first define a model specification
spec <- ugarchspec(# variance equation
  variance.model = list(model = "sGARCH", 
                        # sGARCH = standard GARCH
                        garchOrder = c(2,1)),
  # mean equation - lets turn on the intercept term
  mean.model = list(armaOrder = c(1,0), 
                    include.mean = F,
                    # we add an element to the mean equation,
                    # which can be either stdev (archpow 1)
                    # or var (archpow=2)
                    archm = T, archpow = 1), 
  # assumed distribution of errors
  distribution.model = "norm")

# function doesn't accept missing values
k.ar1garchm21 <- ugarchfit(spec = spec, 
                           data = na.omit(SP500$r))

k.ar1garchm21

# Is the estimate of the archm parameter significantly positive?
# YES, it is (also when robust standard errors are applied),
# so we DO find the proof for risk premium in the model


############################################################
# The GARCH-t model          

# Let's see whether conditional distribution of
# the error term can be better described 
# by the t-Student distribution.

# lets first define a model specification
spec <- ugarchspec(# variance equation
  variance.model = list(model = "sGARCH", 
                        garchOrder = c(2,1)),
  # mean equation
  mean.model = list(armaOrder = c(1,0), 
                    include.mean = F), 
  # assumed distribution of errors
  distribution.model = "std") # std = t-Student

# function doesn't accept missing values
k.ar1garcht21 <- ugarchfit(spec = spec, 
                           data = na.omit(SP500$r))

k.ar1garcht21

# shape is the number of degrees of freedom 
# for the t-Student distribution.
# In our case this equals to 7.20.

# However, when robust std errors are applied
# the model is not significant at all

# One more thing!
# the variance equation seems to be INcomplete 
# (see Ljung-Box Test on Standardized Squared Residuals!)
# on the other hand ARCH tests do NOT show 
# any problem with the variance equation

plot(k.ar1garcht21)

# plot 12 shows significance of 1st lag!

# It is not clear if t distribution is better
# than Normal distribution

# lets compare ICs later


# all above options can be combined !!!

############################################################
# The EGARCH in mean-t model          

# lets first define a model specification
spec <- ugarchspec(# variance equation
  variance.model = list(model = "eGARCH", 
                        garchOrder = c(2,1)),
  # mean equation
  mean.model = list(armaOrder = c(1,0), 
                    include.mean = F,
                    archm = T, archpow = 1), 
  # assumed distribution of errors
  distribution.model = "std") # std = t-Student

# function doesn't accept missing values
k.ar1egarchmt21 <- ugarchfit(spec = spec, 
                             data = na.omit(SP500$r))

k.ar1egarchmt21

# looks better!
# alpha1, archm and shape are significant
# and have expected signs !!!

# no further extensions of the mean
# and variance equations are needed


# lets remind the results the AR(5)-GARCH(2,1) 
# model estimated last time
# (reestimate it with the use of ugarchfit)

spec <- ugarchspec(# variance equation
  variance.model = list(model = "sGARCH", 
                        garchOrder = c(2,1)),
  mean.model = list(armaOrder = c(5,0), 
                    include.mean = F), 
  distribution.model = "norm")

# function doesn't accept missing values
k.ar5garch21 <- ugarchfit(spec = spec, 
                          data = na.omit(SP500$r))

k.ar5garch21

# here we can fix the ar2-ar4 parameters at 0 !

spec <- ugarchspec(# variance equation
  variance.model = list(model = "sGARCH", 
                        garchOrder = c(2,1)),
  mean.model = list(armaOrder = c(5,0), 
                    include.mean = F), 
  distribution.model = "norm",
  # you need to use correct parameter names
  fixed.pars = list(ar2=0, ar3=0, ar4=0))

k.ar5garch21_2 <- ugarchfit(spec = spec, 
                            data = na.omit(SP500$r))

k.ar5garch21_2


# lets compare information criteria for all models

compare.ICs.ugarchfit(c("k.ar5garch21",
                        "k.ar5garch21_2",
                        "k.ar5egarch21",
                        "k.ar1egarch21", 
                        "k.ar1garchm21", 
                        "k.ar1garcht21", 
                        "k.ar1egarchmt21"))

# all criteria indicate that AR-EGARCH-in-mean-t
# is the best model here

# prediction based on a GARCH-type model

r.forecast <- ugarchforecast(k.ar1egarchmt21,
                             n.ahead = 5)

r.forecast

str(r.forecast)

r.forecast@forecast$seriesFor
r.forecast@forecast$sigmaFor

# how to turn forecasted returns into a forecasted price?
# r = d(ln(P)) = ln(P_{t}/P_{t-1})

# therefore
# P_{t} = P_{t-1} * e**r

SP500.forecast <- rep(NA, 5)

# ofrecast for the first period refers to
# the last real observation

SP500.forecast[1] <- tail(SP500$SP500,1) * exp(r.forecast@forecast$seriesFor[1])

for (i in 2:5)
  SP500.forecast[i] <- SP500.forecast[i-1] * exp(r.forecast@forecast$seriesFor[i])

SP500.forecast


############################################################
# Exercises 12
# Download a selected time series from yahoo finance
# and calculate returns for a selected period

############################################################
# Exercise 12.1
# Examine the existence of:
#  a) asymmetry in the conditional variance function (EGARCH),
#  b) risk premium in the log-residuals (GARCH-m),
#  c) t-Student distribution as an alternative to normal distribution
#     of the error term (GARCH-t)




############################################################
# Exercise 12.2
# Find out which model is the best and use it to
# forecast a mean of the series for the next 10 periods.



