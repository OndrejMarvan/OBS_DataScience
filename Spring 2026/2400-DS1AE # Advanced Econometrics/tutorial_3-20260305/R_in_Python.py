# -*- coding: utf-8 -*-
"""
Created on Sat Jan 18 22:14:29 2025

@author: Hp

Na podstawie:
https://rviews.rstudio.com/2022/05/25/calling-r-from-python-with-rpy2/
https://stackoverflow.com/questions/64181911/call-r-package-data-using-python-with-rpy2
https://rpy2.github.io/doc/v2.9.x/html/introduction.html
https://rpy2.github.io/doc/v3.3.x/html/robjects_rpackages.html
"""

# ---------------- instalacja ----------------
pip install rpy2==3.5.12

import rpy2 as rpy2
print(rpy2.__version__)

import os
os.environ['R_HOME'] = 'C:\\Program Files\\R\\R-4.4.2'
os.environ["PATH"] += os.pathsep + 'C:\\Program Files\\R\\R-4.4.2\\bin\\x64\\'
os.environ["PATH"] += os.pathsep + 'C:\\Program Files\\R\\R-4.4.2\\'
 
import pandas as pd
import rpy2.robjects as robjects
from rpy2.robjects import pandas2ri
from rpy2.robjects.packages import importr, data
# Use importr() to load the utils and base packages, which normally come 
# preinstalled with R.

# Installing and loading R packages with rpy2
# Installing and loading R packages are often the first steps in R scripts. 
# The rpy2 package provides a function rpy2.robjects.packages.importr() that 
# mimics these steps. Run the below, where you’ll also import the function 
# data() for later.

utils = importr('utils')
base = importr('base')
stats = importr('stats')

# ---------------- model regresji ----------------

os.chdir('C:\\Users\\Hp\\WNE\\PNA2\\PNA2_Z13_2024')
diamonds_py = pd.read_csv("diamonds.csv", sep=",")

# let's convert a Python dataset into R dataset
from rpy2.robjects import pandas2ri
pandas2ri.activate()
diamonds_r = pandas2ri.py2rpy_pandasdataframe(diamonds_py)

# let's estimate a regression model using R function
model = stats.lm('price~carat', data=diamonds_r)
print(base.summary(model))

# ---------------- own function ----------------

from rpy2.robjects.packages import SignatureTranslatedAnonymousPackage

string = """
square <- function(x) {
    return(x^2)
}

cube <- function(x) {
    return(x^3)
}
"""

powerpack = SignatureTranslatedAnonymousPackage(string, "powerpack")

res = powerpack.square(3)
print(res)
res = powerpack.cube(2)
print(res)

# ---------------- function from a file ----------------

string = """
rafalwozniak = function() {
  print("rafalwozniak")
}
"""

rw = SignatureTranslatedAnonymousPackage(string, "rw")

rw.rafalwozniak()

