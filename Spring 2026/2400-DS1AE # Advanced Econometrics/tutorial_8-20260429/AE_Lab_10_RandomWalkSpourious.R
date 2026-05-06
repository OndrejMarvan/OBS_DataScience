###########################################################################
#	Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#   Materials based on dr Piotr Wojcik Time Series Analysis for QF        #
#                                                                         #
#     Lab 10: Random walks & Newbold - Davis Experiment                   #
#                                                                         #
###########################################################################

# lets start with defining a path to the current working directory

# lets install needed packages

install.packages("lmtest")  # e.g. for dwtest() function
install.packages("fBasics") # e.g. for basicStats() function

library(lmtest)
library(fBasics)

Sys.setenv(LANG = "en")
options(scipen=100)

################################################
# 1. Random walk simulation,                
#    stochastic and deterministic trends,    
#    examples of non-stationary time series 
################################################


################ 
# Example #1  
################


####################################################################
# Discrete random walk 

# we create an vector drw of 0s
# function rep() replicates the first argument
# as many times as provided by the second argument

# We make a vector of 1000 zeros
drw <- rep(0,     # value
           1000)  # number of repetitions
# and frequency of unique values
table(drw)

# lets check the class of the resulting object
class(drw)

# its length
length(drw)

# lets list first 10 observations
head(drw, 10)

# runif() generates pseudo-random variable from a uniform distribution 
#  min and max define the interval [0,1]

# random numbers between 0 and 1
z <- runif(1000, min = 0, max = 1)
table(z)

# lets see the plot of z
plot(z, type = "l", main = "Uniform White Noise (0,1)")

# and its histogram
hist(z, main = "Histogram of Uniform Noise")

# lets convert it to values -1 or +1
# with the use of the ifelse() function
# syntax: ifelse(condition, what if T, what if F)
# convert to coin flip: heads=+1, tails=-1
z1 <- ifelse(z < 0.5,  # condition
             1,        # value returned if condition is true
             -1)       # value returned if condition is false
z1
table(z1)
# y[t] = y[t-1]+disturbance

# now we use a loop to change the values of drw
# based on the generated random variable z1

# we could fdo it step by step, e.g.
drw[2] <- drw[1] + z1[2]
drw[3] <- drw[2] + z1[3]
drw[4] <- drw[3] + z1[4]

# etc...

# a loop is much easier for the repeated task.
# We need to define a sequence of values
# and a general command which uses the index
# to generate a different particular command 
# in each iteration
# in our case the general command is:
#	drw[i] <- drw[i-1] + z1[i]

# we start from the 2nd value as the formula is based on 
# the previous value (and there is no previous for the 1st one)

# here for loop defines iteration number i 
# which changes from 2 to 1000

# The for-loop just automates this 1000 times. 
# Non-stationary because where you end up depends on how long you've 
# been walking — variance = t.
# We make a vector of 1000 zeros

drw <- rep(0,     # value
           1000)  # number of repetitions

for(i in 2:1000){
  drw[i] <- drw[i-1] + z1[i]
} 

# lets list first 10 observations
head(drw, 10)

table(drw)
# not 0s any more

# lets see it on the plot
plot(drw,       # what is ploted - a numeric vector/array
	type = "l",	  # type of the plot (l=line)
	col = "blue", # color of the line
	lwd = 2,      # line width - default=1
	main = "Discrete random walk")

# This is a discrete random walk
# Starts around 0
# Moves up and down randomly
# But overall it wanders (drifts) over time
# 
# No constant mean
# Early values: near 0–10
# Later values: around 20–50
# The “average level” is changing
# 
# Wandering / drifting behavior
# Goes up (0 → 50)
# Then down (50 → 20)
# Then up again
# No fixed level it returns to
# This is a unit root process
# 
# 
# Shocks are permanent
# When it jumps up, it stays up
# It doesn’t “come back” to a mean
# Each random shock accumulates
# This is the BIG reason it's non-stationary

# Variance increases over time
# Early part: small fluctuations
# Later part: bigger swings
# Uncertainty grows over time
# Another sign of non-stationarity

# gives you back the original noise (z1)
plot(diff(drw))
# Values don’t increase over time
# No upward or downward movement
# Mean is constant
# Stationary

d <- rep(0, length(drw) - 1)

# compute differences
for(i in 2:length(drw)){
  d[i-1] <- drw[i] - drw[i-1]
}
plot(d)

all.equal(d, diff(drw))

