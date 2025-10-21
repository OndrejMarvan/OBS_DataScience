###
### 
### hierarchical clustering

install.packages("tidyverse")
library(tidyverse)  # data manipulation
install.packages("cluster")
library(cluster)    # clustering algorithms
install.packages("factoextra")
library(factoextra) # clustering visualization
install.packages("dendextend")
library(dendextend) # for comparing two dendrograms

# use the built-in R data set USArrests, which contains statistics in arrests per 100,000 residents 
# for assault, murder, and rape in each of the 50 US states in 1973 
# it covers also the % the population living in urban areas

df <- USArrests

# remove missing values
df <- na.omit(df)

# standardize the data 
df <- scale(df)
head(df)

# agglomerative approach

# dissimilarity matrix
d <- dist(df, method = "euclidean")

# complete linkage
hc1 <- hclust(d, method = "complete" )

# dendrogram
plot(hc1, cex = 0.6, hang = -1)

# instead of "complete" you may specify "singe", "average", "centroid", "ward" as the method
# check this out and see how it affects the output

# the same with different function
# agnes
hc2 <- agnes(df, method = "complete")

# agglomerative coefficient
hc2$ac

# it measures the amount of clustering structure found 
# values closer to 1 suggest strong clustering structure

# multiple methods to assess
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

# the coefficient
ac <- function(x) {
  agnes(df, method = x)$ac
}

map_dbl(m, ac)

# dendrogram
hc3 <- agnes(df, method = "ward")
pltree(hc3, cex = 0.6, hang = -1, main = "dendrogram - agnes") 

# divisive hierarchical clustering
hc4 <- diana(df)

# divise coefficient - amount of clustering structure found
hc4$dc

# dendrogram
pltree(hc4, cex = 0.6, hang = -1, main = "dendrogram - diana")

# cutting the tree
# Ward's method
hc5 <- hclust(d, method = "ward.D2" )

# cut tree into 4 groups
sub_grp <- cutree(hc5, k = 4)

# number of members in each cluster
table(sub_grp)

# observations and their groups
USArrests %>%
  mutate(cluster = sub_grp) %>%
  head

# plots with borders
plot(hc5, cex = 0.6)
rect.hclust(hc5, k = 4, border = 2:5)

# more visualization - way like with kmeans or pam
fviz_cluster(list(data = df, cluster = sub_grp))

# cut agnes() tree into 4 groups
hc_a <- agnes(df, method = "ward")
cutree(as.hclust(hc_a), k = 4)

# cut diana() tree into 4 groups
hc_d <- diana(df)
cutree(as.hclust(hc_d), k = 4)

# compare dendrograms by linking the labels
# compute distance matrix
res.dist <- dist(df, method = "euclidean")

# compute 2 hierarchical clusterings
hc1 <- hclust(res.dist, method = "complete")
hc2 <- hclust(res.dist, method = "ward.D2")

# create two dendrograms
dend1 <- as.dendrogram (hc1)
dend2 <- as.dendrogram (hc2)

tanglegram(dend1, dend2)

# optimal number of clusters - elbow
fviz_nbclust(df, FUN = hcut, method = "wss")

# optimal number of clusters - silhouette
fviz_nbclust(df, FUN = hcut, method = "silhouette")

# the gap statistic
# compares the total intracluster variation for different values of k 
# with their expected values under null reference distribution of the data 
gap_stat <- clusGap(df, FUN = hcut, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)
