###### Start  ##################################################
###### Check, installation and loading of required packages #######
requiredPackages = c( "readr", "RColorBrewer") # list of required packages
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) } 

#set the working directory
getwd()
setwd("/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1AMI Applied Microeconomics/6c Monete Carlo and Bootstrap/Data codes")


sample_2024 <- read_csv("sample_2024.csv") # load the sample 

par(mfrow=c(2,2)) # four graphs in one window one above the other (par(mfrow=c(2,2)) - next to each other)

#summary of the data 
summary(sample_2024[,1:2])


# the estimation of based on the sample of 350 observations
mnk <- lm(sample_2024$y~sample_2024$x)
mnk
#estimated coefficients
# summary(mnk)$coefficients[,1][1] extraction of coefficient number 
alfa <- round(summary(mnk)$coefficients[,1][1], digits = 0 )  #rounding coefficient
beta <- round(summary(mnk)$coefficients[,1][2], digits = 3 )  
#scatterplot 
plot(sample_2024$x, sample_2024$y, pch=19, 
     main = paste0("Estimation based on sample y(t) = ", alfa," + ",beta,"*x(t)" ))
abline(h=(-20:25)*2000, lty=3) #adding lines in the background (horizontal)
abline(v=(-20:25)*2000, lty=3) #adding lines in the background (vertical)
abline(mnk) #adding trend line from regression

# START the bootsrap procedure

# bootstrap 
# A. discussion of the function sample 
#takes a sample of the specified size from the elements of x using either with or without replacement.
#arguments of the function:
#1) 1:nrow(sample_2024) (350) - a set from which we are drawing elements  
#2) nrow(sample_2024) - number of elements to choose to a new sample
#3) should sampling be with replacement? replace=TRUE yes with replacement 
sample_b_ind_ewa <-sample(1:nrow(sample_2024), nrow(sample_2024), replace=TRUE)
sample_b_ind_ewa # a vector consisting of 350 elements index of each row in sample all 
table(sample_b_ind_ewa)
# B. we need to draw randomly with replacement a set of observations from sample_2024
#1. select randomly with replacement an index rows with function (sample)
#2. then subset sample_2024 to the rows selected by function (sample sample_b_ind)
sample_b_ewa<-sample_2024[sample_b_ind_ewa,] 
# sample_b - choosing row indexes from sample all 
#3. perform regression on sample_b 
#4. store results of a regression to a vector alfa_b and beta_b
# repeat the process 1000 times 

#repeat the process 1000
# input object to the loop epmty vectors before a loop to store obtained results 
#(like an empty page to store results)
sample_b_ind  <-0
alfa_b <- 0
beta_b <- 0
B <- 1000 # Bootsprap iterations
for(i in 1:B){
  sample_b_ind <-sample(1:nrow(sample_2024), nrow(sample_2024), replace=TRUE) #label draw
  sample_b <- sample_2024[sample_b_ind,] 
  mnk_b <- lm(sample_b$y~sample_b$x)
  
  alfa_b[i] <- summary(mnk_b)$coefficients[,1][1]  
  beta_b[i] <- summary(mnk_b)$coefficients[,1][2]  }
# END  
alfa_b 
beta_b 

# distribution of a and b estimates


#histogram for alfa_a
hist(alfa_b, main="Histogram of a", col="aquamarine3", breaks=50, probability=TRUE)
lines(density(alfa_b), lwd=3)
#summary of coefficient alfa_a
summary(alfa_b)
#histogram for alfa_b
hist(beta_b, main="Histogram of b", col="aquamarine3", breaks=50, probability=TRUE)
lines(density(beta_b), lwd=3)
#summary of coefficient alfa_b
summary(beta_b)

############################### function start ###################################
# distribution of a and b as XY plot
#creating a function that will help to make a graph (scatterplot of x and y estimates of 1000 repetitions)
#densCols produces a vector containing colors which encode the local densities at each point in a scatterplot.
plot_colorByDensity = function(x1,x2,
                               ylim=c(min(x2),max(x2)),
                               xlim=c(min(x1),max(x1)),
                               xlab="",ylab="",main="") {
  df <- data.frame(x1,x2)
  x <- densCols(x1,x2, colramp=colorRampPalette(c("black", "white")))
  df$dens <- col2rgb(x)[1,] + 1L
  cols <-  colorRampPalette(c("#000099", "#00FEFF", "#45FE4F","#FCFF00", "#FF9400", "#FF3100"))(256)
  df$col <- cols[df$dens]
  plot(x2~x1, data=df[order(df$dens),], 
       ylim=ylim,xlim=xlim,pch=20,col=col,
       cex=2,xlab=xlab,ylab=ylab,
       main=main)}
############################### function end ###################################
#using the above function on our data
plot_colorByDensity(alfa_b,beta_b,xlab="a",ylab="b",
                    main = paste0("XY plot of bootstrapped estimators \n [mean_a =", round( mean(alfa_b),1), ", mean_b =", round( mean(beta_b),2), "]"))
abline(h=mean(beta_b), v=mean(alfa_b), lwd=2)