####################################################################	
# Continuous random walk 

# again we start with a vector of 0s
crw <- rep(0, 1000)
plot(crw)
# lets generate a random disturbance based on U[-sqrt(3),sqrt(3)]
e <- (-sqrt(3) + 2 * sqrt(3) * runif(1000, min = 0, max = 1))
e = runif(1000, min=-sqrt(3), max=sqrt(3))
e
# and use it to change the values of crw series
for(i in 2:1000){
  crw[i] <- crw[i-1] + e[i]
}
	
# plot of continuous random walk 
plot(crw, type = "l", col = "blue", lwd = 2,
     main = "Continuous random walk")


z <- runif(1000, min = 0, max = 1)
z1 <- ifelse(z < 0.5,  # condition
             1,        # value returned if condition is true
             -1)       # value returned if condition is false

for(i in 2:1000) {
  drw[i] <- drw[i-1] + z1[i]
}
  

# lets see it on the plot
plot(drw,       # what is ploted - a numeric vector/array
     type = "l",	  # type of the plot (l=line)
     col = "blue", # color of the line
     lwd = 2,      # line width - default=1
     main = "Discrete random walk")


####################################################################	
# Continuous random walk 

# again we start with a vector of 0s
crw <- rep(0, 1000)
table(crw)
# lets generate a random disturbance based on U[-sqrt(3),sqrt(3)]
e <- (-sqrt(3) + 2 * sqrt(3) * runif(1000, min = 0, max = 1))
e = runif(1000, min=-sqrt(3), max=sqrt(3))

# and use it to change the values of crw series
for(i in 2:1000){
  crw[i] <- crw[i-1] + e[i]
}

table(crw)  

# plot of continuous random walk 
plot(crw, type = "l", col = "blue", lwd = 2,
     main = "Continuous random walk")

# INTERPRETATION:
# The plot shows a continuous random walk, where each value is the sum of the previous value
# and a random shock drawn from a uniform distribution.
#
# Key properties:
# - The series shows clear drifting behavior (no constant mean)
# - It does not return to a fixed level → no mean reversion
# - Shocks have permanent effects (each shock accumulates)
# - Variability increases over time (larger swings later)
#
# Conclusion:
# → The series is NON-STATIONARY
# → It contains a UNIT ROOT (random walk behavior)
#
# Implication:
# - Cannot be used directly in standard models
# - Needs differencing to become stationary
#
# After differencing:
# diff(crw) will produce stationary white noise

plot(diff(crw), type = "l", col = "blue", lwd = 2,
     main = "")
# 1. No trend
# The series fluctuates around 0
# No upward or downward drift
# Mean is constant
# Stationary
# 2. Constant variance
# Spread looks similar across time
# No “growing swings” like before
####################################################################
# Continuous normal random walk 
cnrw <- rep(0, 1000)

# now the random disturbance comes from a N(0,1) distribution
e <- rnorm(1000, mean = 0, sd = 1)

hist(e)

table(cnrw)

# AutoRegressive model of order 1
# Means:The current value depends on 1 past value
# AR(1) model: y_t = φ * y_{t-1} + ε_t
#
# y_t     = value today
# y_{t-1} = value yesterday
# ε_t     = random noise (shock)
# φ       = how strongly yesterday affects today

for(i in 2:1000){
  cnrw[i] <- 1*cnrw[i-1] + e[i]
}

# plot of continuous normal random walk 
plot(cnrw, type = "l", 
     col = "blue", lwd = 2, 
     main = "Continuous normal random walk")

# 1. Strong up–down switching
# The series keeps reversing direction
# Up → down → up → down
# Because of the −1 coefficient
# each value flips sign of the previous one
# 
# 2. No clear trend
# No steady upward or downward movement
# It doesn’t drift like a random walk
# Mean is roughly stable (around 0)

plot(diff(cnrw), type = "l", 
     col = "blue", lwd = 2)


########################################################
# Examples of stationary processes
########################################################

# AR(1) = AutoRegressive model using 1 past value

# y[t] = alpha * y[t-1] + e[t]
# translation:
# today = (some part of yesterday) + random noise

set.seed(12345)

T = 1000                      # how many time points we generate
e = rnorm(n=T, mean=0, sd=1)  # random noise (completely unpredictable)
y = rep(0, times=T)           # start with all zeros

alpha = 0.9                   # how much yesterday matters (0.9 = a lot)

