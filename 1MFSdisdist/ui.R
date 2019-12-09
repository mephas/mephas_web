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

title = "Discrete Probability Distribution",

##---------- Panel 1 ---------

tabPanel("Binomial",

titlePanel("Binomial Distribution, Poisson Distribution"),

  HTML(
    " 
    <h4><b> B(n,p)</b></h4>
   <ul>
    <li> Draw a Binomial Distribution
   </ul>
    "
    ),
  hr(),

source("p1_ui.R", local=TRUE)$value,
hr()

),

tabPanel("Poisson",

titlePanel("Poisson Distribution"),

  HTML(
    " 
    <h4><b> P(Rate)</b></h4>
   <ul>
    <li> Draw a Poisson Distribution
   </ul>
    "
    ),

source("p2_ui.R", local=TRUE)$value,
hr()

),
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help1.R",local=TRUE, encoding="UTF-8")$value


))
)



