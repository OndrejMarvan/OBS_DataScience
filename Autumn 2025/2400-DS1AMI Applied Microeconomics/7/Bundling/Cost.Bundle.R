#' Find cost F
#'
#' @param n.1 - number of units of good 1
#' @param n.2 - number of units of good 2
#' @param c.1 good 1 parameter of production cost
#' @param c.2 good 1 parameter of production cost
#' @param alfa parameter of scale economics alfa = 0 --> CRS, alfa < 0 --> IRS, alfa < 0 --> DRS
#' @param beta parameter of sope economics  beta = 0 --> neutral, beta > 0 complementary, beta < 0 substitution
#' @param teta parameter of complementary and substitution of goods beta = 0 --> neutral, beta > 0 complementary, beta < 0 substitution
#' @param FC fixed Cost of production
#'
#' @return The TC cost function:
#'
#' @export


Cost.Bundle  <- function(n.1,n.2,c.1,c.2,alfa,beta,FC){

  cost <- ifelse(n.1==n.2, ((1-beta)*(c.1*n.1+c.2*n.2))^(1- alfa),
          ifelse(n.1 > n.2, (c.1*(n.1-n.2) + (1-beta)*(c.1*n.2 + c.2*n.2))^(1- alfa),
                                   (c.2*(n.2-n.1) + (1-beta)*(c.1*n.1 + c.2*n.1))^(1- alfa))) + FC

  return(cost) }
