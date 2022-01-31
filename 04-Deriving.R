#  Purpose of this tutorial
# Deriving information from the Manipulation of Tables with Tidyverse tools

#Learning:
#- `mutate()`, `group_by()`, et `summarise()`, qui permettent d'utiliser vos données pour calculer de nouvelles variables et des statistiques récapitulatives


## Summarise() fonctions

prenoms %>%
  filter(name == "Fabio" & year > 2000 & year < 2019) %>%
  summarise(total = sum(n), max = max(n), mean = mean(n))

prenoms %>%
  filter(name == "Fabio" & year > 2000 & year < 2019) %>%
  ggplot() +
  aes(x=year, y=n)+
  geom_point()+
  geom_line()
