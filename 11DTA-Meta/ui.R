
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!requireNamespace("shinyWidgets", quietly = TRUE)) {install.packages("shinyWidgets")}; require("shinyWidgets",quietly = TRUE)
if (!requireNamespace("latex2exp", quietly = TRUE)) {install.packages("latex2exp")}; require("latex2exp",quietly = TRUE)
# if (!requireNamespace("shinythemes", quietly = TRUE)) {install.packages("shinythemes")}; require("shinythemes",quietly = TRUE)
if (!requireNamespace("DT", quietly = TRUE)) {install.packages("DT")}; require("DT",quietly = TRUE)
if (!requireNamespace("meta", quietly = TRUE)) {install.packages("meta")}; require("meta",quietly = TRUE)
if (!requireNamespace("mada", quietly = TRUE)) {install.packages("mada")}; require("mada",quietly = TRUE)
if (!requireNamespace("dtametasa", quietly = TRUE)) {install.packages("dtametasa")}; require("dtametasa",quietly = TRUE)
if (!requireNamespace("stats", quietly = TRUE)) {install.packages("stats")}; require("stats",quietly = TRUE)
if (!requireNamespace("shinyAce", quietly = TRUE)) {install.packages("shinyAce")}; require("shinyAce",quietly = TRUE)


#library("bsplus")
#library("htmltools")
source("function.R")
#source("./ui_dtameta.R",local = TRUE)
# source("ui_uni.R",local = TRUE)
source("ui_tab.R",local = TRUE)
source("../tab/panel.R",local = TRUE)
source("../tab/func.R",local = TRUE)
source("../tab/tab.R",local = TRUE)
source("sauc.R")
source("llk.o.R")
source("dtametasa_fc.R")


tagList(includeCSS("../www/style.css"),
stylink(),

fluidPage(
shinyWidgets::switchInput(
inputId = "explain_on_off",#
label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
inline = TRUE,
onLabel = "Close",
offLabel = "Info.",
size = "mini"
)
)
,

#shinythemes::themeSelector(),
navbarPage(
theme = shinythemes::shinytheme("flatly"),
collapsible = TRUE,
position="fixed-top",
title = "Meta-Analysis of Diagnostic Test Accuracy",
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>Meta-analysis of diagnostic test accuracy (DTA meta) </b> is used to summaries results of multiple diagnostic studies

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To upload data files, preview data set, and check the correctness of data input
<li> Two models are available: (1) bivariate random-effect model (Reitsma et al. 2005) or 
(2) HSROC model (Rutter and Gatsonis, 2001)
<li> To produce summary ROC (SROC) curves and summary AUC (SAUC)
<li> To detect the publication bias in the results
<li> To do sensitivity analysis for the publication bias
</ul>

<h4><b> 2. The format of your data</b></h4>

<ul>
<li> The variables in your data must contains names as <b>TP, FP, TN, FN </b>, indicating true positive, false positive, true negative, false negative, respectively.  
</ul>

<h4><i>Case Example</i></h4>

<i> We used the meta-analysis for diagnosing intravascular device–related bloodstream infection. (Safdar et al. 2005) 

</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give the analytical results. </h4>
"

),

# p("This page can make",tags$strong(" SROC Plot")," and",tags$strong(" SAUC Plot")),
# HTML('<b>&#9312;Set Header TP,FN,FP,TN</b>'),br(),
# HTML("&#10103;<b>When Change the Data, Click Reload DATA TO Calculation</b>"),br(),
downloadButton("ManualPDF_download","Download Manual")
),
tabPanel("Meta-Analysis",
headerPanel("Meta-Analysis of Diagnostic Test Accuracy"),
source("ui_dta.R",local = TRUE)$value),

tabPanel("Funnel Plot",
headerPanel("Funnel Plot for Publication Bias"),
source("ui_funnel.R",local=TRUE)$value
),
tabPanel("Sensitivity Analysis",
  headerPanel("Sensitivity-Analysis of Publication Bias"),
source("ui_sensitivity.R",local = TRUE)$value
),
tabPanel("Download App",
headerPanel("Download and Install the Desktop App"),
source("ui_desktopApp.R",local = TRUE)$value),

#tablang("11DTA-Meta"),
tabstop(),
tablink(),

))