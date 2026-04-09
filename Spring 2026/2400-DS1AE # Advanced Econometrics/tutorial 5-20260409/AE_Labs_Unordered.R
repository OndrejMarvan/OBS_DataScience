###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#                                                                         #
#                 Labs 05: Unordered choice models                        #
#                                                                         #
###########################################################################


Sys.setenv(LANG = "en")
# setwd("C:\\Users\\Hp\\WNE\\Advanced_Econometrics\\AE_Lab_05")

library("sandwich")
library("zoo")
library("lmtest")
library("MASS")
library("aod")

# install.packages("nnet")
library("nnet")

library("Formula")
library("miscTools")
library("maxLik")
# install.packages("mlogit")
library("mlogit")
library("car")
library("survival")
#install.packages("AER")
library("AER")
library("stargazer")

# ------------------------------------------
# Lecture slides
# ------------------------------------------

options(scipen = 999)

# ********************************************
# The other way of estimating multinomial 
# logit models
# This method does not allow us to obtain
# marginal effects
# You estimated a multinomial logit model in 
# R where the dependent variable is mode (type of fishing: beach, charter, pier, private).

fish = read.csv(file="Fishing_mode.csv", sep=",", header=TRUE)
# View(fish[1:5,])
fish$mode = as.factor(fish$mode)
fish$income2 = fish$income^2

# descriptive statistics
summary(fish)

# multinomial model
mlogit = multinom(mode~income+income2, data=fish)
summary(mlogit)

# > summary(mlogit)
# Call:
#   multinom(formula = mode ~ income + income2, data = fish)
# 
# Coefficients:
#   (Intercept)     income      income2
# charter   0.8619802  0.2071885 -0.022473520
# pier      1.1011571 -0.3174451  0.018404477
# private   0.6227868  0.1497982 -0.005260256
# 
# Std. Errors:
#   (Intercept)    income    income2
# charter   0.3180882 0.1308082 0.01134261
# pier      0.3411857 0.1437094 0.01216713
# private   0.3196997 0.1262830 0.01026384
# 
# Residual Deviance: 2939.288
# AIC: 2957.288




# This estimates how income affects the probability of choosing each fishing mode.
# Important:
# In multinomial logit, one category becomes the reference group automatically.
# Here the baseline is beach.
# So the model estimates:
# charter vs beach
# pier vs beach
# private vs beach

# statistical significance
z <- summary(mlogit)$coefficients/summary(mlogit)$standard.errors
z

# 2-tailed z test
p <- (1 - pnorm(abs(z), 0, 1)) * 2
p

stargazer(mlogit, type = "text")


# Charter vs Beach
# Variable	Coefficient	Meaning
# income	0.207	higher income increases probability of charter
# income²	-0.022	but the effect decreases at higher incomes
# This suggests diminishing returns of income.
# People with higher income initially prefer charter, but the increase slows.
# Statistical significance:
# income → not significant (p=0.113)
# income² → significant (p=0.048)
# So the nonlinear effect matters.


# Pier vs Beach
# Variable	Coefficient	Meaning
# income	-0.317	higher income reduces probability of pier
# income²	0.018	curvature
# Significance:
#   income → significant (p=0.027)
# income² → not significant
# Interpretation:
#   Higher-income individuals are less likely to fish from piers compared to beaches.
# 
# Private vs Beach
# None of the income effects are statistically significant.
# Meaning:
#   Income doesn't strongly explain choosing private vs beach.

# ********************************************
# The easy way to obtain marginal effects are
# presented in Exercise 1


# ------------------------------------------
# Exercise 1
# ------------------------------------------
# Exercise 1
# The dataset consists of 1182 observations on individuals’ choices of how to fish. There are
# Y = four fishing modes (beach, pier, boat, charter), 
# X1 = two alternative specific variables (price and catch), and 
# X2 = one choice/individual specific variable (income)
# 
# a) Estimate a pure multinomial model for mode.
# b) Determine and interpret marginal eﬀects.
# c) Verify the Independence from Irrelevant Alternatives (IIA) assumption.
# d) Check whether alternatives boat and charter might be combined into one category.
# e) Test joint insignificance of all variables in the model.
# f) Interpret pseudo-R2 determined by mlogit function.

# a) Estimate a pure multinomial model for mode.
# multinomial model
data("Fishing", package = "mlogit")

# income in thousands of dollars
Fishing$income = Fishing$income/1000
hist(Fishing$income)
install.packages("psych")
psych::describe(Fishing$income)


# a) Estimate a pure multinomial model for mode choice
# "Pure multinomial" here means that only individual-specific variables
# (like income) explain the choice, and there are no alternative-specific regressors.

