###### Check, installation and loading of required packages ##########
requiredPackages = c( "copula", "VineCopula", "triangle", "animation") # list of required packages
for(i in requiredPackages){
  for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
  for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) } }

############ Normal copula with uniform[40,80] and triangle[0,100,30] marginal distributions and corelation rho = 0.9
N <- 2000
rho<- 0.9 # correlation coeficient 

copula.r1.r2 <- mvdc(normalCopula(rho, dim = 2), 
                     margins=c("unif","triangle"), 
                     paramMargins=list(list(40,80),list(0,100,30))) 
r1.r2 <- data.frame(rMvdc(N, copula.r1.r2))

# Graph 
par(mfrow=c(2,2))
par(mar=c(2,2,5,0))
hist <- hist(r1.r2[,1], xlab="x", ylab="", xlim = c(0, 100), main="Distribution of X" )
par(mar=c(1,0,2,0))
persp(copula.r1.r2, dMvdc, xlim = c(0, 100), ylim = c(0, 100), ticktype = "simple", xlab="X", ylab="Y", main="H(X,Y)")
par(mar=c(2,2,5,0))
plot(r1.r2, main="Scatterplot", xlab="x", ylab="y", xlim = c(0, 100),ylim = c(0, 100))
hist <- hist(r1.r2[,2], xlab="r2", ylab="", main="Distribution of y" )
par(mfrow=c(1,1))

###################### End of the lecture example ##########################################


###################################################################

# Examples --> run section by section
###################################################################

############# Section 1a ######################################
############ Normal copula with normal and normal marginal distributions
N <- 2000 
rho<- 0.7 # correlation coeficient 
copula.r1.r2 <- mvdc(normalCopula(rho, dim = 2), 
                     margins=c("norm","norm"),
                     paramMargins=list(list(0.2,0.2),list(0.2,0.2))) 
r1.r2 <- data.frame(rMvdc(N, copula.r1.r2))

# Graph 
par(mfrow=c(2,2))
par(mar=c(2,2,5,0))
hist <- hist(r1.r2[,1], xlab="r1", ylab="", main="Distribution of r1" )
par(mar=c(1,0,2,0))
persp(copula.r1.r2, dMvdc, xlim = c(0, 0.4), ylim = c(0, 0.4), ticktype = "simple", xlab="r1", ylab="r1", main="PDF" )
par(mar=c(2,2,5,0))
plot(r1.r2, main="Scatterplot", xlab="r1", ylab="r2")
hist <- hist(r1.r2[,2], xlab="r2", ylab="", main="Distribution of r2" )

############# Section 1b ################################
############ Normal copula with uniform and uniform marginal distributions
N <- 2000 
rho<- 0.3 # correlation coefficient 
copula.r1.r2 <- mvdc(normalCopula(rho, dim = 2), 
                     margins=c("unif","unif"),
                     paramMargins=list(list(0,1),list(0,1))) 
r1.r2 <- data.frame(rMvdc(N, copula.r1.r2))
# Graph 
par(mfrow=c(2,2))
par(mar=c(2,2,5,0))
hist <- hist(r1.r2[,1], xlab="r1", ylab="", main="Distribution of r1" )
par(mar=c(0,0,1,0))
persp(copula.r1.r2, dMvdc, xlim = c(-0.1, 1.1), ylim = c(-0.1, 1.1), ticktype = "simple", xlab="r1", ylab="r1",  main="PDF" )
par(mar=c(2,2,5,0))
plot(r1.r2, main="Scatterplot", xlab="r1", ylab="r2")
hist <- hist(r1.r2[,2], xlab="r2", ylab="", main="Distribution of r2" )
title("Normal copula", outer=TRUE) 
############# END Section 1 ###############################

############# Section 2 ####################################
############# Frank copula with beta marginal distributions 
N <- 5000 
tau <- 2 
copula.r1.r2<-mvdc(frankCopula(tau),
                   margins=c("beta", "beta"),
                   paramMargins=list(list(5,2), list(2,2)))
