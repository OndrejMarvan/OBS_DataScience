#' Demands, Profits, Consumer Surpluses, Cost for Pure Bundling strategy
#' @param r1.r2 N valuations of good 1 and 2  - reserversion prices r1, r2
#' @param price.pb Monopoly price of bundle [price.pb <- c(p.b)]
#' @param c.1  Parameter of production cost of good 1
#' @param c.2  Parameter of production cost of good 1
#' @param alfa Parameter of scale economics alfa = 0 --> CRS, alfa < 0 --> IRS, alfa < 0 --> DRS
#' @param beta Parameter of sope economics  beta = 0 --> neutral, beta > 0 complementary in proiduction, beta < 0 substitution in production
#' @param teta Parameter of complementary and substitution of goods beta = 0 --> neutral, beta > 0 complementary in consumption, beta < 0 substitution in consumption
#' @param FC Fixed Cost of production
#'
#' @return For a given: i. N valuations of r1 ,r2 ii. Monopoly prices p1, p2 iii. Technology
#'  profit  - profit for Pure Bundle strategy
#'  c.s     - Consumer surplus for Pure Componenets strategy
#'  t.c     - cost of production
#'  no.buy  - number of consumers which do not buy any good
#'  buy.b   - number of consumers which buy bundle of good 1 and good 2
#' @examples
#' c.1  <-  0.5   # parametr of cost of y1 (MC1 for beta = 0, alfa = 0)
#' c.2  <-  0.5   # parametr of cost of y2 (MC1 for beta = 0, alfa = 0)
#' beta <-  0     # parametr of scope economics
#' alfa <-  0     # parametr of scale economics
#' teta <-  0     # parametr of degree of contingency
#' FC <- 250      # Fix Costs
#' r1.r2      <- r1.r2.cable  # Valuations of TV and Internet
#' price.mb   <- c(20,40,50)  # monopoly prices of TV, INTERNET and  bundle TV and Internet
#' demand.m.b <- Profit.MB(r1.r2,price.mb, c.1, c.2, alfa, beta, teta, FC)
#' plot(r1.r2, type = "p", col="transparent", xlab="r1", ylab="r2", main = "MB" )
#' points(demand.m.b$no.buy , pch = 8, col  = "gray80" )
#' points(demand.m.b$buy.1 , pch = 19,    col  = "gray50")
#' points(demand.m.b$buy.2 , pch = 18,    col  = "gray50")
#' points(demand.m.b$buy.1.2 , pch = 17,    col  = "gray10")
#' legend("topright", col = c("transparent","gray80","gray50 ", "gray50 ","gray10"),
#' pch=c(1,8,19,18,17), legend=c("", "no buy","buy y1", "buy y2" , "buy bundle"), bty="n")
#' abline(a=demand.m.b$p.b, b= -1, lty = 2)
#' abline(h = demand.m.b$p.1, v = demand.m.b$p.2, lty = 2)
#'
#' @export

Profit.PB <- function(r1.r2, prices.pb, c.1, c.2, alfa, beta, teta, FC)
{
  p.b <- prices.pb

  no.buy <- as.matrix(r1.r2[(1 + teta) * (r1.r2[, 1] + r1.r2[,2]) < p.b &
                              (r1.r2[,1] + ifelse(r1.r2[,2]< 0,r1.r2[,2],0)   < p.b) &
                              (r1.r2[, 2] + ifelse(r1.r2[,1]< 0,r1.r2[,1],0) < p.b),])
  buy.b <- as.matrix(r1.r2[((1 + teta) * (r1.r2[, 1] + r1.r2[,2]) >= p.b) |
                             (r1.r2[,1] + ifelse(r1.r2[,2]< 0,r1.r2[,2],0) >= p.b) |
                             (r1.r2[, 2] + ifelse(r1.r2[,1]< 0,r1.r2[,1],0) >= p.b),])
  n.1 <- dim(buy.b)[1]
  n.2 <- n.1

  t.c <- Cost.Bundle(n.1, n.2, c.1, c.2, alfa, beta, FC)
  profit <- p.b * n.1 - t.c
  c.s <- apply(buy.b, 2, sum)[1] + apply(buy.b, 2, sum)[2]

  output.PB <- list(
    profit = profit,
       c.s = c.s,
       t.c = t.c,
       p.b = p.b,
    no.buy = no.buy,
    buy.b = buy.b )

  return(output.PB)
}
