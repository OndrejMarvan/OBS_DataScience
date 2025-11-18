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
- 




