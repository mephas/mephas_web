##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyUI(
tagList(
#shinythemes::themeSelector(),
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########

navbarPage(
 
  title = "Chi-Square Test for Contingency Table",

##---------- Panel 1 ----------
tabPanel("2 by 2",

titlePanel("Chi-square Test for Case-Control Status and Two Independent Samples"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the population are the same in the 2 independent samples 
      <li> To determine if the population are homogeneity

    </ul>

    <h4><b> 2. About your Data </b></h4>

      <ul>
      <li> You have 2 categories for case-control status (usually as row names)
      <li> You have 2 samples for 2 factor status (usually shown as column names)
      <li> 2 samples are independent data
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),

source("p1_ui.R", local=TRUE)$value
    ),

##---------- Panel 2 ----------
tabPanel("2 by C",

titlePanel("Chi-square Test for Case-Control Status"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the population rate/proportion behind your multiple Groups data are significantly different </ul>

    <h4><b> 2. About your data </b></h4>

      <ul>
      <li> Your Groups data come from binomial distribution (the proportion of success)
      <li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
      <li> The multiple Groups are independent observations
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr()

#source("p2_ui.R", local=TRUE)$value
    ),

##---------- Panel 3 ----------

tabPanel("R by C",

titlePanel("Chi-square Test for R by C Table"),

HTML("
<b> Notes </b>

<ul>

<li> R x C contingency table is a table with R rows (R categories) and C columns (C categories)
<li> To determine whether there is significant relationship between two discrete variables, where one variable has R categories and the other has C categories

</ul>

<b> Assumptions </b>

<ul>

<li> No more than 1/5 of the cells have expected values < 5
<li> No cell has an expected value < 1

</ul>

  "),

hr()
#source("p3_ui.R", local=TRUE)$value
),


##---------- Panel 4 ----------

tabPanel("2 x K ",

titlePanel("Test for Trend"),


hr()

#source("p4_ui.R", local=TRUE)$value

),

##---------- Panel 5 ----------

tabPanel("K by K",

titlePanel("Kappa Statistic"),

p("To qualify the degree of association. This is particularly true in reliability studies, where the researcher want to qualify the reproducibility of the same variable measured more than once."),

hr()
#source("p5_ui.R", local=TRUE)$value

)

##########----------##########----------##########

,
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help5.R",local=TRUE, encoding="UTF-8")$value


))
)

