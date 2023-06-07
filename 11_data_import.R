#-------------------------
# 11 Data Import
#-------------------------
# In this chapter, you’ll learn how to load flat files in R with the readr package, which is part of 
# the core tidyverse.

library(tidyverse)

#  11.2 Getting started

# Most of readr’s functions are concerned with turning flat files into data frames:
#   
# read_csv() reads comma delimited files, read_csv2() reads semicolon separated files (common in 
# countries where , is used as the decimal place), read_tsv() reads tab delimited files, and 
# read_delim() reads in files with any delimiter.
# 
# read_fwf() reads fixed width files. You can specify fields either by their widths with fwf_widths() 
# or their position with fwf_positions(). read_table() reads a common variation of fixed width files 
# where columns are separated by white space.
# 
# read_log() reads Apache style log files. (But also check out webreadr which is built on top of 
# read_log() and provides many more helpful tools.)
# 
# These functions all have similar syntax: once you’ve mastered one, you can use the others with ease. 
# For the rest of this chapter we’ll focus on read_csv(). Not only are csv files one of the most common 
# forms of data storage, but once you understand read_csv(), you can easily apply your knowledge to all 
# the other functions in readr.
# 
# The first argument to read_csv() is the most important: it’s the path to the file to read.
heights <- read_csv("data/heights.csv")
#
# You can also supply an inline csv file. This is useful for experimenting with readr and for creating reproducible 
# examples to share with others:
read_csv("a,b,c
1,2,3
4,5,6")
#
# n both cases read_csv() uses the first line of the data for the column names, which is a very common convention. 
# There are two cases where you might want to tweak this behaviour:
#
# First Method
# Sometimes there are a few lines of metadata at the top of the file. You can use skip = n to skip the first n lines; 
# or use comment = "#" to drop all lines that start with (e.g.) #.
#
read_csv("The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3", skip = 2)
#
read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "#")
#
# Second Method
# The data might not have column names. You can use col_names = FALSE to tell read_csv() not to treat the first 
# row as headings, and instead label them sequentially from X1 to Xn:

read_csv("1,2,3\n4,5,6", col_names = FALSE)
#
# ("\n" is a convenient shortcut for adding a new line. You’ll learn more about it and other types of string escape 
# in string basics.)
#
# Alternatively you can pass col_names a character vector which will be used as the column names:
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))
#
# Another option that commonly needs tweaking is na: this specifies the value (or values) that are used to represent 
# missing values in your file:
read_csv("a,b,c\n1,2,.", na = ".")
#
# This is all you need to know to read ~75% of CSV files that you’ll encounter in practice. You can also easily adapt 
# what you’ve learned to read tab separated files with read_tsv() and fixed width files with read_fwf(). 
#
# To read in more challenging files, you’ll need to learn more about how readr parses each column, turning them into 
# R vectors.
#
#--------------------------------------
# 11.2.1 Compared to base R
#--------------------------------------
# If you’ve used R before, you might wonder why we’re not using read.csv(). There are a few good reasons to favour 
# readr functions over the base equivalents:

# They are typically much faster (~10x) than their base equivalents. Long running jobs have a progress bar, so you 
# can see what’s happening. If you’re looking for raw speed, try data.table::fread(). It doesn’t fit quite so well 
# into the tidyverse, but it can be quite a bit faster.

# They produce tibbles, they don’t convert character vectors to factors, use row names, or munge the column names. 
# These are common sources of frustration with the base R functions.

# They are more reproducible. Base R functions inherit some behaviour from your operating system and environment 
# variables, so import code that works on your computer might not work on someone else’s.
#
#---------------------------
#  11.2.2 Exercises
#---------------------------
# 1. What function would you use to read a file where fields were separated with “|”?
  
# 2. Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?
  
# 3. What are the most important arguments to read_fwf()?
  
# 4. Sometimes strings in a CSV file contain commas. To prevent them from causing problems they need to be 
#    surrounded by a quoting character, like " or '. By default, read_csv() assumes that the quoting character 
#    will be ". What argument to read_csv() do you need to specify to read the following text into a data frame?
#    "x,y\n1,'a,b'"

