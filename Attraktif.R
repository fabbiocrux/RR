# ================ Purpose of the analysis ================

# Create a reproductible Script that enables the analysis of the AttrakDiff Methodology


# CONTENTS
#   1. Reading the Excel Data
#   2. Treating Excel Data
#   3. Making the Tables and the Graphics
#   4. Introduce the results in Rmarkdown table.


# KEY PACKAGES
## Install those now if you do not have the latest versions. ----
#install.packages("tidyverse")  # Tidyverse approach for Data science
#install.packages("readxl")


## Load the packages ----
library(tidyverse) # Data Science Tools
library(readxl)  # Read a Excel File



#  1. Reading the Excel Data ----

# Identify the onglets
onglets <- excel_sheets("data/Data.xlsx")

# Reading all table
data <- read_excel(path = "data/Data.xlsx" )

# Reading all table but considering as title the second row
data <- read_excel(path = "data/Data.xlsx" , skip = 1)

# Obtaining the names of the columns
names(data)

# Eventually changing a name of the column
col_names <- names(data)
col_names[1] <- c("Participant")
names(data) <- col_names
names(data)


#  2. Treating Excel Data ----
# Pivot_longer() to arrange each variable
data <-
  data %>% pivot_longer(cols = -Participant,
                        names_to = "Variables",
                        values_to = "Answers")


# Changing the scale of the answers
data <-
  data %>% mutate(
    change_scale =
      case_when(
        Answers == 7  ~ 3,
        Answers == 6  ~ 2,
        Answers == 5  ~ 1,
        Answers == 4  ~ 0,
        Answers == 3  ~ -1,
        Answers == 2  ~ -2,
        Answers == 1  ~ -3,
        TRUE ~ as.numeric(Answers)
      )
  )

#View(data)

# Changing the sign of the answers : Approach Explicit
data <-
  data %>% mutate(
    final_answer =
      case_when(
        Variables %in%
          c("ATT1*", "ATT3*","ATT5*",
            "ATT7*", "QHI2*", "QHI3*", "QHI6*",
            "QHS1*", "QHS3*", "QHS4*", "QP1*",
            "QP2*", "QP3*", "QP5*")  ~ as.numeric(change_scale)*(-1),
        TRUE ~ as.numeric(change_scale)
      )
  )

#View(data)

# Changing the sign of the answers : Approach by Character
data <-
  data %>% mutate(
    final_answer_II =
      case_when(
        str_detect(Variables, "\\*") ~ as.numeric(change_scale)*(-1),
        TRUE ~ as.numeric(change_scale)
      ))

# Doing the Groups of the Dimmensions
data <-
  data %>% mutate(
    Factors =
      case_when(
        str_detect(Variables, "QP") ~ "QP",
        str_detect(Variables, "QP1") ~ "QP",
        str_detect(Variables, "QHS") ~ "QHS",
        str_detect(Variables, "QHI") ~ "QHI",
        str_detect(Variables, "QH1") ~ "QHI",
        str_detect(Variables, "ATT") ~ "ATT",
        TRUE ~ "ATTENTION"
      ))


#  3. Making the Graphics  ----

Table_I <-
  data %>%
  group_by(Factors) %>%
  summarise(Moyenne = mean(final_answer),
            Std = sd(final_answer),
            se = Std / sqrt(length(final_answer))
  )

# More Info: # https://www.r-graph-gallery.com/4-barplot-with-error-bar.html

Graph_I <-
  Table_I %>%
  ggplot() +
  aes(x= Factors, y=Moyenne , fill = Factors ) +
  geom_bar(stat = "identity") +
  geom_errorbar( aes(x=Factors, ymin=Moyenne-se,
                     ymax=Moyenne+se),
                 width=0.1, colour="orange", alpha=0.9, size=0.5) +
  geom_point() +
  coord_flip() +
  scale_x_discrete(breaks=c("ATT","QHI","QHS","QP"),
                   labels=c("Attractivité Globale",
                            "Qualité hédonique - Identification",
                            "Qualité hédonique - Stimulation",
                            "Qualité Pragmatique")) +
  scale_y_continuous(limits = c(-3,3)) +
  labs(x = "",
       y = "Level ",
       title = "AtracDiff Profile for XXX",
       subtitle = paste("Total of answers:" , max(data$Participant))
  )+
  theme_minimal(base_size = 12, base_family = "Palatino")



# Saving the File
#ggsave("Results/Graph-1.jpg", width = 5, height = 8, dpi="print" )


#  4. Graphic 2 ----

# Reading only first row for the titles
titles <- read_excel(path = "data/Data.xlsx") %>% slice(1)
#View(titles)

