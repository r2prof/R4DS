seq(1, 10)
x <- "hello world"
my_variable <- 10
my_variable
#---------------------------------
# 06 Workflow: scripts
#---------------------------------
# Tweak each of the following R commands so that they run correctly:
library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)

filter(diamonds, carat > 3)

# Press Alt + Shift + K. What happens? How can you get to the same place using the menus?