###################################################################
#           Statistics and Explaratoroty db Analysis              #
#                        Excercises 6                             #
#                    Two-sample tests                             #
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


#Excersize 1
  
  #1 
  
  if(!require(datasets)){install.packages("datasets")}
  library(datasets) #datasets
  
  Group<-c(rep("First",20),rep("Second",20))
  db.all<-data.frame(Group,EuStockMarkets[201:240,1])
  colnames(db.all)<-c("Period","DAX")
  
  #2
  # Is variable normal, symmetric?
  
  describe(db.all[db.all$Period!='First',"DAX"])
  describe(db.all[db.all$Period=='First',"DAX"])


  # Shapiro-Wilk Normality test
  # H0: Variable is normally distributed
  # H1: Variable is not normally distributed
  
  shapiro.test(db.all[db.all$Period=='First',"DAX"])
  shapiro.test(db.all[db.all$Period!='First',"DAX"])
  #normality assumption is fulfilled

  #variance equality check
  # F test for equal variances
  # H0: Variables have same variance
  # H1: Variables have different varinaces
  var.test(db.all$DAX~db.all$Period) 

  # 3
  # t test for two indepenedent samples with unequal variances
  # H0: Variables have same mean
  # H1: Variables have different mean
  t.test(DAX ~ Period,  db.all, conf.int = 0.95, var.equal = FALSE)

  #right choice: test assuming not equal variances

  #4
  t.test(DAX ~ Period,  db.all, conf.int = 0.95, var.equal = FALSE)
  t.test(DAX ~ Period,  db.all, conf.int = 0.95, var.equal = T)
  wilcox.exact(DAX ~ Period, db.all, conf.int = 0.95,exact=T)
  mood.medtest(DAX ~ Period, db.all, conf.int = 0.95,exact=T)






###########################################

# Two paired samples

###########################################



#Excersize 2

  #1 
  
  if(!require(datasets)){install.packages("datasets")}
  library(datasets) #datasets
  
  db.all<-data.frame(EuStockMarkets[1:20,2:3])
  db<-rbind(merge(c("SMI"),db.all[,1]),merge(c("CAC"),db.all[,2]))
  colnames(db)<-c("Index","Price")
  
  
  
  #2 
    #variable preparation for checks
    db.all$diff<-db.all$SMI-db.all$CAC
    db.all

    
    # Shapiro-Wilk Normality test
    # H0: Variable is normally distributed
    # H1: Variable is not normally distributed
    describe(db.all$dif)
    #negative kurtosis means that the excess kurtosis is reported exKur=Kur-3
    shapiro.test(db.all$dif)
  
  
    # Is distribution symmetric?
    
    hist(db.all$dif)
    describe(db.all$dif)
  
    #rather not
    
  #3
    # Sign test for two paired samples
    SIGN.test(x = db.all$SMI,  y = db.all$CAC,  alternative = "two.sided",conf.level = 0.95)
    SignTest(x = db.all$SMI, y = db.all$CAC)


  #4
    SIGN.test(x = db.all$SMI,  y = db.all$CAC,  alternative = "two.sided",conf.level = 0.95)
    t.test(Price ~ Index, db, paired = TRUE, conf.level = 0.95)
    wilcox.exact(Price ~ Index, db,  paired = TRUE, conf.level = 0.95)





