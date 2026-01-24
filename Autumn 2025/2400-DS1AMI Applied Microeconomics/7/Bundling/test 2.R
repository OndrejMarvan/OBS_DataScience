################ START ############################################
###### Check, installation and loading of required packages #######
requiredPackages = c( "readr", "wesanderson", "flexdashboard","shiny" ) # list of required packages
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) } 


N    <-  20000 # Number of observations 
teta <-  0.0   # Parameter of degree of contingency of valuations (-) substitutes (+) complementary goods
c.1  <-  0 # Parameter of cost of y1 (MC1 for beta = 0, alfa = 0)
c.2  <-  0   # Parameter of cost of y2 (MC2 for beta = 0, alfa = 0)
beta <-  0   # Parameter of scope economics
alfa <-  0   # Parameter of scale economics
FC   <-  0   # Fix Cost

pal_col <- c("Wheat 4","Forest Green","Firebrick", "Turquoise 4"  )

r1.r2 <- matrix(runif(1200, min = 1, max = 30), nrow = 600, ncol = 2)

p.1.max <- max(r1.r2[,1])
p.2.max <- max(r1.r2[,2])
p.b.max <- p.1.max + p.2.max 
p.1.min.max <- c(0,p.1.max)
p.2.min.max <- c(0,p.2.max)
p.b.min.max <- c(0,p.b.max)


par(mfrow=c(1,3))
par(mar=c(4,4,3,1)) 

demand.p.c <- Profit.PC(r1.r2,c(17, 12), c.1, c.2, alfa, beta, teta, FC)

####################### drawing of PC ####################### 
plot(r1.r2, type = "p", col="transparent", xlab="r1", ylab="r2", main = paste(" PC","\nProfit = ", round(demand.p.c$profit, 0) , "p1 = ",round(demand.p.c$p.1,2),"p2 = ", round(demand.p.c$p.2,2)) )
points(demand.p.c$no.buy, pch = 8, col = pal_col[1])
points(demand.p.c$buy.1, pch = 17, col = pal_col[2])
points(demand.p.c$buy.2, pch = 19, col = pal_col[3])
points(demand.p.c$buy.1.2, pch = 18, col = pal_col[4])
legend("bottomright", col = c("transparent",pal_col[1],pal_col[2], pal_col[3],pal_col[4]), pch=c(1,8,17,19,18), legend=c("", "no buy","buy y1", "buy y2" , "buy y1&y2"), bty="n")
abline(h = demand.p.c$p.2, v = demand.p.c$p.1, lty = 2, lwd = 2 , col = "red")


demand.p.b <- Profit.PB(r1.r2,50, c.1, c.2, alfa, beta, teta, FC)
####################### drawing of PB ####################### 
plot(r1.r2, type = "p", col="transparent", xlab="r1", ylab="r2", main = paste(" PB","\nProfit = ", round(demand.p.b$profit, 0) , "p.b = ", round(demand.p.b$p.b,2)) )
points(demand.p.b$no.buy, pch = 8, col = pal_col[1])
points(demand.p.b$buy.b, pch = 17, col = pal_col[4])
legend("bottomright", col = c("transparent",pal_col[1],pal_col[4]), pch=c(1,8,17), legend=c("", "no buy", "buy bundle"), bty="n")
abline(a= demand.p.b$p.b[1], b= -1, lty = 2, lwd = 2 , col = "red")


demand.m.b <- Profit.MB(r1.r2,c(18, 14, 40), c.1, c.2, alfa, beta, teta, FC)
####################### drawing of MB ####################### 
plot(r1.r2, type = "p", col="transparent", xlab="r1", ylab="r2",main =  paste(" MB ","\nProfit = ", round(demand.m.b$profit, 0) , "p1 = ",round(demand.m.b$p.1,2),"p2 = ", round(demand.m.b$p.2,2), "p.b = ", round(demand.m.b$p.b,2)) )
points(demand.m.b$no.buy , pch = 8, col  = pal_col[1] ) 
points(demand.m.b$buy.1 , pch = 19,    col  = pal_col[2]) 
points(demand.m.b$buy.2 , pch = 18,    col  = pal_col[3]) 
points(demand.m.b$buy.1.2 , pch = 17,    col  = pal_col[4]) 
legend("bottomright", col = c("transparent",pal_col[1],pal_col[2], pal_col[3],pal_col[4]), pch=c(1,8,19,18,17), legend=c("", "no buy","buy y1", "buy y2" , "buy bundle"), bty="n")
# abline(a=demand.m.b$p.b, b= -1, lty = 2, lwd = 2 , col = "red")
# abline(v = demand.m.b$p.1, h = demand.m.b$p.2, lty = 2, lwd = 2 , col = "red")

segments(0, demand.m.b$p.2,  
         demand.m.b$p.b-demand.m.b$p.2,demand.m.b$p.2, 
         lty = 2, lwd = 2 , col = "red")
segments(demand.m.b$p.b-demand.m.b$p.2,demand.m.b$p.2,  
         demand.m.b$p.b-demand.m.b$p.2,30, 
         lty = 2, lwd = 2 , col = "red")

segments(demand.m.b$p.1, demand.m.b$p.b-demand.m.b$p.1, 
         30,demand.m.b$p.b-demand.m.b$p.1, 
         lty = 2, lwd = 2 , col = "red")

segments(demand.m.b$p.b-demand.m.b$p.2,demand.m.b$p.2, 
         demand.m.b$p.1, demand.m.b$p.b-demand.m.b$p.1,
         lty = 2, lwd = 2 , col = "red")
segments(demand.m.b$p.1, demand.m.b$p.b-demand.m.b$p.1,
         demand.m.b$p.1, 0,
         lty = 2, lwd = 2 , col = "red")




####################### END of paraller computation ########################
############################################################################
################# END SECTION 1  ##########################################