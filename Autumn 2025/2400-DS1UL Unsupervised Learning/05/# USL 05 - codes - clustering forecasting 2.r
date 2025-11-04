# upload the Sales_Transactions_Dataset_Weekly dataset - quantities of 800 products for 52 weeks
# from the UCI Machine Learning Repository
# inspect the dataset
df <- read.csv("Sales_Transactions_Dataset_Weekly.csv", header = TRUE)
print(is.data.frame(df))
print(ncol(df))
print(nrow(df))

# check the product codes
DF <- data.frame(df[,2:53], row.names = df$Product_Code)
names(DF)

# do we have any missing values?
sum(is.na(DF))

# we do our analysis and forecasting basing on the historical observations

# the issue with data normalization - the normalized data may have a lower representation of the features of the original data
# thus, it affects the quality of predictions

# cluster products into groups based on the similarity of transactions over the covered period

# try out with vaiours k
# perform the stats that you already know
install.packages("factoextra")
library("factoextra")

k1 = kmeans(DF, centers=2, nstart=25)
k2 = kmeans(DF, centers=3, nstart=25)
k3 = kmeans(DF, centers=4, nstart=25)
k4 = kmeans(DF, centers=5, nstart=25)

# prepare some plots
p1 <- fviz_cluster(k1, geom = "point", DF) + ggtitle("k = 2")
p2 <- fviz_cluster(k2, geom = "point", DF) + ggtitle("k = 3")
p3 <- fviz_cluster(k3, geom = "point", DF) + ggtitle("k = 4")
p4 <- fviz_cluster(k4, geom = "point", DF) + ggtitle("k = 5")

install.packages("gridExtra")
library("gridExtra")
grid.arrange(p1, p2, p3, p4, nrow=2)

# Elbow method based on within-cluster sum of squares
install.packages("tidyverse")
library("tidyverse")
set.seed(100)

wss=function(k) {kmeans(DF, k, nstart=10)$tot.withinss}

# k range from 1 to 15
k.values = 1:15

# extract wss
wss_values = map_dbl(k.values, wss)

plot(k.values, wss_values, type="b", pch=19, frame=FALSE,
    main = "Elbow plot for k-means output",
    xlab = "No of clusters",
    ylab = "Total within-clusters sum of squares")

# Silhouette width
install.packages("cluster")
library("cluster")

silhouette_score = function(k){
    km = kmeans(DF, centers = k, nstart=25)
    ss = silhouette(km$cluster, dist(DF))
    mean(ss[, 3])}
k = 2:10
avg_sil = sapply(k,silhouette_score)
plot(k, type = 'b', avg_sil, xlab = 'number of clusters', ylab ='average silhouette scores', frame = 'False')

# Gap stat
library("factoextra")
fviz_nbclust(DF, kmeans, method = "gap_stat")

# let us proceed with 3 clusters

cluster_3 <- kmeans(DF,centers = 3,nstart = 10)
cluster_3$cluster <- as.factor(cluster_3$cluster)
cluster_3
ggplot(DF, aes(W1,W44,color =cluster_3$cluster)) +geom_point()

# structure of clusters
str(cluster_3)

# more insight into the data - group of 490 observations
group1 = data.frame(t(DF[cluster_3$cluster == 3,]))
summary(sapply(group1, mean))
hist(sapply(group1, mean), main = "Histogram of Product Group 1", xlab = "Number of Transactions")

# what is the average weekly transaction?

# separate the initial group 1 into two parts

group0 <- group1 [, sapply (group1, mean) <= 2]
group1 <- group1 [, sapply (group1, mean) > 2]
group2 <- data.frame (t (DF [cluster_3$cluster == 1,]))
group3 <- data.frame (t (DF [cluster_3$cluster == 2,]))

# visualize that
library("scales")
slices <- c(ncol(group0), ncol(group1), ncol(group2), ncol(group3))
lbls <- c("Group 0:", "Group 1:", "Group 2:", "Group 3:")
lbls <- paste(lbls, percent(slices/sum(slices)))
pie(slices, labels = lbls, col=rainbow(length(lbls)), main="Pie Chart of Product Segmentation")

# boxplot
group0_mean <- sapply(group0, mean)
group1_mean <- sapply(group1, mean)
group2_mean <- sapply(group2, mean)
group3_mean <- sapply(group3, mean)
boxplot(group0_mean, group1_mean, group2_mean, group3_mean, main = "Box-Plot of Product Segmentation",
names = c("Group 0", "Group 1", "Group 2", "Group 3"))

