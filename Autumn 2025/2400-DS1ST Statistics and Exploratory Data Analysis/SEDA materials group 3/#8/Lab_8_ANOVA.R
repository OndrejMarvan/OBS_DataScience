###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Laboratory 7                             #
#                     ANOVA & related                             #
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

if(!require(FSA)){install.packages("FSA")}
library(FSA) #Summarize

if(!require(ggplot2)){install.packages("ggplot2")}
library(ggplot2) #drawings tuning


#ANOVA

if(!require(car)){install.packages("car")}
library(car) #Anova

if(!require(lsmeans)){install.packages("lsmeans")}
library(lsmeans) #lsmeans, cld

#KRUSKAL - WALLIS

if(!require(dunn.test)){install.packages("dunn.test")}
library(dunn.test) #dunn.test

if(!require(conover.test)){install.packages("conover.test")}
library(conover.test) #conover.test




 
### Mixed models

if(!require(lme4)){install.packages("lme4")}
library(lme4)

if(!require(lmerTest)){install.packages("lmerTest")}
library(lmerTest) #anova after lmer

if(!require(multcompView)){install.packages("multcompView")}
library(multcompView) #multcompLetters

if(!require(multcomp)){install.packages("multcomp")}
library(multcomp) #multcompLetters

if(!require(phia)){install.packages("phia")}
library(phia) #plots of interactions
?phia


if(!require(nlme)){install.packages("nlme")}
library(nlme)

if(!require(AICcmodavg)){install.packages("AICcmodavg")}
library(AICcmodavg)


#Set English in R
Sys.setenv(LANG = "en")

options(scipen=999) #avoiding e10 notation


####################################


# ONE-WAY ANOVA


####################################

