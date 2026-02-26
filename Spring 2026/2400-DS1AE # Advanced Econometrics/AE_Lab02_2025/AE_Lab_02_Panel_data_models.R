
###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#                 Labs 2: Panel data models                               #
#                                                                         #
###########################################################################


# This file is based on:
# 1. Getting Started in Fixed/Random Effects Models using R(ver. 0.1-Draft), 
#    Oscar Torres-Reyna, Princeton University
# 2. Ch.F. Baum, Introduction to Modern Exconometrics Using Stata, Stata Press, 2006.
# 3. A.C. Cameron, P.K. Trivedi, Microeconometrics Using Stata, Stata Press, 2010.
# 4. R.C. Hill, W.E. Griffiths, G.C. Lim, Principles of Econometrics, 3rd Ed., 2008.

install.packages("plm")
install.packages("Formula")
install.packages("stargazer")

# -----------------------------------------------------------------------------------
# Code
# -----------------------------------------------------------------------------------

setwd("C:\\Users\\ekate\\Advanced Econometrics 2023\\Lab 2")
Sys.setenv(LANG = "en")
options(scipen=999)

# BE SURE YOU HAVE ALL LIBRARIES BELOW INSTALLED
library("MASS")
library("sandwich")
library("zoo")
library("car")
library("lmtest")
library("Formula")
library("plm")
library("stargazer")

# ------------------------------------------------------------------------------
# Exercise 1
# Fixed effects model
# ------------------------------------------------------------------------------

traffic = read.csv(file="traffic.csv", sep=",", header=TRUE)

fixed <-plm(fatal~beertax+spircons+unrate+perincK, data=traffic, 
            index=c("state", "year"), model="within")
summary(fixed)

fixef(fixed)
ols<-lm(fatal~beertax+spircons+unrate+perincK, data=traffic)
# Pooled OLS == POLS
# Simple regression model used for panel data set.
# Biased and inconsistent estimates!
# Autocorrelation and heteroskedasticity problems

# tests for poolability
pFtest(fixed, ols)

# Testing for serial correlation
pbgtest(fixed)

# Testing for heteroskedasticity
bptest(fatal~beertax+spircons+unrate+perincK, data=traffic, studentize=T)

# Controlling for heteroskedasticity and autocorrelation:
coeftest(fixed, vcov.=vcovHC(fixed, method="white1", type="HC0", cluster="group"))


# ------------------------------------------------------------------------------
# Exercise 2
# Random effects model
# ------------------------------------------------------------------------------

rice = read.csv(file="rice.csv", sep=",", header=TRUE)

random <-plm(prod~area+labor+fert, data=rice, 
             index=c("firm", "year"), model="random")
summary(random)

fixed <-plm(prod~area+labor+fert, data=rice, 
            index=c("firm", "year"), model="within")
summary(fixed)

POLS <-plm(prod~area+labor+fert, data=rice, 
          index=c("firm", "year"), model="pooling")
summary(POLS)

#hausmann test
phtest(fixed, random)

#individual effects for random effects?
plmtest(POLS, type=c("bp"))

#individual effects for fixed effects?
pFtest(fixed, POLS)

# Testing for serial correlation
pbgtest(random)

# Testing for heteroskedasticity
bptest(fatal~beertax+spircons+unrate+perincK, data=traffic, studentize=TRUE)


# ------------------------------------------------------------------------------
# Exercise 3
# Dancing with the Stars
# ------------------------------------------------------------------------------

dancing = read.csv(file="dancingwiththestars.csv", header=TRUE, sep=",")

random <-plm(score~judgexp+ppepisodexp, data=dancing, 
             index=c("team", "time"), model="random")
summary(random)

fixed <-plm(score~judgexp+ppepisodexp, data=dancing, 
            index=c("team", "time"), model="within")
summary(fixed)

phtest(fixed, random)

stargazer(fixed, random, title="Results", align=TRUE, type="text")

# ------------------------------------------------------------------------------
# Exercise 4
# Grunfeld data
# ------------------------------------------------------------------------------

data("Grunfeld", package="plm")

plm(formula = inv ~ value + capital, data = Grunfeld, 
    model = "...", index = c("firm", "year"))


# ------------------------------------------------------------------------------
# Exercise 5
# General-to-specific procedure
# ------------------------------------------------------------------------------

crime = read.csv(file="crime.csv", header=TRUE, sep=",")
# alternatively
crime = pdata.frame(crime, index=c("county", "year"))
View(crime)

# -----------------------------------------------------------------------
# Step 1
# -----------------------------------------------------------------------

# general model
fixed = plm(lcrmrte~lprbarr+lprbconv+lprbpris+lavgsen+lpolpc+ldensity+ltaxpc+lwcon+lwfir,
            data=crime, model="within")
summary(fixed)


# -----------------------------------------------------------------------
# Step 2
# -----------------------------------------------------------------------
# general model without ldensity
fixed1 = plm(lcrmrte~lprbarr+lprbconv+lprbpris+lavgsen+lpolpc+ltaxpc+lwcon+lwfir,
            data=crime, index=c("county", "year"), model="within")
summary(fixed1)
# general model without ldensity. ltaxpc
fixed2 = plm(lcrmrte~lprbarr+lprbconv+lprbpris+lavgsen+lpolpc+lwcon+lwfir,
             data=crime, index=c("county", "year"), model="within")
summary(fixed2)

# ldensity and ltaxpc
wald.test.results = waldtest(fixed, fixed2, vcov = vcov(fixed))
wald.test.results


# -----------------------------------------------------------------------
# Step 3
# -----------------------------------------------------------------------
# general model without ldensity and ltaxpc
fixed2

# model without ldensity and ltaxpc and lavgsen
fixed3 = plm(lcrmrte~lprbarr+lprbconv+lprbpris+lpolpc+lwcon+lwfir,
            data=crime, index=c("county", "year"), model="within")
summary(fixed3)

wald.test.results = waldtest(fixed2, fixed3, vcov = vcov(fixed))
wald.test.results


# -----------------------------------------------------------------------
# Step 4
# -----------------------------------------------------------------------
# model without ldensity and ltaxpc and lavgsen
fixed3


fixed4 = plm(lcrmrte~lprbarr+lprbconv+lprbpris+lpolpc+lwcon,
             data=crime, index=c("county", "year"), model="within")
summary(fixed4)
wald.test.results = waldtest(fixed3, fixed4, vcov = vcov(fixed))
wald.test.results


# general to fixed4?
wald.test.results = waldtest(fixed, fixed4, vcov = vcov(fixed))
wald.test.results # yes
summary(fixed4)
# now all significant