# Convert the Fishing dataset from wide format to the format required by mlogit
# - shape = "wide" means the original data has one row per individual
# - choice = "mode" says that the dependent variable indicating the chosen alternative is "mode"
# - varying = 2:9 tells R that columns 2 to 9 contain alternative-specific variables
Fish <- mlogit.data(Fishing, shape="wide", choice="mode", varying=2:9)
head(Fish[1:5,])
head(Fishing[1:5,])

## a pure "multinomial model"
# Estimate a multinomial logit model
# Formula: mode ~ 0 | income
# - Left side: mode is the choice variable
# - "0" means no alternative-specific explanatory variables are included
# - "|" separates alternative-specific variables from individual-specific variables
# - income is an individual-specific variable, so it enters on the right of "|"
# This model explains the probability of choosing each fishing mode as a function of income only
mlogit1 = mlogit(mode ~ 0 | income, data = Fish)
# Turn off scientific notation to make output easier to read
options(scipen = 999)
# Display the standard model summary
# This gives coefficient estimates, standard errors, z-values, and p-values
summary(mlogit1)
# Display the model results in a cleaner regression-table style
# type = "text" prints the table in the console
stargazer(mlogit1, type = "text")

# Compute a data frame with the mean value of income in the sample
# for each alternative
# - with(Fish, ...) lets us use Fish variables directly
# - index(mlogit1)$alt gives the alternative label for each row in the mlogit data
# - tapply(income, index(mlogit1)$alt, mean) computes mean income by alternative
# - data.frame(...) stores the result as a data frame called z
z <- with(Fish, data.frame(income = 
                             tapply(income, index(mlogit1)$alt, mean)))
print(z)


# b) Determine and interpret marginal eﬀects.
# compute the marginal effects for average characteristics
# impact of an additional thousand of dollars
# mode = fishing mode choice (alternatives):
#   beach
# boat
# charter
# pier
# income = individual characteristic
# 0 | income means:
#   income affects utility of each alternative
# no alternative-specific variables in the first part.
# So the model studies:
#   How income affects the probability of choosing each fishing mode.
mlogit1 = mlogit(mode ~ 0 | income, data = Fish)
# How the probability of choosing each alternative changes when income increases by one unit.
# Marginal effects in multinomial logit must sum to zero.
z <- with(Fish, data.frame(income = 
                             tapply(income, index(mlogit1)$alt, mean)))
print(z)
effects(mlogit1, covariate = "income", data = z)
# beach         boat      charter         pier 
# -0.001432654  0.033608044 -0.015806283 -0.016369108 
# The marginal effects show how a change in income affects the probability of 
# choosing each fishing mode. A higher income increases the probability of choosing 
# boat fishing by about 0.033, while decreasing the probability of choosing charter 
# and pier fishing. 
# This suggests that higher-income individuals prefer more expensive fishing modes.

# compute the average marginal effects
# Marginal effects differ for each observation because probabilities differ.
# So we compute:
#   Marginal effect for each observation
# Average them across the sample

AME = matrix(0, nrow=1182, ncol=4)

# nrow = nrow(Fishing) # Fishing not Fish
# ncol = the number of alternatives

for(iter in 1:1182) {
  income = Fish$income[Fish$chid==iter]
  z = data.frame(income = tapply(income, index(mlogit1)$alt[Fish$chid==iter], mean))
  AME[iter, ] = effects(mlogit1, covariate = "income", data = z)
}

# AMEj =average marginal effect across individuals
AvMargEff = colMeans(x=AME)
print(AvMargEff)
# print(AvMargEff)
# 0.0001646645  0.0317561616 -0.0111518637 -0.0207689624

# Multinomial Logit Marginal Effects Summary
#
# In a multinomial logit (MNL) model, coefficients do not directly represent
# the effect of a variable (e.g., income) on choice probabilities because the
# probability function is nonlinear. Therefore we compute marginal effects:
#
#   dP_j / dX
#
# which measure how a small change in X affects the probability of choosing
# alternative j.
#
# The command:
#   effects(mlogit1, covariate = "income", data = z)
#
# calculates the marginal effects for ONE specific observation (the covariate
# values contained in 'z'). Because probabilities must sum to 1 across all
# alternatives, marginal effects across alternatives must sum to zero.
#
# In contrast, the loop:
#
#   for(iter in 1:1182) {
#       income = Fish$income[Fish$chid==iter]
#       z = data.frame(income = tapply(income,
#                     index(mlogit1)$alt[Fish$chid==iter], mean))
#       AME[iter, ] = effects(mlogit1, covariate = "income", data = z)
#   }
#   AvMargEff = colMeans(AME)
#
# computes marginal effects for each observation (each choice situation),
# stores them, and then averages them across all individuals.
#
# This produces Average Marginal Effects (AME), which represent the average
# change in the probability of choosing each alternative when income
# increases by one unit in the sample.
#
# AMEs are typically preferred in empirical analysis because marginal effects
# in nonlinear models depend on individual covariate values.

