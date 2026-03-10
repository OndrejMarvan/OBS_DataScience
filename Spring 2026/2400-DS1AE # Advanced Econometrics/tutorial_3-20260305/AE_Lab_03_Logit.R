###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#                                                                         #
#                 Lab 3: Binary choice models                            #
#                                                                         #
###########################################################################

# setwd("C:\\Users\\Hp\\WNE\\Advanced_Econometrics\\AE_Lab_03")

Sys.setenv(LANG = "en")
options(scipen = 5)


# ------------------------------------------------------------
# Installing the libraries
# ------------------------------------------------------------

# WNE package from Github
install.packages("devtools")
library("devtools")

install_github("Rand-0/WNE")
library(WNE)

# BaylorEdPsych from CRAN archive repository
# https://cran.r-project.org/web/packages/BaylorEdPsych/index.html
install_version(package = "BaylorEdPsych", version = "0.5")

# LogisticDx from CRAN archive repository
# https://cran.r-project.org/web/packages/LogisticDx/index.html
install_version(package = "LogisticDx", version = "0.3")

# Install install_version()
install.packages("remotes")   # run once
library(remotes)

# Install LogisticDx version 0.3 from CRAN archive
install.packages(
  "https://cran.r-project.org/src/contrib/Archive/LogisticDx/LogisticDx_0.3.tar.gz",
  repos = NULL,
  type = "source"
)

# Standard CRAN Repository

# install.packages("htmltools")
install.packages("logistf")
install.packages("mfx")

library("sandwich")
library("lmtest")
library("MASS")
library("mfx")
library("BaylorEdPsych")
# library("htmltools")
library("LogisticDx")
library("aod")

library("logistf") #Firth's bias reduction method

# ------------------------------------------------------------
# Exercise 1
# ------------------------------------------------------------
# Exercise 1
# 0) Estimate the probit model using data oscar.csv of the form
# winner∗i = β0 + β1nominationsi + β2gglobesi + εi. (1)
# The dependent variable winner is a dummy variable(=1 if the movie won the best picture
#                                             Oscar, = 0 otherwise). W
# nominations - number of nominations and 
# gglobes - number of Golden Globes won by the movie as explanatory variables.
# a) Are β1 and β2 jointly significant?
# b) Calculate marginal eﬀects for the average observation and for your own defined observation.
# c) Calculate R2 statistics and interpret them.
# d) Perform the model specification test (linktest).
# e) Perform the Hosmer-Lemeshow test.
# f) Perform the Osius-Rojek test
# g) Verify a hypothesis that β2 = 0 using likelihood ratio test.

oscar = read.csv2(file="Oscar.csv", header=TRUE, sep=";")
View(oscar)
oscar = na.omit(oscar)

# probit model estimation
myprobit <- glm(winner~nominations+gglobes, data=oscar, 
                family=binomial(link="probit"))

summary(myprobit)

# Call:
#   glm(formula = winner ~ nominations + gglobes, family = binomial(link = "probit"), 
#       data = oscar)
# 
# Coefficients:
#   Estimate Std. Error z value    Pr(>|z|)    
# (Intercept)  -5.2314     1.0203  -5.127 0.000000294 ***
#   nominations   0.3804     0.1005   3.786    0.000153 ***
#   gglobes       0.6241     0.1748   3.570    0.000357 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 100.080  on 99  degrees of freedom
# Residual deviance:  45.501  on 97  degrees of freedom
# AIC: 51.501
# 
# Number of Fisher Scoring iterations: 7

# Signs and significance
# nominations positive and highly significant (p = 0.000153)
# gglobes positive and highly significant (p = 0.000357)
# BUT: the coefficient values are not “percentage points”
# In probit (and logit), coefficients affect the latent index Z, not probability directly.
# 0.3804 means: each additional nomination increases the latent score Z by 0.3804.
# 0.6241 means: each additional Golden Globe increases Zby 0.6241.
# To translate to probability changes you use marginal effects

# predicted probabilities
oscar$prob = round(predict(myprobit,type=c("response")),2)

# oscar$prob is the model’s estimated probability of winning for each observation.
library(dplyr)
oscar %>% head

library(pROC)
g <- roc(winner ~ prob, data = oscar)
plot(g)    

