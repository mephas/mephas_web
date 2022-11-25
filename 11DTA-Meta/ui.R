
if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny") 
require("shiny",quietly = TRUE)

if (!requireNamespace("ggplot2",quietly = TRUE)) install.packages("ggplot2")
require("ggplot2",quietly = TRUE)

if (!requireNamespace("shinyWidgets", quietly = TRUE)) install.packages("shinyWidgets") 
require("shinyWidgets",quietly = TRUE)

if (!requireNamespace("latex2exp", quietly = TRUE)) install.packages("latex2exp") 
require("latex2exp",quietly = TRUE)

if (!requireNamespace("shinythemes", quietly = TRUE)) install.packages("shinythemes")
require("shinythemes",quietly = TRUE)

if (!requireNamespace("DT", quietly = TRUE)) install.packages("DT") 
require("DT",quietly = TRUE)

if (!requireNamespace("meta", quietly = TRUE)) install.packages("meta") 
require("meta",quietly = TRUE)

if (!requireNamespace("mada", quietly = TRUE)) install.packages("mada") 
require("mada",quietly = TRUE)

if (!requireNamespace("mvmeta", quietly = TRUE)) install.packages("mvmeta") 
require("mvmets",quietly = TRUE)

if (!requireNamespace("dtametasa", quietly = TRUE)) install.packages("dtametasa") 
require("dtametasa",quietly = TRUE)

if (!requireNamespace("stats", quietly = TRUE)) install.packages("stats") 
require("stats",quietly = TRUE)

if (!requireNamespace("shinyAce", quietly = TRUE)) install.packages("shinyAce") 
require("shinyAce",quietly = TRUE)

# if (!requireNamespace("plotly", quietly = TRUE)) install.packages("plotly") 
# require("plotly",quietly = TRUE)



#library("bsplus")
#library("htmltools")
source("function.R")
# source("./ui_dtameta.R",local = TRUE)
# source("ui_uni.R",local = TRUE)
source("ui_tab.R")
source("../tab/panel.R")
#source("../tab/func.R")

source("sauc.R")
source("llk.o.R")
source("dtametasa_fc.R")

####--------------------------------------Preamble

