##----------#----------#----------#----------
##
## 6MFSanova UI
##
## Language: EN
## 
## DT: 2019-04-07
##
##----------#----------#----------#----------
shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########
navbarPage(

  title = "Analysis of Variance",

##---------- Panel 1 ----------
  tabPanel(
    "One-way",

    headerPanel("One-way ANOVA"),

    tags$b("Assumptions"),
    tags$ul(
      tags$li("The differences of samples are numeric and continuous and based on the normal distribution"),
      tags$li("The data collection process was random without replacement."),
      tags$li("The samples are from the populations with same variances.")
      ),

source("p1_ui.R", local=TRUE)$value

    ),

##---------- Panel 2 ----------

  tabPanel(
    "Two-way",

    headerPanel("Two-way ANOVA"),

    tags$b("Assumptions"),
    tags$ul(
      tags$li("The populations from which the samples were obtained are normally or approximately normally distributed."),
      tags$li("The samples are independent."),
      tags$li("The variances of the populations are equal."),
      tags$li("The groups have the same sample size.")

      ),
source("p1_ui.R", local=TRUE)$value

    ), ##

##---------- Panel 3 ----------

  tabPanel(
    "Multiple Comparison",
    headerPanel("Multiple Comparison"),

    tags$b("Assumptions"),
    tags$ul(
      tags$li("Significant effects have been found when there are three or more levels of a factor"),
      tags$li("After an ANOVA, the means of your response variable may differ significantly across the factor, but it is unknown which pairs of the factor levels are significantly different from each other")
      ),
source("p1_ui.R", local=TRUE)$value
 
  ),

##########----------##########----------##########

##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help6.R",local=TRUE, encoding="UTF-8")$value





)))

