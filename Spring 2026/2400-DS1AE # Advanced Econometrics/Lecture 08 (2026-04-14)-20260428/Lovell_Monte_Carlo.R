
# --------------------------------------------------------------------
# Example 1
# Simple Monte Carlo experiment
# What estimate should we get?
# --------------------------------------------------------------------

# specification
N.iter = 1000
N = 1000
beta0 = 1
beta1 = 2
beta1.hat.vec = rep(NA, times=N.iter)


# Monte Carlo Loop
for(iter in 1:N.iter) {
  x = rnorm(n=N, mean=10, sd=1)
  y = beta0 + beta1*x + rnorm(n=N, mean=0, sd=1)
  model.iter = lm(y~x)
  beta1.hat.vec[iter] = model.iter$coefficients[2]
  rm(x,y)
}

hist(beta1.hat.vec)


# --------------------------------------------------------------------
# Example 2
# What pvalues should we get?
# --------------------------------------------------------------------

library("car")

# specification
N.iter = 1000
N = 1000
beta0 = 1
beta1 = 2
beta1.pvalues = rep(NA, times=N.iter)

# Monte Carlo Loop
for(iter in 1:N.iter) {
  x = rnorm(n=N, mean=10, sd=1)
  y = beta0 + beta1*x + rnorm(n=N, mean=0, sd=1)
  model.iter = lm(y~x)
  verif = linearHypothesis(model.iter, c("x=2"))
  beta1.pvalues[iter] = verif$`Pr(>F)`[2]
  rm(x,y)
}

hist(beta1.pvalues)
# Does it look as it should?

# How many rejections do we have?
mean(beta1.pvalues<0.05)


# --------------------------------------------------------------------
# Example 3
# A model with two independent variables
# H0: x=2 and z=3
# --------------------------------------------------------------------

library("car")

# specification
N.iter = 1000
N = 1000
beta0 = 1
beta1 = 2
beta2 = 3
H0.pvalues = rep(NA, times=N.iter)

# Monte Carlo Loop
for(iter in 1:N.iter) {
  x = rnorm(n=N, mean=10, sd=1)
  z = rpois(n=N, lambda=5)
  y = beta0 + beta1*x + beta2*z + rnorm(n=N, mean=0, sd=1)
  model.iter = lm(y~x+z)
  verif = linearHypothesis(model.iter, c("x=2", "z=3"))
  H0.pvalues[iter] = verif$`Pr(>F)`[2]
  rm(x,y)
}

hist(H0.pvalues)
# How many rejections do we have?
mean(H0.pvalues<0.05)


# --------------------------------------------------------------------
# Example 4
# A model with two independent variables
# H0: x=2 and z=3
# but now we will use simple hypothesis testing
# --------------------------------------------------------------------

library("car")

# specification
N.iter = 1000
N = 1000
beta0 = 1
beta1 = 2
beta2 = 3
if.rejected = rep(NA, times=N.iter)

# Monte Carlo Loop
for(iter in 1:N.iter) {
  x = rnorm(n=N, mean=10, sd=1)
  z = rpois(n=N, lambda=5)
  y = beta0 + beta1*x + beta2*z + rnorm(n=N, mean=0, sd=1)
  model.iter = lm(y~x+z)
  verif.x = linearHypothesis(model.iter, c("x=2"))
  verif.z = linearHypothesis(model.iter, c("z=3"))
  if.rejected[iter] = (verif.x$`Pr(>F)`[2]<0.05 | verif.z$`Pr(>F)`[2]<0.05)
  rm(x,y,z)
}

table(if.rejected)
# How many rejections do we have?
mean(if.rejected==1)


# --------------------------------------------------------------------
# Example 5
# A model with two independent variables
# H0: x=2 and z=3
# but now we will use simple hypothesis testing
# with Bonferroni correction
# --------------------------------------------------------------------



# --------------------------------------------------------------------
# Example 6
# A model with two independent variables
# H0: x=2 and z=3
# but now we will use simple hypothesis testing
# with alpha splitting
# the first 0.02 and the second 0.03
# --------------------------------------------------------------------

