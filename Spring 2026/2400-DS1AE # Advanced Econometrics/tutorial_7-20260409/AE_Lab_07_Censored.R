###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#                                                                         #
#                 Lab 07: Censored and Sample Selection data              #
#                                                                         #
###########################################################################

# WNE package from Github
install.packages("devtools")
library("devtools")

install_github("Rand-0/WNE")
library(WNE)

install.packages("censReg")
install.packages("truncreg")
library( "censReg" )
library( "truncreg" )
library("AER")
install.packages("DescTools")
library("DescTools")



data( "Affairs", package = "AER" )

Sys.setenv(LANG = "en")
options(scipen=100)


# ------------------------------------------------------------------------------
# Tobit model
# a.k.a. censored regression
# ------------------------------------------------------------------------------

# depvar:
# number of affairs in the past year 
# 
# indepvars:
# age, 
# number of years married, 
# religiousness, 
# occupation, 
# own rating of the marriage. 

# The dependent variable is left-censored at zero and not right-censored. Hence, 
# this is a standard Tobit model. 
# 
# This actually an example of count data, but for the sake of this class
# let's treat it as a continuous variable.

Desc(Affairs$affairs)
# The window shows:
# Histogram / spikes → distribution of affairs
# Dot/strip plot → individual observations
# ECDF (cumulative distribution) → bottom plot

#first OLS
table(Affairs$occupation)
OLS <- lm(affairs ~ age + yearsmarried + religiousness +
            + occupation + rating, data = Affairs)
summary(OLS)

# Tobit model can be estimated by following command:
tobit1<-censReg(affairs~age+yearsmarried+religiousness+occupation+rating,
                left=0, right=Inf, data=Affairs)
summary(tobit1)

library(stargazer)

stargazer(OLS, tobit1,
          type = "text",   # use "latex" or "html" if needed
          title = "OLS vs Tobit Results",
          column.labels = c("OLS", "Tobit"),
          dep.var.labels = "Affairs",
          digits = 3)

# Big Picture: Why OLS vs Tobit?
# Your dependent variable = Affairs (number of affairs)
# From your Desc():Many zeros
# Continuous positive values otherwise. This is a left-censored variable at 0
# OLS → treats it as fully continuous (not ideal)
# Tobit → accounts for censoring at 0 (correct model)
# OLS (Column 1)
# Measures effect on observed number of affairs
# Tobit (Column 2)
# Measures effect on a latent (underlying) propensity to have affairs
# Also accounts for:
# Probability of having any affair
# Intensity (how many) That’s why Tobit coefficients are larger in magnitude

##################################################################
# Interpretation: OLS vs Tobit

# AGE
# OLS: -0.050
# Tobit: -0.179
# -> Older individuals tend to have fewer affairs.
# -> The effect is stronger in the Tobit model because it accounts for censoring at zero.

# YEARS MARRIED
# OLS: +0.162*
# Tobit: +0.554*
# -> Being married longer is associated with more affairs.
# -> The Tobit model suggests a much stronger effect once censoring is considered.

# RELIGIOUSNESS
# OLS: -0.476*
# Tobit: -1.686*
# -> More religious individuals tend to have fewer affairs.
# -> This negative effect is substantially larger in the Tobit model.

# WHY ARE TOBIT COEFFICIENTS LARGER?
# -> OLS underestimates effects because it treats all zeros as true observed values.
# -> However, many zeros are "censored":
#    some individuals may have a latent tendency to have affairs,
#    but we only observe zero due to censoring.

# -> The Tobit model accounts for this by modeling:
#    1. The latent (unobserved) propensity to have affairs
#    2. The observed outcome (which is censored at zero)

# -> As a result, Tobit recovers stronger (less biased) effects.
##################################################################
# marginal effects after censReg function
source("tobit_marginal_effects.R")
tobit1<-censReg(affairs~age+yearsmarried+religiousness+occupation+rating,
                left=0, right=Inf, data=Affairs)
summary(tobit1)
x = rbind(1, mean(Affairs$age), mean(Affairs$yearsmarried), mean(Affairs$religiousness), 
          mean(Affairs$occupation), mean(Affairs$rating))
x = c(1, 50, 20, 5, 1, 8)
me = tobit_marginal_effects(tobit1, x, dummies_indices=c())
me
# Marginal Effects (Tobit Model Interpretation)

