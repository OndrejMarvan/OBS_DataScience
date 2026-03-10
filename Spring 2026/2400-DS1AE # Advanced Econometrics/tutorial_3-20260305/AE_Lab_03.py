# -*- coding: utf-8 -*-
"""
# Advanced Econometrics
# Spring semester
# Lab 03: Binary Variables Dependent Models
# Rafal Wozniak
# The code partially uses codes from the textbook by
# Florian Heiss, Daniel Brunner,
# Using Python for Introductory Econometrics
"""

# installation
pip install linearmodels

# packages
import math as math
import numpy as np
import pandas as pd
from scipy import stats
import statsmodels.formula.api as smf
import statsmodels.api as sm

# working directory
import os as os
os.chdir('C:\\Users\\Hp\\WNE\\Advanced_Econometrics\\AE_Lab_03')
os.getcwd()


# ------------------------------------------------------------------------------
# Exercise 1
# Fixed effects model
# ------------------------------------------------------------------------------

# oscar data set
oscar = pd.read_csv("oscar.csv", sep=";")
print(oscar)

reg_logit = smf.logit(formula="winner~nominations+gglobes", data=oscar)
logit = reg_logit.fit()
print(logit.summary())


# marginal effects for the average observation
# marginal effects for means
MEM  = logit.get_margeff(at="mean").summary()
print(MEM)

# average marginal effects
coef_names = np.array(logit.model.exog_names)
coef_names = np.delete(coef_names, 0) # usuniecie
AME = logit.get_margeff(at="overall").margeff
print(AME)
table = pd.DataFrame({'coef_names': coef_names,
                     'AME': AME})
print(table)

# marginal effects for a defined vector
# define resp as dictionary
# eff  = logit.get_margeff(atexog=resp.summary()

# marginal effects for a defined vector
# define resp as dictionary
# eff  = logit.get_margeff(atexog=resp.summary()

# average marginal effects
coef_names = np.array(logit.model.exog_names)
coef_names = np.delete(coef_names, 0) # delete the intercept
AME = logit.get_margeff().margeff
table = pd.DataFrame({'coef_names': coef_names,
                     'AME': AME})
print(table)

# let's use R inside Python
oscar_r = pandas2ri.py2rpy_pandasdataframe(oscar)
model = stats.glm("winner~nominations+gglobes", 
                  family=stats.binomial(link="logit"), 
                  data=oscar_r)
print(base.summary(model))

# diagnostics
tsts.stukeltest(model)
