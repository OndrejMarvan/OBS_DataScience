
## Lab 07 (given during Lab 06)
First, note that the model includes dummy variables for hours 1 through 23. Because `hour 0` (midnight) is omitted from the output, it serves as the reference (base) category for the model.

### a) Interpret the estimate of the parameter for hour12 in the Poisson model

The estimated coefficient for `as.factor(hour)12` is **0.89944**.

In a Poisson regression model, the coefficients represent the expected change in the log of the response variable. To interpret this in terms of the actual counts (number of submissions), we must exponentiate the coefficient:

$\exp(0.89944) \approx 2.458$

**Interpretation:** The expected number of manuscript submissions during hour 12 (12:00 PM) is approximately 2.46 times higher (or about 145.8% higher) than the expected number of submissions during the base hour of midnight (hour 0), holding all else constant.

### b) What hour do researchers submit the most papers? Interpret the estimate's value

To find the hour with the most submissions, we look for the highest positive coefficient among the hour factors.

- The highest coefficient is for **hour 16** (4:00 PM), with an estimate of **1.04376**.
    
- Exponentiating this value: $\exp(1.04376) \approx 2.840$
    

**Interpretation:** Researchers submit the most papers at 4:00 PM. The expected number of submissions during this hour is roughly 2.84 times the expected submissions at midnight.

### c) What hour is connected with the least number of submitted papers? Interpret the value

Conversely, the least number of submissions corresponds to the most negative coefficient in the output.

- The lowest coefficient is for **hour 5** (5:00 AM), with an estimate of **-2.03427**.
    
- Exponentiating this value: $\exp(-2.03427) \approx 0.131$
    

**Interpretation:** The lowest number of submissions occurs at 5:00 AM. The expected number of submissions during this hour is only about 13.1% of the expected submissions at midnight (an 86.9% decrease).

### d) Are all the variables jointly significant?

Yes, they are jointly significant. We can determine this by conducting a Likelihood Ratio (LR) Test comparing the null model (intercept only) to our current model using the deviance statistics provided in the output:

- **Null Deviance:** 105214 on 876 degrees of freedom.
    
- **Residual Deviance:** 79954 on 853 degrees of freedom.
    

The test statistic is the difference between the deviances:

$LR = 105214 - 79954 = 25260$

This statistic follows a Chi-square distribution with degrees of freedom equal to the difference in degrees of freedom between the two models ($876 - 853 = 23$). A value of 25260 on 23 degrees of freedom yields a p-value that is practically zero. Therefore, we firmly reject the null hypothesis and conclude that the variables (the hours of the day) are jointly significant in explaining the number of paper submissions.

### e) What other econometric models could be estimated for the data? Explain.

Since the dependent variable represents counts (number of submissions), there are several alternative count-data models that might be more appropriate depending on the data's characteristics:

1. **Negative Binomial Model:** The current Poisson model assumes that the mean and variance of the counts are equal. However, looking at the residual deviance (79954) divided by its degrees of freedom (853), the result is much greater than 1. This strongly indicates **overdispersion** (the variance is much larger than the mean). A Negative Binomial regression adds a parameter to account for this overdispersion, leading to more reliable standard errors and p-values.
    
2. **Zero-Inflated Poisson / Zero-Inflated Negative Binomial:** If there are more instances of "zero submissions" in certain hours/countries than a standard Poisson or Negative Binomial distribution would naturally predict, a zero-inflated model separates the process into two parts: a logit model determining whether a count is zero or positive, and a count model for the actual submissions.
    
3. **Hurdle Model:** Similar to the zero-inflated model, this treats the decision/probability of submitting _any_ paper (passing the "hurdle" from 0 to 1) differently from the process determining the volume of papers submitted once that hurdle is crossed.