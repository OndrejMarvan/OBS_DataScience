#' This function creates a vector of combination from sequences of prices p.1, p.2 and pb
#' It will be searched to find prices that maximize profits in MB strategy
#'
#' @param p.1.min.max Minimum and maximum value of price p1 [p.1.min.max <- c(p.1.min, p.1.max)]
#' @param p.2.min.max Minimum and maximum value of price p2 [p.2.min.max <- c(p.2.min, p.2.max)]
#' @param pb.min.max Minimum and maximum value of price of bundle [pb.min.max <- c(pb.min, pb.max)]
#' @param step Increment of the sequences
#'
#' @return A vector of all possible combinations of p.1, p.2 and pb from sequences of prices:
#' (from p.1.min, p.1.max by step),
#' (from p.2.min, p.2.max by step),
#' (from pb.min to pb.max by step).
#'
#' @export

Prices.MB  <- function(p.1.min.max, p.2.min.max, p.b.min.max, step) {

  p.1.min     <- p.1.min.max[1]      # min price of good 1
  p.1.max     <- p.1.min.max[2]      # max price of good 1

  p.2.min     <- p.2.min.max[1]      # min price of good 2
  p.2.max     <- p.2.min.max[2]      # max price of good 2

  p.b.min   <-  p.b.min.max[1]       # min price of bundle
  p.b.max   <-  p.b.min.max[2]       # max price of bundle

  p.1   <-seq(p.1.min,p.1.max, by=step)
  p.2   <-seq(p.2.min,p.2.max, by=step)
  p.b   <-seq(p.b.min,p.b.max, by=step)

  fullp1   <-rep(p.1, each  = length(p.2))# na 2
  fullp2   <-rep(p.2, times = length(p.1)) # 1

  fullpb  <-rep(p.b, each=length(p.1)*length(p.2))

  p1.p2.pb <-cbind(fullp1, fullp2, fullpb)

  return(p1.p2.pb)}
