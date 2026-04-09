
# Advanced Econometrics
# Lab 06


# For starters

setwd("...")

Sys.setenv(LANG = "en")

# install.packages("MASS")
# install.packages("pscl")
# install.packages("sandwich")
# install.packages("car")
# install.packages("lmtest")

library("MASS")
library("sandwich")
library("car")
library("lmtest")
library("pscl")

# install.packages("coin")
library(coin) #test
install.packages("DescTools")
library(DescTools)

# ------------------------------------------
# Exercise 1
# ------------------------------------------
# Let’s model number of surgical errors and medical malpractice per hospital. The data set
# surgical_errors.csv includes:
# • hosp_id - hospital id
# • errors - number of errors
# • lnN - logarithm of operation number
# • private - a dummy variable = 1 if the hospital is a private firm, 0 = if it is a part
# of national health service
# a) Estimate Poisson regression model.
# b) Estimate Negative Binomial regression model.
# c) Compare both models.

errors = read.csv(file="surgical_errors.csv", header=TRUE, sep=",")
errors$lnN = log(errors$n)

# a) Estimate Poisson regression model.
# Poisson regression model
model_p = glm(errors~lnN+private, data=errors, family=poisson)
summary(model_p)

# Intercept:
# Expected log-count of errors when lnN = 0 and private = 0
# (baseline category)

# Interpretation: larger N -> more errors
# In Poisson: exp(1.4242) ≈ 4.15 → a 1-unit increase in lnN
# multiplies expected errors by ~4.15

# private coefficient (0.6841):
# Positive but only marginally significant (p ≈ 0.079)
# Interpretation: private institutions tend to have more errors,
# but evidence is weak at 5% significance level
# exp(0.6841) ≈ 1.98 → nearly double the expected count

# Poisson assumes: mean = variance (equidispersion)
# If residual deviance >> degrees of freedom → overdispersion concern
# Here: 12.704 vs 6 → possible mild overdispersion

# Suggestion:
# Consider checking Negative Binomial model as robustness check

# b) Estimate Negative Binomial regression model.
# Negative Binomial regression
model_nb = MASS::glm.nb(errors~lnN+private, data=errors)
summary(model_nb)



# b) Estimate Negative Binomial regression model

# Fit Negative Binomial regression:
# Used when overdispersion is present (variance > mean)
# Adds dispersion parameter (theta) to relax Poisson assumption
model_nb = MASS::glm.nb(errors ~ lnN + private, data = errors)

# Display model summary
summary(model_nb)


# --- Interpretation of results ---

# Intercept (4.7805):
# Baseline log-count when lnN = 0 and private = 0

# lnN coefficient (1.3773, p = 0.00124):
# Strong positive and statistically significant
# exp(1.3773) ≈ 3.96 → increasing lnN by 1 multiplies expected errors by ~4

# private coefficient (0.6262, p = 0.1627):
# Not statistically significant at 5% level
# exp(0.6262) ≈ 1.87 → suggests higher errors, but effect is not reliable


# --- Model fit (with numbers) ---

# Residual deviance = 8.86 on 6 df → ratio ≈ 8.86 / 6 = 1.48
# → Slightly above 1 → mild overdispersion

# Compare with Poisson:
# Poisson residual deviance = 12.70 on 6 df → ratio ≈ 2.12
# → stronger overdispersion under Poisson

# Interpretation:
# NB reduces deviance ratio from ~2.12 → ~1.48 → improvement

# --- Dispersion parameter (theta) ---

# Theta = 16.0 (SE = 25.2)

# Interpretation:
# Large theta → variance ≈ mean → close to Poisson
# Very large SE → estimate is imprecise → weak evidence of overdispersion

# If strong overdispersion existed → theta would be small and precise


# --- Coefficient stability (Poisson vs NB) ---

# lnN:
# Poisson = 1.4242 vs NB = 1.3773 → very similar

