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

<i><h4>Case Example</h4>

Suppose we wanted to explore 100 lymph node positive breast cancer patients on metastasis-free survival. 
Data contained 5 clinical risk factors: (1) Diam: diameter of the tumor; (2) N: number of affected lymph nodes; (3) ER: estrogen receptor status; (4) Grade: grade of the tumor; and (5) Age: Patient age at diagnosis (years); 
and gene expression measurements of 70 genes found to be prognostic for metastasis-free survival in an earlier study. 
Time variable is metastasis-free follow-up time (months). Censoring indicator variable: 1 = metastasis or death; 0 = censored. 

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
<p> <b>Kaplan–Meier estimator</b>, also known as the product limit estimator, is a non-parametric statistic used to estimate the survival function from lifetime data. </p>
<p> <b>Log-rank test</b> is a hypothesis test to compare the survival distributions of two samples. It compares estimates of the hazard functions of the two groups at each observed event time.

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
"
),

hr(),
source("1km_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

tabPanel("Parametric Model",

headerPanel("Accelerated Failure Time (AFT) Model"),
HTML(
"
<p><b>Accelerated failure time (AFT) model</b> is a parametric model assumes that the effect of a covariate is to accelerate or decelerate the life course of a disease by some constant.</p>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build AFT model
<li> To get the estimates of linear regressions, such as estimate of coefficient, model information, AIC-based best model selection,ROC plot, sensitivity and specificity table, and model predictions 
<li> To get fitted values which are predicted from the existed data
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Please prepare the data in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
),

hr(),
source("2aft_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

tabPanel("Prediction1",

headerPanel("Prediction after Accelerated Failure Time (AFT) model"),
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload new data and get the prediction
<li> To get the evaluation if new data contains new dependent variable
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data cover all the independent variables used in the model.
<li> New data not used to build the model is called <b>test set</b>
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
),

hr(),
source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

tabPanel("Semi-Parametric Model",

headerPanel("Cox Regression"),
HTML(
"
<p><b> Cox Regression</b>, also known as Cox proportional hazard regression assumes that if the proportional hazards assumption holds (or, is assumed to hold) then it is possible to estimate the effect parameter(s) without any consideration of the hazard function. </p>
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build a Cox regression model
<li> To get the estimates of linear regressions, such as estimate of coefficient, model information, AIC-based best model selection,ROC plot, sensitivity and specificity table, and model predictions 
<li> To get fitted values which are predicted from the existed data
</ul>

<h4><b> 2. About your data (test set) </b></h4>

<ul>
<li> Please prepare the data in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
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
<li> To upload new data and get the prediction
<li> To get the evaluation if new data contains new dependent variable
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data cover all the independent variables used in the model.
<li> New data not used to build the model is called <b>test set</b>
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
),

hr(),
source("3pr_ui.R", local=TRUE, encoding="UTF-8")$value,
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


