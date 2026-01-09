# Completely hypothetical situation:
# You are going to buy three tickets for three lotteries every day this year. The lotteries are independent of each other.
# 
# Lottery A
# The ticket for lottery A costs $10.
# The probability of winning 0.22, the value of the prize is $60.
# 
# 
# Lottery B
# You estimate that the minimum value of the prize is $5, the maximum is $20.
# You also estimate that the most likely outcome is around $10.
# This type of probability is modelled by triangle distribution see:  https://learnandteachstatistics.files.wordpress.com/2013/07/notes-on-triangle-distributions.pdf
# The price of the ticket is 10$.
# 
# Lottery C ( you can lose)
# The prize has a normal distribution with mean 12 and standard deviation 20.
# The price of the ticket is 10$.
# 
# 
# 1) What will be the distribution of your daily earnings?
#   Create MC simulation for daily earnings. Number of iteration N = 10000
#   Calculate the mean and standard deviation of the simulated earnings.
#   
#   2) Every day you pay $30 for tickets.
# How would you lay out this amount of money to improve your financial efficiency?  You can buy only the tickets for one lottery or two. 
# (It will be continued at lecture "risk" --> What criteria of the efficiency we can use?
# 
# You can experiment with R.
# I showed you that vectorization is the strength of R
# Looping is a weakness. 
# You can compare times of generating data by vectorization and by a loop. 
#   

# You need packege: triangle 
###### Check, installation and loading of required packages #######
requiredPackages = c("triangle") # list of required packages
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)} 
for(i in requiredPackages){library(i,character.only = TRUE) } 


N <- 100000

# Generationg the values of earnings lotteries
######## SECTION 1 #################
######## Vectorization #################

start <-Sys.time() 
# A  
a.earnings <- ifelse(runif(N) < 0.22, (60 - 10), -10) # vectorization of if statement
# B  
b.earnings <- rtriangle(N, a=5, b=20, c=10) - 10
# C
c.earnings <- rnorm(N, mean = 12, sd = 20) - 10
# Your expected profit
all.earnings <-  a.earnings + b.earnings + c.earnings
paste("Time of execution of the procedure =", (Sys.time()- start))

par(mfrow=c(2,2)) # 2 by 2 graph 
hist(a.earnings )
hist(b.earnings)
hist(c.earnings)
hist(all.earnings)
par(mfrow=c(1,1)) 

summary(a.earnings)
sd(a.earnings)
summary(b.earnings)
sd(b.earnings)
summary(c.earnings)
sd(c.earnings)
summary(all.earnings)
sd(all.earnings)

rm(a.earnings,b.earnings,c.earnings,all.earnings) # Remove big data vectors data

######## SECTION 2 #################
######## Loop #################

start <-Sys.time()

a.earnings <- NULL
b.earnings <- NULL
c.earnings <- NULL
all.earnings <- NULL

for(i in 1:N){ 
  # A  
  a.earnings[i] <- ifelse(runif(1) < 0.22, (60 - 10), -10)
  # B  
  b.earnings[i] <- rtriangle(1, a=5, b=20, c=10) - 10
  # C
  c.earnings[i] <- rnorm(1, mean = 12, sd = 20) - 10
  # All
  all.earnings[i] <-  a.earnings[i] + b.earnings[i] + c.earnings[i]
}

paste("Time of execution of the procedure loop =", (Sys.time()- start))
rm(a.earnings,b.earnings,c.earnings,all.earnings) # Remove big data vectors data