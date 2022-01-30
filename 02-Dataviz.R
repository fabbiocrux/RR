#  Purpose of this section
# Understand the creation of reproducible graphics


# Molecules: Ggplot -----
# 1.  Créer des graphiques avec un **modèle** (ou **template**) {ggplot2} réutilisable
# 2.  Ajouter des variables à un graphique avec **aesthetics**
# 3.  Sélectionner le "type" de votre graphique avec **geoms**


# Load the packages
library(tidyverse)
library(ggplot2) # Package for professional graphics
library(readxl)  # Package for read Excel documents

# Loading the data
literature <- read_tsv(here("data/web-of-sciences.txt"))


data <- mpg # data that present in the ggplot package
str(data)


# Basic Model for Graphics
# ggplot(data = <DATA>) +
#   aes(x = <X>, y = <Y>) +
#  <GEOM_FUNCTION>()


# Graphic Scatterplot (Nuage de Points) Complete
ggplot(data = mpg) +
  aes(x = displ, y = hwy) +
  geom_point(color = "blue") +
  labs(title="Gasoline Consumption in function of engine displacement",
      subtitle="Data source from mpg in ggplot package",
       y="Highway miles per gallon (Mile / US gal)",
       x="Engine displacement (litres)",
       ) +
  geom_smooth(method = lm, formula = y ~ x, se = TRUE) +
  stat_regline_equation(label.x = 5) + #using library(ggpubr) +
  stat_cor( aes( label = ..rr.label..) , label.x = 5, label.y = 40) + # Add P-values to a
  theme_minimal( base_family = "Palatino")


# Grafique de boxplot
ggplot(data = mpg) +
  aes(x = manufacturer, y = hwy)  +
  geom_boxplot() +
  coord_flip()



# Explanation of the element we can change
ggplot() +
  geom_point(aes(1, 1), size = 20) +
  geom_point(aes(2, 1), size = 10) +
  geom_point(aes(3, 1), size = 20, shape = 17) + # Playing with Size http://www.sthda.com/english/wiki/ggplot2-point-shapes
  geom_point(aes(4, 1), size = 20, colour = "blue") +
  scale_x_continuous(NULL, limits = c(0.5, 4.5), labels = NULL) +
  scale_y_continuous(NULL, limits = c(0.9, 1.1), labels = NULL) +
  theme(aspect.ratio = 1/3)


# Playing with the Color
ggplot(data = mpg) +
  aes(x = displ, y = hwy, color = class) +
  geom_point()


# Playing with the Size
ggplot(data = mpg) +
  aes(x = displ, y = hwy, size = class) + # No making sense
  geom_point()

# Solution Two
ggplot(mpg) +
  aes(x = displ, y = hwy) +
  geom_count() +
  labs(size = "Quantity of Vehicules") +
  scale_size(breaks = c(2, 4, 6, 8))
  theme_bw()

# Alpha
  ggplot(data = mpg) +
    aes(x = displ, y = hwy, alpha = class ) + # changing for cty
    geom_point()

# Shape
ggplot(data = mpg) +
  aes(x = displ, y = hwy, shape = class) + # changing for drv
  geom_point()


# Exercise:  Représentez `cty` avec color
ggplot(data = mpg) +
  aes(x = displ, y = hwy, color = cty) +
  geom_point()

# Ex: Représentez `cty` avec size
ggplot(data = mpg) +
  aes(x = displ, y = hwy, size = cty) + # Explanation of the problem
  geom_point()

# Ex: Représentez `cty` avec shape
ggplot(data = mpg) +
  aes(x = displ, y = hwy, shape = cty) + # Explanation of the problem
  geom_point()


# Ex: Représentez `class` avec `color`, `size`, et `shape` dans un même graphique.
#Est-ce que cela fonctionne ?

ggplot(data = mpg) +
  aes(x = displ, y = hwy, color = class, shape = class , size = class ) +
  geom_point()

ggplot(data = mpg) +
  aes(x = displ, y = hwy, color = class, shape = fl, alpha = displ) +
  geom_point()


# Logical subsetting for Color
ggplot(data = mpg) +
  aes(x = displ, y = hwy, color = displ < 5) +
  geom_point()

# Color General
ggplot(mpg) +
  aes(displ, hwy) +
  geom_point(color = "red")

# Color particular
ggplot(data = mpg) +
  aes(x = displ, y = hwy, color = "blue") +
  geom_point()

# Making sense of Alpha
ggplot(data = mpg) +
  aes(x = displ, y = hwy) +
  geom_point(color = "blue", shape = 3, alpha = 0.5)



# References
# - https://policyviz.com/hmv_post/pollution-infographic/
