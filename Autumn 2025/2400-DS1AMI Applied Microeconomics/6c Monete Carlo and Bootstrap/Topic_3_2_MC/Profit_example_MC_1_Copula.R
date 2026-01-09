###### Start  ##################################################
###### Check, installation and loading of required packages #######
requiredPackages = c("copula", "VineCopula", "triangle","triangle") # list of required packages
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) } 

N <- 10000
MC <- 90
FC <- 7000

# You expect that the minimum number of sold units is 100, the maximum 1000 and the most "probable" is to sell 350 units per month --> the distribution of sold units X can be approximated by a triangular distribution 
# a: the minimum value 100,
# c: the peak value (the height of the triangle) 350
# b: the maximum value of 1000. 
# 
# The maximum bid price is 30 PLN greater than starting price and any bid prices from the interval are equally probable. --> the distribution of transaction prices can be approximated by a uniform distribution 
# l: minimum value 90
# u: maximum value 120


# traingle marginal dystribution
a <- 100
b <- 1000
c <- 350

# uniform marginal dystribution
l <- 90
u <- 130

# You expect that the number of sold units is coreated with bid price the corelation is 0.9 but you can chaque diffrent correlations coeficient. 
# generate price and number of sold units using using copula function 

rho <- 0.9  # correlation coeficient 

copula.price.sold <- mvdc(normalCopula(rho, dim = 2), 
                     margins=c("triangle","unif"), 
                     paramMargins=list(list(a,b,c),list(l,u))) 
price.sold <- data.frame(rMvdc(N, copula.price.sold))

x <- price.sold[,1]
p <- price.sold[,2]


# Profit function
profit <-  p*x - FC - MC*x - (0.09*x)*110 

# Graph 1
par(mfrow=c(2,2))
par(mar=c(2,2,5,0))
hist <- hist(p, xlab="x", ylab="", xlim = c(90, 140), main="Distribution of prices" )
par(mar=c(1,0,2,0))
persp(copula.price.sold, dMvdc, xlim = c(100, 1000), ylim = c(90, 130), ticktype = "simple", xlab="p", ylab="x", main="H(p,x)")
par(mar=c(2,2,5,0))
plot(x,p, main="Scatterplot", xlab="x", ylab="p", xlim = c(100, 1000),ylim = c(90, 130))
hist <- hist(x, xlab="x", ylab="", main="Distribution of x" )
par(mfrow=c(1,1))


# Graph 2
VaR <- quantile(profit, 0.05)
VaR

summary(profit)
hist(profit, main= paste0("Distribution of Profits; rho = ", rho ), col="aquamarine3", breaks=50, probability=TRUE)
lines(density(profit), lwd=3)
abline(v = VaR , col ="red")
abline(v = 0, col ="blue")
