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
<li> To upload data file, preview data set, and check the correctness of data input 
<li> To pre-process some variables (when necessary) for building the linear regression
<li> To get the basic descriptive statistics and plots of the variables 
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> Your data need to include <b>one dependent variable (denoted as Y)</b> and <b> at least one independent variables (denoted as X)</b>
<li> Your data need to have more rows than columns
<li> Do not mix character and numbers in the same column 
<li> The data used to build model is called <b>training set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in one study, the doctors recorded the birth weight of 10 infants, together with age (month), age group (a: age < 4 month, b; other wise), and SBP.
We were interested to predict the birth weight of a infants, and find the relations between birth weight and the other variables. 

</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please build the model in the next tab.</h4>
"
),

hr(),
source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()


),

#----------1. LM regression panel----------
tabPanel("Model",

headerPanel("Linear Regression"),

HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build a linear regression model, given the dependent variables is continuous with underlying normal distribution.
<li> To get the estimates of linear regressions, such as estimate of coefficient, model information, ANOVA table of variables, AIC-based best model selection, plots of residuals, and model predictions 
<li> To get fitted values which are predicted from the existed data
</ul>

<h4><b> 2. About your data  (training set)</b></h4>

<ul>
<li> Please prepare the training set data in the previous <b>Data</b> tab
</ul> 

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
source("1lm_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

tabPanel("Prediction",

headerPanel("Prediction from Model"),

HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> If you have input the data and built a model in the previous tabs, you can upload new data and get the predictive results from new data.
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data need to have all the independent variables in the model.
<li> New data not used in the model is called <b> test set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in the same study, the doctors got another 6 infants data, and wanted to predict their birth weights based on the model we build.

</h4></i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

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


