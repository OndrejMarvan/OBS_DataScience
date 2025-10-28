###
### 
### Clustering quality

# upload the dataset (snsdata.csv) - the same one as before
teens <- read.csv("snsdata.csv")

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

# narrow down the scope to compute the quality measures faster (run the broader dataset on your own)
interests_shorter_z <- interests_short_z[1:500,]

# install the packages
install.packages("factoextra")
install.packages("flexclust")
install.packages("fpc")
install.packages("clustertend")
install.packages("cluster")
install.packages("ClusterR")
install.packages("tidyverse")
install.packages("dendextend")
library(factoextra)
library(flexclust)
library(fpc)
library(clustertend)
library(cluster)
library(ClusterR)
library(tidyverse)
library(dendextend)

# k-means
cluster_km <- kmeans(interests_shorter_z, 3)
# pam
cluster_pam<-eclust(interests_shorter_z, "pam", k= 3) 
# clara
cluster_clara<-eclust(interests_shorter_z, "clara", k=4) 

# optimal number of clusters
install.packages("NbClust")
library(NbClust)
library(help="NbClust") # only one function in a package

opt1<-NbClust(interests_shorter_z, distance="euclidean", min.nc=2, max.nc=8, method="complete", index="ch")
opt1 # it chooses the best partition
opt1$All.index
opt1$Best.nc
opt1$Best.partition

# optimal number of clusters, another criteria
opt2<-Optimal_Clusters_KMeans(interests_shorter_z, max_clusters=10, plot_clusters = TRUE)
opt2<-Optimal_Clusters_KMeans(interests_shorter_z, max_clusters=10, plot_clusters=TRUE, criterion="silhouette")
opt2<-Optimal_Clusters_KMeans(interests_shorter_z, max_clusters=10, plot_clusters=TRUE, criterion="AIC")

# another approach, decision based on a plot
opt3<-Optimal_Clusters_Medoids(interests_shorter_z, 10, 'euclidean', plot_clusters=TRUE)

# automatic selection, average silhouette width
opt_aut<-pamk(interests_shorter_z, krange=2:10, criterion="asw", usepam=TRUE, scaling=FALSE, alpha=0.001, diss=inherits(interests_shorter_z, "dist"), critout=FALSE) # fpc::pamk()
class(opt_aut)
opt_aut

# announcement and plot
cat("number of clusters estimated by optimum average silhouette width:", opt_aut$nc, "\n")
plot(pam(interests_shorter_z, opt_aut$nc))

# Hopkins stat
hopkins(interests_shorter_z, n=nrow(interests_shorter_z)-1) 

get_clust_tendency(interests_shorter_z, 2, graph=TRUE, gradient=list(low="red", mid="white", high="blue"), seed = 123) # factoextra:: #interpretation as in table

# Plotting the Ordered Dissimilarity Matrix
# 1.Compute the dissimilarity matrix (DM) between the objects in the data set (Euclidean distance or other)
# 2. Reorder the DM to put similar objects close to one another and plot - one gets an ordered dissimilarity matrix (ODM)
# result blue (violet): high distance  high dissimilarity  low similarity 
# result red (pink): low distance  low dissimilarity  high similarity 
# interpretation: clustering tendency is present when blocks of colors are visible
# random data - when ordered data looks like unordered data
di<-dist(interests_shorter_z)
di<-get_dist(interests_shorter_z, method="euclidean")
fviz_dist(di, show_labels = FALSE)+ labs(title="our data") #factoextra::

# one can see the blocks of colors at the figure, what confirms that data are clusterable and clustering is feasible 

# Rand, Jaccard & Fowlkes-Mallows

# let’s check if partitioning in interests is robust
set.per1<-interests_z[,1:3]
set.per2<-interests_z[,7:9]

d1<-cclust(set.per1, 4, dist="euclidean") # flexclust::
d1
d2<-cclust(set.per2, 4, dist="euclidean") # flexclust::
d2

randIndex(d1, d2)  # flexclust::

comPart(d1, d2)

# Calinski-Harabasz & Duda-Hart
km1<-kmeans(interests_shorter_z, 2) # stats::
round(calinhara(interests_shorter_z, km1$cluster),digits=2) #fpc::calinhara()

km2<-kmeans(interests_shorter_z, 3) # stats::
round(calinhara(interests_shorter_z, km2$cluster),digits=2) #fpc::calinhara()

km3<-kmeans(interests_shorter_z,2) 
dudahart2(interests_shorter_z, km3$cluster) #fpc::

# shadow statistics
d1<-cclust(interests_shorter_z, 4, dist="euclidean") #flexclust:: for k-means
shadow(d1) # flexclust::
plot(shadow(d1))

# move to hierarchical clustering now

# use the built-in R data set USArrests, which contains statistics in arrests per 100,000 residents 
# for assault, murder, and rape in each of the 50 US states in 1973 
# it covers also the % the population living in urban areas
df <- USArrests

# remove missing values
df <- na.omit(df)

# standardize the data 
df <- scale(df)

# agglomerative approach
# dissimilarity matrix
d <- dist(df, method = "euclidean")
# complete linkage
cluster_hierarchical <- hclust(d, method = "complete" )

# cut tree into 4 groups
sub_grp_2 <- cutree(cluster_hierarchical, k = 2)

# cut tree into 4 groups
sub_grp_4 <- cutree(cluster_hierarchical, k = 4)

# various measures of clustering quality
c.stat<-cluster.stats(d,sub_grp_2)
c.stat

c.stat2<-cluster.stats(d,sub_grp_4)
c.stat2

#EXTRA compute some inertia
#install.packages("ClustGeo")
#library(ClustGeo)

#diss.mat<-d

#inertia<-matrix(0, nrow=4, ncol=2)
#colnames(inertia)<-c("division to 2 clust.", "division to 4 clust.")
#rownames(inertia)<-c("intra-clust", "total", "percentage", "Q")

#inertia[1,1]<-withindiss(diss.mat, part=sub_grp_2)# intra-cluster
#inertia[2,1]<-inertdiss(diss.mat) # overall
#inertia[3,1]<-inertia[1,1]/ inertia[2,1] # ratio
#inertia[4,1]<-1-inertia[3,1] # Q, inter-cluster

#inertia[1,2]<-withindiss(diss.mat, part=sub_grp_4) # intra-cluster
#inertia[2,2]<-inertdiss(diss.mat) # overall
#inertia[3,2]<-inertia[1,2]/ inertia[2,2] # ratio
#inertia[4,2]<-1-inertia[3,2] # Q, inter-cluster
#options("scipen"=100, "digits"=4)
#inertia