# 5. Identify what is wrong with each of the following inline CSV files. What happens when you run the code?

read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")
#
#---------------------------
#  11.3 Parsing a vector
#---------------------------
# Before we get into the details of how readr reads files from disk, we need to take a little detour to talk 
# about the parse_*() functions. These functions take a character vector and return a more specialised vector 
# like a logical, integer, or date:

str(parse_logical(c("TRUE", "FALSE", "NA")))

str(parse_integer(c("1", "2", "3")))

str(parse_date(c("2010-01-01", "1979-10-14")))
#
# These functions are useful in their own right, but are also an important building block for readr. Once you’ve 
# learned how the individual parsers work in this section, we’ll circle back and see how they fit together to parse 
# a complete file in the next section.

# Like all functions in the tidyverse, the parse_*() functions are uniform: the first argument is a character vector 
# to parse, and the na argument specifies which strings should be treated as missing:

parse_integer(c("1", "231", ".", "456"), na = ".")

# If parsing fails, you’ll get a warning:

x <- parse_integer(c("123", "345", "abc", "123.45"))

# And the failures will be missing in the output:
x

# If there are many parsing failures, you’ll need to use problems() to get the complete set. This returns a tibble, 
# which you can then manipulate with dplyr.
problems(x)

# Using parsers is mostly a matter of understanding what’s available and how they deal with different types of input. 
# There are eight particularly important parsers:

# parse_logical() and parse_integer() parse logicals and integers respectively. There’s basically nothing that can 
# go wrong with these parsers so I won’t describe them here further.
# 
# parse_double() is a strict numeric parser, and parse_number() is a flexible numeric parser. These are more 
# complicated than you might expect because different parts of the world write numbers in different ways.
# 
# parse_character() seems so simple that it shouldn’t be necessary. But one complication makes it quite 
# important: character encodings.
# 
# parse_factor() create factors, the data structure that R uses to represent categorical variables with fixed 
# and known values.
# 
# parse_datetime(), parse_date(), and parse_time() allow you to parse various date & time specifications. 
# These are the most complicated because there are so many different ways of writing dates.
# 
# The following sections describe these parsers in more detail.

#---------------------
#  11.3.1 Numbers
#--------------------
# It seems like it should be straightforward to parse a number, but three problems make it tricky:
#   
# People write numbers differently in different parts of the world. For example, some countries use . in 
# between the integer and fractional parts of a real number, while others use ,.
# 
# Numbers are often surrounded by other characters that provide some context, like “$1000” or “10%”.
# 
# Numbers often contain “grouping” characters to make them easier to read, like “1,000,000”, and these grouping 
# characters vary around the world.
# 
# To address the first problem, readr has the notion of a “locale”, an object that specifies parsing options 
# that differ from place to place. When parsing numbers, the most important option is the character you use for 
# the decimal mark. You can override the default value of . by creating a new locale and setting the decimal_mark 
# argument:
#   
parse_double("1.23")

parse_double("1,23", locale = locale(decimal_mark = ","))

# readr’s default locale is US-centric, because generally R is US-centric (i.e. the documentation of base R is 
# written in American English). An alternative approach would be to try and guess the defaults from your operating 
# system. This is hard to do well, and, more importantly, makes your code fragile: even if it works on your computer, 
# it might fail when you email it to a colleague in another country.

# parse_number() addresses the second problem: it ignores non-numeric characters before and after the number. This 
# is particularly useful for currencies and percentages, but also works to extract numbers embedded in text.

parse_number("$100")

parse_number("20%")

parse_number("It cost $123.45")

# The final problem is addressed by the combination of parse_number() and the locale as parse_number() will 
# ignore the “grouping mark”:

# Used in America
parse_number("$123,456,789")

# Used in many parts of Europe
parse_number("123.456.789", locale = locale(grouping_mark = "."))

# Used in Switzerland
parse_number("123'456'789", locale = locale(grouping_mark = "'"))









