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