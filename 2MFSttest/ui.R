
##----------#----------#----------#----------
##
## 2MFSttest UI
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########

navbarPage(
  
  title = "T Test for the Means",

##---------- Panel 1 ---------

tabPanel( "One Sample",

headerPanel("One-Sample T-Test"), 

  HTML(
    "

    <h4><b> 1. Goal </b></h4>
    <ul>
      <li> To determine if your data is statistically significantly different from the specified mean
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain only 1 group of values (or a vector)
      <li> The values are independent observations and approximately normally distributed
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

  hr(),

source("p1_ui.R", local=TRUE)$value


),

##---------- Panel 2 ---------

tabPanel("Two Samples",

headerPanel("Independent Two-Sample T-Test"),

    HTML(
    "
    <h4><b> 1. Goal </b></h4>
    <ul>
      <li> To determine if the means of two sets of your data are significantly different from each other
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain 2 separate groups/sets (or 2 vectors)
      <li> The 2 separate groups/sets are independent and identically approximately normally distributed
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

    "
    ),

    hr(),

source("p2_ui.R", local=TRUE)$value

    ),

##---------- Panel 3 ---------

tabPanel("Paired Samples",

    headerPanel("Dependent T-Test for Paired Samples"),

    HTML("

    <h4><b> 1. Goal </b></h4>
    <ul>
      <li> To determine if the differences from the paired 2 samples are equal to 0
    </ul>


    <h4><b> 2. About your data </b></h4>
      
      <ul>
      <li> The differences of paired samples are approximately normally distributed                           
      <li> Two samples that have been matched or paired 
      <li> The pairs are either one person's pre-test and post-test scores or between pairs of persons matched into meaningful groups
      </ul>                                         
      "
      ),

  helpText("A typical example of the pared sample is that the repeated measurements, where subjects are tested prior to a treatment, say for high blood pressure, and the same subjects are tested again after treatment with a blood-pressure lowering medication"),


   hr(),

   source("p3_ui.R", local=TRUE)$value

    ),

##########----------##########----------##########

##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help2.R",local=TRUE, encoding="UTF-8")$value

  )
 )
)

