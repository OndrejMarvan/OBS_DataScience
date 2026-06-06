# -*- coding: utf-8 -*-
"""
# Advanced Econometrics
# Spring semester
# Lab 04: Ordered Choice Models
# Rafal Wozniak
# The code partially uses codes from the textbook by
# Florian Heiss, Daniel Brunner,
# Using Python for Introductory Econometrics
"""

# packages
import math as math
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf
from statsmodels.miscmodels.ordinal_model import OrderedModel
import scipy.stats as stats


# working directory
import os as os
os.getcwd()
os.chdir('C:\\Users\\Hp\\WNE\\Advanced_Econometrics\\AE_Lab_04')
os.getcwd()

# read the data
rd = pd.read_csv("randdata.csv", sep=",")
print(rd.head())

# generate the dependent variable health
health = rd["hlthp"]
health[rd["hlthf"]==1] = 2
health[rd["hlthg"]==1] = 3
rd["health"] = health
rd = rd.drop(rd[rd["health"]==0].index)

# let's check if the dependent variable contains only {1,2,3}
set(rd["health"])

# ordered logit
olog_reg = OrderedModel(rd['health'],
                        rd[["income","female","num"]],
                        distr='logit')
ologit = olog_reg.fit()
print(ologit.summary())

# Hypotheses testing
hypothesis = ["income=0"]
ologit.t_test(hypothesis)

hypothesis = ["income=0", "female=0", "num=0"]
ologit.f_test(hypothesis)

# Likelihood ratio test
olog_restr = OrderedModel(rd['health'],
                        rd[["income"]],
                        distr='logit')
ologit_r = olog_restr.fit()

LRtest = 2*(ologit.llf - ologit_r.llf)
pvalue = 1 - stats.chi2.cdf(x=LRtest, df=2)
print(pvalue)


# goodness-of-fit tests
# Long story short: only Brant test works
# We will use R in Python.

import rpy2 as rpy2
print(rpy2.__version__)

# Personal computer
import os
os.environ['R_HOME'] = 'C:\\Program Files\\R\\R-4.4.2'
os.environ["PATH"] += os.pathsep + 'C:\\Program Files\\R\\R-4.4.2\\bin\\x64\\'
os.environ["PATH"] += os.pathsep + 'C:\\Program Files\\R\\R-4.4.2\\'

# WNE Labs:
import os
os.environ['R_HOME'] = 'C:\\programy\\R\\R-4.4.2'
os.environ["PATH"] += os.pathsep + 'C:\\programy\\R\\R-4.4.2\\bin\\x64\\'
os.environ["PATH"] += os.pathsep + 'C:\\programy\\R\\R-4.4.2\\'
 
import pandas as pd
import rpy2.robjects as robjects
from rpy2.robjects import pandas2ri
from rpy2.robjects.packages import importr, data

# let's call R packages
utils = importr('utils')
base = importr('base')
stats = importr('stats')
MASS = importr('MASS')
lmtest = importr("lmtest")
gh = importr("generalhoslem")
brant = importr("brant")

# let's convert the data set into an R object
from rpy2.robjects import pandas2ri
pandas2ri.activate()
rd_r = pandas2ri.py2rpy_pandasdataframe(rd)
rd_r.rx2["health"] = base.factor(rd_r.rx2["health"])

col_2_index = list(rd_r.colnames).index('health')
col_2 = robjects.vectors.FactorVector(rd_r.rx2('health'))
rd_r[col_2_index] = col_2

# model estimation
model = MASS.polr('health~income+female+num', data=rd_r)
print(base.summary(model))

# Brant test
brant.brant(model)

# Goodness-of-fit tests
# they do not work
gh.lipsitz_test(model)
y = pandas2ri.py2rpy_pandasdataframe(rd["health"])
gh.logitgof(y, stats.fitted(model), g = 5, ord=True)
gh.pulkrob_chisq(model, ["female"])





