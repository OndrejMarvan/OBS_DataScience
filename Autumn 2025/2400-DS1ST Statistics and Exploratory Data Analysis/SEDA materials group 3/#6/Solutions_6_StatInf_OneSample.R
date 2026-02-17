###################################################################
#           Statistics and Explaratoroty db Analysis            #
#                        Excercises 5                             #
#                    One-sample tests                             #
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


options(scipen=999) #avoiding e10 notation

#Set English in R
Sys.setenv(LANG = "en")

#Excersize 1
  #1 

  if(!require(dbsets)){install.packages("dbsets")}
  library(dbsets) #dbsets
  library(help = "dbsets")
  db<-Orange
  
  #2

  # Is variable normal, symmetric?
  plotNormalHistogram(db$price)
  describe(db$price)

  # Shapiro-Wilk Normality test
  # H0: Variable is normally distributed
  # H1: Variabel is not normally distributed
  shapiro.test(db$price)

  #3
  # normal

  # One sample t-test
  # H0: Fail to reject that average is equal to mu
  # H1: Average is not equal to mu
  t.test(db$price, mu= 10,alternative=c("less"),  conf.int = 0.95)
  
  #4
  t.test(db$price, mu= 10,alternative=c("less"),  conf.int = 0.95)
  wilcox.test(db$price, mu=10, alternative=c("less"), paired=F,conf.int = 0.95)
  wilcox.exact(db$price, mu=10, alternative=c("less"), paired=F,conf.int = 0.95)
  SignTest(db$price, mu = 10, alternative=c("less"))
