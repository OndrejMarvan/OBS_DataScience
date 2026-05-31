###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa³ WoŸniak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#                                                                         #
#                  Lab 14: Instrumental variables estimations             #
#                                                                         #
###########################################################################

# AE Instrumental Variables Estimation

library("MASS")
library("sandwich")
library("zoo")
library("car")
library("lmtest")
library("Formula")
library("plm")
library("stargazer")
library("maxLik")

library("AER")

setwd("C:/Users/Rafal/WNE/Advanced_Econometrics/AE_Lab_14")

# -----------------------------------------------------------------------------------
# Exercise 1
# -----------------------------------------------------------------------------------

# Let's artificially create a sample of N=100 observation from the true model
# y = 1+x+e,
# where x and e are normally distributed variables with true means 0 and variances 1. 
# We set the population correlation between x and e to be Corr(x,e)=0.6.

# Let's generate three instrumental variables
# z_{1}:  Corr(x,z_{1})=0.5,  Corr(z_{1},e)=0
# z_{2}:  Corr(x,z_{2})=0.3,  Corr(z_{2},e)=0 
# z_{3}:  Corr(x,z_{3})=0.5,  Corr(z_{3},e)=0.3$

# The generated data is included in ch10.csv file.

# Estimate:
# a) simple regression model
# b) use ivreg function from AER package and use as instrument:
#   i) z1
#   ii) z2
#   iii) z3

# Create a quality publication table.
# Compare results, i.e. s.e and parameters

ch10 = read.csv(file="ch10.csv", header=TRUE, sep=",")
View(ch10)

ols = lm(y~x, data=ch10)
summary(ols)

# ivreg(formula, instruments, data)
ivreg1 = ivreg(y~x|z1, data=ch10)
summary(ivreg1)
# CI for the slope estimate
# 1.19-2*0.1945
# 1.19+2*0.1945
# CI = (0.8, 1.579)

ivreg2 = ivreg(y~x|z2, data=ch10)
summary(ivreg2)

ivreg3 = ivreg(y~x|z3, data=ch10)
summary(ivreg3)

stargazer(ols, ivreg1, ivreg2, ivreg3, type="text")


# -----------------------------------------------------------------------------------
# Exercise 2
# -----------------------------------------------------------------------------------

# We will use the data on married women in the file mroz.csv to estimate the wage model. 
# a) Using the N = 428 women in the sample who are in the labor force, find the least squares
#    estimates and their standard errors.
# b) Use mothereduc as an instrument for educ. Why is it a valid instrument?
# c) Create a quality publication table.
# d) Compare results, i.e. s.e and parameters

mroz = read.csv(file="mroz.csv", header=TRUE, sep=",")
mroz = mroz[mroz$wage>0,]
View(mroz)

mroz$lnWAGE = log(mroz$wage)
mroz$exper2 = mroz$exper^2

ols = lm(lnWAGE~educ+exper+exper2, data=mroz)
summary(ols)

ivreg1 = ivreg(lnWAGE~educ+exper+exper2|.-educ+mothereduc, data=mroz)
summary(ivreg1)

stargazer(ols, ivreg1, type="text")


# -----------------------------------------------------------------------------------
# Exercise 3
# -----------------------------------------------------------------------------------

# A consulting firm run by Mr. John Chardonnay is investigating the relative efficiency
# of wine production at 75 California wineries. John sets up the production function

# Q_{i}=\beta_{1}+\beta_{2}\textit{MGT}_{i}+\beta_{3}\textit{CAP}_{i}+\beta_{4}\textit{LAB}_{i}+\epsilon

# where Q is an index of wine output for a winery, taking into account both quantity and
# quality, MGT is a variable that reflects the efficiency of management, CAP is an index
# of capital input, and LAB is an index of labour input. 

# Because he cannot get data on management efficiency, John collects observations on the number 
# of years of experience (XPER) of each winery manager and uses that variable in place of MGT. 
# The 75 observations are stored in the file chard.csv.

# a) Estimate the revised equation using least squares and comment on the results.
# b) John is concerned that the proxy variable XPER might be correlated with the
#    error term. He decides to do a Hausman test, using the manager’s age (AGE) as an
#    instrument for XPER. Regress XPER on AGE; CAP, and LAB, and save the residuals. 
#    Include these residuals as an extra variable in the equation you
#    estimated in part (a), and comment on the outcome of the Hausman test.
# c) Use the instrumental variables estimator to estimate the equation
#    Q = b1 + b2*XPER + b3*CAP + b4*LAB + e
#    with AGE, CAP, and LAB as the instrumental variables. Comment on the results
#    and compare them with those obtained in part (a).

wine = read.csv(file="chard.csv", sep=",", header=TRUE)
View(wine)

# a)
ols = lm(q~xper+cap+lab, data=wine)
summary(ols)

# b)
ols1 = lm(xper~age+cap+lab, data=wine)
summary(ols1)

ols2 = lm(q~xper+cap+lab+ols1$residuals, data=wine)
summary(ols2)

# c)
ivreg1 = ivreg(q~xper+cap+lab|.-xper+age+cap+lab, data=wine)
summary(ivreg1, diagnostics=TRUE)


stargazer(ols, ivreg1,type="text")


# -----------------------------------------------------------------------------------
# Exercise 4
# -----------------------------------------------------------------------------------

