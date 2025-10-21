###
### 
### CLARA

# upload the dataset (snsdata.csv) - the same one as for k-means and pam
teens <- read.csv("snsdata.csv")

# inspect the dataset
str(teens)

# focus on age between 13 and 20 only
teens$age <- ifelse(teens$age >= 13 & teens$age < 20, teens$age, NA)
summary(teens$age)

# missing values are still the problem for gender feature
# if you drop them, you limit the dataset significantly
# another way to mitigate this problem would be to treat these cases as a separate category (no gender specified)
teens$female <- ifelse(teens$gender == "F" & !is.na(teens$gender), 1, 0)
teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)

# age has missing values but as it is numeric, there would be no point in creating a separate category for missings
# use imputation instead
# fill in the missing data with a guess as to what the true value is 

# calculate the mean value of age after removing missing values
mean(teens$age, na.rm = TRUE)



# calculate average age for different levels (all four) of graduation year
aggregate(data = teens, age ~ gradyear, mean, na.rm = TRUE)

# modify the dataset
ave_age <- ave(teens$age, teens$gradyear, FUN = function(x) mean(x, na.rm = TRUE))

# impute these means onto the missing values!
teens$age <- ifelse(is.na(teens$age), ave_age, teens$age)

# let's refer to various interests of students for our clustering
interests <- teens[5:40]

# remember to standardize/normalize your data
# to avoid a problem in which some features come to dominate solely 
# because they tend to have larger values than others

# z-score standardization below
interests_z <- as.data.frame(lapply(interests, scale))

# shorter scope - just two variables - age & friends
interests_short <- teens[3:4]
interests_short_z <- as.data.frame(lapply(interests_short, scale))

# narrow down the scope to compute the silhouette width faster (run the broader dataset on your own)
interests_shorter_z <- interests_short_z[1:500,]

# time for clustering
install.packages("factoextra")
install.packages("flexclust")
install.packages("fpc")
install.packages("clustertend")
install.packages("cluster")
install.packages("ClusterR")
library(factoextra)
library(flexclust)
library(fpc)
library(clustertend)
library(cluster)
library(ClusterR)

# try out with 3 clusters
clara_flex<-eclust(interests_shorter_z, "clara", k=3) 
summary(clara_flex)
fviz_cluster(clara_flex)
fviz_silhouette(clara_flex)

# another approach - 3 clusters and 6 samples specified - play with samplesize
clara_clust<-clara(interests_shorter_z, 3, metric="euclidean", stand=FALSE, samples=6,
           sampsize=50, trace=0, medoids.x=TRUE,
           rngR=FALSE, pamLike=FALSE, correct.d=TRUE)
class(clara_clust)
clara_clust

# plot the output
fviz_cluster(clara_clust, geom="point", ellipse.type="norm") 
fviz_cluster(clara_clust, palette=c("#00AFBB", "#FC4E07", "#E7B800"), ellipse.type="t", geom="point", pointsize=1, ggtheme=theme_classic())
fviz_silhouette(clara_clust)
