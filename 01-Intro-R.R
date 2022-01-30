# ================ Purpose of the analysis ================

# Create a reproductible Script that enables the analysis of the AttrakDiff Methodology


# ATOMS: Fonctions & Objets -----

# 1. Clasess:
#   - Numerical, Character, Integer or Logical
# 2. Objects
#   - Vectors, Lists, Data frames,  Factors.
# 3. Operations
#   - Subsetting, Logical subsetting



## As Calculator: Interface, Using the console and  Basic Operations ----

1 + 2
5 - 2
2 * 3
3 * 2
2 / 2
24 %% 11 # Check the Help Panel
25 %/% 2 # Check the Help Panel

# Considering the Parenthesis
3 + 5 * 2
(3 + 5) * 2
(3 + (5 * (2 ^ 2))) # What is the order of the Precedence




## Functions -----
# Trigonometric Functions
?sin(20)
cos(20)
log(30)
sqrt(40)

rnorm(100)
?rnorm
args(rnorm)
rnorm(100, mu = 100, sd = 50)



## Variables and Assignation '<-' ----
# Asignation symbol '<-' Shortcut (ALT + '-' )
?"<-" # See the Help

aleatoire = rnorm(100, mu = 100, sd = 50)
aleatoire <-  rnorm(100, mu = 100, sd = 50)

### Recommendation with the names of Variables:
# Source: http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf

# Principles:
# - 1) Machine readable // Human readable // Plays well with default ordering

# 1) Machine readable

Var_1 <- 2      # Names can contain Letters, Numbers and symbols `.` et `_`. without spaces
2_Var <- 4      # Don't Start by a number
é <- 3          # Attention to the accent
Var% <- 2       # Wrong

a <- 1;  A <- 3 # case sensitivity
a == A

# 2) Human readable
"taille_conj1" -> Good
"taille_du_conjoint_numero_1" -> trop_long
"t1" -> pas_assez_explicite

# 3) Plays well with default ordering
helper01_load-counts
helper02_load-exp-des
helper03_load-focus-statinf
helper04_extract-and-tidy





## Numerical ----
a <- 2+2
b <- 5-7
c <- 4*12
d <- 10/3
e <- 5^2
Resultat <- a + b + c +d +e

## Character ----
Text_1 <- "Hello students, Today is"
Text_2 <- "Tuesday 01/02 "

paste(Text_1, Text_2)

Sys.Date() # Function to know the Date
paste(Text_1, Sys.Date(), sep = ": ")


## Integer ----
a_int <- 20L
b_int <- 30L
typeof(a_int)

## Logical ----
a_log <- TRUE
b_log <- FALSE
typeof(a_int)


## Objects in R ----
### Vectors ----
# Les vecteurs sont l’un des objets de base de R et correspondent à une liste de valeurs.
#La fonction `c()` ('*combination fonction*') permet de creer de vecteur:

c(1, 2, 3)
c('d', 'e', 'f')
c(1, 2, 'f')

numbers_odd <- c(1, 3, 5, 7)
texte <- c("Bonjour", "comment", "ça va", "?")

Exercise <- c(1, 2, 3,  "4", "5", 6) # What' is Wrong

# Operator ':'
numbers <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
numbers <- c(1:10)
rep(2, 3)
rep(numbers, 2)
rep(c(1:3, 8:11), 2)


# Operation with vectors
10*numbers
numbers + numbers
numbers^2

# Graphics (Basic)
plot(x= numbers , y = numbers^2 )

y_axis <- numbers^2 +  2*numbers
plot(x= numbers , y = numbers^2 )




### List ----

v1 <- c("Maelle", "Luca", "Sandrine", "Marcelo", "Jean")
v2  <-  c(188, 173, 187, 164, 178,)
v3 <- c(32, 23, 35, 35, 54)

a_list <- list(etudiant = v1,
               taille = v2,
               age = v3 )
a_list

a_list$etudiant
a_list$taille
a_list$age

### Dataframes ----

ID <- c(1:5)
etudiants <- c("Maelle", "Luca", "Sandrine", "Marcelo", "Jean")
taille  <-  c(188, 173, 187, 164, 178)
age <- c(32, 23, 35, 35, 54)
fumeur <- c(TRUE, FALSE, TRUE, FALSE, FALSE)

table <- data.frame(ID, etudiants, taille, age, fumeur)
table$etudiants


# Subsetting ----
# Vectors
etudiants[1]
etudiants[c(1,2)]
etudiants[c(1,2,3)]
etudiants[1:4]

# Dataframe
table[1]
table[[1]]
table$etudiants
table["etudiants"]
table[1, 1] #table[row, column]
table[1, 4]
table[1, 5]

table[, 1]
table[1, ]

## FUnctions

length(tailles)
min(tailles)
max(tailles)
sum(tailles)
mean(tailles)
range(tailles)




# Exercise
#Determinez:
# Age moyenne des des étudiants dans la variable `moyenne_global`.
# Longueur du vecteur étudiants. (voir `?length`)




# Explaining the notion of Packages ----
# Show: https://cran.r-project.org/



References
1. https://swcarpentry.github.io/r-novice-gapminder-es/
2. https://moderndive.com/index.html
3. https://flor14.github.io/Fundamentos_de_R/
















