################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 12 ##########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Getting into the tidyverse #################################################

#library(tidyverse) # loading a full set of all tidyverse packages

library(dplyr) # data manipulation package -> the only one we need today 

# Read life expectancy data
# You can use a standard function read.csv

life <- read.csv("~/Documents/GitHub/OBS_DataScience/OBS_DataScience/Autumn 2025/2400-DS1R R intro, data cleaning and imputation R,  basics of visualisation/data/dataset - life expectancy/Life Expectancy Data.csv")
head(life)
class(life) # data.frame format

# Or load readr package and use read_csv function

library(readr)
life.readr <- read_csv("data/dataset - life expectancy/Life Expectancy Data.csv")

# this function is definitely louder! It gives you much more feedback on the 
# things that happen in the background. This can be a good or a bad thing :)
# You can also make it "quieter" by using suppressMessages function

life.readr <- suppressMessages(read_csv("data/dataset - life expectancy/Life Expectancy Data.csv"))

head(life.readr) # new way of printing data! 
class(life.readr) # tibble class, which extends the possibilities of a data.frame

# We can use glimpse function to learn more about the data structure

glimpse(life.readr)
glimpse(life)


# You can easily transform a data.frame to a tibble

life2 <- as_tibble(life) # see how the underscore is used here instead of a dot!
# This is a common thing in tidyverse packages, underscore _ is used to specify
# the general family of functions that a method belongs to.

head(life2) # now our dataset is a tibble, its way of printing changes



### Dplyr - general info #######################################################

# The package dplyr contains functions for efficient processing
# of data in R - they work very fast also on large datasets

# That's why the package is currently a standard in the R-world
# and is a part of "tidyverse" - the universe of packages 
# developed by RStudio (for more information https://www.tidyverse.org/).

# The dplyr package tries to follow SQL language scheme.

# Let's get to some basic functions:
# - filter() - is used to select observations that meet
#               the specified conditions,
# - select() - select columns,
#    inside select() one can use:
#         contains()
#         starts_with()
#         ends_with()
# - rename() - allows you to rename columns,
# - arrange() - is used to sort data,
# - mutate() - is used to create new variables.
# - glimpse() - show structure of the data (alternative to str())
# - group_by() - is used to split data into groups using
#                selected columns (allows analysis in subgroups)
# - summarise() - summarizes data
#   inside summarise one can use for example:
#       n() - number of observations
#       n_distinct() - number of unique values
#       sample_n() - random sample (w/o replacement) - n elements
#       sample_frac() - random sample (w/o replacement) - fraction

# Each of these functions as the first argument expects 
# a data frame. Further arguments often require providing
# column names, which in these functions are NOT put in quotes.

# for more details see here:
# https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html
# http://dplyr.tidyverse.org/



### Dplyr - select #############################################################

colnames(life2)

# Let's select some initial variables

life2[,c("Country")] # standard way

select(life2, Country) # use of the select function

life2 %>% select(Country) # use of the pipeline operator
# it makes the previous element flow to the following function



# If we want to get more variables:

life2[,c("Country", "Year")]

?select # we have ... sign, we can put more names here

select(life2, Country, Year)
life2 %>% select(Country, Year)



# Select works on data.frames as well
life %>% select(Country)

life %>% select(Country) %>% head() # we can use head to limit the printout in the console

# output from the select command is a data.frame



# Compare these codes:
life %>% select(Country) %>% class() # data.frame
life[,"Country"] %>% class() # character vector
life$Country %>% class() # character vector

life2 %>% select(Country) %>% class() # tibble
life2[,"Country"] %>% class() # still a tibble!
life2$Country %>% class() # character vector

# Important! If you limit a tibble, your result will be still a tibble. 
# Functions which operate on vectors will need to be used in a bit more careful way.



# More examples of select
colnames(life2)

life2 %>% select(Country, Year, Status)
life2 %>% select(Country:Status) # range of values

life2 %>% select(starts_with("P")) # additional function -> select based on name string
life2 %>% select(ends_with("deaths"))
life2 %>% select(contains("co"))



### Dplyr - filter #############################################################

life2[life2$Country=="Poland",]

# Filter takes dataset and then the condition that needs to be met
filter(life2, Country == "Poland")

# it's like subset function, but filter is much more flexible
# subset(life2, Country == "Poland")



