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
tabPanel("Normal",

headerPanel("Normal Distribution"),

  HTML(
    " 
    <h4><b> What can you do on this page</b></h4>
   <ul>
    <li> Draw a Normal Distribution with N(&#956, &#963); &#956 is the location, and &#963 indicates the shape
    <li> Compare your data to a Normal Distribution 
   </ul>
    "
    ),

  hr(),

source("p1_ui.R", local=TRUE)$value,

hr()
)
,

##---------- Panel 2 ---------
tabPanel("Exponential",

headerPanel("Exponential Distribution"), 

  HTML(
    " 
    <h4><b> What can you do on this page</b></h4>
   <ul>
    <li> Draw an Exponential Distribution with E(Rate); Rate indicates the rate of change
    <li> Compare your data to an Exponential Distribution 
   </ul>
    "
    ),

  hr(),

source("p2_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 3 ---------
tabPanel("Gamma",

headerPanel("Gamma Distribution"), 

  HTML(
    " 
    <h4><b> What can you do on this page</b></h4>    
   <ul>
    <li> Draw a Gamma Distribution with Gamma(&#945, &#952); &#945 controls the shape, 1/&#952 controls the change of rate
    <li> Compare your data to a Gamma Distribution 
   </ul>
    "
    ),

  hr(),

source("p3_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 4 ---------
tabPanel("Beta",

headerPanel("Beta Distribution"), 

  HTML(
    " 
    <h4><b> What can you do on this page</b></h4>    
   <ul>
    <li> Draw a Beta Distribution with Beta(&#945, &#946); &#945, &#946 controls the shape
    <li> Compare your data to a Beta Distribution 
   </ul>
    "
    ),

  hr(),

source("p4_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 5 ---------
tabPanel("T",

headerPanel("Student's T Distribution"), 

  HTML(
    " 
    <h4><b> What can you do on this page</b></h4>    
   <ul>
    <li> Draw a T Distribution with T(v); v is the degree of freedom related to your sample size and control the shape 
    <li> Compare your data to a T Distribution 
   </ul>
    "
    ),

  hr(),

source("p5_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 6 ---------
tabPanel("Chi",

headerPanel("Chi-Squared Distribution"), 

  HTML(
    " 
    <h4><b> What can you do on this page</b></h4>    
   <ul>
    <li> Draw a Chi-Squared Distribution with Chi(v); v is the degree of freedom related to your sample size and control the shape 
    <li> Compare your data to a Chi-Squared Distribution 
   </ul>
    "
    ),

  hr(),

source("p6_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 7 ---------
tabPanel("F",

headerPanel("F Distribution"), 

  HTML(
    " 
    <h4><b> What can you do on this page</b></h4>    
   <ul>
    <li> Draw a F Distribution with F(df1, df2) ; df1 and df2 are the degree of freedom related to your sample size and control the shape 
    <li> Compare your data to a F Distribution 
   </ul>
    "
    ),

  hr(),

source("p7_ui.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########

##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help1.R",local=TRUE, encoding="UTF-8")$value


))
)