for(t in 2:T) {
  y[t] = alpha * y[t-1] + e[t]  
  # take 90% of yesterday
  # then add random shock
}

plot(y, type="l", main="AR(1) with alpha = 0.9")

# -----------------------------
# SUPER SIMPLE INTUITION
# -----------------------------

# Imagine:
# - yesterday influences today
# - but not fully (only 90%)
# - plus some random surprise each day

# So:
# - the series "remembers" the past
# - but doesn't drift away forever
# - it wiggles around a level

# -----------------------------
# WHAT alpha DOES (VERY IMPORTANT)
# -----------------------------

# alpha = 0
# → no memory → just random noise

# alpha = 0.9
# → strong memory → smooth, persistent series (what you see)

# alpha = 1
# → random walk → keeps drifting away → NON-STATIONARY

# alpha > 1
# → explodes → values go to infinity → VERY BAD

# alpha < 0
# → zig-zag (up-down-up-down behavior)

# -----------------------------
# ONE LINE TO REMEMBER
# -----------------------------

# alpha tells you:
# "how much yesterday affects today"

set.seed(12345)

T <- 1000
e <- rnorm(T)

par(mfrow = c(2, 2))

alphas <- c(0, 0.5, 0.9, 1)

for(a in alphas){
  
  y <- rep(0, T)
  
  for(t in 2:T){
    y[t] <- a * y[t-1] + e[t]
  }
  
  # choose title based on alpha
  title_text <- if(a == 0){
    "α = 0 → White noise (no memory)"
  } else if(a == 0.5){
    "α = 0.5 → Weak persistence"
  } else if(a == 0.9){
    "α = 0.9 → Strong persistence"
  } else if(a == 1){
    "α = 1 → Random walk (non-stationary)"
  }
  
  plot(y, type="l",
       main = title_text,
       col = "blue")
}

par(mfrow = c(1, 1))
# The DF Type-I test checks: is alpha = 1?
# H₀ (bad): alpha = 1 → random walk → non-stationary
# H₁ (good): alpha < 1 → stationary
#########################################################################
# ---------------
# Theses were examples of processes analysed in the 
# type-I Dickey-Fuller test

# AR(2)
# y[t] = alpha*y[t-1] + beta*y[t-2] + e
# For higher order auto-regressive processes
# we shouldn't apply the condition |alpha| < 1
# Tab 2 — AR(2): Now today depends on two past values. 
# The danger is that two small pushes together can exceed 1 
# even if each alone looks fine. Alpha=0.4 + Beta=0.5 = 0.9 → ok. 
# Alpha=0.6 + Beta=0.5 = 1.1 → unit root. 
# You can't just check alpha alone anymore.

T = 1000 # number of observations
e = rnorm(n=T, mean=0, sd=1) # disturbance
y = rep(0, times=T) # process
alpha = 0.4 # parameter of the process
beta = 0.5
# This is an AR(2) process Meaning:
# Today depends on yesterday AND the day before
for(t in 3:T) {
  y[t] = alpha*y[t-1] + beta*y[t-2]+ e[t]
}

plot(y, type="l")

# ----------------
# Examples of processes for the type-II Dickey-Fuller test
# We add a constant to the process


set.seed(1234567)
T = 100 # number of observations
e = rnorm(n=T, mean=0, sd=1) # disturbance Random noise (shocks)
y = rep(0, times=T) # process
alpha = 0.5 # parameter of the process Keeps 50% of yesterday
constant = 0.2

for(t in 2:T) {
  # Today = a little push up + part of yesterday + random noise
  y[t] = constant + alpha*y[t-1] + e[t]
}

plot(y, type="l")

# What it shows:
# Values go up and down randomly
# No clear strong upward line
# Looks “wiggly” around some level
# So:It does NOT look strongly trending

# I am removing the linear trend
plot(y-constant*seq(1,T,1), type="l")

# If alpha = 1 and we have a constant in the process, then
# we have a random walk process around a linear trend.
# In other words, this constant accumulates in time to linear trend.


# ----------------
# Examples of processes for the type-III Dickey-Fuller test
# We add a constant and a trend to the process

set.seed(1234567)
T = 1000 # number of observations
e = rnorm(n=T, mean=0, sd=1) # disturbance
y = rep(0, times=T) # process
alpha = 1 # parameter of the process
constant = 0.1
beta = 0.0001

