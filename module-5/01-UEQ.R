# ================ UEQ Script for data analysis ================
# Create a reproductible Script that enables the analysis of the UEQ Methodology

# CONTENTS
#   1. Reading the Excel/CSV Data
#   2. Treating CSV Data
#   3. Making the Tables and the Graphics
#   4. Introduce the results in Rmarkdown table.


## Load the packages ----
library(tidyverse) # Data Science Tools
library(readxl)  # Read a Excel File


#  1. Reading the CSV Data ----
UEQ <- read_csv('UEQ.csv')

## Quantity of participants
total <- nrow(UEQ)


## Obtaining the names of the columns
names(UEQ)


#  2. Treating CSV Data ----

## Pivot_longer() to arrange each variable
Step.1 <-
   UEQ %>% pivot_longer(cols = c(EFF1 : ATT6),
                               names_to = "Variables",
                               values_to = "Answers")


##. 2.2 Changing the scale of the certains answers ----
### Reading the Excel for the Parameters
onglets <- excel_sheets("Parameters.xlsx") # Identify the onglets

# Reading all table
Parameters_UEQ <-
   read_excel(path = "Parameters.xlsx", sheet = onglets[2] )



## Step 2
Step.2 <- #<<
  Step.1 %>% #<<
  mutate(
    change_scale = #<<
      case_when(
        Answers == 1  ~  -3, #<<
        Answers == 2  ~  -2,  #<<
        Answers == 3  ~  -1,  #<<
        Answers == 4  ~  0,  #<<
        Answers == 5  ~  1,  #<<
        Answers == 6  ~  2,  #<<
        Answers == 7  ~  3,  #<<
        TRUE ~ 99 #<< ## High number if a problem arrives
      )
  )

### Inversing the Scale option 1
toInvert <-
   c("EFF1", "EFF4",
     "PERS2", "PERS4",
     "DEP3", "DEP4",
     "STIM1", "STIM4",
     "NOV1",  "NOV2",
     "ATT2", "ATT5", "ATT6")

### Option 2
toInvert <- Parameters_UEQ %>% filter(Inversion == "Yes") %>% pull(Variables)


### Changing the sign of the answers : Approach Explicit
Step.3 <-
  Step.2 %>% mutate(
      Final_value =
         case_when(
            Variables %in% toInvert ~ change_scale*(-1),
            TRUE ~ change_scale
         )
   )


## 2.3 Groups of the Dimmensions ----
Step.4 <-
  Step.3 %>%
  left_join(Parameters_UEQ, by = "Variables")


#  3. Graphic I ----
## 3.1 Calculating the mean values and the error
Table_I <-
  Step.4 %>%
   group_by(Scale) %>%
   summarise(Moyenne = mean(Final_value),
             Std = sd(Final_value),
             Se = Std / sqrt(length(Final_value)))


Graph_I <-
   Table_I %>%
   ggplot() +
   aes(x= Scale, y=Moyenne) +
   geom_bar(stat = "identity") +
   geom_errorbar( aes(x=Scale,
                      ymin = Moyenne - Se,
                      ymax = Moyenne + Se ),
                  width=0.1, colour="orange", alpha=0.9, size=0.5) +
   geom_point() +
   coord_flip() +
   scale_x_discrete( name = "UEQ Results") +
   scale_y_continuous(limits = c(-3,3), breaks = c(-3:3)) +
   annotate("rect", ymin=c(-0.8), ymax=c(0.8),
            xmin=c(0), xmax=c(7),
            alpha = .1 , fill = c("orange")) +
   ggplot2::annotate("text",
                     y = c(2),
                     x = c(4),
                     label = c("Zone Neutre"),
                     family = "Palatino", fontface = 3, size=3) +
   labs(x = "",
        y = "Level ",
        title = "UEQ Profile for XXX",
        subtitle = paste("Total of answers:" , total)
   ) +
   theme_minimal(base_size = 12, base_family = "Palatino")

# Saving the File
#ggsave("Figures/UEQ-1.jpg", width = 10, height = 5, dpi="print" )