lapply(list(group0_mean, group1_mean, group2_mean, group3_mean), summary)

# group 0
par(mfrow = c(1, 2))
hist(group0_mean, main = "Histogram of Group 0", xlab = "Number of Transactions")
boxplot(group0_mean, main = "Box-plot of Group 0", names = c("Group0"))

# select a representative product with average weekly transaction close to median or mean
# median is a better choice as our distribution is right skewed
idx0 <- which.min(abs(group0_mean-summary(group0_mean)['Median']))
print(idx0)

# proceed with timeseries
# use the Julian calendar
ts0 = ts (group0 [, idx0], frequency = 365.25/7)
plot(ts0)

# most of time P214 has zero transactions, some 1 transaction, and one 4 transactions per week
# most of products in this group will have similar plots
# so it is unnecessary to proceed further with analysis or develop a forecasting model with this series

# ooks like a static series and the most appropriate way is to copy the current data to predict the future assuming the transactions 
# will be same as the previous year for a certain product in Group 0

# however, we can always try to find out something out of nothing

summary(group1_mean)
par(mfrow = c(1, 2))
hist(group1_mean, main = "Histogram of Group 1", xlab = "Number of Transactions")
boxplot(group1_mean, main = "Box-plot of Group 1", names = c("Group1"))

# it seems that the products in Group1 have low demands

idx1 = which.min (abs (group1_mean-summary (group1_mean)['Mean']))
print(idx1)
summary(group1[, idx1])
boxplot (group1[,idx1], main = "Box-Plot")

# convert p318 to time series
ts1 <- ts(group1[,idx1], frequency = 365.25/7)
p1 = plot(ts1)

# there is no trend or seasonality in this time series

# Exponentian Smoothing (ETS)
# weighted averages of past observations
# weights decaying exponentially as the observations get older
install.packages("forecast")
library("forecast")
fit_ets <- ets(ts1)
summary(fit_ets)
checkresiduals(fit_ets)

# the Ljung-Box test leads us to not‐to‐reject the null hypothesis or, in other words, the time series is white test

plot(forecast(fit_ets, h = 4))

# the residuals have constant variance and zero mean, and there is no significant autocorrelation with each other
# the model is a good fit; moreover, the p-value of Ljung-Box test also indicates independence of residuals

# the forecasting results displaying the prediction interval is excessively wide, with negative values.
# so ETS model is not a good choice for this time series

# Autoregressive Integrated Moving Average (ARIMA)

install.packages("urca")
library("urca")
install.packages("aTSA")
library("aTSA")

summary(ur.kpss(ts1))
adf.test(ts1)
ur.df(ts1,type='trend',lags=10,selectlags="BIC")

p1 = ggAcf(ts1)
p2 = ggPacf(ts1)
grid.arrange(p1, p2, ncol = 2)

# time series of P318 is a white noise, which is a stationary data

# ARIMA for Group1
fit_arima = auto.arima(ts1, seasonal = FALSE)
summary(fit_arima)
checkresiduals(fit_arima)

# compared to ETS model, we can see that, the RMSE and AIC are both smaller indicating better fit for the ARIMA model
# when checking the forecasting results, we notice that the forecasts are very similar with the ETS model, with an unacceptably wide prediction interval
# for this time series, ARIMA model is not a good choice neither

# Average, Naive and Drift approaches
# Naive prediction places 100% weight on the most recent observation and moving averages place equal weight on k values
# exponential smoothing allows for weighted averages where greater weight can be placed on recent observations and lesser weight on older observations

p1 = autoplot(ts1) + autolayer(meanf(ts1, h = 4)) + xlab("Week") +
ylab("Number of Transactions") + ggtitle("Group 1: Average Method")
p2 = autoplot(ts1) + autolayer(naive(ts1, h = 4)) + xlab("Week") +
ylab("Number of Transactions") + ggtitle("Group 1: Naive Method")
p3 = autoplot(ts1) + autolayer(rwf(ts1, h = 4)) + xlab("Week") +
ylab("Number of Transactions") + ggtitle("Group 1: Drift Method")
grid.arrange(p1, p2, p3, ncol = 3)

# none of these methods fit the data better than either ARIMA or ETS method

