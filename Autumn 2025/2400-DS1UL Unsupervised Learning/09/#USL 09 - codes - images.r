# dimension reduction on images
###
###
###

# based on the example by Prof. Katarzyna Kopczewska

install.packages("jpeg")
install.packages("factoextra")
install.packages("gridExtra")
install.packages("ggplot2")
library(jpeg)
library(factoextra)
library(gridExtra)
library(ggplot2)

#install.packages("magick")
#library(magick)

# importing and plotting colour photo – our faculty
photo<-readJPEG("#USL 09 - wne.jpg")
plot(1, type="n") # plotting the rasterImage – colour photo
rasterImage(photo, 0.6, 0.6, 1.4, 1.4)

# in colour photo one gets three matrices – pixel by pixel 
# each for one component of RGB colour
# easy trick to convert to grey scale is to sum up RGB shades 
# and divide by max value (to scale up to max. 1)

photo.sum<-photo[,,1]+photo[,,2]+photo[,,3] # summing up RGB shades
photo.bw<-photo.sum/max(photo.sum)	# dividing by max
plot(1, type="n")	# plotting the rasterImage – black & white photo
rasterImage(photo.bw, 0.6, 0.6, 1.4, 1.4)
writeJPEG(photo.bw, "photo_bw.jpg")

# PCA for pictures is to run individual PCA on each of R, G & B shades.
# This generates eigenvectors of shades - 
# first eigen vector explains the majority of shade, next vectors less.
# Trick is to integrate new shades into picture. 
# This new value comes from multiplying “x” and “rotation” components of PCA.

# each color scale (R,G,B) gets own matrix and own PCA
r<-photo[,,1] # individual matrix of R colour component
g<-photo[,,2]
b<-photo[,,3]

r.pca<-prcomp(r, center=FALSE, scale.=FALSE) # PCA for R colour component
g.pca<-prcomp(g, center=FALSE, scale.=FALSE)
b.pca<-prcomp(b, center=FALSE, scale.=FALSE)
rgb.pca<-list(r.pca, g.pca, b.pca)	# merging all PCA into one object

# let’s see the importance of PC
library(gridExtra)
f1<-fviz_eig(r.pca, main="Red", barfill="red", ncp=5, addlabels=TRUE)
f2<-fviz_eig(g.pca, main="Green", barfill="green", ncp=5, addlabels=TRUE)
f3<-fviz_eig(b.pca, main="Blue", barfill="blue", ncp=5, addlabels=TRUE)
grid.arrange(f1, f2, f3, ncol=3)

# the loop for different photos
# number of pixels in photo defines the number of principal components (PC)
# In code below we make 9 photos, with min. 3 & max=n PC
# we multiply x * rotation and apply it on existing pixels grid
# finally we save all photos into working directory and as objects

vec<-seq.int(3, round(nrow(photo)), length.out=9)
for(i in vec){
photo.pca<-sapply(rgb.pca, function(j) {
    new.RGB<-j$x[,1:i] %*% t(j$rotation[,1:i])}, simplify="array")
assign(paste("photo_", round(i,0), sep=""), photo.pca) # saving as object
writeJPEG(photo.pca, paste("photo_", round(i,0), "_princ_comp.jpg", sep=""))
}

# https://cran.r-project.org/web/packages/magick/vignettes/intro.html
# run in RStudio

# easy plotting of new photo
# install.packages("magick")
# library(magick)
# plot(image_read(photo_3))

# number of PC
# round(vec,0) 

