################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 6 ###########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Data from different sources ################################################


# Absolute path, basic functions:


# file location

# Windows path: C:\Users\maria\Desktop\RIntro\data\notepadData.txt

# transformation1: C:\\Users\\maria\\Desktop\\RIntro\\data\\notepadData.txt

# transformation2: C:/Users/maria/Desktop/RIntro/data/notepadData.txt


# Reading data from txt file with basic function read.table

# checking the arguments of the function
?read.table

table1 <- read.table("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets/notepadData.txt", 
                      header = TRUE, sep = " ")

table1

# now we can use the data we have read
summary(table1$price)



# reading data with relative paths

# path to the data folder:  "C:/Users/maria/Desktop/RIntro/data"

# setting the 'working directory' 
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets")

# checking the path to the working directory 
getwd()


# location can be stored with a text variable which stores the path to the folder
locationWD <- c("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation")

setwd(locationWD)

getwd() # we get the same result



# now we can use the relative paths:

table1a <- read.table("/Datasets/notepadData.txt", 
                      header = TRUE, sep = " ")

table1a <- read.table("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets/notepadData.txt", 
                       header = TRUE, sep = " ")

table1a # success! the same table has been read



# path location can be chosen with the interactive function file.choose()

table1b <- read.table(file.choose(), header = TRUE, sep = " ")
table1b



### Reading data of other types ################################################

# reading the csv file with read.csv() function
setwd("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets")

getwd()

water <- read.csv("/graphics - water quality/water_potability.csv", sep = ";", dec=".")
water <- read.table(file.choose(), header = TRUE, sep = ",", dec=".")

# good practice! always glimpse at the data that you have just read
# check if they are read in the proper format 
head(water)

# Problem! there was a wrong separator chosen 

water <- read.csv(file.choose(), sep = ",", dec=".")

head(water) # now the data looks properly



# reading data from Excel file with read_excel function

# staring with installing the new package
install.packages("readxl")

# loading it to the current R session
# now its functions will be available in this R session
library(readxl)

?read_excel

# automatic loading of the first sheet 
loanEXCEL1 <- read_excel("dataset - loan prediction/loan_prediction_excel.xlsx")
loanEXCEL1

loanEXCEL2 <- read_excel("dataset - loan prediction/loan_prediction_excel.xlsx", sheet = 2)
loanEXCEL2

loanEXCEL3 <- read_excel("dataset - loan prediction/loan_prediction_excel.xlsx", sheet = "LoanPred")
loanEXCEL3

class(loanEXCEL1) # to tibble - specific data types, extending the data.frame possibilities

loanEXCEL1 <- as.data.frame(loanEXCEL1)
class(loanEXCEL1)

# cleaning the environment from unnecessary files - function remove()
remove(loanEXCEL3)
loanEXCEL3 # reading error: this object is no longer available in the memory



### Saving and reading R objects ###############################################

# Saving and reading objects between R sessions 

ls() # listing all the objects loaded in the memory 

# saving all loaded objects to the file (to use them in the next session)
save(list = ls(all.names = TRUE), file= "~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets/all.rda")

rm(list = ls(all.names = TRUE)) # cleaning the whole memory

loanEXCEL1 # lack of object

load("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets/all.rda")

loanEXCEL1 # object read again 

# saving single object to a file  
save(loanEXCEL1, file = "~/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets/")

rm(loanEXCEL1)

head(loanEXCEL1)

load("data/loanEXCEL_inR.rda")

head(loanEXCEL1)

# saving a few objects -> to the RData file
save(loanEXCEL1, loanEXCEL2, file = "data/loanEXCEL12_inR.RData")
load("data/loanEXCEL12_inR.RData")


rm(list = ls(all.names = TRUE)) # cleaning the enviroment



################################################################################
### Cleaning data - case study #################################################

# Loading data and reviewing its overall structure

alcohol <- read.csv("/home/ondrej-marvan/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/Datasets/dataset - student alcohol consumption/student-alcohol.csv")
head(alcohol)
str(alcohol)


# The first column is simply an index - it can be removed

head(alcohol[,-1]) # omit the first column

alcohol <- alcohol[,-1] # overwriting the object



# Revisiting the structure

str(alcohol)
summary(alcohol)
# lots of text variables that should be converted to 'factor'
# there are also numeric variables that are also factors


### 1. Missing data ############################################################

# is there missing data?
alcohol[!complete.cases(alcohol),]

# age and Mjob variables


summary(alcohol$age)
median(alcohol$age)

median(alcohol$age, na.rm = TRUE)


# Filling in with median

alcohol$age[is.na(alcohol$age)] <- median(alcohol$age, na.rm = TRUE)

# Check if there are any missing observations left
alcohol$age[is.na(alcohol$age)]




# Which date still needs to be completed?
alcohol[!complete.cases(alcohol),] # MJob in line 63

# What values does mjob take
summary(alcohol$Mjob)

