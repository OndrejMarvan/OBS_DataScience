# -*- coding: utf-8 -*-
"""
# Advanced Econometrics
# Spring semester
# Lab 02: Panel data models
# Rafal Wozniak
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
import linearmodels as plm
from linearmodels.panel import PanelOLS

# working directory
import os as os
os.getcwd()
os.chdir('C:\\Users\\Hp\\WNE\\Advanced_Econometrics\\AE_Lab_02')
os.getcwd()


# ------------------------------------------------------------------------------
# Exercise 1
# Fixed effects model
# ------------------------------------------------------------------------------

traffic = pd.read_csv("traffic.csv", sep=",")
traffic = traffic.set_index(["state", "year"], drop=False)

# random effects (RE)
reg_re = plm.RandomEffects.from_formula(formula="fatal~1+beertax+spircons+unrate+perincK", 
                                       data=traffic)
re = reg_re.fit()
print(re)

# two-way random effects
reg_re = plm.RandomEffects.from_formula(formula="fatal~1+beertax+spircons+unrate+perincK", 
                                       data=traffic)
re2w = reg_re.fit()
print(re2w)

# LSDV
reg = smf.ols(formula="fatal~1+beertax+spircons+unrate+perincK+C(state)", 
              data=traffic)
lsdv = reg.fit()
print(lsdv.summary())

# fixed effects
exog_vars = ["beertax","spircons","unrate","perincK"]
exog = sm.add_constant(traffic[exog_vars])
mod = PanelOLS(traffic.fatal, exog, entity_effects=True)
fe = mod.fit()
print(fe)

# two-way fixed effects
exog_vars = ["beertax","spircons","unrate","perincK"]
exog = sm.add_constant(traffic[exog_vars])
mod = PanelOLS(traffic.fatal, exog, entity_effects=True,
               time_effects=True)
fe2w = mod.fit()
print(fe2w)

# Pooled OLS (POLS)
# Pooled OLS (POLS)
reg = smf.ols(formula="fatal~beertax+spircons+unrate+perincK", data=traffic)
pols = reg.fit()
print(pols.summary())


# Pooled OLS == POLS
# Simple regression model used for panel data set.
# Biased and inconsistent estimates!
# Autocorrelation and heteroskedasticity problems


# cluster-robust standard errors
# RE with robust s.e.
reg_re = plm.RandomEffects.from_formula(formula="fatal~beertax+spircons+unrate+perincK", 
                                       data=traffic)
re_rob = reg_re.fit(cov_type="clustered", cluster_entity=True, debiased=False)
print(re_rob)

# FE with cluster robust s.e.
exog_vars = ["beertax","spircons","unrate","perincK"]
exog = sm.add_constant(traffic[exog_vars])
mod = PanelOLS(traffic.fatal, exog, entity_effects=True)
fe_rob = mod.fit(cov_type="clustered", cluster_entity=True, debiased=False)
print(fe_rob)

# Quality Publication Table
# pip install stargazer
from stargazer.stargazer import Stargazer

s = Stargazer([pols, re, re2w, fe, fe2w, re_rob, fe_rob])
s.show_degrees_of_freedom(False)
from IPython.core.display import HTML
a = HTML(s.render_html())
html = a.data
with open('html_Panel_models.html', 'w') as f:
    f.write(html)


# tests for poolability for the fixed effects estimator
from linearmodels.panel import PanelOLS

exog_vars = ["beertax","spircons","unrate","perincK"]
exog = sm.add_constant(traffic[exog_vars])
mod = PanelOLS(traffic.fatal, exog, entity_effects=True)
fe2 = mod.fit()
print(fe2)

# The rest of the exercise is based on
# https://web.pdx.edu/~crkl/ceR/Python/example16_2.py

from linearmodels import PooledOLS
pols = PooledOLS.from_formula('fatal~1+beertax+spircons+unrate+perincK', traffic).fit()

# LM test for random effects versus OLS
n = traffic.index.levels[0].size
T = traffic.index.levels[1].size
D = np.kron(np.eye(n), np.ones(T)).T
e = pols.resids
LM = (e.dot(D).dot(D.T).dot(e) / e.dot(e) - 1) ** 2 * n * T / 2 / (T - 1)
LM_pvalue = stats.chi2(1).sf(LM)
print("LM Test: chisq = {0}, df = 1, p-value = {1}".format(LM, LM_pvalue))

# Hausman test for fixed versus random effects model
# null hypothesis: random effects model
psi = fe.cov.iloc[1:,1:] - re.cov.iloc[1:,1:]
diff = fe.params[1:] - re.params[1:]
# psi = fixed1.cov.iloc[1:,1:] - random.cov.iloc[1:,1:]
# diff = fixed1.params[1:] - random.params[1:]
W = diff.dot(np.linalg.pinv(psi)).dot(diff)
dof = re.params.size -1
pvalue = stats.chi2(dof).sf(W)
print("Hausman Test: chisq = {0}, df = {1}, p-value = {2}".format(W, dof, pvalue))

# ------------------------------------------------------------------------------
# Exercise 2
# Random effects model
# ------------------------------------------------------------------------------

rice = pd.read_csv("rice.csv", sep=",")
rice = rice.set_index(["firm", "year"], drop=False)

# random effects (RE)
reg_re = plm.RandomEffects.from_formula(formula="prod~area+labor+fert", 
                                       data=rice)
re = reg_re.fit()
print(re)