r1.r2 <- data.frame(rMvdc(N, copula.r1.r2))
# Graph 
par(mfrow=c(2,2))
par(mar=c(2,2,5,0))
hist <- hist(r1.r2[,1], xlab="r1", ylab="", main="Distribution of r1" )
par(mar=c(0,0,1,0))
persp(copula.r1.r2, dMvdc, xlim = c(0, 1), ylim = c(0, 1), ticktype = "simple", xlab="r1", ylab="r1",  main="PDF")
par(mar=c(2,2,5,0))
plot(r1.r2, main="Scatterplot", xlab="r1", ylab="r2")
hist <- hist(r1.r2[,2], xlab="r2", ylab="", main="Distribution of r2" )
title("Frank Copula", outer=TRUE) 
############# End Section 2 ##################################

############# Section 3a ##############################################
############# Gumbel copula (tau = 4 ) with marginal with marginal uniform distributions 
N <- 5000 
tau <- 4  
copula.r1.r2 <- mvdc(gumbelCopula(tau), 
                     margins=c("unif", "unif"),
                     paramMargins=list(list(0,1), list(0,1)))
r1.r2 <- rMvdc(N, copula.r1.r2)
# Graph 
par(mfrow=c(2,2), oma=c(0,0,2,0), mar=c(2,2,5,0))
hist <- hist(r1.r2[,1], xlab="r1", ylab="", main="Distribution of r1" )
par(mar=c(0,0,1,0))
persp(copula.r1.r2, dMvdc, xlim = c(0, 1), ylim = c(0, 1), ticktype = "simple", xlab="r1", ylab="r1",  main="PDF" )
par(mar=c(2,2,5,0))
plot(r1.r2, main="Scatterplot", xlab="r1", ylab="r2")
hist <- hist(r1.r2[,2], xlab="r2", ylab="", main="Distribution of r2" )
title("Gumbel Cipula", outer=TRUE) 

############# Section 3b ##############################################
############# Rotated 90' Gumbel copula (tau = - 4 ) with marginal uniform distributions 
N <- 5000 
tau <- - 4  
copula.r1.r2 <- mvdc(r90GumbelCopula(tau), 
                     margins=c("unif", "unif"),
                     paramMargins=list(list(0,1), list(0,1)))
r1.r2 <- rMvdc(N, copula.r1.r2)
# Graph 
par(mfrow=c(2,2), oma=c(0,0,2,0), mar=c(2,2,5,0))
hist <- hist(r1.r2[,1], xlab="r1", ylab="", main="Distribution of r1" )
par(mar=c(0,0,1,0))
persp(copula.r1.r2, dMvdc, xlim = c(0, 1), ylim = c(0, 1), ticktype = "simple", xlab="r1", ylab="r1",  main="PDF" )
par(mar=c(2,2,5,0))
plot(r1.r2, main="Scatterplot", xlab="r1", ylab="r2")
hist <- hist(r1.r2[,2], xlab="r2", ylab="", main="Distribution of r2" )
title("r90Gumbel", outer=TRUE) 

############# Section 4a ##############################################
############# Clayton copula (tau = 5 ) uniform marginal distributions
N <- 5000 
tau <- 4  
copula.r1.r2 <- mvdc(claytonCopula(5), 
                     margins=c("unif", "unif"),
                     paramMargins=list(list(0,1), list(0,1)))
r1.r2 <- data.frame(rMvdc(N, copula.r1.r2))
# Graph 
par(mfrow=c(2,2))
par(mar=c(2,2,5,0))
hist <- hist(r1.r2[,1], xlab="r1", ylab="", main="Distribution of r1" )
par(mar=c(0,0,1,0))
persp(copula.r1.r2, dMvdc, xlim = c(0, 1), ylim = c(0, 1), ticktype = "simple", xlab="r1", ylab="r1",  main="PDF" )
par(mar=c(2,2,5,0))
plot(r1.r2, main="Scatterplot", xlab="r1", ylab="r2")
hist <- hist(r1.r2[,2], xlab="r2", ylab="", main="Distribution of r2" )
title(" Clayton Copula ", outer=TRUE) 
############# Section 3b ##############################################
############# Rotated 90' Clayton  copula (tau = - 5 ) with marginal uniform distributions 
N <- 5000 
tau <- 4  
copula.r1.r2 <- mvdc(r90ClaytonCopula(-5), 
                     margins=c("unif", "unif"),
                     paramMargins=list(list(0,1), list(0,1)))
