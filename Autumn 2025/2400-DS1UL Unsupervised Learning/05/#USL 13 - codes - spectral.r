# spectral clustering
###
###
###

# a step-by-step example by J. Neto
# the goal of spectral clustering is to cluster data that is connected but not necessarily clustered within convex boundaries
install.packages("mlbench")
library(mlbench)

set.seed(111)
obj <- mlbench.spirals(100,1,0.025)
my.data <-  4 * obj$x
plot(my.data)

# Spectral clustering needs a similarity or affinity s(x,y) measure determining how close points x and y are from each other
# Let’s denote the Similarity Matrix, S
# Let’s compute S for this dataset using the gaussian kernel
# We expect that when two points are from different clusters they are far away. But it might also happen that two points from the same cluster are also far away, except that there should be a sequence of points from the same cluster creating a “path” between them

s <- function(x1, x2, alpha=1) {
  exp(- alpha * norm(as.matrix(x1-x2), type="F"))
}

make.similarity <- function(my.data, similarity) {
  N <- nrow(my.data)
  S <- matrix(rep(NA,N^2), ncol=N)
  for(i in 1:N) {
    for(j in 1:N) {
      S[i,j] <- similarity(my.data[i,], my.data[j,])
    }
  }
  S
}

S <- make.similarity(my.data, s)
S[1:8,1:8]

# The next step is to compute an affinity matrix A based on S. A must be made of positive values and be symmetric
# This is usually done by applying a k-nearest neighboor filter to build a representation of a graph connecting just the closest dataset points. 
make.affinity <- function(S, n.neighboors=2) {
  N <- length(S[,1])

  if (n.neighboors >= N) {  # fully connected
    A <- S
  } else {
    A <- matrix(rep(0,N^2), ncol=N)
    for(i in 1:N) { # for each line
      # only connect to those points with larger similarity 
      best.similarities <- sort(S[i,], decreasing=TRUE)[1:n.neighboors]
      for (s in best.similarities) {
        j <- which(S[i,] == s)
        A[i,j] <- S[i,j]
        A[j,i] <- S[i,j] # to make an undirected graph, ie, the matrix becomes symmetric
      }
    }
  }
  A  
}

A <- make.affinity(S, 3)  # use 3 neighboors (includes self)
A[1:8,1:8]

# With this affinity matrix, clustering is replaced by a graph-partition problem, where connected graph components are interpreted as clusters. The graph must be partitioned such that edges connecting different clusters should have low weigths, and edges within the same cluster must have high values. Spectral clustering tries to construct this type of graph.
# There is the need of a degree matrix D where each diagonal value is the degree of the respective vertex and all other positions are zero:

D <- diag(apply(A, 1, sum)) # sum rows
D[1:8,1:8]

# Next we compute the unnormalized graph Laplacian (U=D−A) and/or a normalized version (L).
U <- D - A
round(U[1:12,1:12],1)

# L <- diag(nrow(my.data)) - solve(D) %*% A  # simple Laplacian
# round(L[1:12,1:12],1)

# matrix power operator: computes M^power (M must be diagonalizable)
"%^%" <- function(M, power)
  with(eigen(M), vectors %*% (values^power * solve(vectors)))

# L <- (D %^% (-1/2)) %*% A %*% (D %^% (-1/2))  # normalized Laplacian

# Assuming we want k clusters, the next step is to find the k smallest eigenvectors (ignoring the trivial constant eigenvector).

k   <- 2
evL <- eigen(U, symmetric=TRUE)
Z   <- evL$vectors[,(ncol(evL$vectors)-k+1):ncol(evL$vectors)]

# the ith row of Z defines a transformation for observation xi. Let’s check that they are well-separated:
plot(Z, col=obj$classes, pch=20) # notice that all 50 points, of each cluster, are on top of each other

# in this transformed space it becomes easy for a standard k-means clustering to find the appropriate clusters:
install.packages("stats")
library(stats)
km <- kmeans(Z, centers=k, nstart=5)
plot(my.data, col=km$cluster)

# If we don’t know how much clusters there are, the eigenvalue spectrum has a gap that give us the value of k.
signif(evL$values,2) # eigenvalues are in decreasing order

plot(1:10, rev(evL$values)[1:10], log="y")
abline(v=2.25, col="red", lty=2) # there are just 2 clusters as expected

# all this is already implemented in R
install.packages("kernlab")
library(kernlab)

sc <- specc(my.data, centers=2)
plot(my.data, col=sc, pch=4)            # estimated classes (x)
points(my.data, col=obj$classes, pch=5) # true classes (<>)

# alternatively 
# Spectrum package
# https://cran.r-project.org/web/packages/Spectrum/vignettes/Spectrum_vignette.pdf