# private:
# Poisson p ≈ 0.079 vs NB p ≈ 0.163 → becomes less significant

# Interpretation:
# Results are stable → no major model sensitivity


# --- Final conclusion (numerically justified) ---

# 1. Overdispersion exists but is mild:
#    Poisson deviance/df ≈ 2.12 → NB reduces it to ≈ 1.48

# 2. AIC difference is small (≈ 1.28 < 2):
#    → No strong evidence NB is better

# 3. Large theta (16) → data close to Poisson assumption

# → Conclusion:
# Poisson model is adequate; NB does not add substantial value

# NB can still be reported as robustness check



# Comparison
summary(model_p)$aic
summary(model_nb)$aic

# --- AIC comparison (key decision metric) ---

# Poisson AIC = 50.665
# NB AIC      = 51.946

# Difference = 51.946 - 50.665 ≈ 1.28

# Rule of thumb:
# ΔAIC < 2 → models are essentially equivalent

# Interpretation:
# NB does NOT provide meaningful improvement over Poisson


# ------------------------------------------
# Exercise 2
# ------------------------------------------
# Let’s analyse total number of medals won by a country at Olympic Games. The data
# set contains information on number of medal won (medaltot), population (pop), Gross
# Domestic Product (gdp). What is more, it includes two dummy variables: soviet = 1 if a
# country was part of the Soviet Block, and host = 1 for Olympic Games host-countries.
# a) Estimate Poisson regression model.
# b) Estimate Negative Binomial regression model.
# c) Compare both models.
# d) Check frequencies of zero observations.
# e) Estimate Zero-Inflated Poisson regression model.
# f) Estimate Zero-Inflated Negative Binomial regression model.
# g) Compare all the models.


library(haven)
medals = read_dta("olympics_11.dta")
indices = which(medals$year==72)
medals = medals[indices, ]

medals$lnPOP = log(medals$pop)
medals$lnGDP = log(medals$gdp)

# a) Estimate Poisson regression model.
# Poisson regression model
# Dependent variable: total medals (count)
# lnPOP: log population
# lnGDP: log GDP
# soviet: dummy (former Soviet countries)
# host: dummy (host country effect)
model_p = glm(medaltot~lnPOP+lnGDP+soviet+host, data=medals, family=poisson)
summary(model_p)

# --- Interpretation of coefficients (log → multiplicative effects) ---

# Intercept (-14.106):
# Baseline log expected medals when all covariates = 0
# Not directly meaningful economically, but needed for model


# lnPOP (-0.1806, p = 0.003):
# Statistically significant and NEGATIVE
# exp(-0.1806) ≈ 0.835
# → A 1% increase in population reduces expected medals by ~0.18%
# Interpretation:
# Larger populations do not necessarily translate into more medals
# (possible dilution effect or inefficiency)


# lnGDP (0.7312, p < 0.001):
# Strong positive and highly significant
# exp(0.7312) ≈ 2.08
# → A 1-unit increase in lnGDP (≈ 100% GDP increase)
# doubles expected medals
# Interpretation:
# Wealth is a key driver of Olympic success


# soviet (2.0803, p < 0.001):
# Very large and highly significant effect
# exp(2.0803) ≈ 8.01
# → Former Soviet countries win ~8x more medals (ceteris paribus)
# Interpretation:
# Strong legacy effect (sports systems, training infrastructure)


# host (0.7118, p < 0.001):
# Positive and significant host advantage
# exp(0.7118) ≈ 2.04
# → Host countries win about 2x more medals
# Interpretation:
# Home advantage (familiarity, crowd support, more participants)


# --- Model fit ---

# Null deviance = 2170.8 (model with no predictors)
# Residual deviance = 420.4 → large drop → strong explanatory power

# Deviance/df = 420.4 / 113 ≈ 3.72
# → MUCH greater than 1 → strong overdispersion

# AIC = 594.07 → used for comparison with alternative models


# --- Key conclusion ---

