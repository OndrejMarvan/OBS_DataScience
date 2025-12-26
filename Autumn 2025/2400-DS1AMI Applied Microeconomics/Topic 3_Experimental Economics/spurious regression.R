# function to generating a autoregressive processes:
# y (i) = a +  b * y (i-1) + e (i) ~ N [0,1]
# t - length of the series
# a - constant for a =! 0 drift
# b - autoregressive parameter  for b = 1 generate Random Walk

##### input function to memery ##########
########## start ################
ar1_ts <- function(t,a,b){ 
  x  <-  matrix(0, nrow = t, ncol = 1)   # creating empty matrix (vector [t X 1]) to input data   
  x[1,1]  <- a                          # entering a as the first value of series
  for(i in 2:t){                         # begining of the loop
    x[i,]  <- a + b*x[i-1,] +  rnorm(1)} 	
  return(x)} # returning a result as a vector. If there are more than one results, use the return( list (o1, o2, 03, ...)) 
            #https://www.datacamp.com/community/tutorials/functions-in-r-a-tutorial 

########## end ################



############ - you can run the code between # start # and # end # several times #########
########## start ################

ts_l <- 70
time <- 1:ts_l # time trend --> vector [ts_l X 1] 

a <- 0
b1<- 0.94
b2<- 0.97

x <- ar1_ts(t = ts_l,a = a, b = b1) # function call - parameters specified by sequence and (=) assignment
y <- ar1_ts(ts_l,a,b2) # function call -  only by sequence

max_axis <- max(x,y) #graphs parametres  --> axis  
min_axis <- min(x,y) 

# regresions 
mnk_m_1 <- lm(y~x)  # caling lienrar regresion OLS --> y_t = b0 + b1*x_t + e_t and creating the object mnk_m_1 containing regression results --> see environment
mnk_m_2 <- lm(x~y + time)
mnk_m_3 <- lm(x~y)

summary(mnk_m_1) # calling results of the OLS summary(object)
summary(mnk_m_2)
summary(mnk_m_3)

### graphs

par(mfrow = c(1, 3)) # creating panel of graphs [1X3]
### graph 1
plot(time,x, type = "l", lty=2, col = "red", xlab ="TIME", ylab ="series", ylim = c(min_axis,max_axis), main =" trend line of x") ## pol
abline(lm(x~time), col = "red2") 


### graph 2
plot(time,y, type = "l", col = "green", lty=3, xlab ="TIME", ylab ="series", ylim = c(min_axis,max_axis), main ="trend line of y") ## pol
abline(lm(y~time), col = "green3")

### graph 3
plot(time,x, type = "l",  lty=2,col = "red", xlab ="TIME", ylab ="series", ylim = c(min_axis,max_axis), main ="x and y") ## pol
lines(time,y, type = "l", lty=3, col = "green")

########## end ################

############ How to extract ols parameters --> select one by one and run  ###########
summary(mnk_m_1)$coefficients
summary(mnk_m_1)$coefficients[,4]
summary(mnk_m_1)$coefficients[,4][2] # p-value for b 
############ ###########

############  MC symulation #####################
########## start ##########################################

iter <- 1000 # number of iterations 

# model 1 
output_1 <- NULL
for(i in 1:iter){                       
  x    <- ar1_ts(ts_l,a=a,b = b1)
  y    <- ar1_ts(ts_l,a=a,b = b2)
  mnk_m <- lm(x~y)
  output_1[i] <- summary(mnk_m)$coefficients[,4][2]}	

# model 2 
output_2 <- NULL
for(i in 1:iter){                      
  x    <- ar1_ts(ts_l,a=a,b = b1)
  y    <- ar1_ts(ts_l,a=a,b = b2)
  time  <- 1:ts_l
  mnk_m <- lm(x~ y + time)
  output_2[i] <- summary(mnk_m)$coefficients[,4][2]  
}	
########## end ##########################################



### Distribution of p-value ##
########## start ##########################################

par(mfrow = c(1, 2)) # creating panel of graphs [1 X 2]
########### graph 1
hist(output_1, main = "p-value distribution of model 1", col = terrain.colors(40, alpha=0.5), ylim = c(0,iter))
abline(v = 0.05, col = "red" ) 
########### graph 2
hist(output_2, main = "p-value didtribution of model 2 ", col = terrain.colors(40, alpha=0.5), ylim = c(0,iter))
abline(v = 0.05, col = "red" ) 
########## end ##########################################


### Distributions of significant and non-significant resultss ##
########## start ##########################################

par(mfrow = c(2, 2)) # creating panel of graphs [2 X 2]

########### graph 1
barplot(c(length(output_1[output_1 < 0.05])/iter , length(output_1[output_1 >=0.05])/iter), 
        main = "Symulation for model 1", 
        names.arg=c("Significant", "No significant"), 
        col = terrain.colors(40, alpha=0.5),
        ylim = c(0,1))
abline(h = 0.05, col = "red" ) 

########### graph 2
barplot(c(0.05, 0.95), main = "Expeected distribution for p-val = 0.05 ", 
        names.arg=c("Significant", "No significant"), 
        col = terrain.colors(40, alpha=0.5),
        ylim = c(0,1))
abline(h = 0.05, col = "red" ) 

########### graph 3
barplot(c(length(output_2[output_2 < 0.05])/iter , length(output_2[output_2 >=0.05])/iter), 
        main = "Symulation for model 2", 
        names.arg=c("Significant", "No significant"), 
        col = terrain.colors(40, alpha=0.5),
        ylim = c(0,1))
abline(h = 0.05, col = "red" ) 

########### graph 4
barplot(c(0.05, 0.95)  ,main = "Expected distribution for p-val = 0.05", 
        names.arg=c("Significant", "No significant"), 
        col = terrain.colors(40, alpha=0.5),
        ylim = c(0,1))
abline(h = 0.05, col = "red" ) 
########## end ##########################################
