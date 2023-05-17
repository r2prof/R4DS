#--------------------
# CH 10
# Tibbles
#--------------------
# Source info: https://tibble.tidyverse.org/articles/tibble.html
#
library(tidyverse)
#--------------------------
#  10.2 Creating tibbles
#--------------------------
# Almost all of the functions that you’ll use in this book produce tibbles, as tibbles are one of 
# the unifying features of the tidyverse. Most other R packages use regular data frames, so you might 
# want to coerce a data frame to a tibble. You can do that with as_tibble():
as_tibble(iris)
#
# You can create a new tibble from individual vectors with tibble(). 
# tibble() will automatically recycle inputs of length 1, and allows you to refer to variables that 
# you just created, as shown below.
tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

#
# If you’re already familiar with data.frame(), note that tibble() does much less: it never changes 
# the type of the inputs (e.g. it never converts strings to factors!), it never changes the names of 
# variables, and it never creates row names.
#
# It’s possible for a tibble to have column names that are not valid R variable names, aka non-syntactic 
# names. For example, they might not start with a letter, or they might contain unusual characters like 
# a space. To refer to these variables, you need to surround them with backticks, `:

tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)
tb
#
# You’ll also need the backticks when working with these variables in other packages, like ggplot2, 
# dplyr, and tidyr.
#
# Another way to create a tibble is with tribble(), short for transposed tibble. tribble() is customised 
# for data entry in code: column headings are defined by formulas (i.e. they start with ~), and entries 
# are separated by commas. This makes it possible to lay out small amounts of data in easy to read form.
tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)
# I often add a comment (the line starting with #), to make it really clear where the header is.
#
#-------------------------------
# 10.3 Tibbles vs. data.frames
#------------------------------
#There are two main differences in the usage of a tibble vs. a classic data.frame: printing and subsetting.
#------------------
# 10.3.1 Printing
#------------------
# Tibbles have a refined print method that shows only the first 10 rows, and all the columns that fit on 
#screen. This makes it much easier to work with large data. In addition to its name, each column reports 
# its type, a nice feature borrowed from str():
#
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)
#
# Tibbles are designed so that you don’t accidentally overwhelm your console when you print large data frames. 
# But sometimes you need more output than the default display. There are a few options that can help.
# 
# First, you can explicitly print() the data frame and control the number of rows (n) and the width of the 
# display. width = Inf will display all columns:
nycflights13::flights %>% 
  print(n = 10, width = Inf)
#
# You can also control the default print behaviour by setting options:
#
# options(tibble.print_max = n, tibble.print_min = m): if more than n rows, print only m rows. 
# Use options(tibble.print_min = Inf) to always show all rows.
#
# Use options(tibble.width = Inf) to always print all columns, regardless of the width of the screen.
#
# You can see a complete list of options by looking at the package help with package?tibble.
#
# A final option is to use RStudio’s built-in data viewer to get a scrollable view of the complete dataset. 
# This is also often useful at the end of a long chain of manipulations.
nycflights13::flights %>% 
  View()
#--------------------------
#  10.3.2 Subsetting
#--------------------------
# So far all the tools you’ve learned have worked with complete data frames. If you want to pull out a 
# single variable, you need some new tools, $ and [[. [[ can extract by name or position; $ only extracts 
# by name but is a little less typing.
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df
# Extract by name
df$x
df[["x"]]
#
# Extract by position
df[[1]]
#
# To use these in a pipe, you’ll need to use the special placeholder .:
df %>% .$x
df %>% .[["x"]]
#
# Compared to a data.frame, tibbles are more strict: they never do partial matching, and they will 
# generate a warning if the column you are trying to access does not exist.
#
#------------------------------------
#  10.4 Interacting with older code
#-----------------------------------
# Some older functions don’t work with tibbles. If you encounter one of these functions, use as.data.frame() 
# to turn a tibble back to a data.frame:
class(as.data.frame(tb))
#
# The main reason that some older functions don’t work with tibble is the [ function. We don’t use [ much 
# in this book because dplyr::filter() and dplyr::select() allow you to solve the same problems with clearer 
# code (but you will learn a little about it in vector subsetting). With base R data frames, [ sometimes returns 
# a data frame, and sometimes returns a vector. With tibbles, [ always returns another tibble.
#
#--------------------
# 10.5 Exercises
#--------------------
# 1. How can you tell if an object is a tibble? (Hint: try printing mtcars, which is a regular data frame).
data(mtcars)
View(mtcars)
class(mtcars)
# Covert mtcars from data frame to a tibble