# notice that the forecasting results of both ARIMA and ETS models are equal to the mean of P318 (3.673/3.68)

# because of the wide prediction interval, it will put business into risk if we only use the forecasting results directly
# instead of using the mean value, it will be advisable to use the 3rd quartile value, 5 transactions per week and that way, we may cover 75% of business needs

# Group2
summary(group2_mean)
par(mfrow = c(1, 2))
hist(group2_mean, main = "Histogram of Group 2", xlab = "Number of Transactions")
boxplot(group2_mean, main = "Box-plot of Group 2", names = c("Group2"))

# we can conclude that the products in Group2 have high demands
# the distribution is centered, so, we select the mean as target value

idx2 =which.min(group2_mean-summary(group2_mean)['Mean'])
print(idx2)
summary(group2[,idx2])
boxplot(group2[,idx2], main = "Box-Plot (Group 2)")

# decomposition of Group2
# convert P209 data to time series
ts2 = ts(group2[,idx2], frequency = 365.25/7)
p1 = autoplot(ts2) + xlab("Week") + ylab("Number of Transaction") + ggtitle("Time Plot (Group 2)")
p2 = ggAcf(ts2)
grid.arrange(p1, p2, ncol = 2)

# the majority of the number of transactions is between 15 and 35 per week
# a decreasing trend over time, but no seasonality
# auto correlation plot confirms with this observation

# the original time series consists of a trend component and an irregular component, but no seasonal component

# it is appropriate to use the simple moving average method for smoothing

autoplot(ts2, series = "Data") + autolayer(ma(ts2, 5), series = "5-MA") +
autolayer(ma(ma(ts2, 5), 3), series = "3x5-MA") +
scale_colour_manual(values=c("Data"="grey50","5-MA"="blue", "3x5-MA" = "red"),
breaks=c("Data","5-MA", "3x5-MA"))

# the estimated trend is not smoothing as expected
# “3x5-MA” trend is a better fit
# repeat the similar process of applying ETS, ARIMA and others

fit_ets <- ets(ts2, model = "AAZ")
summary(fit_ets)
checkresiduals(fit_ets)

# residual plot above shows that the residuals have constant variance and zero mean, and there is no significant autocorrelation with each other
# the model is a good fit
# the p-value of Ljung-Box test also indicates independence of residuals
# the ETS model is a good fit

# ARIMA for Group2
summary(ur.kpss(ts2))
adf.test(ts2)
ur.df(ts1, type='trend', lags = 10, selectlags = "BIC")

# the unit root test result shows the necessary of differencing, and the differencing degree should be 1

ndiffs(ts2)

p1 = ggAcf(ts2)
p2 = ggPacf(ts2)
grid.arrange(p1, p2, ncol = 2)

# in the ACF plot, we see that there are two spikes crossed the upper confidence line and no significant spikes thereafter
# in the PACF, there are two significant spikes, and then no significant spikes thereafter
# the ACF and PACF lead us to think an ARIMA(2,1,0) model might be appropriate

fit_arima1 = arima(ts2, order = c(2, 1, 0))
fit_arima2 = arima(ts2, order = c(2, 1, 1))
fit_arima3 = arima(ts2, order = c(2, 1, 1))
fit_arima_auto = auto.arima(ts2, seasonal = FALSE)
print(c(fit_arima1$aic, fit_arima2$aic, fit_arima3$aic, fit_arima_auto$aic))
summary(fit_arima_auto)
checkresiduals(fit_arima_auto)

# best fit Arima model is Arima(0,1,1), in which the order of autocorrelation is set to 0
# it may be attributed to the small spikes in the PACF plot

# based on the trend of historical data, this forecast may overestimate the transaction

# therefore, the ETS model fits better

# SUMMARY
# Group 0: Since the demands are very low (average < 1.5 transactions/ week), it is difficult to make predictions for this group. For forecasting purpose, historical data can be used as reference; moreover, customers can be contacted to get an early estimation for future orders
# Group 1: Here too, demands are low ( average < 4 transactions /week). White noise in the transaction makes it difficult to provide a reliable forecast. Therefore, to reduce business risks, the third quartile can be used as a forecast, which is ~ 5 transactions /week. In this way, we can roughly cover 75% of orders
# Group 2: Demands are high ( average 24 transactions / week). The transaction data of the representative product has a decrease trend, but no seasonality. The forecasts of ETS model are around 20 transactions per week
