# dimension reduction - all together
###
###
###

# based on the example by Prof. Katarzyna Kopczewska

CIA<-read.csv("#USL 09 CIAdata.csv", header=TRUE, sep=";", dec=",")
dim(CIA)
summary(CIA)

# eliminating columns with names
rownames(CIA)<-CIA[,1]
countries<-CIA[,1]
continents<-CIA[,2]
CIA<-CIA[,c(-1,-2)]

# new re-scaled variables
CIA$AREA.100<-CIA$AREA..SQ.KM./mean(CIA$AREA..SQ.KM., na.rm=TRUE)
CIA$POPUL.100<-CIA$POPULATION/mean(CIA$POPULATION, na.rm=TRUE)
CIA$GDP.PC.PPP.100<-CIA$GDP...PER.CAPITA..PPP./mean(CIA$GDP...PER.CAPITA..PPP., na.rm=TRUE)

names(CIA)

# new names (to eliminate dots)
colnames(CIA)<-c("AREA.sqkm", "POPULATION", "BIRTHS.1000.POPUL", "LIFE.EXP.YEARS",  "ADULT.OBESITY", "GDP.PC.PPP", "UNEMPL.RATE", "ELECTRICITY.CONSUMPTION.KWH", "MOBILE.PHONES", "INTERNET.USERS", "RAILWAYS.KM", "MILITARY.EXP.TO.GDP", "POPUL.DENSITY", "ELECTR.CONS.PC", "MOBILE.PH.PC", "INTERNET.USERS.PC", "RAILWAY.DENSITY", "AREA.100", "POPUL.100", "GDP.PC.PPP.100")

# keeping only scaled variables
CIA<-CIA[,c(-1, -2, -6, -8, -9, -10, -11)]

# imputation to eliminate many missing values
install.packages("mice")
library(mice)
CIA.imput<-mice(CIA)
#CIA.new<-mice(CIA, m=5, maxit=50, method="pmm")
CIA.new<-complete(CIA.imput)
summary(CIA.new)
x<-which(is.na(CIA.new$MOBILE.PH.PC==TRUE))
CIA.new$MOBILE.PH.PC[x]<-0
x<-which(is.na(CIA.new$GDP.PC.PPP.100==TRUE))
CIA.new$GDP.PC.PPP.100[x]<-0
summary(CIA.new)

# k-means
install.packages("factoextra")
library(factoextra)

# for features
#km.f<-eclust(t(CIA), "kmeans", hc_metric="euclidean",k=5) # does not work due to NAs
km.f<-eclust(t(CIA.new), "kmeans", hc_metric="euclidean",k=5)

fviz_cluster(km.f, main="kmeans / Euclidean", ylim=c(-15, 5), xlim=c(-15, 55), labelsize=10, repel=TRUE)
fviz_silhouette(km.f)

# for countries
km.c<-eclust(CIA.new, "kmeans", hc_metric="euclidean",k=8)
fviz_cluster(km.c, main="kmeans / Euclidean")
fviz_silhouette(km.c)

# we select medoids – most middle representants of world’regions
vec<-unique(continents)
meds<-matrix(0, ncol=1, nrow=10)
for(i in 1:10){
vec[i]
x<-which(continents==vec[i])
sub<-CIA.new[x,]
ppam<-eclust(sub, "pam", k=1) # factoextra::
meds[i,1]<-rownames(ppam$medoids)}
meds
rownames(meds)<-vec
conti.rep.PAM<-CIA.new[meds,]
rownames(conti.rep.PAM)<-vec

# we use k-means – artificial parameters of centroid observation of world’ regions
vec<-unique(continents)
meds<-matrix(0, ncol=13, nrow=10)
for(i in 1:10){
vec[i]
x<-which(continents==vec[i])
sub<-CIA.new[x,]
kkm<-eclust(sub, "kmeans", k=1) # factoextra::
meds[i,]<-kkm$centers}
meds
rownames(meds)<-vec
conti.rep.km<-meds

# for countries - representatives
km.c<-eclust(conti.rep.PAM, "kmeans", hc_metric="euclidean",k=5)
fviz_cluster(km.c, main="PAM rep / Euclidean")
fviz_silhouette(km.c)

km.c<-eclust(conti.rep.km, "kmeans", hc_metric="euclidean",k=5)
fviz_cluster(km.c, main="kmeans rep / Euclidean")
fviz_silhouette(km.c)

library(factoextra)
fviz_nbclust(t(CIA.new), FUNcluster=cluster::pam, method="gap_stat")
fviz_nbclust(CIA.new, FUNcluster=cluster::pam, method="gap_stat")

