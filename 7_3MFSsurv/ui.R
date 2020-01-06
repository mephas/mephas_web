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

title = "Survival Analysis",

#----------0. dataset panel----------

tabPanel("Data",

headerPanel("Data Preparation"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get your data prepared for survival models
<li> To change the type of some variables for linear regression model
<li> To get the basic descriptive statistics of the variables in your data
<li> To get the descriptive statistics plot of the variables in your data
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data need to include one binary dependent variable (outcome/response) as Y (Y=1/0, or a 2-level factor), and >=1 independent variables (factors/predictors)
<li> Your data need to have more rows than columns
<li> Do not mix character and numbers in the same column 
<li> The data used to build model is called <b>training data</b>
</ul> 

<i><h4>Case Example</h4>
Suppose we wanted to explore the Breast Cancer dataset and develop a model to try classifying suspected cells to Benign (B) or Malignant (M).

</h4></i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()


),

#----------1. LM regression panel----------
tabPanel("Non-parametric Model",

headerPanel("Kaplan-Meier Estimator and Log-rank Test"),
HTML(
"
<p> The Kaplan–Meier estimator, also known as the product limit estimator, is a non-parametric statistic used to estimate the survival function from lifetime data. </p>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get Kaplan-Meier survival curves, based on the survival time and censored data
<li> To conduct log Log-rank test to compare the survival distributions of two samples
<li> To get fitted values which are predicted from the existed data
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Please prepare the data in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
source("1km_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

tabPanel("Parametric Model",

headerPanel("Accelerate Failure Models by an Arbitrary Transform of the Time Variable"),
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build a logistic regression model, given the dependent variables is binary with underlying binomial distribution.
<li> To get the estimates of linear regressions, such as estimate of coefficient, model information, AIC-based best model selection,ROC plot, sensitivity and specificity table, and model predictions 
<li> To get fitted values which are predicted from the existed data
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Please prepare the data in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
source("2aft_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

tabPanel("Prediction1",

headerPanel("Prediction after Accelerate Failure Models"),
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> If you have input the data and built a model in the previous tabs, you can upload new data and get the predictive results.
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> New data need to have all the independent variables in the model.
<li> New data not used in the model is called <b> test data</b>
</ul> 

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
#source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

tabPanel("Semi-Parametric Model",

headerPanel("Cox Regression"),
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build a logistic regression model, given the dependent variables is binary with underlying binomial distribution.
<li> To get the estimates of linear regressions, such as estimate of coefficient, model information, AIC-based best model selection,ROC plot, sensitivity and specificity table, and model predictions 
<li> To get fitted values which are predicted from the existed data
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Please prepare the data in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
source("3cox_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

tabPanel("Prediction2",

headerPanel("Prediction after Cox Regression"),
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> If you have input the data and built a model in the previous tabs, you can upload new data and get the predictive results.
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> New data need to have all the independent variables in the model.
<li> New data not used in the model is called <b> test data</b>
</ul> 

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
#source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value,
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