# c) Verify the Independence from Irrelevant Alternatives (IIA) assumption.
# independence from irrelevant alternatives assumption
# Independence of Irrelevant Alternatives (IIA) Test in Multinomial Logit
#
# The multinomial logit model relies on the IIA assumption, which states that
# the relative odds of choosing between any two alternatives are independent
# of the presence or characteristics of other alternatives.
#
# Example implication: the odds of choosing "beach" over "boat" should not
# change if another alternative (e.g., "pier") is removed from the choice set.
#
# To test the IIA assumption we use the Hausman-McFadden test (hmftest).
# The idea is to compare:
#   - a model estimated with the full set of alternatives
#   - a model estimated with a subset of alternatives
#
# If the IIA assumption holds, removing an alternative should not
# significantly change the estimated coefficients.
#
# Models estimated:
#
# mlogit1 : Full model (all alternatives, reference = "beach")
# mlogit2 : Subset without "pier"
# mlogit3 : Subset without "charter"
# mlogit4 : Subset without "boat"
# mlogit5 : Full model with different reference level ("pier")
# mlogit6 : Subset without "beach"
#
# The Hausman-McFadden tests compare coefficient stability:
#
# hmftest(mlogit1, mlogit2)  # tests if removing "pier" violates IIA
# hmftest(mlogit1, mlogit3)  # tests if removing "charter" violates IIA
# hmftest(mlogit1, mlogit4)  # tests if removing "boat" violates IIA
# hmftest(mlogit5, mlogit6)  # additional robustness check with different reference
#
# Hypotheses:
#   H0: IIA assumption holds (coefficients are consistent across models)
#   H1: IIA assumption is violated
#
# Interpretation:
#   - If the p-value is large -> fail to reject H0 -> IIA likely holds
#   - If the p-value is small -> reject H0 -> IIA likely violated
#
# If IIA is violated, alternative models such as nested logit,
# mixed logit, or multinomial probit may be more appropriate.
# Estimate multinomial logit model with all fishing alternatives
# Choice variable: mode
# Explanatory variable: income (individual-specific)
# No alternative-specific intercepts (0)
# Reference alternative: "beach"
mlogit1 = mlogit(mode ~ 0 | income, data = Fish, reflevel="beach")

# Estimate model excluding the "pier" alternative
# Used to test IIA by comparing with the full model (mlogit1)
mlogit2 = mlogit(mode ~ 0 | income, data = Fish, reflevel="beach",
                 alt.subset=c("beach", "boat", "charter"))

# Estimate model excluding the "charter" alternative
# Used to check whether removing "charter" changes coefficients (IIA test)
mlogit3 = mlogit(mode ~ 0 | income, data = Fish, reflevel="beach",
                 alt.subset=c("beach", "boat", "pier"))

# Estimate model excluding the "boat" alternative
# Another restricted model for IIA testing
mlogit4 = mlogit(mode ~ 0 | income, data = Fish, reflevel="beach",
                 alt.subset=c("beach", "charter", "pier"))

# Re-estimate the full model but with a different reference alternative ("pier")
# This is done as a robustness check for the IIA test
mlogit5 = mlogit(mode ~ 0 | income, data = Fish, reflevel="pier")

# Estimate restricted model excluding "beach"
# Compared with mlogit5 to test IIA under a different reference category
mlogit6 = mlogit(mode ~ 0 | income, data = Fish, reflevel="pier",
                 alt.subset=c("pier", "charter", "boat"))
# compute the test
# 1.
hmftest(mlogit1, mlogit2) # pier alternative H0: it does not violate the IIA assumption
# Removing pier does not significantly change the coefficients, so the IIA assumption holds in this comparison.
# 2. 
hmftest(mlogit1, mlogit3) # H0: charter does not violate the assumption
# Removing charter significantly changes the coefficients, so the IIA assumption is violated.
# This suggests charter is not independent of the other alternatives.
# 3. 
hmftest(mlogit1, mlogit4) # H0: boat alt. does not violate the IIA
# Removing boat does not violate IIA.
# 4. 
hmftest(mlogit5, mlogit6)
# Fail to reject H0
# IIA also holds when using pier as the reference alternative.

# d) Check whether alternatives boat and charter might be combined into one category
# let's test the hypothesis that private boat and charter boat 
# alternatives might be combined into one category
# i.e. non-constant variables' parameters in these categories
# are equal to themselves
#
# here: boat:beta_income=charter:beta_income

# H0: income:boat = income:charter
# H0: income:boat - income:charter = 0

linearHypothesis(model=mlogit1, c("income:boat=income:charter"))

