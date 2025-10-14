# upload the dataset (snsdata.csv)

# the dataset collected used for clustering analysis contains social networking service (SNS) information 
# of 30000 anonymous U.S. high school students who had SNS profile in 2006
# it contains 30000 observations (rows) each preresents a high school student and 40 features (columns) 
# that provides information for the student

# 40 features includes graduation year, the gender, age and number of friends one has connected throught the SNS 
# for each student, and the remaining 36 columns are word/s terms such as football, shopping, hot, church etc. 
# that describes the student interest and beliefs with value of 1 indicates a belonging to the group, and 0 otherwise

# his can help to group individuals into clusters with similar interest, and provide help for 
# companies’ marketing teams to advertise appropriate products online targeting students 
# with certain interest or belief

# variety of applications in economics and other social sciences

teens <- read.csv("snsdata.csv")

# inspect the dataset
str(teens)

# we have some missing values (e.g. gender feature)

# is this problem substantial?
table(teens$gender, useNA = "ifany")

# 2,724 records (9 percent) have missing gender data
# we also observe a disproportion with f/m ratio in this dataset 

# another feature with missing values is age
summary(teens$age)

# 5,086 records (17 percent) have missing values for age

# minimum and maximum values of age do not look as reliable 

# remember that you shall deal with student with respect to this dataset

# focus on age between 13 and 20 only
teens$age <- ifelse(teens$age >= 13 & teens$age < 20, teens$age, NA)
summary(teens$age)

# missing values are still the problem for gender feature
# if you drop them, you limit the dataset significantly
# another way to mitigate this problem would be to treat these cases as a separate category (no gender specified)

teens$female <- ifelse(teens$gender == "F" & !is.na(teens$gender), 1, 0)

teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)

table(teens$gender, useNA = "ifany")

table(teens$female, useNA = "ifany")

table(teens$no_gender, useNA = "ifany")

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

summary(teens$age)

# let's refer to various interests of students for our clustering
interests <- teens[5:40]

# remember to standardize/normalize your data
# to avoid a problem in which some features come to dominate solely 
# because they tend to have larger values than others

# z-score standardization below
interests_z <- as.data.frame(lapply(interests, scale))

# center scaling the data - another way
# interests_s<-center_scale(interests) # from ClusterR:: to scale or center the data 

###
###
### k-means

install.packages("stats")
library(stats)

# let's try with 5 clusters
teen_clusters <- kmeans(interests_z, 5)

# check sizes of these clusters 
teen_clusters$size

# what are centers of these clusters?
teen_clusters$centers

# check the assignment into clusters
teens$cluster <- teen_clusters$cluster

teens[1:10, c("cluster", "gender", "age", "friends")]

# general characteristics of clusters
aggregate(data = teens, age ~ cluster, mean)

aggregate(data = teens, female ~ cluster, mean)

aggregate(data = teens, friends ~ cluster, mean)

# more info about the output
attributes(teen_clusters)

# more options with other packages
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

# change the number of cluster to 3 and narrow to age and friends variables to make transparent plots
interests_short <- teens[3:4]
interests_short_z <- as.data.frame(lapply(interests_short, scale))
teen_clusters_km3 <- kmeans(interests_short_z, 3)

# simple plots
plot(interests_short_z, col = teen_clusters_km3$cluster, pch=".", cex=3)
points(teen_clusters_km3$centers, col = 1:5, pch = 8, cex=2, lwd=2)

# more elegant plots
fviz_cluster(list(data=interests_short_z, cluster=teen_clusters_km3$cluster), 
             ellipse.type="norm", geom="point", stand=FALSE, palette="jco", ggtheme=theme_classic()) 

# statistics by clustered groups
d1<-cclust(interests_short_z, 3, dist="euclidean") #flexclust::
stripes(d1) #flexclust::

# boxplots
groupBWplot(interests_short_z, teen_clusters_km3$cluster, alpha=0.05) 

# narrow down the scope to compute the silhouette width faster (run the broader dataset on your own)
interests_shorter_z <- interests_short_z[1:500,]

teen_clusters_km4 <- kmeans(interests_shorter_z, 3)

# silhouette plot
sil<-silhouette(teen_clusters_km4$cluster, dist(interests_shorter_z))
fviz_silhouette(sil)

# alternative commands for k-means
k1<- cclust(interests_short_z, k=3, simple=FALSE, save.data=TRUE) #flexclust:: class kcca
k1
plot(k1)
summary(k1)
attributes(k1) # checking the slots of output

# yet another package ready to be used - factoextra::
# you can use the eclust () function from the factoextra :: package
# it allows for clusters using k-means, PAM, CLARA etc. methods 
# using Euclidean, Manhattan, Canberra, Minkowski distance etc.

# optimal number of clusters - elbow
opt<-Optimal_Clusters_KMeans(interests_short_z, max_clusters=10, plot_clusters = TRUE)

# optimal number of clusters - silhouette
opt<-Optimal_Clusters_KMeans(interests_short_z, max_clusters=10, plot_clusters=TRUE, criterion="silhouette")

###
###
### partitioning around medoids

# most of steps from above easy to execute
# play with this part on your own basing on codes from above
c1<-pam(interests_shorter_z,3) #cluster::pam(), works for n<65536
print(c1)

c1$medoids

c1$clustering
head(c1$clustering)

summary(c1)

class(c1)
silhouette(c1)

plot(c1)

# better graphics
fviz_cluster(c1, geom = "point", ellipse.type = "norm") # factoextra:: 
fviz_cluster(c1, geom = "point", ellipse.type = "convex") # factoextra:: 

# another simple method
c2<-eclust(interests_shorter_z, "pam", k= 3) 
fviz_silhouette(c2)
fviz_cluster(c2) 

# play with number or clusters and distance metrics
pam2<-eclust(interests_shorter_z, "pam", k=4, hc_metric="manhattan") 
fviz_silhouette(pam2)
fviz_cluster(pam2) 

# useful function for deciding upon number of clusters - elbow
opt_md<-Optimal_Clusters_Medoids(interests_shorter_z, 10, 'euclidean', plot_clusters=TRUE)

# useful function for deciding upon number of clusters - silhouette
opt_md2<-Optimal_Clusters_Medoids(interests_shorter_z, max_clusters=10, 'euclidean', plot_clusters=TRUE, criterion="silhouette")
