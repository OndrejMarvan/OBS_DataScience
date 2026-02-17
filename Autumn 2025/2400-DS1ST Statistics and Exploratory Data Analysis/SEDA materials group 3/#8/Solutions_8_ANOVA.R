###################################################################
#           Statistics and Explaratoroty Data Analysis            #
#                        Excersises 7                             #
#                      ANOVA & related                            #
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

(!require(car)){install.packages("car")}
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




#Excersise 1



#1


  db<-chickwts

#2

  # Preanalysis of data
  
    # Descriptive statistics
    
    Summarize(weight ~ feed, data=db, digits=3)
    
    # Skewness & Kurtosis?
    describeBy(db$weight,db$feed)
    
    #Boxplot
    boxplot(weight ~ feed, data=db)
    
    #Mean with CI
    Sum <- groupwiseMean(weight ~ feed, data   = db, conf   = 0.95, digits = 3, traditional = FALSE, percentile  = TRUE)
    # traditional=T - traditional confidence intervals for the group means, using the t-distribution
    # percentile  = TRUE -  percentile confidence intervals for the group means by bootstrap
    
    #plot 
    ggplot(Sum, aes(x = feed, y = Mean)) +
      geom_errorbar(aes(ymin = Percentile.lower, ymax = Percentile.upper), width = 0.05, size  = 0.5) +
      geom_point(shape = 15, size  = 4) +
      theme_bw() +
      theme(axis.title   = element_text(face  = "bold")) +
      ylab("Mean weight, mg")


#3

  #Estimating a linear model
  model <- lm(weight ~ feed, data = db)


  #Diagnostics
    #are residuals normal?
    
    res<- residuals(model)
    plotNormalHistogram(res)
    shapiro.test(res)
    
    #are variances equal to each other?
    # equality of variance tests for more then 2 samples
    # H0:all samples have the same variance
    # H1:variance is not the same for all samples
    bartlett.test(weight ~ feed, data = db) #assuming normality
  
    leveneTest(weight ~ feed, data = db)
    fligner.test(weight ~ feed, data = db)
    
    #normality and equal variances fulfilled 

#4
  # F test for all betas=0
  # Rejecting H0 indicates that there is significant difference betwee averages
  summary(model) 
  
  #ANOVA analysis results
  Anova(model)   
  
  #Rejecting H0 weight of a chciken depends on feed type
  
#5  
  #POST-HOC analysis
    #pairwise comparsion of means after ANOVA
    ls = lsmeans(model, pairwise ~ feed, adjust = "holm")
    # it calculates averages for each group & contrasts (differences)
    # the same as sample beacuse only one variable
    
    
    # Compact letter display of pairwise comparisons
    # preparation for plot with letters informing which means are not different
    cld = cld(ls, alpha   = 0.05, Letters = letters,    adjust  = "holm")    
    ### Letters = letters - Use lower-case letters for .group
    cld
    
    
    ### Order the levels for printing
    cld$feed = factor(cld$feed, levels=unique(cld$feed))
    
    ###  Remove spaces in .group  
    cld$.group=gsub(" ", "", cld$.group)
    
    
    ### Plot
    
    ggplot(cld,
           aes(x     = feed, y     = lsmean, label = .group)) +
      geom_point(shape  = 15, size   = 4) +
      geom_errorbar(aes(ymin  =  lower.CL, ymax  =  upper.CL), width =  0.2, size  =  0.7) +
      theme_bw() +
      theme(axis.title   = element_text(face = "bold"), axis.text    = element_text(face = "bold"),  plot.caption = element_text(hjust = 0)) +
      ylab("Least square mean\n weight cost") +
      geom_text(nudge_x = c(0, 0, 0),
                nudge_y = c(120, 120, 120),
                color   = "black")

  # the most effective feed types are: casein and sunflower




#Excersie 2



#1
  
  #Estimating a linear model
  model <- lm(count ~ spray, data = InsectSprays)
  
  
  #Diagnostics
  #are residuals normal?
  
  res<- residuals(model)
  plotNormalHistogram(res)
  shapiro.test(res)
  
  #are variances equal to each other?
  
  # bartlett.test(len ~ interaction(supp,dose), data=ToothGrowth)
  leveneTest(count ~ spray, data = InsectSprays)
  fligner.test(count ~ spray, data = InsectSprays)
  
  #neither normality nor equal variances assumption is fulfilled
  
#2
  mood.medtest(count ~ spray, data = InsectSprays)
  
  #there is significant difference in effectivness of different sprays
  
