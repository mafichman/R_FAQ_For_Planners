# Intro to R

# MUSA Spatial Analysis Bootcamp, August, 2020
# Michael Fichman, Lab Instructor
# mfichman@design.upenn.edu

# ------ Resources -------

# A simple guide to data types and basic operations - http://www.r-tutor.com/r-introduction
# Hadley Wickham's "R For Data Science" - http://r4ds.had.co.nz/
# Stack Overflow - stackoverflow.com

# A note - almost any problem you have with your data or code has occurred before in some form,
# and it was likely discussed online and solved!

#  ---- What is R? ------
# It is a programming language used for statistics, data science and data visualization
# It is open source, backed by an enormous community of users
# It is the most quickly growing programming language and community

# ----- How do you run code in R? ------

# Let's examine the R Studio enviornment.

# Code with a "#" is called "commented code"

# Code without will run - either as written in the console or by hitting ctrl+enter on code the code window

print("hello world")

# R is case sensitive - many of your issues can be resolved by checking your syntax

# ----- Data Types -----

# You can assign information to a variable using this sign "<-"

myVariable <- "derp"

# What kind of data are these?

typeof(myVariable)

# Let's create another

anotherVariable <- 95.01234

typeof(anotherVariable)

# You can do math with a numeric variable, a double etc.,

anotherVariable + 10

anotherVariable / 4

# There is a data type called "NA" that R uses to deal with missing data
# You might find a data set that has missing observations that get assinged a value of NA
# NA values can break certain operations, so be aware of them!

# Let's take the mean of a group of numbers

mean(c(2, 4, 6)) # This works

mean(c(2, 4, 6, NA)) # This doesn't

3 + NA # Neither does this

# You can apply a logical test to see if there are NA values in your data

is.na(c(2, 4, 6, NA))

# You can omit NA data - but do this with caution - if you have a big data set, you could lose
# rows that have non missing data!

na.omit(c(2, 4, 6, NA))

# Data types - characters, numbers, vectors, lists

# Characters are dealt with in quotes
# Here is a vector of character data, created using the "<-" 
# and the function "c" which creates the vector
# we give it a name of our choice

characterVector <- c("A", "B", "C", "A", "A", "C", "B", "B", "A", "D")

# Numbers do not have quotes

numericVector <- c(3, 135, 37, 21, 26, 11, 15, 20, 1, 10)

# We can bind these together as columns because they are the same length

cbind(characterVector, numericVector)

# This is starting to look more like the type of data we are familiar with from excel....

#  ------ Exploring the environment, loading data and using data frames  ------

# Loading Data using syntax and the RStudio dropdown - we can import our data using the 
# "Import Dataset" button and loading it From Text (base).

# Let's load some data

# Make sure you select "Yes" in the Headings option

# Let's name our data "dat"

# Alternately, we could load data using R syntax
# Use the filepath appropriate for your file!

dat <- read.csv("https://raw.githubusercontent.com/mafichman/R_FAQ_For_Planners/main/data/someCensusData.csv")

# For mac: read.csv("/users/myname/desktop/experiment.csv")

# EXAMINING YOUR DATA

# Look at the first five rows
head(dat)

head(dat$total_HU.2010)

# What are the dimensions of the data?
length(dat)

nrow(dat)

# What are the column names
names(dat)

# Let's look at the first five rows
head(dat)

# Let's call a column using the "$" operator

dat$total_HU.2010

# What type of data are they?

typeof(dat$total_HU.2010)

# Let's summarize it

summary(dat$total_HU.2010)

# We can create new columns

dat$housingUnitChange <- dat$total_HU.2016 - dat$total_HU.2010

# We can create new columns based on some manipulation of data

dat$newColumn <- 25

dat$newColumnSquared <- dat$newColumn^2

# What are the characteristics of the data?

typeof(dat$vacancyPct.2016) # data type

max(dat$total_pop.2016)

median(dat$vacancyPct.2016) # uh oh - this won't work. maybe some NA values?

# We can omit the NA values if we want - this can be done multiple ways

median(na.omit(dat$vacancyPct.2016))

# Taking a mean will have the same problem

mean(na.omit(dat$vacancyPct.2016))

# We can store that mean value

median.Vacant <- median(na.omit(dat$vacancyPct.2016))

# We can look at the quantile values for that data

quantile(na.omit(dat$vacancyPct.2016))

# We can make a histogram to explore the distribution

hist(dat$vacancyPct.2016)

# Let's manipulate data using "tidy" language and then write out a new data frame

# This is a bit of a preview to "Intro to TidyCensus" which we will do next week

# Let's use a "select" a few rows, "rename" some things and create a new variable using "mutate"
# note the use of the "pipe" operator %>% - to chain operations together. This is very useful!


install.packages('tidyverse')
library(tidyverse)

dat %>%
  filter(is.na(vacancyPct.2016) == FALSE) %>%
  summarize(median(vacancyPct.2016))

newDat <- dat %>%
  select(GEOID, 
         NAME.x,
         total_pop.2010, 
         total_GradDeg.2010,
         pointBreeze) %>%
  rename(tractName = NAME.x,
         pop_total_2010 = total_pop.2010) %>%
  mutate(gradPercent.2010 = total_GradDeg.2010 / pop_total_2010)%>%
  filter(gradPercent.2010 >= 0.1)

hist(newDat$gradPercent.2010)

# We could "filter" to create a data set of just the highest percentage tracts

pctOver10 <- newDat %>%
  filter(gradPercent.2010 >= 0.1)

# We could output any data frame we create to file using "write.csv"
# Use the filepath appropriate for YOUR file

write.csv(pctOver10, "your_filepath_on_your_computer/your_filename.csv")