### EXAM PRACTICE###

### 1
# 1. Create a numerical value with decimal part. Convert it to integer and then
# to character. See what are the changes (in values and printing). 
a<-2.6
as.integer(a)
as.character(a)

# 2. Create two variables with text. Check the documentation of paste() and try
# to use it on created vectors. Compare the results of paste() function and c(). 
# What are the differences? Why?
a<-'abc'
d<-'def'
paste(a,d)

# 3. a) Convert vector vecDate <- c("09:12:12", "28:02:16", "31:05:22") to Date class. 
# HINT: DONT CHANGE ANYTHING BY HAND in the original data. Make sure to utilise function parameters. 
vecDate <- c("09:12:12", "28:02:16", "31:05:22")
x<-as.Date(vecDate, format = "%d:%m:%y")
class(x)
#b) Calculate number of days between these dates and today's date.
# HINT: is there a function that will get the "today's date" automatically?
x
abs(x - Sys.Date())
# 4. Create a vector "vec1" which will include numbers from 2 to 8 and from 17 to 30. 
# Use the shortest code possible.
vec1<- c(2:8, 17:30)
vec1

# 5. Create a vector "vec2" with given structure: (2,  8, 14, 20, 26, 32). Use seq() function. 
vec2<-seq(2,32, 6)
# 6. Create a vector with given structure: "2", "7", "a", "2", "7", "a", "2", "7", "a". TIP: rep()
rep(c("2","7","a"), 3)
# 7. Create a vector of length 100, which will store consecutive numbers divisible by three. 
seq(from = 3, by = 3, length.out = 100)

# 8. Using only one line of code create a vector "vec3" with following structure:
# HINT: work smartly - if something can be done with a function or with appropriate argument of
# a fuction - use it, rather than typing it down manually.  
# (1, 1, 3, 3, 5, 5, 7, 7, 9, 9, 1, 1, 3, 3, 5, 5, 7, 7, 9, 9, 1, 1, 3, 3, 5, 5, 7, 7, 9, 9). 

rep(rep(seq(1,9,2), each = 2),3)
# 9. Generate a vector "vec4" of 50 numbers with the usage of runif() function. What does
# it do? Use generated numbers to create a vector of 50 random integer values from the 
# range 0-20. 
vec4<-runif(50, min = 0, max = 20)

# 10. Print values from the 5th, 10th and 26th element of previously created vector (from task 9).
vec4[c(5,10,26)]

# 11. Print values of every second element from the previously created vector, 
# starting from the 5th element of the vector. TIP: seq(). 
vec4[seq(from = 5, to = 50, by= 2)]




### 2

# 1. Create a factor with values "a", "b", "c" of length 7. Add labels "Letter A",
# "Letter B", "Letter C". Summarize factor values. 

?factor
x<-factor(c("b","b","c", "b", "c", "a", "c"), labels=c("Letter A", "Letter B", "Letter C"))
summary(x)
# 2. Create a numeric vector with values 1-4 and length 10. You can use any function
# for creating the vector. Values can be ordered randomly. Summarize the variable 
# and check its type. Then use this vector to create an ordered factor. Set levels
# to "low" "medium" "high" "very high". Summarize the value and compare it to the initial vector. 
x<-round(runif(10, min = 1, max = 4))

f<-factor(x, levels = c(1,2,3,4) ,labels= c("low" ,"medium" ,"high", "very high"))
summary(f)
x
round(2.3)
# 3. Create a matrix with 5 rows and 2 columns, filled with zeros. Save it to "table" 
# variable. 
table = matrix(0, 5, 2)
# a) fill 1st column with values 3, 
table[,1] <-3
table
# b) set 3rd element of 2nd column to 20
table[3,2]<-20 
table
# c) Print values of the 2nd column. Check the type of the values in this column.
class(table[,2])
# d) Change the 4th element of the 2nd column to "twelve". Print values of the 
# second column again. Check their type. What is different?
table[4,2]<-"twelve"
# e) What is the type of the values of the first column? Why?
class(table[,1])

# 4. Create four variables with different types (vectors, matrices, single values).
# Create a list out of these objects named "myList".
# a) Now get the second element of the list and add an additional value to it. 
# Save the change so that it will be visible in the list

