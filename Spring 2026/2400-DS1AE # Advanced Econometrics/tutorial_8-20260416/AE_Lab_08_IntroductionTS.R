###########################################################################
#		Advanced Econometrics                                                 #
#   Spring semester                                                       #
#   dr Marcin Chlebus, dr Rafa? Wo?niak                                   #
#   University of Warsaw, Faculty of Economic Sciences                    #
#                                                                         #
#   Materials based on dr Piotr Wojcik Time Series Analysis for QF        #
#                                                                         #
#                 Lab 08: Introduction to TSA                             #
#                                                                         #
###########################################################################


###########################################################################
# 1. Set up R  environment                                                #
###########################################################################

# installing the library 
# (done once on particular computer in particular R version)

install.packages("zoo")
install.packages("xts")

# loading the library into memory (done once in R session, 
# when it is needed)
# lets install needed packages
library(zoo)
library(xts)
library(dplyr)

###########################################################################
# 2. Data preparing                                                       #
###########################################################################

#####################################################
# Importing data from other formats

# Checking the current working path/directory

# getwd()

# Setting the w path/directory
# CAUTION! Instead of single backslash
# division sign or double backslash should be used, eg.: 
# setwd("C:\\Data\\project")	or setwd("C:/Data/project")

# setwd("C:\\Users\\Rafal\\WNE\\Advanced_Econometrics\\AE_Lab_08")

# import of CSV file
# "VIX.csv" data on implied volatility measure 
# Chicago Board Options Exchange Market 
# Volatility Index, a popular measure of the implied volatility 
# of S&P 500 index options)

VIX <- read.csv("VIX.csv", # name of the file
              header = T,  	# if first row doesn't contain variable names: header=F'
              sep = ",", 	  # sign used as columns separator
              dec = ".")	  # sign used as decimal place separator

# in case of the CSV file with a header, comma separator 
# and "dot" for decimal place
# one can simply use the syntax

VIX <- read.csv("VIX.csv")

# lets see the first few rows of resulting data frame
head(VIX)

# and last few rows
tail(VIX)

# exporting a data frame into a CSV file
write.csv(VIX, "VIX_copy.csv")

# if we don't want to save the rownames in the file
write.csv(VIX, "VIX_copy.csv", row.names = F)


#####################################################
# Working with dates

# importing the data from csv file saved in working directory
quot_aapl <- read.csv("AAPL.csv")

head(quot_aapl)

# lets check the class of the Date column
class(quot_aapl$Date)

# lets check structure of the whole dataset
str(quot_aapl)

# Date column is not a date! 
# It is stored as a factor column (qualitative variable)
# read.csv() function by default converts all strings to factors

# lets change it by importing the data again 
# with an additional parameter
quot_aapl <- read.csv("AAPL.csv", stringsAsFactors = F)

class(quot_aapl$Date)

# now it is a character column
# lets transform it into date

quot_aapl$Date <- as.Date(quot_aapl$Date, format = "%Y-%m-%d")
# we have to give the format in which date is originally stored:
# %y means 2-digit year, 
# %Y means 4-digit year
# %m means a month
# %d means a day

class(quot_aapl$Date)

head(quot_aapl)
# looks the same, but is not the same 
# now R understands this column as dates

#####################################################
# Working with more then one data sets

quot_msft <- read.csv("MICROSOFT.csv", stringsAsFactors = F)
quot_intel <- read.csv("INTEL.csv", stringsAsFactors = F)
quot_amazon <- read.csv("AMAZON.csv", stringsAsFactors = F)

# lets transform a Date column into date format for all imported stocks
quot_intel$Date <- as.Date(quot_intel$Date, format = "%Y-%m-%d")
quot_amazon$Date <- as.Date(quot_amazon$Date, format = "%Y-%m-%d")
quot_msft$Date <- as.Date(quot_msft$Date, format = "%Y-%m-%d")


# by default all imported datasets are stored as data.frames
# in case of time series data (especially with possibly
# irregular intervals) it is more convenient to store
# them as xts objects

# lets convert all datasets to xts objects
quot_aapl <- xts(quot_aapl[,-1], # data columns (without a column with date)
                 quot_aapl$Date) # date/time index
str(quot_aapl)
# lets see the result
head(quot_aapl)

# and convert all remaining data to xts objects
quot_intel <- xts(quot_intel[,-1], quot_intel$Date)
quot_amazon <- xts(quot_amazon[,-1], quot_amazon$Date)
quot_msft <- xts(quot_msft[,-1], quot_msft$Date)


### putting the data together

# lets keep close prices (Adj.Close) for all stocks in one dataset

# we will use merge.xts() function, which allows to join xts objects

# first we check the sequence of columns
names(quot_aapl)
names(quot_intel)
names(quot_amazon)
names(quot_msft)

# we need column no 6 (Adj.Close)

# lets put together all quotations
# we will use merge.xts() function which allows to join datasets
# ( cbind() will also work on xts objects with the same result)

quotations <- merge.xts(quot_aapl[,6],
                        quot_intel[,6],
                        quot_amazon[,6],
                        quot_msft[,5])

quotations = na.omit(quotations)

# the abbreviated name merge() would also work correctly
head(quotations)

# lets change the names of columns with close prices respectively 
names(quotations) <- c("close_aapl", "close_intel", 
                       "close_amazon", "close_msft")

# and see the first few rows again
head(quotations)


#####################################################
# Plotting data

# plot a single series
plot(quotations$close_intel,
     main = "Quotations of Intel \n 2005-2016") # \n means a line break

plot(diff.xts(quotations$close_intel,log=T),
     main = "Quotations of Intel \n 2005-2016") # \n means a line break

# several series on one plot

# it is easier for the zoo data type

# we transform a data frame into zoo object using as.zoo() function
# transforming an xts object into zoo requires just its name

quotations.zoo <- as.zoo(quotations) 

class(quotations.zoo)

# plotting series separately
plot(quotations.zoo)

# plotting series on one plot
plot(quotations.zoo, plot.type = "single")

# Amazon has a different scale - lets skip it on the plot
plot(quotations.zoo[,-3], plot.type = "single")

# but here we need to add a legend

colors_ <- c("blue", "green", "red")

plot(quotations.zoo[,-3], plot.type = "single",
     col = colors_,   # colors for subsequent lines
     ylab = "close price", xlab = "time", # axes labels
     main = "Quotations of 3 different stocks") # title above the plot

# separately we add a legend definition
legend("topleft",     # legend position - combination of top, bottom and left, right
       names(quotations.zoo[,-3]), # legend elements (names of the series)
       text.col = colors_)     # colors (the same as in plot() function above)


### lets save the final xts object as RData file
save(list = "quotations", file = "quotations.RData")

###################################################################
# Exercises

# Exercise 1.1
# import a CSV dataset with daily data for selected index 
# (BOVESPA, CAC40, DAX or FTSE100)

# Import CSV file
for (i in c("BOVESPA", "CAC40", "DAX", "FTSE100")) {
  x <- read.table(paste0(i,".txt"), header = TRUE, sep = ",")
  assign(x = i,value = x)
}

# indices <- c("BOVESPA", "CAC40", "DAX", "FTSE100")
# 
# data_list <- lapply(indices, function(i) {
#   read.table(paste0(i, ".txt"), header = TRUE, sep = ",")
# })

# names(data_list) <- indices

# Show first rows

for (i in c("BOVESPA", "CAC40", "DAX", "FTSE100")) {
  print(head(get(i)))
}
# Check structure
for (i in c("BOVESPA", "CAC40", "DAX", "FTSE100")) {
  print(str(get(i)))
}

# Exercise 1.2
# create a dataset containing only date, close price and volume

for (i in c("BOVESPA", "CAC40", "DAX", "FTSE100")) {
  df = get(i)
  
  df = df[, c("Date", "Close", "Volume", "Open")]
  
  assign(x = i,value = df)
}

head(BOVESPA)


# Exercise 1.3
# Based on the original imported dataset (Exercise 1.1) 
# add a new variable 'max_min' equal to the relation of maximum 
# to minimum price during the month and variable p_diff equal to
# the percentage daily price difference (close-open)/open

for (i in c("BOVESPA", "CAC40", "DAX", "FTSE100")) {
  
  df <- get(i)
  
  df$Date <- as.Date(as.character(df$Date), format = "%Y%m%d")
  
  df$month <- format(df$Date, "%Y-%m")
  
  df = df %>%
    mutate(month = format(Date, "%Y-%m")) %>%
    group_by(month) %>%
    group_by(month) %>%
    mutate(month_max = max(Close),
           month_min = min(Close),
           rel_min_max = month_max/month_min
           ) %>%
    ungroup()
  
  df$p_diff <- (df$Close - df$Open) / df$Open
  
  assign(i, df)
}

head(BOVESPA)

# Exercise 1.4
# print dates for which the percentage daily price difference
# exceeded 3.5% in absolute sense (abs() function)

indices <- c("BOVESPA", "CAC40", "DAX", "FTSE100")

for (i in indices) {
  
  df <- get(i)
  
  # Ensure Date is in Date format
  # df$Date <- as.Date(as.character(df$Date), "%Y%m%d")
  
  # Filter rows
  big_moves <- df[abs(df$p_diff) > 0.035, ]
  
  # Print results
  cat("\nIndex:", i, "\n")
  print(paste0("We have ",length(big_moves$Date), " dats with |p_diff|> 0.035"))
}

library(ggplot2)

indices <- c("BOVESPA", "CAC40", "DAX", "FTSE100")

combined <- data.frame()

for (i in indices) {
  df <- get(i)
  
  # Convert Date safely
  if (!inherits(df$Date, "Date")) {
    df$Date <- as.Date(as.character(df$Date), format = "%Y%m%d")
  }
  
  # Keep only finite observations
  df <- df[!is.na(df$Date) & is.finite(df$p_diff), ]
  
  # Add index name
  df$Index <- i
  
  combined <- rbind(combined, df)
}

ggplot(combined, aes(x = Date, y = p_diff)) +
  geom_line() +
  facet_wrap(~ Index, scales = "free_y") +
  ggtitle("Daily Returns by Index") +
  theme_minimal()

# Exercise 1.5
# for a variable p_diff print and interpret basic statistical 
# measures (summary() function)

indices <- c("BOVESPA", "CAC40", "DAX", "FTSE100")

for (i in indices) {
  
  df <- get(i)
  print(i)
  print(summary(df$p_diff))
}

# BOVESPA
# Median is close to 0, indicating no typical daily gain or loss.
# Mean is also approximately 0, suggesting no consistent daily trend.
# Most daily returns lie between about -1.06% and +1.09%.
# However, extreme values (-15.8% and +33.9%) indicate very high volatility.
# This suggests BOVESPA is a highly volatile index, typical for an emerging market.

# CAC40
# Median is close to 0 and mean slightly negative, indicating stable behavior.
# Most daily returns fall between about -0.61% and +0.63%, showing low volatility.
# The minimum value of -100% is unrealistic and indicates a data error.
# This observation should be removed before further analysis.

# DAX
# Median and mean are close to 0, indicating no strong daily trend.
# Most returns are between about -0.58% and +0.60%, suggesting moderate stability.
# Extreme values (-8.7% and +11.8%) are large but realistic, likely due to crisis periods.
# Overall, DAX shows moderate volatility typical of developed markets.

# FTSE100
# Median and mean are very close to 0, indicating stable daily returns.
# Most values lie between about -0.48% and +0.53%, the narrowest range among indices.
# Extreme values (-8.8% and +9.8%) are moderate.
# FTSE100 appears to be the most stable index among the four.


