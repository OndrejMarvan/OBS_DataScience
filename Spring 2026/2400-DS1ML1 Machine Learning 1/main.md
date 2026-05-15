## Lab 1 (27.02.2026)
Together with Michal Wozniak

Course prerequisites
We require you to know:
well linear algebra, calculus, statistics, and probability theory (recommended to read and understand Deisenroth P., Faisal A., Ong S. (2020). Mathematics for machine learning. Cambridge University Press);
at least basic Python programming skills (recommended to:
read and understand Matthes, E. (2019). Python crash course: A hands-on, project-based introduction to programming. no starch press
or
do Programiz Python Programming Course: https://www.programiz.com/python-programming). 

==Check the literature, especially the first one==
James, G., Witten, D., Hastie, T., & Tibshirani, R. (2021). An Introduction to Statistical Learning. Springer, New York, NY (offical online access: https://www.statlearning.com/)
Hastie, T., Tibshirani, R., & Friedman, J. (2009). The Elements of Statistical Learning. Springer-Verlag. 
Harrington, P. (2012). Machine learning in action (Vol. 5). Greenwich, CT: Manning.
Intel (2018). Introduction to Machine Learning. Retrieved from https://www.intel.com/content/www/us/en/developer/learn/course-machine-learning.html
VanderPlas, J. (2016). Python data science handbook: Essential tools for working with data. O'Reilly Media, Inc.

The following weights are used to determine the final grade (max 100 pts):
- 40 pts - mid-term theoretical exam
- 30 pts for each of 2 projects, including:
    - 10 pts for in class presentation
    - 10 pts for presentation contents
    - 10 pts for models performance in competition (out of sample test)


## Mock Test 
### Question 1: Testing the significance of the entire model

**Options:**

- A) is possible only in non-parametric models
    
- B) allows to assess whether the estimated model is able to explain the variability of the studied phenomenon
    
- C) consists in testing the hypothesis that all parameters of the model (including the constant) are equal to zero at the same time
    
- D) allows to assess which of the variables have a significant impact on the studied phenomenon
    

**Correct Answer:** B) allows to assess whether the estimated model is able to explain the variability of the studied phenomenon

**Reasoning:** Testing the overall significance of a model (typically via an F-test in regression) evaluates if the independent variables, as a group, reliably predict the dependent variable. It assesses whether the model explains a statistically significant portion of the variance. Option C is incorrect because the null hypothesis usually tests only the slope coefficients, not the constant (intercept). Option D describes testing individual parameters (like a t-test), not the entire model.

---

### Question 2: Which of the following statements regarding the information criteria is NOT true

**Options:**

- A) information criteria impose an additional "penalty" on the optimization criterion for the size of the model
    
- B) information criteria can be used to select the best model
    
- C) the lower the value of the information criterion, the worse the model
    
- D) the use of the BIC criterion often results in a model with fewer variables than in case of AIC
    

**Correct Answer:** C) the lower the value of the information criterion, the worse the model

**Reasoning:** Information criteria, such as the Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC), evaluate model quality by balancing goodness-of-fit against complexity. The goal is to minimize information loss; therefore, a _lower_ value indicates a _better_ model. This makes statement C false.

---

### Question 3: The problem of overfitting

**Options:**

- A) may appear for too flexible model
    
- B) means a monotonic increase in the prediction error on the training sample
    
- C) means a monotonic increase in the forecast error on the test sample
    
- D) means estimating the model on too many samples
    

**Correct Answer:** A) may appear for too flexible model

**Reasoning:** Overfitting occurs when a machine learning model is too complex (highly flexible) and learns the "noise" or random fluctuations in the training data rather than the underlying pattern. When overfitting happens, the prediction error on the _training_ sample decreases (invalidating option B), but the error on unseen test data increases.

---

### Question 4: Which of the following statements regarding cross-validation is NOT true

**Options:**

- A) cross-validation means randomly dividing the training sample into smaller samples and estimating the analyzed model several times
    
- B) cross-validation can be used to tune model hyperparameters (search for their optimal values)
    
- C) cross-validation can be used to estimate the prediction error on the new data
    
- D) cross-validation means randomly dividing the test sample into smaller samples and estimating the analyzed model several times
    

**Correct Answer:** D) cross-validation means randomly dividing the test sample into smaller samples and estimating the analyzed model several times

**Reasoning:** The defining rule of machine learning evaluation is that the test sample must remain completely isolated and "unseen" until the very final evaluation. Cross-validation is performed entirely on the _training_ data (splitting it into training and validation folds) to tune hyperparameters and prevent overfitting. You never divide or train on the test sample.

---

### Question 5: The LASSO method

**Options:**

- A) is an algorithm used exclusively to solve regression problems
    
- B) can be used as a method of selecting variables for the model
    
- C) requires rescaling the variables to the range 0-1
    
- D) consists in dividing the sample into a larger number of subgroups in order to obtain a more accurate match
    

**Correct Answer:** B) can be used as a method of selecting variables for the model

**Reasoning:** LASSO (Least Absolute Shrinkage and Selection Operator) applies L1 regularization. A unique property of L1 regularization is that it can shrink the coefficients of less important features exactly to zero. Because it eliminates certain variables from the final model, it acts as an automatic feature selection method.

---

### Question 6: Which of the following statements regarding leave one out validation (LOOCV) is NOT true

**Options:**

- A) LOOCV validation does not require the use of a random number generator
    
- B) LOOCV validation is more often used in small datasets
    
- C) LOOCV validation may give a different assessment of the forecast error, depending on the division of the learning sample into smaller subsamples used in it
    
- D) in LOOCV validation, the average prediction error is calculated as the average of n errors, where n is the size of the training sample
    

**Correct Answer:** C) LOOCV validation may give a different assessment of the forecast error, depending on the division of the learning sample into smaller subsamples used in it

**Reasoning:** LOOCV is an extreme form of k-fold cross-validation where _k_ equals the number of data points (_n_). Because you leave exactly one observation out for testing in each iteration, the "split" is completely deterministic. Unlike standard k-fold cross-validation, there is no randomness involved in how the data is divided. Therefore, LOOCV will always yield the exact same assessment for a given dataset, making statement C false.


## L? (15.05.2026)
Kedro
https://kedro.org/

Node <- In df1, Out df 

Pipeline




