###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#                                                                         #
#                 Lab 04: Ordered choice models                           #
#                                                                         #
###########################################################################

# setwd("C:\\Users\\Hp\\WNE\\Advanced_Econometrics\\AE_Lab_04")
Sys.setenv(LANG = "en")
options(scipen = 5)

##########################################################
# Ordered choice Models
#########################################################

# WNE package from Github
install.packages("devtools")
library("devtools")

detach("package:WNE", unload = TRUE)
install_github("Rand-0/WNE")
library(WNE)

# install.packages("pscl")
# install.packages("ucminf")
# install.packages("ordinal")
# install.packages("reshape")
# install.packages("generalhoslem")
# install.packages("oglmx")
# install.packages("brant")
# install.packages("aod")


library("sandwich")
library("zoo")
library("lmtest")
library("MASS")
library("pscl")
library("LogisticDx")
library("ucminf")
library("ordinal")
library("reshape")
library("generalhoslem")
library("oglmx")
library("aod")
library("brant")


# ------------------------------------------
# Exercise 1
# ------------------------------------------
# Exercise 1
# We illustrate the ordered probit and logit techniques with a model of corporate bond ratings. The
# dataset ratings.csv contains information on 98 U.S. corporations’ bond ratings and financial char-
# acteristics where the bond ratings are AAA (excellent) to C (poor). The integer codes underlying
# the ratings increase in the quality of the firm’s rating, such that an increase in the response variable
# indicates that the firm’s bonds are a more attractive investment opportunity. The bond rating vari-
# able (rating83c) is coded as integers 2-5, with 5 corresponding to the highest quality (AAA) bonds
# to the lowest. We model the 1983 bond rating as a function of the firm’s income-to-asset ratio in
# 1983 (ia83: roughly, return on assets) and the change in that ratio from 1982 to 1983 (dia).
# a) Estimate ordered logit for rating83c.
# b) Are ia83 and dia jointly significant?
# c) Interpret parameters’ coeﬃcients.
# d) Perform goodness-of-fit tests.
# e) Perform the Brant’s test.
# f) Calculate and interpret pseudo-R2 statistics.
# g) Calculate marginal eﬀects and interpret them.
# 
# View(cbind(rat$rating83c, rat$ia83, rat$dia))
# a) Estimate ordered logit for rating83c.
rr = read.csv(file="Ratings.csv", header=TRUE, sep=",")
rr = rep(0, 98)
rr[which(rat$rating83c=="BA_B_C")]=2
rr[rat$rating83c=="BAA"]=3
rr[rat$rating83c=="AA_A"]=4
rr[rat$rating83c=="AAA"]=5

table(rr)
# Estimate ordered logit for \texttt{rating83c}.
# polr from MASS package
ologit = MASS ::polr(as.factor(rr)~ia83+dia, data=rat)
# If I were interested in the ordered probit model
# polr(as.factor(rr)~ia83+dia, data=rat, method = "probit")
summary(ologit)

# ia83
# Coefficient = 0.0939
# Positive sign means higher profitability increases the probability of higher bond ratings.
# Firms with higher income-to-asset ratios are more likely to receive better credit ratings.
# The t-value (3.171) suggests the effect is statistically significant.

# dia
# Coefficient = −0.0867
# Negative sign indicates that increases in the change of profitability slightly reduce the probability of higher rating categories.
# However, the t-value (−1.927) suggests weak statistical significance (close to the 10% level).


# The intercepts reported by polr() are called THRESHOLDS or CUT-POINTS.
# They define boundaries between the ordered rating categories
# on the unobserved (latent) credit quality scale.

# Estimated thresholds:

# 2|3 = -0.185  -> boundary between rating category 2 and 3
# 3|4 =  1.186  -> boundary between rating category 3 and 4
# 4|5 =  1.908  -> boundary between rating category 4 and 5

# Interpretation:

# The ordered logit model assumes there exists an unobserved
# continuous variable representing the firm's latent credit quality.

# Firms are placed on this hidden scale according to:
# latent score = β1 * ia83 + β2 * dia + error

# The thresholds divide this latent scale into rating categories.

# For example:
# if latent score < -0.185      -> rating = category 2
# if -0.185 ≤ score < 1.186     -> rating = category 3
# if 1.186 ≤ score < 1.908      -> rating = category 4
# if score ≥ 1.908              -> rating = category 5

