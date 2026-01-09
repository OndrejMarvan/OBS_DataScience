  # generating artificial throws to the dartboard
  
  N <- 10000 # Number of throws 
  x <- runif (N, 0,1) # random x coordinates 
  y <- runif (N, 0,1) # random y coordinates 
  dist <- sqrt (x ^ 2 + y ^ 2) # circle equation
  inside <- ifelse (dist <= 1, 1,0) # points inside the circle
  prob_inside <- mean(inside) # percentage of points inside
  pi_a <- prob_inside * 4 # determination of the PI number
  
  # drawing of points inside the dartboard
  par(mfrow=c(1,1)) 
  plot (x [dist <= 1], y [dist <= 1], xlab = "x", ylab = "y", main = paste ("Monte Carlo simulation N =", N), col = "red" )
  points (x [dist> 1], y [dist> 1], col = "gray")
  text (0.8,0.9, paste ("Pi appr.. =", pi_a), col = "red")
  
  ###########################################
  
  # examining on the stability of results
  pi_a  <- 0 # create an empty storage vector to the loop
  variance <- 0 #  create an empty storage vector to the loop 
  
  # loop gradually increasing the number of par
  for (i in 1: 15000) { 
   x <-runif (i, 0,1)
   y <-runif (i, 0,1)
   dist <- sqrt (x ^ 2 + y ^ 2)
   inside <- ifelse (dist <= 1,1,0)
   prob_inside <- mean(inside)
   variance[i] <- var (inside) # variance within the sample
   pi_a[i] <- prob_inside * 4}
  
 # drawing of accuracy of the solution and variance
 par(mfrow=c(2,1)) 
 plot (pi_a, type = "l", ylim = c (2,4), main = "PI's estimates vs. N")
 abline(h = pi, col = "red")
 plot (variance, type = "l", main = "Variance vs. N")
 title(outer=TRUE,main = "Accuracy of the solution and variance", line = -1) 
 