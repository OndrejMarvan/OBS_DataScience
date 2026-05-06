
# ----------------------------------------------
# mean reversing
# ----------------------------------------------

alpha = -0.9
constant = 1
T_in_sample = 1000
T_out_of_sample = 100

# initialisation
y = rep(0, times=T_in_sample+T_out_of_sample)

# process
for(t in 2:T_in_sample) {
  y[t] = constant + alpha*y[t-1] + rnorm(n=1, mean=0, sd=1)
}

# out-of-sample forecasts
for(t in (T_in_sample+1):(T_in_sample+1+T_out_of_sample)) {
  y[t] = constant + alpha*y[t-1]
}

plot(y, type="l")
plot(y[1001:1050], type="l")

# the uncoditional expected value of y
constant/(1-alpha)

