## Lab 1 (19.02.2026) - missed 

## Lab 2 (26.02.2026)
- FE correlated
- RE not correlated 
	==TEST== We may receive stat extract and are asked to interpret 

![[Pasted image 20260226190533.png]]
![[Pasted image 20260226190554.png]]

**Important**: Follow the steps in exercise file in e) Hausman Test -> Interpretation
![[Pasted image 20260226193722.png]]
**Professor will provide us with corrected version the day after

Suggestion to topic: ???


## Lab 5 (XX.03.2026)
# Advanced Econometrics: Multinomial Logit, Conditional Logit

_Tags: #econometrics #statistics #discrete_choice #logit_models_

---

## 1. Categorical Dependent Variables

Many empirical models involve dependent variables that are categorical (e.g., satisfaction levels, transport choices) rather than continuous.

### Ordered vs. Unordered Logit Models

- **Ordered Logit (Ordinal Logit):** Used when categories have a natural ranking, such as a satisfaction scale from "Very dissatisfied" to "Very satisfied".
    
    - **Mechanism:** It assumes an underlying latent variable $y^* = X\beta + \epsilon$ and estimates coefficients along with cut-points (thresholds) $\tau_j$.
        
    - **Key Assumption:** Relies on the Proportional Odds (Parallel Lines) assumption. This means each explanatory variable shifts the odds of being in a higher category by the same amount, regardless of where the cut-point is (slopes are identical, only intercepts change). Tested using the Brant test.
        
- **Multinomial Logit (MNL / Unordered Logit):** Used when categories have no inherent order, such as choosing between a car, bus, or train.
    
    - **Mechanism:** It compares each outcome to a reference category, generating separate parameter vectors ($\beta$) for each alternative.
        
    - **Key Assumption:** Relies on the Independence of Irrelevant Alternatives (IIA) assumption. Tested using Hausman or Small-Hsiao tests.
        

Note: If the proportional odds assumption fails for an ordered logit, you should fall back on a generalized/partial ordered logit or a multinomial logit (which is more flexible but less efficient) .

---

## 2. Multinomial Logit vs. Conditional Logit

Both models are used when people choose one option from several alternatives.

### Multinomial Logit (MNL)

- **Main Question:** Who chooses what?
    
- **Focus:** Choice depends on the characteristics of the _person_.
    
- **Variables Used:** Income, age, gender, education .
    
- **Utility Function:** $U_{ij} = X_i\beta_j + \epsilon_{ij}$ (Parameters $\beta$ vary by alternative $j$, but $X$ is individual-specific).
    

### Conditional Logit (CL)

- **Main Question:** What option is attractive?
    
- **Focus:** Choice depends on the characteristics of the _alternatives_.
    
- **Variables Used:** Price, travel time, distance, comfort .
    
- **Utility Function:** $U_{ij} = Z_{ij}\beta + \epsilon_{ij}$ (The characteristics $Z$ vary by alternative, but the parameter $\beta$ is common).
    

### The IIA Problem (Independence of Irrelevant Alternatives)

- **Definition:** The odds ratio between two alternatives does not depend on other available alternatives (e.g., adding a "Blue Bus" steals equally from "Car" and "Red Bus", which is unrealistic) .
    
- **CL vs IIA:** Conditional logit improves on basic MNL by using alternative-specific variables, making predictions more realistic, but it **does not** fully remove the strict IIA assumption .
    

---

## 3. Advanced Models: Mixed and Nested Logits

### Mixed Logit (Random Parameters Logit)

- **Concept:** People have different tastes, so coefficients are random and vary across individuals ($\beta_i \sim f(\beta)$) rather than being fixed.
    
- **Advantages:** It is highly flexible, captures unobserved preference heterogeneity, allows correlation across alternatives, and effectively relaxes the strict IIA assumption .
    
- Note: Mixed cloglog is for timing/hazard models, whereas Mixed logit is for choices among alternatives .
    

### Nested Logit

- **Concept:** Groups similar alternatives into "nests" (e.g., public transport vs. private transport).
    