# These threshold parameters are not interpreted economically.
# They simply determine the boundaries used to calculate the
# probabilities of each rating category in the ordered logit model.


# b) Statistical significance of coefficients
lmtest::coeftest(ologit)
# The function lmtest::coeftest() provides statistical tests
# for the coefficients of the ordered logit model.
# Null hypothesis for each variable:
# H0: coefficient = 0 (the variable has no effect on bond ratings)
# ia83:
# Estimate = 0.0939
# Std. Error = 0.0296
# t-value = 3.17
# p-value = 0.002

# Interpretation:
# The coefficient for ia83 (income-to-asset ratio) is positive and
# statistically significant at the 1% level. This indicates that
# higher profitability increases the probability of higher bond ratings.

# dia:
# Estimate = -0.0867
# Std. Error = 0.0450
# t-value = -1.93
# p-value = 0.057

# Interpretation:
# The coefficient for dia (change in income-to-asset ratio) is negative
# and only marginally significant at the 10% level. This suggests weak
# evidence that increases in this variable reduce the probability of
# higher bond ratings.

# Significance codes:
# ***  p < 0.001
# **   p < 0.01
# *    p < 0.05
# .    p < 0.10
# blank = not statistically significant

# Conclusion:
# The variable ia83 significantly affects corporate bond ratings,
# while dia shows weaker statistical evidence of an effect.

# b) Are ia83 and dia jointly significant?
# We test the hypothesis:
#   H₀ (null hypothesis):
#   ia83 = 0 and dia = 0
# H₁ (alternative):
#   At least one of them is not 0
# Are \texttt{ia83} and \texttt{dia} jointly significant?
# Likelihood ratio test
library(MASS)
library(lmtest)
ologit.restricted = MASS::polr(as.factor(rr)~1, data=rat)

lmtest::lrtest(ologit, ologit.restricted)

# Results:
# LogLik (unrestricted model) = -127.27
# LogLik (restricted model)   = -133.04

# LR statistic = 11.542
# Degrees of freedom = 2
# p-value = 0.0031

# Hypotheses:
# H0: β_ia83 = β_dia = 0   (variables have no effect on ratings)
# H1: At least one coefficient ≠ 0

# Interpretation:
# Since the p-value (0.0031) is less than 0.05, we reject the null hypothesis.

# Conclusion:
# The variables ia83 and dia are jointly statistically significant
# in explaining corporate bond ratings.

# d) Perform goodness-of-fit tests.
# Goodness-of-fit tests
# install.packages("generalhoslem")
library(generalhoslem)
lipsitz.test(ologit)
# It compares:
# what the model predicts
# what the data actually shows
# Lipsitz test checks whether the ordered logit model fits the data well.
# The Lipsitz test is similar to the Hosmer–Lemeshow test, 
# but it is designed for ordered logit/probit models.
# Hypotheses:
# H0: Model fits the data well
# H1: Model does not fit the data well

# Output:
# LR statistic = 12.514
# df = 9
# p-value = 0.1859

# Decision rule:
# If p-value < 0.05 → poor model fit
# If p-value > 0.05 → model fits the data

# Interpretation:
# Since p-value = 0.1859 > 0.05,
# we do not reject H0.

# The ordered logit model provides an adequate fit to the data.
logitgof(rat$rating83c, fitted(ologit), g = 5, ord = TRUE)
# The Hosmer–Lemeshow test compares observed rating categories
# with predicted probabilities from the ordered logit model.
# Your ordered logit model predicts probabilities for each category.
# Now we look at the real data.
# Maybe the person’s actual health category = good.
# The test checks this for many people.
# It asks:Are the model’s predicted probabilities close to what we actually observe?
# Hypotheses:
# H0: Model fits the data well
# H1: Model does not fit the data well

# Results:
# X-squared = 88.61
# df = 11
# p-value = 3.12e-14

# Decision rule:
# If p-value < 0.05 → reject H0

# Interpretation:
# Since p-value is extremely small (< 0.05),
# we reject the null hypothesis.

# Conclusion:
# According to the Hosmer–Lemeshow test,
# the ordered logit model does not fit the data well.
ologit = MASS ::polr(as.factor(rr)~ia83+dia, data=rat)
pred_prob <- predict(ologit, type = "probs")

# This line:
#   looks at each row of predicted probabilities
# finds the largest probability
# returns the health category with that highest probability
pred_class <-colnames(pred_prob)[apply(pred_prob, 1, which.max)]