Input <- ("
Year       Student  Wrkday
          '1st year'  a        1200
          '1st year'  b        1400
          '1st year'  c        1350
          '1st year'  d         950
          '1st year'  e        1400
          '1st year'  f        1150
          '1st year'  g        1300
          '1st year'  h        1325
          '1st year'  i        1425
          '1st year'  j        1500
          '1st year'  k        1250
          '1st year'  l        1150
          '1st year'  m         950
          '1st year'  n        1150
          '1st year'  o        1600
          '1st year'  p        1300
          '1st year'  q        1050
          '1st year'  r        1300
          '1st year'  s        1700
          '1st year'  t        1300
          '2nd year'  u        1100
          '2nd year'  v        1200
          '2nd year'  w        1250
          '2nd year'  x        1050
          '2nd year'  y        1200
          '2nd year'  z        1250
          '2nd year'  aa       1350
          '2nd year'  ab       1350
          '2nd year'  ac       1325
          '2nd year'  ad       1525
          '2nd year'  ae       1225
          '2nd year'  af       1125
          '2nd year'  ag       1000
          '2nd year'  ah       1125
          '2nd year'  ai       1400
          '2nd year'  aj       1200
          '2nd year'  ak       1150
          '2nd year'  al       1400
          '2nd year'  am       1500
          '2nd year'  an       1200
          '3rd year'  u        1600
          '3rd year'  v        1700
          '3rd year'  w        1450
          '3rd year'  x        1650
          '3rd year'  y        1800
          '3rd year'  z        1550
          '3rd year'  aa       1950
          '3rd year'  ab       1750
          '3rd year'  ac       1925
          '3rd year'  ad       1825
          '3rd year'  ae       1625
          '3rd year'  af       1525
          '3rd year'  ag       1800
          '3rd year'  ah       1725
          '3rd year'  ai       1200
          '3rd year'  aj       1600
          '3rd year'  ak       1950
          '3rd year'  al       1100
          '3rd year'  am       1400
          '3rd year'  an       1600
          ")


Data <- read.table(textConnection(Input),header=TRUE)


    # Preanalysis of data

    # Descriptive statistics
    
      Summarize(Wrkday ~ Year, data=Data, digits=3)
    
    # Skewness & Kurtosis?
      psych::describe(Data[Data$Year=='1st year',"Wrkday"])
      psych::describe(Data[Data$Year=='2nd year',"Wrkday"])
      psych::describe(Data[Data$Year=='3rd year',"Wrkday"])
    
    #Boxplot
      boxplot(Wrkday ~ Year, data=Data)
    
    #Mean with CI
      Sum <- groupwiseMean(Wrkday ~ Year, data   = Data, conf   = 0.95, digits = 3, traditional = FALSE, percentile  = TRUE)
      # traditional=T - traditional confidence intervals for the group means, using the t-distribution
      # percentile  = TRUE -  percentile confidence intervals for the group means by bootstrap
      
      #plot 
      ggplot(Sum, aes(x = Year, y = Mean)) +
        geom_errorbar(aes(ymin = Percentile.lower, ymax = Percentile.upper), width = 0.05, size  = 0.5) +
        geom_point(shape = 15, size  = 4) +
        theme_bw() +
        theme(axis.title   = element_text(face  = "bold")) +
        ylab("Mean Wrkday, mg")
   
      
      
       
    #### ONE-WAY ANOVA analysis
    
      #Estimating a linear model
      model <- lm(Wrkday ~ Year, data = Data)
    
      # F test for all betas=0
      # Rejecting H0 indicates that there is significant difference betwee averages
      summary(model) 
      
      #ANOVA analysis results
      Anova(model)   
      ### In this case F test from summary is the same F test as for Anova
      # Because we have only one indepent variables --> all betas for different Years levels
      # Conclusions? There is difference in means? In which particurarlly? Whe don't know.

      #Diagnostics
        #are residuals normal?
      
        res<- residuals(model)
        plotNormalHistogram(res)
        shapiro.test(res)

        #are variances equal to each other?
          # equality of variance tests for more then 2 samples
          # H0:all samples have the same variance
          # H1:variance is not the same for all samples
          bartlett.test(Wrkday ~ Year, data = Data) #assuming normality
          # bartlett.test(len ~ interaction(supp,dose), data=ToothGrowth)
          leveneTest(Wrkday ~ Year, data = Data)
          fligner.test(Wrkday ~ Year, data = Data)
      
          
      #POST-HOC analysis
        #pairwise comparsion of means after ANOVA
        ls = lsmeans::lsmeans(model, pairwise ~ Year, adjust = "holm")
        # it calculates averages for each group & contrasts (differences)
        # the same as sample beacuse only one variable

        #different methods for p-values adjustments wrt multpiple comparsions
        lsmeans::lsmeans(model, pairwise ~ Year, adjust = "hochberg")
        lsmeans::lsmeans(model, pairwise ~ Year, adjust = "holm")
        lsmeans::lsmeans(model, pairwise ~ Year, adjust = "bonferroni")


      # Compact letter display of pairwise comparisons
        # preparation for plot with letters informing which means are not different
        cld = cld(ls[[1]], alpha   = 0.05, Letters = letters,    adjust  = "holm")    
        ### Letters = letters - Use lower-case letters for .group
        cld
      
        ### Order the levels for printing
        cld$Year = factor(cld$Year, levels=c("1st year", "2nd year", "3rd year"))
        
        ###  Remove spaces in .group  
        cld$.group=gsub(" ", "", cld$.group)
      
      
        ### Plot
        
        ggplot(cld,
               aes(x     = Year, y     = lsmean, label = .group)) +
          geom_point(shape  = 15, size   = 4) +
          geom_errorbar(aes(ymin  =  lower.CL, ymax  =  upper.CL), width =  0.2, size  =  0.7) +
          theme_bw() +
          theme(axis.title   = element_text(face = "bold"), axis.text    = element_text(face = "bold"),  plot.caption = element_text(hjust = 0)) +
          ylab("Least square mean\n Wrkday cost") +
          geom_text(nudge_x = c(0, 0, 0),
                    nudge_y = c(120, 120, 120),
                    color   = "black")


 
        
        
        
               
        
      ####################################
      
      
      # Kruskall - Wallis test
      
      
      ####################################
      # Alternative for ANOVA when assumptions about normality are not met
            
          
        #In order to be a test of medians, the distributions of values for each group need to be of similar shape and
        # spread. Otherwise the test is a test of distributions.
        #Equal variances? - this time bartlet test is not appropriate
          leveneTest(Wrkday ~ Year, data = Data)
          fligner.test(Wrkday ~ Year, data = Data)
      
        # Kruskall - Wallis test
          kruskal.test(Wrkday ~ Year, data = Data)
      
        ### POST-HOC analysis - pairwise comparison
          #Dunn test
          dunn.test(x=Data$Wrkday, g=Data$Year, method=c("hs"))
          DT <- dunn.test(x=Data$Wrkday, g=Data$Year, method=c("by"))     
          # Adjusts p-values for multiple comparisons;
          
          #Another function, to get table prepared for Compact letter display
          DT<-dunnTest(x=Data$Wrkday, g=Data$Year, method=c("by"))
          DT$res
        
          ### Conover-Iman test
          conover.test(x=Data$Wrkday, g=Data$Year, method=c("bonferroni"))
          CI <- conover.test(x=Data$Wrkday, g=Data$Year, method=c("bonferroni"))     
          # Adjusts p-values for multiple comparisons;
          CI
        
          ### Mann-Whitney/Wicoxon test
          PT = pairwise.wilcox.test(x=Data$Wrkday, g=Data$Year, p.adjust.method="BH")
          PT
        
          #plot  
            ### Compact letter display list - assaign same letters for pairs that are not statistically different
            
            cld<-cldList(P.adj ~ Comparison, data = DT$res, threshold = 0.05)
            
            # Groups sharing a letter not signficantly different (alpha = 0.05).
            
            
            # Nice figure - medians with CI & CLD
            ### Order groups by year
            
            Data$Year = factor(Data$Year,levels=c("1st year", "2nd year", "3rd year"))
            
            
            Sum = groupwiseMedian(Wrkday ~ Year, data = Data, R= 5000, percentile = TRUE,bca= FALSE, digits= 3)
            # bca= FALSE - The intervals calculated using the adjusted bootstrap percentile (BCa) method (DEFAULT)
            # percentile = TRUE - The intervals calculated using the bootstrap percentile method
            Sum
            
            #data preparation for a plot
            X     = 1:length(cld$Letter) 
            Y     = Sum$Percentile.upper + 20
            Label = c("a", "b", "a")
            
            #plot
            ggplot(Sum,                ### The data frame to use.
                   aes(x = Year, y = Median)) + ### axis creation.
              geom_errorbar(aes(ymin = Percentile.lower, ymax = Percentile.upper), width = 0.05, size  = 0.5) +
              geom_point(shape = 15,  size  = 4) +
              theme_bw() +
              theme(axis.title   = element_text(face  = "bold")) +
              ylab("Median") +
              annotate("text", x = X, y = Y, label = cld$Letter)

    ####################################
    
    
    # Mood's Median test
    
    
    ####################################
    ####  If variances are not equal
    
    mood.medtest(Wrkday ~ Year, data = Data)
    #post-hoc
    pairwiseMedianTest(Wrkday ~ Year, data   = Data, exact  = T, method = "bonferroni")


########################################################### 


# ANOVA with blocks

    
###########################################################

    
    Input <- ("
Subject       Student  Result
          'Math'  1        1200
          'Math'  2        1400
          'Math'  3        1350
          'Math'  4         950
          'Math'  5        1400
          'Math'  6        1150
          'Math'  7        1300
          'Math'  8        1325
          'Math'  9        1425
          'Math'  10        1500
          'Math'  11        1250
          'Math'  12        1150
          'Math'  13         950
          'Math'  14        1150
          'Math'  15        1600
          'Math'  16        1300
          'Math'  17        1050
          'Math'  18        1300
          'Math'  19        1700
          'Math'  20        1300
          'Biology'  1        1100
          'Biology'  2        1200
          'Biology'  3        1250
          'Biology'  4        1050
          'Biology'  5        1200
          'Biology'  6        1250
          'Biology'  7       1350
          'Biology'  8       1350
          'Biology'  9       1325
          'Biology'  10       1525
          'Biology'  11       1225
          'Biology'  12       1125
          'Biology'  13       1000
          'Biology'  14       1125
          'Biology'  15       1400
          'Biology'  16       1200
          'Biology'  17       1150
          'Biology'  18       1400
          'Biology'  19       1500
          'Biology'  20       1200
          'English'  1        1600
          'English'  2        1700
          'English'  3        1450
          'English'  4        1650
          'English'  5        1800
          'English'  6        1550
          'English'  7       1950
          'English'  8       1750
          'English'  9       1925
          'English'  10       1825
          'English'  11       1625
          'English'  12       1525
          'English'  13       1800
          'English'  14       1725
          'English'  15       1200
          'English'  16       1600
          'English'  17       1950
          'English'  18       1100
          'English'  19       1400
          'English'  20       1600
          ")
    
    
    Data <- read.table(textConnection(Input),header=TRUE)
    
    

#descriptive statistics
  Summarize(Result ~ Subject + Student, data=Data, digits=3)
  Summarize(Result ~ Student, data=Data, digits=3)
  Summarize(Result ~ Subject, data=Data, digits=3)
  
  ### ANOVA with blocks  - we put blocks directly into model in order separate its influence
  
  #linear model  
    model = lm(Result ~ Subject+factor(Student), data = Data)
    summary(model)   ### Will show overall p-value and r-squared
  
  #histogram of 1st-3rd Subject
    histogram(~ Result | Subject, data=Data, layout=c(3,2))
  
  
  #anova analysis 
    Anova(model, type = "II")   
    ### Type II sum of squares (A|B) & (B|A)
  
  #diagnostics
    #normality
    res<- residuals(model)
    plotNormalHistogram(res)
    shapiro.test(res)

      # With unreplicated study design
      bartlett.test(Result ~ Subject, data = Data) #assuming normality


  #post-hoc analysis
      
    # We are not interesed in blocks so we only compare means for Subject
    leastsquare = lsmeans::lsmeans(model, pairwise ~ Subject, adjust = "tukey")

    leastsquare$lsmeans
    leastsquare$contrasts

    # Results are averaged over the levels of: Student 

  #plot  
    CLD = cld(leastsquare[[1]], alpha   = 0.05, Letters = letters, adjust  = "tukey")
    CLD

    ### Order the levels for printing
    CLD$Subject = factor(CLD$Subject, levels=c("Math", "Biology", "English"))

    ###  Remove spaces in .group  
    CLD$.group=gsub(" ", "", CLD$.group)
    
    
    ### Plot
    
    ggplot(CLD,
           aes(x     = Subject, y     = lsmean, label = .group)) +
      geom_point(shape  = 15, size   = 4) +
      geom_errorbar(aes(ymin  =  lower.CL, ymax  =  upper.CL), width =  0.2, size  =  0.7) +
      theme_bw() +
      theme(axis.title   = element_text(face = "bold"), axis.text    = element_text(face = "bold"),  plot.caption = element_text(hjust = 0)) +
      ylab("Least square mean\n Result cost") +
      geom_text(nudge_x = c(0, 0, 0),
                nudge_y = c(150, 150, 150),
                color   = "black")
  

########################################################


# ANOVA with random blocks   
    

########################################################### 

  #MIxed-effect model
    
  model = lmer(Result ~ Subject2+ subject3 + (1|Student), data=Data, REML=TRUE)
  # (1|Student) - random intercept for each Student
  # REML - restricted maximum likelihood estimator

  anova(model)

  
    #Diagnostics
      #are residuals normal?
      
      res<- residuals(model)
      plotNormalHistogram(res)
      shapiro.test(res)
      
      #are variances equal to each other?
      # equality of variance tests for more then 2 samples
      # H0:all samples have the same variance
      # H1:variance is not the same for all samples
      bartlett.test(Result ~ Subject, data = Data) #assuming normality
      # bartlett.test(len ~ interaction(supp,dose), data=ToothGrowth)
      leveneTest(Result ~ Subject, data = Data)
      fligner.test(Result ~ Subject, data = Data)
      
      # comaprsion of a model with null modell
      # null model including random effect
      model.null = lmer(Result ~ subject2 + (1|Student), data=Data, REML=TRUE)
      
      #2 models comparisons
      #H0: General model is statistitcally indifferent to specific model
      #H1: Genereal model is better than specific model
      anova(model,model.null)
      
      #R2
      nagelkerke(fit  = model, null = model.null)
      
      # null model not including random effects
      model.null.2 = lm(Result ~ Subject, data = Data)
      anova(model, model.null.2)
      nagelkerke(fit  = model, null = model.null.2)


    #POST_HOC
    leastsquare = lsmeans::lsmeans(model, pairwise ~ Subject,   adjust="tukey")         ###  Tukey-adjusted comparisons
    CLD = cld(leastsquare[[1]], alpha=0.05,  Letters=letters,  adjust="tukey")         
    leastsquare$contrasts



##########################################################


# Friedman & Quade tests
    
    
###########################################################

  #variable creation for unreplicated complete block design
    #in each block every subject only once
    
  #Group Averages Over Level Combinations of Factors
  #Here function is not mean but simply sequnce of integers

  Data$num <- ave(Data$Result,Data$Subject, FUN = seq_along)

    # x - Data$Result numeric variable to which function should be applied (in this case any numeric)
    # among subset of x where Data$Subject on the same level
    # sequence genereation FUN = seq_along

    # The test is based on the differences between paired data
    # The function pairwiseDifferences will create a new data frame of differences for all pairs of differences.  
    # Note that the data must be ordered by the blocking variable so that the first observation 
    # for 1st Subject will be paired with the first observation for 2nd Subject, and so on.



 
  #descriptive statistics, are distirbutions similar in spread and shape?
  Summarize(Result ~ Subject, data=Data, digits=3)
  describeBy(Data$Result, group=Data$Subject)

  leveneTest(Result ~ Subject, data = Data)
  fligner.test(Result ~ Subject, data = Data)


  #friedman test
  #H0:Same medians/same distributions
  
  friedman.test(Result ~ Subject | Student, data = Data)
  
  # install.packages('PMCMRplus')
  library(PMCMRplus)
  
 
  ## Global Friedman test
  friedmanTest(y=Data$Result,groups=Data$Subject,blocks=Data$Student)
  ## Demsar's many-one test
  frdManyOneDemsarTest(y=Data$Result,groups=Data$Subject,blocks=Data$Student, p.adjust = "bonferroni")
  ## Exact many-one test
  frdManyOneExactTest(y=Data$Result,groups=Data$Subject,blocks=Data$Student, p.adjust = "bonferroni")
  ## Nemenyi's many-one test

  FR<-frdAllPairsExactTest(y=Data$Result,groups=Data$Subject,blocks=Data$Student, p.adjust = "bonferroni")

  FR1 = fullPTable(FR[[3]])
  FR1
  
  ### Compact letter display
  multcompLetters(FR1,  compare="<", threshold=0.05, Letters=letters)


  #Quade test
  #H0:Same medians/same distributions
  
  quade.test(Result ~ Subject | Student, data = Data)
  
  #CLD
  
  PT = pairwise.wilcox.test(Data$Result, Data$Subject,  p.adjust.method="fdr",  paired=TRUE)$p.value
  PT
  
  #Convert a lower triangle matrix to a full matrix
  PT1 = fullPTable(PT)
  PT1

  #Letter summary of similarities and differences
  multcompLetters(PT1,  compare="<", threshold=0.05, Letters=letters)

  # X symmetric matrix with p-values
  # comapre - function for comapre if "<" then threshold than different
  # Letters=letters - Vector of distinct characters (or character strings) 
  # used to connect levels that are not significantly different. 




  ##################################################################
  
  
  # 2-way ANOVA     
  
  
  ##################################################################
  #Specification as A+B+A*B

Input = ("
         Year        Avg  Wrkday
         '1st year'   A           1200
         '1st year'   A           1400
         '1st year'   A           1350
         '1st year'   A            950
         '1st year'   A           1400
         '1st year'   B           1150
         '1st year'   B           1300
         '1st year'   B           1325
         '1st year'   B           1425
         '1st year'   B           1500
         '1st year'   C           1250
         '1st year'   C           1150
         '1st year'   C            950
         '1st year'   C           1150
         '1st year'   C           1600
         '1st year'   D           1300
         '1st year'   D           1050
         '1st year'   D           1300
         '1st year'   D           1700
         '1st year'   D           1300
         '2nd year'   A           1100
         '2nd year'   A           1200
         '2nd year'   A           1250
         '2nd year'   A           1050
         '2nd year'   A           1200
         '2nd year'   B           1250
         '2nd year'   B           1350
         '2nd year'   B           1350
         '2nd year'   B           1325
         '2nd year'   B           1525
         '2nd year'   C           1225
         '2nd year'   C           1125
         '2nd year'   C           1000
         '2nd year'   C           1125
         '2nd year'   C           1400
         '2nd year'   D           1200
         '2nd year'   D           1150
         '2nd year'   D           1400
         '2nd year'   D           1500
         '2nd year'   D           1200
         '3rd year'  A            900
         '3rd year'  A           1100
         '3rd year'  A           1150
         '3rd year'  A            950
         '3rd year'  A           1100
         '3rd year'  B           1150
         '3rd year'  B           1250
         '3rd year'  B           1250
         '3rd year'  B           1225
         '3rd year'  B           1325
         '3rd year'  C           1125
         '3rd year'  C           1025
         '3rd year'  C            950
         '3rd year'  C            925
         '3rd year'  C           1200
         '3rd year'  D           1100
         '3rd year'  D            950
         '3rd year'  D           1300
         '3rd year'  D           1400
         '3rd year'  D           1100
         ")


Data <- read.table(textConnection(Input),header=TRUE)
# Data$Wrkday<-ifelse(Data$Year=="3rd year"&Data$Avg=="A",Data$Wrkday+700,Data$Wrkday)

  #Preanalysis
    #descriptive stats
    Summarize(Wrkday ~ Year+Avg, data=Data, digits=3)
    
  #2-way ANOVA
    #define a model Year:Avg is interaction
    model <- lm(Wrkday ~ Year + Avg + Year:Avg, data = Data)
    summary(model)
    
    #anova analysis type 3 - why? B/c
    Anova(model,type = "III")
    #interactions are significant
    
  
  #Diagnostics
    res<- residuals(model)
    plotNormalHistogram(res)
    shapiro.test(res)
    
    # equality of variance tests for more then 2 samples
    # H0:all samples have the same variance
    # H1:variance is not the same for all samples
    
    bartlett.test(Wrkday ~ interaction(Year,Avg), data=Data)
    leveneTest(Wrkday ~ interaction(Year,Avg), data = Data)
    fligner.test(Wrkday ~ interaction(Year,Avg), data = Data)
    


  #### POST-HOC LS MEANS
  # detach("package:lmerTest", unload=TRUE) #we need to unload lmerTest package as it's changing lsmeans function for mixed models
  library(lsmeans)
  
  #means for years
  lsYear <- lsmeans::lsmeans(model, pairwise ~ Year, adjust = "tukey")
  lsYear$contrasts
  CLDYear = cld(lsYear[[1]], alpha   = 0.05,   Letters = letters,   adjust  = "tukey")         
  CLDYear
  CLDYear$.group=gsub(" ", "", CLDYear$.group)
  
  ggplot(CLDYear,
         aes(x     = Year, y     = lsmean, label = .group)) +
        geom_point(shape  = 15,   size   = 4) +
        geom_errorbar(aes(ymin  =  lower.CL,     ymax  =  upper.CL),  width =  0.2,  size  =  0.7) +
        theme_bw() +
        theme(axis.title   = element_text(face = "bold"),  axis.text    = element_text(face = "bold"),  plot.caption = element_text(hjust = 0)) +
        ylab("Least square means Years") +
        geom_text(nudge_x = c(0, 0, 0), nudge_y = c(120, 120, 120),   color   = "black")
  
  
  #means for AVG  
  lsAvg <- lsmeans(model, pairwise ~ Avg, adjust = "tukey")
  lsAvg$contrasts
  CLDAvg = cld(lsAvg[[1]],  alpha   = 0.05,    Letters = letters,  adjust  = "tukey")   
  CLDAvg
  CLDAvg$.group=gsub(" ", "", CLDAvg$.group)  
    
  ggplot(CLDAvg,
           aes(x     = Avg, y     = lsmean, label = .group)) +
           geom_point(shape  = 15,   size   = 4) +
           geom_errorbar(aes(ymin  =  lower.CL,     ymax  =  upper.CL),  width =  0.2,  size  =  0.7) +
           theme_bw() +
           theme(axis.title   = element_text(face = "bold"),  axis.text    = element_text(face = "bold"),  plot.caption = element_text(hjust = 0)) +
            ylab("Least square means AVG") +
            geom_text(nudge_x = c(0, 0, 0), nudge_y = c(120, 120, 120),   color   = "black")
    
    
  ### What to do if interactions are significant?
    # present an interaction plot of the means for both main effects together on one plot. 
    
    leastsquare = lsmeans(model, pairwise ~ Year:Avg, adjust = "tukey")
    CLD = cld(leastsquare[[1]],  alpha   = 0.05,  Letters = letters,  adjust  = "tukey")   
    ###  Remove spaces in .group  
    CLD$.group=gsub(" ", "", CLD$.group)
    CLD
    
    ### Plot
    
    pd = position_dodge(0.6)    ### How much to jitter the points on the plot
    ggplot(CLD,
           aes(x     = Year, y     = lsmean, color = Avg,  label = .group)) +
           geom_point(shape  = 15, size   = 4,  position = pd) +
           geom_errorbar(aes(ymin  =  lower.CL,  ymax  =  upper.CL),  width =  0.2,  size  =  0.7,  position = pd) +
           theme_bw() +
           theme(axis.title   = element_text(face = "bold"),  axis.text    = element_text(face = "bold"),  plot.caption = element_text(hjust = 0)) +
           ylab("Least square means Year*Avg") +
           geom_text(nudge_x = c(-0.22, 0.08, -0.22, 0.22, 0.08, 0.08, -0.08, -0.22, 0.22, 0.22, -0.08, -0.08),nudge_y = rep(270, 12),
           color   = "black") +
           scale_color_manual(values = c("steelblue", "steelblue2","springgreen4", "springgreen3"))
    
    ### Produce interaction plot
    IM = interactionMeans(model)
    IM
    
    ### Produce interaction plot
    plot(IM)
    
    ### Return the graphics device to its default 1-plot-per-window state
    par(mfrow=c(1,1))

    ################################################################################################################### 
    
    
    # Scheirer?Ray?Hare test - nonparametric equivalnet ot factorial ANOVA, extention of Kruskall-Wallis test
    
    
    ###################################################################################################################
    
    scheirerRayHare(Wrkday ~ Year+Avg+Year:Avg,    data = Data)
    
    ### Post-hoc - Dunn test
    
    #independently?
    DTYear = dunnTest(Wrkday ~ Year, data=Data, method="bh")      
    DTYear
    
    DTAvg = dunnTest(Wrkday ~ Avg, data=Data, method="bh")      
    DTAvg
    
    #or jointly?
    DTAll = dunnTest(Wrkday ~ interaction(Year,Avg), data=Data, method="bh")      
    DTAll



########################################################

    
    
# Reapeated measures ANOVA      

    

########################################################### 
    
    
Input = ("
         Wrk_type        Student  Month   Salary
         'Journalist'     a        1       2000
         'Journalist'     a        2       1978
         'Journalist'     a        3       1962
         'Journalist'     a        4       1873
         'Journalist'     a        5       1782
         'Journalist'     a        6       1737
         'Journalist'     b        1       1900
         'Journalist'     b        2       1826
         'Journalist'     b        3       1782
         'Journalist'     b        4       1718
         'Journalist'     b        5       1639
         'Journalist'     b        6       1644
         'Journalist'     c        1       2100
         'Journalist'     c        2       2067
         'Journalist'     c        3       2065
         'Journalist'     c        4       2015
         'Journalist'     c        5       1994
         'Journalist'     c        6       1919
         'Journalist'     d        1       2000
         'Journalist'     d        2       1981
         'Journalist'     d        3       1987
         'Journalist'     d        4       2016
         'Journalist'     d        5       2010
         'Journalist'     d        6       1946
         'Data Scientist'     e        1       2100
         'Data Scientist'     e        2       2004
         'Data Scientist'     e        3       2027
         'Data Scientist'     e        4       2109
         'Data Scientist'     e        5       2197
         'Data Scientist'     e        6       2294
         'Data Scientist'     f        1       2000
         'Data Scientist'     f        2       2011
         'Data Scientist'     f        3       2089
         'Data Scientist'     f        4       2124
         'Data Scientist'     f        5       2199
         'Data Scientist'     f        6       2234
         'Data Scientist'     g        1       2000
         'Data Scientist'     g        2       2074
         'Data Scientist'     g        3       2141
         'Data Scientist'     g        4       2199
         'Data Scientist'     g        5       2265
         'Data Scientist'     g        6       2254
         'Data Scientist'     h        1       2000
         'Data Scientist'     h        2       1970
         'Data Scientist'     h        3       1951
         'Data Scientist'     h        4       1981
         'Data Scientist'     h        5       1987
         'Data Scientist'     h        6       1969
         'Other'     i        1       1950
         'Other'     i        2       2007
         'Other'     i        3       1978
         'Other'     i        4       1965
         'Other'     i        5       1984
         'Other'     i        6       2020
         'Other'     j        1       2000
         'Other'     j        2       2029
         'Other'     j        3       2033
         'Other'     j        4       2050
         'Other'     j        5       2001
         'Other'     j        6       1988
         'Other'     k        1       2000
         'Other'     k        2       1976
         'Other'     k        3       2025
         'Other'     k        4       2047
         'Other'     k        5       2033
         'Other'     k        6       1984
         'Other'     l        1       2000
         'Other'     l        2       2020
         'Other'     l        3       2009
         'Other'     l        4       2017
         'Other'     l        5       1989
         'Other'     l        6       2020
         ")      


Data = read.table(textConnection(Input),header=TRUE)


  #Note:
    # Generalized Least Squares estimation 
      # without random effects
    
      # model = gls(Salary ~ Wrk_type + Month + Wrk_type*Month,
      #             correlation = corAR1(form = ~ Month | Student,
      #                                  value = 0.8990),
      #             data=Data,
      #             method="REML")
      # 
      # library(car)
      # 
      # Anova(model)
    # 

  #Mixed effects model
  
  model = lme(Salary ~ Wrk_type + Month + Wrk_type:Month, random = ~1|Student, correlation = corAR1(form = ~ Month | Student), data=Data, method="REML")
  summary(model)
  
  # correlation = Structure(form  = ~ time | subjvar)
  #   Structure -  autocorrelation structure.
  #     corAR1	- autoregressive process of order 1.
  #     corARMA	- autoregressive moving average process, with arbitrary orders for the autoregressive and moving average components.
  #     corCompSymm - compound symmetry structure corresponding to a constant correlation.
  #     corSymm	-  general correlation matrix, with no additional structure.
  # time - time variable 
  # subjvar - unit id Autocorrelation is modeled within levels of the subjvar, and not between them.
  # 
  
  # AIC selection of correlation structure
  # Model selection for fixed effects is only appropriate with method=ML
  # REML (default) should only be used to select random effects for a constant set of fixed effects
  
  Cand.models <- list( )
  
  Cand.models[[1]] <- lme(Salary ~ Wrk_type + Month + Wrk_type:Month, random = ~1|Student, data=Data, method="ML")
  Cand.models[[2]] <- lme(Salary ~ Wrk_type + Month + Wrk_type:Month, random = ~Month|Student, data=Data, method="ML")
  Cand.models[[3]] <- lme(Salary ~ Wrk_type + Month + Wrk_type:Month, random = ~1|Student, correlation = corCompSymm(form = ~ Month | Student), data=Data, method="ML")
  Cand.models[[4]] <- lme(Salary ~ Wrk_type + Month + Wrk_type:Month, random = ~Month|Student, correlation = corCompSymm(form = ~ Month | Student), data=Data, method="ML")
  Cand.models[[5]] <- lme(Salary ~ Wrk_type + Month + Wrk_type:Month, random = ~1|Student, correlation = corAR1(form = ~ Month | Student), data=Data, method="ML")
  Cand.models[[6]] <- lme(Salary ~ Wrk_type + Month + Wrk_type:Month, random = ~1|Student, correlation = corSymm(form = ~ Month | Student), data=Data, method="ML")
  


  ##create a vector of names to trace back models in set
  Modnames <- paste("mod", 1:length(Cand.models), sep = " ")

  ##generate AICc table
  aictab<-aictab(cand.set = Cand.models, modnames = Modnames, sort = TRUE)
  #which model is the best?
  aictab
  
  #the best is model 5
  model = lme(Salary ~ Wrk_type + Month + Wrk_type:Month, random = ~1|Student, correlation = corAR1(form = ~ Month | Student), data=Data, method="REML")
  summary(model)
  
  # diagnostics

    #random effects check
    model.fixed = gls(Salary ~ Wrk_type + Month + Wrk_type*Month, data=Data, method="REML")
    anova(model, model.fixed)
    
    #model significance check
    model.null.2 = gls(Salary ~ 1, data = Data)
    nagelkerke(model, model.null.2)
    
    #residuals normality check
    x = residuals(model)
    plotNormalHistogram(x)
    shapiro.test(x)
  
  
  #anova analysis
    
    #if interactions are significant
    #2 is disputable - because we omit interactions which are important
    Anova(model, type="II") # (A|B),(B|A), (AB|A,B)
    
    #3 type is appropriate
    Anova(model, type="III") # (A|B,AB),(B|A,AB), (AB|A,B)
    
    #Interpretation
      #Interaction Wrk_type:Month - difference in month trends in salaries for different Wrk_type
      #Linear trend in Salaries for base Wrk_type (Data Scientist)
      #Different Salaries for Wrk_type at Month 1

  #post-hoc analysis

    lsmeans(model,  pairwise ~ Wrk_type:Month,  adjust="holm")

    #plot 
    Sum = groupwiseMean(Salary ~ Wrk_type + Month, data   = Data,  conf   = 0.95, digits = 3,   traditional = FALSE,    percentile  = TRUE)
    Sum
    
    pd = position_dodge(.2)
    
    ggplot(Sum, aes(x =    Month, y =Mean, color = Wrk_type)) +
      geom_errorbar(aes(ymin=Percentile.lower,  ymax=Percentile.upper), width=.2, size=0.7, position=pd) +
      geom_point(shape=15, size=4, position=pd) +
      theme_bw() +
      theme(axis.title = element_text(face = "bold")) +
      ylab("Mean salaries per work type")


  #EXTRA
        # # What to do if we want to check wheter time has an influence on each wrk_type
        # # and when the significant difference between wrk_type starts?
        # 
        # #ordered factor
        # Data$Mnt<-factor(Data$Month,ordered=T)
        # #model with ordered factor (note: we do no assume linear influence month)
        # model = lme(Salary ~ Wrk_type + Mnt + Wrk_type:Mnt, random = ~1|Student, correlation = corAR1(form = ~ Month | Student), data=Data, method="REML")
        # summary(model)
        # 
        # 
        # #adjustment for multiple comparisons
        # lsmeans(model,  pairwise ~ Wrk_type|Mnt, adjust="tukey")
        # lsmeans(model,  pairwise ~ Mnt|Wrk_type,  adjust="tukey")
        