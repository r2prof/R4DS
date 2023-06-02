#-----------------------------
# Exploratory Data Analysis
#-----------------------------
# 7.1 Introduction
# 
# This chapter will show you how to use visualisation and transformation to explore your data in a 
# systematic way, a task that statisticians call exploratory data analysis, or EDA for short. 
#
# EDA is an iterative cycle. You:
# 1. Generate questions about your data.
# 2. Search for answers by visualising, transforming, and modelling your data.
# 3. Use what you learn to refine your questions and/or generate new questions.
# 
# EDA is not a formal process with a strict set of rules. More than anything, EDA is a state of mind. 
# During the initial phases of EDA you should feel free to investigate every idea that occurs to you. 
# Some of these ideas will pan out, and some will be dead ends. As your exploration continues, you will 
# home in on a few particularly productive areas that you’ll eventually write up and communicate to others.
# 
# EDA is an important part of any data analysis, even if the questions are handed to you on a platter, 
# because you always need to investigate the quality of your data. Data cleaning is just one application 
# of EDA: you ask questions about whether your data meets your expectations or not. To do data cleaning, 
# you’ll need to deploy all the tools of EDA: visualisation, transformation, and modelling.
#-------------------------
#  7.1.1 Prerequisites
#-------------------------
# In this chapter we’ll combine what you’ve learned about dplyr and ggplot2 to interactively ask questions, 
# answer them with data, and then ask new questions.
library(tidyverse)
#
# “There are no routine statistical questions, only questionable statistical routines.” — Sir David Cox
#
# “Far better an approximate answer to the right question, which is often vague, than an exact answer to 
# the wrong question, which can always be made precise.” — John Tukey
#
# There is no rule about which questions you should ask to guide your research. However, two types of 
# questions will always be useful for making discoveries within your data. 
# You can loosely word these questions as:
#
# 1. What type of variation occurs within my variables?
# 2. What type of covariation occurs between my variables?
#
# Let’s define some terms:
#
# A variable is a quantity, quality, or property that you can measure.
# A value is the state of a variable when you measure it. The value of a variable may change from 
# measurement to measurement.
# 
# An observation is a set of measurements made under similar conditions (you usually make all of the 
# measurements in an observation at the same time and on the same object). An observation will contain 
# several values, each associated with a different variable. I’ll sometimes refer to an observation as 
# a data point.
# 
# Tabular data is a set of values, each associated with a variable and an observation. Tabular data is tidy if 
# each value is placed in its own “cell”, each variable in its own column, and each observation in its own row.
# 
# So far, all of the data that you’ve seen has been tidy. In real-life, most data isn’t tidy, so we’ll come back 
# to these ideas again in tidy data.
#
#-----------------------
# 7.3 Variation
#-----------------------
# Variation is the tendency of the values of a variable to change from measurement to measurement. You can see 
# variation easily in real life; if you measure any continuous variable twice, you will get two different results. 
# This is true even if you measure quantities that are constant, like the speed of light. 
#
# Each of your measurements will include a small amount of error that varies from measurement to measurement. 
# Categorical variables can also vary if you measure across different subjects (e.g. the eye colors of different 
# people), or different times (e.g. the energy levels of an electron at different moments). 
# 
# Every variable has its own pattern of variation, which can reveal interesting information. 
#
# The best way to understand that pattern is to visualise the distribution of the variable’s values.
#
#-------------------------------------
# 7.3.1 Visualising distributions
#-------------------------------------
# How you visualise the distribution of a variable will depend on whether the variable is categorical or continuous. 
# A variable is categorical if it can only take one of a small set of values. In R, categorical variables are 
# usually saved as factors or character vectors. 
#
# We will be working with the diamonds dataset, so let’s take a minute to familiarize ourselves with it. 
# This built-in dataset is available when the ggplot2 package is loaded. Loading the tidyverse package will 
# automatically load ggplot2.
View(diamonds)
head(diamonds)
#
#------------------------------------------
# Distribution of a categorical variable
#------------------------------------------
# To examine the distribution of a categorical variable, use a bar chart:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
#
# The height of the bars displays how many observations occurred with each x value. You can compute these values 
# manually with dplyr::count():
diamonds %>% 
  count(cut)
#
#------------------------------------------
# Distribution of a continuous variable
#------------------------------------------
# A variable is continuous if it can take any of an infinite set of ordered values. Numbers and date-times are 
# two examples of continuous variables. To examine the distribution of a continuous variable, use a histogram:
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
#
# You can compute this by hand by combining dplyr::count() and ggplot2::cut_width():
diamonds %>% 
  count(cut_width(carat, 0.5))