# we have to reject the null, that private boat and charter boat
# alternatives cannot be combined into one category


# let's test the hypothesis that private boat, charter boat and pier
# alternatives might be combined into one category
# i.e. non-constant variables' parameters in these categories
# are equal to themselves
#
# here: boat:beta_income=charter:beta_income=pier:beta_income

# H0: income:boat = income:charter
#     income:charter = income:pier
# H0: income:boat - income:charter = 0
#     income:charter - income:pier = 0

linearHypothesis(model=mlogit1, c("income:boat = income:charter", 
                                  "income:charter = income:pier"))
# Conclusion?

# e) Test joint insignificance of all variables in the model.
# Joint insignificance test of all regressors in the multinomial choice model
#
# H0: all slope coefficients are jointly equal to 0
#     -> the explanatory variables (here: income) have no effect on choice
# H1: at least one coefficient is different from 0
#
# We use a likelihood ratio (LR) test:
#   LR = 2 * (LogLik_unrestricted - LogLik_restricted)
#
# Unrestricted model: multinomial logit with income
mlogit1 = mlogit(mode ~ 0 | income, data = Fish)

# Restricted model: intercept-only model (no explanatory variables)
# chid is removed because multinom() requires standard data format
Fish$chid = NULL
mlogitr = multinom(mode ~ 1, data = Fishing)

# Compare unrestricted and restricted models
lrtest(mlogit1, mlogitr)

# Output:
# Model 1 (with income):    LogLik = -1477.2
# Model 2 (restricted):     LogLik = -1497.7
# LR statistic = 41.145
# p-value = 6.093e-09
#
2 * (-1477.2 - (-1497.7))
pchisq(41.145, df = 3, lower.tail = FALSE)

# LR statistic and degrees of freedom
LR = 41.145
df = 3

# create range for chi-square distribution
x = seq(0, 50, length = 1000)
LR = 41.145
df = 3

# plot chi-square density
plot(x, dchisq(x, df),
     type = "l",
     lwd = 2,
     main = "Likelihood Ratio Test",
     xlab = "Chi-square statistic",
     ylab = "Density")

# add vertical line for LR statistic
abline(v = LR, col = "red", lwd = 2)

# shade p-value area
polygon(c(LR, x[x > LR], max(x)),
        c(0, dchisq(x[x > LR], df), 0),
        col = "pink")

# compute p-value
pchisq(LR, df = df, lower.tail = FALSE)
# Decision:
# Since p-value < 0.05, we reject H0.
#
# Conclusion:
# The explanatory variables are jointly significant.
# In particular, income is jointly insignificant; it helps explain
# the choice of fishing mode.
#
# Note:
# The warning appears because lrtest() compares two models estimated by
# different functions/classes ("mlogit" vs "multinom").
# The LR result is still commonly used here, but ideally both models
# would be estimated within the same framework.

################################################################################
# 'impure' conditional logit
# This is called an “impure conditional logit” because it includes two types of variables:
# Alternative-specific	price, catch	vary across fishing alternatives
# Individual-specific	income	same for all alternatives but interacts with alternatives
mlogit1 = mlogit(mode ~ price+catch | income, data = Fish)
summary(mlogit1)

# Observed choices in the dataset:
# Mode	Share
# beach	11.3%
# boat	35.4%
# charter	38.2%
# pier	15.1%
# Reference alternative: beach
# Coefficient	Meaning
# (Intercept):boat = 0.527	boat preferred to beach
# (Intercept):charter = 1.694	charter strongly preferred to beach
# (Intercept):pier = 0.778	pier preferred to beach

# price = -0.0251 ***
# Interpretation:
# Higher price reduces the probability of choosing that fishing mode.
# Highly significant (p < 0.001).
# Economic meaning:People are price sensitive when choosing fishing modes.

# catch = 0.3578 **
# Higher expected catch increases the probability of choosing that alternative.
# Significant at the 1% level.
# Economic meaning:
# People prefer fishing modes with higher expected catch.

# 1. Price
# Higher prices discourage choosing that fishing alternative.
# 2. Expected catch
# People prefer alternatives with higher expected catch.
# 3. Income differences
# Higher-income individuals are less likely to fish from piers.
# 4. Intrinsic attractiveness of alternatives
# Boat and charter fishing are generally more attractive than beach fishing.


# marginal effects
z <- with(Fish, data.frame(price = tapply(price, index(mlogit1)$alt, mean),
                           catch = tapply(catch, index(mlogit1)$alt, mean),
                           income = tapply(income, index(mlogit1)$alt, mean)))
z
# Average marginal effects (AME) of explanatory variables in the multinomial logit

# Marginal effect of income
effects(mlogit1, covariate = "income", data = z)

