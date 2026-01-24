#' Demands, Profits, Consumer Surpluses,for Pure Componenets strategy
#' @param r1.r2 N valuations of good 1 and 2  - reserversion prices r1, r2
#' @param price.pc A vector of monopoly prices of good 1 and 2 [price.pc <- c(p1, p2)]
#' @param c.1  Parameter of production cost of good 1
#' @param c.2  Parameter of production cost of good 1
#' @param alfa Parameter of scale economics alfa = 0 --> CRS, alfa < 0 --> IRS, alfa < 0 --> DRS
#' @param beta Parameter of sope economics  beta = 0 --> neutral, beta > 0 complementary in proiduction, beta < 0 substitution in production
#' @param teta Parameter of complementary and substitution of goods beta = 0 --> neutral, beta > 0 complementary in consumption, beta < 0 substitution in consumption
#' @param FC Fixed Cost of production
#'
#' @return For a given: i. N valuations of r1 ,r2 ii. Monopoly prices p1, p2 iii. Technology
#'  profit  - profit for Pure Componenets strategy
#'  c.s     - Consumer surplus for Pure Componenets strategy
#'  t.c     - cost of production
#'  no.buy  - number of consumers which do not buy any good
#'  buy.1   - number of consumers which buy good 1
#'  buy.2   - number of consumers which buy good 2
#'  buy.1.2 - number of consumers which buy separately good 1 and good 2
#'
#' @examples
#' c.1  <-  0.5   # parametr of cost of y1 (MC1 for beta = 0, alfa = 0)
#' c.2  <-  0.5   # parametr of cost of y2 (MC1 for beta = 0, alfa = 0)
#' beta <-  0     # parametr of scope economics
#' alfa <-  0     # parametr of scale economics
#' teta <-  0     # parametr of degree of contingency
#' FC <- 250      # Fix Costs
#' r1.r2 <- r1.r2.cable    # Valuations of TV and Internet
#' price.pc   <- c(20, 30) # Monopoly price of TV and Internet
#' demand.p.c <- Profit.PC(r1.r2,price.pc,c.1, c.2, alfa, beta, teta, FC)
#' plot(r1.r2, type = "p", col="transparent", xlab="r1 TV", ylab="r2 INTERNET", main = " PC")
#' points(demand.p.c$no.buy, pch = 8, col = "gray80")
#' points(demand.p.c$buy.1, pch = 17, col = "gray50 ")
#' points(demand.p.c$buy.2, pch = 19, col = "gray50")
#' points(demand.p.c$buy.1.2, pch = 18, col = "gray10")
#' legend("topright", col = c("transparent","gray80","gray50 ", "gray50 ","gray10"),
#' pch=c(1,8,17,19,18), legend=c("", "no buy","buy y1", "buy y2" , "buy y1&y2"), bty="n")
#' abline(h = demand.p.c$p.2, v = demand.p.c$p.1, lty = 2)
#'
#' @export


Profit.PC<- function(r1.r2,price.pc,c.1,c.2,alfa,beta,teta,FC){


  p.1<- price.pc[1]
  p.2<- price.pc[2]

  no.buy <- as.matrix(r1.r2[(r1.r2[,1] <  p.1) & (r1.r2[,2] <  p.2) &
                              (1+teta)*(r1.r2[,1]+r1.r2[,2])<(p.1 + p.2),])

  buy.1  <- as.matrix(r1.r2[((r1.r2[,1] >= p.1) & ((r1.r2[,1] - p.1) >= (r1.r2[,2] - p.2))) &!
                              ((1+teta)*(r1.r2[,1]+r1.r2[,2])>=(p.1+ p.2) &
                                 (1+teta)*(r1.r2[,1]+r1.r2[,2])-(p.1+ p.2) >= (r1.r2[,1] - p.1) &
                                 (1+teta)*(r1.r2[,1]+r1.r2[,2])-(p.1+ p.2) >= (r1.r2[,2] - p.2)),])


  buy.2  <- as.matrix(r1.r2[(r1.r2[,2]>p.2) & ((r1.r2[,2] - p.2) >= (r1.r2[,1] - p.1)) &!
                              ((1+teta)*(r1.r2[,1]+r1.r2[,2])>=(p.1+ p.2) &
                                 (1+teta)*(r1.r2[,1]+r1.r2[,2])-(p.1+ p.2) >= (r1.r2[,1] - p.1) &
                                 (1+teta)*(r1.r2[,1]+r1.r2[,2])-(p.1+ p.2) >= (r1.r2[,2] - p.2)),])


  buy.1.2 <- as.matrix(r1.r2[
    ((1+teta)*(r1.r2[,1]+r1.r2[,2])   >= ( p.1 + p.2)) &
      ((1+teta)*(r1.r2[,1]+r1.r2[,2]) - (p.1 + p.2)) >= (r1.r2[,1] - p.1) &
      ((1+teta)*(r1.r2[,1]+r1.r2[,2]) - (p.1 + p.2)) >= (r1.r2[,2] - p.2) ,])

  n.1   <-  dim(buy.1)[1]
  n.2   <-  dim(buy.2)[1]
  n.1.2 <-  dim(buy.1.2)[1]

  t.c <- Cost.Bundle((n.1 + n.1.2 ),(n.2 + n.1.2),c.1,c.2,alfa,beta,FC)
  profit <- p.1*(n.1 + n.1.2) + p.2*(n.2+ n.1.2) - t.c
  c.s <- ifelse(n.1==0, 0, apply(buy.1, 2, sum)[1]) +
         ifelse(n.2==0, 0, apply(buy.2, 2, sum)[2]) +
         ifelse(n.1.2==0, 0, apply(buy.1.2, 2, sum)[1]) +
         ifelse(n.1.2==0, 0, apply(buy.1.2, 2, sum)[2])

    output.PC <-
    list(   profit = profit,
            c.s    =  c.s,  ################
            t.c    =  t.c,
            p.1    =  p.1,
            p.2    =  p.2,
         no.buy    = no.buy,
         buy.1     = buy.1,
         buy.2     = buy.2,
         buy.1.2   = buy.1.2)

return(output.PC)
}


