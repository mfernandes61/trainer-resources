# Live demo DA1 -------
# load tidyverse library (Note no quotes!)
#install.packages("tidyverse")

# load packages with library()
library(tidyverse)


# Data types - create a vector and demonstrate class()

# assignment operator: Alt + - or Option + -
temperature <- 23
temperature + 10

temperature <- temperature + 10

temperature_celcius <- 27

# programming languages are case sensitive
Temperature <- 34

# you can perform operations with objects
temperature * temperature_celcius

## More complex objects ----

temps <- c(12, 34, 88, 99, 120, 199, 822)

# we can check the type of object using class()
class(temps)

# character / string / text
patient_id <- c("patient_01", "patient_02", "patient_06")

class(patient_id)


# logical data (TRUE or FALSE)

icu_admission <- c(TRUE, FALSE, TRUE)
class(icu_admission)

more_icu <- c("TRUE", FALSE, FALSE)
class(more_icu)

# update the data type
more_icu <- as.logical(more_icu)
class(more_icu)


c("True", FALSE, "False")

seq()
?seq()
seq(from = 1, to = 9, by = 1) 
seq(from = 10, to = 4, by = -1)

# Indexing - vector and use seq_along()

temps
length(temps)

# functions use ( ) and subsetting uses [ ]
temps[c(1, 2, 3)]
temps[4]
temps[3:5]
temps[c(3, 4, 5)]


## Dealing with missing data ---

num_seq <- c(125, 140, 115, NA, 112)
class(num_seq)

# when calculating averages, we need to tell the
# computer how to deal with missing data
mean(num_seq, na.rm = TRUE)



# select only 1st & 3rd value using c()


# Live demo DA2 --------

# you can read in excel files, using the readxl package
# but we're not doing that here

surveys <- read_csv("data/surveys.csv")

# structure of the data
str(surveys)

# head function
head(surveys)

tail(surveys)


# column names
colnames(surveys)


# summary statistics
summary(surveys)

# subsetting tables

temps[2:3]

# subset [rows, columns]
# numerical indexing
surveys[8, 4]
surveys[ , 4]
surveys[1:5, 8]

surveys[c(1, 6, 9), c(1, 6)]

# label-based subsetting
surveys[ , "weight"]
surveys[ , c("weight", "record_id") ]

# selecting a single column using the $ sign
surveys$year

# Read in data from infections.csv
# Examine the data (nrow, ncol, summary & str functions)
infections <- read_csv("data/infections.csv")
# Check data quality - unique values of infection type
# use sum() and is.na() to find out number of missing values

# Display one and multiple columns using $ and R,C format
# and then repeat but only show first 3 rows

# DA2 simple plots - plot scattergraph
# body_temperature on x and crp_level on y
ggplot(data=infections, mapping=aes(x=body_temperature,y=crp_level)) +
  geom_point()

# repeat above but colo(u)r by hospital
ggplot(data=infections, mapping=aes(x=body_temperature,y=crp_level,
                                    colour=hospital)) +
  geom_point()
# repeat above but use facet_wrap to create 1 plot per hospital
ggplot(data=infections, mapping=aes(x=body_temperature,y=crp_level,
                                    colour=hospital)) +
  geom_point() +
  facet_wrap(facets=vars(hospital))
# And again but use facet_grid with rows =
# icu_admission and columns = hospital
ggplot(data=infections, mapping=aes(x=body_temperature,y=crp_level,
                                    colour=hospital)) +
  geom_point() +
  facet_grid(rows=vars(icu_admission), cols = vars(hospital))