- **Advantages:** Partially relaxes IIA. IIA holds _within_ a nest, but not necessarily across all alternatives, allowing for stronger substitution among similar choices.
    

---

## 4. Data Preparation in R (`mlogit` package)

To estimate these models, data must be converted from **Wide Format** to **Long Format**.

- **Wide Format:** 1 row per individual. Alternative attributes (like prices) are stored in separate columns (e.g., `price.beach`, `price.boat`).
    
- **Long Format:** Multiple rows per individual (1 row per alternative).
    
    - This is required because CL models compare alternatives _within_ each choice situation.
        

### Key Variables in Long Format

- **`alt`**: The name of the specific alternative (e.g., beach, boat).
    
- **`chid`**: Choice ID. Groups rows belonging to the same decision-maker or choice occasion.
    
- **`mode`**: Becomes a logical indicator (`TRUE` for the chosen alternative, `FALSE` for non-chosen ones) .
    
- **Individual variables (e.g., `income`)**: Repeat identically across all alternative rows for the same person.
    

### Formula Syntax in `mlogit`

The formula dictates the type of model : `Dependent Variable ~ Alternative-Specific Variables | Individual-Specific Variables`

- `mode ~ 0 | income`: Pure Multinomial Logit (no alternative-specific regressors).
    
- `soda ~ feat + disp + price | 0`: Conditional Logit (no individual-specific regressors).
    

---

## 5. Interpreting Results & Marginal Effects

- **Signs:** A negative coefficient (like price) lowers the probability of choice, while a positive coefficient (like display) raises it.
    
- **Marginal Effects Matrices:** * **Diagonal elements:** Own-effects (e.g., an increase in Coke's price decreases Coke's probability).
    
    - **Off-diagonal elements:** Cross-effects (e.g., an increase in Coke's price increases Pepsi's probability, showing substitution).
        
- **Percentage Points vs. Percent:** * Marginal effects in choice models are typically interpreted in **percentage points (pp)** (the absolute difference between percentages) rather than percent (relative change).
    
    - A 1 pp change can be economically huge if the baseline probability is very small.


## Lab 6 (26.03.2026) 
## Advanced Econometrics: Models for Count Data

_Tags: #econometrics #statistics #count_data #regression_

---

## 1. Introduction to Count Data

- **Definition:** Count data is data that simply counts things.
    
- **Properties:** It only takes non-negative integer values ($0, 1, 2, 3, \dots$) and cannot be negative or expressed as decimals.
    
- **Examples:** The number of accidents, the number of hospital visits, or the number of emails received.
    

### Why Linear Regression Fails

- Linear regression can predict negative values, which is impossible for count data since it is always non-negative.
    
- The variance in count data is often not constant, violating standard linear regression assumptions.
    

---

## 2. Poisson Regression (The Baseline Model)

The Poisson distribution is used for counting things, characterized by one key number: $\lambda$, which represents the average or expected count.

- **Model:** $Y \sim Poisson(\lambda)$ where $Y$ is the actual count.
    
- **Regression Equation:**
    
    $$\log(\lambda) = X\beta$$
    
    - Using the log link ensures that predictions always stay positive.
        
    - This translates to: $\lambda = e^{X\beta}$.
        
- **Interpretation of Coefficients ($\beta$):** A +1 unit increase in $X$ multiplies the expected count by $e^\beta$; it does not simply add to it.
    
- **Core Assumption:** The Poisson model strictly assumes that the mean is equal to the variance.
    

---

## 3. Handling Overdispersion (Negative Binomial Model)

**The Problem:** Real-world data is often more "spread out" than the Poisson model expects, meaning it has too many very small and very large values.

- This creates a situation where the variance is greater than the mean ($Variance > Mean$), which is called overdispersion.
    
- Because Poisson assumes Mean = Variance, it underestimates variability and leads to wrong conclusions.
    

**The Solution:** Use the Negative Binomial (NegBin) model because it allows for extra variability (fatter tails in the distribution).