# The Tobit model produces different types of marginal effects:

# y*           = Effect on latent (unobserved) propensity for affairs
# E(y|x)       = Effect on expected number of affairs (overall, including zeros)
# E(y|x, y>0)  = Effect on number of affairs, conditional on having at least one
# Pr(y>0|x)    = Effect on probability of having any affair

# Interpretation: Marginal Effects (Tobit)

# AGE
# -> A one-year increase in age reduces the probability of having an affair
#    by about 0.13 percentage points.
# -> It also decreases the expected number of affairs by about 0.0046.

# YEARS MARRIED
# -> A one-year increase in years married increases the probability of having an affair
#    by about 0.4 percentage points.
# -> It also increases the expected number of affairs by about 0.014.

# RELIGIOUSNESS
# -> A one-unit increase in religiousness reduces the probability of having an affair
#    by about 1.2 percentage points.
# -> It also decreases the expected number of affairs by about 0.043.

# OCCUPATION
# -> A one-unit increase in occupation increases the probability of having an affair
#    by about 0.23 percentage points.
# -> It also increases the expected number of affairs by about 0.008.

# RATING (marriage satisfaction)
# -> A one-unit increase in marriage satisfaction reduces the probability of having an affair
#    by about 1.6 percentage points.
# -> It also decreases the expected number of affairs by about 0.058.


# KEY INTERPRETATION
# -> The most relevant column is E(y|x):
#    it shows how explanatory variables affect the expected number of affairs overall.
# -> Tobit allows us to decompose effects into:
#    1. Probability of having any affair
#    2. Intensity of affairs (if > 0)
# -> This is something OLS cannot do.

################################################################################
tobit2 <- tobit(affairs ~ age + yearsmarried + religiousness +
                     + occupation + rating, left = 0, right = Inf , data = Affairs ,x=T)
# summary(tobit2)
## the vector of marginal effects (at mean values and for y > 0) should be as follows.
## note the [-1] used to remove the intercept term from the final vector, 
##  but not from within the adjustment term. 

#E(y|x,y>0)
margEff(tobit1)
summary(margEff(tobit1))

pnorm(sum(apply(tobit2$x,2,FUN=mean) * tobit2$coef)/tobit2$scale) * tobit2$coef[-1]

# ==========================================
# Tobit Marginal Effects: Interpretation
# ==========================================

# The reported marginal effects correspond to:
# E(y | x, y > 0)
# -> Effect on the number of affairs, conditional on having at least one affair.

# AGE
# If age increases by 1 year, people who 
# already have affairs will have about 0.042 fewer affairs on average.
# -> Marginal effect: -0.042 (significant at 5%)
# -> Among individuals who have affairs, an additional year of age
#    reduces the number of affairs by about 0.042.
# -> Older individuals engage in fewer affairs (conditional on participation).

# YEARS MARRIED
# -> Marginal effect: +0.130 (highly significant)
# -> Among those with affairs, longer marriages increase the number of affairs.
# -> Strong positive effect on intensity of affairs.

# RELIGIOUSNESS
# -> Marginal effect: -0.394 (highly significant)
# -> More religious individuals have substantially fewer affairs
#    among those who engage in affairs.
# -> One of the strongest negative effects.

# OCCUPATION
# -> Marginal effect: +0.076 (not statistically significant)
# -> No strong evidence that occupation affects the number of affairs.

# RATING (marriage satisfaction)
# -> Marginal effect: -0.534 (highly significant)
# -> Higher marriage satisfaction strongly reduces the number of affairs
#    among those who have any.
# -> This is the strongest effect in the model.

# Statistical significance

# -> age: significant at 5%
# -> yearsmarried, religiousness, rating: highly significant (1%)
# -> occupation: not significant

# Manual calculation check
# The pnorm(...) expression reproduces the marginal effects manually:
# -> It computes the probability of being uncensored (y > 0)
# -> Multiplies it by the Tobit coefficients
# -> Confirms that margEff() results are correct

# Key takeaway

# -> These marginal effects describe behavior ONLY for individuals with y > 0
# -> Tobit allows us to separate:
#    (1) participation (whether affairs occur)
#    (2) intensity (how many affairs occur)
# -> OLS cannot make this distinction
################################################################################
# ------------------------------------------------------------------------------
# Truncated regression
# ------------------------------------------------------------------------------