# Interpretation:
# Measures how a small increase in income changes the probability of choosing
# each fishing alternative (beach, boat, charter, pier), holding other
# variables constant. Since income is individual-specific, its marginal
# effect differs across alternatives.

# Marginal effect of price
effects(mlogit1, covariate = "price", data = z)

# Interpretation:
# Shows how a change in the price of a specific fishing alternative affects
# the probability that this alternative is chosen. Because the estimated
# coefficient of price is negative, increasing price reduces the probability
# of choosing that alternative and shifts probability toward the others.

# Marginal effect of catch rate
effects(mlogit1, covariate = "catch", data = z)

# Interpretation:
# Measures how an increase in expected catch for a fishing mode changes the
# probability of choosing that alternative. Since the catch coefficient is
# positive, higher expected catch increases the probability of choosing that
# fishing mode and reduces the probabilities of the other modes.

# Important property of multinomial logit marginal effects:
# The marginal effects across all alternatives always sum to zero because
# choice probabilities must sum to 1.

# Compute Average Marginal Effects (AME) of income in the multinomial logit model

# Create matrix to store marginal effects for each observation
# 1182 = number of choice situations (individuals)
# 4 = number of alternatives (beach, boat, charter, pier)
AME = matrix(0, nrow=1182, ncol=4)

for(iter in 1:1182){
  
  income = Fish$income[Fish$chid == iter]
  price  = Fish$price[Fish$chid == iter]
  catch  = Fish$catch[Fish$chid == iter]
  
  z = data.frame(
    income = tapply(income, index(mlogit1)$alt[Fish$chid==iter], mean),
    price  = tapply(price,  index(mlogit1)$alt[Fish$chid==iter], mean),
    catch  = tapply(catch,  index(mlogit1)$alt[Fish$chid==iter], mean)
  )
  
  AME[iter,] = effects(mlogit1, covariate="income", data=z)
}

AvMargEff = colMeans(AME)
print(AvMargEff)

AME_catch = array(0, dim = c(1182, 4, 4))

for(iter in 1:1182){
  
  income = Fish$income[Fish$chid == iter]
  price  = Fish$price[Fish$chid == iter]
  catch  = Fish$catch[Fish$chid == iter]
  
  z = data.frame(
    income = tapply(income, index(mlogit1)$alt[Fish$chid == iter], mean),
    price  = tapply(price,  index(mlogit1)$alt[Fish$chid == iter], mean),
    catch  = tapply(catch,  index(mlogit1)$alt[Fish$chid == iter], mean)
  )
  
  AME_catch[iter, , ] = effects(mlogit1, covariate = "catch", data = z)
}

# Average over individuals
AvMargEff_catch = apply(AME_catch, c(2, 3), mean)
print(AvMargEff_catch)

# f) Interpret pseudo-R2 determined by mlogit function.

# confusuon matrix
prob = as.data.frame(fitted(mlogit1, type = "prob"))
pred_choice = colnames(prob)[apply(prob, 1, which.max)]
table(pred_choice )
actual_choice <- index(Fish)$alt[Fish$mode == TRUE]
head(actual_choice)
cm = table(actual_choice, pred_choice)

cm_percent = round(prop.table(cm, 1) * 100, 2)
cm_percent <- cbind(cm_percent, RowSum = rowSums(cm_percent))
cm_percent

round(prop.table(cm) * 100, 2)

library(performance)
r2(mlogit)

# The McFadden pseudo-R2
# equals 0.019, indicating that the model with explanatory variables provides 
# a substantially better fit than the intercept-only model. In discrete choice models, 
# values between 0.1 and 0.4 are generally considered to represent a good fit.

# ------------------------------------------
# Exercise 2
# ------------------------------------------
# Exercise 2
# We observe 1822 purchases, covering 104 weeks and 5 stores, in which a consumer pur-
# chased 2-liter bottles of either Pepsi (34.6%), 7-Up (37.4%). or Coke Classic (28%). These
# data are in the file cola.csv. In the sample, the average price of Pepsi was $1.23, of 7-Up
# $1.12, and of Coke $1.21. We estimate the conditional logit model that choices depend on
# price, feature, and display variables.
# Observed variables:price, feature (promotion in flyer), display (special store display)
# a) Why shouldn’t we use a multinomial logit model for this problem?
# b) Estimate a conditional logit model for soda choice with covariates mentioned above.
# c) Determine and interpret pseudo-R2 statistics.
# d) Are variables in the model jointly significant?
# e) Determine and interpret marginal eﬀects for price.
# f) Determine and interpret marginal eﬀects for display.

# a) Why shouldn’t we use a multinomial logit model for this problem?