# 1. GDP, Soviet status, and host effect strongly increase medal counts
# 2. Population has a small but significant negative effect
# 3. Model explains a large portion of variation (big deviance drop)

# BUT:
# Strong overdispersion (3.72 >> 1)
# → Poisson assumption (mean = variance) is violated

# → Suggestion:
# Use Negative Binomial model for more reliable inference

# b) Estimate Negative Binomial regression model.
# Negative Binomial regression
model_nb = MASS::glm.nb(medaltot~lnPOP+lnGDP+soviet+host, data=medals)
summary(model_nb)

# b) Estimate Negative Binomial regression model

# Fit Negative Binomial model:
# Appropriate when strong overdispersion is present (variance >> mean)
model_nb = MASS::glm.nb(medaltot ~ lnPOP + lnGDP + soviet + host, 
                        data = medals)

summary(model_nb)


# --- Interpretation of coefficients (log → multiplicative effects) ---

# Intercept (-16.617):
# Baseline log expected medals (not directly interpretable economically)


# lnPOP (0.0968, p = 0.453):
# Not statistically significant
# exp(0.0968) ≈ 1.10
# → A 1-unit increase in lnPOP increases medals by ~10%, but effect is NOT reliable
# Interpretation:
# Population has no clear effect once overdispersion is accounted for


# lnGDP (0.6358, p < 0.001):
# Strong positive and highly significant
# exp(0.6358) ≈ 1.89
# → Doubling GDP increases expected medals by ~89%
# Interpretation:
# Economic strength remains a key driver of Olympic success


# soviet (2.7780, p < 0.001):
# Very large and highly significant effect
# exp(2.7780) ≈ 16.1
# → Former Soviet countries win ~16x more medals
# Interpretation:
# Strong legacy/institutional advantage (even larger than in Poisson)


# host (0.9040, p = 0.420):
# Not statistically significant
# exp(0.9040) ≈ 2.47
# → Suggests higher medals for hosts, but very imprecise (large SE)
# Interpretation:
# Host effect is not robust once overdispersion is controlled for


# --- Model fit (with numbers) ---

# Residual deviance = 103.08 on 113 df → ratio ≈ 103.08 / 113 = 0.91
# → Close to 1 → GOOD fit (no overdispersion problem remaining)

# Compare with Poisson:
# Poisson deviance/df ≈ 420.4 / 113 ≈ 3.72 → severe overdispersion

# Interpretation:
# NB dramatically improves model fit


# --- AIC comparison (key decision metric) ---

# Poisson AIC = 594.07
# NB AIC      = 378.03

# Difference = 594.07 - 378.03 ≈ 216 (!!)

# Interpretation:
# HUGE improvement → strong evidence in favor of NB


# --- Dispersion parameter (theta) ---

# Theta = 0.876 (SE = 0.254)

# Interpretation:
# Small theta → strong overdispersion
# Precisely estimated → reliable evidence of overdispersion

# Contrast with earlier example:
# Here overdispersion is strong and clearly present


# --- Coefficient comparison vs Poisson ---

# lnPOP:
# Poisson: negative and significant
# NB: insignificant → effect disappears

# host:
# Poisson: significant
# NB: insignificant → effect not robust

# soviet:
# Strong in both, but even larger in NB (exp ≈ 16 vs ~8)

# Interpretation:
# Poisson gave misleading significance due to underestimated standard errors


# --- Final conclusion (numerically justified) ---

# 1. Strong overdispersion:
#    Poisson deviance/df ≈ 3.72 → NB reduces to ≈ 0.91

# 2. Massive AIC improvement (≈ 216 points):
#    → NB clearly preferred

# 3. Theta = 0.876 (small, precise):
#    → confirms strong overdispersion

# → Conclusion:
# Negative Binomial is the correct model here

# Key insight:
# After correcting for overdispersion,
# only GDP and Soviet legacy remain robust predictors

library(stargazer)