# We need to change into long format to be able to work with the titles
titles <-
  titles %>% select(-1) %>%
  pivot_longer(cols = everything(), names_to = "Label Incorrect", values_to = "Variables") %>%
  separate(col = "Label Incorrect", into = c("Left", "Right"), sep = "-")


# Changing the Label to the correct format
titles <-
  titles %>%
  mutate(
    Correct_label =
      case_when(
        str_detect(Variables, "\\*") ~ paste(Right, Left, sep = " - "),
        TRUE ~ paste(Left, Right,  sep = " - ")
      ))


# Joinning the Data with the correct Titles
data <-
  data %>%
  left_join(titles %>% select(Variables, Correct_label),
            by = "Variables")

# Calculating the mean value by each Variables
Table_II <-
  data %>%
  group_by(Variables) %>%
  summarise(Media = mean(final_answer))


# Selecting only the data that I have interests
Graph_II <-
  Table_II %>%
  left_join( data %>% select(Variables, Factors, Correct_label) %>% unique(),
             by = "Variables"
  ) %>%
  select(Factors, Variables, Media, Correct_label) %>%
  arrange(Factors, Variables)


# Order Factors
# as.factor(Graph_II$Correct_label) %>% levels()
Graph_II$Correct_label <- factor(Graph_II$Correct_label, levels = Graph_II$Correct_label)


# Making the Graphic
Graph_II <-
  Graph_II %>%
  ggplot(aes(x= Correct_label, y= Media, color = Factors , group=1 )) + #
  geom_point() +
  geom_line() +
  annotate("rect", xmin=c(1,8,15,22), xmax=c(7,14,21,28),
           ymin=rep(-3,4), ymax=rep(3, 4),
           alpha = .1 , fill = c("blue", "red", "grey","green")) +
  coord_flip(xlim = NULL, ylim = c(-3,5)) +
  scale_y_continuous(breaks=c(-3:4),
                     labels=c(-3:3, " ")) +
  ggplot2::annotate("text",
                    y = c(2, 2, 2, 2),
                    x = c(4, 11, 19, 26),
                    label = c("Attractivité \n globale",
                              "Qualité \n hédonique - identification",
                              "Qualité \n hédonique - stimulation",
                              "Qualité \n pragmatique"),
                    family = "Palatino", fontface = 3, size=3) +
  theme_minimal(base_size = 10, base_family = "Palatino") +
  labs(x = "",
       y = "Level ",
       title = "AtrakDiff Profile",
       subtitle = paste("Total of answers:" , max(data$Participant) ) ) +
  theme(
    legend.position = "right",
    panel.border = element_blank(),
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 18, family = "Palatino")
  )





# Final Graphic III
QH <-
  data %>%
  filter(Factors == "QHI" | Factors == "QHS") %>%
  summarise(QH = mean(final_answer),
            QH_sd = sd(final_answer),
            QH_IC_min = t.test(final_answer)$conf.int[1], # see https://larmarange.github.io/analyse-R/intervalles-de-confiance.html
            QH_IC_max = t.test(final_answer)$conf.int[2]
  )


QP <-
  data %>%
  filter(Factors == "QP") %>%
  summarise(QP = mean(final_answer),
            QP_sd = sd(final_answer),
            QP_IC_min = t.test(final_answer)$conf.int[1], # see https://larmarange.github.io/analyse-R/intervalles-de-confiance.html
            QP_IC_max = t.test(final_answer)$conf.int[2]
  )


Table_III <- tibble(QH, QP)
names(Table_III)



Graph_III <-
  Table_III%>%
  ggplot() +
  aes(x=QP, y=QH) +
  geom_point()+
  ylim(-3,3)+ xlim(-3,3) +
  geom_hline(yintercept=c(-1,1))+
  geom_vline(xintercept=c(-1,1)) +
  annotate("rect", xmin = Table_III$QP_IC_min, xmax = Table_III$QP_IC_max,
           ymin = Table_III$QH_IC_min, ymax = Table_III$QH_IC_max,
           alpha = .5 , fill = c("blue")) +
  ggplot2::annotate("rect", xmin=c(-1), xmax=c(1),
                    ymin=c(-1), ymax=c(1),
                    alpha = .1 , fill = c("#009999")) +
  ggplot2::annotate("text",
                    y = c(0.5),
                    x = c(0),
                    label = c("Neutre"),
                    family = "Palatino", fontface = 3, size=4) +
  labs(title = "Global AttrakDiff ",
       subtitle = paste("Total of answers:" , max(data$Participant)),
       x = "Qualité Pragmatique",
       y = "Qualité Hedonique ") +
  theme_minimal(base_size = 10, base_family = "Palatino")




Results <- list(t1 = Table_I, t2 = Table_II, t3= Table_III,
                Fig_1= Graph_I, Fig_2 = Graph_II, Fig_3 = Graph_III)