# A Multinomial Logit (MNL) model assumes explanatory variables are 
# individual-specific (same for all alternatives).
# But in this dataset, explanatory variables are alternative-specific:
# Meaning:
# price differs across alternatives
# display differs across alternatives
# feature differs across alternatives
# Standard MNL cannot correctly handle these variables, because they vary within the choice set.
# Therefore we use the Conditional Logit Model (McFadden 1974) where utility depends on attributes of each alternative.
# Therefore we use the Conditional Logit Model (McFadden, 1974),
# where utility depends on attributes of each alternative.

# Utility function:
# U_ij = β1 * price_ij + β2 * feature_ij + β3 * display_ij + ε_ij
#
# where:
# i = individual (purchase occasion)
# j = alternative (Pepsi, 7-Up, Coke)
# price_ij, feature_ij, display_ij are alternative-specific variables.

# Choice probability:
# P_ij = exp(β X_ij) / sum_{k=1}^J exp(β X_ik)
#
# This gives the probability that individual i chooses alternative j
# among J alternatives.

# b) Estimate a conditional logit model for soda choice with covariates mentioned above.
# 'pure' conditional logit -- cola dataset
cola = read.csv(file='cola.csv', sep=",", header=TRUE)
cola[1:5,]

# data preparation
cola$soda = 0
cola$soda[cola$pepsi==1] = 'pepsi'
cola$soda[cola$coke==1] = 'coke'
cola$soda[cola$sevenup==1] = 'sevenup'
head(cola)

names(cola) = c("id","pepsi","sevenup","coke","price.pepsi","price.sevenup","price.coke",
                "feat.pepsi","feat.sevenup","feat.coke",
                "disp.pepsi","disp.sevenup","disp.coke","soda")
# names with "." are necessary for mlogit.data function

# mlogit.data
cola2 <- mlogit.data(cola, shape="wide", choice="soda", varying=5:13)
head(cola2)
# varying - which variables are case-sensitive

# 'pure' conditional logit model
# Estimate conditional logit model for soda choice
# In mlogit formulas:
# variables before "|" are alternative-specific (vary across products)
# variables after "|" are individual-specific (same for all alternatives)

# price, feat, and disp vary across soda brands,
# so they appear before "|".

# We write "| 0" because there are no individual-specific variables
# in this model
mlogit1 = mlogit(soda~feat+disp+price, data=cola2)
summary(mlogit1)

mlogit1 = mlogit(soda~feat+disp+price|0, data=cola2)
summary(mlogit1)


# Variables before "|" are alternative-specific (vary across soda brands).
# Variables after "|" would be individual-specific.
# We use "| 0" because there are no individual-specific variables in this dataset.

# Interpretation of results:
# Frequencies of alternatives (observed market shares in the sample):
# coke    = 27.99%
# pepsi   = 34.58%
# sevenup = 37.43%
# Estimation method:
# Newton-Raphson algorithm converged after 4 iterations.

# Estimated coefficients:

# feat (feature promotion):
# coefficient = -0.0106
# p-value = 0.8945
# -> Not statistically significant.
# Feature advertising does not significantly influence soda choice.

# disp (store display):
# coefficient = 0.4624
# p-value < 0.001
# -> Highly significant positive effect.
# Products placed on store display increase the probability of being chosen.

# price:
# coefficient = -1.7445
# p-value < 0.001
# -> Highly significant negative effect.
# Higher prices reduce the probability that a soda is chosen.

# Log-likelihood of the model:
# LL = -1822.2
# This value is used to compute pseudo-R² and likelihood ratio tests.

# Overall interpretation:
# Consumers are price sensitive and strongly correlated with in-store displays,
# while feature promotions have no statistically significant effect.

# Relation to economic theory

# The conditional logit model represents consumer demand for differentiated products.
# Consumers choose the soda (Coke, Pepsi, or SevenUp) that gives them the highest utility.

# Utility function:
# U_ij = β1 * price_ij + β2 * feat_ij + β3 * disp_ij + ε_ij
# where i = consumer/purchase occasion and j = soda alternative.

# Relation to demand theory:
# The negative price coefficient (-1.744) reflects the law of demand:
# when the price of a soda increases, the probability that it is chosen decreases.

# Therefore, the model captures demand-side behavior similar to microeconomic demand models.

# However, this is not a full supply-demand equilibrium model.
# The conditional logit only models consumer choice (demand side),
# while supply and market equilibrium prices are not modeled here.



# Marginal effects

# Construct a data frame z containing mean values of the alternative-specific variables
# for each soda brand. These are average observed characteristics in the sample.
z <- with(cola2, data.frame(
  feat  = tapply(feat,  index(mlogit1)$alt, mean),
  disp  = tapply(disp,  index(mlogit1)$alt, mean),
  price = tapply(price, index(mlogit1)$alt, mean)
))

print(z)

