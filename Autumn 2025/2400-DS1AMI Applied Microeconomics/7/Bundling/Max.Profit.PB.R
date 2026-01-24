#' Find maximum profit for Pure Bundling strategy
#'
#' @param r1.r2 NX2 reservation prices of two goods []
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

Max.Profit.PB  <- function(r1.r2, pb.min.max, c.1, c.2, alfa, beta,teta, FC) {

  numerate <- max(pb.min.max)

  FC  <- FC/numerate
  c.1 <- c.1/numerate
  c.2 <- c.2/numerate
  r1.r2 <- data.frame(r1.r2)/numerate

  pb.min.max <- pb.min.max/numerate
  step <- 0.001
  prices.pb <- Prices.PB(pb.min.max, step)


  output.i <-foreach(i = prices.pb, .combine="rbind",.packages = "bundling", .multicombine=TRUE) %dopar% {
    p.b <- i  # price Pure Bundling
    output <- Profit.PB(r1.r2, p.b, c.1, c.2, alfa, beta, teta, FC)
    list(output$profit,output$c.s,output$t.c,output$p.b )

  }

  output     <- matrix(unlist(output.i), ncol = 4, byrow = FALSE)
  ind.max.profit    <- apply(output, 2, max)[1]
  max.profit <- matrix((output[output[,1] == ind.max.profit]), ncol = 4, byrow = FALSE)
  ind.max.c.s    <- apply(max.profit, 2, max)[2]
  max.profit <- matrix((max.profit[max.profit[,2] == ind.max.c.s]),ncol = 4, byrow = FALSE)

  ndx <- order(abs( 0 - output[,1]))[1:(round(nrow(output)/10, digits = 0))]
  zero.profit <- output[ndx,]
  ind.max.c.s <- apply(zero.profit, 2, max)[2]
  zero.profit <- matrix((zero.profit[zero.profit[,2] == ind.max.c.s]),ncol = 4, byrow = FALSE)

  remove("output")


  output.max.PB   <-
    list(
      max.profit         = max.profit[1,1]*numerate,
      max.profit.c.s     = max.profit[1,2]*numerate,
      max.profit.t.c     = max.profit[1,3]*numerate,
      max.profit.p.b     = max.profit[1,4]*numerate)
  return(output.max.PB)
}
