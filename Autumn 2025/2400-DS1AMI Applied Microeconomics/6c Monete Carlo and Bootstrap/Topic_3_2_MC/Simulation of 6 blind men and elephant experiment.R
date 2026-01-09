###### Start  ##################################################
###### Check, installation and loading of required packages #######
requiredPackages = c( "animation", "scatterplot3d") # list of required packages
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) } 

############################
# Simulation of 6 blind men and elephant experiment. Copy, paste and run in R-CRAN 

n_sample <- 15 # You can change number of students in the class (sample) 

combination_of_digits <- expand.grid(digit_1 = 0:9, digit_2 = 0:9)

e1 <- 0.5 -  combination_of_digits$digit_1/5  # individual error term (e1) for student 
e2 <- 0.5 -  combination_of_digits$digit_2/5  # individual error term (e2) for student

############################
# Analytical solution of system of equations 
# as a function on the measurement error; x1=f(e1,e2) and x2=f(e1,e2).
# Copied form maxima analytical solution – Appendix 5
x1 <- (300*(-e1-0.2))/((e1+0.2)*(-e2-1)+0.24)+160.0/((e1+0.2)*(-e2-1)+0.24)
x2 <- (200*(-e2-1))/((e1+0.2)*(-e2-1)+0.24)+90.0/((e1+0.2)*(-e2-1)+0.24)
data_all <- data.frame(e1,e2,x1,x2)
data_all$x1_sign <- ifelse(data_all$x1>0,"+","-")
data_all$x2_sign <- ifelse(data_all$x2>0,"+","-")

############################
# The distribution of possible outcomes. 
# Drawing 1 presents all possible outcomes for all combinations of digits in student id. 
#  Drawings 2-10 present samples of 9 possible distributions of results in a class with 25 students.
iter <- 9
par(mfrow = c(2, (iter+1)/2))
t1 <- table(paste(data_all$x1_sign,data_all$x2_sign))
barplot(t1/nrow(data_all), col = "seashell3",main="Full sample 100 of 100")
for ( i in 1:iter){
  ind <- sample(1:nrow(data_all),n_sample, replace = TRUE)
  data_sample <- data_all[ind,]
  t1 <- table(paste(data_sample$x1_sign,data_sample$x2_sign))
  barplot(t1/nrow(data_sample), col = "seashell3",main= paste0("sample ", i))
}
title("Policy recomendation for x1 and x2", line = -1, outer = TRUE)

############################
# The results of calculation for full sample – all 100 possible combination of digits. 

par(mfrow = c(1, 1))
for ( i in 1:1){
  ind <- sample(1:nrow(data_all),100, replace = FALSE )
  data_sample <- data_all[ind,]
  spl <- scatterplot3d(data_sample[,c(1,2,3)] , pch = 16, color = "firebrick2", grid=TRUE, box=FALSE, zlab = "x1(red), x2(green)",          
                       xlim = c(-1.5,1),ylim = c(-1.5,1), 
                       zlim = c(-5000,5000), main = "Full sample")
  spl$points3d(data_sample[,c(1,2,4)], pch=16, col = "chartreuse4",ylab = " x1, x2")
}

#####################################
# Animation of possible outcomes – not includes in the paper 
saveHTML( {
  for (t in (1:30)){
    par(mfrow = c(1, 3))
    par(oma=c(3,3,3,3)) 
    par(mar=c(5,4,4,2) + 0.1)
    ind <- sample(1:nrow(data_all),25, replace = TRUE)
    data_sample <- data_all[ind,]
    t1 <- table(paste(data_sample$x1_sign,data_sample$x2_sign))
    barplot(t1/nrow(data_sample), col = "seashell3",main="Policy recomendation for x1 and x2")
    hist(data_sample $x1, prob=TRUE,  col = "firebrick3", main="Outcomes of x1", xlab = NULL ) 
    hist(data_sample $x2, prob=TRUE, col = "chartreuse4", main="Outcomes of x2", xlab = NULL ) 
    title(paste0("Case ",t ), outer = TRUE )
  }}, img.name = "Symulation", imgdir = "Symulation_img", htmlfile = "Symulation_animation.html", 
  autobrowse = TRUE, title = "Animation of possible outcomes")
########## END ###################