# Interpretation of z:
# coke:    average feature, display, and price values for Coke
# pepsi:   average feature, display, and price values for Pepsi
# sevenup: average feature, display, and price values for SevenUp

# For dummy variables (feat and disp), marginal effects are easier to interpret
# at the value 0 rather than at their sample means, because these variables only
# take values 0 or 1 in practice.
#
# Therefore, we set feat = 0 and disp = 0 for all alternatives, while keeping
# price at its brand-specific sample mean.

z[,1:2] = 0
print(z)

# Now z represents a baseline situation:
# no soda is featured and no soda is on display,
# while prices remain at their average observed levels.

# Marginal effects for price
effects(mlogit1, covariate = "price", data = z)

# Interpretation:
# Each row shows the effect of increasing the price of one soda by 1 unit ($1)
# on the choice probabilities of all sodas.
#
# The reported values are changes in probability (not dollars or units of soda).
# Probabilities range from 0 to 1, so a value like 0.3721 corresponds to
# about 37.21 percentage points.

# Row "coke":
# A $1 increase in Coke price: base is frequency of coke = 0.27991
# - decreases probability of choosing Coke by 0.3782 (≈ 37.82 percentage points)
################################
# Baseline probability of choosing Coke is about 0.2799 (27.99%).
# The marginal effect of a $1 increase in Coke price is -0.3782,
# meaning the probability decreases by about 37.8 percentage points.
# Since this change is larger than the baseline probability itself,
# the effect is very large, indicating strong consumer price sensitivity.
################################
# - increases probability of choosing Pepsi by 0.1711 (≈ 17.11 percentage points)
# - increases probability of choosing SevenUp by 0.2072 (≈ 20.72 percentage points)
#
# This is consistent with demand theory:
# when Coke becomes more expensive, consumers substitute away from Coke
# toward Pepsi and SevenUp.

# Row "pepsi":
# A $1 increase in Pepsi price:
# - decreases probability of choosing Pepsi by 0.3721 (≈ 37.21 percentage points)
# - increases probability of choosing Coke by 0.1711 (≈ 17.11 percentage points)
# - increases probability of choosing SevenUp by 0.2011 (≈ 20.11 percentage points)

# Row "sevenup":
# A $1 increase in SevenUp price:
# - decreases probability of choosing SevenUp by 0.4083 (≈ 40.83 percentage points)
# - increases probability of choosing Coke by 0.2072 (≈ 20.72 percentage points)
# - increases probability of choosing Pepsi by 0.2011 (≈ 20.11 percentage points)

# Diagonal elements = own-price effects (always negative here)
# Off-diagonal elements = cross-price effects (positive substitution effects)
# Marginal effects for display

effects(mlogit1, covariate = "disp", data = z)

# Interpretation:
# Each row shows the effect of changing display from 0 to 1 for one soda
# on the choice probabilities of all sodas.
#
# Row "coke":
# If Coke gets a display promotion:
# - probability of choosing Coke increases by 0.1003
# - probability of choosing Pepsi decreases by 0.0453
# - probability of choosing SevenUp decreases by 0.0549
#
# Thus, display makes the promoted product more attractive and steals market share
# from competing brands.
#
# Row "pepsi":
# If Pepsi gets a display promotion:
# - Pepsi choice probability increases by 0.0987
# - Coke and SevenUp probabilities decrease
#
# Row "sevenup":
# If SevenUp gets a display promotion:
# - SevenUp choice probability increases by 0.1082
# - Coke and Pepsi probabilities decrease
#
# Diagonal elements = own display effects (positive)
# Off-diagonal elements = competitors lose probability when one soda gets display support

# Marginal effects for feature
effects(mlogit1, covariate = "feat", data = z)

# Interpretation:
# The effects are extremely small for all brands.
# For example, if Coke is featured:
# - probability of choosing Coke decreases by about 0.0023
# - probabilities of Pepsi and SevenUp increase only slightly
#
# These effects are very close to zero, which matches the estimated coefficient
# on feat being statistically insignificant in the model.
#
# Therefore, feature advertising does not appear to have an economically meaningful
# effect on consumer choice in this dataset.

# c) Determine and interpret pseudo-R2 statistics.
# Estimate null model (no explanatory variables)
mlogit0 <- mlogit(soda ~ 1, data = cola2)
summary(mlogit0)
# McFadden pseudo R²
pseudoR2 <- 1 - logLik(mlogit1) / logLik(mlogit0)
pseudoR2


# d) Are variables in the model jointly significant?
library(lmtest)
mlogit0 <- mlogit(soda ~ 1 , data = cola2)
summary(mlogit0)
mlogit1 = mlogit(soda~feat+disp+price|0, data=cola2)
summary(mlogit1)
# Likelihood Ratio test
lrtest(mlogit1, mlogit0)

