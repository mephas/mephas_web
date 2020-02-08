if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("DT")) {install.packages("DT")}; library("DT")
if (!require("psych")) {install.packages("psych")}; library("psych")
if (!require("pls")) {install.packages("pls")}; library("pls")
if (!require("spls")) {install.packages("spls")}; library("spls")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style.css"),
sty.link(),
tabOF(),

navbarPage(

theme = shinythemes::shinytheme("cerulean"),
#title = a("Dimensional Analysis 2", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Dimensional Analysis 2",
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
<li> To upload data files, preview data set, and check the correctness of data input</li>
<li> To pre-process some variables (when necessary) for building the model</li>
<li> To get the basic descriptive statistics and plots of the variables</li>
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> The data need to be all numeric</li>
<li> The data used to build a model is called a <b>training set</b></li>
</ul>

<i><h4>Case Example: NKI data</h4>

Suppose in one study, we wanted to explore some lymph node-positive breast cancer patients on metastasis-free survival.
Data contained the clinical risk factors: (1) Age: Patient age at diagnosis (years) and (2) the year until relapse;
and gene expression measurements of 70 genes found to be prognostic for metastasis-free survival in an earlier study.
In this example, we wanted to create a model that could find the relations between age, year until release, and gene expression measurements.

<h4>Case Example: Liver toxicity data</h4>

This data set contains the expression measure and clinical measurements for rats that were exposed to non-toxic, moderately toxic or severely toxic doses of acetaminophen in a controlled experiment.

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
tabPanel("PCR and Prediction",

headerPanel("Principal Component Regression"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>Principal component regression (PCR)</b> is a regression analysis technique that is based on principal component analysis (PCA). It finds hyperplanes of maximum variance between the response and independent variables.

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To achieve a correlation matrix and plots</li>
<li> To achieve the results from a model</li>
<li> To achieve the factors and loadings result tables and</li>
<li> To achieve the factors and loadings distribution plots in 2D and 3D</li>
<li> To achieve the predicted dependent variables</li>
<li> To upload new data and conduct the prediction</li>

</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> All the data for analysis are numeric</li>
<li> New data (test set) should cover all the independent variables used in the model.</li>
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
")
),
hr(),
source("ui_pcr.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_pcr_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("PLSR and Prediction",

headerPanel("Partial Least Squares Regression"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>Partial least squares regression (PLSR)</b> is a regression analysis technique that finds a linear regression model by projecting the predicted variables and the observable variables to a new space.

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To achieve a correlation matrix and plots</li>
<li> To achieve the results from a model</li>
<li> To achieve the factors and loadings result tables</li>
<li> To achieve the factors and loadings distribution plots in 2D and 3D</li>
<li> To achieve the predicted dependent variables</li>
<li> To upload new data and conduct the prediction</li>

</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> All the data for analysis are numeric</li>
<li> New data (test set) should cover all the independent variables used in the model.</li>
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
")
),

hr(),
source("ui_pls.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_pls_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
),


##########----------##########----------##########
tabPanel("SPLSR and Prediction",

headerPanel("Sparse Partial Least Squares Regression"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>Sparse partial least squares regression (SPLSR)</b> is a regression analysis technique that aims simultaneously to achieve good predictive performance and variable selection by producing sparse linear combinations of the original predictors.

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To achieve a correlation matrix and plot</li>
<li> To achieve the results from a model</li>
<li> To achieve the factors and loadings result tables</li>
<li> To achieve the factors and loadings distribution plots in 2D and 3D</li>
<li> To achieve the predicted dependent variables</li>
<li> To upload new data and conduct the prediction</li>
</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> All the data for analysis are numeric</li>
<li> New data (test set) should cover all the independent variables used in the model.</li>
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
")
),
hr(),
source("ui_spls.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_spls_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabstop(),
tablink()


))