# An ROC curve shows how well your predicted probabilities separate the two classes (winner=1 vs winner=0) across 
# all possible cutoffs.
# Sensitivity (TPR) on Y-axis: among true winners, how many you correctly flag as winners.
# 1 − Specificity (FPR) is often on X-axis, but your plot uses Specificity on X (that’s a pROC plotting style), so read it accordingly.
# The grey diagonal is “coin flip performance” (no discrimination).
# Your black curve is strongly bent toward the “good” corner (high sensitivity with high specificity), which suggests the model has good discriminatory power.
# To quantify “how good”, you typically report AUC (area under the curve).
auc(g) # Area under the curve: 0.9416
# Rule of thumb:
# AUC = 0.5 → random
# 0.7–0.8 → okay
# 0.8–0.9 → good
# 0.9 → excellent

myprobit$coefficients
summary(myprobit)$coefficients[2,3]

# ------
# Ad. a)
# install.packages("lmtest")   # run once
library(lmtest)
# Joint insignificance of all variables test


null_probit = glm(winner~1, data=oscar, family=binomial(link="probit"))

lrtest(myprobit, null_probit)

# Model 1: winner ~ nominations + gglobes
# Model 2: winner ~ 1
# #Df LogLik Df Chisq Pr(>Chisq)    
# 1   3 -22.75                        
# 2   1 -50.04 -2 54.58  1.407e-12 ***
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# ------

# Interpretation:
# H0: beta_nominations = beta_gglobes = 0
# H1: At least one coefficient is different from 0

# Output interpretation (from the test):
# LR statistic = 54.58
# degrees of freedom = 2
# p-value = 1.407e-12

# Since p-value < 0.05, we reject H0.

# Conclusion:
# The explanatory variables "nominations" and "gglobes"
# are jointly statistically significant.
# The probit model with predictors fits the data
# significantly better than the intercept-only model.

# Ad. b)
# b) Calculate marginal eﬀects for the average observation and for your own defined observation.
# marginal effects for the average observation
(meff = probitmfx(formula=winner~nominations+gglobes, data = oscar, atmean=TRUE))

# marginal effect for user-defined observation
# source("marginaleffects.R")
install.packages("mfx")   # run once
library(mfx)
# user.def.obs = c(1, 7.43, 1.31)  # (intercept, nominations, gglobes)
user.def.obs = c(1, 7.43, 1.31) # convention: (intercept, x1, x2, ...)

mean(oscar$nominations) # 7.43
mean(oscar$gglobes)     # 1.31

marginaleffects(myprobit, user.def.obs)

# What “marginal effect” means?
# For a movie with:7.43 nominations and 1.31 Golden Globe
# we expect:
# If I increase X by 1 (keeping other variables fixed), how much does the predicted probability P(winner=1)
# P(winner=1) change?
# So it’s a change in probability, not a change in the latent index.


# Interpretation in words At nominations = 7.43 and gglobes= 1.31
# additional nomination increases the predicted probability of winning by about 0.043 → about 4.3 percentage points.
# additiona Golden Globe increases the predicted probability of winning by about 0.0706 → about 7.1 percentage points.

# Because in probit/logit models the effect on probability depends on where you are on the curve 
# (near 0/1 effects are smaller; around middle effects are larger). So these effects are local: true at that chosen point.

######## For median
median(oscar$nominations) # 7
median(oscar$gglobes)     # 1

user.def.obs = c(1,7,1) #convention: (intercept, x1, x2, ...)
marginaleffects(myprobit, user.def.obs)

# For a movie with:7 nominations and 1 Golden Globe
# we expect:
# one additional nomination → probability of winning increases by about 2.3 pp
# one additional Golden Globe → probability increases by about 3.8 pp
# So Golden Globes have a stronger effect than nominations at this point

library(ggeffects)

pred <- ggpredict(myprobit, terms=c("nominations"))

plot(pred)