# filter can take more conditions
# in this case ALL should be met
filter(life2, Country == "Poland", Year > 2008)



# now we can build longer chains of code with the pipeline operator
life2 %>% filter(Country == "Poland", Year > 2008) %>% 
  select(Country, Year, BMI)

# without pipes:
select(filter(life2, Country == "Poland", Year > 2008), Country, Year, BMI)

# other notation:
life2[life2$Country == "Poland" & life2$Year > 2008, c("Country", "Year", "BMI")]

# You can choose what is more comfortable for you :)



### Dplyr - mutate #############################################################

# mutate allows for creating additional variables in the dataset
# the rule is -> specify the name of the new variable first, 
# and then specify which data should come there 

# warning! If you want your variable to be saved in the dataset you need to 
# use the assignment sign!

life2 %>% mutate(infant_adult_mortality = infant.deaths/Adult.Mortality) %>% 
  # we create a new variable using information already existing in the dataset
  select(Country, Year, Status, infant_adult_mortality)

colnames(life2) # our result was not saved -> the calculations were only done ad hoc

# if we want our change to be permanent, we need to save it to the dataset

life2 <- life2 %>% mutate(infant_adult_mortality = infant.deaths/Adult.Mortality) %>% 
  select(Country, Year, Status, infant_adult_mortality)

# Sometimes this notation is used with pipelines
life2 %>% mutate(infant_adult_mortality = infant.deaths/Adult.Mortality) %>% 
  select(Country, Year, Status, infant_adult_mortality) -> life2 # saving at the end
# this notation only works with arrows!

# Personally I don't recommend this notation, as it can be a bit misleading. 
# But, as always, you can choose what works for you.



# Ad hoc calculations are commonly used with pipes when some modifications are 
# needed in the data just for reporting purposes
# Sometimes there is no need to save the result in the main dataset (e.g. when
# we just want to calculate some statistic for a specific subset of data)

life2 %>% filter(Country == "Poland", Year > 2008) %>% 
  select(Country, Year, BMI) %>% 
  mutate(BMI_variation = BMI/mean(BMI)) 
# see how these calculations use only the context of this subset -> mean calculated
# here is only corresponding to the BMI values for Poland, in years 2009-2015


# We can use rename() to change the name of our variables
# rule: new first, older second.

life2 %>% filter(Country == "Poland", Year > 2008) %>% 
  select(Country, Year, BMI) %>% 
  mutate(BMI_variation = BMI/mean(BMI)) %>% 
  rename(BMI_to_mean = BMI_variation) # here the change is applied to the variable
# created in the previous step -> this improves the way the report table is presented





### Dplyr - summarize ##########################################################

# Summarize function extends the possibilities of preparing nice raport tables

# Let's create it step by step:
mean(life2$BMI)

mean(life2$BMI, na.rm=T)

# standard issue with the missing data
summarize(life2, mean(BMI))

summarize(life2, mean(BMI, na.rm=T)) # now it is reported but the printout is rather ugly...

summarize(life2, meanBMI = mean(BMI, na.rm=T)) # we can label the results

summarize(life2, meanBMI = mean(BMI, na.rm=T),
          sdBMI = sd(BMI, na.rm=T)) # we can also add more statistics


# Now, this is not saying much about our data. We have information
# across countries and years, which we can use to create a more comprehensive
# information about what's really going on in the dataset.

# For that, we will need to use group_by :)



### Dplyr - group_by ###########################################################

# let's start the grouping by Status variable (only two levels)
life2_grouped <- life2 %>% group_by(Status)

life2_grouped # we can see that Groups appear in the tibble printout
class(life2_grouped) # we have a new class -> grouped_df

# Now, if we try to use summarize, the results will be split across categories
summarize(life2_grouped, meanBMI = mean(BMI, na.rm=T)) 
# This happens, because after grouping our dataset is processed separately across
# categories. Here, the mean is calculated in the Developed and in the Developing
# group separately. 
# The result is also presented in this way. 

# Let's use the pipes to create a flow
life2 %>% group_by(Status) %>% 
  summarize(meanBMI = mean(BMI, na.rm=T)) # we got to the same result

life2 %>% group_by(Status) %>% 
  summarize(meanBMI = mean(BMI, na.rm=T),
            sdBMI = sd(BMI, na.rm=T)) # we can use more statistics