table(
  Predicted = pred_class,
  Actual = ologit$model$`as.factor(rr)`
)
# The model rarely thinks category 4 is the most likely outcome.


# e) Perform the Brant’s test.
# Brant's test
# the function works with polr model results
# install.packages("brant")

library(brant)
brant(ologit)
# The Brant test checks whether the proportional odds
# assumption of the ordered logit model holds.

# Ordered logit assumes that explanatory variables have the SAME effect
# across all rating thresholds.

# Ordered logit works using cumulative comparisons between rating levels.
# With 4 rating categories (BA_B_C, BAA, AA_A, AAA) the model estimates
# three thresholds:

# 1) BA_B_C vs (BAA, AA_A, AAA)
# 2) (BA_B_C, BAA) vs (AA_A, AAA)
# 3) (BA_B_C, BAA, AA_A) vs AAA

# The parallel regression assumption means that the effect of the
# explanatory variables is the same in all three comparisons.

# Parallel regression assumption means that the effect of each variable
# (e.g., ia83 or dia) is constant across these comparisons.


# H0: Parallel regression assumption holds
# H1: Assumption is violated

# Results:
# Omnibus test: X2 = 68.74, p = 0.000

# Since p < 0.05, we reject H0.
# Therefore, the proportional odds assumption is violated.

# Variable-specific tests:
# ia83: X2 = 14.24, p = 0.000 → assumption violated
# dia:  X2 = 1.10,  p = 0.58  → assumption holds

# Conclusion:
# The violation is mainly caused by ia83, suggesting that
# the effect of profitability differs across rating thresholds.

# As stated at:
# https://stats.idre.ucla.edu/stata/dae/ordered-logistic-regression/
# A significant test statistic provides evidence that the parallel
# regression assumption has been violated.
# 
# Significant result for ia83 indicates violation of the proportional
# odds assumption.
# The omnibus test results confirms violation of the assumption.
# We should apply a more advanced method.
# Generalized ordered logit model
# The stereotype model
# The continuation ratio model
# Cumulative Probit Models
# Cumulative Log-Log Links

# Pseudo-R2 statistics
# install.packages("pscl")
library(pscl)
pR2(ologit)

# f) Pseudo-R2 statistics
# The pR2() function calculates pseudo-R2 measures for the ordered logit model.
# These statistics compare the fitted model with a null model
# that contains no explanatory variables.

# Output:
# llh      = -127.27  (log-likelihood of the estimated model)
# llhNull  = -133.04  (log-likelihood of the null model)
# G2       = 11.54    (likelihood ratio statistic)
# McFadden = 0.0434   (McFadden pseudo-R2)
# r2ML     = 0.1111   (McKelvey–Zavoina / ML pseudo-R2)
# r2CU     = 0.1190   (Cragg–Uhler / Nagelkerke pseudo-R2)

# Interpretation:

# The likelihood ratio statistic (G2 = 11.54) measures the improvement
# of the model with explanatory variables compared to the null model.

# McFadden pseudo-R2 = 0.043 indicates that the model improves the
# likelihood by about 4.3% relative to the null model.

# Note:
# Pseudo-R2 values are usually much smaller than OLS R2 values
# and should not be interpreted as "percentage of variance explained".

# Conclusion:
# The explanatory variables ia83 and dia provide some improvement
# in explaining corporate bond ratings compared with a model without predictors.

# g) Calculate marginal eﬀects and interpret them.
# Marginal effects show how a small change in an explanatory variable
# affects the probability of each rating category.

# In ordered logit models, coefficients do NOT directly give probability
# changes. Therefore we compute marginal effects.

# Example using the margins package:
# install.packages("margins")
library(margins)

margins::margins(ologit)
#     ia83     dia
# -0.01725 0.01592
# ia83 (income-to-asset ratio)
# The negative marginal effect (-0.01725) means that an increase in ia83
# reduces the probability of lower bond rating categories and shifts
# probability toward higher rating categories.

# dia (change in income-to-asset ratio)
# The positive marginal effect (0.01592) means that an increase in dia
# slightly increases the probability of lower rating categories and
# decreases the probability of higher rating categories.

# Conclusion:
# Higher profitability (ia83) improves the likelihood of better bond
# ratings, while increases in dia slightly shift probability toward
###############################################################
# positive coefficient → move probability to higher categories
# negative coefficient → move probability to lower categories

