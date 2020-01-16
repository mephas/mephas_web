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


title = "Dimensional Analysis 2",

##########----------##########----------##########

tabPanel("Dataset",

titlePanel("Data Preparation"),

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

<i><h4>Case Example 1: NKI data</h4>

SUppose in one study, people measured the 9 chemical attributes of 7 types of drugs. However, not all the attributes are important.
We wanted to explore the important or principal components from the chemical attributes matrix.

</i>

<i><h4>Case Example 2: NKI data</h4>

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


##########----------##########----------##########
tabPanel("PCR",

titlePanel("Principal Component Regression"),

hr(),
source("pcr_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()

), 

##########----------##########----------##########


tabPanel("Prediction1",

titlePanel("Prediction after Principal Component Regression"),

hr(),
source("pr1_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("PLSR",

titlePanel("Partial Least Squares Regression"),

hr(),
source("plsr_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########


tabPanel("Prediction2",

titlePanel("Prediction after Partial Least Squares Regression"),

hr(),
source("pr2_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("SPLSR",

titlePanel("Sparse Partial Least Squares Regression"),

hr(),
source("spls_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########

tabPanel("Prediction3",

titlePanel("Prediction after Partial Least Squares Regression"),

hr(),
source("pr3_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()

),
##########----------##########----------##########

source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value

))
)