life2 %>% group_by(Year, Status) %>% 
  summarize(meanBMI = mean(BMI, na.rm=T),
            sdBMI = sd(BMI, na.rm=T)) 
# and prepare cross-comparison tables with more categories

life2 %>% group_by(Year, Status) %>% 
  summarize(meanBMI = mean(BMI, na.rm=T),
            sdBMI = sd(BMI, na.rm=T),
            inCategory = n()) # commonly used function n() to get counts in categories



# Group_by can be used for preparing new variables, which results will differ
# across categories. 

life2 %>% group_by(Status) %>% 
  mutate(BMI_mean_inGroup = mean(BMI, na.rm=T)) %>% 
  select(Country, Year, Status, BMI, BMI_mean_inGroup) %>% 
  filter(Year == 2011) # filtering needed to show that the result differers across categories

# Still, our data is grouped. If we would like to go back to the standard way
# of processing a tibble we need to use ungroup() function.

life2 %>% group_by(Status) %>% 
  mutate(BMI_mean_inGroup = mean(BMI, na.rm=T)) %>% 
  select(Country, Year, Status, BMI, BMI_mean_inGroup) %>% 
  filter(Year == 2011) %>% 
  ungroup() # now the tibble is ungrouped 

# Again, if we want to save the result we need to use assignment sign

life2 <- life2 %>% group_by(Status) %>% 
  mutate(BMI_mean_inGroup = mean(BMI, na.rm=T)) %>% 
  ungroup() # now the tibble is ungrouped 

glimpse(life2)



### Dplyr - arrange ############################################################

# We can change the way the data is presented by reordering the values
# for that we have dplyr command arrange

life2 # Arranged by country, and then Year (descending)

life2 %>% arrange(Country) # no change - by Country, ascending (alphabetic) order

life2 %>% arrange(Year) # arranged by year now, ascending order

life2 %>% arrange(Country, Year) #first by country, then ordered by year, ascending

life2 %>% arrange(Country, desc(Year)) #first by country, then ordered by year, descending 
# like in original data :)



### Side note on pipeline operator #############################################

# Normally, the pipeline allows to move the result from the previous operator
# to the first place in a given function (in tidyverse: exactly where the data should be)

# But we can control the behaviour of pipes with the dot symbol

# These codes return the same results:
runif(10) %>% 
  plot( y = 1:10)

runif(10) %>% 
  plot(., y = 1:10)

runif(10) %>% 
  plot(x =., y = 1:10)


# Here we can change the plot by placing a dot in a different place
runif(10) %>% 
  plot(x = 1:10, y = .)


# We can use the dot to get a vector out of a column in a tibble

# compare the results
life2 %>% .["BMI"] # tibble object
life2 %>% .[["BMI"]] # vector

# the function mean() will not work
# on the data frame (or tibble object)

mean(life2 %>% .["BMI"], na.rm=T)

# but works for a vector (numeric or logical)

mean(life2 %>% .[["BMI"]], na.rm=T)



### Tasks ######################################################################

### IMPORTANT! In these tasks please use tidyverse functions whenever possible!!!
### Use the pipeline notation!

# 1. Read the gapminder_full data to a tibble format (use readr package). Name 
# the variable "gapminder". 

# 2. Filter the dataset to get information on 1962 year only. 
# Please use the pipeline operator. 

# 3. Create a new variable population1000 which will store the population numbers 
# in thousands. Use the mutate command and save the result to your dataset. 
# TIP: Divide raw numbers by 1000. 

# 4. Prepare a summary table which will sore the median population count on 
# each continent. Use one line of code with pipeline operators. 
# TIP: use group_by, and then summarize(). 

# 5. In the full dataset prepare a variable maxCountry which will store the maximum 
# gdp value obtained for a specific country in the whole researched period.
# TIP: use group_by, and then mutate to do the calculations in groups. 
# Remember to ungroup your data at the end and store the result in the dataframe.

# 6. Using previously created variable show for each country in each year 
# the gdp reached its maximum. 
# TIP: you can use comparison between gdp_cap and maxCountry variable

# 7. Add a sorting step to the codes from the previous task. Arrange the filtered
# data to see for which country the maximum gdp was in the furthest moment of time.
# You will see which countries "developed backwards".


