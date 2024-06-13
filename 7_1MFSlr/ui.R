if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("DT")) {install.packages("DT")}
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
#if (!require("psych")) {install.packages("psych")}; library("psych")
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
#title = a("Linear Regression", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Linear Regression", 
collapsible = TRUE,
id="navibar", 
position="fixed-top",
##########----------##########----------##########


tabPanel("Data",

headerPanel("Data Preparation"),

conditionalPanel(
condition = "input.explain_on_off",

HTML(
'
<div style = "background-color: #AED6F1; width: 80%; border-radius: 3px;">

<b>Linear regression</b> is a linear approach to modeling the relationship between a dependent variable and one or more independent variables.
The case of one explanatory variable is called <b>(simple) linear regression</b>.
For more than one explanatory variable, the process is called <b>multiple linear regression</b>.

<h4><b> 1. Functionalities</b></h4>
<ul>
<li> To upload a data file, preview data set, and check the correctness of data input</li>
<li> To pre-process some variables (when necessary) for building the model</li>
<li> To calculate the basic descriptive statistics and draw plots of the variables</li>
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> Your data need to include <b>one dependent variable (denoted as Y)</b> and <b> at least one independent variables (denoted as X)</b></li>
<li> Your data need to have more rows than columns</li>
<li> Do not mix character and numbers in the same column</li>
<li> The data used to build a model is called a <b>training set</b></li>
</ul>

<h4><i>Case Example</i></h4>

<li>Suppose in one study, the doctors recorded the birth weight of 10 infants, together with age (month), age group (a: age < 4 months, b; otherwise), and SBP.
We were interested (1) to predict the birth weight of infants,
and (2) find the relations between birth weight and the other variables, that is, to find out which variable contributes significantly to the dependent variable.

</i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please build the model in the next tab.</h4>
</div>

'
)
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("Model and Prediction",

headerPanel("Linear Regression"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"


<h4><b> 1. Functionalities</b></h4>
<li><b>Build the model</b></li>
<ul>
<li> To build a simple or multiple linear regression model </li>
<li> To achieve the estimates of regressions, including (1) estimate of coefficients with t test, p value, and 95% CI, (2) R<sup>2</sup> and adjusted R<sup>2</sup>, and (3) F-Test for overall significance in regression</li>
<li> To achieve additional information: (1) predicted dependent variable and residuals, (2) ANOVA table of the model, (3) AIC-based variable selection, and (4) diagnostic plot-based from the residuals and predicted dependent variable</li>
<li> To upload new data and get the prediction</li>
<li> To achieve the evaluation of new data contains new dependent variable</li>
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> The dependent variable is real-valued and continuous under an underlying normal distribution.</li>
<li> Please prepare the training set data in the previous <b>Data</b> tab</li>
<li> New data (test set) should cover all the independent variables used in the model.</li>

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

tablang("7_1MFSlr"),
tabstop(),
tablink()
)
)