#  4. Graphic II ----
## 4.1 Grouping the mean values and the error

Parameters_UEQ$Scale %>% as.factor() %>%  levels()

Step.5 <-
  Step.4 %>% mutate(
      Global_scale =
         case_when(
            str_detect(Scale, "Compréhensibilité") ~ "Qualité Pragmatique (QP)",
            str_detect(Scale, "Efficacité") ~ "Qualité Pragmatique (QP)",
            str_detect(Scale, "Contrôlabilité") ~ "Qualité Pragmatique (QP)",

            str_detect(Scale, "Originalité") ~ "Qualité Hédonique",
            str_detect(Scale, "Stimulation") ~ "Qualité Hédonique",

            str_detect(Scale, "Attraction") ~ "Attraction",
            TRUE ~ "ATTENTION"
         ))


Table_II <-
  Step.5 %>%
   group_by(Global_scale) %>%
   summarise(Moyenne = mean(Final_value),
             Std = sd(Final_value),
             Se = Std / sqrt(length(Final_value)))

Graph_II <-
   Table_II %>%
   ggplot() +
   aes(x= Global_scale, y=Moyenne) +
   geom_bar(stat = "identity") +
   geom_errorbar( aes(x=Global_scale,
                      ymin = Moyenne - Se,
                      ymax = Moyenne + Se ),
                  width=0.1, colour="orange", alpha=0.9, size=0.5) +
   geom_point() +
   #coord_flip() +
   scale_x_discrete( name = "UEQ Results") +
   scale_y_continuous(limits = c(-3,3), breaks = c(-3:3)) +
   # annotate("rect", ymin=c(-0.8), ymax=c(0.8),
   #          xmin=c(0), xmax=c(7),
   #          alpha = .1 , fill = c("orange")) +
   # ggplot2::annotate("text",
   #                   y = c(2),
   #                   x = c(4),
   #                   label = c("Zone Neutre"),
   #                   family = "Palatino", fontface = 3, size=3) +
   labs(x = "",
        y = "Level ",
        title = "UEQ Profile for XXX",
        subtitle = paste("Total of answers:" , total)
   ) +
   theme_minimal(base_size = 12, base_family = "Palatino")

# Saving the File
#ggsave("Figures/UEQ-2.jpg", width = 10, height = 5, dpi="print" )



#  5. Graphic III ----

## Making the graphic per Variable Item

Table_III <-
   Step.5 %>%
   group_by( Variables ) %>%
   summarise( Moyenne = mean(Final_value))


Graph_III <-
   Table_III %>%
   ggplot() +
   aes(x = Variables, y=Moyenne, group =1) +
   geom_line( color="grey" ) +
   geom_point() +
   scale_y_continuous(name="Moyenne", breaks=seq(-3,3,1), limits=c(-3, 3))+
   # scale_x_discrete(name="Items",
   #                  labels= c())+
   coord_flip() +
   annotate("rect", xmin=c(1,7,11,15, 19, 23), xmax=c(6,10,14,18, 22, 26),
            ymin=rep(-3,6), ymax=rep(3, 6),
            alpha = .1 , fill = c("blue", "red", "grey","green", "orange", "yellow")) +
   ggplot2::annotate("text",
                     y = c(2, 2, 2, 2, 2, 2),
                     x = c(4, 8, 12, 16, 20, 23),
                     label = c("Attraction",
                               "Contrôlabilité",
                               "Efficacité",
                               "Originalité",
                               "Compréhensibilité",
                               "Stimulation"
                               ),
                     family = "Palatino", fontface = 3, size=3) +
   theme_minimal(base_size = 12, base_family = "Palatino") +
   labs(x = "",
        y = "Level ",
        title = "AtrakDiff Profile",
        subtitle = paste("Total of answers:" , total ),
        caption = "Group X") +
   theme(
      legend.position = "right",
      panel.border = element_blank(),
      panel.spacing = unit(0.1, "lines"),
      strip.text.x = element_text(size = 18, family = "Palatino")
   )

# Saving the File
#ggsave("Figures/UEQ-3.jpg", width = 10, height = 5, dpi="print" )


