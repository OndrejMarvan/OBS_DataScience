###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 9                             #
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

################################################

#GOODNESS-OF-FIT tests

################################################

  #######################
  
  #Exact mulinomial test
  
  #######################
     
  #we want to compare distribution of student's from DS programme 
  # to all others english programmes at the UW
  #                     DS    Other
  # Polish              15    0.5
  # EU (other then PL)  3     0.1
  # Europe non-UE       7     0.2
  # Other countries     10    0.2
  
  observed=c(15,3,7,10)
  observed/sum(observed)
  
  expected=c(0.5,0.1,0.2,0.2)
  
  #Exact multinomial - distance F
  multinomial.test(observed=observed, prob=expected)
  
  #Montecarlo Carlo multinomial
  multinomial.test(observed=observed, prob=expected, MonteCarlo = T,ntrial=10)
  
  #Montecarlo Carlo multinomial - chisquare
  multinomial.test(observed=observed, prob=expected, useChisq = T)
  
    # observed	-
    # vector describing the observation: 
    # contains the observed numbers of items in each category.
    
    # prob	
    # vector describing the model: 
    # contains the hypothetical probabilities corresponding 
    # to each category.
    
    # useChisq	
    # if TRUE, Pearson's chisquare is used as a distance measure 
    # between observed and expected frequencies.
    
    # MonteCarlo	
    # if TRUE, the Monte Carlo approach is used.
    
    # ntrial	
    # number of simulated samples in the Monte Carlo approachtest()

  #######################
  
  #Exact binomial test
  
  #######################
  
  #binomial test for PL vs others
  
  binom.test(x=15, n=35, p=0.5, conf.level=0.95)
  
    # x	
    # number of successes, or a vector of length 2 giving the numbers of successes and failures, respectively.
    
    # n	
    # number of trials; ignored if x has length 2.
    
    # p	
    # hypothesized probability of success.
    
    # alternative	
    # indicates the alternative hypothesis and must be one of "two.sided", "greater" or "less". You can specify just the initial letter.
    
    # conf.level	
    # confidence level for the returned confidence interval.

  ##############################
  
  #Pearson Chi-Square test
  
  ##############################
  
    chisq.test(x = observed, p = expected)
  
    # x	
    # a numeric vector or matrix. x and y can also both be factors.
    # 
    # y	
    # a numeric vector; ignored if x is a matrix. If x is a factor, y should be a factor of the same length.
    # 
    # correct	
    # a logical indicating whether to apply continuity correction 
    # when computing the test statistic for 2 by 2 tables: 
    #   one half is subtracted from all |O - E| differences; 
    # however, the correction will not be bigger than the differences themselves. 
    # 
    # p	
    # a vector of probabilities of the same length of x. 

  ##############################
  
  #G test
  
  ##############################
  


    GTest(x=observed,  p=expected, correct="none")
  
    # x	
    # a numeric vector or matrix. x and y can also both be factors.
    # 
    # y	
    # a numeric vector; ignored if x is a matrix. If x is a factor, y should be a factor of the same length.
    # 
    # correct	- continuity correction
    # one out of "none" (default), "williams", "yates" . 
    # 
    # p	
    # a vector of probabilities of the same length of x.

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
    
    Origin<-c("Polish","EU (other then PL)","Europe non-UE","Other countries")
    
    #bar plot with CI
    ggplot(Data,                  
           aes(x     = Origin,  y     = Count)) +
      geom_bar(stat = "identity",  color = "black", fill  = "gray50",  width =  0.7) +
      
      geom_errorbar(aes(ymin  = Lower, ymax  = Upper), width = 0.2, size  = 0.7,    color = "black" ) +
      theme_bw() +
      theme(axis.title = element_text(face = "bold")) +
      
      ylab("Count of observations") +
      xlab("Students origin")


########################################################

#ASSOCIATION TESTS FOR NOMINAL DATA (INDEPENDENCE TESTS)

########################################################