- **Model:** $Y \sim NegBin(\mu, \theta)$.
    
    - $\mu$ = expected count (similar to Poisson).
        
    - $\theta$ = extra variability parameter.
        
- **Intuition:** It adds extra randomness to the process, allowing the variance to be larger than the mean to handle uneven, messy data.
    

---

## 4. Handling Excess Zeros (ZIP & Hurdle Models)

**The Problem:** Sometimes data has a lot more zeros than the Poisson model expects. Poisson assumes zeros happen "naturally" as part of the standard counting process and mixes everyone together.

To solve this, we use models that split the data into separate processes.

### Zero-Inflated Poisson (ZIP)

- **Concept:** Assumes there are two types of people: an "always-zero" group and a "count" group (which can also generate zeros).
    
- **Sources of Zeros:** Zeros come from **TWO** sources.
    
    1. The person is strictly in the always-zero group.
        
    2. The person is in the normal count group, but their count just happened to be zero this time.
        
- **The Math Structure:**
    
    - $\psi_i$ = chance of being always zero (modeled via logit/probit).
        
    - $\lambda_i$ = average count for the count group.
        

### Hurdle Models

- **Concept:** Breaks the process into two separate sequential decisions: first, whether it is zero or not (the "hurdle"), and second, how many (if not zero).
    
- **Sources of Zeros:** Zeros come from **ONE** source only.
    
    1. Step 1 (Binary model): Models whether $Y=0$ or $Y>0$ (e.g., do you go to the hospital or not?).
        
    2. Step 2 (Count model): Only applies to positive values ($Y>0$) using a truncated distribution where zero is NOT allowed.
        

---

## 5. Model Selection Guide

| **Model**             | **When to use**                                    | **Intuition / Key Feature**                                                                                 |
| --------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **Poisson**           | Mean $\approx$ variance; independent events.       | Basic choice for simple count data. Random arrivals with a constant rate.                                   |
| **Negative Binomial** | Variance $>$ mean (overdispersion).                | Directly models overdispersion; acts like a Poisson model with extra variability.                           |
| **ZIP**               | Excess zeros beyond what Poisson expects.          | Zeros come from two sources (structural always-zeros + the count model itself).                             |
| **ZINB**              | Excess zeros **and** overdispersion.               | Same concept as ZIP but adds flexible variance to handle the extra spread.                                  |
| **Hurdle**            | Zero vs. positive outcomes are separate processes. | First cross the hurdle to leave zero; the positive counts use a truncated model where no zeros are allowed. |


## Lab 7 (09.04.2026)
# Advanced Econometrics: Censored Data Models

_Tags: #econometrics #statistics #censored_data #tobit #heckman_

---

## 1. Limited Dependent Variables (LDV)

- **Definition:** These are dependent variables that are restricted to a specific interval.
    
- **Examples:** Outcomes bounded to $[0, \infty)$ (such as expenditures) or outcomes bounded between $[a, b]$.
    
- **Why not OLS?:** Standard OLS is often inappropriate for this type of data.
    

---

## 2. The Three Key Models (Overview)

- **Tobit Model:** We observe everyone in the dataset, but for some individuals, the outcome is "stuck" at a limit (e.g., hitting a wall).
    
- **Truncated Regression:** We only see part of the sample because some people are completely missing from the dataset.
    
- **Heckman Model:** The outcome is missing for a non-random group due to self-selection.
    

---

## 3. Tobit Model (Censored Regression)

- **When to use:** Used when the dependent variable is limited or censored at a specific value, typically zero, causing many observations to pile up exactly at that limit.
    
- **The Latent Variable:** The model assumes there is a hidden (latent) variable, $y_i^*$, that we would like to observe.
    
- **Observation rules:** We only observe 0 if the true value is too low, and we observe the true value ($y_i^*$) if it is above the limit.
    
- **Why OLS fails:** OLS assumes the dependent variable is fully observed and tries to fit a straight line through many zeros. This pulls the regression line down, resulting in biased coefficients and inconsistency (estimates do not converge to true values even with more data).
    
