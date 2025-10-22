# DA3 live coding -------

## Load tidyverse package -----
library(tidyverse)

## Read in our data & find out column names/variables ----------
surveys <- read_csv("data/surveys.csv")
colnames(surveys) # one way
summary(surveys) # Another way that also helps sanity check data


## using dplyr select on cols ------------
select(surveys, species_id, year)

## or use View() to go all spreadsheet style.  ----------
View(select(surveys, species_id, year))

## More clever select() tricks ---------
# Pull out all the numeric columns with where(is.numeric)
View(select(surveys, where(is.numeric)))
## Exclude columne by use of -
View(select(surveys, -record_id))

# create a new column using dplyr mutate() verb -------------------
## Divide hindfoot_length by 10 to get it in cm
View(mutate(surveys, hindfoot_length_cm = hindfoot_length / 10))

# Chaining commands ---------------
surveys |> 
  select(record_id, hindfoot_length) |>
  mutate(hindfoot_length_cm = hindfoot_length / 10) 

# This lets us use two commands without storing the output 
# of 1st in an intermediate data object.
# We can continue piecewise extending this with more pipes knowing that the
# previous code works so any error MUST be in the new line.
# For an example let's edit the above to pipe into a View() command....
# NB on web you will see examples of both pipe syntax being used |> and %>%

# Rows ---------------


# Grouped operations ---------

# DA4 live coding -------
## Reshaping -------
# Load tidyverse 'tool-kit'
library(tidyverse)

# Get the data
surveys_join <- read_csv("data/surveys_join.csv")

# peek at first few rows
head(surveys_join)

# Pivot wide -------
surveys_wide <- surveys_join |> 
  pivot_wider(names_from = "year",
              values_from = "weight",
              names_prefix = "yr_")

# peek at first few rows
head(surveys_join)

# Visualise difference between 2021 & 2022 using ggplot ----
ggplot(surveys_wide, aes(x = yr_2021, y = yr_2022)) +
  geom_point()

# Compare across years ------
# Can compare across years if we convert 
# the year data to a factor
ggplot(surveys_join, aes(x = factor(year), y =  weight)) +
  geom_boxplot()

# Back to long format -----
# or "there & back again" for Tolkein fans
surveys_wide |> 
  pivot_longer(cols = -record_id,
               names_to = "year",
               values_to = "weight",
               names_prefix = "yr_")

# Combining data -----
# Often want to bring in other data to 
# enrich/annotate our data.

# Load tidyverse 'tool-kit'
library(tidyverse)

# Read in our data & annotation set (Plot types)
surveys <- read_csv("data/surveys.csv")
plot_types <- read_csv("data/plots.csv")
species <- read_csv("data/species.csv")

# Examine plot types -----
plot_types

#plot IDs - how many?
unique(surveys$plot_id)
# or
surveys |> count(plot_id)

# Annotate surveys by left-joining plot_types ----
View(left_join(surveys, plot_types, by = "plot_id"))
# If happpy assign to data object
surveys_left <- 
  left_join(surveys, plot_types, by = "plot_id")

# Use joined data to get more meaningful boxplot -----
ggplot(surveys_left, aes(x = plot_type, y = hindfoot_length)) +
  geom_boxplot()

# OK lets explore a right join -----
right_join(surveys, plot_types, by = "plot_id")
# we get fewer rows than right join as lines 
#  corresponding ID are dropped :-(

# Now an inner join (Set intersection) ----
# only items in both tables get included
inner_join(surveys, plot_types, by = "plot_id")

# Full join now (set union) most 'relaxed' ----
full_join(surveys, plot_types, by = "plot_id")

# Joins explained by animation
browseURL("https://www.garrickadenbuie.com/project/tidyexplain/")

#########################

# Clean, style & arrange ------------
# A collection of R packages designed for data science
library(tidyverse)

# A package for cleaning up data
library(janitor)

# A package for creating composite plots
library(patchwork) # may need install.packages("patchwork")

messy_data <- read_csv("data/messy_data.csv")
surveys <- read_csv("data/surveys.csv")
plot_types <- read_csv("data/plots.csv")
surveys_left <- left_join(surveys, plot_types, by = "plot_id")

# Look at messy data ----
messy_data |> 
  colnames()

# Lets use janitor on those names
messy_data |> 
  clean_names() |> 
  colnames()

# If happy then save cleanedup names to data
messy_data <- messy_data |>
  clean_names()

# Replace numbers by category for plot-id -----
plot_types |> 
  mutate(plot_id = paste0("plot_", sprintf("%03d", plot_id)))
