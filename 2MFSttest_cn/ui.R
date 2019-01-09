
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

navbarPage(
  
  title = "Tests of Means",

##---------- Panel 1 ---------

tabPanel(
  "One Sample",

  headerPanel("One Sample t-Test"),

  tags$b("Notations"),
  HTML(
    "
    <ul>
    <li> X is the dependent observations </li>
    <li> &#956 is the population mean of X </li>
    <li> &#956&#8320 is the specific mean </li>
    </ul>
    "
    ),

  tags$b("Assumptions"),
  HTML(
    "
    <ul>
    <li> X is numeric and continuous and based on the normal distribution </li>
    <li> Each observation of X (sample) is independent and approximately normally distributed </li>
    <li> The data collection process was random without replacement </li>
    "
    ),

  hr(),

  source("p1_ui.R", local=TRUE)$value


),

##---------- Panel 2 ---------

  tabPanel(
    "Two Independent Samples",

    headerPanel("Two-Sample t-Test"),

    tags$b("Notations"),
    HTML(
      "
      <ul>
      <li> The independent observations are designated X and Y</li>
      <li> &#956&#8321 = the population mean of X; &#956&#8322 = the population mean of Y </li>
      </ul>"
      ),

    tags$b("Assumptions"),
    tags$ul(
      tags$li("Each of the two populations being compared should follow the normal distribution"),
      tags$li("X and Y should be sampled independently from the two populations being compared"),
      tags$li("The two populations being compared should have the same variance")
      ),

    hr(),

    source("p2_ui.R", local=TRUE)$value

    ),
  ##

  ## 3. Two paried samples ---------------------------------------------------------------------------------
  tabPanel(
    "Two Paired Samples",

    headerPanel("Paired t-Test"),

    helpText("A typical example of the pared sample is that the repeated measurements, where subjects are tested prior to a treatment, say for high blood pressure, and the same subjects are tested again after treatment with a blood-pressure lowering medication"),

    tags$b("Assumption"),
    tags$ul(
      tags$li("The differences of paired samples are approximately normally distributed."),
      tags$li("The differences of paired samples are numeric and continuous and based on the normal distribution"),
      tags$li("The data collection process was random without replacement.")
      ),

    tags$b("Notations"),
    HTML(
      "
      <ul>
      <li> The dependent observations are designated X and Y </li>
      <li> &#916 is the underlying mean differences between X and Y</li>
      </ul>"
      ),

   hr(),

   source("p3_ui.R", local=TRUE)$value

    ),

##---------- other panels ----------

source("../0tabs/home.R",local=TRUE)$value,
source("../0tabs/stop.R",local=TRUE)$value

  )
 )
)

