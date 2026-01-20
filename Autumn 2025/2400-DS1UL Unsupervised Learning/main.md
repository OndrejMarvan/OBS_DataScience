## passoword
USL_@)@$

## 1 
Distance-base approach
Appropriate number of clusters 
- Silhoutte analysis, width, etc. 
K-means
Clustering: partitioning around medoids (PAM)
Hierarchical Clustering
- Linkage methods

## 2
###Continuation with presentation #1 
- Too many K -> over fitting
- When K is too high, the more difficult to interpret the results
	- Rule of thumb (**never use!!!**), elbow method
	- follow distance between points, stop when distance stops to lower (how?) 
	- ==AIC== from econometrics 
	- "equidistant" = as close/far to two clusters (example of bats as mammals)
	- ![[Pasted image 20251014174045.png]] which on is better? Answer **Red one**

- 0 k is non-sense, 1 k is not giving further insight
- basic datasets between 2-14 k, more for bigger datasets
- ![[Pasted image 20251014174410.png]]
		- 5 is the best option, 3 is ok as well, so can be used as well. In practise, we would test both on and choose which one is stable. 

==At least 1 project in Python, 1 in R**==

Professor recommends using Stata
To get the same results in R with prof., we would have to set up seeds. 

Projects: 

P1 - Energy mix clustering 
data source for energy mix
https://ourworldindata.org/energy-mix
https://ourworldindata.org/grapher/global-energy-substitution.csv?v=1&csvType=full&useColumnShortNames=true



GDP per capita: 
PPP: 
Geographical features 
Coal and Gas price (dark spread/spark spread)

## 4
silhoutte width, index, etc. - it's all the same
For silh we wwant to see values +1, negative may mean a mistake but doenst mean to 

Skip the elbow methos but dont skip Silhoutte and GAP method 

We should distinguish between Jaccard distant and Jaccard similarity

ASW = Avg. Silhoutte Width

## 5 (04.11.2025)
Clustering for forecasting - practical at work and well recommended 
ARIMA considered as easier one 

Nocasting as a super cool and hyped...
Seed will make our project fully replicable

Class dates
- 11.11 moved to 14.11
- 18.11. classes
- 25.11. cancelled 

Homework till Wed EOD (12.11.) - more available on Moodle 
submit via email - ideally notebook 

## 06 (revise on 18.11.)
- why dim reduction - because of analysis of the dataset based on literature review or recommendation
- Done after cleaning the data 
- thanks to that, we speed up the analysis, find new trends and make better visualizations
- Sometimes done automatically 
- Make two dimensional data (x and y) only x, so data will be in linear order (like a line). 
- t -SNE for those ambitious with their projects, would be recognised as something extra 
	- useful for text dimensioning for next year 
- Packages for MDS in R located on Moodle for analysis -> to make our life easier
- 

## 09 
16.12.2025

Example projects for our projects added to Moodle (dimensional reduction)