- **Corner Solution vs. Censoring:**
    
    - **Corner Solution:** Zero is a real, optimal choice (e.g., spending $0 on charity), meaning no hidden information exists.
        
    - **Censoring:** The observed value does not equal the true value due to a data problem, such as a survey capping answers at a threshold (e.g., income "4k+").
        
- **Marginal Effects:** Unlike OLS, Tobit has multiple marginal effects because a single variable affects two things: participation (whether $y > 0$) and intensity (how much $y$ is when $y > 0$).
    
    1. **Unconditional expectation:** $\frac{\partial E[y]}{\partial x}$ measures the effect of $x$ on the overall expected value of $y$, including both zeros and positive values.
        
    2. **Conditional expectation:** $\frac{\partial E[y|y>0]}{\partial x}$ measures the effect of $x$ only for individuals with positive outcomes ("among those who participate").
        
    3. **Probability of being uncensored:** $\frac{\partial P(y>0)}{\partial x}$ measures the effect of $x$ on the probability of having a positive outcome.
        

---

## 4. Truncated Regression (Missing Data)

- **When to use:** Used when part of the population is completely missing from the dataset, meaning we only observe a subset of individuals.
    
- **The Problem:** We do not see the full distribution because the data is cut off from one side (left or right).
    
- **Truncation vs. Censoring:**
    
    - **Truncation:** Observations are completely missing (e.g., a dataset containing only billionaires), and we do not even know these missing observations exist.
        
    - **Censoring:** All observations are present, but some true values are partially hidden or reported as limits.
        

---

## 5. Heckman Sample Selection Model

- **When to use:** Used when selection into the sample is non-random, meaning we only observe outcomes for a systematically different, selected group.
    
- **The Problem (Self-Selection):** People choose whether to be in the sample or to be observed. For example, we only observe wages for women who work, meaning working women (who may be more educated or motivated) create a biased sample.
    
- **Model Structure:** The Heckman model uses a two-step idea to correct for selection bias.
    
    1. **Step 1 (Selection Equation):** A Probit model ($D^* = Z\gamma + u$) that determines the probability of being in the sample (who is observed).
        
    2. **Step 2 (Outcome Equation):** A model ($y = X\beta + \epsilon$) that determines the actual value of the dependent variable, which is only observed when the individual is in the sample ($D = 1$).
        

---

## 6. Model Choice Summary

|**Model**|**Problem**|**Example**|
|---|---|---|
|**Tobit**|Censoring, many zeros, or boundary values.|Charity spending, or number of affairs.|
|**Truncated**|Missing observations or sample cut off.|Income > 2000 only, or test score $\ge 40$.|
|**Heckman**|Self-selection or non-random sample.|Wages (only workers), or loan approval.|


## Lab 8 (16.04.2026)
# Time Series 


## Lab 11 (07.05.2026)
stationerity, non-stationerity 

Augmented dec in the test and what are the other tests (KPSS a PP tests) for stationerity 


## Lab 2 (14.05.2026) - different than expected topic (cointegration)
What to expect in the test: 
- Check if cointegrated or not from the screenshot



## Lab 13 (21.05.2026)
Will give us 2 questions regarding slide 30 out of 32 in the presentaiton



# Exam Preparation
## L1
Note: If you can excusse the model than use it. It  depends a lot on data we have. 
Car colour choice determinants 
© Regression (OLS) © Logit/Probit © Ordered choice model © **Unordered choice mode**
- because we cannot order them in a natural way

he number of plane accidents across countries over the last 20 years. © Negative binomial © **Panel data model** © Tobit © ARIMA
- Pdm for count data (out of scope of the course)

Consider determinants of the number of children in Polish marriages. 
© **Count data model** © Ordered choice model © Unordered choice model © Logit/Probit
- data are integers (1, 2, 3,...)

What determines the choice of the field of study at the university? 
© Logit/Probit © ADL © Ordered choice model © **Unordered choice model**

Modelling the number of doctor visits © Regression (OLS) © Logit/Probit © Ordered choice model © Unordered choice model  © **Count data model**