# Consider a supply model for edible chicken, which the U.S. Department of Agriculture
# calls ‘‘broilers.’’ The data for this exercise are in the file newbroiler.dat, which
# is adapted from the data provided by Epple and McCallum (2006). The data are
# annual, 1950–2001, but in the estimations use data from 1960–1999. The supply
# equation is

# lnQPROD = b1 + b2*lnP + b3*lnPF + b4*TIME + b5*lnQPRODt-1 + e

# where 
# QPROD = aggregate production of young chickens, 
# P = real price index of fresh chicken, 
# PF = real price index of broiler feed, 
# TIME = 1; . . . ; 52. 
# This supply equation is dynamic, with lagged production on the right-hand side.
# This predetermined variable is known at time t and is treated as exogenous.
# TIME= 1; 2; . . . ; 52 is included to capture technical progress in production.
#
# Some potential external instrumental variables are lnY where Y is real per capita
# income; lnPB where PB is the real price of beef; POPGRO = percentage
# population growth from year t = 1 to t; lnPt-1 = lagged log of real price of
# chicken; lnEXPTS = log of exports of chicken.
#
# (a) Estimate the supply equation by least squares. Discuss the estimation results. Are
#     the signs and significance what you anticipated?
# (b) Estimate the supply equation using an instrumental variables estimator with all
#     available instruments. Compare these results to those in (a).
# (c) Test the endogeneity of lnPt using the regression-based Hausman test.
# (d) Check whether the instruments are adequate, using the test for weak instruments.
#     What do you conclude?
# (e) Do you suspect the validity of any instruments on logical grounds? If so, which
#     ones, and why? Check the instrument validity.


chicken = read.csv(file="newbroiler.csv", sep=",", header=TRUE)
# View(chicken)

chicken$lnQPROD = log(chicken$qprod)
chicken$lnP = log(chicken$p)
chicken$lnPF = log(chicken$pf)
chicken$lnPB = log(chicken$pb)
chicken$lnY = log(chicken$y)
chicken$lnQPRODlagged = sapply(1:nrow(chicken), function(x) chicken$lnQPROD[x+1])
chicken$lnPlagged = sapply(1:nrow(chicken), function(x) chicken$lnP[x+1])

ols1 = lm(lnQPROD~lnP+lnPF+year+lnQPRODlagged, data=chicken)
summary(ols1)

ivreg1 = ivreg(lnQPROD~lnP+lnPF+year+lnQPRODlagged|.-lnP+lnY+lnPB+popgro+lnPlagged, data=chicken)
summary(ivreg1, diagnostics=TRUE)

# Weak instruments test p-value = 0.0101
# H0: beta_instrument=0 -- i.e. instrument is insignificant
# We have to reject the null that the instrument are insignificant.
# We have four instruments and the test statistic is not higher that 10
# Rule of thumb mentioned in the last lecture: F-test statistic > 10
#
# Sargan test p-value = 0.0728
# H0: cov(instrument, e)=0 -- i.e. instrument is valid
# A statistically significant test statistic always indicates that the instruments may not be valid.
# We cannot reject the null that instruments are valid.
# Sargan tests overidentification restrictions. The idea is that if you have more 
# than one instrument per endogenous variable, the model is overidentified, and you 
# have some excess information. All of the instruments must be valid for the 
# inferences to be correct. So it tests that all exogenous instruments are in fact 
# exogenous, and uncorrelated with the model residuals. 
# If it is significant, it means that you don't have valid instruments.
#
# Wu-Hausman test p-value = 0.0491
# H0: cov(x,e)=0 -- i.e. there is no endogeneity
# We have to reject the null that the OLS estimates are equal to the IV estimates.
# Therefore, IV method is preferable.
# In other words, variables being tested must be treated as endogenous.
#
# H0: Wu-Hausman tests that IV is just as consistent as OLS, and since OLS is more 
# efficient, it would be preferable.

stargazer(ols1, ivreg1, type="text")


# -----------------------------------------------------------------------------------
# Exercise 5
# -----------------------------------------------------------------------------------

# A regression from Griliches (1976) is a classic study of the wages of a sample 
# of 758 young men. Griliches model their wages as a function of several continuous 
# factors: 
# s - years of schooling
# expr - experience
# tenure - a job tenure
# rns - an indicator for residency in the South
# smsa - an indicator for urban versus rural
# and a set of year dummies since the data are a set of pooled cross sections.
#
# The endogenous regressor is iq, the worker's IQ score, which is considered as a
# potentially mismeasured version of ability. 
# Here we do not consider that wage and iq are simultaneously determined, but rather
# that iq cannot be assumed independent of the error term:
#
# the same correlation that arises in the context of an endogenous regressor in a 
# structural equation.
#
# The IQ score is instrumented with four factors excluded from the equation:
# med  - the mother's level of education
# kww - the score on another standardised test
# age - the worker's age
# mrt - an indocator of marital status

# a) estimate the model for wage with OLS method
# b) check which of the four instruments are strong
# c) use instruments to estimate parameters of the model for wage
# d) interpret the Weak instruments test
# e) interpret the Wu-Hausman test
# f) interpret the Sargan test

wages = read.csv(file="griliches.csv", sep=",", header=TRUE)
View(wages)



