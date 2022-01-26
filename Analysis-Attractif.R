##========================================================##
##                                                        ##
##   Network Visualization with R                         ##
##   Reproducible Research ENSGSi, France                 ##
##                                                        ##
##   Fabio CRUZ                                           ##
##   Web: kateto.net | Email: katya@ognyanova.net         ##
##   GitHub: kateto  | Twitter: @Ognyanova                ##
##                                                        ##
##========================================================##



# ================ Purpose of the analysis ================

# Create a reproductible Script that enables the analysis the


# CONTENTS
#
#   1. Working with colors in R plots
#   2. Reading in the network data
#   3. Network plots in 'igraph'
#   4. Plotting two-mode networks
#   5. Plotting multiplex networks
#   6. Beyond igraph: Statnet & ggraph
#   7. Simple plot animations in R
#   8. Interactive JavaScript networks
#   9. Interactive and dynamic networks with ndtv-d3
#  10. Plotting networks on a geographic map


# KEY PACKAGES
## Install those now if you do not have the latest versions. ----
install.packages("tidyverse")  # Tidyverse approach for Data science
install.packages("readxl")


## Load the packages ----
library(tidyverse)
library(readxl)  # Read a Excel File


#  1. Reading the Excel Data ----





# Base de Donnes
?mpg
mpg <- mpg
# Creation de Graphique
ggplot(data = mpg)  +
  aes(x = displ, y = hwy) +
  geom_point()

# Nuages de Points
ggplot(data = mpg) +
  aes(x = class, y = hwy) +
  geom_boxplot()



















