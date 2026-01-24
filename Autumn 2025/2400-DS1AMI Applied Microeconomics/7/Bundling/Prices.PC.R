#' This function creates a vector of combination p.1 and p.2 from sequences of prices p.1 and p.2
#' It will be searched to find prices that maximize profits in PC strategy
#'
#' @param p.1.min.max Minimum and maximum value of price p1 [p.1.min.max <- c(p.1.min, p.1.max)]
#' @param p.2.min.max Minimum and maximum value of price p2 [p.2.min.max <- c(p.2.min, p.2.max)]
#' @param step Increment of the sequences
#'
#' @return A vector of all possible combinations of p.1 and p.2 from sequences of prices:
#' (from p.1.min, p.1.max by step),
#' (from p.2.min, p.2.max by step).
#'
#' @export
Prices.PC  <- function(p1.min.max, p2.min.max, step) {

  p1.min     <- p1.min.max[1]     # min price of good 1
  p1.max     <- p1.min.max[2]     # max price of good 1

  p2.min     <- p1.min.max[1]     # min price of good 2
  p2.max     <- p1.min.max[2]     # max price of good 2

  p1 <-seq(p1.min,p1.max ,by=step)
  p2 <-seq(p2.min,p2.max ,by=step)
  fullp1 <-rep(p1, each  = length(p1))
  fullp2 <-rep(p2, times = length(p2))
  p1.p2  <-cbind(fullp1, fullp2)

  return(p1.p2)}