r1.r2 <- data.frame(rMvdc(N, copula.r1.r2))
# Graph 
par(mfrow=c(2,2))
par(mar=c(2,2,5,0))
hist <- hist(r1.r2[,1], xlab="r1", ylab="", main="Distribution of r1" )
par(mar=c(0,0,1,0))
persp(copula.r1.r2, dMvdc, xlim = c(0, 1), ylim = c(0, 1), ticktype = "simple", xlab="r1", ylab="r1",  main="PDF" )
par(mar=c(2,2,5,0))
plot(r1.r2, main="Scatterplot", xlab="r1", ylab="r2")
hist <- hist(r1.r2[,2], xlab="r2", ylab="", main="Distribution of r2" )
title("Rotated Clayton Copula ", outer=TRUE)

###  Animation - comparison of beta distributions #################

################################################################### 
# Change the parameters in the selected section and run it
rho <-  - 0.9  # You can change the correlation coefficient rho 
###################################################################
y.factor11 <- c( seq(0.6,1.4, by = 0.2), rep(1.4, 4), seq(1.4,0.6 , by = -0.2), rep(0.6, 8) ) 
y.factor12 <- c( seq(0.6,1.4, by = 0.2), rep(1.4, 4), rep(1.4, 4), rep(1.4,4), seq(1.4,0.6 , by = -0.2)  )  
y.factor21 <- c( rep(0.6, 5), seq(0.7,1.4, by = 0.2),rep(1.4, 4), seq(1.4,0.6 , by = -0.2), rep(0.6,4) )
y.factor22 <- c( rep(0.6, 5), seq(0.7,1.4, by = 0.2), seq(1.4,0.6 , by = -0.2),rep(0.6,8))
y<- cbind(y.factor11,y.factor12,y.factor21,y.factor22)
iter.y <- length(y.factor11)
x <- seq(0.001, 0.999, length=2000)
N <- length(x)
# Loop of animation
saveHTML({
  ani.options(interval = 0.5, nmax = 30)
  for (j in 1:iter.y) {
    
    copula.r1.r2 <- mvdc(normalCopula(rho, dim = 2), 
                         margins=c("beta", "beta"),
                         paramMargins=list(list(y.factor11[j],y.factor12[j]), list(y.factor21[j],y.factor22[j])))
    r1.r2 <- data.frame(rMvdc(N, copula.r1.r2))
    
    # Graph 
    par(mfrow=c(2,2), oma=c(0,0,2,0))
    par(mar=c(2,2,5,0))
    hist <- hist(r1.r2[,1], xlab="r1", ylab="", ylim = c(0,N/3) , main=paste0("r1 beta[",y.factor11[j],",",y.factor12[j],"]") )
    par(mar=c(1,0,2,0))
    persp(copula.r1.r2, dMvdc, xlim = c(0, 1), ylim = c(0, 1), ticktype = "simple", xlab="r1", ylab="r1", main="Copula" )
    par(mar=c(2,2,5,0))
    plot(r1.r2, main="Scatterplot", xlab="r1", ylab="r2")
    hist <- hist(r1.r2[,2], xlab="r2", ylab="", ylim = c(0,N/3),main=paste0("r2 beta[",y.factor21[j],",",y.factor22[j],"]") )
    title(paste("Combination No. = ", j), outer=TRUE) 
  }},htmlfile = "Animation.html", img.name = "beta_no", title = "Animation", description = "Comparison of beta distributions" )