Input =("
        Group               Pass   Fail
        1st                21      5
        2nd           6     11
        3rd                7      8
        4th             27      5
        ")

Matrix = as.matrix(read.table(textConnection(Input),
                              header=TRUE, 
                              row.names=1))

Matrix

prop.table(Matrix,margin=1)

  ##############################
  
  #Fischer exact test
  
  ##############################

    fisher.test(Matrix)
  
    # x	
    # either a two-dimensional contingency table in matrix form, or a factor object.
    
    # y	
    # a factor object; ignored if x is a matrix.

    #Post-hoc analysis
    PT = pairwiseNominalIndependence(Matrix, compare = "row", fisher  = TRUE, gtest   = FALSE, chisq   = FALSE, method  = "fdr", digits  = 3)
    PT
    # x	
    # A two-way contingency table. At least one dimension should have more than two levels.

    # compare	
    # If "row", treats the rows as the grouping variable. If "column", treats the columns as the grouping variable.
    
    # fisher	
    # If "TRUE", conducts fisher exact test.
    
    # gtest	
    # If "TRUE", conducts G-test.
    
    # chisq	
    # If "TRUE", conducts Chi-square test of association.
    
    # method	
    # The method to adjust multiple p-values. See p.adjust.
    
    # correct	
    # The correction method to pass to GTest. "none" (default), "williams", "yates"

    ##############################
    
    #G test
    
    ##############################
    
    GTest(Matrix)

    ##############################
    
    #Pearson Chi-Square test
    
    ##############################
    
    chisq.test(Matrix)




############################################################

# Tests for paired data nominal data

############################################################ 

  # political party support Right & Left Wing parties
  
  Input =("
          FirstVote       Second.Left   Second.Right
          First.Left     9          5
          First.Right     17         15
          ")
  
  Matrix.1 = as.matrix(read.table(textConnection(Input),
                                  header=TRUE, 
                                  row.names=1))
  
  Matrix.1
  
  
  # political party support Right wing, Centre & Left wing parties
  
  Input =("
          FirstVote         Second.Left   Second.Right   Second.Centre
          First.Left      6          0           1
          First.Right       5          3           7
          First.Centre   11          1          12
          ")
  
  Matrix.2 = as.matrix(read.table(textConnection(Input),
                                  header=TRUE, 
                                  row.names=1))
  
  Matrix.2

  
  #################################################
  
  #McNemar and Exact test tests for symmetry 2X2 CT
  
  #################################################  
  

  # H0: Matrix is symmetric (Left and right wings parties are as popular as they were)
  # H0: Matrix is not symmetric (Left or right wing party become more popular)
  
  mcnemar.test(Matrix.1)
  
  # Left wing party become more popular
  nominalSymmetryTest(Matrix.1, digits = 3)


  ##########################################################################
  
  #McNemar-Bowker's, Stuart-Maxwell and Exact test tests for symmetry nXn CT
  
  ##########################################################################
  

  mcnemar.test(Matrix.2)
  # Matrix is not symmetric, there are significant changes in parties support
  
  StuartMaxwellTest(Matrix.2)
  
  nominalSymmetryTest(Matrix.2, method="fdr", digits = 3)
  # Matrix is not symmetric
  # Matrix is not symmetric, there are significant changes in parties support
  # L more poplar than R & C, C than R



  ############################################################
  
  # Symmetry vs. Association Tests for not paired nominal data
  
  ############################################################ 
  
  Input =("
          Coffee   Yes   No
          Yes      37    17
          No        9    25
          ")
  
  Matrix.3 = as.matrix(read.table(textConnection(Input),
                                  header=TRUE, 
                                  row.names=1))
  
  Matrix.3
  # H0: CT is not symmetric (pij=pji)
  mcnemar.test(Matrix.3)
  #It is equal probable that someone likes Tea and don't like Coffee as that someone likes Coffee and don't like Tea
  
  # H0: There is no association between variables (P(Likes Coffee)=P(Likes Coffe|Likes Tea))
  chisq.test(Matrix.3)
  #If someone likes Tea it is more probable that he/she likes Coffee as well than doesn't like coffee 


  
  
  ############################################################
  
  # Tests for 3-way CT
  
  ############################################################ 
  
  
    ############################################################
    
    # Cochran?Mantel?Haenszel Test for 3-Dimensional Tables 
    # (1 dimension is either time or block )
    
    ############################################################ 
    
    Input = ("
             County       Sex     Result  Count
             Bloom        Female  Pass     9
             Bloom        Female  Fail     5
             Bloom        Male    Pass     7
             Bloom        Male    Fail    17
             Cobblestone  Female  Pass    11
             Cobblestone  Female  Fail    4
             Cobblestone  Male    Pass    9
             Cobblestone  Male    Fail    21
             Dougal       Female  Pass     9
             Dougal       Female  Fail     7
             Dougal       Male    Pass    19
             Dougal       Male    Fail     9
             Heimlich     Female  Pass    15
             Heimlich     Female  Fail     8
             Heimlich     Male    Pass    14
             Heimlich     Male    Fail    17
             ")
    
    Data = read.table(textConnection(Input),header=TRUE)
    
    
    #converting long form data to a table
    
    Table = xtabs(Count ~ Sex + Result + County, 
                  data=Data)
    ###  Note that the grouping variable is last in the xtabs function
    
    ftable(Table)                     # Display a flattened table
    
    # Cochran?Mantel?Haenszel test
    mantelhaen.test(Table)
    
    # CMH assumes that Odds Ratios in every CT are equal (Homogeneity of the Odds Ratios) and checks wheter they are equal to 1
    # Woolf test or Breslow-Day test for Homogeneity of the Odds Ratios 
    
    woolf_test(Table) #vcd
    WoolfTest(Table) #DescTools
    
    
    BreslowDayTest(Table)
    
    #Post-hoc analysis
    groupwiseCMH(Table,
                 group   = 3,
                 fisher  = TRUE,
                 gtest   = FALSE,
                 chisq   = FALSE,
                 method  = "fdr",
                 correct = "none",
                 digits  = 3)
    
    ############################################################
    
    # Cochran Q test for matched data
    
    ############################################################     
    Input = ("
             Models     Student   UseInWork
             Neural     a         Yes
             Neural     b         No
             Neural     c         Yes
             Neural     d         Yes
             Neural     e         No
             Neural     f         Yes
             Neural     g         Yes
             Neural     h         Yes
             Neural     i         No
             Neural     j         Yes
             Neural     k         Yes
             Neural     l         Yes
             Neural     m         Yes
             Neural     n         Yes
             RandomForrest   a         Yes
             RandomForrest   b         No
             RandomForrest   c         No
             RandomForrest   d         No
             RandomForrest   e         No
             RandomForrest   f         No
             RandomForrest   g         No
             RandomForrest   h         No
             RandomForrest   i         Yes
             RandomForrest   j         No
             RandomForrest   k         No
             RandomForrest   l         No
             RandomForrest   m         No
             RandomForrest   n         No
             XGBoost    a         Yes
             XGBoost    b         No
             XGBoost    c         Yes
             XGBoost    d         Yes
             XGBoost    e         Yes
             XGBoost    f         Yes
             XGBoost    g         Yes
             XGBoost    h         Yes
             XGBoost    i         No
             XGBoost    j         Yes
             XGBoost    k         Yes
             XGBoost    l         Yes
             XGBoost    m         Yes
             XGBoost    n         Yes
             Logistic    a         Yes
             Logistic    b         No
             Logistic    c         No
             Logistic    d         Yes
             Logistic    e         Yes
             Logistic    f         No
             Logistic    g         No
             Logistic    h         Yes
             Logistic    i         Yes
             Logistic    j         Yes
             Logistic    k         Yes
             Logistic    l         No
             Logistic    m         Yes
             Logistic    n         No
             ")
    
    Data = read.table(textConnection(Input),header=TRUE)
    
    ### Creates a new numeric variable
    ###  that is UseInWork.n as a 0 or 1
    Data$UseInWork.n = ifelse(Data$UseInWork=="Yes",1,0)   
    
    ### Table Students vs. models
    xtabs(UseInWork.n ~ Student + Models,data=Data)
    
    #counts for MOdels vs. Use in Work
    xtabs( ~ Models + UseInWork.n, data=Data)
    
    
    xtabs( ~UseInWork.n+ Models +  Student, 
                  data=Data)
    
    ### Create bar plot
    Table = xtabs( ~ UseInWork.n + Models, data=Data)
    Table               
    
    
    
    barplot(Table,
            beside = TRUE,
            legend = TRUE,
            ylim = c(0, 12),   ### y-axis: used to prevent legend overlapping bars
            cex.names = 0.8,   ### Text size for bars
            cex.axis = 0.8,    ### Text size for axis
            args.legend = list(x   = "topright",   ### Legend location
                               cex = 0.8,          ### Legend text size
                               bty = "n"))         ### Remove legend box
    
    
    # Cochran?s Q test
    # Number of usage is the same for each model
  
    cochran.qtest(UseInWork.n ~ Models | Student, data = Data)
    
    #CHM extension is exactly the same test as Cocharn's Q (Co)
    
    Table1<-xtabs( ~ Models+UseInWork.n+Student, data=Data)
    mantelhaen.test(Table1)
    

    # Post-hoc analysis for Cochran?s Q test
    
    # The pairwiseMcnemar function will conduct pairwise McNemar, binomial exact, or permutation tests analogous 
    # to uncorrected McNemar tests.  The permutation tests require the coin package.  
    # As usual, method is the p-value adjustment method (see ?p.adjust for options), 
    # and digits indicates the number of digits in the output.  
    # The correct option is used by the chi-square test function.
    
    
    PT = pairwiseMcnemar(UseInWork.n ~ Models | Student,
                         data   = Data,
                         test   = "permutation",
                         method = "fdr",
                         digits = 3)
    
    PT
    