model_nb_glm <- model_nb
class(model_nb_glm) <- c("glm", "lm")

# Extract coefficient tables
p_tab  <- coef(summary(model_p))
nb_tab <- coef(summary(model_nb))

# Build one combined table
tab <- data.frame(
  Variable = rownames(p_tab),
  `Poisson Coef.` = sprintf("%.3f", p_tab[, "Estimate"]),
  # `Poisson SE`    = sprintf("(%.3f)", p_tab[, "Std. Error"]),
  `Poisson p`     = sprintf("%.3f", p_tab[, "Pr(>|z|)"]),
  `NB Coef.`      = sprintf("%.3f", nb_tab[, "Estimate"]),
  # `NB SE`         = sprintf("(%.3f)", nb_tab[, "Std. Error"]),
  `NB p`          = sprintf("%.3f", nb_tab[, "Pr(>|z|)"])
)

stargazer(tab, type = "text",summary = FALSE, rownames = FALSE,
          title = "Poisson vs Negative Binomial Regression Results")

# Key insight:
# After correcting for overdispersion,
# only GDP and Soviet legacy remain robust predictors


# c) Compare both models
# Comparison
summary(model_p)$aic
summary(model_nb)$aic

# c) Compare both models

# AIC values:
summary(model_p)$aic    # 594.07 (Poisson)
summary(model_nb)$aic   # 378.03 (Negative Binomial)

# --- Interpretation ---

# Difference in AIC:
# 594.07 - 378.03 ≈ 216

# Rule of thumb:
# ΔAIC > 10 → very strong evidence in favor of the model with lower AIC

# Here:
# ΔAIC ≈ 216 → EXTREMELY strong evidence favoring Negative Binomial

# Negative Binomial model fits the data MUCH better than Poisson
# → Poisson model is clearly misspecified
# --- Link to overdispersion ---

# Recall:
# Poisson deviance/df ≈ 3.72 → strong overdispersion
# NB deviance/df ≈ 0.91 → good fit

# Interpretation:
# Poisson fails because it assumes mean = variance
# NB succeeds by allowing variance > mean

# The very large AIC reduction (~216 points), combined with
# strong overdispersion in the Poisson model, provides clear
# evidence that the Negative Binomial model is preferred.

# d) Check frequencies of zero observations.
# Frequency table
table(medals$medaltot)
library(dplyr)
medals %>% group_by(medaltot) %>% 
  summarise(n=n()) %>% 
  ungroup() %>% 
  mutate(total = sum(n), percent = 100*(n/total))

# e) Estimate Zero-Inflated Poisson regression model.
# ZIP model
model_zip = zeroinfl(medaltot~lnPOP+lnGDP+soviet+host | 
                      lnPOP+lnGDP+soviet+host, data=medals, dist="poisson")
summary(model_zip)
# e) Estimate Zero-Inflated Poisson (ZIP) model

# ZIP combines:
# (1) Count model (Poisson)
# (2) Zero-inflation model (logit → probability of structural zeros)

model_zip = zeroinfl(medaltot ~ lnPOP + lnGDP + soviet + host | 
                       lnPOP + lnGDP + soviet + host,
                     data = medals, dist = "poisson")

summary(model_zip)


# --- COUNT MODEL (Poisson part: number of medals) ---

# lnPOP (-0.1398, p = 0.037):
# Significant negative effect
# exp(-0.1398) ≈ 0.87
# If exp(coef) = 0.87 → 13% decrease
# If exp(coef) = 1.20 → 20% increase
# → 1-unit increase in lnPOP reduces medals by ~13%
# Interpretation:
# Larger countries do not necessarily win more medals (efficiency effect)

# lnGDP (0.6016, p < 0.001):
# Strong positive effect
# exp(0.6016) ≈ 1.83
# → Doubling GDP increases medals by ~83%
# Interpretation:
# Wealth strongly increases Olympic performance

