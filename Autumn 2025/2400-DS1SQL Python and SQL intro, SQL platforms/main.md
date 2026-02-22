In the test:
- definitely Inheritence
- Right square which returns people who are older than some age and buys iPhone 5...
- multidimensional arrays
28.11. done with Python for now, continuation with SQL

Homework 
- sth that uses database, is connected to Python and has web application (can be used e.g. Django, but required to write raw SQL queries that can be skipped in Django)
- We'll create SQL in Jupyter notebook for our projects

## Used libraries
- Keyword
- Math
- Numpy
- Pandas

## SQL Part
- Use of SQL Lite database
- https://app.genmymodel.com/api/login

# L01
- 07.01.2026 deadline to submit Python projects (can be done in LaTeX)
- final exam multiple choice questions (MCQs)

- ==Be adding comments==, so professor will understand in order not to make the prof. crazy
- If we plan to speed up the code 5 sec but spend on it few hours, not worth it. Just write the code 
- **What?** Understanding the difference between functional and object-oriented programming – both paradigms have different advantages, and recognizing when to use each is important.

> [!PDF|yellow] [[python_1.pdf#page=7&selection=0,0,12,7&color=yellow|python_1, p.7]]
> > Final Exam Format: Multiple-choice questions (MCQs) (A multiple-choice question is a type of objective assessment in which a question has zero or more possible answers) Number of questions: 25 Time limit: 90 minutes Date of exam – during the examination session: 26 January 2026 – 8 February 2026 (to be determined later by the administration office)
> 

![[python_1.pdf#page=8&selection=2,0,39,44&color=yellow]]


Don't analyse basic datasets (like Titanic probably), take something of your interest. 


## Mock Exam 
## Q1. What is the output?

x = [1, 2, 3]  
y = x  
y.append(4)  
print(x)

A. [1, 2, 3]  
**B. [1, 2, 3, 4]**  
C. Error

## Q2. What does this do?

s = "Computer"  
print(s[1:4] + s[-3:])

A. Prints omputer  
**B. Prints ompter**  
C. Uses string slicing

## Q3. What is the output?

lst = [10, 20, 30, 40]  
print(lst[1:3] + lst[-1:])

**A. [20, 30, 40]**  
B. [20, 30]  
C. [10, 20, 30]

## Q4. What is the output?

a = (1, 2, 3)  
a[0] = 10

A. (10, 2, 3)  
**B. Error**   when () => tuple
C. [10, 2, 3]

## Q5. What is printed?

def f(x, y=5):  
    return x + y  
  
print(f(3))

A. 3  
**B. 8**  
C. Error

## Q6. What is the output?

def calc(a, b):  
    return a - b, a / b  
  
x, y = calc(10, 2)  
print("difference:", x, "quotient:", y)

**A. difference: 8 quotient: 5.0**  
B. difference: 5 quotient: 8  
C. difference: (8, 5.0) quotient: error

## Q7. What is the output?

import numpy as np  
arr = np.array([1, 2, 3])  
print(arr * 2)

A. [1, 2, 3, 1, 2, 3]  
**B. [2, 4, 6]**  
C. Error

## Q8. Which is TRUE about NumPy arrays?

A. They are slower than Python lists  
**B. They support vectorized operations**  
C. They cannot store integers

## Q9. What is the output?

import pandas as pd  
df = pd.DataFrame({"A":[1,2], "B":[3,4]})  
print(df.shape)

**A. (2, 2)**  
B. 4  
C. (4,)

## Q10. What does this return?

df["A"].mean()

A. Median of column A  
**B. Mean of column A**  
C. Sum of column A

## Q11. Which snippet produces:

0    2  
1    4  
Name: A, dtype: int64

A.

df = pd.DataFrame({"A":[1,2]})  
print(df["A"] * 2)

B.

df = pd.DataFrame({"A":[1,2]})  
print(df.A * 2)

C.

df = pd.DataFrame({"A":[1,2]})  
print(df[["A"]] * 2)

correct: ![[Pasted image 20260222234116.png]]
## Q12. What does `axis=1` mean in pandas?

A. Operate column-wise  
**B. Operate row-wise**  
C. Sort values

## Q13. What is the output?

d = {"a":1, "b":2}  
print(list(d.keys()))

**A. ["a", "b"]**  
B. (1, 2)  
C. dict_keys object printed