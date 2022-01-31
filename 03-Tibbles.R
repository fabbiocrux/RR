#  Purpose of this tutorial
# Understand the Manipulation of Tables with Tidyverse tools

# Organims: Ggplot -----

# - `select()` et `filter()`, qui permettent de selectionner des colonnes et des lignes d'un jeu de données
# - `arrange()`, qui vous permet de réordonner les lignes d'un jeu de données
# - `%>%`, qui organise votre code sous la forme de "pipes" faciles à déchiffer (un pipe peut être vu comme un flux dans lequel divers traitements sur les données sont enchaînés)
# - `mutate()`, `group_by()`, et `summarize()`, servent à calculer des statistiques descriptives


# Load the packages
library(tidyverse)
library(readxl)  # Package for read Excel documents

# Load the Data.
prenoms <- read_csv2(here("data/prenoms_france.csv")) # Coming from library(prenoms)
str(prenoms)

# Select function  ----
# Select the different columns of the data

## We learned '$' from last section.
prenoms$year # Explaining the limits: One at the time


select(prenoms, name, year)
#select(prenoms, name)
#select(prenoms, name, year)
#select(prenoms, year, sex, name, n)

## Exclusion of the columns
select(prenoms, -sex)

## Selection of range of columns
select(prenoms, year:n)

## Columns that contains a string
select(prenoms, contains("e"))

## Columns that starts with a string
select(prenoms, starts_with("n"))

## Columns that ends with a string
select(prenoms, ends_with("P"))

## Columns whose name appear in the given set
select(prenoms, one_of(c("sex", "name")))





# Filter function ----

## Logical operators
#   == (Equal to)
#   != (Not equal to)
#   < (Less than)
#   <= (Less than or equal to)
#   > (Greater than)
#   >= (Greater than or equal to)


filter(prenoms, name == "Fabio")
filter(prenoms, name != "Fabio")
filter(prenoms, prop < 0.00001) # For numeric
filter(prenoms, name < "Ab") # For Character


## Combination of logical tests

# - & (logical AND) --> Est-ce que les conditionsA et B sont toutes les deux vraies ?
# - | (logical OR) --> Est-ce que l’ une ou les deux conditions  A et B sont vraies ?
# - ! (logical NOT) --> Est-ce que A n’est pas vraie ?
# - %in%  --> Est-ce que x est dans l’ensemble a, b, et c ?

test <- filter(prenoms, name == "Fabio" & year == 2018)
test <- filter(prenoms, name == "Fabio" | name == "Giovanny")
test <- filter(prenoms, !name == "Fabio")
test <- filter(prenoms, name %in% c("Fabio", "Giovanny", "Mauricio"))

#test <- filter(prenoms , xor(name == "Fabio", year == 2018)) # Esta condicion o esta
#test <- filter(prenoms, name == "Fabio" | year == 2018)
#test <- filter(prenoms , all(name == "Fabio", year == 2018)) # Esta condicion o esta



# Arrange function ----
test <- arrange(prenoms, year)
test <- arrange(prenoms, desc(year))


# slice ----
slice(prenoms, 1)
slice(prenoms, 1:5)
slice_head(prenoms, n=15)
slice_tail(prenoms, n=15)


## Exercise: Determinez le prenom masculin le plus utilisé l'anne 2018
boys_2018 <- filter(prenoms, year == 2018, sex == "M")
boys_2018 <- select(boys_2018, name, n)
boys_2018 <- arrange(boys_2018, desc(n))
boys_2018

# https://www.r-graph-gallery.com/267-reorder-a-variable-in-ggplot2.html
prenoms %>%
  filter(year == 2018, sex == "M") %>%
  arrange(desc(n)) %>%
  #mutate(name = fct_reorder(name, n)) %>%  # to explain
  slice(1:10) %>%
  ggplot() +
  aes(x = name, y = n) +
  geom_bar(stat = 'identity')+
  coord_flip()

# Pipe operator ----
## Shorcut: Ctr/Cmd + Shift + M

prenoms %>%
  filter(year == 2018, sex == "M") %>%
  select(name, n) %>%
  arrange(desc(n)) %>%
  slice(1)


# Exercise: Plotting your Name throu
prenoms %>%
  filter(name == "Fabio", sex == "M") %>%
  ggplot() +
  aes(x = year, y = n) +
  geom_line() +
  labs(title = "Popularité du prénom Fabio en France") +
  theme_minimal()

# Exercise: Compare your name with other that you want
prenoms %>%
  filter(name == "Fabio" | name == "Mauricio") %>%
  ggplot() +
  aes(x = year, y = n, color = name) +
  geom_line() +
  labs(title = "Popularité du prénom Fabio en France") +
  theme_minimal()