# soviet (1.8288, p < 0.001):
# Large positive effect
# exp(1.8288) ≈ 6.23
# → Soviet countries win ~6x more medals
# Interpretation:
# Strong legacy advantage

# host (0.6327, p < 0.001):
# Positive and significant
# exp(0.6327) ≈ 1.88
# → Host countries win ~88% more medals
# Interpretation:
# Home advantage remains important


# --- ZERO-INFLATION MODEL (logit: probability of always zero) ---

# Interpretation:
# This part models the probability that a country is a "certain zero"
# (i.e., structurally unable to win medals)

# lnGDP (-0.5674, p = 0.0047):
# Significant negative effect
# → Higher GDP reduces probability of being a structural zero
# Interpretation:
# Wealthy countries are less likely to win zero medals

# lnPOP (-0.2214, p = 0.339):
# Not significant → population does not strongly affect zero probability

# soviet (-17.4, huge SE, p ≈ 1):
# host (-14.6, huge SE, p ≈ 1):
# Extremely large coefficients with massive SEs → unreliable estimates
# Likely due to:
# → Perfect or near-perfect separation (e.g., Soviet/host countries almost never zero)

# Intercept (17.03, p < 0.001):
# High baseline probability of zero for low-GDP countries

# Log-likelihood = -259.8

# Compare with Poisson:
# Poisson logLik ≈ -292 → ZIP improves fit

# But compare with NB:
# NB logLik ≈ -183 → NB fits MUCH better than ZIP

# Interpretation:
# ZIP improves over Poisson (handles excess zeros)
# BUT does not outperform Negative Binomial

# 1. Two processes:
#    - Some countries never win medals (structural zeros)
#    - Others follow a Poisson count process

# 2. GDP matters in BOTH parts:
#    - Increases medal count
#    - Reduces probability of zero

# 3. Instability in zero model (huge SEs):
#    → suggests ZIP may not be well-specified

# ZIP captures excess zeros better than Poisson
# BUT:
# - NB already handled overdispersion very well
# - ZIP zero model is unstable (huge SEs)
# - NB likely remains the preferred model
# → ZIP adds complexity without clear improvement over NB


# f) Estimate Zero-Inflated Negative Binomial regression model.
# ZINB model
# Type 1: “Always zero” countries
# No chance of winning medals
# Modeled by the right side (logit part)
# Type 2: “At risk” countries
# Can win medals
# Counts follow a Negative Binomial distribution
model_zinb = zeroinfl(medaltot~lnPOP+lnGDP+soviet+host | 
                        lnPOP+lnGDP+soviet+host, data=medals, dist="negbin")
summary(model_zinb)

# f) Estimate Zero-Inflated Negative Binomial (ZINB) model

# ZINB combines:
# (1) Negative Binomial count model (handles overdispersion)
# (2) Logit model for excess zeros (structural zeros)

summary(model_zinb)


# --- COUNT MODEL (Negative Binomial: number of medals) ---

# lnPOP (-0.0384, p = 0.816):
# Not statistically significant
# exp(-0.0384) ≈ 0.96
# → No meaningful effect of population on medal counts

# lnGDP (0.5370, p < 0.001):
# Strong positive and significant
# exp(0.5370) ≈ 1.71
# → Doubling GDP increases expected medals by ~71%
# Interpretation:
# Economic strength strongly increases medal counts

# soviet (2.2769, p < 0.001):
# Very large and significant effect
# exp(2.2769) ≈ 9.75
# → Former Soviet countries win ~10x more medals
# Interpretation:
# Strong legacy/institutional advantage

# host (0.9513, p = 0.279):
# Not statistically significant
# exp(0.9513) ≈ 2.59
# → Suggests higher medals for hosts, but not reliable


# --- DISPERSION (overdispersion handling) ---

# Theta = 1.435
# Interpretation:
# Relatively small → confirms presence of overdispersion
# Justifies use of NB instead of Poisson


# --- ZERO-INFLATION MODEL (logit: probability of structural zero) ---