vec<- seq(0, 10)
mtx<- matrix(67, ncol = 3, nrow = 5)
num<- 55.4
chr<- "NOMORESTUDING!!!"
lst<-list(vec, mtx, num, chr)
lst[[2]][,3]<-55
lst[[2]]
# b) Add new elements at the end of the list - make it a 6-element vector of any type
lst[[6]]<-c(1,2,3,4,5,6)
# c) Print the 4th element of the last object in the list
lst[[6]][4]<-NA
lst
# d) Change the value of the 5th element of that last object to NA. 


###3 

# 1. Create and add unique names to five vectors of length 8. Make their types 
# diverse. Create a dataframe named "mySet1" out of created vector. 
numbers <- c(1:8)
mix <- c('a','b','c',4,'d',T,'ghi','j')
bool <- c(T,T,T,T,F,F,F,F)
morenumbers <- seq(1,22, by = 3) 
randomm <- rnorm(8,0,1)
mySet1 <- data.frame(numbers,mix,bool,morenumbers,randomm)
mySet1
# a) Show the 5th row of created dataframe.
mySet1[5,]
# b) Change the name of the second column of mySet1 dataframe to "column02"
colname(mySet1[,2])
colnames(mySet1)[2]<-"column02"
colnames(mySet1)
#c) Show 7 first rows of mySet1 dataframe. Use two different methods - with 
# indexes and with a function. 
mySet1[c(1:7),]
head(mySet1,7)

