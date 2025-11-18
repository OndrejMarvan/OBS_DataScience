# dimension reduction
###
###
###

# based on the example by Prof. Katarzyna Kopczewska

# load the data - the description is available on moodle
# it covers prices of some selected products across regions of Poland
price_where<-read.csv("prices_regions.csv", sep=";", dec=".", header=TRUE, fileEncoding = "Latin1") 
summary(price_where)
dim(price_where) # checking the dimensions of the dataset

price_when<-read.csv("prices_months.csv", sep=";", dec=".", header=TRUE, fileEncoding = "Latin1") 
summary(price_when)
dim(price_when) # checking the dimensions of the dataset

price_what<-read.csv("prices_products.csv", sep=";", dec=".", header=TRUE, fileEncoding = "Latin1") 
summary(price_what)
dim(price_what) # checking the dimensions of the dataset

# no labels at data – price_where
region_where<-price_where[,1] # first column
product_where<-price_where[,2] # second column
region_where<-colnames(price_where[3:18]) # first row
price_where<-as.matrix(price_where[,3:18]) # data only

x1<-apply(t(price_where), 2, sd) # in apply 2 is for columns
x2<-which(x1==0)
price_where<-price_where[-x2,]

# no labels at data – price_when
region_when<-price_when[,1] # first column
product_when<-price_when[,2] # second column
months_when<-colnames(price_when[3:14]) # first row
price_when<-as.matrix(price_when[,3:14]) # data only

# no labels at data – price_what
region_what<-price_what[,1] # first column
months_what<-price_what[,2] # second column
product_what<-colnames(price_what[3:68]) # first row
price_what<-as.matrix(price_what[,3:68]) # data only

# are the variables related to each other?

install.packages("corrplot")
library(corrplot) # to plot nice correlations

# analysis for products (in price_what object in columns)
# nominal values
yyy.cor<-cor(price_what, method="pearson") 
print(yyy.cor, digits=2)
corrplot(yyy.cor, order ="alphabet", tl.cex=0.6)

# and standardized values
yyy.n<-data.Normalization(price_what, type="n1",normalization="column")
summary(yyy.n)
yyy.n.cor<-cor(yyy.n, method="pearson") 
corrplot(yyy.n.cor, order ="alphabet", tl.cex=0.6)

# Results: 
# one can see that some of variables are highly correlated - the question is for how much this correlation impacts the MDS results
# rescaling does not matter for correlations (but matters for MDS and PCA)
# in general, too many variables to see any details

# analysis for regions (in price_where object in columns)
yyy.cor<-cor(price_where, method="pearson") # nominal values
print(yyy.cor, digits=2)
corrplot(yyy.cor, order ="alphabet", tl.cex=0.6)

# analysis for months (in price_when object in columns)
yyy.cor<-cor(price_when, method="pearson") # nominal values
print(yyy.cor, digits=2)
corrplot(yyy.cor, order ="alphabet", tl.cex=0.6)

# analysis for months (in price_when object in columns)
install.packages("GGally")
library(GGally)
ggpairs(as.data.frame(price_when))

# For months, it is very visible that from month to month changes are similar, 
# but for more distant months correlations tend to 0

# WE NEED DATA DIMENSION REDUCTION METHOD TO SEE RELATIONS EASIER THAN ON CORRELATION MATRIX

# MDS
# it reveals the dataset structure by plotting the relative distance of units
# we assume n observations with k characteristics 
# one calculates distances between all possible pairs – to get nxn matrix
# then one assumes artificial coordinates (x,y) and calculates the distances
# last step – optimization (relocation) of artificial coordinates (x,y) 
# in order to replicate at best real matrix of distances

# Metric MDS: when ratio of similarity of distance is computable
# non-metric MDS: mainly for ordinal scale (1st, 2nd, 3rd, …, good/bad, agree/disagree)