# Predicted probabilities at observed values
p0 <- predict(ologit, type = "probs")

# Create a copy of data with ia83 increased a little
rat2 <- rat
rat2$ia83 <- rat2$ia83 + 0.01

# Predicted probabilities after small increase in ia83
p1 <- predict(ologit, newdata = rat2, type = "probs")

# Approximate marginal effects for ia83
me_ia83 <- colMeans((p1 - p0) / 0.01)
me_ia83


rat3 <- rat
rat3$dia <- rat3$dia + 0.01

p2 <- predict(ologit, newdata = rat3, type = "probs")

me_dia <- colMeans((p2 - p0) / 0.01)
me_dia
# Marginal effects of dia on rating probabilities:

# BA_B_C (rating 2):  +0.0159
# BAA   (rating 3):  +0.0034
# AA_A  (rating 4):  -0.0032
# AAA   (rating 5):  -0.0161

# Interpretation:
# A small increase in dia increases the probability of lower
# bond ratings (BA_B_C and BAA) and decreases the probability
# of higher ratings (AA_A and AAA).

# Therefore, increases in dia shift probability from higher
# credit ratings toward lower ratings.


margins::margins(ologit)
# ia83     dia
# -0.01725 0.01592
#######################
# > me_ia83
# 2            3            4            5 
# -0.017242919 -0.003702440  0.003492586  0.017452772 
# > me_dia
# 2            3            4            5 
# 0.015922418  0.003409892 -0.003227365 -0.016104945
#######################

summary(margins::margins(ologit))

library(marginaleffects)
avg_slopes(ologit, type = "probs")

# Term Group Estimate Std. Error     z Pr(>|z|)    S     2.5 %    97.5 %
# dia      2  0.01592    0.00807  1.97   0.0484  4.4  0.000113  0.031727
# dia      3  0.00341    0.00241  1.41   0.1572  2.7 -0.001316  0.008143
# dia      4 -0.00323    0.00187 -1.73   0.0840  3.6 -0.006885  0.000433
# dia      5 -0.01611    0.00815 -1.98   0.0480  4.4 -0.032076 -0.000139
# ia83     2 -0.01725    0.00520 -3.31   <0.001 10.1 -0.027444 -0.007048
# ia83     3 -0.00370    0.00200 -1.85   0.0640  4.0 -0.007611  0.000215
# ia83     4  0.00349    0.00153  2.29   0.0220  5.5  0.000505  0.006484
# ia83     5  0.01745    0.00484  3.61   <0.001 11.7  0.007966  0.026933

# Interpretation of ia83 (income to asset ratio)
# ia83 = income-to-asset ratio (profitability).
# Rating	Marginal effect	Interpretation
# BA_B_C (2)	-0.01725	reduces probability of lowest rating
# BAA (3)	-0.00370	small decrease
# AA_A (4)	+0.00349	increases probability
# AAA (5)	+0.01745	increases probability of best rating

# ------------------------------------------
# Exercise 2
# ------------------------------------------
# Let’s analyse variable coding health status of respondents (hstatus). 
# The variable takes three values:
# 1 for a person with bad health, 
# 2 for moderate health, 
# and 3 for good health status. Covariates for
# the dependent variable are: income, female – a binary variable (1 for women), black, and num–
# family size.
# a) Why shouldn’t we use a logit/probit model for this problem?
# b) Estimate an ordered logit for health status with covariates mentioned above.
# c) Determine and interpret pseudo-R2 statistics.
# d) Are variables in the model jointly significant?
# e) The parameter next to income is equal to−3.39 ∗ 10(−5). Are we allowed to conclude on the basis
# of the value that income is insignificant?
# f) Having parameters estimated determine signs of marginal eﬀects for female and famsize for the
# alternative good health.
# g) Perform goodness-of-fit tests.
# h) Determine and interpret marginal eﬀects for the alternative moderate health.
# i) Determine and interpret marginal eﬀects for the alternative good health.
# j) Verify hypothesis that income aﬀects respondents’ health linearly against the alternative that
# income has nonlinear, cubic impact. Use likelihood ratio test.

# a) Why shouldn’t we use a logit/probit model for this problem?
rd = read.csv(file="Randdata.csv", header=TRUE, sep=",")
# View(rd[1:5,])

