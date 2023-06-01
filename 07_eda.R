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
 
























