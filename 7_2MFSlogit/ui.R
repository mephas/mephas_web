source("../tab.R")
tagList(

source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,
#tags$head(includeScript("../0tabs/navtitle.js")),
tags$head(
  tags$link(rel = "shortcut icon", href = "../www/favicon.ico"),
  tags$link(rel = "icon", type = "image/png", sizes = "96x96", href = "../www/favicon-96x96.ico"),
  tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "../www/favicon-32x32.png"),
  tags$link(rel = "icon", type = "image/png", sizes = "16x16", href = "../www/favicon-16x16.png")
),
tags$style(type="text/css", "body {padding-top: 70px;}"),
#source("../0tabs/onoff.R", local=TRUE)$value,
tabOF(),

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
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
<b>Logistic regression</b> is used to model the probability of a certain class or event existing such as pass/fail, win/lose, alive/dead or healthy/sick.
Logistic regression uses a logistic function to model a binary dependent variable.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input
<li> To pre-process some variables (when necessary) for building the model
<li> To get the basic descriptive statistics and plots of the variables
</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> Your data need to include <b>one binary dependent variable (denoted as Y)</b> and <b> at least one independent variables (denoted as X)</b>
<li> Your data need to have more rows than columns
<li> Do not mix character and numbers in the same column
<li> The data used to build model is called <b>training set</b>
</ul>

<i><h4>Case Example</h4>

Suppose we wanted to explore the Breast Cancer dataset and develop a model to try classifying suspected cells to Benign (B) or Malignant (M).
The dependent variable is binary outcome (B/M). We were interested (1) to build a model which calculates the probability of benign or malignant and then help us to determine whether the patient is benign or malignant,
and (2) find the relations between binary dependent variable and the other variables, that is find out which variable contributes greatly to the dependent variable.


</h4></i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
)
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr(),

),

##########----------##########----------##########
tabPanel("Model and Prediction",

headerPanel("Logistic Regression"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<li><b> Build the Model  </b>
<ul>
<li> To build simple or multiple logistic regression model
<li> To get the estimates of regressions, including (1) estimate of coefficients with t test, p value, and 95% CI, (2) R<sup>2</sup> and adjusted R<sup>2</sup>, and (3) F-Test for overall significance in Regression
<li> To get additional information: (1) predicted dependent variable and residuals, (2) AIC-based variable selection, (3) ROC plot, and (4) sensitivity and specificity table for ROC plot
</ul>
<b><li> Prediction </b>
<ul>
<li> To upload new data and get the prediction
<li> To get the evaluation if new data contains new dependent variable
</ul>

<h4><b> 2. About your data </b></h4>
<b><li> Training set for building the model   </b>
<ul>
<li> The dependent variable is binary
<li> Please prepare the training set data in the previous <b>Data</b> tab
</ul>
<b><li> Test set for prediction   </b>
<ul>
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

tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

)
)