summary(factor(alcohol$Mjob))
# The missing value can be filled in by the most frequent observation or the overall level - here 'other'

alcohol$Mjob[63]
alcohol$Mjob[63] <- 'other'



# Are there any more missing dates?
alcohol[!complete.cases(alcohol),] # No - zero rows


### 2. Transforming categorical data ###########################################
str(alcohol)


# School
# check if there are no errors in the labels
summary(factor(alcohol$school))
alcohol$school <- factor(alcohol$school, levels = c("GP", "MS"), 
                         labels = c("Gabriel Pereira", "Mousinho da Silveira"))



# Sex
summary(factor(alcohol$sex))
alcohol$sex <- factor(alcohol$sex, levels = c("F", "M"), 
                      labels = c("female", "male"))




# Address
summary(factor(alcohol$address))
alcohol$address <- factor(alcohol$address, levels = c("R", "U"), 
                          labels = c("rural", "urban"))



# Family size
summary(factor(alcohol$famsize))
alcohol$famsize <- factor(alcohol$famsize, levels = c("GT3", "LE3"), 
                          labels = c("more than 3", "less or equal to 3"))



# Parent's cohabitation status
summary(factor(alcohol$Pstatus))
alcohol$Pstatus <- factor(alcohol$Pstatus, levels = c("A", "T"), 
                          labels = c("living apart", "living together"))




# Mother's education
# Pierwszy factor zapisany liczbami
summary(factor(alcohol$Medu))
alcohol$Medu <- factor(alcohol$Medu, levels = c(0, 1, 2, 3, 4), 
                       labels = c("none", "primary",
                                  "primary higher", "secondary",
                                  "higher"), ordered = TRUE)



# Father's education
summary(factor(alcohol$Fedu))
alcohol$Fedu <- factor(alcohol$Fedu, levels = c(0, 1, 2, 3, 4), 
                       labels = c("none", "primary",
                                  "primary higher", "secondary",
                                  "higher"), ordered = TRUE)



# Reason to choose this school
summary(factor(alcohol$reason))
alcohol$reason <- factor(alcohol$reason)




# Checking the structure after the first corrections
str(alcohol)
summary(alcohol)



# Guardian
summary(factor(alcohol$guardian))
alcohol$guardian <- factor(alcohol$guardian)



# Travel time
summary(alcohol$traveltime)
summary(factor(alcohol$traveltime))

#numeric: 1 - <15 min., 2 - 15 to 30 min., 3 - 30 min. to 1 hour, or 4 - >1 hour

alcohol$traveltime <- factor(alcohol$traveltime, levels = c(1, 2, 3, 4), 
                             labels = c("0-15 min", "15-30 min",
                                        "30-60 min", "above 60 min"),
                             ordered = TRUE)



# Study time
summary(alcohol$studytime)
summary(factor(alcohol$studytime))

# 1 - <2 hours, 2 - 2 to 5 hours, 3 - 5 to 10 hours, or 4 - >10 hours) 

alcohol$studytime <- factor(alcohol$studytime, levels = c(1, 2, 3, 4), 
                            labels = c("0-2 hours", "2-5 hours",
                                       "5-10 hours", "above 10 hours"),
                            ordered = TRUE)



# School support
summary(factor(alcohol$schoolsup))
alcohol$schoolsup <- factor(alcohol$schoolsup, levels = c("no", "yes"))



# other variables with the same structure - we will try to automate this

# 16.	schoolsup - extra educational support (binary: yes or no) 
# 17.	famsup - family educational support (binary: yes or no) 
# 18.	paid - extra paid classes within the course subject (Math or Portuguese) (binary: yes or no) 
# 19.	activities - extra-curricular activities (binary: yes or no) 
# 20.	nursery - attended nursery school (binary: yes or no) 
# 21.	higher - wants to take higher education (binary: yes or no) 
# 22.	internet - Internet access at home (binary: yes or no) 
# 23.	romantic - with a romantic relationship (binary: yes or no) 


binaryVariables <- c('famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic')

# Levles overview:

lapply(alcohol[,binaryVariables], summary)


lapply(alcohol[,binaryVariables], function(x){summary(factor(x))})

# Problem with variable internet - many levels, database errors



# We will start with levels stored using numbers:
alcohol$internet[alcohol$internet==0]
alcohol$internet[alcohol$internet==0] <- "no"

alcohol$internet[alcohol$internet==1] 
alcohol$internet[alcohol$internet==1] <- "yes"

summary(factor(alcohol$internet))

# Problem with levels written in capital letters
alcohol$internet <- tolower(alcohol$internet) 

summary(factor(alcohol$internet)) 
# The levels are already in homogeneous form



# We check again whether the variables are suitable for conversion:
lapply(alcohol[,binaryVariables], function(x){summary(factor(x))})

alcohol[,binaryVariables] <- lapply(alcohol[,binaryVariables], factor, levels = c("no", "yes"))

str(alcohol)



# Conversion of other variables

# Quality of family relations
summary(alcohol$famrel)
summary(factor(alcohol$famrel))

