
########################################################
# Examples of stationary processes
########################################################

# AR(1) auto-regressive process of order 1

# y[t] = alpha*y[t-1] + e[t]
# stationary if |alpha| < 1

set.seed(12345)
T = 1000 # number of observations
e = rnorm(n=T, mean=0, sd=1) # disturbance
y = rep(0, times=T) # process
alpha = 0.8 # parameter of the process

for(t in 2:T) {
  y[t] = alpha*y[t-1] + e[t]
}

plot(y, type="l")

# AR(p) process
# y[t] = alpha_1*y[t-1]+alpha_2*y[t-2]+...+alpha_p*y[t-p]+e[t]

# If alpha = 1, then we have a random walk process.
# If abs.value of alpha > 1, then process explodes to + or minus infinity
# and it is clear that it is non-stationary

# ---------------
# Theses were examples of processes analysed in the type-I Dickey-Fuller test


# AR(2)
# y[t] = alpha*y[t-1] + beta*y[t-2] + e
# For higher order auto-regressive processes
# we shouldn't apply the condition |alpha| < 1

# ----------------
# Examples of processes for the type-II Dickey-Fuller test
# We add a constant to the process

set.seed(1234567)
T = 1000 # number of observations
e = rnorm(n=T, mean=0, sd=1) # disturbance
y = rep(0, times=T) # process
alpha = 1 # parameter of the process
constant = 0.2

for(t in 2:T) {
  y[t] = constant + alpha*y[t-1] + e[t]
}

plot(y, type="l")

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
alpha = 0.5 # parameter of the process
constant = 0.1
beta = 0.01

for(t in 2:T) {
  y[t] = constant + beta*t + alpha*y[t-1] + e[t]
}

plot(y, type="l")

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