#-----------------------------
# 5 - Data transformation
#-----------------------------
# 5.1 Introdution
#-----------------------------

# Visualisation is an important tool for insight generation, but it is rare that you get the data 
# in exactly the right form you need. Often you’ll need to create some new variables or summaries, 
# or maybe you just want to rename the variables or reorder the observations in order to make the 
# data a little easier to work with. You’ll learn how to do all that (and more!) in this chapter, 
# which will teach you how to transform your data using the dplyr package and a new dataset on 
# flights departing New York City in 2013.

library(nycflights13)
library(tidyverse)

# Take careful note of the conflicts message that’s printed when you load the tidyverse. 
# It tells you that dplyr overwrites some functions in base R. If you want to use the base 
# version of these functions after loading dplyr, you’ll need to use their full names: 
# stats::filter() and stats::lag().

# 5.1.2 nycflights13
#-----------------------------

# To explore the basic data manipulation verbs of dplyr, we’ll use nycflights13::flights. 
# This data frame contains all 336,776 flights that departed from New York City in 2013. 
# The data comes from the US Bureau of Transportation Statistics, and is documented in: 

?flights

# Lets load the data:
flights

View(flights)


# You might notice that this data frame prints a little differently from other data frames 
# you might have used in the past: it only shows the first few rows and all the columns that 
# fit on one screen. (To see the whole dataset, you can run View(flights) which will open the 
# dataset in the RStudio viewer). 
# 
# It prints differently because it’s a tibble. 
# Tibbles are data frames, but slightly tweaked to work better in the tidyverse. For now, you 
# don’t need to worry about the differences; we’ll come back to tibbles in more detail in wrangle.
# 
# You might also have noticed the row of three (or four) letter abbreviations under the column names. 
# These describe the type of each variable:

# int stands for integers.
# 
# dbl stands for doubles, or real numbers.
# 
# chr stands for character vectors, or strings.
# 
# dttm stands for date-times (a date + a time).
# 
# There are three other common types of variables that aren’t used in this dataset but you’ll 
# encounter later in the book:
#   
# lgl stands for logical, vectors that contain only TRUE or FALSE.
# 
# fctr stands for factors, which R uses to represent categorical variables with fixed possible values.
# 
# date stands for dates.

# 5.1.3 dplyr basics
#-----------------------------
# In this chapter you are going to learn the five key dplyr functions that allow you to 
# solve the vast majority of your data manipulation challenges:
#   
# Pick observations by their values (filter()).

# Reorder the rows (arrange()).

# Pick variables by their names (select()).

# Create new variables with functions of existing variables (mutate()).

# Collapse many values down to a single summary (summarise()).

# These can all be used in conjunction with group_by() which changes the scope of each 
# function from operating on the entire dataset to operating on it group-by-group. 

# These six functions provide the verbs for a language of data manipulation.
# 
# All verbs work similarly:
#   
# The first argument is a data frame.
# 
# The subsequent arguments describe what to do with the data frame, using the variable names (without quotes).
# 
# The result is a new data frame.
# 
# Together these properties make it easy to chain together multiple simple steps to achieve a complex result. 
# Let’s dive in and see how these verbs work.