# 2. Use iris dataset. Using indexing show values of every 3rd row between 
# 40th and 120th observations. Try to use a one-liner (shorten the code so that 
# it fits in one line only, without any intermediate steps).
seq(40,120,3)
iris[seq(40,120,3),]
# 3. Use built-in "women" dataset. 
women
# a) Change type of the first column to character.
women[,1]<-as.character(women[,1])
class(women)
women[,1]
# b) Add two new rows to the dataset with made-up numbers. Make sure that you 
# don't loose the types of variables in the main dataframe in the process.
women[[nrow(women)+1,] <-c('2',3)
women[nrow(women)+1,] <- c('3',2)
women[,2]
# c) Add new variable to the dataset and name it "shoe_size". Using runif function
# create the values for this variable. Shoe size must be an integer between 35 and 42. 


### 4


# 1. Print values of CO2 uptake from the largest to the smallest.

sort(CO2$uptake, decreasing = T)
# 2. Show the rows of CO2 dataset, where the Type is set to Quebec and Treatment to chilled
CO2[(CO2$Type == 'Quebec') & (CO2$Treatment == 'chilled'),]
# 3. Show the rows of CO2 dataset, where the uptake is higher than 40 and the 
# dataset is sorted by the conc value from the smallest to the largest.
# Bonus point for keeping the whole code in just one line. If you need to create
# an intermediate object - name it 'temp'.
str(tmp)
CO2[(CO2$uptake >40),][sort(CO2[(CO2$uptake >40),]$conc)]
tmp <-CO2[(CO2$uptake >40),]
tmp[order(tmp$conc),]

# 4. How to get a random ordering of a CO2 dataset? TIP: You may want to get a 
# vector with random indices that will come from order(unif(...)) results. 
# See section "Picking random rows from data" for reference.
# Bonus point for writing the code in just one line with no intermediate objects.

idx <- sample(1:nrow(CO2), size =  nrow(CO2), replace = FALSE)
CO2[idx,]
runif(84)

#!!!!!!!!!!!! ORDER WORKS PRETTY FUNNY AND USEFUL, DIFFRENT THAN SORT, GIVES BACK INDEX
x<- c(0.8, 0.2, 0.3)
order(x) #gives back INDEX of osrted from laregst to lowest nubrer

# 5. Show rows of missCO2 dataset, which have at lease one missing value.
set.seed(123)
missCO2 <- CO2
missCO2[c(as.integer(runif(10)*nrow(missCO2)),14:16),"uptake"] <- NA
missCO2[c(as.integer(runif(10)*nrow(missCO2)),14:16),"conc"] <- NA
missCO2$weight <- paste0(as.integer(runif(nrow(missCO2))*30),"kg")
complete

missCO2[!complete.cases(missCO2),]
# 6. Fill in the missing uptake values with value 20.
missCO2[is.na(missCO2$uptake),]$uptake <- 20

# 7. Fill in the missing conc values with the mean of conc.
mean(na.omit(missCO2$conc))
missCO2[is.na(missCO2$conc),]$conc <- mean(na.omit(missCO2$conc))
# 8. Extract the numeric values from weight variable and store them in the new 
# column "weightNumber". Bonus point for keeping the code in one line, 
# without any intermediate objects.

#!!!!!!!!!!!!!!!!!!!!!!!!!!!1
substr(missCO2$weight, start = 1 ,stop = nchar(missCO2$weight)-2)
missCO2$weight


### 5
# 1. read the description of the clients' personality analysis data and load it 
# into R (clients.csv file) as a variable named "clients". 
clients <- read.csv('C:/Users/macko/OneDrive/Pulpit/SEMESTER 1/R/data/clients.csv')

# 2. preview the structure of the data and check what classes have been assigned 
# to the variables in question.
str(clients)

# 3. Check if there are any missing observations in the set. 
clients[!complete.cases(clients),]
# a) Which variables include missing values?
x<-as.data.frame(colSums(is.na(clients)), col.names = c('x', 'sums'))
x[x$`colSums(is.na(clients))` > 0,]
clients[,colSums(is.na(clients)) >0]
colSums(is.na(clients))
# b) Input the missing values with the mean or median value from the variable. 
# Before completing the values, consider what values the variable takes.
# If they are numbers, are they integers (e.g. year of birth)? If so, complete 
# these values according to the nature of the variable (we don't want the year 
# 1995.832, do we? ;)).

table(clients$Response)
# c) What code do you use to fill the missing values of Year_Birth (if any)?
clients$Response[is.na(clients$Response)]<-0
clients$MntWines[is.na(clients$MntWines)]<-round(mean(na.omit(clients$MntWines)))
clients$Year_Birth[is.na(clients$Year_Birth)]<-as.integer(mean(clients$Year_Birth, na.rm = T))
# 4. a) Check that all missing observations have been completed. If not, repeat step 3.

# b) What code would you use to show all the rows which still have some missing data? 
clients[!complete.cases(clients),]
# 5. a) Consider which variables are worth converting to a "factor" type? 
# Hint: these will usually be text variables with a few specific, recurring 
# values. They can also be variables that are represented by numbers, but do 
# not have a "numerical sense" - e.g. the variable "education" and the values 
# 2, 3, 4, which actually represent successive stages of education (logical sense) 
# rather than the exact number of years of education (numerical sense). 

str(clients)
#Education, Marital_Status          
# b) What code would you use to transform the Marital_Status variable into factor (shortest code possible)?
clients$Marital_Status<- factor(clients$Marital_Status)
summary(factor(clients$Marital_Status))
# 6. a) Consider which of the previously identified variables would be worth 
# converting to an 'ordered factor' type (ordered categorical variable).
# Hint: An 'ordered factor' type variable should contain a logical order of 
# levels - e.g. an 'education' variable with values of 'primary', 'secondary' 
# and ''. In this case, it may be worthwhile to keep the different 
# levels in order. Another typical example of an ordered factor variable is survey 
# responses recorded using a Likert scale (https://en.wikipedia.org/wiki/Likert_scale)

unique(clients$Education)
# b) What code would you use to transform the Education variable? Let's assume that 
# 2n means secondary education and graduation is equal to BA defence.
?factor
clients$Education<- factor(clients$Education, levels = c('Basic', '2n', 'Graduation', 'Master', 'PhD'), ordered = T)


# 1. a) Load the dataset "Life Expectancy Data.csv" into R and name it "life" 
life<-read.csv("Life Expectancy Data.csv")
# b) Preview its structure and summarise the values (two lines of code).
str(life)
summary(life)
# c) Filter the dataset - show data for 2013 only (use the $ notation where you can).
# Summarize the values of the subset (summary()) without saving the data to a 
# separate intermediate variable.
summary(life[life$Year == 2013,])
# d) Calculate median of life.expectancy for Developing Countries (status variable) 
# in 2010. Use only one line of code, with no intermediate objects. Get the numerical result.
median(life[(life$Status =='Developing') & (life$Year == 2010),]$Life.expectancy)

# e) What the average Polio vaccination share was over the world in the year 2014?
mean(life[life$Year == 2014,]$Polio)

# 2. a) Create a subset of "life" dataset for year 2008 only, name it life2008.
life2008<-life[life$Year == 2008,]

# b) Remove rows which include missing values from your dataset.
life2008<-life2008[complete.cases(life2008),]

# c) Build a linear model for the "life2008" dataset, in which the dependent (y) variable
# will be the GDP, and the regressors (x) will be Polio, Alcohol and infant.deaths
# (in that order). Name the output object model2008.
model2008<-lm(life2008$GDP~life2008$Polio + life2008$Alcohol +life2008$infant.deaths)
summary(model2008)
# d) Check the summary of the modelling results and the structure of output.
# e) Print out the coeficient for infant.deaths (use $ notation where possible)
model2008$coefficients['life2008$infant.deaths']
# f) Calculate the variance of the absolute difference between real GDP values 
# and the values fitted by your model (fitted.values element). Hint: use abs() function.
sd(abs(model2008$fitted.values- life2008$GDP))**2
length(model2008$fitted.values)
length(life2008$GDP)



###7

# 1. a) Using USArrests data (built-in dataset) draw a histogram to show the 
# distribution of the Assault variable.
hist(USArrests$Assault, labels = T, main = 'USA assault distribution')
# b) Add labels above the bins (check the documentation)
?hist
# c) Add a title "USA assault distribution" to the plot created in point 1a)

# 2. a) Load the insurance.csv dataset into R (medical cost folder) and name it 
# insurance. Check if data is properly loaded and the types of variables are correct.
insurance <- read.csv('insurance.csv')
# b) Convert sex variable into factor type.
insurance$sex<-factor(insurance$sex)
# c) Do the same to the smoker and region variables.
insurance$smoker<-factor(insurance$smoker)
insurance$region<-factor(insurance$region)
# 3. a) Using the insurance dataset prepare a correlation graph between age, 
# bmi and charges. When calling the columns use the indexing by column names. 
# Make it so that your graph is created by only one line of code. Use the 
# default parameters of corrplot function (don't change anything yet).
# Hint: use the corrplot() function from the corrplot package. You can assume
# that corrplot package in loaded in R.
# Hint 2: remember to draw the graph from the correlation table 
#made with the cor() functi
insurance[!complete.cases(insurance),]
corr <-cor(insurance[,c('age', 'bmi', 'charges')])
corrplot(corr, order = 'hclust')
# b) Arrange the variables on the graph using the order given by hierarchical
# clustering algorithm (hclust).
?corrplot
# c) Modify the plot that was created in b). Change the area of the graph so 
# that the lower triangle shows the numerical values and the upper triangle 
# shows the representation using circles. 
# Hint: look at the function corrplot.mixed(). 
?corrplot.mixed
corrplot.mixed(corr, lower = "number", upper = "circle", order = 'hclust')
# d) Prepare a boxplot of the variable charges by region. Change the axis 
# titles to "Medical charges" and "Region"
boxplot(insurance$charges~insurance$region, ylab = "Medical charges", xlab = "Region", )
# e) Modify the boxplot and add more styling to it. Name the axis, change 
# color of the elements, etc. Play with the arguments of plot function.
?boxplot



####8


# 1. a) Using USArrests data (built-in dataset) draw a histogram to show the 
# distribution of the Murder variable.
hist(USArrests$Murder)
# b) Select the Zissou1 palette from wesanderson and use a vector of 10 continuous 
# colours from this set to change the colour of the histogram bars.
# When submitting the answer you can assume that the package is already loaded.
hist(USArrests$Murder, col = wes_palette('Zissou1',10 ,'continuous'))
?wes_palette()
# c) Create a histogram for the Rape variable and color the bins with Moonrise1
# palette - discrete colours, vector with 4 colours, that will be reused in the plot.
hist(USArrests$Rape, col = wes_palette('Moonrise1', 4, 'discrete'))

# d) Change the graphical environment settings (two columns, one row)
par(mfrow = c(1,2))
# e) Draw the two graphs side by side. 
# f) reset the graphical environment
par(mfrow = c(1,1))
# 2. a) Load the insurance.csv dataset into R (medical cost folder) and name it 
# insurance. Check if data is properly loaded and the types of variables are correct.
# Convert sex, smoker and region variables into factor type.
# b) Prepare a boxplot of the variable charges by region. Change the axis 
boxplot(insurance$charges~insurance$region, ylab = "Medical charges", xlab = "Region")

# c) Change the colour of the 'boxes' according to the region and add an 
# appropriate legend. Use a palette viridis with 4 discrete colors. You can assume
# that the viridis package is loaded when submitting the answer.

boxplot(insurance$charges~insurance$region, ylab = "Medical charges", xlab = "Region", col = viridisdis(4))
legend('topleft', legend = levels(insurance$region), fill = viridis(4))
# d) Create a legend in the topright corner of the plot. Name the elements exactly
# as the names of the categories are shown in your plot. Hint: you can use the levels()
# function to get the names automatically.
# Make sure that the colours of your legend match the colours of the boxes.
# When submitting the answer provide just the line of code with legend creation.

# 3. a) Load the Tokyo 2021 dataset dataset from the olympic games folder 
# and store it in the games variable.
games<- read.csv('Tokyo 2021 dataset.csv')

# b) We will prepare a bar chart showing, in sequence, the ten countries that 
# have won the most silver Olympic medals. Start by creating a new dataset "silver10"
# that will store the 10 countries that have won the most Silver medals,
# and order that dataset by the Silver.Medal variable in decreasing order. First
# create a dataset sorted by the Silver Medal variable, and then limit it 
# to the first 10 observations only. Try to combine these steps and to this
# operation in one line only. Submit the shortest code that works for you.

games10<-head(games[order(games$Silver.Medal, decreasing = T),], 10)
View(games10)

# c) Using function barplot prepare a plot for the Silver Medal variable.
barplot(games10$Silver.Medal, names.arg = games10$NOCCode, main =  "Top 10 silver medals")

# d) Add lables under the bars (check the names.arg parameter in the barplot function)
# For the labels use the values of NOCCode function.
# e) Add title "Top 10 silver medals".
# f) Modify the style of the text, change the axis title. Add a chosen colour 
# palette and make the plot more interesting. Play with modification of different 
# plot elements. Export your plot to png file and name it by your 
# student ID number. Submit that plot to the test :)





###9

# 1. Write your own function "max75" that returns the 75% of the maximum value of a 
# given variable. You can assume that the variable is a numeric. Use the name 
# maximum75 for the temporary calculations done in the function.

# Use the template:

# ... <- ....{           # paste that in 1-definition field in the test
#    maximum75<-...      # paste that in 1-operation field in the test
# return(maximum75)      
#}

max75 <- function(variable){
  maximum75<- max(variable)*0.75
  return(maximum75)
}

max75(11)
# 2. Modify the loop so that it prints out only the values divisible by 3. 
# TIP: check out the %% symbol :)

for(j in seq(2,20,4)){
  if(j%%3 == 0) { # paste the condition that you wrote in the 2) field in the test
    print(j)
  }
}


# 3. Using the "next" instruction write a loop which will print out only the
# text values longer than 5 characters.

textVector <- c("Anna", "longitude", "bike", "car", "Sandra") 
?next
for(text in textVector){
  if(nchar(text) <=5){
    next
  }
    print(text)
  # write here the code will manipulate the loop execution
  # try to limit your code here to one line  (check out the TIP in line 190)

}
x<-'asnjsdas'
nchar(x)

# 4. You have a matrix like so:
myMatrix <- matrix(NA, nrow=10, ncol=10)
myMatrix[1,1]

for(i in 1:nrow(myMatrix)){
  myMatrix[,i] = i
}
myMatrix
# a) Create a loop which will go by row and fill in the values to look like this:
#      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]    1    2    3    4    5    6    7    8    9    10
# [2,]    1    2    3    4    5    6    7    8    9    10
# [3,]    1    2    3    4    5    6    7    8    9    10
# [4,]    1    2    3    4    5    6    7    8    9    10



# b) Write a loop which will reassign the values within myMatrix to look like this:
#       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]     2    3    4    5    6    7    8    9   10    11
# [2,]     3    4    5    6    7    8    9   10   11    12
# [3,]     4    5    6    7    8    9   10   11   12    13
# [4,]     5    6    7    8    9   10   11   12   13    14
# [5,]     6    7    8    9   10   11   12   13   14    15
# [6,]     7    8    9   10   11   12   13   14   15    16
# [7,]     8    9   10   11   12   13   14   15   16    17
# [8,]     9   10   11   12   13   14   15   16   17    18
# [9,]    10   11   12   13   14   15   16   17   18    19
# [10,]   11   12   13   14   15   16   17   18   19    20

for(i in 1:ncol(myMatrix)){
  for(j in 1:nrow(myMatrix)){
    myMatrix[j,i] = j+i
  }
}
myMatrix
# Use the following template:

# for(row in 1:nrow(myMatrix)){
#   for(col in 1:ncol(myMatrix)){
#     .... # paste your code for the body of the loop in the 4b) field in the test
#   }
# }


# c) Write a loop similar to the one in b) that will now reassign the values of 
# the matrix to look like this

# [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]    1    2    3    4    5    6    7    8    9    10
# [2,]    2    4    6    8   10   12   14   16   18    20
# [3,]    3    6    9   12   15   18   21   24   27    30
# [4,]    4    8   12   16   20   24   28   32   36    40
# [5,]    5   10   15   20   25   30   35   40   45    50
# [6,]    6   12   18   24   30   36   42   48   54    60
# [7,]    7   14   21   28   35   42   49   56   63    70
# [8,]    8   16   24   32   40   48   56   64   72    80
# [9,]    9   18   27   36   45   54   63   72   81    90
# [10,]   10   20   30   40   50   60   70   80   90   100



# 5. Write a function myMulti which will create a matrix with multiplication 
# table of size n x n, where n will be the argument of your function.

# Use the following template for writing your answer:




myMulti<- function(n){
  mtx<- matrix(NA, ncol = n, nrow = n)
  for(i in 1:n){
    for(j in 1:n){
      mtx[j,i] = j*i
    }
  }
return(mtx)
}



myMulti(3)





# myMulti <- ...... # paste the code from this line to slot 5a) in the test
#   myMatrix <- 
#   for(......)
#     for(........)
#        myMatrix....... # paste the code from this line to slot 5b) in the test
#   .....
#   return(...)


# 6. Write a function which will take a text vector of package names from CRAN
# and will check if they are installed. If not - it will install them and load them,
# and if they are already installed - the function will just load them. 



### 11


# 1. Read the gapminder_full data to a tibble format (use readr package). Name 
# the variable "gapminder". 
library(dplyr)
library(tidyverse)
gapminder <- read_csv("gapminder_full.csv")
gapminder
# 2. Filter the dataset to get information on 1962 year only. 
# Please use the pipeline operator. 
gapminder %>% filter(year ==1962)
# 3. Create a new variable population1000 which will store the population numbers 
# in thousands. Use the mutate command and save the result to your dataset. 
# TIP: Divide raw numbers by 1000. 
gapminder %>% mutate(population1000 = population/1000)
# 4. Prepare a summary table which will sore the median population count on 
# each continent. Use one line of code with pipeline operators. 
# TIP: use group_by, and then summarize(). 
gapminder %>% group_by(continent) %>% summarize(median(population, na.rm = T))
gapminder$continent <- factor(gapminder$continent)
# 5. In the full dataset prepare a variable maxCountry which will store the maximum 
# gdp value obtained for a specific country in the whole researched period.
# TIP: use group_by, and then mutate to do the calculations in groups. 
# Remember to ungroup your data at the end and store the result in the dataframe.
gapminder <-gapminder %>% group_by(country) %>% mutate(maxCountry = max(gdp_cap)) %>% ungroup()
# 6. Using previously created variable show for each country in each year 
# the gdp reached its maximum. 
# TIP: you can use comparison between gdp_cap and maxCountry variable
gapminder %>% group_by(country) %>% filter(maxCountry == gdp_cap) %>% select(country, year)
# 7. Add a sorting step to the codes from the previous task. Arrange the filtered
# data to see for which country the maximum gdp was in the furthest moment of time.
# You will see which countries "developed backwards"
gapminder %>% group_by(country) %>% filter(maxCountry == gdp_cap) %>% select(country, year) %>% arrange(year)
