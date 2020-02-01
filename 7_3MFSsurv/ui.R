if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")
shinyUI(
tagList(

source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,
tags$head(includeScript("../0tabs/navtitle.js")),
tags$style(type="text/css", "body {padding-top: 70px;}"),
source("../0tabs/onoff.R", local=TRUE)$value,

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
title = a("Survival Analysis", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
collapsible = TRUE,
id="navibar", 
position="fixed-top",
##########----------##########----------##########

tabPanel("Data",

headerPanel("Data Preparation"),
conditionalPanel(
condition = "input.explain_on_off",
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

<i><h4>Case Example 1: Right-censored diabetes data</h4>
Suppose in a study, we got some observations from a trial of laser coagulation for the treatment of diabetic retinopathy.
Each patient had one eye randomized to laser treatment and the other eye received no treatment.
For each eye, the event of interest was the time from initiation of treatment to the time when visual acuity dropped below 5/200 two visits in a row.
Thus there is a built-in lag time of approximately 6 months (visits were every 3 months).
Survival times in this dataset are therefore the actual time to blindness in months, minus the minimum possible time to event (6.5 months).
Censor status of 0= censored; 1 = visual loss. Treatment: 0 = no treatment, 1= laser. Age is age at diagnosis.


<h4>Case Example 2: Left-truncated right-censored Nki70 data</h4>
Suppose we wanted to explore 100 lymph node positive breast cancer patients on metastasis-free survival. But some patients enrolled in the study later than other people.
Data contained 5 clinical risk factors: (1) Diam: diameter of the tumor; (2) N: number of affected lymph nodes; (3) ER: estrogen receptor status; (4) Grade: grade of the tumor; and (5) Age: Patient age at diagnosis (years);
and gene expression measurements of 70 genes found to be prognostic for metastasis-free survival in an earlier study.
Time variable is metastasis-free follow-up time (months). Censoring indicator variable: 1 = metastasis or death; 0 = censored.
<br></br>
<p>We wanted to explore the association between survival time and the independent variables.<p>
</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
)
),

hr(),
source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()


),

##########----------##########----------##########
tabPanel("Non-Parametric Model",

headerPanel("Kaplan-Meier Estimator and Log-rank Test"),
conditionalPanel(
condition = "input.explain_on_off",
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
)
),

hr(),
source("1km_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("Semi-Parametric Model",

headerPanel("Cox Regression"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p><b> Cox Regression</b>, also known as Cox proportional hazard regression assumes that if the proportional hazards assumption holds (or, is assumed to hold) then it is possible to estimate the effect parameter(s) without any consideration of the hazard function.
Cox regression assumes that the effects of the predictor variables upon survival are constant over time and are additive in one scale.</p>
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build a Cox regression model
<li> To get the estimates of the model, such as (1) estimate of coefficient, (2) predictions from the training data, (3)residuals,
(4) the adjusted survival curves, (5) proportional hazard test, and (6) diagnostic plot
</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> Please prepare the data in the Data tab
<li> Please prepare the survival object in the Data tab
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("3cox_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("Prediction1",

headerPanel("Prediction after Cox Regression"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload new data and get the prediction
<li> To get the evaluation if new data contains new dependent variable
<li> To get Brier Score and time-dependent AUC
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data cover all the independent variables used in the model
<li> New data not used to build the model is called <b>test set</b>
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("3pr_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########

tabPanel("Parametric Model",

headerPanel("Accelerated Failure Time (AFT) Model"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p><b>Accelerated failure time (AFT) model</b> is a parametric model assumes that the effect of a covariate is to accelerate or decelerate the life course of a disease by some constant.</p>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build AFT model
<li> To get the estimates of the model, such as coefficients of parameters, residuals, and diagnostic plot
<li> To get fitted values which are predicted from the training data
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Please prepare the data in the Data tab
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("2aft_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("Prediction2",

headerPanel("Prediction after Accelerated Failure Time (AFT) model"),
conditionalPanel(
condition = "input.explain_on_off",
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
)
),

hr(),
source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########

tabPanel(tags$button(
				    id = 'close',
				    type = "button",
				    class = "btn action-button",
				    icon("power-off"),
				    style = "background:rgba(255, 255, 255, 0); display: inline-block; padding: 0px 0px;",
				    onclick = "setTimeout(function(){window.close();},500);")),
navbarMenu("",icon=icon("link"))

)
##-----------------------over
)
)
