
# Comparison of R optimization function and MC simulation (minimum of the function)
funkcja0 <-function(x) (sin(18*x*log(x))/x  ) # declaration of the function

a <- 1 # lower limit
b <- 2 # uper limit

# R function optimize
start_time <- Sys.time()
opt<-optimize(funkcja0, interval=c(a, b), maximum = FALSE) # R function 
end_time <- Sys.time()
print(paste("Code execution time",end_time - start_time))
opt # print the resuklts 

# MC symulation
start_time <- Sys.time()
x <- runif(10000,a,b) # drawing numbers from the uniform distribution, x~unif[1,100] 
y <- funkcja0(x) # calculating function values for x's
i <- which(y == min(y)) # finding the minimum value of y and determining its location and value of x 
end_time <- Sys.time()
print(paste("Code execution time",end_time - start_time))
print( paste("y min   = ",y[i], "for x  = ",x[i]), )

# how to graph the function
curve(funkcja0, a, b, lwd=2)
abline(h = opt$objective, v = opt$minimum,  lty=3, col ="red", lwd = 3 )
abline(h = y[i], v = x[i],  lty=2, col ="green",lwd = 3)
