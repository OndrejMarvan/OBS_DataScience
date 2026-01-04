PlayGame <- function(winnings=0, turn=1) {
  if(sample(0:1, 1)) {
    winnings <- winnings + (2^turn)
    turn <- turn + 1
    PlayGame(winnings, turn)
  }
  else {
    winnings
  }
}

RunSimulation <- function(timesToPlay, ticket.price ) {
  results <- rep(NA, timesToPlay)
  results2 <- rep(NA, timesToPlay)
  rollingAvg <- rep(NA, timesToPlay)
  for(i in 1:timesToPlay) {
    results[i] <- PlayGame() - ticket.price
    rollingAvg[i] <- mean(results[1:i])
  }
  par(mfrow = c(2, 1))
  plot(results, type="l", xlab="Trials", ylab="Net income", main = "Net income in trials")
  plot(rollingAvg, type="l", xlab="Number of Trials", ylab="Rolling Average", main="Rolling Average of net income")
  par(mfrow = c(1, 1))
  }

RunSimulation(timesToPlay = 2000, ticket.price = 4 )