tagList(
withMathJax(),
tags$div(tags$script("
                MathJax.Hub.Config({
                tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
                
                ,
                TeX:{
        equationNumbers:{
            autoNumber:'AMS'  
        }}
    });
                
                ")),
  includeCSS("../www/style.css"),

#                 "<script type='text/x-mathjax-config'>
#   MathJax.Hub.Config({
#     tex2jax: {
#       inlineMath: [ ['$','$'], ['\\(','\\)'] ],
#       displayMath: [ ['$$','$$'], ['\\[','\\]'] ]
#     }
#   });
# </script>",
fluidPage(
switchInput(
inputId = "explain_on_off",#
label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
inline = TRUE,
onLabel = "Close",
offLabel = "Details",
size = "default"
)
),

#shinythemes::themeSelector(),
navbarPage(
  theme = shinytheme("flatly"),
  collapsible = TRUE,
  position="fixed-top",
  title = "Meta-Analysis of Diagnostic Test Accuracy",

  ########## ----------##########----------##########

id="Main_Panel",
## tabPanel 1 starts
tabPanel(
  "Diagnostic Studies",
  headerPanel("Summary of Diagnostic Test Accuracy"),

  ## Explanations
  conditionalPanel(
  condition = "input.explain_on_off",
    HTML(
    "
    <b>Meta-analysis of diagnostic test accuracy $($DTA meta$)$ </b> is used to summaries results of multiple diagnostic studies

    <h4><b> 1. Functionalities  </b></h4>
    <ul>
    <li> To upload data files, preview data set, and check the correctness of data input
    <li> Two models are available: $($1$)$ bivariate random-effect model $($Reitsma et al. 2005$)$ or 
    $($2$)$ HSROC model $($Rutter and Gatsonis, 2001$)$
    <li> To produce summary ROC $($SROC$)$ curves and summary AUC $($SAUC$)$
    <li> To detect the publication bias in the results
    <li> To do sensitivity analysis for the publication bias
    </ul>

    <h4><b> 2. The format of your data</b></h4>

    <ul>
    <li> The variables in your data must contains names as <b>TP, FP, TN, FN </b>, indicating true positive, false positive, true negative, false negative, respectively.  
    </ul>

    <h4><i>Case Example</i></h4>

    <i> We used the meta-analysis for diagnosing intravascular device-related bloodstream infection. $($Safdar et al. 2005$)$ 

    </i>

    <h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give the analytical results. </h4>
    "

    ),

    # p("This page can make",tags$strong(" SROC Plot")," and",tags$strong(" SAUC Plot")),
    # HTML('<b>&#9312;Set Header TP,FN,FP,TN</b>'),br(),
    # HTML("&#10103;<b>When Change the Data, Click Reload DATA TO Calculation</b>"),br(),
    downloadButton("ManualPDF_download","Download Manual")
    ),

hr(),
source("ui_dta.R",local = TRUE)$value,
hr()
),
## tabPanel 1 ends

## tabPanel 1.2 starts
tabPanel(
  "Meta-Analysis",
  headerPanel("Meta-Analysis of Diagnostic Test Accuracy"),

  ## Explanations
  conditionalPanel(
  condition = "input.explain_on_off",
    HTML(
    "
    <b>Meta-analysis of diagnostic test accuracy $($DTA meta$)$ </b> is used to summaries results of multiple diagnostic studies

    <h4><b> 1. Functionalities  </b></h4>
    <ul>
    <li> To upload data files, preview data set, and check the correctness of data input
    <li> Two models are available: $($1$)$ bivariate random-effect model $($Reitsma et al. 2005$)$ or 
    $($2$)$ HSROC model $($Rutter and Gatsonis, 2001$)$
    <li> To produce summary ROC $($SROC$)$ curves and summary AUC $($SAUC$)$
    <li> To detect the publication bias in the results
    <li> To do sensitivity analysis for the publication bias
    </ul>

    <h4><b> 2. The format of your data</b></h4>

    <ul>
    <li> The variables in your data must contains names as <b>TP, FP, TN, FN </b>, indicating true positive, false positive, true negative, false negative, respectively.  
    </ul>

    <h4><i>Case Example</i></h4>

    <i> We used the meta-analysis for diagnosing intravascular device-related bloodstream infection. $($Safdar et al. 2005$)$ 

    </i>

    <h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give the analytical results. </h4>
    
    "

    )

    # p("This page can make",tags$strong(" SROC Plot")," and",tags$strong(" SAUC Plot")),
    # HTML('<b>&#9312;Set Header TP,FN,FP,TN</b>'),br(),
    # HTML("&#10103;<b>When Change the Data, Click Reload DATA TO Calculation</b>"),br(),
    # downloadButton("ManualPDF_download","Download Manual")
    ),
hr(),
source("ui_resm.R",local = TRUE)$value,
hr()
),
## tabPanel 1 ends


## tabPanel 2.1 starts

tabPanel(
  "Sensitivity Analysis for Publication Bias",
  headerPanel("Likelihood-based Sensitivity Analysis for Publication Bias"),
  conditionalPanel(
    condition = "input.explain_on_off",
     
    HTML(
      "
<h4><b>Suppose that $N$ diagnostic studies are published and included in meta-analysis.</b></h4>
We use a bivariate normal model $($hereinafter referred to as the Reitsma model$)$
for sensitivity and specificity and define $\\mu_{1i}$ and $\\mu_{2i}$ as the logit-transformed true sensitivity and specificity of the $i$th study.
The Reitsma model assumes that $(\\mu_{1i}, \\mu_{2i})^T$ is normally distributed:
\\begin{align}
	\\binom{\\mu_{1i}}{\\mu_{2i}}
	\\sim 
	N\\left ( \\binom{\\mu_1}{\\mu_2}, \\boldsymbol{\\Omega} \\right ) 
	\\mathrm{~with~}
	\\boldsymbol{\\Omega} = 
	\\begin{pmatrix}
	\\tau_1^2 & \\tau_{12} \\\\
	\\tau_{12} & \\tau_2^2
	\\end{pmatrix},
	\\label{eq:b1}
\\end{align}

where $\\mu_1$ and $\\mu_2$ are the common means of the logit-transformed sensitivity and specificity,
$\\tau_1^2~(\\tau_1>0)$ and $\\tau_2^2~(\\tau_2>0)$ are their between-study variances, 
$\\tau_{12} = \\rho\\tau_{1}\\tau_{2}$ is the covariance between $\\mu_{1i}$ and $\\mu_{2i}$,
and $\\rho~(-1 \\le \\rho \\le 1)$ is the correlation coefficient.
Let $y_{1i}$ and $y_{2i}$ be the logit-transformed observed sensitivity $($ $\\mathrm{\\hat{se}}_i$ $)$ and specificity $($$\\mathrm{\\hat{sp}}_i$$)$.
Given $(\\mu_{1i}, \\mu_{2i})$, it is assumed that
\\begin{align}
	\\binom{y_{1i}}{y_{2i}} 
	\\sim 
	N \\left (\\binom{\\mu_{1i}}{\\mu_{2i}}, \\boldsymbol{\\Sigma}_i  \\right )
	\\mathrm{~with~}
	\\boldsymbol{\\Sigma}_i 
	= \\begin{pmatrix}
	s_{1i}^2 & 0\\\\
	 0 & s_{2i}^2
	\\end{pmatrix},
	\\label{eq:b2}
\\end{align}

where $s_{1i}^2$ and $s_{2i}^2$ are the observed variances of $y_{1i}$ and $y_{2i}$ within each study.
The models (\\eqref{eq:b1}) and (\\eqref{eq:b2}) leads to the marginal model:
\\begin{align}
\\boldsymbol{y}_i | \\boldsymbol{\\Sigma}_i 
\\sim N_2 
\\left (\\boldsymbol{\\mu}, \\boldsymbol{\\Omega} + \\boldsymbol{\\Sigma}_i  \\right ),
\\label{eq:b12}
\\end{align}
where $\\boldsymbol{y}_i = (y_{1i},y_{2i})^T$, $\\boldsymbol{\\mu} = (\\mu_1,\\mu_2)^T$, and $N_2$ denotes the bivariate normal distribution.
SROC curve is defined by
\\begin{align}
SROC(x; \\boldsymbol{\\mu}, \\boldsymbol{\\Omega}) 
= \\mathrm{logit}^{-1} \\left[ \\mu_1 - \\dfrac{\\tau_{12}}{\\tau_2^2}\\{\\mathrm{logit}(x)+\\mu_2\\} \\right].
\\label{eq:sroc}
\\end{align}
Accordingly, the SAUC is defined by 
\\begin{align}
SAUC(\\boldsymbol{\\mu}, \\boldsymbol{\\Omega}) 
= \\int_{0}^{1}SROC(x; \\boldsymbol{\\mu}, \\boldsymbol{\\Omega})dx.
\\label{sauc}
\\end{align}
The HSROC curve is given by the SROC curve \\eqref{eq:sroc} with $\\rho=-1$.
Suppose that all the studies for meta-analysis took a common cutoff value to define the outcomes, 
then selection function on the $t$-statistic of the lnDOR is applicable to model the selective publication mechanism. 

We consider a more general form of selection function on the $t$-type statistic of the linear combination of the logit-transformed sensitivity and specificity:

\\begin{align*}
\\boldsymbol{c}^T \\boldsymbol{y}_i = c_1y_{1i}+c_2y_{2i},
\\end{align*}

where $\\boldsymbol{c} = (c_1, c_2)^T$ is a contrast vector.

From equation \\eqref{eq:b12}, it holds that
\\begin{align}
t_i = \\dfrac{\\boldsymbol{c}^T \\boldsymbol{y}_i}{\\sqrt{\\boldsymbol{c}^T\\boldsymbol{\\Sigma}_i\\boldsymbol{c}}}
\\sim 
N 
\\left (
\\dfrac{\\boldsymbol{c}^T\\boldsymbol{\\mu}}{\\sqrt{\\boldsymbol{c}^T\\boldsymbol{\\Sigma}_i\\boldsymbol{c}}},
1 + \\dfrac{\\boldsymbol{c}^T\\boldsymbol{\\Omega}\\boldsymbol{c}}{\\boldsymbol{c}^T\\boldsymbol{\\Sigma}_i\\boldsymbol{c}}
\\right ). 
\\label{eq:t2} 
\\end{align}
$(c_1, c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$ gives the $t$-statistic of the lnDOR.
By taking different contrast vectors, the $t$-type statistic can determine a variety of selective publication mechanisms.
For example, 
$(c_1, c_2) = (1, 0)$ and $(c_1, c_2) = (0, 1)$ in equation \\eqref{eq:t2} indicate that the selective publication mechanisms are determined by the significance of sensitivity and specificity, respectively.
Given a value of marginal probability of selective publication, $p=P(\\mathrm{select})$.
\\begin{align}
\\ell_O(\\boldsymbol{\\mu},\\boldsymbol{\\Omega}, \\boldsymbol{c}, \\beta)
& = \\ell_O(\\boldsymbol{\\mu},\\boldsymbol{\\Omega}, \\boldsymbol{c}, \\beta, \\alpha_p) \\nonumber \\\\ 
& = \\sum_{i=1}^{N} \\left\\{ 
-\\frac{1}{2} (\\boldsymbol{y}_i-\\boldsymbol{\\mu})^T(\\boldsymbol{\\Sigma}_i+\\boldsymbol{\\Omega})^{-1}(\\boldsymbol{y}_i-\\boldsymbol{\\mu})) 
-\\frac{1}{2}\\log |\\boldsymbol{\\Sigma}_i+\\boldsymbol{\\Omega}| 
\\right \\}  \\nonumber \\\\ 
& + \\sum_{i=1}^{N} \\log \\Phi \\left({ \\beta 
\\frac{\\boldsymbol{c}^T\\boldsymbol{y}_i}{\\sqrt{\\boldsymbol{c}^T\\boldsymbol{\\Sigma}_i\\boldsymbol{c}}}} 
+ \\alpha_p
\\right)
- \\sum_{i=1}^{N}  \\log \\Phi \\left\\{ \\dfrac{\\beta \\dfrac{\\boldsymbol{c}^T\\boldsymbol{\\mu}}{ \\sqrt{\\boldsymbol{c}^T\\boldsymbol{\\Sigma}_i\\boldsymbol{c}}} +  \\alpha_p}
{  \\sqrt{1+\\beta^2 \\left( 1+\\dfrac{\\boldsymbol{c}^T\\boldsymbol{\\Omega}\\boldsymbol{c}}{\\boldsymbol{c}^T\\boldsymbol{\\Sigma}_i\\boldsymbol{c}} \\right) }}  \\right \\}.
\\label{eq:llkp}
\\end{align}
The parameters can be estimated by maximizing the conditional log-likelihood \\eqref{eq:llkp}.

The contrast vector $\\boldsymbol{c}$ can be regarded as unknown parameters to be estimated.

"
    )
    ,uiOutput("explainSensi")
  ),
  hr(),
  source("ui_sensitivity.R", local = TRUE, encoding = "UTF-8")$value,
  hr()
  # )
),

## tabPanel 2.2 starts
  tabPanel(
  "Funnel Plots for Publication Bias",
  headerPanel("Funnel Plots for Publication Bias"),
  conditionalPanel(
    condition = "input.explain_on_off",
    HTML(
      "
<h4>Show results</h4>

"
    )
  ),
  hr(),
  source("ui_funnel.R", local = TRUE, encoding = "UTF-8")$value,
  hr()
), 



## tabPanel 2 ends

## tabPanel 3 ends
tabPanel(
  "Download App",
  headerPanel("Download and Install App in Desktop"),
  hr(),
  source("ui_desktopApp.R",local = TRUE)$value,
  hr()
  ),

#tablang("11DTA-Meta"),
tabstop(),
tablink()

))