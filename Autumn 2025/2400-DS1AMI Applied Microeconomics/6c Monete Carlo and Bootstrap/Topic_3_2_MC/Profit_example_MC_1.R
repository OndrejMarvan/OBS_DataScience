###### Start  ##################################################
###### Check, installation and loading of required packages #######
requiredPackages = c("triangle") # list of required packages
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) } 

N <- 1000000
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

a <- 100
b <- 1000
c <- 350
x <- rtriangle(N,a,b, c) 
hist(x, main="Simulation of triangle ditribution", col="aquamarine3", breaks=50, probability=TRUE)



l <- 90
u <- 150
p <- runif(N,l,u) 
hist(p, main="Simulation of uniform ditribution", col="aquamarine3", breaks=50, probability=TRUE)


# Profit function
profit <- - FC +  p*x - MC*x - (0.09*x)*110 


VaR <- quantile(profit, 0.05)


hist(profit, main = "Distribution of Profits", col="aquamarine3", breaks=50, probability=TRUE)
lines(density(profit), lwd=3)
abline(v = VaR , col ="red")
abline(v = 0, col ="blue")