# https://stats.idre.ucla.edu/stata/output/truncated-regression/
# Examples of truncated regression
# Example 1.

# A study of students in a special GATE (gifted and talented education)
# program wishes to model achievement as a function of language skills
# and the type of program in which the student is currently enrolled. A
# major concern is that students are required to have a minimum
# achievement score of 40 to enter the special program. Thus, the
# sample is truncated at an achievement score of 40.  

truncdata = readRDS("truncpanel.rds")
truncdata = truncdata[which(truncdata$time==1),]
hist(truncdata$achievement)
# This distribution is truncated, we do not observe any values below 40.

# Truncated regression
treg = truncreg::truncreg(achievement~lang.score+program2+program3, 
                        data=truncdata, point=40, direction="left")
summary(treg)

# Let's compare these estimates with simple regression results
simpreg = lm(achievement~lang.score+program2+program3, data=truncdata)
summary(simpreg)


# Estimates
cbind(treg$coefficients[1:4], simpreg$coefficients[1:4])
# Std. Errors
cbind(summary(treg)$coefficient[1:4,2], summary(simpreg)$coefficient[1:4,2])  

# Analysis methods you might consider
# Below is a list of some analysis methods you may have encountered. 
# Some of the methods listed are quite reasonable, while others have 
# either fallen out of favor or have limitations.
#
# OLS regression ? You could analyze these data using OLS regression.  
# OLS regression will not adjust the estimates of the coefficients to take into 
# account the effect of truncating the sample at 40, and the coefficients may 
# be severely biased. 
# This can be conceptualized as a model specification error (Heckman, 1979).
# 
# Truncated regression ? Truncated regression addresses the bias introduced 
# when using OLS regression with truncated data.  
# Note that with truncated regression, the variance of the outcome variable is 
# reduced compared to the distribution that is not truncated. Also, if the lower
# part of the distribution is truncated, then the mean of the truncated variable
# will be greater than the mean from the untruncated variable; if the truncation
# is from above, the mean of the truncated variable will be less than 
# the untruncated variable.
# 
# https://stats.idre.ucla.edu/stata/output/truncated-regression/


# ------------------------------------------------------------------------------
# Heckman model
# a.k.a. Sample selection model
# ------------------------------------------------------------------------------


#####################################################################################             
# Real data examples    
#####################################################################################  

#### EXAMPLE 1                       


# This data set was used by Mroz (1987) for analysing female labour supply. 
# 
# labour force participation (described by dummy lfp) is modelled by: 
#   a quadratic polynomial in age (age), 
#   family income (faminc, in 1975 dollars), 
#   presence of children (kids), 
#   and education in years (educ). 
# 
# The wage equation includes 
#   a quadratic polynomial in experience (exper), 
#   education in years (educ), and
#   residence in a big city (city).

install.packages("sampleSelection")
library("sampleSelection")

# getting data                   
data("Mroz87")     

#variable for presence of children.           
Mroz87$kids <- (Mroz87$kids5 + Mroz87$kids618 > 0)

#2-step method     
# The model consists of two equations:
# 1) Selection equation (Probit): participation in labor force (lfp)
# 2) Outcome equation: wage (observed only if working)
# ==========================================
# Heckman 2-step selection model (Heckit)
# ==========================================

greeneTS <- selection(
  # SELECTION EQUATION (Probit model)
  # -> Models probability of being in the labor force (lfp)
  # -> Dependent variable: lfp (1 = working, 0 = not working)
  lfp ~ age + I(age^2) + faminc + kids + educ,
  # OUTCOME EQUATION (Wage equation)
  # -> Models wages, observed only for individuals who are working
  wage ~ exper + I(exper^2) + educ + city,
  # Dataset
  data = Mroz87,
  # Estimation method
  # -> "2step" = Heckman two-step procedure:
  #    Step 1: Estimate selection equation (Probit)
  #    Step 2: Estimate outcome equation with inverse Mills ratio correction
  method = "2step"
)
# -> The model corrects for sample selection bias:
#    wages are only observed for individuals who work
# -> age, faminc, kids, educ affect participation (selection equation)
# -> exper, educ, city affect wages (outcome equation)
# -> I(age^2), I(exper^2) allow for nonlinear (quadratic) effects
summary(greeneTS) 

# Heckman 2-step (Selection Model) – Interpretation

