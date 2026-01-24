
# Lista plików .R do załadowania
pliki <- list.files(pattern = "\\.R$")

# Załaduj każdy plik
for (plik in pliki) {
  source(plik)
}


requiredPackages = c( "copula", "VineCopula") # list of required packages
for(i in requiredPackages){
  if(!require(i,character.only = TRUE)) install.packages(i)
  library(i,character.only = TRUE) } 
# You will obtain the visualisation of PC, PB and MB optimum strategies 
#
# You can check all possible combination of beta distribution and 
# all parameters of copula function used in the article

# To load of required packages select the Section 0 and run (only once) 
# Change the parameters in the selected section and run it

###### Section 0 ##################################################

###### Check, installation and loading of required packages #######
requiredPackages = c("devtools","foreach", "doParallel","copula",  "VineCopula" ) # list of required packages
for(i in requiredPackages){
  if(!require(i,character.only = TRUE)) install.packages(i)
  library(i,character.only = TRUE) } #


################# SECTION 1  #########################################################
################# Normal copula with beta marginal distributions ####################
################# Parameters of visualisation #########################################
################# You can change it ##################################################

N    <-  20000 # Number of observations 
No. <- 14     # Combinations of beta distributions 
rho <-  0.95    # Corelation of reserwation prices 
teta <-  0.0   # Parameter of degree of contingency of valuations (-) substitutes (+) complementary goods
c.1  <-  0 # Parameter of cost of y1 (MC1 for beta = 0, alfa = 0)
c.2  <-  0   # Parameter of cost of y2 (MC2 for beta = 0, alfa = 0)
beta <-  0   # Parameter of scope economics
alfa <-  0   # Parameter of scale economics
FC   <-  0   # Fix Cost

####################### Start of computation ######################## 

y.factor11 <- c( seq(0.6,1.4, by = 0.2), rep(1.4, 4), seq(1.4,0.6 , by = -0.2), rep(0.6, 8) ) 
y.factor12 <- c( seq(0.6,1.4, by = 0.2), rep(1.4, 4), rep(1.4, 4), rep(1.4,4), seq(1.4,0.6 , by = -0.2)  )  
y.factor21 <- c( rep(0.6, 5), seq(0.7,1.4, by = 0.2),rep(1.4, 4), seq(1.4,0.6 , by = -0.2), rep(0.6,4) )
y.factor22 <- c( rep(0.6, 5), seq(0.7,1.4, by = 0.2), seq(1.4,0.6 , by = -0.2),rep(0.6,8))
y<- cbind(y.factor11,y.factor12,y.factor21,y.factor22)

copula.r1.r2<-mvdc(normalCopula(rho, dim = 2),
                   margins=c("beta", "beta"),
                   paramMargins=list(list(y.factor11[No.], y.factor12[No.]), list(y.factor21[No.], y.factor22[No.])))
r1.r2 <- data.frame(rMvdc(N, copula.r1.r2))

p.1.max <- max(r1.r2[,1])
p.2.max <- max(r1.r2[,2])
p.b.max <- p.1.max + p.2.max 
p.1.min.max <- c(0,p.1.max)
p.2.min.max <- c(0,p.2.max)
p.b.min.max <- c(0,p.b.max)

####################### Start of paraller computation ######################## 

no.cores <- detectCores()
cl<-makeCluster(no.cores)
registerDoParallel(cl)

par(mfrow=c(1,3))
par(mar=c(4,4,3,1)) 
out.p.c <- Max.Profit.PC(r1.r2,p.1.min.max, p.2.min.max,c.1,c.2,alfa,beta,teta,FC)
demand.p.c <- Profit.PC(r1.r2,c(out.p.c$max.profit.p.1, out.p.c$max.profit.p.2), c.1, c.2, alfa, beta, teta, FC)

####################### drawing of PC ####################### 
plot(r1.r2, type = "p", col="transparent", xlab="r1", ylab="r2", main = paste(" PC","\nProfit = ", round(demand.p.c$profit, 0) , "p1 = ",round(demand.p.c$p.1,2),"p2 = ", round(demand.p.c$p.2,2)) )
points(demand.p.c$no.buy, pch = 8, col = "gray80")
points(demand.p.c$buy.1, pch = 17, col = "gray50")
points(demand.p.c$buy.2, pch = 19, col = "gray50")
points(demand.p.c$buy.1.2, pch = 18, col = "gray10")
legend("bottomright", col = c("transparent","gray80","gray50 ", "gray50 ","gray10"), pch=c(1,8,17,19,18), legend=c("", "no buy","buy y1", "buy y2" , "buy y1&y2"), bty="n")
abline(h = demand.p.c$p.2, v = demand.p.c$p.1, lty = 2, lwd = 2 , col = "red")


out.p.b  <- Max.Profit.PB(r1.r2,p.b.min.max,c.1,c.2,alfa,beta,teta,FC) 
demand.p.b <- Profit.PB(r1.r2,out.p.b$max.profit.p.b , c.1, c.2, alfa, beta, teta, FC)
####################### drawing of PB ####################### 
plot(r1.r2, type = "p", col="transparent", xlab="r1", ylab="r2", main = paste(" PB","\nProfit = ", round(demand.p.b$profit, 0) , "p.b = ", round(demand.p.b$p.b,2)) )
points(demand.p.b$no.buy, pch = 8, col = "gray80")
points(demand.p.b$buy.b, pch = 17, col = "gray10")
legend("bottomright", col = c("transparent","gray80","gray10"), pch=c(1,8,17), legend=c("", "no buy", "buy bundle"), bty="n")
abline(a= demand.p.b$p.b[1], b= -1, lty = 2, lwd = 2 , col = "red")


out.m.b <- Max.Profit.MB(r1.r2,p.1.min.max, p.2.min.max, p.b.min.max,c.1,c.2,alfa,beta,teta,FC) 
demand.m.b <- Profit.MB(r1.r2,c(out.m.b$max.profit.p.1, out.m.b$max.profit.p.2, out.m.b$max.profit.p.b), c.1, c.2, alfa, beta, teta, FC)
####################### drawing of MB ####################### 
plot(r1.r2, type = "p", col="transparent", xlab="r1", ylab="r2",main =  paste(" MB ","\nProfit = ", round(demand.m.b$profit, 0) , "p1 = ",round(demand.m.b$p.1,2),"p2 = ", round(demand.m.b$p.2,2), "p.b = ", round(demand.m.b$p.b,2)) )
points(demand.m.b$no.buy , pch = 8, col  = "gray80" ) 
points(demand.m.b$buy.1 , pch = 19,    col  = "gray50") 
points(demand.m.b$buy.2 , pch = 18,    col  = "gray50") 
points(demand.m.b$buy.1.2 , pch = 17,    col  = "gray10") 
legend("bottomright", col = c("transparent","gray80","gray50 ", "gray50 ","gray10"), pch=c(1,8,19,18,17), legend=c("", "no buy","buy y1", "buy y2" , "buy bundle"), bty="n")
abline(a=demand.m.b$p.b, b= -1, lty = 2, lwd = 2 , col = "red")
abline(v = demand.m.b$p.1, h = demand.m.b$p.2, lty = 2, lwd = 2 , col = "red")

segments(3, 0, 7, 0, col = "red", lwd = 2)

####################### END of paraller computation ########################
############################################################################
################# END SECTION 1  ###########################################