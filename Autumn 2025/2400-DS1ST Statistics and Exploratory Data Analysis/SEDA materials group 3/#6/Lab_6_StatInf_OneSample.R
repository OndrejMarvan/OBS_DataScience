###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 5                             #
#                     One-sample tests                            #
###################################################################
if(!require(Rcpp)){install.packages("Rcpp")}
library(Rcpp) # rcompanion - R / C++ interface
#?Rcpp

if(!require(rcompanion)){install.packages("rcompanion")}
library(rcompanion) # plotNormalHistogram(x), groupWiseMean(x)
# ?`rcompanion-package`

if(!require(psych)){install.packages("psych")}
library(psych) #describe()
# ?psych


if(!require(exactRankTests)){install.packages("exactRankTests")}
library(exactRankTests) #Ansari-Bradley and Wilcoxon exact test with ties

if(!require(DescTools)){install.packages("DescTools")}
library(DescTools) #sign test, gtest



#Set English in R
Sys.setenv(LANG = "en")

options(scipen=999) #avoiding e10 notation

# creating input to the table
Input <-("Tourist  Restaurant_Grade
         1         3 
         2         4
         3         5
         4         4
         5         4
         6         4 
         7         4
         8         3
         9         2
         10         5")

# reading table into data 
  Data <- read.table(textConnection(Input),header=TRUE)
  rm(Input)

# Is variable normal, symmetric?
  plotNormalHistogram(Data$Restaurant_Grade)
  describe(Data$Restaurant_Grade)

# Shapiro-Wilk Normality test
  # H0: Variable is normally distributed
  # H1: Variable is not normally distributed
  shapiro.test(Data$Restaurant_Grade)

# If it is normal

  # One sample t-test
  # H0: Fail to reject that average is equal to mu
  # H1: Average is not equal to mu
  t.test(Data$Restaurant_Grade, mu=3,alternative=c("two.sided"),  conf.int = 0.95)

# symmetric

  # One sample Wilcoxon test
  # H0: The distribution of the data set is symmetric around mu
  # H1: The distribution of the data set is not symmetric around mu
  wilcox.test(Data$Restaurant_Grade, mu=3, alternative=c("two.sided"), conf.int = 0.95)
  # alternative=c("two.sided", "less", "greater")
  ## Warnings.. why? - bulid-in function is not prepared for tied ranks

  # Solution:
  wilcox.exact(Data$Restaurant_Grade, mu=3, alternative=c("two.sided"), conf.int = 0.95)

  # How it is implemented?
  methods(wilcox.exact) # Next step, ask for the method: 'princomp.default'
  getAnywhere('wilcox.test.default') # this will show you the code

# V by hand
  Data$check<-Data$Restaurant_Grade-3
  Data.1<-Data[Data$check!=0,]
  Data.1$check_abs<-abs(Data.1$check)
  Data.1<-Data.1[order(Data.1$check_abs),]
  Data.1$Rank<-rank(Data.1$check_abs)

  V<-sum(ifelse(Data.1$check>0,sign(Data.1$check)*Data.1$Rank,0))

#not normal, not symmetric

  # One sample sign test
  # H0: The median of the data set is equal to mu
  # H1: The median of the data set is not equal to the ME
  SignTest(Data$Restaurant_Grade, mu = 3)
  
  
#we may assume that normality assumtion is held - comapre tests results
  t.test(Data$Restaurant_Grade, mu= 3,alternative=c("two.sided"),  conf.int = 0.95)
  wilcox.test(Data$Restaurant_Grade, mu=3, alternative=c("two.sided"), paired=F,conf.int = 0.95)
  wilcox.exact(Data$Restaurant_Grade, mu=3, alternative=c("two.sided"), paired=F,conf.int = 0.95)
  SignTest(Data$Restaurant_Grade, mu = 3)
  