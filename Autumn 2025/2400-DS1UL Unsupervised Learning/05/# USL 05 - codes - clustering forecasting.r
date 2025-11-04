# upload the flexclust library
install.packages("flexclust")
library("flexclust")

# load the built-in dataset
# a simple artificial regression example with 4 clusters, all of them having a Gaussian distribution
data("Nclus")

# seed values initialize randomization
# create a data frame
# take a subsample
set.seed(1)
dat <- as.data.frame(Nclus)
ind <- sample(nrow(dat), 50)

# refer to the train data
dat[["train"]] <- TRUE
dat[["train"]][ind] <- FALSE

# perform clustering
# kcca class objects necessary: kernel canonical correlation analysis
cl1 = kcca(dat[dat[["train"]]==TRUE, 1:2], k=4, kccaFamily("kmeans"))
cl1 

# do the prediction
pred_train <- predict(cl1)
pred_test <- predict(cl1, newdata=dat[dat[["train"]]==FALSE, 1:2])

# visualize the output
image(cl1)
points(dat[dat[["train"]]==TRUE, 1:2], col=pred_train, pch=19, cex=0.3)
points(dat[dat[["train"]]==FALSE, 1:2], col=pred_test, pch=22, bg="orange")
