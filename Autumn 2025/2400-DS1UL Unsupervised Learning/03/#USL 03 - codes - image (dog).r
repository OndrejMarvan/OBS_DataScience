###
### 
### clustering on images

# libraries
install.packages("jpeg")
library(jpeg)
install.packages('plotrix')
install.packages("rasterImage")
library(rasterImage)

# upload an image
WNE_image<-readJPEG("#USL 03 - dog.jpg")
class(WNE_image) 

# plot the raster image
plot(1, type="n")
rasterImage(WNE_image, 0.6, 0.6, 1.4, 1.4)

# inspect the dimensions of the object - is it a 3d one?
dm1<-dim(WNE_image) 
dm1

# develop a data frame
# get the coordinates of pixels - RGB info in three columns
rgbImage1<-data.frame(x=rep(1:dm1[2], each=dm1[1]),  y=rep(dm1[1]:1, dm1[2]), r.value=as.vector(WNE_image[,,1]),  g.value=as.vector(WNE_image[,,2]), b.value=as.vector(WNE_image[,,3]))
head(rgbImage1)

# more insight regarding the size of the dataset
dim(rgbImage1)

# plot the image in RGB
plot(y~x, data=rgbImage1, main="Faculty of Economic Sciences, UW", col=rgb(rgbImage1[c("r.value", "g.value", "b.value")]), asp=1, pch=".")

# apply CLARA and get Silhouette 
library(cluster)
# empty vector to save results
n1<-c() 
# number of clusters to consider
for (i in 1:10) {
cl<-clara(rgbImage1[, c("r.value", "g.value", "b.value")], i)
# saving silhouette to vector
n1[i]<-cl$silinfo$avg.width
}

plot(n1, type='l', main="Optimal number of clusters", xlab="Number of clusters", ylab="Average silhouette", col="blue")
points(n1, pch=21, bg="navyblue")
abline(h=(1:30)*5/100, lty=3, col="grey50")

# Silhouette information, for 7 clusters
clara<-clara(rgbImage1[,3:5], 7) 
plot(silhouette(clara))

# assign medoids (“average” RGB values) to each cluster id and convert RGB into colour
colours<-rgb(clara$medoids[clara$clustering, ])

# plot pixels in the new colours
plot(rgbImage1$y~rgbImage1$x, col=colours, pch=".", cex=2, asp=1, main="7 colours")

# how many original colours were on picture?
cols.org<-rgb(rgbImage1[,3:5])
head(cols.org)
length(unique(cols.org))