alcohol$famrel <- factor(alcohol$famrel, levels = c(1, 2, 3, 4, 5), 
                         labels = c("very bad", "bad", "average",
                                    "good", "excellent"),
                         ordered = TRUE)



# A group of variables with the same record:

# 25.	freetime - free time after school (numeric: from 1 - very low to 5 - very high) 
# 26.	goout - going out with friends (numeric: from 1 - very low to 5 - very high) 
# 27.	Dalc - workday alcohol consumption (numeric: from 1 - very low to 5 - very high) 
# 28.	Walc - weekend alcohol consumption (numeric: from 1 - very low to 5 - very high) 

leveledVariables <- c("freetime", "goout", "Dalc", "Walc")

# Checking levels:

lapply(alcohol[,leveledVariables], summary)

lapply(alcohol[,leveledVariables], function(x){summary(factor(x))})
# everything looks good


# Conversion to an ordered class of a categorical variable:

alcohol[,leveledVariables] <- lapply(alcohol[,leveledVariables], factor, 
                                     levels = c(1, 2, 3, 4, 5), 
                                     labels = c("very low", "low", "average",
                                                "high", "very high"),
                                     ordered = TRUE)

str(alcohol)


# The last categorical variable
# Current health status:

# numeric: from 1 - very bad to 5 - very good
summary(alcohol$health)
summary(factor(alcohol$health))

alcohol$health <- factor(alcohol$health, levels = c(1, 2, 3, 4, 5), 
                         labels = c("very bad", "bad", "average",
                                    "good", "very good"),
                         ordered = TRUE)

str(alcohol)




### Tasks ######################################################################

# 1. read the description of the clients' personality analysis data and load it 
# into R (clients.csv file) as a variable named "clients". 

clients <- read.csv("clients.csv")

head(clients)

# 2. preview the structure of the data and check what classes have been assigned 
# to the variables in question.

str(clients)

# 3. Check if there are any missing observations in the set. 

# a) Which variables include missing values?
summary(clients)

# b) Input the missing values with the mean or median value from the variable. 
# Before completing the values, consider what values the variable takes. 
# If they are numbers, are they integers (e.g. year of birth)? If so, complete 
# these values according to the nature of the variable (we don't want the year 
# 1995.832, do we? ;)).

clients$Year_Birth[is.na(clients$Year_Birth)] <- round(mean(clients$Year_Birth, na.rm = TRUE), 0)


# c) What code do you use to fill the missing values of Year_Birth (if any)?

clients$Year_Birth[is.na(clients$Year_Birth)] <- round(mean(clients$Year_Birth, na.rm = TRUE), 0)

# 4. a) Check that all missing observations have been completed. If not, repeat step 3. 

sum(is.na(clients))

# b) What code would you use to show all the rows which still have some missing data?

clients[!complete.cases(clients), ]

# 5. a) Consider which variables are worth converting to a "factor" type? 
# Hint: these will usually be text variables with a few specific, recurring 
# values. They can also be variables that are represented by numbers, but do 
# not have a "numerical sense" - e.g. the variable "education" and the values 
# 2, 3, 4, which actually represent successive stages of education (logical sense) 
# rather than the exact number of years of education (numerical sense). 





# b) What code would you use to transform the Marital_Status variable (shortest code possible)?

clients$Marital_Status <- as.factor(clients$Marital_Status)

# 6. a) Consider which of the previously identified variables would be worth 
# converting to an 'ordered factor' type (ordered categorical variable).
# Hint: An 'ordered factor' type variable should contain a logical order of 
# levels - e.g. an 'education' variable with values of 'primary', 'secondary' 
# and 'tertiary'. In this case, it may be worthwhile to keep the different 
# levels in order. Another typical example of an ordered factor variable is survey 
# responses recorded using a Likert scale (https://en.wikipedia.org/wiki/Likert_scale). 

# The Education variable is the clear choice.

# b) What code would you use to transform the Education variable? Let's assume that 
# 2n means secondary education and graduation is equal to BA defence.

edu_levels <- c("Basic", "2n Cycle", "Graduation", "Master", "PhD")

clients$Education <- factor(clients$Education, 
                            levels = edu_levels, 
                            ordered = TRUE)

# 7. Transform the variables identified in steps 5 and 6 into the appropriate classes.

# Apply the transformation from Step 5
clients$Marital_Status <- as.factor(clients$Marital_Status)

# Apply the transformation from Step 6
# Define the correct logical order
edu_levels <- c("Basic", "2n Cycle", "Graduation", "Master", "PhD")

# Transform the variable
clients$Education <- factor(clients$Education, 
                            levels = edu_levels, 
                            ordered = TRUE)

# --- Optional: Check your work ---
# Notice 'Marital_Status' is now 'Factor' and 'Education' is 'Ord.factor'
str(clients)


# 8. Save results for future reference! Use an RData file with name "clientsInR".

save(clients, file = "clientsInR.RData")