pred <- ggpredict(myprobit, terms=c("gglobes"))
plot(pred)
# ------
# Ad. c)
# c) Calculate R2 statistics and interpret them.
install.packages("DescTools")   # run once
library(DescTools)
# R-squared statistics
PseudoR2(myprobit)
# R-squared statistics
# PseudoR2(myprobit) McFadden 0.5453574 
# Value	Interpretation
# 0.02 – 0.10	weak
# 0.10 – 0.20	moderate
# 0.20 – 0.40	strong
# > 0.40	very strong model fit
# Pseudo R2
# cannot be interpreted exactly like OLS R2
# It does not mean that 54.5% of variance is explained.
# It only measures relative improvement in model likelihood.
PseudoR2(myprobit, which="McKelveyZavoina") # closest to OLS interpretation
# This pseudo R2 approximates the proportion of variance explained in the latent variable model behind probit regression.
# About 70.7% of the variation in the latent propensity to win is explained by the explanatory variables (nominations and gglobes).
# ------
# Ad. d)
# Perform the model specification test (linktest).
# Linktest
# source("linktest.R")
linktest_result = WNE::linktest(myprobit)
print(linktest_result)
# The specification is correct.
# ---------------------------------------------------------
# Model specification test: LINKTEST
# ---------------------------------------------------------

# The link test checks whether the model is correctly specified.
# It helps detect problems such as:
# - omitted variables
# - incorrect functional form
# - missing nonlinear relationships

# Idea of the test:
# After estimating the model, a new regression is run:

# Y = a + b1*_hat + b2*_hatsq

# where:
# _hat   = predicted values from the original model
# _hatsq = squared predicted values

# Expected results for a correctly specified model:
# _hat   -> should be statistically significant
# _hatsq -> should NOT be statistically significant

# If _hatsq is significant:
# it suggests model misspecification (e.g., missing variables or wrong functional form).

# ---------------------------------------------------------
# Your results
# ---------------------------------------------------------

# _hat   coefficient: 0.62148
# p-value: 0.000  -> statistically significant

# _hatsq coefficient: 0.03027
# p-value: 0.366  -> NOT statistically significant

# ---------------------------------------------------------
# Interpretation
# ---------------------------------------------------------

# Since:
# - _hat is significant
# - _hatsq is NOT significant

# There is no evidence of model misspecification.

# Conclusion:
# The probit model appears to be correctly specified,
# and the explanatory variables (nominations and gglobes)
# adequately capture the relationship with the probability of winning.
# -----
# Ad. e) Perform the Hosmer-Lemeshow test.
install.packages("ResourceSelection")
library(ResourceSelection)

hoslem.test(oscar$winner, fitted(myprobit))

# Interpretation

# If p-value > 0.05
# -> fail to reject H0
# -> the model fits the data well

# If p-value < 0.05
# -> reject H0
# -> the model does not fit the data well
# -> possible model misspecification

# ---------------------------------------------------------
# Hosmer–Lemeshow goodness-of-fit test
# ---------------------------------------------------------

# Test result:
# X-squared = 2.9448
# df = 8
# p-value = 0.9378

# Hypotheses:
# H0: the model fits the data well
# H1: the model does not fit the data well

# Decision rule:
# reject H0 if p-value < 0.05

# Since p-value = 0.9378 > 0.05,
# we do NOT reject H0.

# Conclusion:
# There is no evidence of lack of fit.
# The probit model fits the data well.
# Predicted probabilities are consistent
# with the observed outcomes.
####################
# f) Perform the Osius-Rojek test

# ---------------------------------------------------------
# Osius–Rojek goodness-of-fit test
# ---------------------------------------------------------
source("AllGOFTests.R")
list.files()
gof.results = o.r.test(myprobit)
# z =  -0.05314216 with p-value =  0.9576186

# Interpretation:
# Since p-value > 0.05, we fail to reject the null hypothesis.
# There is no evidence of model misspecification.
# The probit model appears to fit the data adequately.

# The Osius–Rojek test checks whether the binary model
# (logit/probit) is correctly specified.

# Hypotheses:
# H0: the model is correctly specified (good fit)
# H1: the model is misspecified

# Test statistic approximately follows:
# Z ~ N(0,1)

# Decision rule:
# reject H0 if |Z| > 1.96 (or p-value < 0.05)

# If |Z| < 1.96:
# -> no evidence of model misspecification
# -> model fits the data well

# In practice this test complements:
# - Hosmer–Lemeshow test
# - Link test
# when diagnosing model specification.
# install.packages("remotes")
# library(remotes)


# -----
# Ad. g)
# Verify a hypothesis that β2 = 0 using likelihood ratio test.
myprobit <- glm(winner~nominations+gglobes, data=oscar, 
                family=binomial(link="probit"))
summary(myprobit)