## Topic discussion_Presentation (3.2.3)
> [!PDF|yellow] [[Class 3.2.3 recommendations for e-commerce.pdf#page=2&selection=250,0,314,7&color=yellow|Class 3.2.3 recommendations for e-commerce, p.1143]]
> > These studies argue that the recommendation decision is based not on the probability of a purchase, but rather on the sensitivity of probability of a purchase, as affected by the recommendation action. 
> 
> 

> [!PDF|yellow] [[Class 3.2.3 recommendations for e-commerce.pdf#page=2&selection=826,0,890,6&color=yellow|Class 3.2.3 recommendations for e-commerce, p.1143]]
> > This study considers that integrate both rough set theory and association rule as a new approach in terms of processing AHP ordinal scale data for developing a recommendation system on electronic commerce.
> 
> 

This document provides a comprehensive overview of association rules within the context of unsupervised learning, as presented by the **University of Warsaw’s Faculty of Economic Sciences**1. It covers the fundamental concepts, measurement metrics, and primary algorithms used for discovering patterns in large databases2222.

+3

---

## Introduction to Association Rules

Association rules are used for unsupervised knowledge discovery, primarily in databases featuring binary attributes3333. This technique represents patterns in data without the need for labeled datasets or specified target variables4444.

+3

- **Core Applications**:
    
    - **Market Basket Analysis**: Analyzing sets of products in transactions5555.
        
        +1
        
    - **Biology**: Identifying interesting patterns in DNA and protein sequences in cancer data6.
        
    - **Fraud Detection**: Recognizing purchase patterns combined with fraudulent credit card use7.
        
    - **Customer Behavior**: Identifying patterns that precede customers dropping their cell phone service8888.
        
        +1
        
- **Rule Types**:
    
    - **Actionable Rules**: Provide high-quality, useful information9.
        
    - **Trivial Rules**: Present information already well-known to business experts10.
        
    - **Inexplicable Rules**: Do not suggest any clear action11.
        

---

## Measuring Rule Interest

To evaluate the strength and "interest" of a discovered rule (e.g., $\{X\} \rightarrow \{Y\}$), three primary metrics are used12121212:

+1

### 1. Support

Support indicates how frequently an itemset or rule occurs in the database13. An itemset is considered "frequent" if it satisfies a minimum support threshold ($min\_sup$)14.

+1

$$support(X) = \frac{count(X)}{N}$$

Where $N$ is the total number of transactions15.

### 2. Confidence

Confidence measures the proportion of transactions containing $X$ that also contain $Y$16. It represents the certainty or trustworthiness of a discovered pattern17.

+1

$$confidence(X \rightarrow Y) = \frac{support(X, Y)}{support(X)}$$

18

### 3. Lift

Lift controls for the frequency of the consequent ($Y$) to determine if the association between $X$ and $Y$ is positive, negative, or independent19.

$$lift(X \rightarrow Y) = \frac{confidence(X \rightarrow Y)}{support(Y)}$$

20

- **Lift > 1**: Positive association21.
    
- **Lift $\approx$ 1**: Independent itemsets22.
    
- **Lift < 1**: Negative association23.
    

---

## Primary Algorithms

### Apriori Algorithm

The Apriori algorithm uses prior knowledge of frequent items to reduce the search space24. It relies on the **Apriori Property**: all nonempty subsets of a frequent itemset must also be frequent25.

+1

- **Process**: It iteratively identifies frequent itemsets of increasing size (1-itemsets, then 2-itemsets, etc.) and prunes candidates that contain infrequent subsets26262626.
    
    +1
    
- **Strengths**: Easy to understand; ideal for very large transactional datasets27.
    
- **Weaknesses**: High computational cost due to repeated database scans and candidate generation; not helpful for small datasets28282828.
    
    +1
    

### Frequent Pattern Growth (FP-Growth)

FP-growth discovers patterns without candidate generation by using a specialized data structure called an **FP-tree**29.

- **Process**: It summarizes the database into a tree structure and explores patterns incrementally by adding prefixes30.
    
- **Strengths**: Faster than Apriori; uses a compact data structure; does not require candidate selection31.
    
- **Weaknesses**: The FP-tree can be expensive to build and may exceed available memory32.
    

### ECLAT (Equivalence Class Clustering)

ECLAT works in a **vertical manner** (Depth-First Search), whereas Apriori works horizontally (Breadth-First Search)33.

- **Process**: It stores a list of transaction IDs (tid-lists) for every item34. Support is determined by the intersection of these tid-lists35353535.
    
    +2
    
- **Strengths**: Very fast computing; avoids repeated scanning of data to compute support36.
    
- **Weaknesses**: Intermediate tid-lists can become too large for memory37.
    

---

### Comparison Summary

|**Feature**|**Apriori**|**FP-Growth**|**ECLAT**|
|---|---|---|---|
|**Search Strategy**|Horizontal (Breadth-First) 38|Recursive Tree Traversal 39|Vertical (Depth-First) 40|
|**Candidate Generation**|Yes 41|No 42|No 43|
|**Data Layout**|Horizontal 44|Tree-based 45|Vertical 46|
|**Main Limitation**|Slow/Multiple scans 47474747<br><br>+1|Memory for tree 48|Memory for tid-lists 49|

**Would you like me to create a step-by-step numerical example of how the Apriori algorithm prunes candidates using a sample dataset?**

Useful link to dataset - Harvard Dataverse 
https://dataverse.harvard.edu/

Use in report: 
![[Pasted image 20260113181202.png]]

Extra tasks:
1: 
Do not delete any countries. 
Possible to paste and it will display the density of data. 

2:

