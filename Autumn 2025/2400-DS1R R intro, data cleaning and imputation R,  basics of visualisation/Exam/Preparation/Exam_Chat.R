# Exam


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

##############################################################################
# Load libraries 
library(tidyverse)
library(dplyr)

# Read the data
data <- read.csv("chatXDD.csv", sep = ";", dec = ",")

# Check the data structure
names(data)
head(data)
summary(data)
str(data)

##############################################################################
# TASK 1 - Variable types analysis
##############################################################################
# Type (currently)          Target type/class in R
# breakdownTime    chr      Date (or POSIXct)
# employees        int      int (correct already)
# siteTraffic      num      num (correct already)
# errorCode        chr      factor (or split into two variables)
# topic            chr      factor
# hoursToImprove   num      num (correct already)


##############################################################################
# TASK 2 - Rename 'breakdownTime' to 'indicentTime'
##############################################################################
data$breakdownTime <- rename(indicentTime = breakdownTime)

#### Task 2 - Rename variable ‘breakdownTime’ to 'indicentTime’. Correct the error created at the data creation stage. Do not create a new variable, just rename an existing one.
data <- rename(data, indicentTime = breakdownTime)

# Check if renaming worked
head(data$indicentTime)
names(data)

##############################################################################
# TASK 3 - Transform 'topic' to factor
##############################################################################
str(data$topic)

data$topic <- as.factor(data$topic)
levels(data$topic)  # See the levels

##############################################################################
# TASK 4 - Separate 'errorCode' into 'errorNumber' and 'microservice'
##############################################################################
head(data$errorCode)  # Example: "403-S2"

# Separate the variable using tidyr's separate function
data <- data %>% 
  separate(col = "errorCode",
           into = c("errorNumber", "microservice"),
           sep = "-",
           remove = TRUE)  # remove original column

# Check the result
names(data)
head(data)

##############################################################################
# TASK 5 - Maximum employees when topic was "economics"
##############################################################################
# FIlter for economics and find max employees
max_employees_economics <- data %>%
  filter(topic == "economics") %>%
  summarise(max_employees = max(employees))

print(max_employees_economics)

# Alternative simple way using base R:
max(data$employees[data$topic == "economics"])

##############################################################################
# TASK 6 - Maximum time for issues resolved by at least 16 employees
##############################################################################
# Filter for employees >= 16 and find max hoursToImprove

max_time_16_employees <- data %>%
  filter(employees >= 16) %>%
  summarise(max_time = max(hoursToImprove))

print(max_time_16_employees)

# Alternative simple way using base R:
max(data$hoursToImprove[data$employees >= 16])

##############################################################################
# TASK 7 - Add new variable 'minutesFixing' (hours * 60)
##############################################################################

data$minutesFixing <- data$hoursToImprove * 60

# Check the result
head(data[, c("hoursToImprove", "minutesFixing")])

##############################################################################
# TASK 8 - Boxplot of minutes by microservice
##############################################################################
boxplot(minutesFixing ~ microservice, 
        data = data,
        xlab = "Microservice type",
        ylab = "Minutes to fix",
        main = "Distribution of fixing time by microservice")

# Alternative using ggplot2:
ggplot(data, aes(x = microservice, y = minutesFixing)) +
  geom_boxplot() +
  labs(x = "Microservice type", 
       y = "Minutes to fix",
       title = "Distribution of fixing time by microservice")

##############################################################################
# TASK 9 - Build linear model and extract employees coefficient
##############################################################################

# Build the linear model
myModel <- lm(hoursToImprove ~ employees + siteTraffic + topic + microservice, 
              data = data)

# View the full model summary
summary(myModel)

# Extract and print the coefficient for employees
employees_coefficient <- coef(myModel)["employees"]
print(employees_coefficient)

##############################################################################
# TASK 10 - Group comparison summary table
##############################################################################
# Filter for S1 microservice only, group by microservice and topic
summary_table <- data %>%
  filter(microservice == "S1") %>%
  group_by(microservice, topic) %>%
  summarise(
    averageEmployees = mean(employees),
    maximumFixTimeInMinutes = max(minutesFixing),
    .groups = "drop"
  )

# Print the summary table
print(summary_table)

# If you want it to look exactly like the exam example (only economics and mathematics):
summary_table_filtered <- data %>%
  filter(microservice == "S1", topic %in% c("economics", "mathematics")) %>%
  group_by(microservice, topic) %>%
  summarise(
    averageEmployees = mean(employees),
    maximumFixTimeInMinutes = max(minutesFixing),
    .groups = "drop"
  )

print(summary_table_filtered)

