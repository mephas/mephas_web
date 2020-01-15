##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(


title = "Dimensional Analysis 1",

#----------1. dataset panel----------

tabPanel("Data",

headerPanel("Data Preparation"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input 
<li> To pre-process some variables (when necessary) for building the model
<li> To get the basic descriptive statistics and plots of the variables
<li> To prepare the survival object as 'dependent variable' for building model
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> Your data need to include <b>one survival time variable and one 1/0 censoring variable</b> and <b> at least one independent variables (denoted as X)</b>
<li> Your data need to have more rows than columns
<li> Do not mix character and numbers in the same column 
<li> The data used to build model is called <b>training set</b>
</ul> 

<i><h4>Case Example 1: Chemical data</h4>

SUppose in one study, people measured the 9 chemical attributes of 7 types of drugs. However, not all the attributes are important.
We wanted to explore the important or principal components from the chemical attributes matrix.

</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),
hr(),
source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()

),


## 1. PCA ---------------------------------------------------------------------------------
tabPanel("PCA",

headerPanel("Principal Component Analysis"),

HTML(
"
<b>Principal components analysis (PCA)</b> is a data reduction technique that transforms a larger number of correlated variables into a much smaller set of uncorrelated variables called principal components.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get Kaplan-Meier survival probability estimate
<li> To get Kaplan-Meier survival curves, cumulative events distribution curves, and cumulative hazard curves by group variable
<li> To conduct log-rank test to compare the survival curves from 2 groups
<li> To conduct pairwise log-rank test to compare the survival curves from more than two groups
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> The independent variable is categorical
<li> Please prepare the survival object in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
source("pca_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()

), #penal tab end

## 2.  PLS, ---------------------------------------------------------------------------------
tabPanel("EFA",

headerPanel("Exploratory Factor Analysis"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get Kaplan-Meier survival probability estimate
<li> To get Kaplan-Meier survival curves, cumulative events distribution curves, and cumulative hazard curves by group variable
<li> To conduct log-rank test to compare the survival curves from 2 groups
<li> To conduct pairwise log-rank test to compare the survival curves from more than two groups
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> The independent variable is categorical
<li> Please prepare the survival object in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
source("fa_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

## 3. SPLS, ---------------------------------------------------------------------------------
#tabPanel("SPLS(R)",

#headerPanel("Sparse Partial Least Squares (Regression)"),

#source("3spls_ui.R", local=TRUE, encoding="UTF-8")$value
#),
#penal tab end

##----------------------------------------------------------------------
## 4. Regularization ---------------------------------------------------------------------------------
#tabPanel("Elastic net",

#headerPanel("Ridge, LASSO, and elastic net"),

#sidebarLayout(
#sidebarPanel(

#  h4("Model's configuration"),

#  sliderInput("alf", "Alpha parameter", min = 0, max = 1, value = 1),
#  helpText(HTML("
#  <ul>
#    <li>Alpha = 0: Ridge</li>
#    <li>Alpha = 1: LASSO</li>
#    <li>0 < Alpha < 1: Elastic net</li>
#  </ul>
#    ")),

#  radioButtons("family", "Response type",
#                 choices = c(Continuous =   "gaussian",
#                             Quantitative = "mgaussian",
#                             Counts = "poisson",
#                             Binary = "binomial",
#                             Multilevel = "multinomial",
#                             Survival = "cox"),
#                 selected = "mgaussian"),
#
#   numericInput("lamd", "Lambda parameter", min = 0, max = 100, value = 100)

#  ),

#mainPanel(
#  h4("Results"),
#plotOutput("plot.ela", width = "500px", height = "500px"),
#  verbatimTextOutput("ela")
#h4("Cross-validated lambda"),
#verbatimTextOutput("lambda"),
#helpText("Lambda is merely suggested to be put into the model.")

#  )
#)
#)

##---------- other panels ----------

source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value

))
)