myprobit_restricted <- glm(winner~nominations, data=oscar, 
                           family=binomial(link="probit"))
summary(myprobit_restricted)

library(lmtest)
lrtest(myprobit, myprobit_restricted)
# Result?
# ---------------------------------------------------------
# Likelihood Ratio (LR) test
# ---------------------------------------------------------

# Model 1 (unrestricted model):
# winner ~ nominations + gglobes

# Model 2 (restricted model):
# winner ~ nominations

# Hypotheses:
# H0: the restricted model is sufficient
#     (variable "gglobes" does not improve the model)
# H1: the unrestricted model is better
#     (variable "gglobes" significantly improves the model)

# Test statistic:
# LR = 2*(LogLik_full - LogLik_restricted)

# Log-likelihood values:
# unrestricted model: -22.75
# restricted model:   -30.35

# LR statistic:
# Chisq = 15.199

# p-value = 0.00009676

# Decision rule:
# reject H0 if p-value < 0.05

# Since p-value < 0.001, we reject H0.

# Conclusion:
# Adding the variable "gglobes" significantly improves
# the probit model explaining the probability of winning an Oscar.
# Therefore, the unrestricted model (with nominations and gglobes)
# provides a better fit than the restricted model.

# ------------------------------------------------------------
# Exercise 2
# ------------------------------------------------------------
# Exercise 2 (based on Example 16.3.3 from [1])
# The Olympic Games are a subject of great interest to the global community. Rightly or
# wrongly the attention focuses on the number of medals won by each country. Andrew
# Bernard and Meghan Busse1 examined the eﬀect of a country’s economic resources on the
# number of medals won. The data are in the file olympics.csv.
# a) Estimate the linear probability model for a dummy variable ifgold equal to one if a
# country won at least one gold medal at the Olympic Games in Montreal in 1976.
# ifgoldi = β0 + β1 ln (POP)i + β2 ln (GDP)i + β3hosti + β4plannedi + εi. (2)
# b) Perform specification test.
# c) Check whether the residuals are homoscedastic.
# d) Use White’s estimator for the variance-covariance matrix.
# e) Explain why shouldn’t we use the linear probability model and what model should be used instead.

# Data preparation
olympics = read.csv(file="olympics.csv", header=TRUE, sep=";")
olympics = na.omit(olympics)
indices = olympics$year==76
olympics = olympics[indices, ]
olympics$log.pop = log(olympics$pop)
olympics$log.gdp = log(olympics$gdp)
View(olympics)

# -----
# Ad. a
# a) Estimate the linear probability model for a dummy variable ifgold equal to one if a

# generate ifgold variable
olympics$ifgold = olympics$gold
olympics$ifgold[olympics$ifgold>1] = 1
# View(olympics)

# linear probability model
lpm = lm(ifgold~log.pop+log.gdp+host+planned, data=olympics)
summary(lpm)

# ---------------------------------------------------------
# Linear Probability Model (LPM)
# ---------------------------------------------------------

# Dependent variable:
# ifgold = 1 if the country won at least one gold medal
# ifgold = 0 otherwise

# The coefficients measure the change in the probability
# of winning a gold medal associated with a one-unit change
# in the explanatory variable.

# ---------------------------------------------------------
# Interpretation of coefficients
# ---------------------------------------------------------

# log.pop (-0.0427)
# A 1-unit increase in log population decreases the probability
# of winning a gold medal by about 4.3 percentage points.
# The effect is only weakly significant (p = 0.055).

# log.gdp (0.1243)
# A 1-unit increase in log GDP increases the probability
# of winning a gold medal by about 12.4 percentage points.
# The effect is highly statistically significant (p < 0.001).

# host (-0.5585)
# Being the host country decreases the probability of winning
# a gold medal by about 55.8 percentage points.
# However, the effect is only weakly significant (p = 0.099).

# planned (0.4444)
# Countries with a planned economy have a probability of
# winning a gold medal higher by about 44.4 percentage points.
# The effect is statistically significant (p = 0.023).

# ---------------------------------------------------------
# Model fit
# ---------------------------------------------------------

# R-squared = 0.3369
# About 33.7% of the variation in the probability of winning
# a gold medal is explained by the model.

# Adjusted R-squared = 0.3159

# F-statistic = 16.01
# p-value = 1.27e-10

# This indicates that the explanatory variables are jointly
# statistically significant and the model is overall significant.