#3  
  #post-hoc
  PT= pairwiseMedianTest(count ~ spray, data = InsectSprays, exact  = T, method = "bonferroni")
  
  
  PT                         
  cldList(comparison = PT$Comparison,
          p.value    = PT$p.adjust,
          threshold  = 0.05)
  
  #spray A,B & F are equally effective as well as sprays C,D & F   
  
  
  
  #Excercise 3
  
  
  #1

  
    if(!require(tidyr)){install.packages("tidyr")}
    library(tidyr) #gather
    
    db<-as.data.frame(USJudgeRatings)
    db$block<-rownames(db)
    Data<-gather(db,ability,grade,-block)
    

  #2  Which test?
  
    ### ANOVA with blocks  - we put blocks directly into model in order separate its influence
    
    #linear model  
    model = lm(grade ~ ability+block, data = Data)
    summary(model)   ### Will show overall p-value and r-squared
    
    #anova analysis 
    Anova(model, type = "II")   
    ### Type II sum of squares (A|B) & (B|A)
    
    #diagnostics
    #normality
    res<- residuals(model)
    plotNormalHistogram(res)
    shapiro.test(res)
    
    # bartlett.test(grade ~ interaction(ability,block), data=Data)
    leveneTest(grade ~ ability, data = Data)
    leveneTest(grade ~ block, data = Data)
    
    # Assumptions not met
  
    #ANOVA with random blocks
    
      model = lmer(grade ~ ability + (1|block), data=Data, REML=TRUE)
      # (1|block) - random intercept for each block
      # REML - restricted maximum likelihood estimator
      summary(model)
      
      #Diagnostics
      #are residuals normal?
      
      res<- residuals(model)
      plotNormalHistogram(res)
      shapiro.test(res)
      
      #are variances equal to each other?
      # equality of variance tests for more then 2 samples
      leveneTest(grade ~ ability, data = Data)
      
      # Assumptions not met
    
    # Friedman test - why not Quade? --> more than 5 groups (abilities)
  
      #variable creation for unreplicated complete block design
      #in each block every subject only once
      
      #Group Averages Over Level Combinations of Factors
      #Here function is not mean but simply sequnce of integers
      
      Data$num <- ave(Data$grade,Data$ability, FUN = seq_along)

      # x - Data$grade numeric variable to which function should be applied (in this case any numeric)
      # among subset of x where Data$ability on the same level
      # sequence genereation FUN = seq_along
      
      # The test is based on the differences between paired data
      # The function pairwiseDifferences will create a new data frame of differences for all pairs of differences.  
      # Note that the data must be ordered by the blocking variable so that the first observation 
      # for 1st year will be paired with the first observation for 2nd year, and so on.
      
      
      
      Data.diff = pairwiseDifferences(grade ~ ability, data= Data, factorize=TRUE, plotit=T)
      # plotit	-   If TRUE, then produces bar plots of the differences.
      # factorize	- If TRUE, then adds a column to the output data frame consisting of the differences as a factor variable. 
      
      #are differences symmetrical?
      histogram(~ Difference | Comparison,data=Data.diff,  type = "count",layout=c(1,3))      #  columns and rows of individual plots
      
      #descriptive statistics, are distirbutions similar in spread and shape?
      Summarize(grade ~ ability, data=Data, digits=3)
      describeBy(Data$grade, group=Data$ability)
      
      leveneTest(grade ~ ability, data = Data)
      fligner.test(grade ~ ability, data = Data)
      
      
      #friedman test
      #H0:Same medians/same distributions
      
      friedman.test(grade ~ ability | num, data = Data)
      
      #POST-HOC
      PT = pairwiseSignTest(grade ~ ability, data   = Data,  method = "fdr")
      PT
      ### Compact letter display
      cldList(p.adjust ~ Comparison,data = PT,threshold  = 0.05)
      
      
      

      