# SELECTION EQUATION (Probit: probability of working)

# age (+), age^2 (-), both significant
# -> Probability of labor force participation increases with age
#    but at a decreasing rate (inverted U-shape)

# faminc (not significant)
# -> Family income does not significantly affect participation

# kids (-, highly significant)
# -> Having children significantly reduces probability of working

# educ (+, highly significant)
# -> Higher education increases probability of participation

# ------------------------------------------

# OUTCOME EQUATION (WAGES, conditional on working)

# exper, exper^2 (not significant)
# -> No evidence that experience affects wages in this model

# educ (+, highly significant)
# -> Education strongly increases wages

# city (not significant)
# -> Living in a city has no significant effect on wages

# SELECTION CORRECTION

# invMillsRatio (not significant)
# -> No strong evidence of sample selection bias

# rho = -0.343
# -> Negative correlation between selection and wage errors
# -> However, not statistically significant → weak selection effect

# sigma = 3.200
# -> Standard deviation of the wage equation error term

# KEY TAKEAWAY
# -> Education increases both participation and wages
# -> Having children reduces participation
# -> No strong evidence of selection bias (Heckman correction not crucial)
################################################################################
#ML method             
greeneTS <- selection(lfp~age+I(age^2)+faminc+kids+educ, 
                    wage~exper+I(exper^2)+educ+city,
                    data=Mroz87)
summary(greeneTS)


# ==========================================
# Difference: 2-step vs ML (simple explanation)
# ==========================================

# 2-STEP (method = "2step")
# -> First estimate who works (Probit model)
# -> Then estimate wages ONLY for workers
# -> Add a correction term (inverse Mills ratio)

# -> So: 2 separate steps
# -> Easier to understand
# -> But estimates are less precise

# ------------------------------------------

# ML (default: no method specified)
# -> Does NOT do 2 steps

# -> Instead:
#    Estimates BOTH:
#    (1) who works
#    (2) wages
#    at the SAME TIME

# -> Think:
#    "solve everything together in one big model"

# WHY ML IS "MORE EFFICIENT"

# -> ML uses ALL information at once
# -> So estimates are more precise (smaller standard errors)

# -> 2-step throws away some information between steps

# SUPER SIMPLE INTUITION

# 2-step = solve problem in 2 pieces
# ML     = solve everything together at once (better if model is correct)

# IMPORTANT NOTE

# -> ML is better ONLY if model is correctly specified
# -> If model is wrong → ML can be misleading
# -> 2-step is more "robust" and safer sometimes

# Assumptions in Heckman (ML) model

# 1. JOINT NORMALITY (MOST IMPORTANT)
# -> The errors in BOTH equations are jointly normally distributed:
#    - selection equation error
#    - outcome (wage) equation error
#
# -> This is the KEY assumption for ML to be valid
# -> If this is wrong → ML estimates can be biased

# 2. CORRECT MODEL SPECIFICATION
# -> You included the right variables:

# Selection equation (who works):
# -> age, age^2, faminc, kids, educ

# Outcome equation (wages):
# -> exper, exper^2, educ, city

# -> No important variables are missing
# -> Functional form is correct (quadratic terms included)

# 3. EXCLUSION RESTRICTION (IMPORTANT FOR IDENTIFICATION)
# -> At least one variable affects selection but NOT wages

# In your model:
# -> faminc, kids affect participation (lfp)
# -> but are NOT included in wage equation

# -> This helps identify the model properly

# 4. NO PERFECT MULTICOLLINEARITY
# -> Variables are not perfectly correlated

# 5. INDEPENDENT OBSERVATIONS
# -> Each individual is independent of others

# -> ML assumes:
#    "I correctly described how participation and wages are generated,
#     and the errors follow a normal distribution"

# -> If these assumptions hold → ML is efficient (best estimates)
# -> If they fail → results can be misleading

