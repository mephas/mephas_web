#if (!require("stargazer")) {install.packages("stargazer")}; library("stargazer")
#if (!require("survival")) {install.packages("survival")}; library("survival")
#if (!require("survminer")) {install.packages("survminer")}; library("survminer")
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!requireNamespace("survival", quietly = TRUE)) {install.packages("survival")}; require("survival",quietly = TRUE)
if (!requireNamespace("survminer",quietly = TRUE)) {install.packages("survminer")}; require("survminer",quietly = TRUE)
if (!requireNamespace("survAUC",quietly = TRUE)) {install.packages("survAUC")}; require("survAUC",quietly = TRUE)

#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("reshape2")) {install.packages("reshape2")}; library("reshape2")
#if (!require("survAUC")) {install.packages("survAUC")}; library("survAUC")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
#theme = shinythemes::shinytheme("cerulean"),
#title = a("Survival Analysis", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Survival Analysis",
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
<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input</li>
<li> To pre-process some variables (when necessary) for building the model</li>
<li> To achieve the basic descriptive statistics and plots of the variables</li>
<li> To prepare the <b>survival object</b> alternative to the <b>dependent variable</b> for in the model</li>
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> Your data need to include <b>one survival time variable and one 1/0 censoring variable</b> and <b> at least one independent variables (denoted as X)</b></li>
<li> Your data need to have more rows than columns</li>
<li> Do not mix character and numbers in the same column</li>
<li> The data used to build a model is called a <b>training set</b></li>
</ul>

<h4><i>Case Example 1: Right-censored diabetes data</i></h4>
<i>Suppose in a study, we got some observations from a trial of laser coagulation for the treatment of diabetic retinopathy.
Each patient had one eye randomized to laser treatment, and the other eye received no treatment.
For each eye, the event of interest was the time from initiation of treatment to the time when visual acuity dropped below 5/200 two visits in a row.
Thus there is a built-in lag time of approximately 6 months (visits were every 3 months).
Therefore, survival times in this dataset are the actual time to blindness in months, minus the minimum possible time to event (6.5 months).
Censor status of 0= censored; 1 = visual loss. Treatment: 0 = no treatment, 1= laser. Age is the age at diagnosis.
</i>


<h4><i>Case Example 2: Left-truncated right-censored Nki70 data</i></h4>
<i>Suppose we wanted to explore 100 lymph node positive breast cancer patients on metastasis-free survival. But some patients enrolled in the study later than other people.
Data contained 5 clinical risk factors: (1) Diam: diameter of the tumor; (2) N: number of affected lymph nodes; (3) ER: estrogen receptor status; (4) Grade: grade of the tumor; and (5) Age: Patient age at diagnosis (years);
and gene expression measurements of 70 genes found to be prognostic for metastasis-free survival in an earlier study.
Time variable is metastasis-free follow-up time (months). Censoring indicator variable: 1 = metastasis or death; 0 = censored.
<br><br>
<p>We wanted to explore the association between survival time and the independent variables.<p>
</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
)
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()


),

##########----------##########----------##########
tabPanel("KM Model",

headerPanel("Non-Parametric Kaplan-Meier Estimator and Log-rank Test"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p> <b>Kaplan–Meier estimator</b>, also known as the product-limit estimator, is a non-parametric statistic used to estimate the survival function from lifetime data. </p>
<p> The <b>log-rank test</b> is a hypothesis test to compare the survival distributions of two samples. It compares estimates of the hazard functions of the two groups at each observed event time.

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To achieve Kaplan-Meier survival probability estimate</li>
<li> To achieve Kaplan-Meier survival curves, cumulative events distribution curves, and cumulative hazard curves by a group variable</li>
<li> To conduct a log-rank test to compare the survival curves from 2 groups</li>
<li> To conduct a pairwise log-rank test to compare the survival curves from more than two groups</li>
</ul>

<h4><b> 2. About your data </b></h4>
<ul>
<li> Prepare the survival object in the Data tab
<li> A categorical variable is required in this model
</ul>
<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("ui_km.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("Cox Model and Prediction",

headerPanel("Semi-Parametric Cox Regression"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p><b> Cox Regression</b>, also known as Cox proportional hazard regression, assumes that if the proportional hazards assumption holds (or, is assumed to hold), then it is possible to estimate the effect parameter(s) without any consideration of the hazard function.
Cox regression assumes that the effects of the predictor variables upon survival are constant over time and are additive in one scale.</p>

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To build a Cox regression model</li>
<li> To achieve the estimates of the model, such as (1) estimate of coefficient, (2) predictions from the training data, (3)residuals,
(4) the adjusted survival curves, (5) proportional hazard test, and (6) diagnostic plot</li>
<li> To upload new data and get the prediction</li>
<li> To achieve the evaluation of new data containing new dependent variable</li>
<li> To achieve Brier Score and time-dependent AUC</li>
</ul>



<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> Please prepare the training data in the Data tab</li>
<li> Please prepare the survival object, Surv(time, event), in the Data tab</li>
<li> New data (test set) should cover all the independent variables used in the model.
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("ui_cox.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_cox_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("AFT Model and Prediction",

headerPanel("Parametric Accelerated Failure Time (AFT) Model"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p><b>Accelerated failure time (AFT) model</b> is a parametric model that assumes that the effect of a covariate is to accelerate or decelerate the life course of a disease by some constant.</p>

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To build an AFT model</li>
<li> To achieve the estimates of the model, such as coefficients of parameters, residuals, and diagnostic plot</li>
<li> To achieve fitted values which are predicted from the training data</li>
<li> To upload new data and get the prediction</li>
<li> To achieve the evaluation of new data containing new dependent variable</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Prepare the training data in the Data tab
<li> Prepare the survival object, Surv(time, event), in the Data tab
<li> New data (test set) should cover all the independent variables used in the model.
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("ui_aft.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_aft_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel


##########----------##########----------##########

tablang("7_3MFSsurv"),
tabstop(),
tablink()

)
##-----------------------over
)
