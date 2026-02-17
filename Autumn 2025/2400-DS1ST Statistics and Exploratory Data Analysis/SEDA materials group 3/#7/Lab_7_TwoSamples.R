###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 6                             #
#                     Two-sample tests                            #
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


if(!require(normtest)){install.packages("normtest")}
library(normtest) #jb.norm.test & others

if(!require(lattice)){install.packages("lattice")}
library(lattice) #drawings tunning

if(!require(RVAideMemoire)){install.packages("RVAideMemoire")}
library(RVAideMemoire) #mood.medtest

#Set English in R
Sys.setenv(LANG = "en")

options(scipen=999) #avoiding e10 notation




###########################################

# Two independent (not paired) samples

###########################################

Input <- ("
          Gender       Student  Wrkday
          'Male'  a        1200
          'Male'  b        1400
          'Male'  c        1350
          'Male'  d         950
          'Male'  e        1400
          'Male'  f        1150
          'Male'  g        1300
          'Male'  h        1325
          'Male'  i        1425
          'Male'  j        1500
          'Male'  k        1250
          'Male'  l        1150
          'Male'  m         950
          'Male'  n        1150
          'Male'  o        1600
          'Male'  p        1300
          'Male'  q        1050
          'Male'  r        1300
          'Male'  s        1700
          'Male'  t        1300
          'Female'  u        1100
          'Female'  v        1200
          'Female'  w        1250
          'Female'  x        1050
          'Female'  y        1200
          'Female'  z        1250
          'Female'  aa       1350
          'Female'  ab       1350
          'Female'  ac       1325
          'Female'  ad       1525
          'Female'  ae       1225
          'Female'  af       1125
          'Female'  ag       1000
          'Female'  ah       1125
          'Female'  ai       1400
          'Female'  aj       1200
          'Female'  ak       1150
          'Female'  al       1400
          'Female'  am       1500
          'Female'  an       1200
          ")

Data <- read.table(textConnection(Input),header=TRUE)
Data
  # Is variable normal, symmetric?

  # Shall we check it jointly?
  describe(Data$Wrkday)
  
  # Or separately?
  describe(Data[Data$Gender!='Female',"Wrkday"])
  describe(Data[Data$Gender=='Female',"Wrkday"])
  #Separately
  
  # Shapiro-Wilk Normality test
  # H0: Variable is normally distributed
  # H1: Variable is not normally distributed

  shapiro.test(Data$Wrkday)
  shapiro.test(Data[Data$Gender!='Female',"Wrkday"])
  shapiro.test(Data[Data$Gender=='Female',"Wrkday"])

  # Jarque - Bera Normality test
  # H0: Variable is normally distributed
  # H1: Variable is not normally distributed
  
  jb.norm.test(Data$Wrkday)
  jb.norm.test(Data[Data$Gender!='Female',"Wrkday"])
  jb.norm.test(Data[Data$Gender=='Female',"Wrkday"])

  #Other normality tests
    #ajb.norm.test(x, nrepl=2000)
    #frosini.norm.test(x, nrepl=2000)
    # geary.norm.test(x, nrepl=2000)
    # hegazy1.norm.test(x, nrepl=2000)
    # hegazy2.norm.test(x, nrepl=2000)
    # kurtosis.norm.test(x, nrepl=2000)
    # skewness.norm.test(x, nrepl=2000)
    # spiegelhalter.norm.test(x, nrepl=2000)
    # wb.norm.test(x, nrepl=2000)


  #historgram
  histogram(~ Wrkday | Gender, data   = Data, type   = "density", layout = c(1,2),           ###  columns and rows of individual plots
            panel=function(x, ...) {  
              panel.histogram(x, ...) 
              panel.mathdensity(dmath = dnorm, col   = "blue", lwd   = 2, args  = list(mean=mean(x), sd=sd(x)))})

  #normality assumption is fulfilled
  
  #variance equality check
  # F test for equal variances
  # H0: Variables have same variance
  # H1: Variables have different varinaces
  var.test(Data$Wrkday~Data$Gender) 

  # Which test should be chosen?
  
    # t test for two indepenedent samples with unequal variances
    # H0: Variables have same mean
    # H1: Variables have different mean
    t.test(Wrkday ~ Gender, data = Data, conf.int = 0.95, var.equal = FALSE)
    
    # t test for two indepenedent samples with equal variances
    # H0: Variables have same variance
    # H1: Variables have different mean
    t.test(Wrkday ~ Gender, data = Data, conf.int = 0.95, var.equal = TRUE)
    
    #right choice: test assuming equal variances

    
    #what if normality assumption is not fulfilled?
    #test for equal scale parameter (same spread)
 
    #Ansari test 
    # H0: Variables have same scale parameter
    # H1: Variables have different scale parameter

    # It doesnt work, why?
    ansari.test(Wrkday ~ Gender, data = Data)

    # This works (tied values)
    exactRankTests::ansari.exact(Wrkday ~ Gender, data = Data, exact=F)
    exactRankTests::ansari.exact(Wrkday ~ Gender, data = Data, exact=T)
    #assumption about equal scale parameter fulfiled - we may use Mann-Whitney/Wilcoxon test

    #Mann-Whitney/Wlicoxon Runk Sum test (may be different shape parameters - different interpretation)
    # H0: The medians of values for each group are equal (distributions are similar in shape and spread)/The distribution 
    # of values for each group are equal (otherwise).
    # H1 (2-sided): The medians of values for each group are not equal/there is systematic difference in the distribution 
    # of values for the groups
    wilcox.test(Wrkday ~ Gender, data = Data, conf.int = 0.95,exact=T)
    wilcox.exact(Wrkday ~ Gender, data = Data, conf.int = 0.95,exact=T)

    #What to do if the assumption is not fulfilled?
    
    # Moods Median test (approx. same shape parameter/resistent for outliers)
    # H0: The medians of values for each group are equal
    # H1 (2-sided): The medians of values for each group are not equal
    
    mood.test(Wrkday ~ Gender, data = Data, conf.int = 0.95,exact=T)

    
    
    
    
    
    ###########################################
    
    # Two paired samples
    
    ###########################################

Input = ("
         Time    Country  Unemployment
         Before  Bulgaria  15
         Before  Croatia  12
         Before  Romania  21
         Before  Slovakia  10
         Before  Poland  9
         Before  Czech  8
         Before  Malta         5
         Before  Cyprus         14
         Before  Lithuania         7
         Before  Latvia         9
         After   Bulgaria         10
         After   Croatia        12
         After   Romania         14
         After   Slovakia         7
         After   Poland         6
         After   Czech         6
         After   Malta        7
         After   Cyprus         7
         After   Lithuania         9
         After   Latvia         8
         ")

Data <- read.table(textConnection(Input),header=TRUE)


  # On which variable should we investigate assumptions?
  
  # Descriptive statistics for separate variables?
  describe(Data[Data$Time=='Before',"Unemployment"])
  describe(Data[Data$Time=='After',"Unemployment"])

  #We should investigate difference of variables for pairs!!
  #variable preparation for checks
  norm_check<-merge(x=Data[Data$Time=='Before',],y=Data[Data$Time=='After',],by="Country",suffixes=c("_bef","_aft"))
  norm_check$diff<-norm_check$Unemployment_aft-norm_check$Unemployment_bef
  norm_check

  # Shapiro-Wilk Normality test
  # H0: Variable is normally distributed
  # H1: Variable is not normally distributed
  describe(norm_check$diff)
  #negative kurtosis means that the excess kurtosis is reported exKur=Kur-3
  shapiro.test(norm_check$diff)

  # Paired t-test
  # H0: The difference between paired observations is equal to zero.
  # H1 (2 sided): The difference between paired observations is not equal to zero.
  
  t.test(Unemployment ~ Time, data=Data, paired = TRUE, conf.level = 0.95)
  
  # Maybe t test for independent samples is not a problem?
  t.test(Unemployment ~ Time, data=Data, paired = FALSE, conf.level = 0.95)


  #Wlcoxon Rank Sum test for paired data
  
  # Is distribution symmetric?
  Time.1 = Data$Unemployment[Data$Time=="Before"]
  Time.2 = Data$Unemployment[Data$Time=="After"]
  
  Difference = Time.2 - Time.1
  Diff.f = factor(Difference)
  
  XT = xtabs(~ Diff.f)
  
  barplot(XT, col="dark gray", xlab="Difference in Unemployment", ylab="Frequency")
  hist(Difference)
  describe(Difference)
  describe(norm_check$diff)
  
  # H0: The distribution of the differences in paired values is symmetric around zero.
  # H1 (2-sided): The distribution of the differences in paired values is not symmetric around zero
  
  wilcox.exact(Unemployment ~ Time, data = Data,  paired = TRUE, conf.level = 0.95)
  # which test is more relevant?
  
  # Rank Sum test for paired data is a one-sample Rank Sum test for difference in values equal to 0 
  wilcox.exact(Difference, mu=0, data = Data, conf.level = 0.95)
  
  
  
  #what if it is not symmetric?
  # Sign test for two paired samples
  SIGN.test(x = Time.1,  y = Time.2,  alternative = "two.sided",conf.level = 0.95)
  SignTest(x = Time.1, y = Time.2)
  
  