# Excersise 4
      
      #1
        Data <- ToothGrowth
        Data$dose<-factor(Data$dose,levels=c("0.5","1","2"), order=F)
        
      #2
        #Preanalysis
        #descriptive stats
        Summarize(len ~ supp+dose, data=Data, digits=3)
        
        #2-way ANOVA
        #define a model supp:dose is interaction
        model <- lm(len ~ supp + dose + supp:dose, data = Data)
        
      
        #Diagnostics
        res<- residuals(model)
        plotNormalHistogram(res)
        shapiro.test(res)
        
        # equality of variance tests for more then 2 samples
        # H0:all samples have the same variance
        # H1:variance is not the same for all samples
        
        bartlett.test(len ~ interaction(supp,dose), data=Data)
        
        
      
      
      #3
      summary(model)
      
      #anova analysis type 3 - why?
      Anova(model,type = "III")
      #interactions are significant
      
   
      #4
      
        #### POST-HOC LS MEANS
        detach("package:lmerTest", unload=TRUE) #we need to unload lmerTest package as it's changing lsmeans function for mixed models
        library(lsmeans)
        
        ### What to do if interactions are significant?
        # present an interaction plot of the means for both main effects together on one plot. 
        
        lsmeans(model, pairwise ~ supp|dose, adjust = "holm")
        lsmeans(model, pairwise ~ dose|supp, adjust = "holm")
      
      #5  
        ### Produce interaction plot
        IM = interactionMeans(model)
        IM
        
        ### Produce interaction plot
        plot(IM)
        
        ### Return the graphics device to its default 1-plot-per-window state
        par(mfrow=c(1,1))
        

        
#Excersize 5
        
        #1
        Data<-ChickWeight             
        #Weight versus age of chicks on different diets
       
        
        #2
        #Mixed effects model
        
        
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
        
        Cand.models[[1]] <- lme(weight ~ Diet + Time + Diet:Time, random = ~1|Chick, data=Data, method="ML")
        Cand.models[[2]] <- lme(weight ~ Diet + Time + Diet:Time, random = ~Time|Chick, data=Data, method="ML")
        Cand.models[[3]] <- lme(weight ~ Diet + Time + Diet:Time, random = ~1|Chick, correlation = corCompSymm(form = ~ Time | Chick), data=Data, method="ML")
        Cand.models[[4]] <- lme(weight ~ Diet + Time + Diet:Time, random = ~Time|Chick, correlation = corCompSymm(form = ~ Time | Chick), data=Data, method="ML")
        Cand.models[[5]] <- lme(weight ~ Diet + Time + Diet:Time, random = ~1|Chick, correlation = corAR1(form = ~ Time | Chick), data=Data, method="ML")
        # Cand.models[[6]] <- lme(weight ~ Diet + Time + Diet:Time, random = ~1|Chick, correlation = corSymm(form = ~ Time | Chick), data=Data, method="ML")
        
        ##create a vector of names to trace back models in set
        Modnames <- paste("mod", 1:length(Cand.models), sep = " ")
        
        ##generate AICc table
        aictab<-aictab(cand.set = Cand.models, modnames = Modnames, sort = TRUE)
        #which model is the best?
        aictab
        
        #the best is model 5
        model = lme(weight ~ Diet + Time + Diet:Time, random = ~1|Chick, correlation = corAR1(form = ~ Time | Chick), data=Data, method="REML")
        summary(model)
        
        # diagnostics
        
          #random effects check
          model.fixed = gls(weight ~ Diet + Time + Diet*Time, data=Data, method="REML")
          anova(model, model.fixed)
          
          #model significance check
          model.null.2 = gls(weight ~ 1, data = Data)
          nagelkerke(model, model.null.2)
          
          #residuals normality check
          x = residuals(model)
          plotNormalHistogram(x)
          shapiro.test(x)
          
      #3  
        #anova analysis
      
        #3 type is appropriate
        Anova(model, type="III") # (A|B,AB),(B|A,AB), (AB|A,B)
        
        #Interpretation
        #Interaction Diet:Time - difference in time trends for weights for different Diet
        #Linear trend in weights for base Diet (Diet 1)
        #Different weights for Diets at Time 1
        
        
      #4  
        #plot 
        Sum = groupwiseMean(weight ~ Diet + Time, data   = Data,  conf   = 0.95, digits = 3,   traditional = FALSE,    percentile  = TRUE)
        Sum
        
        pd = position_dodge(.2)
        
        ggplot(Sum, aes(x =    Time, y =Mean, color = Diet)) +
          geom_errorbar(aes(ymin=Percentile.lower,  ymax=Percentile.upper), width=.2, size=0.7, position=pd) +
          geom_point(shape=15, size=4, position=pd) +
          theme_bw() +
          theme(axis.title = element_text(face = "bold")) +
          ylab("Mean salaries per work type")
        
      #5  
        #post-hoc analysis
        
        lsmeans(model,  pairwise ~ Diet:Time, at=list(Time=c(21)),  adjust="holm")
        
     
  

  
  