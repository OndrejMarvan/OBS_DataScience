# [cite_start][Lecture 01]: Introduction to Advanced Econometrics & Data Types [cite: 1, 123]
**Tags:** #econometrics #lecture_01 #data_types #elasticity

## 1. Core Concepts & Definitions
* [cite_start]**Data Types:** Econometric analysis utilizes three main types of data: cross-sectional, time series, and panel data[cite: 2, 3, 4, 5, 213, 214, 215, 216].
* [cite_start]**Panel Data Structure:** Consists of multiple entities (e.g., firms) observed over multiple time periods (e.g., years), tracking variables like production, area, labor, and fertilizer use across the same entities over time[cite: 224, 225].
* [cite_start]**Variable Classification:** Variables can be classified as continuous, discrete, qualitative, or quantitative[cite: 35, 36, 37, 38, 39, 217, 218, 219, 220, 221].
* [cite_start]**Qualitative Variables:** Can be further divided into ordered (e.g., customer satisfaction levels) and unordered categories (e.g., colors, brands)[cite: 20, 21, 22, 23, 24].
* [cite_start]**Truncated/Censored Data:** Refers to variables that are restricted to a specific range, such as $y \in [0, +\infty)$ representing non-negative household medical expenditures[cite: 13, 28, 29, 41, 50].
* [cite_start]**Percentages vs. Percentage Points:** Distinguishing between a percentage change and a percentage point change is a crucial conceptual difference when interpreting variables like interest rates[cite: 108, 120, 121].

## 2. Key Formulas & Models
[cite_start]This introductory lecture outlines various functional forms and how their respective coefficients are interpreted[cite: 188, 189, 190, 191, 192, 195, 198, 202].

**Log-Log Model (Elasticity)**
$$
ln(y_i) = \beta_0 + \beta_1 ln(x_i) + \epsilon_i
$$
* [cite_start]In a log-log specification, the coefficient represents the elasticity between the variables[cite: 92].
* [cite_start]**Interpretation:** A $1\%$ increase in $x$ is associated with a $\beta_1\%$ change in $y$[cite: 103].

**Log-Linear Model with a Dummy Variable (Exact Semi-elasticity)**
$$
ln(y_i) = \beta_0 + \beta_1 D_i + \epsilon_i
$$
* [cite_start]When an explanatory variable is a binary dummy, the standard coefficient interpretation is only an approximation[cite: 96, 105].
* **Formula:** To find the exact percentage change in $y$ when the dummy variable switches from $0$ to $1$, the exact semi-elasticity formula must be used:
$$
[exp(\beta_1) - 1] \cdot 100\%
$$
* [cite_start]The equation above calculates the exact semi-elasticity for dummy variables in log-linear models[cite: 89, 90].

## 3. Assumptions & Properties
* [cite_start]**Model Mapping Strategy:** The choice of model is dictated by the dependent variable type[cite: 184, 185]. [cite_start]For example, ARIMA/ARDL are used for time series, Logit/Probit for binary outcomes, Multinomial/Conditional Logit for unordered discrete choices, Tobit for censored data, and Panel models for longitudinal data[cite: 185].

## 4. Seminar Practical Application / Interpretations
* **Military Expenses Example:** The lecture provides a model analyzing military budgets among countries: 
$$
ln(ARMY_i) = 1.284 + 0.005 ln(GDP_i) - 0.01 ln(POPULATION_i) - 1.10 noSEA_i + \epsilon_i
$$
[cite_start][cite: 206, 207].
* [cite_start]**Elasticity Interpretation in Practice:** The coefficient for $ln(GDP_i)$ is $0.005$, indicating that a $1\%$ increase in a country's GDP is associated with a $0.005\%$ increase in its military budget[cite: 103].
* [cite_start]**Dummy Interpretation in Practice:** The variable $noSEA_i$ is a dummy variable equal to $1$ if the country is landlocked (no direct access to international waters) and $0$ otherwise[cite: 209]. [cite_start]Because its coefficient is $-1.10$, calculating the exact percentage effect requires the exact semi-elasticity formula $[exp(-1.10) - 1] \cdot 100\%$[cite: 89, 114, 207].