rd$health = 0
rd$health[rd$hlthp==1]=1
rd$health[rd$hlthf==1]=2
rd$health[rd$hlthg==1]=3
table(rd$health)
# let's remove erroneous observations
indeksy = which(rd$health==0)
rd = rd[-indeksy,]
table(rd$health)
library(dplyr)
rd %>% group_by(health) %>% summarise(n=n()) %>% 
  ungroup() %>% mutate(total = sum(n), percent = 100*(n/total))
# health     n total percent
# <dbl> <int> <int>   <dbl>
# 1      1   302  9171    3.29
# 2      2  1560  9171   17.0 
# 3      3  7309  9171   79.7
# Estimate ordered logit for hstatus.
ologit <- MASS::polr(as.factor(health) ~ income + female + num, 
               data = rd, 
               Hess = TRUE
               # Hess = TRUE – oblicza macierz Hessego potrzebną do wyznaczenia
               # błędów standardowych współczynników.
               )
summary(ologit)
# Dependent variable:
# health – respondent's health status
# 1 = bad health
# 2 = moderate health
# 3 = good health

# Interpretation of coefficients
# income
# Coefficient = 0.0001159 (positive)
# A higher income increases the probability of being in a higher
# health category (i.e., better health). 

# female
# Coefficient = -0.141
# This is a binary variable (1 = female). The negative coefficient
# suggests that women have a lower probability of being in a higher
# health category compared to men.

# num
# Coefficient = 0.0294
# A larger household size slightly increases the probability of
# being in a higher health category.

# General interpretation rule in ordered logit models:
# positive coefficient  → increases probability of higher categories
# negative coefficient  → increases probability of lower categories

# The model assumes there is an unobserved continuous variable (latent health) behind these categories.
# Think of it like a hidden health score that can take any value from −∞ to +∞.
# Depending on where that score falls, the observed category changes.
# latent health scale
# <-----------|-----------|------------>
#        -2.5789     -0.5273
# 
# Bad        Moderate      Good
# health       health       health
# Threshold parameters (cut-points)
# 1|2 = -2.5789
# threshold separating:
# bad health vs (moderate + good health)
# 2|3 = -0.5273
# threshold separating:
# (bad + moderate health) vs good health
# These parameters define the boundaries between health categories
# on the unobserved latent health scale and are not interpreted
# economically.

# AIC = 10598.14
# These statistics are used to assess and compare model fit.
# Lower AIC values indicate a better-fitting model when
# comparing alternative specifications.

# Pseudo-R2 statistics
rd$health = as.factor(rd$health)
ologit <- MASS::polr( health~ income + female + num, 
                     data = rd, 
                     Hess = TRUE
                     # Hess = TRUE – oblicza macierz Hessego potrzebną do wyznaczenia
                     # błędów standardowych współczynników.
)
pR2(ologit)

pred_prob <- predict(ologit, type = "probs")
pred_class <-colnames(pred_prob)[apply(pred_prob, 1, which.max)]
table(Actual = ologit$model$health, Predicted = pred_class )


pred_prob <- predict(ologit)
table(Actual = ologit$model$health, Predicted = pred_prob )


# Joint significance
# Likelihood ratio test
# rd$health = as.factor(rd$health)
ologit.unrestricted = MASS::polr(health~income+female+num, data=rd)
ologit.restricted = MASS::polr(as.factor(health)~1, data=rd)
lmtest::lrtest(ologit.unrestricted, ologit.restricted)

# Small value of the parameter
summary(ologit)
coeftest(ologit)

# goodness-of-fit tests
logitgof(rd$health, fitted(ologit.unrestricted), g = 10, ord = TRUE)
pulkrob.chisq(ologit.unrestricted, c("female"))
ologit.unrestricted = MASS::polr(health~income+female+num, data=rd)
lipsitz.test(ologit.unrestricted)

# GOODNESS-OF-FIT TESTS FOR ORDERED LOGIT MODEL

# Hosmer–Lemeshow test
# H0: the ordered logit model fits the data well
# H1: the model does NOT fit the data well
# p-value is extremely small (< 0.05), so we reject H0
# Conclusion: the model does NOT fit the data well

# Pulkstenis–Robinson test
# H0: the ordered logit model fits the data well
# H1: the model does NOT fit the data well
# p-value = 0.00124 (< 0.05), so we reject H0
# Conclusion: the model does NOT fit the data well

# Lipsitz test
# H0: the ordered logit model fits the data well
# H1: the model does NOT fit the data well
# p-value is very small (< 0.05), so we reject H0
# Conclusion: the model does NOT fit the data well