# boxplots in groups
install.packages("flexclust")
library(flexclust)

km1<-kmeans(CIA.new[,], 4) # stats::
groupBWplot(CIA.new[,], km1$cluster, alpha=0.05) #flexclust::

km1<-kmeans(CIA.new[,c(-6, -7)], 4) # stats::
groupBWplot(CIA.new[,c(-6, -7)], km1$cluster, alpha=0.05) #flexclust::

km1<-kmeans(CIA.new[,c(-6, -7, -8, -9)], 4) # stats::
groupBWplot(CIA.new[,c(-6, -7, -8, -9)], km1$cluster, alpha=0.05) #flexclust::

d1<-cclust(CIA.new[,c(-6, -7, -8, -9)], 4, dist="euclidean") #flexclust::
stripes(d1) #flexclust::

install.packages("psych")
library(psych)

km1<-kmeans(CIA.new[,], 4) # stats::
describeBy(CIA.new, km1$cluster) # psych::

# PAM
library(factoextra)

# for features
pam.f<-eclust(t(CIA.new), "pam", k=5) # factoextra::
fviz_cluster(pam.f, main="kmeans / Euclidean", ylim=c(-15, 5), xlim=c(-15, 55), labelsize=10, repel=TRUE)
fviz_silhouette(pam.f)

# for countries
pam.c<-eclust(CIA.new, "pam", k=15) # factoextra::
fviz_cluster(pam.c, main="kmeans/Euclidean")
fviz_silhouette(pam.c)

# MDS
install.packages("maptools")
library(maptools)

# for features
dist.f<-dist(t(CIA.new))
mds.f<-cmdscale(dist.f, k=2) 

# very basic plot
plot(mds.f[,1], mds.f[,2]) 

# fine-tuned plot
plot(jitter(mds.f[,1], amount=500000), jitter(mds.f[,2], amount=3000), xlim=c(-2500000, 5000000), ylim=c(-5000, 25000))
pointLabel(jitter(mds.f[,1], amount=500000), jitter(mds.f[,2], amount=3000), rownames(mds.f), cex=0.8) # smart labeling with maptools::

# for countries
dist.c<-dist(CIA.new)
mds.c<-cmdscale(dist.c, k=2) 

# very basic plot
plot(mds.c[,1], mds.c[,2]) 

# fine-tuned plot
plot(jitter(mds.c[,1], amount=100000), jitter(mds.c[,2], amount=5000), xlim=c(-300000, 3000000), ylim=c(-5000, 25000))
x<-which(mds.c[,1]>1000000 | mds.c[,2]>10000)
pointLabel(jitter(mds.c[x,1], amount=500000), jitter(mds.c[x,2], amount=3000), countries[x], cex=0.8) # smart labeling with maptools::

# for countries
dist.c<-dist(conti.rep.PAM)
mds.c<-cmdscale(dist.c, k=2) 

# very basic plot
plot(mds.c[,1], mds.c[,2]) 

# fine-tuned plot
plot(jitter(mds.c[,1], amount=5), jitter(mds.c[,2], amount=5), xlim=c(-10000, 5000), ylim=c(-200, 200))
pointLabel(jitter(mds.c[,1], amount=5), jitter(mds.c[,2], amount=5), rownames(conti.rep.PAM), cex=0.8) # smart labeling with maptools::

# PCA
library(psych)

# for features
pca.f<-principal(CIA.new, nfactors=4, rotate="varimax")
pca.f
print(loadings(pca.f), digits=3, cutoff=0.4, sort=TRUE)

# hierarchical

# for features
dist.f<-dist(t(CIA.new))
tree.f<-hclust(dist.f, method="complete")
plot(tree.f)

dist.fn<-dist(t(CIA.new[,c(-6, -7)]))
tree.fn<-hclust(dist.f, method="complete")
plot(tree.fn, main="no population and electricity consumption")

dend.f<-hcut(t(CIA.new[,c(-6, -7)]), k=5, stand=FALSE)
dend.f$cluster
fviz_dend(dend.f, rect=TRUE)
fviz_silhouette(dend.f)
fviz_cluster(dend.f)

# for countries / continents

# we select medoids – most middle representants of world’regions
vec<-unique(continents)
meds<-matrix(0, ncol=1, nrow=10)
for(i in 1:10){
vec[i]
x<-which(continents==vec[i])
sub<-CIA.new[x,]
ppam<-eclust(sub, "pam", k=1) # factoextra::
meds[i,1]<-rownames(ppam$medoids)}
meds
rownames(meds)<-vec
conti.rep.PAM<-CIA.new[meds,]
rownames(conti.rep.PAM)<-vec

