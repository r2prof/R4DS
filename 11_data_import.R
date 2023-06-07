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