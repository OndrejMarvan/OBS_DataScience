################################################################################
#######################  Maria Kubara, PhD #####################################
########################## RIntro 2025/26 ######################################
############################ Class 13 ##########################################
################################################################################


# changing the language to English
Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

################################################################################

### Loading pre-processed data #################################################

library(tidyverse)


load("data/datasetsTidyr.RData")
# Includes four datasets:
# onePanel and twoPanel for lecture showcase
# onePanelTask to be used in practice tasks
# tidyrData dataset for tidyr showcase and practice



### Pivoting data - one variable ###############################################

onePanel # one variable, 3 places, 3 years
# data in a wide form



# In case of one variable the job is simple, we just need to specify
# which columns we would like to pivot

onePanel %>% pivot_longer(cols = c("2011", "2012", "2013")) # specify what to use

onePanel %>% pivot_longer(cols = starts_with("20")) # specify what to use with pattern

onePanel %>% pivot_longer(cols = !City) # all but City, which identifies observations



# More parameters can be added to better control the shape of the output data

onePanel %>% pivot_longer(cols = c("2011", "2012", "2013"),
                          names_to = "year", values_to = "profit")

# For more variables it is a bit more tricky, but still doable :)



### Pivoting data - two variables + separate function ##########################

twoPanel # we have two values across 3-year time horizon
# names of the variables follow the same pattern
# first lets make the data long (as long as we can, we will fix it later)

twoPanel %>% pivot_longer(cols = !City) # we pivot all columns except for City



# now we can see that there is too much information carried in the variable name
# we have both year and type of the variable that defines our observations across time

# we will use the function separate (from tidyr) to divide this information
twoPanel %>% pivot_longer(cols = !City) %>% 
  separate(col = "name",  # which variable do we divide
           into = c("type", "year"),  # that will be the names of the new variables
           sep = "_") # what is the separator between names



# now we can clearly see that data is in the "super long" form
# we can make it simpler by moving Profit and People into their own variables
# for that we will use pivot_wider function

twoPanel %>% pivot_longer(cols = !City) %>% 
  separate(col = "name", into = c("type", "year"), sep = "_") %>% 
  pivot_wider(id_cols = c("City", "year"), 
              # we need to specify the columns which allow for unique identification 
              # of observations, here pair: year and place
              names_from = "type",  # where do we take the names from for the columns 
              values_from = "value") # where do we take the values from



# Now data is in a good form, we can save the result into a new variable

organisedTwoPanel <- twoPanel %>% pivot_longer(cols = !City) %>% 
  separate(col = "name", into = c("type", "year"), sep = "_") %>% 
  pivot_wider(id_cols = c("City", "year"), 
              # we need to specify the columns which allow for unique identification 
              # of observations, here pair: year and place
              names_from = "type",  # where do we take the names from for the columns 
              values_from = "value") # where do we take the values from

organisedTwoPanel



### Practice with separate and unite ###########################################

# Let's practice more with the tidyr functions
# We will use unite to combine data into one variable
# and then separate to revert the changes

tidyrData # for practice purposes we will unite information from weight and unit

tidyrData %>% unite(col = "weight_unit", # name of the new column
                     weight, unit, # names of columns to be united
                     sep = " ", # separator between values (default _)
                     remove = TRUE) # remove the original values used for uniting

# now in our dataset we have a new column weight_unit which stores both pieces of information


# Let's save this dataset and practice the separate function with it 
united <- tidyrData %>% unite(col = "weight_unit", # name of the new column
                    weight, unit, # names of columns to be united
                    sep = " ", # separator between values (default _)
                    remove = TRUE) # remove the original values used for uniting


# Separate works in a similar way as unite:
united2 <- united %>% separate(col = "weight_unit", # what are we separating
                    into = c("weight", "unit"), # into which variables we are transforming
                    sep = " ", # what is the separator between values 
                    remove = FALSE) # do not remove the original variable

united2

# Actually it would be best to just put the unit in the name of the variable
# or in the description of the dataset, as we don't have any variation in this 
# value. This variable is then redundant. Let's clean the data

united2 %>% select(-c("weight_unit", "unit")) %>% # remove these variables here
  rename(weight_in_kg = weight) # change the name of the variable to account for the untis
  
# if we are satisfied with the result we can update the tidyrData to its new shape

tidyrData <- united2 %>% select(-c("weight_unit", "unit")) %>% # remove these variables here
  rename(weight_in_kg = weight) # change the name of the variable to account for the untis

tidyrData



### Missing value handling with tidyr ##########################################

# we have three main functions for missing data handling in tidyr
# drop_na() to remove rows with missing data
# fill() to automatically fill the missings basing on the neighbouring information
# replace_na() to specify the rule for NA replacement



