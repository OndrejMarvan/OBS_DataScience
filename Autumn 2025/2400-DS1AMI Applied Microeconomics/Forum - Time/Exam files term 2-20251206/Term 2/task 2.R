###### Check, installation and loading of required packages #######
requiredPackages = c("readr", "animation") # list of required packages
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) } 

N1 <- 2
N2 <- 5
N3 <- 4
N4 <- 9
N5 <- 2

# WTP [Willignees To Pay] for the rent  

WTP <- c(rep(N1, 2), rep(N1*0.5, 1), rep(N1*1.5, 1), 
         rep(N2, 2), rep(N2*0.5, 1), rep(N2*1.5, 1), 
         rep(N3, 2), rep(N3*0.5, 1), rep(N3*1.5, 1),
         rep(N4, 2), rep(N4*0.5, 1), rep(N4*1.5, 1),
         rep(N5, 2), rep(N5*0.5, 1), rep(N5*1.5, 1))
WTA <- c(rep(1, 10), rep(15, 10))


mean(WTP)


demand <- sort(WTP,decreasing = TRUE)
supply <- sort(WTA)
q_d <- seq(1,length(demand),length = length(demand))
q_s <- seq(1,length(supply),length = length(supply))
# Estymation of demand and supply function 
ols_d   <- lm(demand~q_d)
ols_s   <- lm(supply~q_s)
range_x <- c(0, max(length(demand),length(supply)))
range_y <- c(min(demand,supply), max(demand,supply))

# Equilibrium #############################
# Mechanism of based on empirical data #########################


trade_v_d <- NULL
for(t in 1:length(demand)) {
  p_dem <- demand[t]  
  demand_p_dem <- demand[demand >= p_dem] 
  supply_p_dem <- supply[supply <= p_dem] 
  trade_v_d[t] <- min(length(demand_p_dem),length(supply_p_dem))  
}

trade_v_s <- NULL
for(t in 1: length(supply)) {
  
  p_sup <- supply[t]  
  demand_p_sup <- demand[demand >= p_sup] 
  supply_p_sup <- supply[supply <= p_sup] 
  trade_v_s[t] <- min(length(demand_p_sup),length(supply_p_sup))  
  
}

trade_v_d_ind <-  ifelse(trade_v_d == max(trade_v_d) , 1, 0)
trade_v_s_ind <-  ifelse(trade_v_s == max(trade_v_s) , 1, 0)
trade_v_d_ind_2 <-  min(which(cumsum(trade_v_d_ind ) == max(cumsum(trade_v_d_ind ))))
trade_v_s_ind_2 <-  min(which(cumsum(trade_v_s_ind ) == max(cumsum(trade_v_s_ind ))))



p_star <- NULL
p_star <- ifelse(sum(trade_v_d_ind) > sum(trade_v_s_ind) , supply[trade_v_s_ind == max(trade_v_s_ind)] , demand[trade_v_d_ind == max(trade_v_d_ind)] )
# q_star <- ifelse(sum(trade_v_d) > sum(trade_v_s) , 
# length(supply[trade_v_s <= max(trade_v_s)]),
# length(demand[trade_v_d <= max(trade_v_d)]) )
q_star <- ifelse(trade_v_d_ind_2 < trade_v_s_ind_2, 
                 trade_v_d_ind_2,
                trade_v_s_ind_2)


# Mechanism of based on approximation #########################


a <- ols_d$coefficients[1]
b <- ols_d$coefficients[2]
c <- ols_s$coefficients[1]
d <- ols_s$coefficients[2]

q_star_2 <- -(c-a)/(d-b)
p_star_2 <- a-(b*(c-a))/(d-b) 

# Main graphs of equilibrium (empirical and theoretical)

par(mfrow=c(1,1))
title_txt_d <- paste0("Inverse demand p = ", round(a,0), round(b,2), "*q")
plot(range_x , range_y, type='n', ylab="Price", xlab="Quantity", main = title_txt_d )
points(0:(length(demand)-1), demand, type = "s", col= "red4", cex = 2, lwd = 2)
abline(ols_d, col= "red4", lty=2 , lwd = 2)
legend("topright", c("Demand"), col=c("red4"), lwd=c(2),bty = "n")