dist.c<-dist(conti.rep.PAM)
tree.c<-hclust(dist.c, method="complete")
plot(tree.c)

# we use k-means – artificial parameters of centroid observation of world’ regions
vec<-unique(continents)
meds<-matrix(0, ncol=13, nrow=10)
for(i in 1:10){
vec[i]
x<-which(continents==vec[i])
sub<-CIA.new[x,]
kkm<-eclust(sub, "kmeans", k=1) # factoextra::
meds[i,]<-kkm$centers}
meds
rownames(meds)<-vec
conti.rep.km<-meds

dist.c<-dist(conti.rep.km)
tree.c<-hclust(dist.c, method="complete")
plot(tree.c)
fviz_dend(tree.c, k=3, cex=0.5, k_colors=c("#00AFBB","#E7B800","#FC4E07"),
          color_labels_by_k=TRUE, ggtheme=theme_minimal())

#########################################################################
#predictions
#########################################################################

# we have objects as follows: km.f, pam.f, mds.f, pca.f, tree.f
# we have new dataset as follows: originial – CIA.new & new one conti.rep.PAM & conti.rep.km

#prediction in kmeans
library(flexclust)

# for representatives from PAM
km.c<-eclust(CIA.new, "kmeans", hc_metric="euclidean",k=7)
km.c.kcca<-as.kcca(km.c, CIA.new) # conversion to kcca
km.c.p<-predict(km.c.kcca, conti.rep.PAM) # prediction for k-means
km.c.p

# for representatives from k-means
km.c<-eclust(CIA.new, "kmeans", hc_metric="euclidean",k=7)
km.c.kcca<-as.kcca(km.c, CIA.new) # conversion to kcca
km.c.p<-predict(km.c.kcca, conti.rep.km) # prediction for k-means
km.c.p

p1<-fviz_cluster(list(data=CIA.new, cluster=km.c$cluster), stand=F) + ggtitle("train")+ xlim(-3e+06, 1e+05) + ylim(-25000, 10000)
p2<-fviz_cluster(list(data=conti.rep.km, cluster=km.c.p),stand=F) + ggtitle("test")+ xlim(-3e+06, 1e+05) + ylim(-25000, 10000)
gridExtra::grid.arrange(p1, p2, nrow=2)

# prediction in pam
pam.c<-eclust(CIA.new, "pam", k=5) # factoextra::, class "pam", "partition", "eclust"   
pam.c.kcca<-as.kcca(pam.c, CIA.new) # conversion to kcca
pam.c.p<-predict(pam.c.kcca, conti.rep.km) # prediction for PAM
pam.c.p

p1<-fviz_cluster(list(data=CIA.new, cluster=pam.c$clustering), stand=F) + ggtitle("train") + xlim(-3e+06, 1e+05) + ylim(-25000, 10000)
p2<-fviz_cluster(list(data=conti.rep.km, cluster=pam.c.p),stand=F) + ggtitle("test") + xlim(-3e+06, 1e+05) + ylim(-25000, 10000)
gridExtra::grid.arrange(p1, p2, nrow=2)

# prediction in hierarchical tree
# here we run the tree on representatives from PAM, 
# while prediction is for representatives from K-means

library(factoextra)
library(class)

dist.c<-dist(conti.rep.PAM) # distance matrix
dist.c.hc<-hclust(dist.c, method="ward.D2") # dendrogram
fviz_dend(dist.c.hc, k=3, cex=0.5, k_colors=c("#00AFBB","#E7B800","#FC4E07"),
          color_labels_by_k=TRUE, ggtheme=theme_minimal())

groups<-cutree(dist.c.hc, k=3) # clustering vector
table(groups)
knnClust<-knn(train=conti.rep.PAM, test=conti.rep.km, k=1, cl=groups)
knnClust

p1<-fviz_cluster(list(data=conti.rep.PAM, cluster=groups), stand=F) + ggtitle("train")
p2<-fviz_cluster(list(data=conti.rep.km, cluster=knnClust),stand=F) + ggtitle("test")
gridExtra::grid.arrange(p1, p2, nrow=2)

# prediction in PCA
pca.f<-prcomp(CIA.new, center=F, scale=F)
pca.f
pca.f.p<-predict(pca.f, newdata=conti.rep.PAM)
pca.f.p


library(psych)
pca.f<-principal(CIA.new, nfactors=3, rotate="varimax")
pca.f

pca.f.p<-predict.psych(pca.f, conti.rep.PAM , CIA.new)
pca.f.p