# Overall conclusion:
# All three tests suggest that the ordered logit model
# does not describe the data well. The model may be missing
# important variables or the specification may be incorrect.

# marginal effects
options(scipen=999)
model = MASS::polr(as.factor(health)~income+female+num, data=rd, method="logistic")
summary(model)

margins::margins(model)
# income   female        num
# -0.00000367 0.004463 -0.0009308

# marginal effects for a user-defined characteristics
# this function works with polr models
model = MASS::polr(as.factor(health)~income+female+num, data=rd, method="logistic")
margins::margins(model,
        at = list(
          income = mean(rd$income),
          female = mean(rd$female),
          num = mean(rd$num)
        ))

# at(income) at(female)   at(num)       income   female        num
# 7506     0.5606          3.897 -0.000003347 0.004071 -0.0008489

#      income   female        num
# -0.000003347 0.004071 -0.0008489

# income   female        num
# -0.00000367 0.004463 -0.0009308

# Marginal effects at mean covariate values

# Covariate values used:
# income = 7506 (mean income)
# female = 0.5606
# num = 3.897 (mean household size)

# Marginal effects:
# income = -0.000003347
# female = 0.004071
# num = -0.0008489

# Interpretation:
# Higher income slightly shifts probability toward higher health categories.
# Being female slightly increases the probability of lower health categories.
# Larger household size slightly increases the probability of higher health categories.

p0 <- predict(model, type = "probs")
p0
rd2 <- rd
rd2$income <- rd2$income + 1
p1 <- predict(model, newdata = rd2, type = "probs")
me_income <- colMeans(p1 - p0)
me_income
#               1               2               3 
# -0.000003669405 -0.000014480575  0.000018149981 

# income     1    dY/dX -0.00000367 0.000000247 -14.86   <0.001 163.4 -0.00000415 -0.00000319
# income     2    dY/dX -0.00001448 0.000001223 -11.84   <0.001 105.0 -0.00001688 -0.00001208
# income     3    dY/dX  0.00001815 0.000001439  12.61   <0.001 118.8  0.00001533  0.00002097
# The marginal effects show that a one-unit increase in income slightly 
# decreases the probabilities of bad and moderate health and increases the probability 
# of good health. 
# Thus, higher income shifts probability toward better health outcomes.

# base probability 
p0 <- predict(model, type = "probs")

# change to female na 1
# rd2 <- rd
# rd2$female <- 1
# p1 <- predict(model, newdata = rd2, type = "probs")
# # marginal effect (1 vs 0)
# me_female <- colMeans(p1 - p0)
# me_female
# 1. Przygotowanie dwóch identycznych zbiorów danych
data_f0 <- rd
data_f1 <- rd

# 2. Wymuszenie konkretnych wartości dla zmiennej binarnej
data_f0$female <- 0
data_f1$female <- 1

# 3. Przewidywanie prawdopodobieństw (wynikiem są macierze)
# Każda kolumna to jedna kategoria odpowiedzi (np. "low", "med", "high")
p0 <- predict(model, newdata = data_f0, type = "probs")
p1 <- predict(model, newdata = data_f1, type = "probs")

# 4. Obliczenie różnic (macierz - macierz)
diff <- p1 - p0

# 5. Średnia z różnic dla każdej kategorii (kolumny)
me_female <- colMeans(diff)

print(me_female)
avg_slopes(model, type = "probs")
# 1            2            3 
# 0.004415934  0.017559592 -0.021975526  
# female     1    1 - 0  0.00441593 0.000152932  28.88   <0.001 606.6  0.00411619  0.00471567
# female     2    1 - 0  0.01755959 0.000561726  31.26   <0.001 710.2  0.01645863  0.01866056
# female     3    1 - 0 -0.02197553 0.000593775 -37.01   <0.001 993.6 -0.02313930 -0.02081175
# marginal effects on probabilities of each outcome

avg_slopes(model, type = "probs")


# income ↑  → move right → better health
# female=1  → move left  → worse health
# num ↑     → move right → better health



################################################################################
# income affects cubicly than linearly
rd$income2 = rd$income^2
rd$income3 = rd$income^3

# likelihood ratio test
model_R = polr(as.factor(health)~income+female+num, data=rd)
model_U = polr(as.factor(health)~income+income2+income3+female+num, data=rd)
lrtest(model_U, model_R)
# H0: income2=0 and income3=0
# p-value < 5%, so I reject the null hypothesis


