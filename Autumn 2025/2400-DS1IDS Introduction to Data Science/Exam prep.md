**Example exam questions:**

[lectures #1-#2, #5, #8](https://elearning.wne.uw.edu.pl/pluginfile.php/258532/mod_label/intro/intro_ds_test_no_answers.pdf) (Ewa Weychert)

[lectures #3-#4, #6-#7](https://elearning.wne.uw.edu.pl/pluginfile.php/258532/mod_label/intro/example_exam_questions.pdf) (Maciej Świtała PhD), correct answers are: Q1. - A, B; Q2. - A, C; Q3. - none; Q4. - none

List of content 
1. Data science and its economic context - Ewa 
### Econometrics vs Data Science — A Comparative Overview

| **Dimension**            | **Econometrics**                                  | **Data Science / ML**                             |
| ------------------------ | ------------------------------------------------- | ------------------------------------------------- |
| **Primary Goal**         | Causal inference, parameter estimation            | Prediction, pattern recognition                   |
| **Modeling Approach**    | Model-based (theory-driven)                       | Algorithmic / data-driven                         |
| **Assumptions**          | Strong structural and statistical assumptions     | Minimal assumptions, flexible models              |
| **Typical Methods**      | Regression, IV, GMM, panel models                 | Trees, random forests, neural networks, ensembles |
| **Evaluation Criterion** | Consistency, unbiasedness, valid inference        | Out-of-sample predictive accuracy                 |
| **Data Focus**           | Smaller, structured data sets                     | Large, high-dimensional, unstructured data        |
| **Validation**           | Theoretical fit, hypothesis testing               | Cross-validation, regularization, tuning          |
| **Output**               | Interpretability and causal effects               | Accuracy and scalability                          |
| **Core Strength**        | Explanation and policy relevance                  | Prediction and automation                         |
| **Emerging Integration** | Causal ML, double machine learning, hybrid models | Incorporation of theory-based constraints         |



2. Computer programming for data science - Ewa 
3. Introduction to statistics and statistical hypothesis testing- Maciej 
		![[Pasted image 20260118142104.png]]
		---

### 1. Discrete Distributions (Counting)

- **Bernoulli**: A single trial with only two outcomes.
    
    - _Example_: Flipping a coin once (**Heads** or **Tails**).
        
- **Binomial**: Multiple independent Bernoulli trials.
    
    - _Example_: Flipping a coin **10 times** and counting how many times it lands on Heads.
        
- **Poisson**: The number of times an event occurs in a fixed interval of time or space.
    
    - _Example_: The number of **emails** you receive in one hour.

### 2. Continuous Distributions (Measuring)

- **Uniform**: Every outcome in a range is equally likely.
    
    - _Example_: Waiting for a bus that arrives exactly every 10 minutes; if you show up randomly, your wait time is equally likely to be **anywhere between 0 and 10 minutes**.
        
- **Normal (Gaussian)**: The "Bell Curve" where most data clusters around the average.
    
    - _Example_: The **heights** of adult men in a specific country.
        
- **Exponential**: The time between events in a Poisson process.
    
    - _Example_: The **amount of time** you have to wait until the next customer enters a store.
### 3. Specialized Statistical Distributions

These are mostly used in **Inferential Statistics** (testing hypotheses rather than just describing data).

- **Chi-square ($\chi^2$)**: Used to see if observed data fits an expected pattern.
    
    - _Example_: Testing if a **six-sided die is fair** by rolling it 60 times and checking if each number came up roughly 10 times.
        
- **Student’s t**: Used when you have a small sample size and don't know the true population spread.
    
    - _Example_: Testing if a **new drug** lowers blood pressure by testing it on only 15 patients.
        
- **F-Snedecor**: Used to compare the variances (spread) of two different groups.
    
    - _Example_: Comparing the **test score consistency** between two different schools to see which one has more "predictable" results.


1. Introduction to econometrics
2. Introduction to machine learning