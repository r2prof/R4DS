# John Tukey 
# “The simple graph has brought more information to the data analyst’s mind than any other device.” 

# Load the library
library(tidyverse)

# If we need to be explicit about where a function (or dataset) comes from, we’ll use the special 
# form package::function(). For example, ggplot2::ggplot() tells you explicitly that we’re using 
# the ggplot() function from the ggplot2 package. 
 
# Let’s use our first graph to answer a question: Do cars with big engines use more fuel than cars 
# with small engines? 
 
# You probably already have an answer, but try to make your answer precise. What does the relationship 
# between engine size and fuel efficiency look like? Is it positive? Negative? Linear? Nonlinear?
 
# You can test your answer with the mpg data frame found in ggplot2 (aka ggplot2::mpg). 
# A data frame is a rectangular collection of variables (in the columns) and observations (in the rows). 
# mpg contains observations collected by the US Environmental Protection Agency on 38 models of car.
 
mpg

# Getting help with the data
?mpg

# Creating a ggplot

# To plot mpg, run this code to put displ on the x-axis and hwy on the y-axis:

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# The plot shows a negative relationship between engine size (displ) and fuel efficiency (hwy). 
# In other words, cars with big engines use more fuel. Does this confirm or refute your hypothesis 
# about fuel efficiency and engine size?

# With ggplot2, you begin a plot with the function ggplot(). ggplot() creates a coordinate system 
# that you can add layers to. 

# The first argument of ggplot() is the dataset to use in the graph. 
# So ggplot(data = mpg) creates an empty graph, but it’s not very interesting.

# You complete your graph by adding one or more layers to ggplot(). 
# The function geom_point() adds a layer of points to your plot, which creates a scatterplot. 
# ggplot2 comes with many geom functions that each add a different type of layer to a plot. 
# Each geom function in ggplot2 takes a mapping argument. This defines how variables in your 
# dataset are mapped to visual properties. 

# The mapping argument is always paired with aes(), and the x and y arguments of aes() 
# specify which variables to map to the x and y axes. 
# ggplot2 looks for the mapped variables in the data argument, in this case, mpg.

# ggplot template
# Let’s turn this code into a reusable template for making graphs with ggplot2. 
# To make a graph, replace the bracketed sections in the code below with a dataset, 
# a geom function, or a collection of mappings.

# ggplot(data = <DATA>) + 
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

#  3.3 Aesthetic mappings

# “The greatest value of a picture is when it forces us to notice what we never expected to see.” — John Tukey

# In the plot below, one group of points (highlighted in red) seems to fall outside of the linear trend. 
# These cars have a higher mileage than you might expect. How can you explain these cars?
# Let’s hypothesize that the cars are hybrids. One way to test this hypothesis is to look at the class value for each 
# car. The class variable of the mpg dataset classifies cars into groups such as compact, midsize, and SUV. 
# If the outlying points are hybrids, they should be classified as compact cars or, perhaps, subcompact 
# cars (keep in mind that this data was collected before hybrid trucks and SUVs became popular).

# You can add a third variable, like class, to a two dimensional scatterplot by mapping it to an aesthetic. 
# An aesthetic is a visual property of the objects in your plot. Aesthetics include things like the size, 
# the shape, or the color of your points. You can display a point (like the one below) in different ways 
# by changing the values of its aesthetic properties. Since we already use the word “value” to describe data, 
# let’s use the word “level” to describe aesthetic properties. Here we change the levels of a point’s size, 
# shape, and color to make the point small, triangular, or blue:
# You can convey information about your data by mapping the aesthetics in your plot to the variables in 
# your dataset. For example, you can map the colors of your points to the class variable to reveal the 
# class of each car.

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# To map an aesthetic to a variable, associate the name of the aesthetic to the name of the variable 
# inside aes(). ggplot2 will automatically assign a unique level of the aesthetic (here a unique color) 
# to each unique value of the variable, a process known as scaling. ggplot2 will also add a legend that 
# explains which levels correspond to which values.

# The colors reveal that many of the unusual points are two-seater cars. These cars don’t seem like hybrids, 
# and are, in fact, sports cars! Sports cars have large engines like SUVs and pickup trucks, but small bodies 
# like midsize and compact cars, which improves their gas mileage. In hindsight, these cars were unlikely to be 
# hybrids since they have large engines.

# In the above example, we mapped class to the color aesthetic, but we could have mapped class to the size 
# aesthetic in the same way. In this case, the exact size of each point would reveal its class affiliation. 
# We get a warning here, because mapping an unordered variable (class) to an ordered aesthetic (size) is 
# not a good idea.

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# Or we could have mapped class to the alpha aesthetic, which controls the transparency of the points, or to the shape aesthetic, which controls the shape of the points.

# Left
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Right
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# You can also set the aesthetic properties of your geom manually. For example, we can make all of the points in our plot blue:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 3.5 Facets






