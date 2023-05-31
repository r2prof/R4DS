#-----------------------
# CH 12 - Tidy Data
#-----------------------
# 12.1.1 Prerequisites
#-----------------------
# In this chapter we’ll focus on tidyr, a package that provides a bunch of tools to help tidy up 
# your messy datasets. tidyr is a member of the core tidyverse.
library(tidyverse)
#
#-----------------------
# 12.2 Tiday Data
#-----------------------
# The example below shows the same data organised in four different ways. Each dataset shows the 
# same values of four variables country, year, population, and cases, but each dataset organises 
# the values in a different way.
table1
table2
table3
# Spread across two tibbles
table4a  # cases
table4b  # population
#
# There are three interrelated rules which make a dataset tidy:
#
# 1. Each variable must have its own column.
# 2. Each observation must have its own row.
# 3. Each value must have its own cell.
# 
# These three rules are interrelated because it’s impossible to only satisfy two of the three. 
# That interrelationship leads to an even simpler set of practical instructions:
#
# 1. Put each dataset in a tibble.
# 2. Put each variable in a column.
#
# In this example, only table1 is tidy. It’s the only representation where each column is a variable.
# There’s a specific advantage to placing variables in columns because it allows R’s vectorised nature 
# to shine. As you learned in mutate and summary functions, most built-in R functions work with vectors 
# of values. That makes transforming tidy data feel particularly natural.
# 
# dplyr, ggplot2, and all the other packages in the tidyverse are designed to work with tidy data. Here are 
# a couple of small examples showing how you might work with table1.
#
# Compute rate per 10,000
table1 %>% 
  mutate(rate = cases / population * 10000)
#
# Compute cases per year
table1 %>% 
  count(year, wt = cases)
#
# # Visualise changes over time
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))
#
#----------------------------------------------
# 12.2.1 Exercises
#----------------------------------------------
# 1. Using prose, describe how the variables and observations are organised in each of the sample tables.
# 
# 2. Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
#   a. Extract the number of TB cases per country per year.
#   b. Extract the matching population per country per year.
#   c. Divide cases by population, and multiply by 10000.
#   d. Store back in the appropriate place.
# Which representation is easiest to work with? Which is hardest? Why?
#   
# 3. Recreate the plot showing change in cases over time using table2 instead of table1. 
#    What do you need to do first?
#----------------------------------------------  
# 12.3 Pivoting
#----------------------------------------------
# The first step is always to figure out what the variables and observations are. Sometimes this is easy; 
# other times you’ll need to consult with the people who originally generated the data. The second step is 
# to resolve one of two common problems:
#   
# 1. One variable might be spread across multiple columns.
# 2. One observation might be scattered across multiple rows.
# 
# Typically a dataset will only suffer from one of these problems; it’ll only suffer from both if you’re 
# really unlucky! To fix these problems, you’ll need the two most important functions in tidyr: pivot_longer() 
# and pivot_wider().
#
#--------------------------------
# 12.3.1 Longer
#-------------------------------
# A common problem is a dataset where some of the column names are not names of variables, but values of a 
# variable. Take table4a: the column names 1999 and 2000 represent values of the year variable, the values in 
#the 1999 and 2000 columns represent values of the cases variable, and each row represents two observations, 
# not one.

table4a
#
# To tidy a dataset like this, we need to pivot the offending columns into a new pair of variables. 
# To describe that operation we need three parameters:
#
# The set of columns whose names are values, not variables. 
# In this example, those are the columns 1999 and 2000.
# The name of the variable to move the column names to. Here it is year.
# The name of the variable to move the column values to. Here it’s cases.
#
# Together those parameters generate the call to pivot_longer():
table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
#
# The columns to pivot are specified with dplyr::select() style notation. Here there are only two columns, 
# so we list them individually. Note that “1999” and “2000” are non-syntactic names (because they don’t start 
# with a letter) so we have to surround them in backticks. To refresh your memory of the other ways to select 
# columns, see select year and cases do not exist in table4a so we put their names in quotes.
#
# In the final result, the pivoted columns are dropped, and we get new year and cases columns. Otherwise, the 
# relationships between the original variables are preserved. Visually, this is shown in Figure 12.2.
# pivot_longer() makes datasets longer by increasing the number of rows and decreasing the number of columns. 
#
# I don’t believe it makes sense to describe a dataset as being in “long form”. Length is a relative term, and 
# you can only say (e.g.) that dataset A is longer than dataset B.
#
# We can use pivot_longer() to tidy table4b in a similar fashion. The only difference is the variable stored 
# in the cell values:
table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
#
# To combine the tidied versions of table4a and table4b into a single tibble, we need to use 
# dplyr::left_join(), which you’ll learn about in relational data.
#
tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
left_join(tidy4a, tidy4b)
#
#---------------------------
#  12.3.2 Wider
#---------------------------
# pivot_wider() is the opposite of pivot_longer(). You use it when an observation is scattered across 
# multiple rows. For example, take table2: an observation is a country in a year, but each observation 
# is spread across two rows.
table2
#
# To tidy this up, we first analyse the representation in similar way to pivot_longer(). This time, however, 
# we only need two parameters:
#
# The column to take variable names from. Here, it’s type.
# The column to take values from. Here it’s count.
#
# Once we’ve figured that out, we can use pivot_wider(), as shown programmatically below, and visually in 
# Figure 12.3.
table2 %>%
  pivot_wider(names_from = type, values_from = count)
#
# As you might have guessed from their names, pivot_wider() and pivot_longer() are complements. 
# pivot_longer() makes wide tables narrower and longer; pivot_wider() makes long tables shorter and wider.

