par(mfrow=c(1,1))
title_txt_d <- paste0("Inverse supply p = ", round(c,0),"+" ,round(d,2), "*q")
plot(range_x , range_y, type='n', ylab="Price", xlab="Quantity", main = title_txt_d )
points(0:(length(supply )-1), supply , type = "s", col= "palegreen4", cex = 2, lwd = 2)
abline(ols_s, col= "palegreen4", lty=2 , lwd = 2)
legend("topleft", c("Supply"), col=c("palegreen4"), lwd=c(2),bty = "n")

par(mfrow=c(1,2))

plot(range_x , range_y, type='n', ylab="Price", xlab="Quantity", main = "Market equlibrium")
points(0:(length(demand)-1), demand, type = "s", col= "red4", cex = 2, lwd = 2)
points(0:(length(supply)-1), supply, type = "s", col= "palegreen4", cex = 2, lwd = 2)
abline(h=p_star, col= "skyblue4",lwd=1, lty=2 )
legend("topright", c("Demand","Supply"), col=c("red4","palegreen4"), lwd=c(2,2),bty = "n")


plot(range_x , range_y, type='n', ylab="Price", xlab="Quantity", main = "Market equlibrium")
legend("topright", c("Demand","Supply"), col=c("red4","palegreen4"),lty= c(2,2), lwd=c(2,2),bty = "n")
abline(ols_s, col= "palegreen4", lty=2 ,lwd = 2 )
abline(ols_d, col= "red4", lty=2 , lwd = 2)
abline(h=p_star_2, col= "skyblue4",lwd=1, lty=2 )


####### 
par(mfrow=c(1,2))
p_fix <- demand[q_star]  

demand_p_fix <- demand[demand >= p_fix] 
supply_p_fix <- supply[supply <= p_fix] 
trade <- min(length(demand_p_fix),length(supply_p_fix))  
demand_p_fix <- demand[1:trade] 
supply_p_fix <- supply[1:trade] 
CS <- sum(demand[1:trade] - rep(p_fix, times = trade ))
PS <- sum(rep(p_fix, times = trade ) - supply[1:trade])
SW <- PS + CS

range_x <- c(0, max(length(demand),length(supply)))
range_y <- c(min(demand,supply), max(demand,supply))
plot(range_x , range_y, type='n', ylab="Price in K PLN", xlab="Quantity", main = "Market Equlibrium")
points(0:(length(demand)-1), demand, type = "s", col= "red4", cex = 2, lwd = 2)
points(0:(length(supply)-1), supply, type = "s", col= "palegreen4", cex = 2, lwd = 2)
legend("topright", c("Demand","Supply"), col=c("red4","palegreen4"), lwd=c(2,2),bty = "n")
abline(h=p_fix, col= "red3")
for(i in 1:length(demand_p_fix)) {
  x.poly <- c(i-1,i,i,i-1)   
  y.poly <- c(rep(demand_p_fix[i],time=2) ,p_fix,p_fix) 
  polygon(x.poly, y.poly, col= "indianred1", border = FALSE) }        
for(i in 1:length(supply_p_fix)) {
  x.poly <- c(i-1,i,i,i-1)   
  y.poly <- c(rep(supply_p_fix[i],time=2) ,p_fix,p_fix) 
  polygon(x.poly, y.poly, col= "palegreen2", border = FALSE) }        


S_vector <- c(CS,PS,SW)

CS_t <- paste( "CS = " ,CS )
PS_t <- paste( "PS = " ,PS )
SW_t <- paste( "SW = " ,SW )
names(S_vector) <- c(CS_t,PS_t,SW_t)

barplot(S_vector,col = c("indianred1", "palegreen2", "cyan4"), main = "Consumer, Producer Surplas and Social Wefare ",  ylim = c(0,100))