# stats::cmdscale() # basic function
# labdsv::pco()# a wrapper for the ‘cmdscale’ to enable easy plotting

# dist() takes as objects elements from rows. So we have to make transposition t() of our datasets

# analysis for products
dist.what<-dist(t(price_what)) # as a main input we need distance between units
as.matrix(dist.what)[1:10, 1:10] # let’s see the distance matrix
mds1<-cmdscale(dist.what, k=2) #k - the maximum dimension of the space
summary(mds1)	# we get coordinates of new points 

plot(mds1) # 65 columns reduced to two
plot(mds1, type='n') # plot with labels
text(mds1, labels=product_what, cex=0.6, adj=0.5)

# analysis for periods
dist.when<-dist(t(price_when)) # as a main input we need distance between units
mds2<-cmdscale(dist.when, k=2) #k - the maximum dimension of the space
plot(mds2, type='n') # plot with labels
text(mds2, labels=months_when, cex=0.6, adj=0.5)

# analysis for regions
dist.where<-dist(t(price_where)) # as input we need distance between units
mds3<-cmdscale(dist.where, k=2) #k - the maximum dimension of the space
install.packages("maptools")
library(maptools) # to use pointLabel() which jitters labels if overlapping
plot(mds3, type='n') # plot with labels
pointLabel(mds3, labels=region_where, cex=0.6, adj=0.5)

# For products we see few outliers and big group of similar products
# For months we see a kind of similarity path – consecutive months are similar, but more distant not
# For regions we see huge dissimilarity of Slaskie region

# dealing with outliers

# inspection of the results is usually towards the outliers and similars
plot(mds1) # simple graphics for products (price_what)
abline(v=c(-500, 500), lty=3, col=2) # vertical line
abline(h=c(-200, 200), lty=3, col=2) # horizontal line

head(mds1) # new coordinates in 2D

# looking for outliers
x.out<-which(mds1[,1]>500 | mds1[,1]<(-500)) # arbitrary limits
y.out<-which(mds1[,2]>200 | mds1[,2]<(-200))
x.out
y.out
out.all<-c(x.out, y.out) # merging into single dataset
out.uni<-unique(out.all) # unique observations only
price_what[,out.uni]

# visualization with outliers
plot(mds1) # simple graphics for products (price_what)
abline(v=c(-500, 500), lty=3, col=2) # vertical line
abline(h=c(-200, 200), lty=3, col=2) # horizontal line
points(mds1[out.uni,], pch=21, bg="red", cex=2)
text(mds1[out.uni,]-5, labels=rownames(mds1[out.uni,]))

# …and MDS without outliers
dist.what<-dist(t(price_what)[-out.all,]) # distance between units
mds1<-cmdscale(dist.what, k=2) #k - the maximum dimension of the space
plot(mds1) # simple graphics for products (price_what)
text(mds1, labels=product_what[-out.all], cex=0.6, adj=0.5)

# let’s see the data statistics in groups
full<-1:66 # number of products in dataset price_what
limited<-as.numeric(out.all) # id’s of outliers
mark<-full %in% limited # comparing two vectors, output TRUE / FALSE
aa<-cbind(t(price_what), mark) # integrating into one object
aaa<-apply(t(price_what), 1, mean) # mean in rows

install.packages("psych")
library(psych)

aaaa<-describeBy(aaa, mark) # statistics in groups (on the basis of row means)
aaaa

# Statistics are significantly different in groups of similars and outliers
# MDS works well – clusters properly the multidimensional data

# Advanced functions for MDS - smacof::smacofSym()  
# SMACOF: Stress Majorization of a COmplicated Function
# requires dissimilarities as input (as Euclidean distance)
# when having similarity data (as correlations) one transforms it by sim2diss()

# Exercise: test the differences between similarity and dissimilarity matrix
sim<-cor(price_what)  # similarity matrix [66x66] – it takes columns
dis<-dist(price_what) # dissimilarity matrix [192x192] – it takes rows
dis.t<-dist(t(price_what)) # dissimilarity for transposed matrix [66x66]

