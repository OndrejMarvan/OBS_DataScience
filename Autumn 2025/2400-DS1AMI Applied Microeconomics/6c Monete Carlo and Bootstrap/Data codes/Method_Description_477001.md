# Method Description

**Student:** 477001

## My Answer
- alpha = 72.68 
- beta = -0.7814

## What I Changed (3 things)

### 1. Remove outliers before bootstrap
- First I run regression on all 350 points
- Calculate residuals (distance from line)
- Remove points with biggest residuals (keep 85%)
- Now I have ~297 clean points

### 2. More bootstrap iterations
- Original code: 1000 iterations
- My code: 2000 iterations (more stable result)

### 3. Use median instead of mean
- Original code uses mean(alfa_b) and mean(beta_b)
- I use median(alfa_b) and median(beta_b)
- Median is better because it ignores extreme values

## Why it works
Outliers pull the regression line away from true value. By removing them first, we get better estimate.
