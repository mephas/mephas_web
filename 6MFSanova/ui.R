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
  tabPanel("One-way",

  headerPanel("One-way ANOVA to Compare Means from Multiple Groups"),

    HTML(
    "
    <h4><b> 1. Goal </b></h4>
    <ul>
      <li> To determine if the means differ significantly among the groups 
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain several separate groups/sets shown in two vectors
      <li> One vector is the observed values; one vector is to mark your values in different groups
      <li> The separate groups/sets are independent and identically approximately normally distributed
      <li> Each mean of the groups follows a normal distribution with the same variance and can be compared
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

  hr(),

source("p1_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 2 ----------

tabPanel("Two-way",

  headerPanel("Two-way ANOVA to Compare Means from Multiple Groups"),

    HTML(
    "
    <h4><b> 1. Goal </b></h4>
    <ul>
      <li> To determine if the means differ significantly among the groups 
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain several separate groups/sets (or 2 vectors)
      <li> The separate groups/sets are independent and identically approximately normally distributed
      <li> Each mean of the groups follows a normal distribution with the same variance and can be compared
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

  hr(),

source("p2_ui.R", local=TRUE)$value,
hr()
),
#

##---------- Panel 3 ----------
  tabPanel("Pairwise",

    headerPanel("Multiple Comparison"),

    tags$b("Assumptions"),
    tags$ul(
      tags$li("Significant effects have been found when there are three or more levels of a factor"),
      tags$li("After an ANOVA, the means of your response variable may differ significantly across the factor, but it is unknown which pairs of the factor levels are significantly different from each other")
      ),
    hr(),
#source("p3_ui.R", local=TRUE)$value,
 hr()
  ),

##########----------##########----------##########

##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help6.R",local=TRUE, encoding="UTF-8")$value





)))