sim[1:5, 1:5] # first few obs
as.matrix(dis)[1:5, 1:5] # first few obs

install.packages("smacof")
library(smacof)

dis2<-sim2diss(sim, method=1, to.dist = TRUE) # [14x14]
as.matrix(dis2)[1:5, 1:5] # first few obs

# Mantel test – for similarity of matrices
# H0 - the compared matrices are random, thus they are different 
# H1 - the non-random pattern, interpreted as a similarity of the matrices

install.packages("ape")
library(ape)
# to check if dis matrix and converted sim to dis are the same
mantel.test(as.matrix(sim), as.matrix(dis2)) 

# Are the matrices similar?

# smacof::mds() allows for different measurement scales of data
# option: type=c("ratio", "interval", "ordinal", "mspline")
# also in sim2diss() one can specify it:
# for correlation matrices: “corr”  D = sqrt{1-S} (for similarities S)
# for negative disparities: “neglog” (negative logarithm) D= -\log(S)
# for frequencies: “counts”  -\log((S[i,j]*S[j,i)/(S[i,i]*S[j,j])).
# for integers: “counts”  v-S (for integer value v)

# first exercise: with correlation matrix converted into distance matrix
sim<-cor(price_what)
dis2<-sim2diss(sim, method=1, to.dist=TRUE)
fit.data<-mds(dis2, ndim=2,  type="ratio") # from smacof::
fit.data
summary(fit.data)
plot(fit.data) # simple plot

# plot with impact of observation for stress function
plot(fit.data, pch=21, cex=as.numeric(fit.data$spp), bg="red")

# This approach eliminates the impact of outliers

# second exercise: with non-numeric data included

# we come back to original dataset, which includes labels of regions and months
price_what<-read.csv("prices_products.csv", sep=";", dec=".", header=TRUE) 
summary(price_what)
dim(price_what) # checking the dimensions of the dataset

# we use Gower distance – possible for nominal and ordinal data
install.packages("StatMatch")
library(StatMatch)
dist.gower<-gower.dist(t(price_what))
fit.data<-mds(dist.gower, ndim=2,  type="ratio") # from smacof::
fit.data<-mds(dist.gower, ndim=2) # from smacof::
fit.data
summary(fit.data)

# poor visibility of month and region
plot(fit.data, pch=21, cex=1.5, bg="red")
points(fit.data$conf[1:2,], pch=21, cex=2, bg="yellow")

# better visibility of month and region
plot(fit.data$conf, pch=21, cex=as.numeric(fit.data$spp), bg="red")
points(fit.data$conf[1:2,], pch=21, cex=2, bg="yellow")
pointLabel(fit.data$conf, labels=rownames(fit.data$conf))

# Goodness of fit of MDS

# Assume stress function: weighted sqared difference of distances between dist matrix and optimised location, compared with random or permutated stress
# The formula is general STRESS function
# We need to compare the empirical and theoretical (random) STRESS functions
# We compare it as ratio:
# counter: empirical stress
# nominator: theoretical stress
# ratio empirical / theoretical stress measures the quality

# 0 is the best value (while empirical stress=0)
# Kruskal (1964) gave some stress benchmarks for ordinal MDS: 
# 0.20 = poor, 0.10 = fair, 0.05 = good, 0.025 = excellent, 0.00 = perfect

# random stress function from smacof:: 
stressvec<-randomstress(n=66, ndim=2, nrep=1) 
mean(stressvec)

# empirical stress function (Kruskal’s stress)
fit.data$stress

ratio<- fit.data$stress/ mean(stressvec)
ratio

# Test for MDS quality is rather easy and informative
# When poor fitting obtained – one should change the data selection or the method

# Zooming by procrusters

