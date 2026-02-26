# -*- coding: utf-8 -*-
"""
# Advanced Econometrics
# Spring semester
# Lab 01: Undergraduate Econometrics
# Rafal Wozniak
"""

# packages
import math as math
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf
import statsmodels.stats.outliers_influence as smo

# working directory
import os as os
os.getcwd()
os.chdir('C:/Users/ekate/Advanced Econometrics 2023/Lab 1')
os.getcwd()


# Exercise 1
# read the data
cps = pd.read_csv("cps_small.csv", sep=",")
print(cps)

# generate lnWAGE
cps['lnWAGE'] = np.log(cps['wage'])
# generate the interaction term
cps['blackXfemale'] =cps['black']*cps['female']

# model - version 1
reg = smf.ols(formula="lnWAGE~educ+female+black+blackXfemale", data=cps)
model1 = reg.fit()
print(model1.summary())

# model - version 2
reg = smf.ols(formula="np.log(wage)~educ+female+black+black*female", data=cps)
model2 = reg.fit()
print(model2.summary())

# model - version 3
reg = smf.ols(formula="np.log(wage)~educ+female+black+black:female", data=cps)
model3 = reg.fit()
print(model3.summary())

# Quality Publication Table
pip install stargazer
from stargazer.stargazer import Stargazer

s = Stargazer([model1, model2, model3])
from IPython.core.display import HTML
a = HTML(s.render_html())
html = a.data
with open("html_file_Exercise1.html", "w") as f:
    f.write(html)


# Exercise 2
stockton = pd.read_csv("stockton2.csv", sep=",")
print(stockton)

# model 1
reg = smf.ols(formula="np.log(price)~sqft+baths+vacant+stories", data=stockton)
model1 = reg.fit()
print(model1.summary())

# model 2
reg = smf.ols(formula="np.log(price)~sqft+sqft^2+baths+vacant+stories+vacant:stories", 
              data=stockton)
model2 = reg.fit()
print(model2.summary())


# Exercise 3
data = pd.read_stata("http://www.principlesofeconometrics.com/poe3/data/stata/stockton.dta")

reg = smf.ols(formula="price~age+sqft", data=data)
model = reg.fit()
print(model.summary())

# a) functional form validity
# i. Ramsey's RESET test
resettest = smo.reset_ramsey(res=model, degree=3)
print(resettest.summary())
# albo po prostu
smo.reset_ramsey(res=model, degree=3)

# type="regressor"
reg = smf.ols(formula="price~age+sqft+I(age**2)+I(sqft**2)+I(age**3)+I(sqft**3)+age:sqft", 
              data=data)
reset_regresor = reg.fit()
print(reset_regresor.summary())

# the corrected model
reg = smf.ols(formula="price~age+sqft+I(age**2)+I(age**3)+age:sqft", data=data)
model2 = reg.fit()
print(model2.summary())
smo.reset_ramsey(res=model2, degree=3)

# b) heteroskedasticity
reg = smf.ols(formula="price~age+sqft", data=data)
model = reg.fit()
print(model.summary())

# i. Breusch-Pagan test
# Conduct the Breusch-Pagan test
from statsmodels.compat import lzip
import statsmodels.stats.api as sms
names = ['Lagrange multiplier statistic', 'p-value',
         'f-value', 'f p-value']
# Get the test result
test_result = sms.het_breuschpagan(model.resid, model.model.exog)
lzip(names, test_result)

# ii. White's test
X_white = pd.DataFrame({"const": 1, "fitted_reg": model.fittedvalues,
"fitted_reg_sq": model.fittedvalues ** 2})

result_white = sms.het_breuschpagan(model.resid, X_white)
white_statistic = result_white[0]
white_pval = result_white[1]
print(f"white_statistic: {white_statistic}\n")
print(f"white_pval: {white_pval}\n")

# c) normality of errors
import statsmodels.api as sm
name = ["Jarque-Bera test", "Chi^2 two-tail prob.", "Skew", "Kurtosis"]
test = sms.jarque_bera(model.resid)
lzip(name, test)
# However, we do not need this, because the basic output contains 
# the JB test results.


# Exercise 4
budgets = pd.read_stata("budgets.dta")

# model
reg = smf.ols(formula="w02~dochg+wydg+C(klm)+los+pw02", data=budgets)
model1 = reg.fit()
print(model1.summary())

# hypothesis testing using the t test
# H0: beta_dochg = 0
hypothesis = ["dochg=0"]
model1.t_test(hypothesis)

# H0: beta_los = 2
hypothesis = ["los=2"]
model1.t_test(hypothesis)

# testing the hypothesis H0: beta_klm5 = -5
hypothesis = ["C(klm)[T.-20t]=-5"]
model1.t_test(hypothesis)

# hypothesis testing using the F test
hypothesis = ["C(klm)[T.200t-500t]=0", "C(klm)[T.100t-200t]=0", "C(klm)[T.20t-100t]=0",
              "C(klm)[T.-20t]=0", "C(klm)[T.wies]=0"]
model1.f_test(hypothesis)


# Exercise 5
fertil = pd.read_csv("fertil2.csv")

# a) the regression model
reg = smf.ols(formula='ceb ~ age+agefbrth+usemeth', data=fertil)
model = reg.fit()
print(model.summary())

# b) verify the homoscedasticity assumption with Breusch’s and Pagan’s test
from statsmodels.compat import lzip
import statsmodels.stats.api as sms
names = ['Lagrange multiplier statistic', 'p-value',
         'f-value', 'f p-value']
# Get the test result
test_result = sms.het_breuschpagan(model.resid, model.model.exog)
lzip(names, test_result)

# c) apply White’s robust estimator (White’s-Huber’s)
reg = smf.ols(formula='ceb ~ age+agefbrth+usemeth', data=fertil)
model_HC0 = reg.fit(cov_type="HC0")
print(model_HC0.summary())

# d) apply White’s robust estimator MacKinnon’s and White’s
reg = smf.ols(formula='ceb ~ age+agefbrth+usemeth', data=fertil)
model_HC3 = reg.fit(cov_type="HC3")
print(model_HC3.summary())

# e) assume that there are clusters in our data 
# (children – number of children in the household);
# apply appropriate robust matrix

# drop NAs
fertil_clstrd = fertil[["ceb","age","agefbrth","usemeth","children"]]
fertil_clstrd = fertil_clstrd.dropna()

reg = smf.ols(formula='ceb ~ age+agefbrth+usemeth', data=fertil_clstrd)
model_clstrd = reg.fit(cov_type="cluster", cov_kwds = {"groups":fertil_clstrd["children"]})
print(model_clstrd.summary())

# f) present results from (a), (c), (d), and (e) in one Quality Publication Table

from stargazer.stargazer import Stargazer

s = Stargazer([model, model_HC0, model_HC3, model_clstrd])
s.show_degrees_of_freedom(False)
print(s)
from IPython.core.display import HTML
a = HTML(s.render_html())
html = a.data
with open("html_file_Exercise5.html", "w") as f:
    f.write(html)

