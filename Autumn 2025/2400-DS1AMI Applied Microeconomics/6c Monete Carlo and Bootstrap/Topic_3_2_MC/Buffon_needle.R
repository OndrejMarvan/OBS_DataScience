###### Start  ##################################################
###### Check, installation and loading of required packages #######
requiredPackages = c( "animation") # list of required packages
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) } 

saveHTML({
  ani.options(nmax = 200, interval = 0.1)
  par(mar = c(3, 2.5, 1, 0.2), pch = 20, mgp = c(1.5, 0.5,0))
  buffon.needle(type = "S")}, img.name = "buffon_needle", htmlfile = "buffon_needle.html",
  ani.height = 600, ani.width = 600, outdir = getwd(), title = "Simulation of Buffon's Needle",
  description = c("There are three graphs made in each step: the top-left\none is a simulation of the scenario, the top-right one is to help us\nunderstand the connection between dropping needles and the mathematical\nmethod to estimate pi, and the bottom one is the result for each\ndropping."))


# generating artificial throws to the dartboard

N <- 10000 # Number of throws 
x <- runif (N, 0,1) # random [uniform] x coordinates 
y <- runif (N, 0,1) # random [uniform] y coordinates 
dist <- sqrt (x ^ 2 + y ^ 2) # circle equation
inside <- ifelse (dist <= 1, 1,0) # points inside the circle
prob_inside <- sum(inside)/N # percentage of points inside
pi <- prob_inside * 4 # determination of the PI number

# drawing of points inside the dartboard
plot (x [dist <= 1], y [dist <= 1], xlab = "x", ylab = "y", main = paste ("Monte Carlo simulation N =", N), col = "red" )
points (x [dist> 1], y [dist> 1], col = "gray")
text (0.8,0.9, paste ("Pi approximation =", pi), col = "red")