# lnGDP (-0.5331, p = 0.025):
# Significant negative effect
# → Higher GDP reduces probability of being a "certain zero"
# Interpretation:
# Wealthy countries are less likely to win zero medals

# lnPOP (-0.2160, p = 0.498):
# Not significant → population does not affect zero probability

# soviet & host:
# Extremely large coefficients with huge SE → not reliable
# Likely due to separation (these countries almost never have zero medals)

# Intercept (15.60, p = 0.002):
# High baseline probability of zero for low-GDP countries


# --- Model fit (comparison) ---

# Log-likelihoods:
# Poisson ≈ -292
# ZIP     ≈ -260
# NB      ≈ -183
# ZINB    ≈ -179.9  ← BEST (highest log-likelihood)

# Interpretation:
# ZINB provides the best fit among all models


# --- Key insights ---

# 1. Two processes confirmed:
#    - Some countries are structural zeros
#    - Others follow NB count process

# 2. GDP matters in BOTH parts:
#    - Increases medal counts
#    - Reduces probability of zero medals

# 3. Population and host effects are NOT robust
#    once overdispersion and zero inflation are controlled for


# --- Final conclusion (numerically justified) ---

# 1. ZINB has the best fit (highest log-likelihood ≈ -179.9)
# 2. Overdispersion is present (theta = 1.435)
# 3. Excess zeros are relevant (significant zero-inflation part)

# → Conclusion:
# ZINB is the most appropriate model for this dataset

# Key takeaway:
# GDP and Soviet legacy are the only robust determinants of Olympic success
# The ZINB model combines a Negative Binomial count model with 
# a logit model for excess zeros, where the left side models medal 
# counts and the right side models the probability of structural zeros.

# g) Compare all the models.
# Comparison
summary(model_p)$aic
summary(model_nb)$aic
AIC(model_zip)
AIC(model_zinb) # this one should be selected!

# The models are compared using the Akaike Information Criterion (AIC),
# where lower values indicate a better fit.

# The Poisson model has the highest AIC (594.07), indicating a poor fit
# due to its restrictive assumption of equal mean and variance.

# The ZIP model improves the fit (AIC = 539.67) by accounting for excess zeros,
# but it still performs substantially worse than models that address overdispersion.

# The Negative Binomial (NB) model provides a dramatic improvement (AIC = 378.03),
# confirming the presence of strong overdispersion in the data.

# The ZINB model further accounts for excess zeros, but its AIC (381.75)
# is slightly higher than the NB model.

# Difference between NB and ZINB:
# 381.75 - 378.03 ≈ 3.72

# Rule of thumb:
# ΔAIC < 2   → models are essentially equivalent
# ΔAIC 2–7   → weak evidence

# Conclusion:
# Although ZINB is more flexible, it does not provide a meaningful improvement
# over the NB model.

###############################################################
BIC(model_p)
BIC(model_nb)
BIC(model_zip)
BIC(model_zinb) # this one should be selected!
# the same conclusion

# AIC vs BIC:

# AIC (Akaike Information Criterion):
# AIC = -2*log(L) + 2*k
# Focuses on predictive accuracy
# Uses a smaller penalty for additional parameters

# BIC (Bayesian Information Criterion):
# BIC = -2*log(L) + k*log(n)
# Where:
# L = likelihood
# k = number of parameters
# n = sample size
# Focuses on selecting the true model
# Penalizes model complexity more strongly (especially for large n)

# Key difference:
# BIC imposes a heavier penalty than AIC → prefers simpler models

# Interpretation:
# AIC → better for prediction
# Because it uses a smaller penalty (2*k), it allows more complex models
# → captures more patterns in the data → improves out-of-sample prediction

# BIC → better for model selection (avoids overfitting)
# Because it uses a stronger penalty (k*log(n)), especially for large samples
# → discourages unnecessary variables → selects simpler, more parsimonious models
# → reduces risk of fitting noise instead of true relationships

