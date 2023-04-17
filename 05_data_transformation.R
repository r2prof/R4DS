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

# 5.2 Filter rows with filter()
#-------------------------------
# filter() allows you to subset observations based on their values. 
# The first argument is the name of the data frame. 
# The second and subsequent arguments are the expressions that filter the data frame. 
# For example, we can select all flights on January 1st with:
filter(flights, month == 1, day == 1)

# When you run that line of code, dplyr executes the filtering operation and returns a new data frame. 
# dplyr functions never modify their inputs, so if you want to save the result, you’ll need to use the 
# assignment operator, <-:

jan1 <- filter(flights, month == 1, day == 1)

# R either prints out the results, or saves them to a variable. 
# If you want to do both, you can wrap the assignment in parentheses:
(dec25 <- filter(flights, month == 12, day == 25))

# 5.2.1 Comparisons
#-------------------------
# To use filtering effectively, you have to know how to select the observations that you want using 
# the comparison operators. 

# R provides the standard suite: >, >=, <, <=, != (not equal), and == (equal).

# When you’re starting out with R, the easiest mistake to make is to use = instead of == when testing 
# for equality. 

# When this happens you’ll get an informative error:
filter(flights, month = 1)

# There’s another common problem you might encounter when using ==: floating point numbers. 
# These results might surprise you!

sqrt(2) ^ 2 == 2

1 / 49 * 49 == 1

# Computers use finite precision arithmetic (they obviously can’t store an infinite number of digits!) 
# so remember that every number you see is an approximation. Instead of relying on ==, use near():

near(sqrt(2) ^ 2,  2)

near(1 / 49 * 49, 1)

# 5.2.2 Logical operators
#----------------------------------
# Multiple arguments to filter() are combined with “and”: every expression must be true in order 
# for a row to be included in the output. 

# For other types of combinations, you’ll need to use Boolean operators yourself: & is “and”, 
# | is “or”, and ! is “not”. 

# The following code finds all flights that departed in November or December:
  
filter(flights, month == 11 | month == 12)

# The order of operations doesn’t work like English. 

# You can’t write filter(flights, month == (11 | 12)), which you might literally translate into
# “finds all flights that departed in November or December”. 

# Instead it finds all months that equal 11 | 12, an expression that evaluates to TRUE. 

# In a numeric context (like here), TRUE becomes one, so this finds all flights in January, not 
# November or December. This is quite confusing!

# A useful short-hand for this problem is x %in% y. This will select every row where x is one of 
# the values in y. We could use it to rewrite the code above:
nov_dec <- filter(flights, month %in% c(11, 12))

# Sometimes you can simplify complicated subsetting by remembering De Morgan’s law: 
# !(x & y) is the same as !x | !y, and 
# !(x | y) is the same as !x & !y. 

# For example, if you wanted to find flights that weren’t delayed (on arrival or departure) by more 
# than two hours, you could use either of the following two filters:

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# As well as & and |, R also has && and ||. Don’t use them here! You’ll learn when you should use 
# them in conditional execution.

# Whenever you start using complicated, multipart expressions in filter(), consider making them 
# explicit variables instead. That makes it much easier to check your work. 

# You’ll learn how to create new variables shortly.

# 5.2.3 Missing values
# ------------------------
# One important feature of R that can make comparison tricky are missing values, or NAs (“not availables”). 
# NA represents an unknown value so missing values are “contagious”: almost any operation involving an unknown
# value will also be unknown.

NA > 5
10 == NA
NA + 10
NA / 2

# The most confusing result is this one:
NA == NA

# It’s easiest to understand why this is true with a bit more context:

# Let x be Mary's age. We don't know how old she is.
x <- NA

# Let y be John's age. We don't know how old he is.
y <- NA

# Are John and Mary the same age?
x == y

# We don't know!

# If you want to determine if a value is missing, use is.na():

is.na(x)

# filter() only includes rows where the condition is TRUE; it excludes both FALSE and NA values. 
# If you want to preserve missing values, ask for them explicitly:

df <- tibble(x = c(1, NA, 3))
df
filter(df, x > 1)
#---------------------------------------------------------------------------------
# 5.2.4 Exercises
#---------------------------------------------------------------------------------
# Q 1. Find all flights that
## a. Had an arrival delay of two or more hours
## b. Flew to Houston (IAH or HOU)
## c. Were operated by United, American, or Delta
## d. Departed in summer (July, August, and September)
## e. Arrived more than two hours late, but didn’t leave late
## f. Were delayed by at least an hour, but made up over 30 minutes in flight
## g. Departed between midnight and 6am (inclusive)
 
# Q 2. Another useful dplyr filtering helper is between(). 
#      What does it do? Can you use it to simplify the code needed to answer the previous challenges?
   
# Q 3. How many flights have a missing dep_time? What other variables are missing? 
#      What might these rows represent?
   
# Q 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? 
#      Why is FALSE & NA not missing? 
#      Can you figure out the general rule? (NA * 0 is a tricky counterexample!)
#
#---------------------------------------------------------------------------------
# 5.3 Arrange rows with arrange()
#---------------------------------------------------------------------------------
# arrange() works similarly to filter() except that instead of selecting rows, it changes their order. 
# It takes a data frame and a set of column names (or more complicated expressions) to order by. 
# If you provide more than one column name, each additional column will be used to break ties in the 
# values of preceding columns:
arrange(flights, year, month, day)

# Use desc() to re-order by a column in descending order:
arrange(flights, desc(dep_delay))
#
# Missing values are always sorted at the end:
df <- tibble(x = c(5, 2, NA))
df
arrange(df, x)
arrange(df, desc(x))

#---------------------------------------------------------------------------------
# 5.3.1 Exercises
#---------------------------------------------------------------------------------
# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.
# 3. Sort flights to find the fastest (highest speed) flights.
# 4. Which flights travelled the farthest? Which travelled the shortest?
#
#---------------------------------------------------------------------------------
# 5.4 Select columns with select()
#---------------------------------------------------------------------------------
# It’s not uncommon to get datasets with hundreds or even thousands of variables. 
# In this case, the first challenge is often narrowing in on the variables you’re 
# actually interested in. 

# select() allows you to rapidly zoom in on a useful subset using operations based 
# on the names of the variables.
# 
# select() is not terribly useful with the flights data because we only have 19 variables, 
# but you can still get the general idea:
  
# Select columns by name
select(flights, year, month, day)

# Select all columns between year and day (inclusive)
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

# There are a number of helper functions you can use within select():
# starts_with("abc"): matches names that begin with “abc”.
# ends_with("xyz"): matches names that end with “xyz”.
# contains("ijk"): matches names that contain “ijk”.
# matches("(.)\\1"): selects variables that match a regular expression. 
# This one matches any variables that contain repeated characters. 
# You’ll learn more about regular expressions in strings.
# num_range("x", 1:3): matches x1, x2 and x3.

# See ?select for more details.
?select
# select() can be used to rename variables, but it’s rarely useful because it drops all 
# of the variables not explicitly mentioned. 
# Instead, use rename(), which is a variant of select() that keeps all the variables 
# that aren’t explicitly mentioned:
rename(flights, tail_num = tailnum)

# Another option is to use select() in conjunction with the everything() helper. 
# This is useful if you have a handful of variables you’d like to move to the start of the data frame.

select(flights, time_hour, air_time, everything())

#-----------------------------------------------------
# 5.4.1 Exercises
#-----------------------------------------------------
# Q 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.

# Q 2. What happens if you include the name of a variable multiple times in a select() call?
  
# Q 3. What does the any_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")

# Q 4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?
select(flights, contains("TIME"))