# MDS is to check the relative location of points (obs) assuming some variables set
# One can run a MDS in two subgroups (e.g. two sets of variabels) and then compare the results
# In this case we classify regions because of different sets of characteristics
# In other words: for 380 regions we have x1 set and x2 set of variables
# We want to run MDS and scale the results to make them comparable
# What to do if scale (axes) differ between results, so that mapping is impossible? – use Procrustes!
# Procrustes operation helps in fitting two results to each other: by rotation, translation and dilation (zoom)
# congruence coefficient - measure of similarity of two sub-group results 

# data once again
price_what<-read.csv("prices_products.csv", sep=";", dec=".", header=TRUE, fileEncoding = "Latin1") 
summary(price_what)
dim(price_what) # checking the dimensions of the dataset
region_what<-price_what[,1] # first column
months_what<-price_what[,2] # second column
product_what<-colnames(price_what[3:68]) # first row
price_what<-as.matrix(price_what[,3:68]) # data only

x1<-price_what[,1:33]
x2<-price_what[,34:66]
dis.x1<-dist(t(x1))
dis.x2<-dist(t(x2))
fit.x1<-mds(dis.x1, ndim=2)
fit.x2<-mds(dis.x2, ndim=2)
plot(fit.x1)
plot(fit.x2)
plot(fit.x1$conf[,1:2]) # getting the MDS coordinates

fit.proc<-Procrustes(fit.x1$conf, fit.x2$conf) 
fit.proc
plot(fit.proc)

# One can easily see that results overlap well
# So those two datasets do not give the stable and robust classification

# Comparison of distance matrices 

# In Procrustes procedure we have three information subsets

# X: Input target configuration	- a kind of benchmark result
# Y: Input testee configuration	- data which are compared with benchmark
# Yhat: Procrustes transformed (fitted) configuration – transformed Y data to fit benchmark data

attributes(fit.proc) # check the inside of result

# Mantel test – for similarity of matrices
# H0 - the compared matrices are random, thus they are different 
# H1 - the non-random pattern, interpreted as a similarity of the matrices

mantel.test(as.matrix(fit.proc$confdistX), as.matrix(fit.proc$confdistY))
mantel.test(as.matrix(fit.proc$confdistX), as.matrix(fit.proc$confdistYhat))
mantel.test(as.matrix(fit.proc$confdistY), as.matrix(fit.proc$confdistYhat))

# On this basis one can conclude if multidimensional scaling on different subsamples is robust and gives the coherent results

# Predictions using MDS

# The goal of machine learning is the ability to efficiently forecast using estimated models
# MDS is about finding coordinates in the new system for new points using the old point model

# example 
# we create new dataset with three separated groups – data have three columns
xa<-matrix(rnorm(3*10, mean=10, sd=3), ncol = 3)
xb<-matrix(rnorm(3*10, mean=30, sd=3), ncol = 3)
xc<-matrix(rnorm(3*10, mean=60, sd=3), ncol = 3)
x<-rbind(xa, xb, xc)

# we run MDS and plot the result
DM<-dist(x) 
MDS<-cmdscale(DM)
plot(MDS)

# we run MDS and plot the result
DM<-dist(x) 
MDS<-cmdscale(DM)
plot(MDS)

# algorithm of prediction
x1<-cbind(1, x) # we add intercept – data have now four columns
B<-solve(t(x1) %*% x1) %*% t(x1) %*% MDS  # we estimate betas with regression
MDS # we check coordinates in MDS
x1 %*% B # we check coordinates from MDS

# generating new points
ya<-matrix(rnorm(3, mean=10, sd=3), ncol = 3)
yb<-matrix(rnorm(3, mean=30, sd=3), ncol = 3)
yc<-matrix(rnorm(3, mean=60, sd=3), ncol = 3)
y<-rbind(ya, yb, yc)
y1<-cbind(1, y) # we add intercept to new data

MDS.new<-y1 %*% B # forecast for new coordinates of new points
points(MDS.new, pch=21, bg="red")
