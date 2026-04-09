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

|**Model**|**When to use**|**Intuition / Key Feature**|
|---|---|---|
|**Poisson**|Mean $\approx$ variance; independent events.|Basic choice for simple count data. Random arrivals with a constant rate.|
|**Negative Binomial**|Variance $>$ mean (overdispersion).|Directly models overdispersion; acts like a Poisson model with extra variability.|
|**ZIP**|Excess zeros beyond what Poisson expects.|Zeros come from two sources (structural always-zeros + the count model itself).|
|**ZINB**|Excess zeros **and** overdispersion.|Same concept as ZIP but adds flexible variance to handle the extra spread.|
|**Hurdle**|Zero vs. positive outcomes are separate processes.|First cross the hurdle to leave zero; the positive counts use a truncated model where no zeros are allowed.|


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