# ---------------------------------------------------------
# Important note about LPM
# ---------------------------------------------------------

# The Linear Probability Model has limitations:
# - predicted probabilities can fall outside the [0,1] interval
# - heteroskedastic residuals are common
# - the relationship between variables and probability may
#   not be truly linear

# Therefore, logit or probit models are often preferred
# for binary dependent variables.

############################################################
# Limitations of the Linear Probability Model (LPM)
# 1. Predicted probabilities can fall outside the [0,1] interval
#
# In the LPM the predicted probability is:
# P(Y=1|X) = β0 + β1X1 + ... + βkXk
#
# Since the right-hand side is linear and unbounded,
# predicted values may be smaller than 0 or greater than 1.
#
# Example:
# predicted probability = -0.2 or 1.3
#
# Such values have no interpretation as probabilities.

# 2. Heteroskedasticity of residuals
#
# In binary models:
# Var(Y|X) = P(Y=1|X)*(1 - P(Y=1|X))
#
# This variance depends on the probability itself,
# so the error variance is not constant across observations.
#
# Therefore the classical OLS assumption:
# Var(u|X) = constant
#
# is violated.
#
# Consequence:
# OLS estimates remain unbiased, but standard errors are incorrect.
#
# Solution often used:
# heteroskedasticity-robust standard errors.

# 3. The relationship between X and probability may not be linear
#
# The LPM assumes a linear relationship between explanatory
# variables and probability.
#
# However, probabilities typically follow an S-shaped curve:
#
# small effect when probability is close to 0 or 1
# larger effect in the middle range.
#
# This nonlinear relationship is better captured by:
# - logistic regression (logit model)
# - probit regression

# 4. Non-normal residuals
#
# Because Y only takes values 0 or 1, the residuals
# cannot be normally distributed.
#
# This violates another classical OLS assumption.

# 5. Inefficiency of OLS estimates
#
# Due to heteroskedasticity and the binary nature of Y,
# OLS is not the most efficient estimator.
#
# Maximum likelihood estimators used in logit and probit
# models are usually more efficient.
# Summary:
#
# LPM is simple and easy to interpret,
# but logit and probit models are generally preferred
# for binary dependent variables because they:
#
# - guarantee predicted probabilities in [0,1]
# - correctly model nonlinear probability changes
# - provide more efficient estimation.

# -----
# Ad. b) Perform specification test.

# specification test
resettest(lpm, power=2:3, type="fitted")

# Ramsey RESET test for functional form
# The RESET (Regression Specification Error Test) checks
# whether the regression model is correctly specified.
#
# In particular, it tests whether important nonlinear terms
# or omitted variables may be missing from the model.

# Hypotheses:
# H0: the model is correctly specified
# H1: the model is misspecified (missing nonlinear terms
#     or omitted variables)

# Test setup:
# The test adds powers of the fitted values (ŷ^2, ŷ^3)
# to the regression and tests whether they are jointly
# statistically significant.

# Results:
# RESET statistic = 5.411
# df1 = 2
# df2 = 124
# p-value = 0.005584

# Decision rule:
# reject H0 if p-value < 0.05

# Since p-value = 0.0056 < 0.05,
# we reject the null hypothesis.

# Conclusion:
# There is evidence that the model may be misspecified.
# The linear probability model may omit nonlinear effects
# or relevant variables.

# This result suggests that a nonlinear model such as
# logit or probit regression may provide a better
# specification for the binary dependent variable.

# -----
# Ad. c) Check whether the residuals are homoscedastic.

# The Breusch–Pagan test formally checks whether the
# variance of the residuals depends on explanatory variables.

# Hypotheses:
# H0: homoskedasticity (constant variance of residuals)
# H1: heteroskedasticity (variance depends on X)

# Heteroskedasticity does NOT bias the OLS coefficient estimates,
# but it makes the standard errors incorrect.

# As a result:
# - t-statistics
# - p-values
# - confidence intervals
# may be misleading.
lpm.residuals = lpm$residuals
plot(lpm.residuals~log.pop, data=olympics)
plot(lpm.residuals~log.gdp, data=olympics)

bptest(lpm.residuals~log.pop, data=olympics)
bptest(lpm.residuals~log.pop+log.gdp+host+planned, data=olympics)