#collective plotting 9 mages – mechanism of retrieving names of saved files
#par(mfrow=c(3,3)) 
#par(mar=c(1,1,1,1))
#plot(image_read(get(paste("photo_", round(vec[1],0), sep=""))))
#plot(image_read(get(paste("photo_", round(vec[2],0), sep=""))))
#plot(image_read(get(paste("photo_", round(vec[3],0), sep=""))))
#plot(image_read(get(paste("photo_", round(vec[4],0), sep=""))))
#plot(image_read(get(paste("photo_", round(vec[5],0), sep=""))))
#plot(image_read(get(paste("photo_", round(vec[6],0), sep=""))))
#plot(image_read(get(paste("photo_", round(vec[7],0), sep=""))))
#plot(image_read(get(paste("photo_", round(vec[8],0), sep=""))))
#plot(image_read(get(paste("photo_", round(vec[9],0), sep=""))))

# what you would get in RStudio
install.packages("png")
library(png)
photo_magick <- readPNG("magick_output.png")
plot(1, type="n") # plotting the rasterImage – colour photo
rasterImage(photo_magick, 0.6, 0.6, 1.4, 1.4)

# another option of doing the same
#library(abind)
#pp=10 # how many principal components should be included
#photo.pca2<-abind(r.pca$x[,1:pp] %*% t(r.pca$rotation[,1:pp]),
#                  g.pca$x[,1:pp] %*% t(g.pca$rotation[,1:pp]),
#                  b.pca$x[,1:pp] %*% t(b.pca$rotation[,1:pp]),
#                  along=3)
#plot(image_read(photo.pca2))

# let’s check how the size of photo decreases under this PS compression
# file.info() works for files not objects – so one should access files in WD
# paste() with option sep="" is equivalent to paste0() with no options

install.packages("Metrics")
library(Metrics)

sizes<-matrix(0, nrow=9, ncol=4)
colnames(sizes)<-c("Number of PC", "Photo size", "Compression ratio", "MSE-Mean Squared Error")
sizes[,1]<-round(vec,0)
for(i in 1:9) {
path<-paste("photo_", round(vec[i],0), "_princ_comp.jpg", sep="")
sizes[i,2]<-file.info(path)$size 
photo_mse<-readJPEG(path)
sizes[i,4]<-mse(photo, photo_mse) # from Metrics::
}
sizes[,3]<-round(as.numeric(sizes[,2])/as.numeric(sizes[9,2]),3)
sizes

# for a better display of table
install.packages("knitr")
library(knitr)
kable(sizes)

# RStudio
# how to make own palette from image
#install.packages("imgpalr")
#library(imgpalr)

#photo<-readJPEG("wne-building.jpg")
#col1<-image_pal("wne-building.jpg", n=8, type="div", saturation=c(0.75, 1), brightness=c(0.75, 1), plot=TRUE)
#col2<-image_pal("wne-building.jpg", n=11, type="seq", k=2, saturation=c(0.5, 1), brightness=c(0.25, 1), seq_by="hsv", plot=TRUE)
#col3<-image_pal("wne-building.jpg", n=11, type="div", k=2, saturation=c(0.5, 1), brightness=c(0.25, 1), plot=TRUE)
#col4<-image_pal("wne-building.jpg", n=11, k=30, type="div", saturation=c(0.75, 1), brightness=c(0.75, 1), bw=c(0.1, 0.9), plot=TRUE)

# website materials for image compression

#https://github.com/wee-analyze/machine-learning-kmeans-image-compression - k-means compression
#https://towardsdatascience.com/image-compression-using-k-means-clustering-aa0c91bb0eeb	- k-means compression
#https://rpubs.com/JanpuHou/469414 - eigenfaces (PCA for face recognition)
#https://rpubs.com/dherrero12/543854 - eigenfaces (PCA for face recognition)

#Extensions for Dimensions reductions
#1.	PCA for mixed data – operates on quantitative and qualitative data - use PCAmixdata:: package https://cran.r-project.org/web/packages/PCAmixdata/vignettes/PCAmixdata.html#pcarot, https://arxiv.org/pdf/1411.4911.pdf 
#2.	Correspondence Analysis – for categorical variables – use FactoMineR:: package
#https://cran.r-project.org/web/packages/FactoMineR/index.html 
