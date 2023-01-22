#  Purpose of this tutorial
# Deriving information from the Manipulation of Tables with Tidyverse tools

#Learning:
#- `mutate()`, `group_by()`, et `summarise()`, qui permettent d'utiliser vos données pour calculer de nouvelles variables et des statistiques récapitulatives

# Load the Data.
prenoms <- read_csv2(here("data/prenoms_france.csv")) # Coming from library(prenoms)
str(prenoms)


# Summarise() fonctions ----

### Example:1
prenoms %>%
  filter(name == "Fabio" & year > 2000 & year < 2019) %>%
  summarise(total = sum(n),
            max = max(n),
            moyenne = mean(n))

## Summarise the quantity of diverse names in a year
prenoms %>%
  filter(year > 2000 & year < 2019) %>%
   summarise(n = n(),
             distinct = n_distinct(name))

prenoms %>%
  filter(name == "Fabio" & year > 2000 & year < 2019) %>%
  ggplot() +
  aes(x=year, y=n)+
  geom_point()+
  geom_line()



# ?group_by() -----
prenoms %>%
  group_by(year, sex) %>%
  summarise(total = sum(n))


prenoms %>%
  group_by(year, sex) %>%
  summarise(total = sum(n)) %>%
  summarise(total = sum(total))



# mutate() ---
prenoms %>%
  mutate(percent = round(prop * 100, digits = 2))