# View(lpm$fitted.values)
# Heteroskedasticity diagnostics
# In the Linear Probability Model (LPM), heteroskedasticity
# is almost inevitable because the variance of the binary
# dependent variable depends on the predicted probability.

# For a binary variable:
# Var(Y|X) = P(Y=1|X) * (1 - P(Y=1|X))

# Since the probability varies across observations,
# the variance of the residuals is not constant.

# Graphical inspection

# Residual plots against explanatory variables help detect
# heteroskedasticity visually.

# If the spread of residuals changes across values of X
# (for example forming a funnel shape), this suggests
# heteroskedasticity.

# Example plots:
lpm.residuals = lpm$residuals
plot(lpm.residuals~log.pop, data=olympics)
plot(lpm.residuals~log.gdp, data=olympics)
# Residual plots suggest heteroskedasticity.
# The spread of residuals changes across values of log.pop
# and a systematic pattern appears with log.gdp.
#
# Residuals are not randomly scattered around zero,
# which indicates violation of the homoskedasticity assumption.
#
# This visual evidence is consistent with the Breusch–Pagan test,
# which also indicates heteroskedasticity in the model.
#
# Therefore, standard OLS inference may be unreliable,
# and robust standard errors or nonlinear models
# (logit or probit) should be considered.

# Ad. d) Use White’s estimator for the variance-covariance matrix
library(sandwich)
library(lmtest)
# A common solution is to use heteroskedasticity-robust
# standard errors.
# White's estimator of the variance-covariane matrix
robust_vcov = vcovHC(lpm, data = olympics, type = "HC")
coeftest(lpm, vcov.=robust_vcov)

# Alternatively, a logit or probit model can be used,
# which is more appropriate for binary dependent variables.

# to compare the simple lpm and the one with a robust vcov matrix
library("stargazer")
robust.lpm = coeftest(lpm, vcov.=robust_vcov)
stargazer(lpm, robust.lpm, type="text")

# e) Explain why shouldn’t we use the linear probability model and what model should be
# used instead.

# The Linear Probability Model (LPM) is not appropriate for binary dependent variables.

# 1. Predicted probabilities can fall outside the [0,1] interval,
#    which makes them difficult to interpret.

# 2. The error variance depends on the probability:
#    Var(Y|X) = P(Y=1|X)(1 - P(Y=1|X)),
#    which leads to heteroskedasticity and unreliable standard errors.

# 3. The relationship between explanatory variables and probability
#    is typically nonlinear, while LPM assumes a linear relationship.

# Therefore, nonlinear models such as the logit or probit model
# should be used instead of the linear probability model.
# ------------------------------------------------------------
# Exercise 3
# ------------------------------------------------------------
# Exercise 3 (based on Exercise 16.12 from [1])
# Predicting U.S. presidential election outcomes is a weekly event in the year before an
# election. In the 2000 election, Republican George W. Bush defeated Democrat Al Gore,
# and in 2004 George Bush defeated Democrat John F. Kerry. The data file vote2.csv
# contains data on these two elections. By state and for the 2 years we report the dummy
# variable dem= 1 if the popular vote favoured the democratic candidate, income= state
# median income, hs= percentage of the population with at least a high school degree,
# BA= percentageofthepopulationwithatleastabachelor’sdegree,density= population
# per square mile, and region= 3 for the southwest, 2 for the south, and 1 otherwise.
# 1. Consider the probit model
# dem∗
# i = β0 + β1incomei + β2income2
# i + β3region3i + εi (3)
# i. Calculate analytically the marginal eﬀect of the income on the probability of
# voting on a Democrats’ candidate.
# ii. Use R to calculate the marginal eﬀect numerically.
# iii. Should we add a covariate to the model (3)? If so, what are the implications for
# the model (3)?
#   iv. Test the hypothesis H0 : β1 = β2 = 0 using the Wald test.
# v. Test the hypothesis H0 : β1 = β2 = 0 using the Likelihood Ratio test.
# 2. Estimate the probit model
# dem∗
# i = β0 +β1incomei +β2income2
# i +β3region3i +β4hsi +β5bai +β6densityi +ξi (4)
# Discuss the warning message.

vote2 = read.csv(file = "vote2.csv", header=TRUE, sep=";", dec = ",")
# View(vote2)
str(vote2)

