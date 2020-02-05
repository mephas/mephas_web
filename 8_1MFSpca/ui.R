if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("psych")) {install.packages("psych")}; library("psych")

source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style.css"),
sty.link(),
tabOF(),

##########--------------------##########--------------------##########
navbarPage(
theme = shinythemes::shinytheme("cerulean"),

#title = a("Dimensional Analysis 1", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Dimensional Analysis 1", 

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
<li> To achieve the basic descriptive statistics and plots of the variables</li>
</ul>

<h4><b> 2. About your data</b></h4>

<ul>
<li> Your data need to have more rows than columns</li>
<li> Your data need to be all numeric</li>
</ul>


<h4><i>Case Example 1: Mouse gene expression data</i></h4>

<i>This data measured the gene expression of 20 mouses in a diet experiment. Some mouses showed the same genotype, and some gene variables were correlated.
We wanted to compute the principal components that were linearly uncorrelated from the gene expression data.</i>

<h4><i>Case Example 2: Chemical data</i></h4>

<i>
Suppose in one study, people measured the 9 chemical attributes of 7 types of drugs. Some chemicals had a latent association.
We wanted to explore the latent relational structure among the set of chemical variables and narrow down to a smaller number of variables.
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
tabPanel("PCA",

headerPanel("Principal Component Analysis"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>Principal components analysis (PCA)</b> is a data reduction technique that transforms a larger number of correlated variables into a much smaller set of uncorrelated variables called principal components.

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> From <parallel analysis> to estimate the number of components</li>
<li> To achieve a correlation matrix and draw plots</li>
<li> To achieve the principal components and loadings result tables</li>
<li> To gachieve the principal components and loadings distribution plots in 2D and 3D</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> All the data for analysis are numeric
<li> More samples size than the number of independent variables, that is, the number of rows is greater than the number of columns</li>
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
")
),
hr(),
source("ui_pca.R", local=TRUE, encoding="UTF-8")$value,
hr()

), #penal tab end

##########----------##########----------##########
tabPanel("EFA",

headerPanel("Exploratory Factor Analysis"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>Exploratory Factor analysis (EFA)</b> is a statistical method used to describe variability among observed, correlated variables in terms of a potentially lower number of unobserved variables called factors.

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> From <b>parallel analysis</b> to estimate the number of components</li>
<li> To achieve a correlation matrix and plots</li>
<li> To achieve the factors and loadings result tables and</li>
<li> To achieve the factors and loadings distribution plots in 2D and 3D</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> All the data for analysis are numeric</li>
<li> More samples size than the number of independent variables, that is, the number of rows is greater than the number of columns</li>
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
")
),
hr(),
source("ui_fa.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########

tabstop(),
tablink()

))

##########----------##########----------####################----------##########----------####################----------##########----------##########
#)
