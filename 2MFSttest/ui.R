
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
  
  title = "Tests of Means",

##---------- Panel 1 ---------

tabPanel( "One Sample",

headerPanel("One Sample t-Test"),

  HTML(
    "
    <b>Notations </b>

      <ul>
      <li> X is the dependent observations  
      <li> &#956 is the population mean    
      <li> &#956&#8320 is the specific mean 
      </ul>

    <b>Assumptions </b>

      <ul>
      <li> X is numeric, continuous                                                             
      <li> Each observation of X (sample) is independent and approximately normally distributed 
      <li> The data collection process is random without replacement       
      </ul>                     
    "
    ),

  hr(),

source("p1_ui.R", local=TRUE)$value


),

##---------- Panel 2 ---------

tabPanel("Two Independent Samples",

headerPanel("Two-Sample t-Test"),

  HTML(
    "
    <b> Notations </b>
      <ul>
      <li> The independent observations are designated X and Y
      <li> &#956&#8321 is the population mean of X; &#956&#8322 is the population mean of Y 
      </ul>

    <b> Assumptions </b>

      <ul>
      <li> Each of the two populations being compared should follow the normal distribution  
      <li> X and Y should be sampled independently from the two populations being compared   
      <li> The two populations being compared should have the same variance                  
      </ul>
      "
      ),

    hr(),

source("p2_ui.R", local=TRUE)$value

    ),

##---------- Panel 3 ---------

tabPanel("Two Paired Samples",

    headerPanel("Paired t-Test"),

    HTML("

    <b> Notations </b>
    
      <ul>
      <li> The dependent observations are designated X and Y        
      <li> &#916 is the underlying mean differences between X and Y 
      </ul>

    <b> Assumptions </b>
      
      <ul>
      <li> The differences of paired samples are approximately normally distributed                           
      <li> The differences of paired samples are numeric and continuous and based on the normal distribution  
      <li> The data collection process was random without replacement  
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