vote2$income2 = vote2$income^2
vote2$region3 = 0
vote2$region3[vote2$region==3] = 1

# ii. Use R to calculate the marginal effect numerically.
# Probit model

dem.probit <- glm( dem ~ income + I(income^2) + BA,
                  data = vote2,
                  family = binomial(link = "probit"))

# Marginal effects at a chosen observation
probitmfx(dem ~ income + I(income^2) + BA,
          data = vote2,
          atmean = TRUE)

# Call:probitmfx(formula = dem ~ income + I(income^2) + BA, data = vote2, 
#             atmean = TRUE)
# 
# Marginal Effects:
#   dF/dx  Std. Err.       z    P>|z|   
#   income       0.2875749  0.1797525  1.5998 0.109635   
# I(income^2) -0.0033666  0.0023616 -1.4255 0.154003   
# BA           0.0372972  0.0138008  2.7025 0.006881 **
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# income
# Marginal effect = 0.2876
# A one-unit increase in income increases the probability
# of voting Democrat by about 28.8 percentage points
# at the mean values of the explanatory variables.
# However, the effect is not statistically significant.

# income^2
# Marginal effect = -0.00337
# The negative coefficient suggests diminishing returns:
# the effect of income decreases as income increases.
# This effect is not statistically significant.

# BA
# Marginal effect = 0.0373
# Having a bachelor's degree increases the probability
# of voting Democrat by about 3.7 percentage points.
# This effect is statistically significant (p < 0.01).

# iv. Test the hypothesis H0: beta1=beta2=0 using the Wald statistics
install.packages("aod")   # run once
library(aod)
# Restriction matrix
H <- rbind(c(0,1,0,0),
           c(0,0,1,0))

# Wald test
wald.test.results <- wald.test(b = coef(dem.probit),
                               Sigma = vcov(dem.probit),
                               L = H)

wald.test.results

# Wald test for joint significance
# H0: beta_income = beta_income^2 = 0
# H1: at least one coefficient is different from zero

# Wald statistic = 7.4
# df = 2
# p-value = 0.025

# Since p-value < 0.05, we reject the null hypothesis.

# Conclusion:
# The variables income and income^2 are jointly significant.
# This suggests that income has a statistically significant
# (possibly nonlinear) effect on the probability of voting Democrat.

# We have to reject the null hypothesis.

# v. Test the hypothesis H0: beta1=beta2=0 using the likelihood ratio test
dem.U = glm(dem~income+income2+region3, data=vote2, 
            family=binomial(link="probit"))

dem.R = glm(dem~region3, data=vote2, family=binomial(link="probit"))

lrtest(dem.U, dem.R)
---------------------------------------------------------
  # Likelihood Ratio test for joint significance
  # ---------------------------------------------------------

# H0: beta_income = beta_income^2 = 0
# H1: at least one coefficient is different from zero

# Unrestricted model: dem ~ income + income2 + region3
# Restricted model:   dem ~ region3

# LR statistic = 28.617
# df = 2
# p-value = 0.00000061

# Since p-value < 0.05, we reject H0.

# Conclusion:
# Income and income^2 are jointly statistically significant.
# Income has a significant effect on the probability
# of voting Democrat in the probit model.

# vi. Estimate the full model
dem.full = glm(dem~income+income2+region3+density+HS+BA, data=vote2, 
               family=binomial(link="probit"))
#Warning message:
#  glm.fit: fitted probabilities numerically 0 or 1 occurred

table(vote2$dem)
table(vote2$dem, vote2$region3)

# Warning: fitted probabilities numerically 0 or 1 occurred
#
# This warning suggests that some observations are predicted
# with probabilities extremely close to 0 or 1.
#
# This may occur when some explanatory variables almost
# perfectly predict the outcome (quasi-perfect separation).
#
# To investigate this issue we inspect contingency tables,
# for example using:
# table(vote2$dem)
# table(vote2$dem, vote2$region3)
#
# If separation is strong, coefficient estimates may become
# unstable and the model should be interpreted with caution.

# The warning "fitted probabilities numerically 0 or 1 occurred"
# indicates that some observations are predicted with probabilities
# extremely close to 0 or 1.
#
# This may occur when explanatory variables almost perfectly
# classify some observations.
#
# The contingency table of dem and region3 shows no perfect
# separation, so the warning is likely caused by extreme
# combinations of predictors rather than a single variable.
#
# The model can still be estimated, but results should be
# interpreted with caution.

