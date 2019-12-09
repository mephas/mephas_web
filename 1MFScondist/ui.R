##----------#----------#----------#----------
##
## 1MFSdistribution UI
##
## Language: EN
## 
## DT: 2019-01-08
## Update: 2019-12-05
##
##----------#----------#----------#----------

shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(

title = "Continuous Probability Distribution",

##---------- Panel 1 ---------
tabPanel("Normal Distribution",

###---------- 1.1 ---------
headerPanel("Normal Distribution"), 

  HTML(
    " 
    <h4><b> Usage </b></h4>
   <ul>
    <li> Draw a Normal Distribution
    <li> Compare your data to a Normal Distribution 
   </ul>
    "
    ),

  hr(),

source("p1_ui.R", local=TRUE)$value,

hr()
)
,

##---------- Panel 1 ---------
tabPanel("Exponential Distribution",

###---------- 1.1 ---------
headerPanel("Exponential Distribution"), 

  HTML(
    " 
    <h4><b> Usage </b></h4>
   <ul>
    <li> Draw an Exponential Distribution
    <li> Compare your data to an Exponential Distribution 
   </ul>
    "
    ),

  hr(),

source("p2_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 1 ---------
tabPanel("Gamma Distribution",

###---------- 1.1 ---------
headerPanel("Gamma Distribution"), 

  HTML(
    " 
    <h4><b> Usage </b></h4>
   <ul>
    <li> Draw a Gamma Distribution
    <li> Compare your data to a Gamma Distribution 
   </ul>
    "
    ),

  hr(),

source("p3_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 1 ---------
tabPanel("Beta Distribution",

###---------- 1.1 ---------
headerPanel("Beta Distribution"), 

  HTML(
    " 
    <h4><b> Usage </b></h4>
   <ul>
    <li> Draw a Bets Distribution
    <li> Compare your data to a Beta Distribution 
   </ul>
    "
    ),

  hr(),

source("p4_ui.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########

##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help1.R",local=TRUE, encoding="UTF-8")$value


))
)



