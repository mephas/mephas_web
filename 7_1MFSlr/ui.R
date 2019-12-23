##----------#----------#----------#----------
##
## 7MFSreg UI
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

title = "Linear Regression",

#----------0. dataset panel----------

tabPanel("Data",

headerPanel("Data Preparation"),

HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get your data prepared for linear regression model
<li> To change the type of some variables for linear regression model
<li> To get the basic descriptive statistics of the variables in your data
<li> To get the descriptive statistics plot of the variables in your data
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data need to include one dependent variable (outcome/response) as Y, and >=1 independent variables (factors/predictors)
<li> Your data need to have more rows than columns
<li> Do not mix character and numbers in the same column 
</ul> 

<i><h4>Case Example</h4>


</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()


),

#----------1. LM regression panel----------
tabPanel("Model",

headerPanel("Linear Regression"),

hr(),
source("1lm_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

tabPanel("Prediction",

headerPanel("Linear Prediction from Model"),

hr(),
source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),
##---------- other panels ----------


source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help7.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value

)
##-----------------------over
)
)


