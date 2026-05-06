

T = 300
x = rep(0, times=T)
z = rep(0, times=T)

for(t in 2:T) {
  x[t] = x[t-1]+rnorm(1)
  z[t] = z[t-1]+rnorm(1)-0.2*(-x[t-1]+z[t-1])
}

plot(x, type="l")
lines(z, col="red")