#
# A histogram divides the x-axis into equally spaced bins and then uses the height of a bar to display the 
# number of observations that fall in each bin. In the graph above, the tallest bar shows that almost 30,000 
# observations have a carat value between 0.25 and 0.75, which are the left and right edges of the bar.
# 
# You can set the width of the intervals in a histogram with the binwidth argument, which is measured in the 
# units of the x variable. You should always explore a variety of binwidths when working with histograms, as 
# different binwidths can reveal different patterns. 
#
# For example, here is how the graph above looks when we zoom into just the diamonds with a size of less than 
# three carats and choose a smaller binwidth.
smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)
#
#
# If you wish to overlay multiple histograms in the same plot, I recommend using geom_freqpoly() instead of 
# geom_histogram(). geom_freqpoly() performs the same calculation as geom_histogram(), but instead of displaying 
# the counts with bars, uses lines instead. 
#
# It’s much easier to understand overlapping lines than bars.
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)
#
# There are a few challenges with this type of plot, which we will come back to in visualising a categorical and 
# a continuous variable.
# 
# Now that you can visualise variation, what should you look for in your plots? And what type of follow-up 
# questions should you ask? I’ve put together a list below of the most useful types of information that you 
# will find in your graphs, along with some follow-up questions for each type of information. The key to asking 
# good follow-up questions will be to rely on your curiosity (What do you want to learn more about?) as well as 
# your skepticism (How could this be misleading?).
#
#-------------------------------------
# 7.3.2 Typical Values
#-------------------------------------
# In both bar charts and histograms, tall bars show the common values of a variable, and shorter bars show 
# less-common values. Places that do not have bars reveal values that were not seen in your data. To turn this 
# information into useful questions, look for anything unexpected:
# 
#. Which values are the most common? Why?
#. Which values are rare? Why? Does that match your expectations?
#. Can you see any unusual patterns? What might explain them?
# 
# As an example, the histogram below suggests several interesting questions:
#. Why are there more diamonds at whole carats and common fractions of carats?
#. Why are there more diamonds slightly to the right of each peak than there are slightly to the left of each peak?
#. Why are there no diamonds bigger than 3 carats?
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)
#
#
# Clusters of similar values suggest that subgroups exist in your data. To understand the subgroups, ask:
# How are the observations within each cluster similar to each other?
#   
#. How are the observations in separate clusters different from each other?
#. How can you explain or describe the clusters?
#. Why might the appearance of clusters be misleading?
#
# The histogram below shows the length (in minutes) of 272 eruptions of the Old Faithful Geyser in Yellowstone 
# National Park. Eruption times appear to be clustered into two groups: there are short eruptions (of around 2 
# minutes) and long eruptions (4-5 minutes), but little in between.
#
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
#
# Many of the questions above will prompt you to explore a relationship between variables, for example, to see if 
# the values of one variable can explain the behavior of another variable. We’ll get to that shortly.
#
#------------------------------
# 7.3.3 Unusual Values
#------------------------------
# Outliers are observations that are unusual; data points that don’t seem to fit the pattern. Sometimes outliers 
# are data entry errors; other times outliers suggest important new science. When you have a lot of data, outliers 
# are sometimes difficult to see in a histogram. 
#
# For example, take the distribution of the y variable from the diamonds dataset. The only evidence of outliers 
# is the unusually wide limits on the x-axis.
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
#
# There are so many observations in the common bins that the rare bins are so short that you can’t see them 
# (although maybe if you stare intently at 0 you’ll spot something). To make it easy to see the unusual values, 
# we need to zoom to small values of the y-axis with coord_cartesian():
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
#
# (coord_cartesian() also has an xlim() argument for when you need to zoom into the x-axis. ggplot2 also has xlim() 
# and ylim() functions that work slightly differently: they throw away the data outside the limits.)
# 
# This allows us to see that there are three unusual values: 0, ~30, and ~60. We pluck them out with dplyr:
unusual <- diamonds %>% 
filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
   arrange(y)
unusual
#
#------------------------------------------------------------------
# Explanation of the code:
# filter(y < 3 | y > 20): This operation filters the rows of the "diamonds" dataset based on a condition involving 
# the variable "y". It selects only the rows where the value of "y" is less than 3 or greater than 20. 
#
# In other words, it keeps only the diamonds with an unusually small or unusually large value for the "y" variable.
#
# select(price, x, y, z): This operation selects specific variables from the filtered dataset. It keeps only the 
# columns/variables named "price", "x", "y", and "z" in the resulting dataset. This means we are interested in the 
# price of the diamonds and their dimensions in terms of length (x), width (y), and depth (z).
# 
# arrange(y): This operation arranges the rows of the dataset in ascending order based on the values of the "y" 
# variable. This means that the resulting dataset will be sorted from the smallest "y" value to the largest "y" 
# value.
#------------------------------------------------------------------
#
# The y variable measures one of the three dimensions of these diamonds, in mm. We know that diamonds can’t have a 
# width of 0mm, so these values must be incorrect. We might also suspect that measurements of 32mm and 59mm are 
# implausible: those diamonds are over an inch long, but don’t cost hundreds of thousands of dollars!
# 
# It’s good practice to repeat your analysis with and without the outliers. If they have minimal effect on the 
# results, and you can’t figure out why they’re there, it’s reasonable to replace them with missing values, and 
# move on. 
#
# However, if they have a substantial effect on your results, you shouldn’t drop them without justification. 
# You’ll need to figure out what caused them (e.g. a data entry error) and disclose that you removed them in 
# your write-up.

#---------------------------------
# 7.3.4 Exercises
#---------------------------------
# 1. Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn? Think about a 
#    diamond and how you might decide which dimension is the length, width, and depth.
# 
# 2. Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: Carefully think 
#    about the binwidth and make sure you try a wide range of values.)
# 
# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?
#   
# 4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. What happens if 
#    you leave binwidth unset? What happens if you try and zoom so only half a bar shows?
#----------------------------------











