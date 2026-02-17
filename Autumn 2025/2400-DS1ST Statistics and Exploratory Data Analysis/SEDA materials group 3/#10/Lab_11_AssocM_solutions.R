###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Excercise 11                            #
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



#Excersise 1

#1
  # ordinal 
  if(!require(ordinal)){install.packages("ordinal")}
  library(ordinal)
  
  wine

#2
  ################
  # Ordinal vs Ordinal
  
  # Sommers D
  # a measure of association for ordinal factors in a two-way table
  SomersDelta(table(wine$temp,wine$rating), direction="column", conf.level=0.95)
  
  # direction="column" or "row" - Sommers' D is not symmetric
  # "row" calculates Somers' D (R | C) ("column dependent").
  
  # Kendall's tau-b - correlation coefficient
  # Calculate Kendall's tau-b statistic, a measure of association for ordinal factors in a two-way table.
  KendallTauB(table(wine$temp,wine$rating), direction="column", conf.level=0.95)
  
  # Goodman Kruskal's Gamma
  # Calculate Goodman Kruskal's Gamma statistic, a measure of association for ordinal factors in a two-way table.
  GoodmanKruskalGamma(table(wine$temp,wine$rating), direction="column", conf.level=0.95)

#3
  #linear-by-linear test
  prop.table(table(wine$temp,wine$rating),  margin = NULL)   ### proportion in the table
  
  spineplot(table(wine$temp,wine$rating))
  
  
  LxL = lbl_test(table(wine$temp,wine$rating))
  LxL
  
  
  # Compare to chi-square test without ordered categories
  
  statistic(LxL)^2
  chisq_test(table(wine$temp,wine$rating))



# Excersise 2
  #1
  
  setwd("D:/Pulpit/WNE/Przedmioty/Budowa karty scoringowej")
  
  # Zaczytywanie danych z CSV
  UCI<-read.csv2(file="UCI_Credit_Card.csv")
  UCI$EDUCATION<-as.numeric(UCI$EDUCATION)
  UCI$LIMIT_BAL<-as.numeric(gsub(" ", "", UCI$LIMIT_BAL, fixed = TRUE))
  
  #2
  #Multiple correlation plot
  pairs(data=UCI,  ~ default.payment.next.month+LIMIT_BAL + AGE + EDUCATION + BILL_AMT1 + PAY_AMT1)

  # SomersDelta(table(UCI$default.payment.next.month,-UCI$LIMIT_BAL), direction="column", conf.level=0.95)


  cor(UCI[,c("default.payment.next.month","LIMIT_BAL","AGE","EDUCATION","BILL_AMT1","PAY_AMT1")],method="kendall")

  
  corr.test(UCI[,c("default.payment.next.month","LIMIT_BAL","AGE","EDUCATION","BILL_AMT1","PAY_AMT1")], use="pairwise", method = "kendall", adjust = "holm")


  #plot for correlation tests
  chart.Correlation(UCI[,c("default.payment.next.month","LIMIT_BAL","AGE","EDUCATION","BILL_AMT1","PAY_AMT1")], method="kendall", adjust = "holm", histogram=TRUE,  pch=16)

