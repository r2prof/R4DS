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