tibble_matcars <- as_tibble(mtcars)
#
#
# 2. Compare and contrast the following operations on a data.frame and equivalent tibble. What is different? 
#    Why might the default data frame behaviours cause you frustration?
df <- data.frame(abc = 1, xyz = "a")
df
df$x
df[, "xyz"]
df[, c("abc", "xyz")]
#------------------------
# Coverting into a tibble
tibble_df <- as_tibble(df)
tibble_df
df$x
df[, "xyz"]
df[, c("abc", "xyz")]
#
# 1. Inconsistent treatment of strings: Data frames convert strings to factors by default, which can lead to 
#    unexpected behavior and data type issues.
#
# 2. Inconsistent treatment of missing values: Data frames use NA to represent missing values, which can cause 
#    problems when performing calculations or statistical operations. Tibbles, on the other hand, use NA or NaN 
#    to represent missing values, depending on the data type.
#
# 3. Printing limitations: The default print method for data frames displays the entire data frame, including 
#    row numbers. This can be overwhelming and less readable, especially for large datasets. Tibbles address 
#    this issue by providing a more concise and visually appealing default print method.
#
# 4. Non-standard evaluation: Data frames use non-standard evaluation for column selection and subsetting, which 
#    can lead to confusion and unexpected behavior. Tibbles use standard evaluation, which is more consistent and 
#    predictable.
#
# 5. Overall, tibbles provide a more modern and enhanced experience compared to traditional data frames. They offer 
#    improved printing, better handling of missing values, and a more consistent and predictable interface for data 
#    manipulation and analysis. These features make tibbles a preferred choice for many data analysis tasks.
#
# 3. If you have the name of a variable stored in an object, e.g. var <- "mpg", how can you extract the reference 
#    variable from a tibble?
#    Answer: To extract a column from a tibble using the name of the variable stored in an object, such as 
#            var <- "mpg", you can use the curly-brace notation {} along with the bang-bang operator !!. 
#            Here's how you can accomplish it:
#----------------------------------------------
library(dplyr)
# Create a tibble for demonstration
df <- tibble(mpg = c(21, 19, 18),
             cyl = c(6, 6, 8))
# Variable name stored in an object
var <- "mpg"
# Extract the column from the tibble
extracted_column <- df %>% select(!!sym(var))
# Output the extracted column
print(extracted_column)
#----------------------------------------------
#
# In this code, select() function from the dplyr package is used to select the column specified by var. 
# The sym() function is used to convert the character object var into a symbol, and !! is used to unquote 
# the symbol within the select() function call.
#
# The resulting extracted_column will be a tibble containing only the column specified by the variable name 
# stored in var, in this case, "mpg".
#--------------------------------------------
# Here is the data frame:
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying
# 4. Practice referring to non-syntactic names in the following data frame by:
#    Q4 Part 1. Extracting the variable called 1.
# Here is the solution: 
# Extract the variable called '1'
extracted_variable <- annoying %>% select(`1`)
#
# Output the extracted variable
print(extracted_variable)
#-----------------------
# Q4 Part 2. 
# Plotting a scatterplot of 1 vs 2
library(ggplot2)
# Create the scatterplot
scatterplot <- ggplot(annoying, aes(x = `1`, y = `2`)) +
  geom_point() +
  xlab("Variable 1") +
  ylab("Variable 2") +
  ggtitle("Scatterplot of Variable 1 vs Variable 2")
# Display the scatterplot
print(scatterplot)
#------------------------
# Q4 Part 3.
# Creating a new column called 3 which is 2 divided by 1.
#
library(dplyr)
# Create the new column '3' by dividing '2' by '1'
annoying <- annoying %>% mutate(`3` = `2` / `1`)
# Display the modified tibble
print(annoying)
#-------------------------
# Q4 Part 4.
# Renaming the columns to one, two and three.
library(dplyr)
# Rename the columns
annoying <- annoying %>% rename(one = `1`, two = `2`, three = `3`)
# Display the modified tibble
print(annoying)
#------------------------
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying
#------------------------
# Q 5: What does tibble::enframe() do? When might you use it?
#      Answer: The tibble::enframe() function is used to convert named atomic vectors, lists, or 
#             data frames into a tibble with two columns: "name" and "value". Here's how it works:
#
# Example 1: Convert named atomic vector
vec <- c(a = 1, b = 2, c = 3)
df <- enframe(vec)
print(df)
#-----------------------
# Q 6: What option controls how many additional column names are printed at the footer of a tibble?
#      Answer: The option that controls how many additional column names are printed at the footer of a tibble 
#              is called `pillar.sigfig`. 
#              By default, tibbles only print the first 10 rows and all columns that fit within the width of the 
#              console. However, at the footer of the tibble, additional column names are shown to indicate that 
#              there are more columns in the data frame. The number of additional column names printed at the 
#              footer can be controlled by the `pillar.sigfig` option.
# 
#              You can change the value of `pillar.sigfig` to adjust the number of additional column names 
#              displayed at the footer. Here's an example:
#
# Check the current value of pillar.sigfig
getOption("pillar.sigfig") 
# Set the number of additional column names to display at the footer
options(pillar.sigfig = 5)  # For example, set it to 5
# Create a tibble
df <- tibble(a = 1:10, b = 11:20, c = 21:30, d = 31:40)
# Print the tibble
print(df)
#
# In this example, the `getOption("pillar.sigfig")` line is used to check the current value of `pillar.sigfig`. 
# Then, `options(pillar.sigfig = 5)` is used to set the number of additional column names to display at the footer 
# to 5.
# 
# When the tibble `df` is printed, it will display the first 10 rows and all columns that fit within the width of 
# the console. At the footer, it will show the additional column names if there are more columns in the tibble. 
# The number of additional column names displayed will be controlled by the `pillar.sigfig` option. 










