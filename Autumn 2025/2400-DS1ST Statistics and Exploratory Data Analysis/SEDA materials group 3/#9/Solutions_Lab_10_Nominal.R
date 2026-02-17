###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                         Excercise 9                             #
#                     Tests for nominal data                      #
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
library(DescTools) #sign test, gtest, 


if(!require(lattice)){install.packages("lattice")}
library(lattice) #drawings tunning

if(!require(RVAideMemoire)){install.packages("RVAideMemoire")}
library(RVAideMemoire) #mood.medtest

if(!require(FSA)){install.packages("FSA")}
library(FSA) #Summarize

if(!require(ggplot2)){install.packages("ggplot2")}
library(ggplot2) #drawings tuning


# Nominal tests
if(!require(EMT)){install.packages("EMT")}
library(EMT)

if(!require(vcd)){install.packages("vcd")}
library(vcd)

#Set English in R
Sys.setenv(LANG = "en")

options(scipen=999) #avoiding e10 notation


#Excercise 1
  #1


  observed=c(12,7,9,15,3,14)
  observed/sum(observed)
  
  expected=c(1/6,1/6,1/6,1/6,1/6,1/6)
  
  #3
  #Montecarlo Carlo multinomial
  
  #a
  multinomial.test(observed=observed, prob=expected, MonteCarlo = T,ntrial=100000)
  multinomial.test(observed=observed, prob=expected, MonteCarlo = T,ntrial=1000000)
  multinomial.test(observed=observed, prob=expected, MonteCarlo = T,ntrial=5000000)
  multinomial.test(observed=observed, prob=expected, MonteCarlo = T,ntrial=10000000)
  
  #b
  multinomial.test(observed=observed, prob=expected)
  multinomial.test(observed=observed, prob=expected, useChisq = T)
  
  #c
  chisq.test(x = observed, p = expected) # - like exact with Chi-square distance (this is approx)

  GTest(x=observed,  p=expected, correct="none")
  
  #different tests lead to different conlusions, what to do? report that results are on the edge
  
  #2
    ##############################
    
    #Plots
    
    ##############################
    
    MCI = MultinomCI(observed, conf.level=0.95, method="sisonglaz")
    
    MCI
    
    # This function calculates simultaneous confidence intervals for multinomial proportions either according to the methods of
    # Sison and Glaz, Goodman, Wald, Wald with continuity correction or Wilson.
    # 
    # x	
    # A vector of positive integers representing the number of occurrences of each class. 
    # The total number of samples equals the sum of such elements.
    # 
    # conf.level	
    # confidence level, defaults to 0.95.
    # 
    # method	
    # can be one out of "sisonglaz", "cplus1", "goodman", "wald", "waldcc", "wilson".
    
    #preparation of data frame for plot
    Total = sum(observed)
    Count = observed
    Lower = MCI[,'lwr.ci'] * Total
    Upper = MCI[,'upr.ci'] * Total
    
    Data = data.frame(Count, Lower, Upper)
    
    Data
    
    Origin<-factor(c(1:6))
    
    #bar plot with CI
    ggplot(Data,                  
           aes(x = Origin,  y = Count)) +
      
      geom_bar(stat = "identity",  color = "black", fill  = "gray50",  width =  0.7) +
      
      geom_errorbar(aes(ymin  = Lower, ymax  = Upper), width = 0.2, size  = 0.7, position = pd,   color = "black" ) +
      theme_bw() +
      theme(axis.title = element_text(face = "bold")) +
      
      ylab("Count of observations") +
      xlab("Die outcomes")

#Excercise 2

  #1
  Matrix<-as.matrix(HairEyeColor[,,Sex="Male"])
  prop.table(Matrix, margin=1)


  #2
  fisher.test(Matrix, workspace = 2e8)
  
  GTest(Matrix)
  
  chisq.test(Matrix)

  #3
  #Post-hoc analysis
  PT = pairwiseNominalIndependence(Matrix, compare = "row", fisher  = TRUE, gtest   = FALSE, chisq   = FALSE, method  = "fdr", digits  = 3)
  PT
  

#Excersize 3

  #1
  
    Input =("
          PL         Second.Bad   Second.Ok   Second.Great
            First.Bad      1          2           2
            First.Ok       0          3           6
            First.Great   0          0          14
            ")
    
    
  
  Matrix.2 = as.matrix(read.table(textConnection(Input),
                                  header=TRUE, 
                                  row.names=1))
  
  Matrix.2
  


  ##########################################################################
  
  #McNemar-Bowker's, Stuart-Maxwell and Exact test tests for symmetry nXn CT
  
  ##########################################################################
  
  
  mcnemar.test(Matrix.2)

  StuartMaxwellTest(Matrix.2)
  
  nominalSymmetryTest(Matrix.2, method="fdr", digits = 3)
  # positive change is significant





#Excercise 4

  #1  
  HairEyeColor


  ftable(HairEyeColor)                     # Display a flattened table

  #2
  # Cochran–Mantel–Haenszel test
  mantelhaen.test(HairEyeColor)

  # CMH assumes that Odds Ratios in every CT are equal (Homogeneity of the Odds Ratios) and checks wheter they are equal to 1
  # Woolf test or Breslow-Day test for Homogeneity of the Odds Ratios 
  
  woolf_test(HairEyeColor) #vcd
  WoolfTest(HairEyeColor) #DescTools

  #3
  #Post-hoc analysis
  groupwiseCMH(HairEyeColor,
               group   = 3,
               fisher  = F,
               gtest   = T,
               chisq   = FALSE,
               method  = "fdr",
               correct = "none",
               digits  = 3)

  