2*(-1822.2- -1988.6)
# Null hypothesis: all coefficients (price, feat, disp) are equal to zero.

# If p-value < 0.05:
# -> reject H0
# -> explanatory variables are jointly significant.

# Given the strong significance of price and display,
# the model is jointly statistically significant.

# e) Determine and interpret marginal eﬀects for price.
# Construct evaluation point (average prices, no promotions)
z <- with(cola2, data.frame(
  feat  = tapply(feat, index(mlogit1)$alt, mean),
  disp  = tapply(disp, index(mlogit1)$alt, mean),
  price = tapply(price, index(mlogit1)$alt, mean)
))
z
# Set dummy variables to zero
z[,1:2] = 0
z
# Price marginal effects
effects(mlogit1, covariate = "price", data = z)
# Marginal effects of price

# Rows show the effect of increasing the price of one soda by $1.
# Columns show how the probabilities of choosing each soda change.

# Diagonal elements are own-price effects (negative):
# increasing a soda’s price reduces its probability of being chosen.

# Off-diagonal elements are cross-price effects (positive):
# when one soda becomes more expensive, consumers switch to competing brands.

# Each row sums to zero because the total probability across all alternatives must equal 1.

# f) Determine and interpret marginal eﬀects for display.

effects(mlogit1, covariate = "disp", data = z)
# Marginal effects of display (disp)

# Display is a dummy variable indicating whether a soda is placed on
# a special in-store display.

# Each row shows the effect of changing display from 0 to 1 for one soda
# on the probability of choosing each soda.

# Row "coke":
# If Coke is placed on display:
# - probability of choosing Coke increases by about 0.1003 (≈ 10 percentage points)
# - probability of choosing Pepsi decreases by about 0.0453
# - probability of choosing SevenUp decreases by about 0.0549

# Row "pepsi":
# If Pepsi is placed on display:
# - probability of choosing Pepsi increases by about 0.0987
# - probability of choosing Coke decreases by about 0.0453
# - probability of choosing SevenUp decreases by about 0.0533

# Row "sevenup":
# If SevenUp is placed on display:
# - probability of choosing SevenUp increases by about 0.1082
# - probability of choosing Coke decreases by about 0.0549
# - probability of choosing Pepsi decreases by about 0.0533

# Interpretation:
# Display promotions significantly increase the probability of purchasing
# the promoted soda while reducing the probability of choosing competing brands.
# Predicted probabilities from the conditional logit model

# ------------------------------------------
# Exercise 3
# ------------------------------------------

# data
data("Fishing", package = "mlogit")
Fish <- mlogit.data(Fishing, shape="wide", choice="mode", varying=2:9)
View(Fish[1:10,])

# 'impure' conditional logit
mlogit1 = mlogit(mode ~ price+catch | income, data = Fish)
summary(mlogit1)

# marginal effects
z <- with(Fish, data.frame(price = tapply(price, index(mlogit1)$alt, mean),
                           catch = tapply(catch, index(mlogit1)$alt, mean),
                           income = tapply(income, index(mlogit1)$alt, mean)))
z
# compute the marginal effects
# impact of an addtional dollar
effects(mlogit1, covariate = "income", data = z)
# marginal effect for price
effects(mlogit1, covariate = "price", data = z)
# marginal effect for catch rate
effects(mlogit1, covariate = "catch", data = z)



# ------------------------------------------
# Exercise 4
# ------------------------------------------



# ------------------------------------------
# Exercise 5
# ------------------------------------------

# read the data
car = read.csv(file="car_choice.csv", sep=",", header=TRUE)
View(car)

# "impure" condictional logit
mlogit = mlogit(choice~dealer|income, data=car, shape="long",
                chid.var="id", alt.var="car", choice="choice")
summary(mlogit)

# ------------------------------------------
# Exercise 6
# ------------------------------------------

# read the data
dane = read.csv(file="fmld142_part.csv", header=TRUE, sep=",")

# multinom function from nnet library
mlogit = multinom(empltyp1~age_ref+as.factor(sex_ref)+fam_size+as.factor(marital1), 
                  data=dane)
summary(mlogit)
stargazer(mlogit, type="text")

# MARITAL	3	Divorced
# MARITAL	1	Married
# MARITAL	5	Never married
# MARITAL	4	Separated
# MARITAL	2	Widowed

# preparing data for mlogit.data
table(dane$empltyp1)
dane_mlogit = mlogit.data(dane, choice="empltyp1", shape="wide", varying=NULL)
View(dane_mlogit)

# mlogit function from mlogit library
mlogit1 = mlogit(empltyp1~0|age_ref+as.factor(sex_ref)+fam_size+as.factor(marital1), data=dane_mlogit)
summary(mlogit1)
stargazer(mlogit1, type="text")