# drop_na() allows to remove the rows with missing values form the dataset

tidyrData %>% drop_na() # all rows affected by missings were removed

tidyrData %>% drop_na(favMovie) # rows with missing in favMovie were removed



# fill() - useful function for handling text missing data, to fill in the gaps

?fill #fill missing based on the values that are near
tidyrData %>% select(favMovie) # three missing values in rows 2,3 and 6

tidyrData %>% fill(favMovie) # using the default parameters values were filled
# using what was above (1st row data duplicated in rows 2 and 3, and value from 5th row moved to the 6th)

tidyrData %>% fill(favMovie, .direction = "up") # changing the direction of replacing
# now data from 4th row moved to 2nd and 3rd, and data from 7th replicated in 6th



# replace_na()

tidyrData$favMovie %>% replace_na("no movie") # works very well on vectors

# for data.frames or tibbles it requires a list with specification 
# what to do with missings across different column
tidyrData %>% replace_na(list(favMovie = "no movie", # replacing for favMovie
                              favItalianDish = "no dish")) # replacing for favDish



### Nested columns - basic navigation ##########################################

# tibbles allow for storing lists within the column
# it broades the possibilities of storing data in R, especially in tabular form
# for example for spatial data in sf:: package, this property is used to represent
# spatial data in rows - all features are in standard columns, and the spatial properties
# are moved to the nested list column which stores all the specificities of the shape,
# geometry, coordinates, etc. 

# From our point of view it is important to understand how to extract nested
# information form the dataframes. If you remember that these nested columns 
# are in fact just lists, it will be much easier to operate with them. 



# Let's see the example

tidyrData # we have two nested columns - favFruit and favAnimal
# they store tibbles inside, and the type of these columns is shown as "list"

tidyrData$favAnimal %>% class() # if we check it with base function, the same appears



# how this data looks like:

tidyrData %>% select(favAnimal) 
# we see that these values are tibbles with one row and two columns each

tidyrData$favAnimal # in base R printing they are just a list with tibbles inside



# how to extract this data, knowing that it is a list?
tidyrData$favAnimal[1] # fraction of a list -> list from the first position, first box

tidyrData$favAnimal[[1]] # insides of the first list element -> inside of the first box, a tibble

tidyrData$favAnimal[[1]][1,2] # second element stored in this tibble, information from the second column



# in tidyr we have unnest() function which allows for extracting these data from lists

tidyrData %>% select(favAnimal) 

tidyrData %>% select(favAnimal) %>% unnest(cols = c(favAnimal)) 
# unnest extends this data by dropping the first level of complexity from the list
# extracts individual list elements and here transforms them to rows in the tibble



tidyrData %>% unnest(cols = c(favAnimal)) # if we do it on a full dataset we can see
# that this unnested tibble is enhancing our dataset now


# Nesting is a really important feature, which allows for fitting otherwise 
# non-tabular data into tabular format (which is easier for processing). 
# it is also used in grouping with group_by. 

# This section was just to present this idea and show how to operate with it 
# on the basic level. More details will be discussed next semester or 
# can be found in tidyverse tutorials and vignettes. 

# Unless dealing with very specific data, you will rarely see nested variables. 
# It is just important that you understand why they are here, and how they are
# implemented on the general level. So that when they occur (sometimes even from
# the faulty data reading from some specific sources), you will know where 
# to look for helpful functions and guidance. 



### Tasks ######################################################################

### IMPORTANT! In these tasks please use tidyverse functions whenever possible!!!
### Use the pipeline notation!

# 1. Using the onePanelTask dataset transform wide panel data to long format.
# name the numerical variable "Sales" and the time variable "Year". Try to do all 
# these transformations in just one function in one line. 

onePanelTask %>% pivot_longer(cols = -1, names_to = "Year", values_to = "Sales")

# 2. Fill in the missing values in favItalianDish variable from the tidyrData to "pizza".
# Make sure that you are not making any changes in the favMovie variable. 
# Use tidyr function for that. 

tidyrData %>% replace_na(list(favItalianDish = "pizza"))

# 3. Unite information from the year, month, day columns in tidyrData. Name 
# the created variable as "birthday" and convert it to Date type (as.Date)

tidyrData %>% 
  unite(col = "birthday", year, month, day, sep = "-") %>% 
  mutate(birthday = as.Date(birthday))

# 4. Extract the third favourite fruit of the person with ID equal to 3. 

tidyrData$favFruit[[3]][3, 1]

# Explanation:
# [[3]] selects the nested tibble for the 3rd person.
# [3, 1] selects the 3rd row (3rd fruit) and the 1st column (fruit name) of that nested tibble.