################################################################################
#### EXAMPLE 2   
# The data set used in this example is based on the RAND Health Insurance 
# Experiment (Newhouse 1999). It is included in sampleSelection, where it is 
# called RandHIE. Cameron and Trivedi (2005, p. 553) use these data to analyse 
# health expenditures. 
#  
# The endogenous variable of the outcome equation measures the log of the 
# medical expenses of the individual (lnmeddol) and the endogenous variable of 
# the selection equation indicates whether the medical expenses are positive (binexp)
#  
#  The regressors are: 
#    
#    the log of the coinsurance rate plus 1 (logc = log(coins+1)), 
#    a dummy for individual deductible plans (idp), 
#    the log of the participation incentive payment (lpi), 
#    an artificial variable (fmde that is 0 if idp=1 and ln(max(1,mde/(0.01*coins))) otherwise (where mde is the maximum expenditure offer),
#    physical limitations (physlm), 
#    the number of chronic diseases (disea), 
#    dummy variables for good (hlthg), fair (hlthf), and poor (hlthp) self-rated health (where the baseline is excellent self-rated health), 
#    the log of family income (linc), 
#    the log of family size (lfam), 
#    education of household head in years (educdec), 
#    age of the individual in years (xage), 
#    a dummy variable for female individuals (female), 
#    a dummy variable for individuals younger than 18 years (child), 
#    a dummy variable for female individuals younger than 18 years (fchild), 
#    and a dummy variable for black household heads (black)


data("RandHIE")
#as it is in the original example
subsample <- RandHIE$year == 2 & !is.na(RandHIE$educdec)

selectEq <- binexp ~ logc + idp + lpi + fmde + physlm + disea +
+ hlthg + hlthf + hlthp + linc + lfam + educdec + xage +
+ female + child + fchild + black

outcomeEq <- lnmeddol ~ logc + idp + lpi + fmde + physlm +
+ disea + hlthg + hlthf + hlthp + linc + lfam

rhieTS <- selection(selectEq, outcomeEq, data = RandHIE[subsample, ],method = "2step")


summary(rhieTS)

# ------------------------------------------------------------------------------
# Theoretical analyses
# ------------------------------------------------------------------------------
# Tobit-2 

# install.packages("sampleSelection")
# install.packages("mvtnorm")

library("sampleSelection")
library("mvtnorm")


set.seed(123)

#Heckman (tobit-2) sample selection model
#with exclusion restriction (selection regression contains important regressor that is not in outcome regression)

#drawing from bivariate normal distirbution with correlation equal to -0.7
#error terms
eps <- rmvnorm(500, c(0, 0), matrix(c(1, -0.7, -0.7, 1), 2, 2))

#selection indepvar univariate (0,1)   
xs <- runif(500)
#selection depvar ys if (xs +eps)>0 then 1 - probit
ys <- (xs + eps[, 1]) > 0

#outocme regression
xo <- runif(500)
#latent depvar
yoX <- xo + eps[, 2]
#observable outcome if yoX is greater then 0
yo <- yoX * (ys > 0)

#Heckman (tobit-2) sample selection model

summary(selection(ys ~ xs, yo ~ xo))
summary(selection(ys ~ xs, yo ~ xo,method="2step"))

#expected intercepts = 0 and slopes = 1
#close to the true values


#without exclusion restriction (selection regression contains important regressor that is not in outcome regression)

yoX <- xs + eps[, 2]
yo <- yoX * (ys > 0)
summary(selection(ys ~ xs, yo ~ xs))

#estimators still unbiased
#std. errors are larger
#the standard errors of the estimates depend on the variation in the latent selection equation
#More variation gives smaller standard errors

xs <- runif(500, -5, 5)
ys <- xs + eps[, 1] > 0
yoX <- xs + eps[, 2]
yo <- yoX * (ys > 0)
summary(selection(ys ~ xs, yo ~ xs))

#################################


# Tobit-5 


#################################  

set.seed(0)
# variance - covariance matrix
vc <- diag(3)
vc[lower.tri(vc)] <- c(0.9, 0.5, 0.1)
vc[upper.tri(vc)] <- vc[lower.tri(vc)]
vc
# error terms from multivariate normal distributions
eps <- rmvnorm(500, c(0, 0, 0), vc)
#selection regression
xs <- runif(500)
ys <- (xs + eps[, 1]) > 0
#outcome regression 1  
xo1 <- runif(500)
yo1 <- xo1 + eps[, 2]
#outcome regression 1  
xo2 <- runif(500)
yo2 <- xo2 + eps[, 3]

#tobit-5
summary(selection(ys ~ xs, list(yo1 ~ xo1, yo2 ~ xo2)))
summary(selection(ys ~ xs, list(yo1 ~ xo1, yo2 ~ xo2), method="2step"))