for(t in 2:T) {
  # Today = yesterday + small upward push + trend + noise
  y[t] = constant + beta*t + alpha*y[t-1] + e[t]
  # y[t-1] → random walk part (keeps memory forever)
  # constant = 0.1 → adds a small push every step
  # beta*t → adds a trend (line growing over time)
  # e[t] → random noise
}

plot(y, type="l")

# What you see:
# Strong upward movement
# Very “drifty” and growing
# Gets bigger over time
# Why?
# Because:
# random walk accumulates
# trend (beta*t) keeps increasing
# Double effect = strong growth

# How to remove the linear trend out of trend-stationary variable?
model = lm(y~seq(1,T,1))
summary(model)
y.trend.removed = y - model$coefficients[1] - model$coefficients[2]*seq(1,T,1)
plot(y.trend.removed, type="l")

# The Dickey-Fuller test
# Type-III - drift + linear trend
# alpha = 1 (random walk + drift + linear trend)
# random walk around a quadratic trend

# |alpha|<1, then we have a variable that is stationary around a linear trend
# trend-stationary variable
# the variable is non-stationary

# H0: alpha = 1 - variable is non-stationary
# H1: |alpha|<1 - variable is non-stationary (trend-stationarity)


#####################################################################
# END of Today 23.04.2026
####################################################################
# Spurious regressions - Newbold-Davies experiment              

# Let's create a data set with 1000 realizations 
# of two pairs of variables:
#     1) e1 and e2, independent of each other, 
#        both of them IID and hence stationary
#     2) y and x, independent of each other, 
#        both of them random walks and hence non-stationary

e1 <- rnorm(1000, mean = 0, sd = 1)
e2 <- rnorm(1000, mean = 0, sd = 1)

# lets check their correlation
cor(e1, e2)

# create x and y filled with zero's first
x <- rep(0, 1000)
y <- rep(0, 1000)

# and using e1 and e2 respectively 
# we generate two independent random walks
for(i in 2:1000)
	{ x[i] <- x[i-1] + e1[i]
 	  y[i] <- y[i-1] + e2[i]
}

# lets check their correlation
cor(x, y)

# much stronger

# lets plot both generated pairs
plot(as.zoo(cbind(e1, e2)), main = "Two white noises")

plot(as.zoo(cbind(x, y)), main = "Two random walks")

# Regression of stationary time series 
# model formula in R: dependent ~ independent1 + independent2 + ...
model1 <- lm(e1 ~ e2) 

# lets se its summary
summary(model1)

# results as expected - lack of significance and low R2

# lets check autocorrelation of residuals
dwtest(model1, alternative = "two.sided")

# DW close to 2

# Regression of non-stationary time series 
model2 <- lm(y ~ x)

# lets se its summary
summary(model2)

# strong significance and relatively high R2 !!!

# lets check autocorrelation of residuals
dwtest(model2, alternative = "two.sided")

# DW close to 0, which indicates strong positive 
# autocorrelation in regression residuals

# What would be an interpretion of the above results? 

# Let's repeat the steps above, say, 1000 times 
# We'll to that with the help of two additional functions written by lecturers:
# regression_e1e2() and regression_yx().
# They are defined in an additional file TSA_lab03_functions.R 
# and need to be loaded to memory by the source() function. 

source("AE_Lab_10_functions.R")

# Finally, we can call both functions 
results_e1e2 <- regression_e1e2(1000)
results_yx <- regression_yx(1000)


# We can now display descriptive statistics for results from both regressions
#  (mean value, standard deviation, skewness, kurtosis, 5% percentile) 
#  t - t statistic testing significance of the e2 variable
#  dw - Durbin-Watson statistic testing autocorrelation of residuals
#  sig_t - binary variable: 1 if the regressor is statistically significant at the alpha=5%, 
#                            0 otherwise 

# lets see teh structure of results
head(results_e1e2)

# lets print some summary statistics
basicStats(results_e1e2)

# but in fact we are interested in:
# - mean (row 7)
# - stdev (row 14)

basicStats(results_e1e2)[c(7,14),]

basicStats(results_yx)[c(7,14),]

# lets check the 5th percentile
# (should be around -1.66 if the statistic has t-Student
# distribution as expected)

quantile(results_e1e2$t, 0.05)
quantile(results_yx$t, 0.05)

# What are our conlusions? 


####################################################################
# Exercises 3


# Exercise 3.1
# Create a data set with a time series including 
# a stochastic trend with a drift and plot it.




# Exercise 3.2
# Create a data set with time series including
# a deterministic (linear) trend and plot it.