# https://stats.idre.ucla.edu/r/dae/logit-regression/
# https://stats.idre.ucla.edu/other/mult-pkg/faq/general/faqwhat-is-complete-or-quasi-complete-separation-in-logisticprobit-regression-and-how-do-we-deal-with-them/
# https://stats.idre.ucla.edu/other/mult-pkg/faq/general/faqwhat-is-complete-or-quasi-complete-separation-in-logistic-regression-and-what-are-some-strategies-to-deal-with-the-issue/

# Firth's bias reduction
install.packages("logistf")
# Load the package
library(logistf)

# Estimate the model using Firth logistic regression
fit <- logistf(dem ~ income + income2 + region3 + density + HS + BA,
               data = vote2)

summary(fit)

# Firth logistic regression is used when standard logit/probit models
# produce extremely large coefficients or fitted probabilities
# close to 0 or 1 due to separation in the data.
#
# The logistf() function estimates the model using penalized
# maximum likelihood, which produces more stable estimates.

# ------------------------------------------------------------
# Exercise 4
# ------------------------------------------------------------

womenwk = read.csv(file="womenwk.csv", header=TRUE, sep=",")
str(womenwk)

# let's generate variable of interest
womenwk$work = is.na(womenwk$wage)==FALSE

# student's own work ...

# ------------------------------------------------------------
# Exercise 5
# ------------------------------------------------------------
# An econometrician estimated the probit model for the probability of buying a brand-new
# car
# newcar∗i = β0 + β1agei + β2age2i + β3malei + εi. Calculate and interpret the eﬀect of age on the probability.
# Hint: In the probit model
# Pr(yi) = Φ(x′iβ), 
# in which Φ(.) is the cumulative density function of the standard normal distribution.

# ---------------------------------------------------------
# Effect of age on the probability of buying a new car
# in the probit model

# Probit model:
# newcar*_i = β0 + β1*age_i + β2*age_i^2 + β3*male_i + ε_i

# Probability model:
# P(newcar_i = 1) = Φ(x_i'β)
# where Φ(.) is the cumulative distribution function
# of the standard normal distribution.

# The marginal effect of age on the probability is:

# dP(newcar=1)/d(age) = φ(x_i'β) * (β1 + 2*β2*age_i)

# where:
# φ(.) is the density function of the standard normal distribution.

# Interpretation:
# The effect of age on the probability of buying a new car
# depends on the current age because the model includes age^2.

# If β2 < 0, the probability increases with age at younger ages
# but eventually starts decreasing after a certain point.

# The turning point occurs when:
# β1 + 2*β2*age = 0

# age* = -β1 / (2*β2)

# This is the age at which the probability of buying a new car
# reaches its maximum.
# ------------------------------------------------------------
# Exercise 6
# ------------------------------------------------------------

p = seq(from=0, to=1, by=0.001)
lnL = p^5*(1-p)^3
plot(p, lnL, type="l")
abline(v=5/8, col="red")

# install.packages("maxLik")
library("maxLik")

lnL = function(p) {
  l = 5*log(p)+3*log(1-p)
  return(l)
}

res = maxNR(fn=lnL, start=0.5)
summary(res)

curve(lnL(x), from = 0, to=1)
abline(v=res$estimate, col="blue")


# ------------------------------------------------------------
# Exercise 7
# ------------------------------------------------------------

oscar = read.csv2(file="Oscar.csv", header=TRUE, sep=";")
oscar = na.omit(oscar)
library("maxLik")

probit.glm = glm(winner~nominations+gglobes, data=oscar, 
                 family=binomial(link="probit"))
summary(probit.glm)
logLik(probit.glm)

loglik <- function(parameters) {
  beta0 = parameters[1]
  beta1 = parameters[2]
  beta2 = parameters[3]
  y = oscar$winner
  xb = beta0 + beta1*oscar$nominations + beta2*oscar$gglobes
  lnL = sum(y*log(pnorm(xb))) + sum((1-y)*log(1-pnorm(xb)))
  return(lnL)
}

res <- maxNR(loglik, start = c(0.1,0.1,0.1))
summary(res)

# comparison
tmp = cbind(probit.glm$coefficients, res$estimate)
colnames(tmp) = c("glm", "our code")
show(tmp)

