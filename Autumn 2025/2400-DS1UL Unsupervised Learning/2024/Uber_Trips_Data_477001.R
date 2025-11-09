# Changing the language to English
Sys.setlocale("LC_ALL", "en_US.UTF-8")
Sys.setenv(LANGUAGE='en')

# Libraries
library(ggplot2)
library(cluster)  
library(factoextra) 

# Load the Uber Trips data
uber_data <- read.csv("/Users/ondrejmarvan/Documents/Classes/Unsupervised Learning/Uber_Trips_Data_Task/uber-data.csv")

# View the first few rows of data and check its structure
head(uber_data)
str(uber_data)
summary(uber_data)
names(uber_data)

# Missing data check
sum(is.na(uber_data)) # 0

# Converting date/time
uber_data$DateTime <- as.POSIXct(uber_data$Date.Time, format="%m/%d/%Y %H:%M:%S")

# Convert latitude and longitude to num
uber_data$latitude <- as.numeric(uber_data$Lat)
uber_data$longitude <- as.numeric(uber_data$Lon)

# Displaying longitude and latitude 
ggplot(uber_data, aes(x = longitude, y = latitude)) +
  geom_point(alpha = 0.2) +
  ggtitle("Uber Trips in New York")

# Data prep. for clustering
# latitude ranges from 40.5 to 41 "only" while longitude ranges from -~75 to -72.5 => standardization required
location_data <- scale(uber_data[, c("latitude", "longitude")])

# Elbow method to figure our optimal num. of clusters using Within-Cluster Sum of Squares method
set.seed(123)
sample_data <- location_data[sample(1:nrow(location_data), 10000), ]  # To prevent overusing RAM
fviz_nbclust(sample_data, kmeans, method = "wss", k.max = 6) + 
  ggtitle("Elbow Method for Optimal Clusters")

# K-means clustering on the full dataset
set.seed(123)
uber_kmeans <- kmeans(location_data, centers = 4, iter.max = 1000, nstart = 10) # max. it. and nstart to prevent warning mes.: Quick-TRANSfer stage steps exceeded maximum (= 51406800)

# Cluster label
uber_data$cluster <- uber_kmeans$cluster

# Cluster visualization
ggplot(uber_data, aes(x = longitude, y = latitude, color = factor(cluster))) +
  geom_point(alpha = 0.5) +
  labs(title = "Clusters of Uber Trips in New York", color = "Cluster") +
  theme_minimal()

aggregate(cbind(latitude, longitude) ~ cluster, data = uber_data, mean)

table(uber_data$cluster)


# Analyzing Cluster Centers by Hour
# Extract the hour from the DateTime column
uber_data$hour <- as.numeric(format(uber_data$DateTime, "%H"))

# Avg. latitude and longitude for each cluster by hour
uber_hourly_centers <- aggregate(cbind(latitude, longitude) ~ cluster + hour, data = uber_data, mean)


print(uber_hourly_centers)

# Plot avg. latitude by hour for each cluster
ggplot(uber_hourly_centers, aes(x = hour, y = latitude, color = factor(cluster))) +
  geom_line() +
  labs(title = "Average Latitude of Clusters by Hour", x = "Hour", y = "Average Latitude", color = "Cluster") +
  theme_minimal()

# Analyzing Cluster Centers by Date
# Extract the date from the DateTime column
uber_data$date <- as.Date(uber_data$DateTime)

# Calculate avg. latitude and longitude for each cluster by date
uber_daily_centers <- aggregate(cbind(latitude, longitude) ~ cluster + date, data = uber_data, FUN = mean)

# Plot avg. latitude by date for each cluster
ggplot(uber_daily_centers, aes(x = date, y = latitude, color = factor(cluster))) +
  geom_line() +
  labs(title = "Average Latitude of Clusters by Date", x = "Date", y = "Average Latitude", color = "Cluster") +
  theme_minimal()

# Silhouette Analysis to assess clustering quality, running out of RAM memory
set.seed(123)
sample_indices <- sample(1:nrow(location_data), 10000)
sample_data <- location_data[sample_indices, ]
sample_clusters <- uber_kmeans$cluster[sample_indices]

# Compute silhouette scores on the sample
silhouette_scores <- silhouette(sample_clusters, dist(sample_data))
fviz_silhouette(silhouette_scores) + ggtitle("Silhouette Analysis of Sampled Clusters")

# Summary of Silhouette
summary(silhouette_scores)
