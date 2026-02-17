
###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 11                            #
#                 Association measures and tests                  #
###################################################################

# Association measures
if(!require(vcd)){install.packages("vcd")}
library(vcd) #assocstats

if(!require(polycor)){install.packages("polycor")}
library(polycor) #polychronic and polyserial correlation

if(!require(PerformanceAnalytics)){install.packages("PerformanceAnalytics")}
library(PerformanceAnalytics) #chart.Correlation

# Permutation test
if(!require(coin)){install.packages("coin")}
library(coin)

library(rcompanion)
library(DescTools)

############################################################

# Measures and tests of association for nominal variables

############################################################    

#################
#Phi, Cramer's V and Goodman & Kruskal Lambda 

Input =("
        Group               Pass   Fail
        1st                 21      5
        2nd                 6      11
        3rd                 7      8
        4th                 27       5
        ")

Matrix = as.matrix(read.table(textConnection(Input),
                              header=TRUE, 
                              row.names=1))

rcompanion::cramerV(Matrix, digits=4) 
# Cramer's V 


#G test (Likelihood Ratio)
#Chisq test (Pearson)
#Phi - NA? (CT not 2x2) <- just for 2x2 matrix
# Contingency Coeff (Extenstion of phi) sqrt(Chi2/(chi2+n)) = (17.32/(17.32+sum(Matrix)))^0.5
# Cramer's V   
sum(Matrix)
Matrix
Lambda(Matrix, direction="column")
Lambda(Matrix, direction="row")
#Goodman - Kruskal Lambda
(29-23)/29
((7+8+6+11+21+5)-(7+6+21+5+8+5))/(7+8+6+11+21+5)

#2x2 table
cramerV(Matrix[1:2,], digits=4)
#Phi

assocstats(Matrix[1:2,]) ## rejecting h0 that there is no independency (theres association) between class and group
assocstats(Matrix[,]) ## <- p value is smaller, we have bigger proove
#G test
#Chisq test
#Phi
# Contingency Coeff sqrt(Chi2/(chi2+n)) 
# Cramer's V 


######################################################################

#ASSOCIATION MEASURES AND TESTS FOR ORDINAL VARIABLES

###################################################################### 


####################################################################
# Ordinal vs nominal
####################################################################

# Freeman's theta - measure of association
# Freeman's coefficent of differentiation (theta) is used as a measure of association for 
# a two-way table with one ordinal and one nominal variable. See Freeman (1965).

### Example from Freeman (1965), Table 10.6

Input =(
"Adopt      Always  Sometimes  Never
Size
Mom-and-pop      2          3      4
Small            4          4      4
Medium           3          2      0
Large            2          0      0
Hobbiest         0          1      5
")

Tabla = as.table(read.ftable(textConnection(Input)))

Tabla


freemanTheta(Tabla) # there is association between two variables


# x	
# Either a two-way table or a two-way matrix. Can also be a vector of observations of an ordinal variable.
# 
# g	
# If x is a vector, g is the vector of observations for the grouping, nominal variable.
# 
# group	
# If x is a table or matrix, group indicates whether the "row" or the "column" variable is the nominal, grouping variable.
# 
# verbose	
# If TRUE, prints statistics for each comparison.
# 
# progress	
# If TRUE, prints a message as each comparison is conducted.


#Cochran-Armitage test for trend
#H0: No trend in proportions
#H1: There is a trend in proportions (increasing for second level, any trend, deacresing for a second level of variable)
dose <- matrix(c(0,2,4,6,10,8,6,4), byrow=TRUE, nrow=2, dimnames=list(resp=1:0, dose=0:3))
Desc(dose)


CochranArmitageTest(dose, "one.sided") # h1 trend is increasing
CochranArmitageTest(dose, "two.sided") # there is a trend


#Extended Cochran-Armitage test

prop.table(Tabla, margin = 1)   ### proportion in each row

par(mfrow=c(1,1))
spineplot(Tabla)


chisq_test(Tabla, scores = list("Adopt" = c(-1, 0, 1))) 
# based on permution test checking if there is a trend, how much we adopt, here visible positive trend
# where the trend is, we need to to pairwise ordinal independence test


# Post-hoc analysis - between nominal variable categories
pairwiseOrdinalIndependence(Tabla, compare="row", method="fdr")



################
# Ordinal vs Ordinal
Input =(
"Adopt      Always  Sometimes  Never
Size
Hobbiest         0          1      5
Mom-and-pop      2          3      4
Small            4          4      4
Medium           3          2      0
Large            2          0      0
")

Tabla = as.table(read.ftable(textConnection(Input)))


# Sommers D
# a measure of association for ordinal factors in a two-way table
SomersDelta(Tabla, direction="column", conf.level=0.95) # is not symetric, so we need to check 
# negative association means that we would expect negative relation (going on rows down more propbable is seeng values closer to the left)
# direction="column" or "row" - Sommers' D is not symmetric
# "row" calculates Somers' D (R | C) ("column dependent").
SomersDelta(Tabla, direction="row", conf.level=0.95) # is not symetric, so we need to check 

# Kendall's tau-b - correlation coefficient
# Calculate Kendall's tau-b statistic, a measure of association for ordinal factors in a two-way table.
KendallTauB(Tabla, direction="column", conf.level=0.95)

# Goodman Kruskal's Gamma
# Calculate Goodman Kruskal's Gamma statistic, a measure of association for ordinal factors in a two-way table.
GoodmanKruskalGamma(Tabla, direction="column", conf.level=0.95) # gamma is a bit higher, but still indicate on off diagonal realtion


#linear-by-linear test
prop.table(Tabla,  margin = NULL)   ### proportion in the table

spineplot(Tabla)

LxL = lbl_test(Tabla)
LxL # we just dtate that relation is stat. significant


# Compare to chi-square test without ordered categories

statistic(LxL)^2
chisq_test(Tabla)




# ################
# 
# # EXTRA
# 
# ###############
# 
# # Ordinal vs Ordinal(continous latent)
# 
# library(mnormt)
# data(bock)
# 
# tetrachoric(lsat6)
# polychoric(lsat6)
# 
# # Ordinal(continous latent) vs Continous
# library(mvtnorm)
# set.seed(12345)
# data <- rmvnorm(1000, c(0, 0), matrix(c(1, .5, .5, 1), 2, 2))
# x <- data[,1]
# y <- data[,2]
# cor(x, y)  # sample correlation
# 
# # 2-step estimate
# y <- cut(y, c(-Inf, -1, .5, 1.5, Inf))
# polyserial(x, y)  
# 
# # ML estimate
# polyserial(x, y, ML=TRUE, std.err=TRUE) 









######################################################################

#ASSOCIATION MEASURES FOR CONTINOUS/ORDINAL VARIABLES (CORRELATIONS)

######################################################################
Input = ("
         Instructor       Grade   Weight  Calories Sodium  Score
         'Brendon Small'     6      43     2069    1287      77
         'Brendon Small'     6      41     1990    1164      76
         'Brendon Small'     6      40     1975    1177      76
         'Brendon Small'     6      44     2116    1262      84
         'Brendon Small'     6      45     2161    1271      86
         'Brendon Small'     6      44     2091    1222      87
         'Brendon Small'     6      48     2236    1377      90
         'Brendon Small'     6      47     2198    1288      78
         'Brendon Small'     6      46     2190    1284      89
         'Jason Penopolis'   7      45     2134    1262      76
         'Jason Penopolis'   7      45     2128    1281      80
         'Jason Penopolis'   7      46     2190    1305      84
         'Jason Penopolis'   7      43     2070    1199      68
         'Jason Penopolis'   7      48     2266    1368      85
         'Jason Penopolis'   7      47     2216    1340      76
         'Jason Penopolis'   7      47     2203    1273      69
         'Jason Penopolis'   7      43     2040    1277      86
         'Jason Penopolis'   7      48     2248    1329      81
         'Melissa Robins'    8      48     2265    1361      67
         'Melissa Robins'    8      46     2184    1268      68
         'Melissa Robins'    8      53     2441    1380      66
         'Melissa Robins'    8      48     2234    1386      65
         'Melissa Robins'    8      52     2403    1408      70
         'Melissa Robins'    8      53     2438    1380      83
         'Melissa Robins'    8      52     2360    1378      74
         'Melissa Robins'    8      51     2344    1413      65
         'Melissa Robins'    8      51     2351    1400      68
         'Paula Small'       9      52     2390    1412      78
         'Paula Small'       9      54     2470    1422      62
         'Paula Small'       9      49     2280    1382      61
         'Paula Small'       9      50     2308    1410      72
         'Paula Small'       9      55     2505    1410      80
         'Paula Small'       9      52     2409    1382      60
         'Paula Small'       9      53     2431    1422      70
         'Paula Small'       9      56     2523    1388      79
         'Paula Small'       9      50     2315    1404      71
         'Coach McGuirk'    10      52     2406    1420      68
         'Coach McGuirk'    10      58     2699    1405      65
         'Coach McGuirk'    10      57     2571    1400      64
         'Coach McGuirk'    10      52     2394    1420      69
         'Coach McGuirk'    10      55     2518    1379      70
         'Coach McGuirk'    10      52     2379    1393      61
         'Coach McGuirk'    10      59     2636    1417      70
         'Coach McGuirk'    10      54     2465    1414      59
         'Coach McGuirk'    10      54     2479    1383      61
         ")





Data = read.table(textConnection(Input),header=TRUE)

#Multiple correlation plot
pairs(data=Data,  ~ Grade + Weight + Calories + Sodium + Score)

cor(Data[,2:6],method="pearson")
cor(Data[,2:6],method="spearman")
cor(Data[,2:6],method="kendall")

# x	
# a numeric vector, matrix or data frame.
# 
# y	
# NULL (default) or a vector, matrix or data frame with compatible dimensions to x. 
# The default is equivalent to y = x (but more efficient).
# 
# na.rm	
# logical. Should missing values be removed?
# 
# use	
# an optional character string giving a method for computing covariances in the presence of missing values. 
# This must be (an abbreviation of) one of the strings "everything", "all.obs", "complete.obs", "na.or.complete", 
# or "pairwise.complete.obs".
# 
# method	
# a character string indicating which correlation coefficient (or covariance) is to be computed. 
# One of "pearson" (default), "kendall", or "spearman": can be abbreviated.
# 



######################################################################

#ASSOCIATION TESTS FOR CONTINOUS/ORDINAL VARIABLES (CORRELATION TESTS)

######################################################################

library(psych)

#only numeric variables
Data.num = Data[c("Grade", "Weight", "Calories", "Sodium", "Score")]

corr.test(Data.num, use="pairwise", method = "pearson", adjust = "bonferroni")

# If method is "pearson", the test statistic is based on Pearson's product moment correlation coefficient cor(x, y) 
# and follows a t distribution with length(x)-2 degrees of freedom if the samples follow independent normal distributions. 
# If there are at least 4 complete pairs of observation, an asymptotic confidence interval is given based on Fisher's Z transform.
# 
# If method is "kendall" or "spearman", Kendall's tau or Spearman's rho statistic is used to estimate a rank-based measure of association.
# These tests may be used if the data do not necessarily come from a bivariate normal distribution.
# 
# For Kendall's test, by default (if exact is NULL), an exact p-value is computed if there are less than 50 paired samples containing 
# finite values and there are no ties. Otherwise, the test statistic is the estimate scaled to zero mean and unit variance, 
# and is approximately normally distributed.
# 
# For Spearman's test, p-values are computed using algorithm AS 89 for n < 1290 and exact = TRUE, otherwise via 
# the asymptotic t approximation. Note that these are ?exact? for n < 10, and use an Edgeworth series approximation 
# for larger sample sizes (the cutoff has been changed from the original paper)

# checking wheter residuals are normal (Pearson correlation assumption)
model = lm(Sodium ~ Calories, data = Data)
x = residuals(model)
plotNormalHistogram(x)
JarqueBeraTest(x)

library(psych)
corr.test(Data.num, use="pairwise", method = "kendall", adjust = "bonferroni")

#plot for correlation tests
chart.Correlation(Data.num, method="kendall", histogram=TRUE,  pch=16)