string = """
#####################################################################
# NAME: Tom Loughin                                                 #
# DATE: 1-10-13                                                     #
# PURPOSE: Functions to compute Hosmer-Lemeshow, Osius-Rojek, and   #
#     Stukel goodness-of-fit tests                                  #
#                                                                   #
# NOTES:                                                            #
#####################################################################
# Single R file that contains all three goodness-of fit tests


# Adapted from program published by Ken Kleinman as Exmaple 8.8 on the SAS and R blog, sas-and-r.blogspot.ca 
#  Assumes data are aggregated into Explanatory Variable Pattern form.

HLTest = function(obj, g) {
 # first, check to see if we fed in the right kind of object
 stopifnot(family(obj)$family == "binomial" && family(obj)$link == "logit")
 y = obj$model[[1]]
 trials = rep(1, times = nrow(obj$model))
 if(any(colnames(obj$model) == "(weights)")) 
  trials <- obj$model[[ncol(obj$model)]]
 # the double bracket (above) gets the index of items within an object
 if (is.factor(y)) 
  y = as.numeric(y) == 2  # Converts 1-2 factor levels to logical 0/1 values
 yhat = obj$fitted.values 
 interval = cut(yhat, quantile(yhat, 0:g/g), include.lowest = TRUE)  # Creates factor with levels 1,2,...,g
 Y1 <- trials*y
 Y0 <- trials - Y1
 Y1hat <- trials*yhat
 Y0hat <- trials - Y1hat
 obs = xtabs(formula = cbind(Y0, Y1) ~ interval)
 expect = xtabs(formula = cbind(Y0hat, Y1hat) ~ interval)
 if (any(expect < 5))
  warning("Some expected counts are less than 5. Use smaller number of groups")
 pear <- (obs - expect)/sqrt(expect)
 chisq = sum(pear^2)
 P = 1 - pchisq(chisq, g - 2)
 # by returning an object of class "htest", the function will perform like the 
 # built-in hypothesis tests
 return(structure(list(
  method = c(paste("Hosmer and Lemeshow goodness-of-fit test with", g, "bins", sep = " ")),
  data.name = deparse(substitute(obj)),
  statistic = c(X2 = chisq),
  parameter = c(df = g-2),
  p.value = P,
  pear.resid = pear,
  expect = expect,
  observed = obs
 ), class = 'htest'))
}

# Osius-Rojek test
# Based on description in Hosmer and Lemeshow (2000) p. 153.
# Assumes data are aggregated into Explanatory Variable Pattern form.

ortest = function(obj) {
 # first, check to see if we fed in the right kind of object
 stopifnot(family(obj)$family == "binomial" && family(obj)$link == "logit")
 mf <- obj$model
 trials = rep(1, times = nrow(mf))
 if(any(colnames(mf) == "(weights)")) 
  trials <- mf[[ncol(mf)]]
 prop = mf[[1]]
 # the double bracket (above) gets the index of items within an object
 if (is.factor(prop)) 
  prop = as.numeric(prop) == 2  # Converts 1-2 factor levels to logical 0/1 values
 pi.hat = obj$fitted.values 
 y <- trials*prop
 yhat <- trials*pi.hat
 nu <- yhat*(1-pi.hat)
 pearson <- sum((y - yhat)^2/nu)
 c = (1 - 2*pi.hat)/nu
 exclude <- c(1,which(colnames(mf) == "(weights)"))
 vars <- data.frame(c,mf[,-exclude]) 
 wlr <- lm(formula = c ~ ., weights = nu, data = vars)
 rss <- sum(nu*residuals(wlr)^2 )
 J <- nrow(mf)
 A <- 2*(J - sum(1/trials))
 z <- (pearson - (J - ncol(vars) - 1))/sqrt(A + rss)
 p.value <- 2*(1 - pnorm(abs(z)))
 cat("z = ", z, "with p-value = ", p.value, "\n")
}

# Stukel Test
# Based on description in Hosmer and Lemeshow (2000) p. 155.
# Assumes data are aggregated into Explanatory Variable Pattern form.

stukeltest = function(obj) {
 # first, check to see if we fed in the right kind of object
 stopifnot(family(obj)$family == "binomial" && family(obj)$link == "logit")
 high.prob <- (obj$fitted.values >= 0.5) 
 logit2 <- obj$linear.predictors^2
 z1 = 0.5*logit2*high.prob
 z2 = 0.5*logit2*(1-high.prob)
 mf <- obj$model
 trials = rep(1, times = nrow(mf))
 if(any(colnames(mf) == "(weights)")) 
  trials <- mf[[ncol(mf)]]
 prop = mf[[1]]
 # the double bracket (above) gets the index of items within an object
 if (is.factor(prop)) 
  prop = (as.numeric(prop) == 2)  # Converts 1-2 factor levels to logical 0/1 values
 pi.hat = obj$fitted.values 
 y <- trials*prop
 exclude <- which(colnames(mf) == "(weights)")
 vars <- data.frame(z1, z2, y, mf[,-c(1,exclude)])
 full <- glm(formula = y/trials ~ ., family = binomial(link = logit), weights = trials, data = vars)
 null <- glm(formula = y/trials ~ ., family = binomial(link = logit), weights = trials, data = vars[,-c(1,2)])
 LRT <- anova(null,full)
 p.value <- 1 - pchisq(LRT$Deviance[[2]], LRT$Df[[2]])
 cat("Stukel Test Stat = ", LRT$Deviance[[2]], "with p-value = ", p.value, "\n")
}

"""

tsts = SignatureTranslatedAnonymousPackage(string, "tsts")

tsts.stukeltest()