Household’s medical insurance determinants 
© Classical regression © Duration analysis © **Logit/probit** © Tobit 

7.Doctor visit satisfaction survey. Options: very satisfied, satisfied, neutral, dissatisfied, strongly dissatisfied 
©  Logit/Probit © **Ordered choice model** © Unordered choice model © Negative binomial 

8.Opinion on teenage birth control 
© **Unordered choice model** © Ordered choice model © Logit/probit © Count data model

9.Dental care expenses 
© Count data model © Simple regression © Logit/Probit © **Tobit** (because it cannot be negative)

10.Attitudes toward abortion 
© Logit © **Order choice model** © Panel data model © Classical regression

11.Modelling the football match result. The match may end with a draw, win or defeat. © Classical regression © Logit/Probit © **Ordered choice model** © Unordered choice model 
- cannot be Logit/probit or Tbit because we have more than 2 options

12. Household’s alcohol expenditures. The amount spent might be zero, or positive, however, it cannot be negative. © Classical regression © ARIMA © Logit/probit © **Tobit** 
	

13. What determines the choice of the field of study at the university? © Logit/Probit © ADL © Ordered choice model © Unordered choice model 

14. Patients were offered three alternatives to cure the disease they had. The options were: a standard medicine, a new medicine that had just entered the market, or no medicine at all. © Logit/Probit © Ordered choice model © **Unordered choice model** © Count data model 
	- unordered if we believe there is no natural order. 

15. The effect of smoking on lung cancer © Logit/Probit © **Panel data model** © **Tobit** © **Ordered choice model** 

16. Why do people decide to buy a German car? © Logit/Probit © Ordered choice model © **Unordered choice model** © Negative binomial 

17. Why do Poles decide to buy imported used cars? © Count data model © Negative binomial © Logit/Probit © Tobit 

18. Who spends their holidays in Thailand? © Logit © ARIMA © Panel data model © Classical regression 

19. A clinical study on the response to chemotherapy: progressive disease, no change, partial remission, complete remission © Logit/Probit © Ordered choice model © Unordered choice model © Count data model 

20. Mental impairment study. The impairment is measured as well, mild, moderate, or impaired. The study relates the impairment with the number and severity of important life events and socioeconomic status. © Logit/Probit © Ordered choice model © Unordered choice model © Count data model 

21. Do you want to work at a bank after your studies? © Ordered choice model © Logit/Probit © Unordered choice model © Tobit

Presentation: 

## Lab1

### Hypothesis Testing Cheat Sheet

|**Term**|**Symbol / Abbr.**|**Simple Definition**|**What it means in practice**|
|---|---|---|---|
|**Null Hypothesis**|H0|The default assumption that there is _no effect_, _no difference_, or _no relationship_ between variables.|The "status quo." In regression, it usually means a variable has no effect on the outcome (its coefficient is exactly zero).|
|**Alternative Hypothesis**|H1 or HA|The claim you are actually trying to prove. It states there _is_ an effect, difference, or relationship.|What you conclude if you have enough evidence to reject the null hypothesis.|
|**Significance Level**|α (Alpha)|The threshold you set before the test to decide if a result is strong enough to reject H0. Usually set at 0.05 (5%).|Your tolerance for a "false positive." An α of 0.05 means you accept a 5% chance of being wrong when rejecting H0.|
|**p-value**|p|The probability of seeing your data's results (or more extreme) if the Null Hypothesis is actually true.|A measure of evidence _against_ H0. A tiny p-value means your results would be very unlikely if H0 were true.|
|**Statistically Significant**|p < α|The result when your p-value is smaller than your Alpha threshold.|We have enough evidence to **reject H0**. We conclude the variable _does_ have a real effect (it is not just random luck).|
|**Not Statistically Significant**|p ≥ α|The result when your p-value is greater than or equal to your Alpha threshold.|We **fail to reject H0**. We don't have enough evidence to say the variable has an effect. _(Note: We never say we "accept" H0, we just fail to reject it)._|
