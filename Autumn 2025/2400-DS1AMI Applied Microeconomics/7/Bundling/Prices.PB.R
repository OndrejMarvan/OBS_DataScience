#' This function creates a sequencees of prices of bundling of goods p.1 and p.2
#' It will be searched to find price that maximizes profits in PB strategy
#'
#' @param pb.min.max Minimum and maximum value of price of bundle [pb.min.max <- c(pb.min, pb.max)]
#' @param step Increment of the sequences
#'
#' @return A sequences of prices of bundle (from pb.min to pb.max by step)
#'
#' @export

Prices.PB  <- function(pb.min.max, step) {

  pb.min     <- pb.min.max[1]     # min price of bundle
  pb.max     <- pb.min.max[2]     # max price of bundle

  out1 <- seq(pb.min,pb.max,by = step)

  return(p.b = out1)}
