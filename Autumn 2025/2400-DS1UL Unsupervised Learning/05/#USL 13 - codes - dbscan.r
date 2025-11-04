# dbscan
###
###
###

# why sometimes kmeans is not enough?
install.packages("factoextra")
library(factoextra)
data("multishapes")
df <- multishapes[, 1:2]
set.seed(123)
km.res <- kmeans(df, 5, nstart = 25)
fviz_cluster(km.res, df, frame = FALSE, geom = "point")

# try dbscan
install.packages("fpc")
install.packages("dbscan")

# Load the data 
# Make sure that the package factoextra is installed
data("multishapes", package = "factoextra")
df <- multishapes[, 1:2]

library("fpc")
library("dbscan")
# Compute DBSCAN using fpc package
set.seed(123)
db <- fpc::dbscan(df, eps = 0.15, MinPts = 5)
# Plot DBSCAN results
plot(db, df, main = "DBSCAN", frame = FALSE)

library("factoextra")
fviz_cluster(db, df, stand = FALSE, frame = FALSE, geom = "point")

# Print DBSCAN
print(db)

# Cluster membership. Noise/outlier observations are coded as 0
# A random subset is shown
db$cluster[sample(1:1089, 50)]

# what is the optimal eps value?
dbscan::kNNdistplot(df, k =  5)
abline(h = 0.15, lty = 2)

# clusters predictions using dbscan
# The function predict.dbscan(object, data, newdata) [in fpc package] can be used to predict the clusters for the points in newdata. For more details, read the documentation (?predict.dbscan).

# example on the iris dataset
# https://archive.ics.uci.edu/ml/datasets/iris
# Load the data
data("iris")
iris <- as.matrix(iris[, 1:4])

dbscan::kNNdistplot(iris, k =  4)
abline(h = 0.4, lty = 2)

set.seed(123)
# fpc package
res.fpc <- fpc::dbscan(iris, eps = 0.4, MinPts = 4)
# dbscan package
res.db <- dbscan::dbscan(iris, 0.4, 4)

fviz_cluster(res.fpc, iris, geom = "point")

hullplot(iris, res.fpc, solid=TRUE, alpha=0.7)