# ------------------------------------------
# Exercise 3
# ------------------------------------------



# ------------------------------------------
# Exercise 4
# ------------------------------------------

nls = read.csv(file="nlsw88.csv", sep=",", header=TRUE)
nls$union[nls$union==""]=NA
nls = na.omit(nls)
View(nls[1:5,])

# let's prepare all variables we will need
nls$white = 0
nls$white[nls$race=="white"] = 1
nls$black = 0
nls$black[nls$race=="black"] = 1
nls$agriculture = 0
nls$business = 0
nls$construction = 0
nls$entertainment = 0
nls$transport = 0
nls$finance = 0
nls$profserv = 0
nls$manufacturing = 0
nls$mining = 0
nls$perserv = 0
nls$public = 0
nls$trade = 0

nls$agriculture[nls$industry=="Ag/Forestry/Fisheries"] = 1
nls$business[nls$industry=="Business/Repair Svc"] = 1
nls$construction[nls$industry=="Construction"] = 1
nls$entertainment[nls$industry=="Entertainment/Rec Svc"] = 1
nls$finance[nls$industry=="Finance/Ins/Real Estate"] = 1
nls$manufacturing[nls$industry=="Manufacturing"] = 1
nls$mining[nls$industry=="Mining"] = 1
nls$perserv[nls$industry=="Personal Services"] = 1
nls$profserv[nls$industry=="Professional Services"] = 1
nls$public[nls$industry=="Public Administration"] = 1
nls$transport[nls$industry=="Transport/Comm/Utility"] = 1
nls$trade[nls$industry=="Wholesale/Retail Trade"] = 1

# Step 1
# general model
reg1 = lm(wage~age+as.factor(race)+married+grade+south+union+hours+
            ttl_exp+tenure+as.factor(industry), data=nls)
summary(reg1)

# test whether all insignificant variables all jointly insignificant
reg1a = lm(wage~age+white+grade+south+union+
             ttl_exp+tenure+construction+transport+finance, data=nls)
anova(reg1, reg1a)
# all insignificant variables are jointly significant
# therefore we have to drop variables in the way one after another
# let's drop "the most insignificant" variable from reg1
# that is Wholesale/Retail trade

# Step 2
reg2 = lm(wage~age+as.factor(race)+married+grade+south+union+
            hours+ttl_exp+tenure+
            agriculture+business+construction+entertainment+
            finance+manufacturing+mining+perserv+profserv+public+
            transport, data=nls)
