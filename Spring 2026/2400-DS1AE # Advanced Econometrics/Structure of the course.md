### 1. Intro / Panel Data Models

- **What it is:** An introduction to working with multi-dimensional datasets that track the exact same cross-sectional units (individuals, firms, countries) over multiple time periods.
    
- **Core Focus:** Learning why simple OLS fails on pooled data and introducing basic panel techniques like **Fixed Effects (FE)** and **Random Effects (RE)** to control for unobserved, time-invariant individual characteristics.
    

### 2. Panel Data Models / Intro to Maximum Likelihood Method

- **What it is:** A shift away from Ordinary Least Squares (OLS) estimation toward **Maximum Likelihood Estimation (MLE)**.
    
- **Core Focus:** MLE doesn't just minimize errors; it finds the parameter values that maximize the probability (likelihood) of observing the data we actually collected. This math is foundational for estimating non-linear models.
    

## Block 2: Microeconometrics & Limited Dependent Variables

### 3. Binary Dependent Variables

- **What it is:** Modeling choices where the outcome is purely qualitative and binary ($0$ or $1$).
    
- **Core Focus:** Critiquing the **Linear Probability Model (LPM)** (running OLS on a $0/1$ variable) and mastering **Logit** and **Probit** models, which bend the regression line into an S-curve using logistic and normal distributions so predicted probabilities stay bounded between $0\%$ and $100\%$.
    

### 4. Ordered Logit & Probit

- **What it is:** Models designed for multi-category outcomes that have a natural, sequential ranking, but no meaningful numerical distance between the choices.
    
- **Core Focus:** Analyzing data like satisfaction surveys or health severity states. The model maps these choices to an underlying continuous scale broken up by estimated numeric thresholds ("cut points").
    

### 5. Multinomial Logit, Conditional Logit

- **What it is:** Models designed for multi-category choices where the options are **unordered** and mutually exclusive.
    
- **Core Focus:** Understanding how individual consumer traits affect choices (**Multinomial Logit**) versus how the features of the choices themselves affect choices (**Conditional Logit**), such as picking a travel mode based on train vs. plane ticket prices.
    

### 6. Models for Count Data

- **What it is:** Frameworks built for outcomes measured as non-negative discrete integers ($0, 1, 2, 3\dots$) representing how many times an event occurs.
    
- **Core Focus:** Utilizing **Poisson** and **Negative Binomial** regressions to model variables like the number of doctor visits or traffic accidents, where data clusters near zero and cannot be negative.
    

### 7. Censored Data, Sample Selection, & Censored Data Model (Tobit)

- **What it is:** Techniques for dealing with continuous data that is blocked, cut off, or heavily piled up at a specific structural threshold.
    
- **Core Focus:** Mastering the **Tobit model** for corner solutions (like zero expenditures on alcohol or dental care) and learning how **Heckman Selection models** fix bias when your sample is missing data non-randomly (e.g., studying wages when you can only observe wages for people who actually have a job).
    

## Block 3: Model Specification & Time-Series Macroeconometrics

### 8. General-to-Specific Approach

- **What it is:** A model-building methodology (often associated with the London School of Economics) used to find the best configuration of variables.
    
- **Core Focus:** Starting with an intentionally oversized, complex model containing all potential explanatory variables and lags, and then systematically stripping away statistically insignificant variables until a parsimonious, robust model remains.
    

### 9. Introduction to Time Series & Spurious Regression

- **What it is:** Transitioning to pure time-series data, where a single entity is tracked sequentially over regular historical intervals.
    
- **Core Focus:** The danger of **spurious regression**—where two completely unrelated variables look highly statistically significant simply because they are both trending upward over time (e.g., charting iPhone sales against global temperatures).
    

### 10. Stationarity and Nonstationarity

- **What it is:** The most vital technical boundary in time-series analysis.
    
- **Core Focus:** Testing whether a time series is **stationary** (its mean, variance, and covariance do not change over time) or **nonstationary** (contains a trend or a random walk) using unit root tests like the Augmented Dickey-Fuller (ADF) test. Nonstationary data must be transformed, or it will break standard OLS assumptions.
    

### 11. Distributed Lag (DL) and Autoregressive Distributed Lag (ARDL) Models

- **What it is:** Time-series models that map dynamic delays in relationships.
    
- **Core Focus:** Modeling a dependent variable using the current and past lagged values of independent variables (**DL**), alongside past lagged values of the dependent variable itself (**ARDL**). This lets you map exactly how long a policy change takes to impact an economy.
    

### 12. ARMA and ARIMA Models

- **What it is:** Univariate forecasting frameworks that look purely at a variable's own historical footprint.
    
- **Core Focus:** Blending past values of the variable (**Autoregressive / AR**) with past forecast shock errors (**Moving Average / MA**). The "I" (**Integrated**) represents differencing non-stationary data to make it stationary before generating forecasts.
    

### 13. Cointegration Analysis

- **What it is:** The econometric solution for non-stationary variables that share a true economic relationship.
    
- **Core Focus:** If two non-stationary time series move together locked in a long-run equilibrium (like a drunk person and their dog on a leash), they are **cointegrated**. You will learn to use **Error-Correction Mechanisms (ECM)** to model how short-term deviations are corrected back to the long-run path.
    

## Block 4: Advanced Frameworks & Causal Inference

### 14. Instrumental Variables (IV)

- **What it is:** A structural strategy used to combat **endogeneity**—which occurs when an independent variable is correlated with the error term, causing massive OLS bias.
    
- **Core Focus:** Finding a third variable (an "Instrument") that is correlated with your problematic independent variable but completely uncorrelated with the error term, allowing you to isolate clean, causal impacts using Two-Stage Least Squares (2SLS).
    

### 15. Advanced Panel Models

- **What it is:** Pushing panel data estimation beyond basic Fixed or Random effects.
    
- **Core Focus:** Dealing with **Dynamic Panels** (where lagged values of the dependent variable are included as regressors) using advanced Generalized Method of Moments (GMM) estimators like the Arellano-Bond estimator to handle endogeneity in complex, over-time datasets.
    

> **Study Guide Strategy:** Notice how the course builds a bridge. It ensures you know how to handle data with messy boundaries (Blocks 1 & 2), shifts into tracking dynamic variables across time (Block 3), and concludes by showing you how to prove real mathematical causality instead of mere correlation (Block 4).