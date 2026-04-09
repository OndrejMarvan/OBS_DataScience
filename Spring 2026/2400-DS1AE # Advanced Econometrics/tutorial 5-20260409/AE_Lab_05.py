# -*- coding: utf-8 -*-
"""
# Advanced Econometrics
# Spring semester
# Lab 05: Unordered Choice Models
# Rafal Wozniak
# https://www.statsmodels.org/dev/discretemod.html#module-statsmodels.discrete.discrete_model
# https://xlogit.readthedocs.io/en/latest/index.html
"""

pip install xlogit
from xlogit import MultinomialLogit

# packages
import math as math
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf
import statsmodels.api as sm


# working directory
import os as os
os.getcwd()
os.chdir('C:\\Users\\Hp\\WNE\\Advanced_Econometrics\\AE_Lab_05')
os.getcwd()


# ------------------------------------------
# Exercise 0
# ------------------------------------------

# This exercise repeats the results of the
# multinom  function of the nnet package in R.
# Key issue: data is in the wide format, i.e.
# one row per observed individual

# read the data
Fishing_mode = pd.read_csv("Fishing_mode.csv", sep=",")
print(Fishing_mode.head())
from statsmodels.discrete.discrete_model import MNLogit

exog_vars = ["income"]
exog = sm.add_constant(Fishing_mode[exog_vars])
model = MNLogit(endog=Fishing_mode["mode"],
                exog=exog)
mlogit = model.fit()
print(mlogit.summary())

# average marginal effects (AMEs)
mlogit.get_margeff(at="overall").margeff

# suppress the scientific notation
pd.options.display.float_format = '{:.5f}'.format
np.set_printoptions(suppress=True)

# marginal effects for means
mlogit.get_margeff(at="mean").margeff


Fish = pd.read_csv("Fish.csv", sep=",")
print(Fish.head())

# Multinomial logit model for long data set
varnames = ['income']
model = MultinomialLogit()
model.fit(X=Fish[varnames],
          y=Fish['mode'],
          varnames=varnames,
          isvars=['income'],
          ids=Fish['chid'],
          alts=Fish['alt'],
          fit_intercept=True)
model.summary()

# "Impure" conditional logit model for long data set
varnames = ['income','price', 'catch']
model = MultinomialLogit()
model.fit(X=Fish[varnames],
          y=Fish['mode'],
          varnames=varnames,
          isvars=['income'],
          ids=Fish['chid'],
          alts=Fish['alt'],
          fit_intercept=True)
model.summary()


# ------------------------------------------
# Exercise 5
# ------------------------------------------

# The "pure" conditional logit, i.e.
# only alternative-specific variables
from statsmodels.discrete.conditional_models import ConditionalLogit

# read the data
car_choice = pd.read_csv("car_choice.csv", sep=",")
print(car_choice.head())

endog = car_choice["choice"]
exog = car_choice[["dealer"]]
model = ConditionalLogit(endog, 
                         exog,
                         groups = car_choice["id"])
clogit = model.fit()
print(clogit.summary())
# The very same result as in R.


varnames = ['income']
model = MultinomialLogit()
model.fit(X=car_choice[varnames],
          y=car_choice['choice'],
          varnames=varnames,
          isvars=varnames,
          ids=car_choice['id'],
          alts=car_choice['car'],
          fit_intercept=True)
model.summary()


# categorical variables have to recoded into numerical variables
car_choice["sex2"] = 0
temp = car_choice["sex2"] 
temp[car_choice["sex"]=="female"] = 1
car_choice["sex2"] = temp

varnames = ['income', "sex2"]
model = MultinomialLogit()
model.fit(X=car_choice[varnames],
          y=car_choice['choice'],
          varnames=varnames,
          isvars=varnames,
          ids=car_choice['id'],
          alts=car_choice['car'],
          fit_intercept=True)
model.summary()

