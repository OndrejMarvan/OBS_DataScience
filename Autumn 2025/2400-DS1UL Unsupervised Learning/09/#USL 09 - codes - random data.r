# playing with random data - MDS
###
###
###

# based on the example by Prof. Katarzyna Kopczewska

# How well data can be retrieved by MDS?

# let’s generate random data for a ring (in 4 quarters separately)
x1<-runif(1000, 0,1)
y1<-runif(1000, 0,1)
x2<-runif(1000, 0,1)
y2<-runif(1000, -1,0)
x3<-runif(1000, -1,0)
y3<-runif(1000, -1,0)
x3<-runif(1000, -1,0)
x4<-runif(1000, -1,0)
y4<-runif(1000, 0,1)
r1<-(x1^2+y1^2)^0.5
r2<-(x2^2+y2^2)^0.5
r3<-(x3^2+y3^2)^0.5
r4<-(x4^2+y4^2)^0.5
p1<-which(r1>0.95 & r1<1.05)
p2<-which(r2>0.95 & r2<1.05)
p3<-which(r3>0.95 & r3<1.05)
p4<-which(r4>0.95 & r4<1.05)
v1<-cbind(x1[p1], y1[p1])
v2<-cbind(x2[p2], y2[p2])
v3<-cbind(x3[p3], y3[p3])
v4<-cbind(x4[p4], y4[p4])

# let’s plot the ring
plot(v1[,1], v1[,2], ylim=c(-1,1), xlim=c(-1,1))
points(v2[,1], v2[,2])
points(v3[,1], v3[,2])
points(v4[,1], v4[,2])
d<-rbind(v1,v2,v3,v4)
plot(d[,1], d[,2], ylim=c(-1,1), xlim=c(-1,1))

# MDS on the data
dist.reg<-dist(d) # as a main input we need distance between units
mds1<-cmdscale(dist.reg, k=2)
summary(mds1)
plot(mds1[,1], mds1[,2]) # retrieved data
points(d, col="red") # empirical data
title(main="Points retrived from distance (black) vs. original points (red)")

# let’s check the impact of distance metric on quality of MDS
plot(d[,1], d[,2], ylim=c(-2,2), xlim=c(-2,2))

dist.reg<-dist(d, method="euclidean") 
mds1<-cmdscale(dist.reg, k=2)
points(mds1[,1], mds1[,2], col="red")

dist.reg<-dist(d, method="manhattan") 
mds2<-cmdscale(dist.reg, k=2)
points(mds2[,1], mds2[,2], col="blue")

dist.reg<-dist(d, method="canberra") 
mds3<-cmdscale(dist.reg, k=2)
points(mds3[,1], mds3[,2], col="green")

dist.reg<-dist(d, method="maximum") 
mds4<-cmdscale(dist.reg, k=2)
points(mds4[,1], mds4[,2], col="yellow")

dist.reg<-dist(d, method="minkowski", p=0.7) 
mds5<-cmdscale(dist.reg, k=2)
points(mds5[,1], mds5[,2], col="pink")

install.packages("StatMatch")
library(StatMatch)
dist.gower<-gower.dist(d) # library(StatMatch)
mds6<-cmdscale(dist.gower, k=2)
points(mds6[,1], mds6[,2], col="darkmagenta")

legend("bottomleft", col=c("black", "red", "blue", "green", "yellow", "pink", "darkmagenta"), c("empirical points", "Euclidean", "manhattan", "canberra", "maximum", "Minkowski p=0.7", "Gower"), pch=21, bty="n")

# let’s generate z value for points (z as value of dot)
z<-as.data.frame(rnorm(dim(d)[1], 10,3))
d<-cbind(d,z)
colnames(d)<-c("x","y","z")
plot(d[,1:2], cex=d$z/2, pch=".", ylim=c(-1.1, 1.1), xlim=c(-1.1, 1.1))

# MDS on the xyz data
dist.reg<-dist(d) # distance but for three variables (x,y,z)
mds1<-cmdscale(dist.reg, k=2)
summary(mds1)

plot(mds1[,1], mds1[,2])
points(d[,1:2], col="red") # empirical data

plot(mds1[,1], mds1[,2], ylim=c(-10, 10), xlim=c(-10, 10)) # retrieved data
points(d[,1:2], col="red") # empirical data

#############################################################################
### TASK ###
#Try to generate (x,y) numbers which build a triangle (any). Add vector of features (z). 
#Check if pattern only can be well retrived with MDS. What it changes when z added?
##############################################################################
