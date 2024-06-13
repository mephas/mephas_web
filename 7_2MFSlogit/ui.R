if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("stargazer")) {install.packages("stargazer")}; library("stargazer")
#if (!require("ROCR")) {install.packages("ROCR")}; library("ROCR")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")
source("../tab/func2.R")

tagList(

includeCSS("../www/style.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
#theme = shinythemes::shinytheme("cerulean"),
#title = a("Logistic Regression", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Logistic Regression",
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
<b>Logistic regression</b> is used to model the probability of a perticular class or event existing binary outputs such as pass/fail, win/lose, alive/dead, or healthy/sick.
Logistic regression uses a logistic function to model a binary dependent variable.

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To upload data files, preview data set, and check the correctness of data input</li>
<li> To pre-process some variables (when necessary) for building the model</li>
<li> To achieve the basic descriptive statistics and draw plots of the variables</li>
</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> Your data need to include <b>one binary dependent variable (denoted as Y)</b> and <b> at least one independent variables (denoted as X)</b></li>
<li> Your data need to have more rows than columns</li>
<li> Do not mix character and numbers in the same column</li>
<li> The data used to build a model is called a <b>training set</b></li>
</ul>

<h4><i>Case Example</i></h4>

<i>Suppose we wanted to explore the Breast Cancer dataset and develop a model to try classifying suspected cells to Benign (B) or Malignant (M).
The dependent variable is a binary outcome (B/M). We were interested in (1) building a model to calculate the probability of benign or malignant, and to determine whether the patient is benign or malignant, 
and (2) finding out the relations between the binary dependent variable and the other variables, that is finding out which variable contributes significantly to the dependent variable.


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
tabPanel("Model and Prediction",

headerPanel("Logistic Regression"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To build simple or multiple logistic regression model</li>
<li> To achieve the estimates of regressions, including (1) estimate of coefficients with t test, p value, and 95% CI, (2) R<sup>2</sup> and adjusted R<sup>2</sup>, and (3) F-Test for overall significance in Regression</li>
<li> To achieve additional information: (1) predicted dependent variable and residuals, (2) AIC-based variable selection, (3) ROC plot, and (4) sensitivity and specificity table for ROC plot</li>
<li> To upload new data and achieve the prediction</li>
<li> To achieve the evaluation of new data containing new dependent variable</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> The dependent variable is binary</li>
<li> Please prepare the training set data in the previous <b>Data</b> tab</li>
<li> New data (test set) should cover all the independent variables used in the model.
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("ui_model.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tablang("7_2MFSlogit"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

)
)