# NB need to do similar for surveys if we want joins!

# Just how many ways can you say UK? -----
messy_data |> 
  count(country)

# use 'case-when' to undo mess ------
# 1. create some dummy data
df <- tibble(score = c(45, 67, 82, 90, 55))

# 2. recode the values
df <- df |> 
  mutate(performance = case_when(
    score < 60               ~ "fail",
    score >= 60 & score < 80 ~ "pass",
    TRUE                     ~ "excellent"
  ))

# 3. show the result
df

# If happy store in dataframe/tibble ----
messy_data <- messy_data |> 
  mutate(country = case_when(
    country %in% c("United kingdom", "U.K.", "UK") ~ "United Kingdom",
    TRUE ~ country
  ))

# did we fix it or break it?
messy_data |> 
  count(country)

# Illogical logicals -------
class(messy_data$employed_or_not)

# How bad is it?
messy_data |>
  count(employed_or_not)

# Case-when to the rescue again? ------
messy_data <- messy_data |> 
  mutate(employed_or_not = case_when(
    employed_or_not %in% c("no", "n") ~ "FALSE",
    employed_or_not %in% c("yes", "y") ~ "TRUE",
    TRUE ~ employed_or_not
  ))

# Are we there yet?
messy_data |> 
  count(employed_or_not)

class(messy_data$employed_or_not)

# Nope still character - fix it with mutate! ------

messy_data <- messy_data |> 
  mutate(employed_or_not = as.logical(employed_or_not))

# Now are we there?
class(messy_data$employed_or_not)

# Pimping our plots -----
# create violin plot
ggplot(surveys_left, aes(x = plot_type, y = hindfoot_length)) +
  geom_violin()

# Add title etc for full marks ------
ggplot(surveys_left, aes(x = plot_type, y = hindfoot_length)) +
  geom_violin() +
  labs(title = "Violin plot for hindfoot length by plot type",
       subtitle = "1977 - 2022",
       x = "Plot type",
       y = "Hindfoot length (mm)")

# lets fix those overlapping x-axis labels  -----
# lets try rotating the text first
ggplot(surveys_left, aes(x = plot_type, y = hindfoot_length)) +
  geom_violin() +
  labs(title = "Violin plot for hindfoot length by plot type",
       subtitle = "1977 - 2022",
       x = "Plot type",
       y = "Hindfoot length (mm)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# take 2 : lets wrap those labels
ggplot(surveys_left, aes(x = plot_type, y = hindfoot_length)) +
  geom_violin() +
  labs(
    title = "Violin plot for hindfoot length by plot type",
    subtitle = "1977 - 2022",
    x = "Plot type",
    y = "Hindfoot length (mm)") +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10))

# Using colour to clarify plots -------
# get a sub-set of data first
surveys_y2k <- surveys_left |> 
  filter(plot_type %in% c("Control", "Rodent Exclosure")) |> 
  filter(year %in% c(2000, 2001, 2002)) |> 
  drop_na()

# Glorious monochrome
ggplot(surveys_y2k, 
       aes(x = plot_type, y = hindfoot_length)) +
  geom_boxplot() +
  geom_jitter(width = 0.1)

# Colour (or is that color) by sex
ggplot(surveys_y2k, 
       aes(x = plot_type, y = hindfoot_length, fill = sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.1)

# using palettes to go beyond 'standard' colours -----
ggplot(surveys_y2k, aes(x = plot_type, y = hindfoot_length, fill = sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.1) +
  scale_fill_brewer(palette = "Dark2")
# Does this look better?

# Create your own colour-blind "friendly" palette -----
cb_palette   <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
                  "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# plot same graph with custom palette
ggplot(surveys_y2k, aes(x = plot_type, y = hindfoot_length, fill = sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.1) +
  scale_fill_manual(values = cb_palette)

# Arranging plots where we want them -----
# create some plots in variables
p1 <- ggplot(surveys_y2k, aes(x = plot_type, y = weight)) +
  geom_boxplot() +
  labs(title = "plot 1")

p2 <- ggplot(surveys_y2k, aes(x = weight, y = hindfoot_length)) +
  geom_point() +
  labs(title = "plot 2")

p3 <- ggplot(surveys_y2k, aes(x = factor(month), y = weight)) +
  geom_boxplot() +
  labs(title = "plot 3")
# we need the patchwork package
# install.packages("patchwork")
library(patchwork)

# Combine the plots
(p1 + p2) / p3

# we can put labelling on as before
(p1 + p2) / p3 +
  plot_annotation(title = "Fig. 1: Trialling composite plots",
                  tag_levels = "a")





