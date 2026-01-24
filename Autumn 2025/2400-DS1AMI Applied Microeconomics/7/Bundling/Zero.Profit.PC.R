#' Find maximum profit for Pure componenets strategy
#'
#' @param r1.r2 NX2 reservation prices of two goods []
#' @param p.1.min.max Vector
#' @param p.2.min.max  dfg
#' @param c.1 good 1 parameter of production cost
#' @param c.2 good 1 parameter of production cost
#' @param alfa parameter of scale economics alfa = 0 --> CRS, alfa < 0 --> IRS, alfa < 0 --> DRS
#' @param beta parameter of sope economics  beta = 0 --> neutral, beta > 0 complementary, beta < 0 substitution
#' @param teta parameter of complementary and substitution of goods beta = 0 --> neutral, beta > 0 complementary, beta < 0 substitution
#' @param FC fixed Cost of production
#'
#' @return max profit
#'
#' @export

Zero.Profit.PC  <- function(r1.r2, p.1.min.max, p.2.min.max, c.1, c.2, alfa, beta, teta, FC) {

  numerate <- max(p.1.min.max, p.2.min.max)

  FC    <- FC/numerate
  c.1   <- c.1/numerate
  c.2   <- c.2/numerate
  r1.r2 <- data.frame(r1.r2)/numerate

  p.1.min.max <- p.1.min.max/numerate
  p.2.min.max <- p.2.min.max/numerate

  ####################

  step  <- 0.01
  prices.pc <- Prices.PC(p.1.min.max, p.2.min.max, step)

  output.i <-foreach(i = prices.pc[,1], j = prices.pc[,2],  .combine="rbind", .packages = "bundling",.multicombine=TRUE) %dopar% {
    p.1 <- i
    p.2 <- j
    prices.pc.i <- cbind(p.1, p.2)
    output <- Profit.PC(r1.r2, prices.pc.i, c.1, c.2, alfa, beta, teta, FC)
    list(output$profit,output$c.s,output$t.c,output$p.1,output$p.2)
  }

  output     <- matrix(unlist(output.i), ncol = 5, byrow = FALSE)
  ndx <- order(abs( 0 - output[,1]))[1:(round(nrow(output)/10, digits = 0))]
  zero.profit <- output[ndx,]
  ind.max.c.s <- apply(zero.profit, 2, max)[2]
  zero.profit <- matrix((zero.profit[zero.profit[,2] == ind.max.c.s]),ncol = 5, byrow = FALSE)

  ####################

  step <- 0.005
  p.1.min.max <- c(zero.profit[1,4]-0.1,zero.profit[1,4]+0.1)
  p.2.min.max <- c(zero.profit[1,5]-0.1,zero.profit[1,5]+0.1)
  prices.pc <- Prices.PC(p.1.min.max, p.2.min.max, step)

  output.i <-foreach(i = prices.pc[,1], j = prices.pc[,2],  .combine="rbind", .packages = "bundling",.multicombine=TRUE) %dopar% {
    p.1 <- i
    p.2 <- j
    prices.pc.i <- cbind(p.1, p.2)
    output <- Profit.PC(r1.r2, prices.pc.i, c.1, c.2, alfa, beta, teta, FC)
    list(output$profit,output$c.s,output$t.c,output$p.1,output$p.2)
  }

  output     <- matrix(unlist(output.i), ncol = 5, byrow = FALSE)
  ndx <- order(abs( 0 - output[,1]))[1:(round(nrow(output)/10, digits = 0))]
  zero.profit <- output[ndx,]
  ind.max.c.s <- apply(zero.profit, 2, max)[2]
  zero.profit <- matrix((zero.profit[zero.profit[,2] == ind.max.c.s]),ncol = 5, byrow = FALSE)

  ####################

  remove("output")

  output.Zero.Profit.PC  <- list(
    zero.profit.aprox   = zero.profit[1,1]*numerate,
    zero.profit.c.s     = zero.profit[1,2]*numerate,
    zero.profit.t.c     = zero.profit[1,3]*numerate,
    zero.profit.p.1     = zero.profit[1,4]*numerate,
    zero.profit.p.2     = zero.profit[1,5]*numerate)

return(output.Zero.Profit.PC) }