summary(reg2)
# there are still insignificant variables in reg2 model
# let's drop "the most insignificant" variable from reg2
# that is perserv
# Can we?
# let's check
# let's estimate model reg2 without perserv
# and test joint hypothesis: beta_trade=beta_perserv=0
# in the general model that is model reg1
aux.reg = lm(wage~age+as.factor(race)+married+grade+south+union+
               hours+ttl_exp+tenure+
               agriculture+business+construction+entertainment+
               finance+manufacturing+mining+profserv+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null that
# beta_trade=beta_perserv=0
# in the general model that is model reg1
# therefore: we can drop agriculture in reg2 model

# Step 3
reg3 = lm(wage~age+as.factor(race)+married+grade+south+union+
            hours+ttl_exp+tenure+
            agriculture+business+construction+entertainment+
            finance+manufacturing+mining+profserv+public+
            transport, data=nls)
summary(reg3)
# we would like to drop age from reg3
# to do so, we have to verify joint hypothesis that
# beta_trade=beta_perserv=beta_age=0
aux.reg = lm(wage~as.factor(race)+married+grade+south+union+
               hours+ttl_exp+tenure+
               agriculture+business+construction+entertainment+
               finance+manufacturing+mining+profserv+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null, so age might be dropped from reg3 model

# Step 4
reg4 = lm(wage~as.factor(race)+married+grade+south+union+
            hours+ttl_exp+tenure+
            agriculture+business+construction+entertainment+
            finance+manufacturing+mining+profserv+public+
            transport, data=nls)
summary(reg4)
# we would like to drop agriculture from reg4
# to do so, we have to verify joint hypothesis that
# beta_trade=beta_perserv=beta_age=beta_agriculture=0
aux.reg = lm(wage~as.factor(race)+married+grade+south+union+
               hours+ttl_exp+tenure+
               business+construction+entertainment+
               finance+manufacturing+mining+profserv+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null, so agriculture might be dropped from reg4 model

# Step 5
reg5 = lm(wage~as.factor(race)+married+grade+south+union+
            hours+ttl_exp+tenure+
            business+construction+entertainment+
            finance+manufacturing+mining+profserv+public+
            transport, data=nls)
summary(reg5)
# we would like to drop mining from reg5
# to do so, we have to verify joint hypothesis that
# beta_trade=beta_perserv=beta_age=beta_agriculture=beta_mining=0
aux.reg = lm(wage~as.factor(race)+married+grade+south+union+
               hours+ttl_exp+tenure+
               business+construction+entertainment+
               finance+manufacturing+profserv+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null, so minig might be dropped from reg5 model

# Step 6
reg6 = lm(wage~as.factor(race)+married+grade+south+union+
            hours+ttl_exp+tenure+
            business+construction+entertainment+
            finance+manufacturing+profserv+public+
            transport, data=nls)
summary(reg6)
# we would like to drop profserv from reg6
# to do so, we have to verify joint hypothesis that
# beta_trade=beta_perserv=beta_age=beta_agriculture=beta_mining=beta_profserv=0
aux.reg = lm(wage~as.factor(race)+married+grade+south+union+
               hours+ttl_exp+tenure+
               business+construction+entertainment+
               finance+manufacturing+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null, so profserv might be dropped from reg6 model

# Step 7
reg7 = lm(wage~as.factor(race)+married+grade+south+union+
            hours+ttl_exp+tenure+
            business+construction+entertainment+
            finance+manufacturing+public+
            transport, data=nls)
summary(reg7)
# we would like to drop hours from reg7
# to do so, we have to verify joint hypothesis that
# beta_trade=beta_perserv=beta_age=beta_agriculture=beta_mining=beta_profserv=
# =beta_hours=0
aux.reg = lm(wage~as.factor(race)+married+grade+south+union+
               ttl_exp+tenure+
               business+construction+entertainment+
               finance+manufacturing+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null, so hours might be dropped from reg7 model

# Step 8
reg8 = lm(wage~as.factor(race)+married+grade+south+union+
            ttl_exp+tenure+
            business+construction+entertainment+
            finance+manufacturing+public+
            transport, data=nls)
summary(reg8)
# we would like to drop married from reg8
# to do so, we have to verify joint hypothesis that
# beta_trade=beta_perserv=beta_age=beta_agriculture=beta_mining=beta_profserv=
# =beta_hours=beta_married=0
aux.reg = lm(wage~as.factor(race)+grade+south+union+
               ttl_exp+tenure+
               business+construction+entertainment+
               finance+manufacturing+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null, so married might be dropped from reg8 model

# Step 9
reg9 = lm(wage~as.factor(race)+grade+south+union+
            ttl_exp+tenure+
            business+construction+entertainment+
            finance+manufacturing+public+
            transport, data=nls)
summary(reg9)
# we would like to drop race:other from reg9
# to do so, we have to verify joint hypothesis that
# beta_profserv=beta_agriculture=beta_age=beta_mining=beta_perserv=
# =hours=trade=married=race:other=0
aux.reg = lm(wage~black+grade+south+union+
               ttl_exp+tenure+
               business+construction+entertainment+
               finance+manufacturing+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null, so race:other might be dropped from reg9 model

# Step 10
reg10 = lm(wage~black+grade+south+union+
             ttl_exp+tenure+
             business+construction+entertainment+
             finance+manufacturing+public+
             transport, data=nls)
summary(reg10)
# we would like to drop entertainment from reg10
# to do so, we have to verify joint hypothesis that
# beta_profserv=beta_agriculture=beta_age=beta_mining=beta_perserv=
# =hours=trade=married=race:other=0
aux.reg = lm(wage~black+grade+south+union+
               ttl_exp+tenure+
               business+construction+
               finance+manufacturing+public+
               transport, data=nls)
anova(reg1, aux.reg)
# we cannot reject the null, so entertainment might be dropped from reg10 model

# Step 11
reg11 = lm(wage~black+grade+south+union+
             ttl_exp+tenure+
             business+construction+
             finance+manufacturing+public+
             transport, data=nls)
summary(reg11)
# All variables are significant in this step, so
# this ends general-to-specific procedure.


# ------------------------------------------
# Exercise 5
# ------------------------------------------


