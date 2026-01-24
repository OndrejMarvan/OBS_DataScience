#' Find maximum profit for Pure Bundling strategy
#'
#' @param r1.r2 NX2 reservation prices of two goods []
#' @param p.1.min.max Vector
#' @param p.2.min.max Vector
#' @param pb.min.max Vector
#' @param c.1 good 1 parameter of production cost
#' @param c.2 good 1 parameter of production cost
#' @param alfa parameter of scale economics alfa = 0 --> CRS, alfa < 0 --> IRS, alfa < 0 --> DRS
#' @param beta parameter of sope economics  beta = 0 --> neutral, beta > 0 complementary, beta < 0 substitution
#' @param teta parameter of complementary and substitution of goods beta = 0 --> neutral, beta > 0 complementary, beta < 0 substitution
#' @param FC fixed Cost of production
#'
#' @return max.profit
#'
#' @export



Max.Profit.MB  <- function(r1.r2,p.1.min.max, p.2.min.max, p.b.min.max,c.1,c.2,alfa,beta,teta,FC) {

  numerate <- max(p.1.min.max,p.2.min.max)

  FC  <- FC/numerate
  c.1 <- c.1/numerate
  c.2 <- c.2/numerate
  r1.r2 <- data.frame(r1.r2)/numerate

  p.1.min.max <- p.1.min.max/numerate
  p.2.min.max <- p.2.min.max/numerate
  p.b.min.max <- p.b.min.max/numerate

  ########################

  step <-  0.05
  prices.mb <- Prices.MB(p.1.min.max, p.2.min.max, p.b.min.max, step)

  output.i <-foreach(i = prices.mb[,1], j = prices.mb[,2], k = prices.mb[,3], .combine="rbind",.packages = "bundling", .multicombine=TRUE) %dopar% {

    p.1  <- i
    p.2  <- j
    p.b  <- k
    p.mb <- cbind(p.1,p.2,p.b)
    output <- Profit.MB(r1.r2, p.mb, c.1, c.2, alfa, beta, teta, FC)

    list(output$profit,output$c.s,output$t.c,output$p.1,output$p.2,output$p.b)}

  output     <- matrix(unlist(output.i), ncol = 6, byrow = FALSE)
  ind.max.profit    <- apply(output, 2, max)[1]
  max.profit <- matrix((output[output[,1] == ind.max.profit]), ncol = 6, byrow = FALSE)
  ind.max.c.s    <- apply(max.profit, 2, max)[2]
  max.profit <- matrix((max.profit[max.profit[,2] == ind.max.c.s]),ncol = 6, byrow = FALSE)

  ########################

  step <-  0.01
  p.1.min.max <- c(max.profit[1,4]-0.1,max.profit[1,4]+0.1)
  p.2.min.max <- c(max.profit[1,5]-0.1,max.profit[1,5]+0.1)
  p.b.min.max <- c(max.profit[1,6]-0.1,max.profit[1,6]+0.1)
  prices.mb <- Prices.MB(p.1.min.max, p.2.min.max, p.b.min.max, step)

  output.i <-foreach(i = prices.mb[,1], j = prices.mb[,2], k = prices.mb[,3], .combine="rbind",.packages = "bundling", .multicombine=TRUE) %dopar% {

    p.1  <- i
    p.2  <- j
    p.b  <- k
    p.mb <- cbind(p.1,p.2,p.b)
    output <- Profit.MB(r1.r2, p.mb, c.1, c.2, alfa, beta, teta, FC)

    list(output$profit,output$c.s,output$t.c,output$p.1,output$p.2,output$p.b)}

  output     <- matrix(unlist(output.i), ncol = 6, byrow = FALSE)
  ind.max.profit    <- apply(output, 2, max)[1]
  max.profit <- matrix((output[output[,1] == ind.max.profit]), ncol = 6, byrow = FALSE)
  ind.max.c.s    <- apply(max.profit, 2, max)[2]
  max.profit <- matrix((max.profit[max.profit[,2] == ind.max.c.s]),ncol = 6, byrow = FALSE)

  ########################

  step <-  0.001
  p.1.min.max <- c(max.profit[1,4]-0.01,max.profit[1,4]+0.01)
  p.2.min.max <- c(max.profit[1,5]-0.01,max.profit[1,5]+0.01)
  p.b.min.max <- c(max.profit[1,6]-0.01,max.profit[1,6]+0.01)
  prices.mb <- Prices.MB(p.1.min.max, p.2.min.max, p.b.min.max, step)

  output.i <-foreach(i = prices.mb[,1], j = prices.mb[,2], k = prices.mb[,3], .combine="rbind",.packages = "bundling", .multicombine=TRUE) %dopar% {

    p.1  <- i
    p.2  <- j
    p.b  <- k
    p.mb <- cbind(p.1,p.2,p.b)
    output <- Profit.MB(r1.r2, p.mb, c.1, c.2, alfa, beta, teta, FC)

    list(output$profit,output$c.s,output$t.c,output$p.1,output$p.2,output$p.b)}

  output     <- matrix(unlist(output.i), ncol = 6, byrow = FALSE)
  ind.max.profit    <- apply(output, 2, max)[1]
  max.profit <- matrix((output[output[,1] == ind.max.profit]), ncol = 6, byrow = FALSE)
  ind.max.c.s    <- apply(max.profit, 2, max)[2]
  max.profit <- matrix((max.profit[max.profit[,2] == ind.max.c.s]),ncol = 6, byrow = FALSE)

  remove("output")

  output.max.MB   <-
    list( max.profit         = max.profit[1,1]*numerate,
          max.profit.c.s     = max.profit[1,2]*numerate,
          max.profit.t.c     = max.profit[1,3]*numerate,
          max.profit.p.1     = max.profit[1,4]*numerate,
          max.profit.p.2     = max.profit[1,5]*numerate,
          max.profit.p.b     = max.profit[1,6]*numerate)

  return(output.max.MB)}
