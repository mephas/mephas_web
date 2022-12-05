
if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny") 
library("shiny",quietly = TRUE)

if (!requireNamespace("ggplot2",quietly = TRUE)) install.packages("ggplot2")
library("ggplot2",quietly = TRUE)

if (!requireNamespace("shinyWidgets", quietly = TRUE)) install.packages("shinyWidgets") 
library("shinyWidgets",quietly = TRUE)

if (!requireNamespace("latex2exp", quietly = TRUE)) install.packages("latex2exp") 
library("latex2exp",quietly = TRUE)

if (!requireNamespace("shinythemes", quietly = TRUE)) install.packages("shinythemes")
library("shinythemes",quietly = TRUE)

if (!requireNamespace("DT", quietly = TRUE)) install.packages("DT") 
library("DT",quietly = TRUE)

if (!requireNamespace("meta", quietly = TRUE)) install.packages("meta") 
library("meta",quietly = TRUE)

if (!requireNamespace("mada", quietly = TRUE)) install.packages("mada") 
library("mada",quietly = TRUE)

if (!requireNamespace("mvmeta", quietly = TRUE)) install.packages("mvmeta") 
library("mvmeta",quietly = TRUE)

if (!requireNamespace("dtametasa", quietly = TRUE)) install.packages("dtametasa") 
library("dtametasa",quietly = TRUE)

if (!requireNamespace("stats", quietly = TRUE)) install.packages("stats") 
library("stats",quietly = TRUE)

if (!requireNamespace("shinyAce", quietly = TRUE)) install.packages("shinyAce") 
library("shinyAce",quietly = TRUE)

if (!requireNamespace("lme4", quietly = TRUE)) install.packages("lme4") 
library("lme4",quietly = TRUE)


source("Rfuns/function.R")
source("Rfuns/ui_tab.R")
source("Rfuns/sauc.R")
source("Rfuns/llk.o.R")
# source("Rfuns/dtametasa_fc.R")
source("Rfuns/dtametasa.rf.R")

source("../tab/panel.R")



####--------------------------------------Preamble

tagList(
withMathJax(),
tags$div(tags$script("
                MathJax.Hub.Config({
                tex2jax: {inlineMath: [['$','$']]}
                
                ,
                TeX:{
        equationNumbers:{
            autoNumber:'AMS'  
        }}
    });
                
                ")),
includeCSS("../www/style2.css"),

# tags$style(type="text/css", "body {padding-top: -2000px;}"),

#                 "<script type='text/x-mathjax-config'>
#   MathJax.Hub.Config({
#     tex2jax: {
#       inlineMath: [ ['$','$'], ['\\(','\\)'] ],
#       displayMath: [ ['$$','$$'], ['\\[','\\]'] ]
#     }
#   });
# </script>",

# fluidPage(
# switchInput(
# inputId = "explain_on_off",#
# label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
# inline = TRUE,
# onLabel = "Close",
# offLabel = "Details",
# size = "default"
# )
# ),

#shinythemes::themeSelector(),
navbarPage(

theme = shinytheme("flatly"),
collapsible = TRUE,
position="static-top",
title = "DTAmetasa",
windowTitle="DTAmetasa",
id="Main_Panel",
header = list(
  switchInput(
  inputId = "explain_on_off",#
  value = FALSE,
  label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
  inline = TRUE,
  onLabel = "Hide",
  offLabel = "Help",
  size = "default"
  )),

########## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Tab1
tabPanel("Diagnostic Studies",
  
headerPanel("Summary of Diagnostic Studies"),

  ## Explanations
  conditionalPanel(condition = "input.explain_on_off",
    HTML(
    '
    This panel is used for summarizing the diagnostic studies

    <h4><b>1. The format of input data</b></h4>

    <ul>
    <li>The variable names must contain <b>TP, FP, TN</b>,  and <b>FN</b>, denoting <b>True Positive, False Positive, True Negative</b>,  and <b>False Negative</b></li>
    <li>The order of <b>TP, FP, TN, FN</b> does not matter</li>
    <li>No missing values in the data</li>
    <li>Re-click the "Update data and results" button, after you revised the data</li>
    </ul>

    <h4><b>2. You can get the following results:</b></h4>
    <ul>
    <li>The scatter plot of the studies with the corresponding confidence interval</li>
    <li>The descriptive statistics of <b>sensitivity (Sens), specificity (Spec), diagnostic odds ratio (DOR), and likelihood ratios (LRs)</b> of each study</li>
    <li>Test of equality of Sens and Spec </li>
    <li>Forest plots of Sens, Spec, DOR, LRs </li>
    </ul>

    <h4><i><b>Example: real-word meta-analysis of diagnostic studies</b></i></h4>
    <p>The example insert is the meta-analysis for diagnosing intravascular device-related bloodstream infection.</p>

    <p>Reference: <i>Safdar N, Fine JP, Maki DG. 
    Meta-analysis: methods for diagnosing intravascular device–related bloodstream infection. Ann Intern Med. 2005;142(6):451-466. 
    doi:10.7326/0003-4819-142-6-200503150-00011</i></p>
    '

    )

    # p("This page can make",tags$strong(" SROC Plot")," and",tags$strong(" SAUC Plot")),
    # HTML('<b>&#9312;Set Header TP,FN,FP,TN</b>'),br(),
    # HTML("&#10103;<b>When Change the Data, Click Reload DATA TO Calculation</b>"),br(),
    # downloadButton("ManualPDF_download","Download Manual")
    ),

hr(),
source("ui_dta.R",local = TRUE)$value,
hr()
),

########## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tabPanel("Meta-Analysis",

headerPanel("Reitsma's Model and GLM model of Meta-Analysis of Diagnostic Test Accuracy"),

  ## Explanations
conditionalPanel(condition = "input.explain_on_off",
HTML(
"
<p>This panel is used for meta-analysis of diagnostic studies without accounting for publication bias.</p>
<p>Two bivariate models are available: <b>linear mixed model (LMM, or Reitsma's model)</b> and <b>generalized linear mixed model (GLMMM, or GLM model)</b></p>

<h4><b> 1. About the Reitsma's model</b></h4>
<ul>
<li> This is the random effects model based on the bivariate normal distribution</li>
<li> The parameters of interest are: the summarized sensitivity and specificity, and the SAUC</li>
<li> When data are sparse (have many 0 values), this model is not recommended</li>
</ul>
<p>Reference: <i>Reitsma JB, Glas AS, Rutjes AWS, Scholten RJPM, Bossuyt PM, Zwinderman AH. 
Bivariate analysis of sensitivity and specificity produces informative summary measures in diagnostic reviews. J Clin Epidemiol. 2005;58(10):982-990. 
doi:10.1016/j.jclinepi.2005.02.022</i></p>

<h4><b> 2. About GLM model</b></h4>
<ul>
<li> This model is a mixture of binomial model and normal model</li>
<li> The parameters of interest are: the summarized sensitivity and specificity, the the SAUC</li>
<li> When data are sparse (have many 0 values), this model is recommended</li>
<li> When data are not sparse, this model has similar results with Reitsma's model</li>
</ul>
<p>Reference: <i>1. Chu H, Cole SR. Bivariate meta-analysis of sensitivity and specificity with sparse data: a generalized linear mixed model approach. J Clin Epidemiol. 2006;59(12):1331-1332. doi:10.1016/j.jclinepi.2006.06.011</i></p>

<h4><b> 2. You can get the following results:</b></h4>
<ul>
<li> The estimated summary ROC (SROC) curve</li>
<li> The estimates from the Reitsma's model</li>
<li> The estimates from the GLM model</li>
</ul>
See more details in the <b>Help and Install App</b> panel.
"

)

    # p("This page can make",tags$strong(" SROC Plot")," and",tags$strong(" SAUC Plot")),
    # HTML('<b>&#9312;Set Header TP,FN,FP,TN</b>'),br(),
    # HTML("&#10103;<b>When Change the Data, Click Reload DATA TO Calculation</b>"),br(),
    # downloadButton("ManualPDF_download","Download Manual")
    ),
hr(),
source("ui_resm.R", local = TRUE)$value,
hr()
),

########## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tabPanel("Analysis of Publication Bias",

headerPanel("Likelihood-based Sensitivity Analysis for Publication Bias"),
  
conditionalPanel(condition = "input.explain_on_off",
HTML(
      "
<p>This panel is used for sensitivity analysis on the estimates of meta-analysis of diagnostic test accuracy.</p>
<p>Publication bias (PB) is the threat to the validity of the estimates. The method in this panel provides a method to quantify the magnitude of the potential PB.</p> 
<h4><b>1. The input parameter</b></h4>
<ul>
<li><b>Marginal selection probability ($p$)</b>: the expected proportion of published studies from the population; while $1-p$ indicated the expected proportion of the unpublished</li>
</ul>
For example, there are 33 studies in the <i><b>Example</b></i>. 
When we assign $p=0.9$, we expect 
<ul>
<li>90% studies (33 studies) were published from the population ($33/0.93$\\approx 7$ studies)</li>
<li>10% studies ($37 \\times 0.1 \\approx 4$ studies) were not published and caused the potential publication bias</li>
</ul>
When we assign $p=1$, we expect there was no unpublished studies.

<h4><b>2. Other parameters</b></h4>
Contrast $c_1, c_2$: it defines the mechanism of selective publication process in the diagnostic studies 
<ul>
<li>$c_1=c_2$: the selective publication mechanism is influenced by both Sens and Spec; precisely, the $t$-type statistic of lnDOR influences PB</li>
<li>$c_1=1, c_2=0$: the selective publication mechanism is influenced in by Sens only; precisely, the $t$-type statistic of Sens influences PB</li>
<li>$c_1=0, c_2=1$: the selective publication mechanism is influenced in by Spec only; precisely, the $t$-type statistic of Spec influences PB</li>
<li>$\\hat c_1, \\hat c_2$: the selective publication mechanism is estimated from data</li>
</ul>

<h4><b>3. Optional parameters in the optimization</b></h4>
<ul>
<li><b>Initial value of $\\beta$</b>: the initial value of $\\beta$ in the optimization</li>
<li><b>Initial value of $c_1^2$</b>: the initial value of $c_1^2$ in the optimization</li>
<li><b>Range of $\\beta$</b>: lower and upper constraint of $\\beta$ in the optimization</li>
<li><b>Range of $\\alpha$</b>: lower and upper constraint of $\\alpha$ in the optimization</li>
</ul>

<h4><b> 4. You can get the following results:</b></h4>
<ul>
<li> The bias adjusted SROC curve, given the input marginal selection probability</li>
<li> The bias adjusted SAUC, given the input marginal selection probability</li>
<li> The bias adjusted $\\mu_1, \\mu_2, \\tau_1, \\tau_2, \\rho$, given the input marginal selection probability</li>
</ul>
See more details in <b>Help and Install App</b> panel.
"
    )
  ),
  hr(),
  source("ui_sensitivity.R", local = TRUE, encoding = "UTF-8")$value,
  hr()
  # )
),

########## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tabPanel("Detection of Publication Bias",

headerPanel("Funnel Plots for Detecting the Significance of Publication Bias"),

conditionalPanel(
    condition = "input.explain_on_off",
    HTML(
      "
<p>This panel presents funnel plots for detecting potential publication bias on lnDOR, logit-scaled Sens and Spec.</p>
<p> Funnel plot method is not suggested unless all the studies adopt the common cutoff values for diagnosis </p>
<h4><b> You can get the following results:</b></h4>
<ul>
<li> The funnel plot with trim-and-fill for lnDOR, logit-scaled Sens and Sens</li>
<li> The test asymmetry of the funnel plot</li>
</ul>

"
    )
  ),
  hr(),
  source("ui_funnel.R", local = TRUE, encoding = "UTF-8")$value,
  hr()
), 

########## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tabPanel("Help and Download",
fluidRow(column(12,
headerPanel("Download and Install App in Your Desktop"),
p(br()),
downloadButton("desktopApp_Download","Download App"),
helpText("You can get an *.exe installation file. Currently, it only supports the Windows system.")
)),
hr(),
wellPanel(
HTML("<h4><b>Help and Reference</b></h4>"),
helpText('Note: click the "Help" button on the top'),
conditionalPanel(condition = "input.explain_on_off",
     
HTML(
"
<h4><b>Models in this App</b></h4>

<h4><b> 1. Reitsma's model</b></h4>
<p>Suppose that $N~(i=1, \\dots, N)$ diagnostic studies are included in meta-analysis. In other words, there are $N$ rows in the input data.
The observed data are the number of true positives (TP), true negative (TN), false positives (FP), and false negatives (FN), so sensitivity (Sens) and specificity (Spec) can be estimated from data.</p>
<p>In the within-study level, we denote that,</p>
<ul>
<li>$y_{1i}$ and $y_{2i}$: the logit-Sens and logit-Spec after continuity correction</li>
<li>$s_{1i}^2$ and $s_{2i}^2$: the observed variances of $y_{1i}$ and $y_{2i}$ within each study</li>
<li>$\\mu_{1i}$ and $\\mu_{2i}$: the logit-transformed true Sens and Spec of the $i$th study</li>
</ul>
Given $(\\mu_{1i}, \\mu_{2i})$, it is assumed that:
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
<p>In the within-study level, we denote that,</p>
<ul>
<li>$\\mu_1$ and $\\mu_2$: the common means of the logit-transformed sensitivity and specificity</li>
<li>$\\tau_1^2$ and $\\tau_2^2$: between-study variances</li>
<li>$\\tau_{12} = \\rho\\tau_{1}\\tau_{2}$ is the covariance between $\\mu_{1i}$ and $\\mu_{2i}$, $\\rho~(-1 \\le \\rho \\le 1)$ is the correlation coefficient</li>
</ul>
It is assumed that $(\\mu_{1i}, \\mu_{2i})^T$ is normally distributed:
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
<p>The combination of \\eqref{eq:b2} and \\eqref{eq:b1} leads to the Reitsma's model:</p>
\\begin{align}
\\boldsymbol{y}_i | \\boldsymbol{\\Sigma}_i 
\\sim N_2 
\\left (\\boldsymbol{\\mu}, \\boldsymbol{\\Omega} + \\boldsymbol{\\Sigma}_i  \\right ),
\\label{eq:b12}
\\end{align}
where,$\\boldsymbol{y}_i = (y_{1i},y_{2i})^T$, $\\boldsymbol{\\mu} = (\\mu_1,\\mu_2)^T$
<p>Reitsma's model requires the number of diseased and non-diseased to be large.</p>

<h4><b> 2. Generalized linear mixed (GLM) model</b></h4>
<p>GLM model differs Reitsma's model in the within-study level.</p>
Suppose,</p>
<ul>
<li>$n_{00i}, n_{11i}, n_{01i}, n_{10i}$: TP, TN, FP, FN; $N_{1i}=n_{11i}+n_{10i}, N_{0i}=n_{00i}+n_{01i}$</li>
<li>$s_{1i}^2$ and $s_{2i}^2$: the observed variances of $y_{1i}$ and $y_{2i}$ within each study</li>
<li>$\\mu_{1i}$ and $\\mu_{2i}$: the logit-transformed true Sens and Spec of the $i$th study</li>
</ul>
<p>In the within-study level, it is assumed that:,</p>
\\begin{align}
n_{00i}\\sim \\text{Binomial}(N_{0i}, \\text{Spec}_i); ~~~~ n_{11i}\\sim \\text{Binomial}(N_{1i}, \\text{Sens}_i)
\\label{eq:b3}
\\end{align}
<p>In the between-study level, we denote that:</p>
<ul>
<li>$\\mu_{1i}=\\text{logit}(\\text{Sens}_i)$ and $\\mu_{2i}=\\text{logit}(\\text{Spec}_i)$</li>
<li>$\\mu_1$ and $\\mu_2$: the common means of the logit-Sens and logit-Spec</li>
<li>$\\tau_1^2$ and $\\tau_2^2$: between-study variances</li>
<li>$\\tau_{12} = \\rho\\tau_{1}\\tau_{2}$ is the covariance between $\\mu_{1i}$ and $\\mu_{2i}$, $\\rho~(-1 \\le \\rho \\le 1)$ is the correlation coefficient</li>
</ul>
<p>In the between-study level, $\\mu_{1i}, \\mu_{2i}$ have the same distribution with \\ref{eq:b2}</p>
<p>The combination of \\eqref{eq:b3} and \\eqref{eq:b1} leads to the GLM model.</p>
<p>GLM model does not require continuity correction.</p>

<h4><b> 3. SROC and SAUC</b></h4>
The SROC curve:
\\begin{align}
SROC(x; \\boldsymbol{\\mu}, \\boldsymbol{\\Omega}) 
= \\mathrm{logit}^{-1} \\left[ \\mu_1 - \\dfrac{\\tau_{12}}{\\tau_2^2}\\{\\mathrm{logit}(x)+\\mu_2\\} \\right].
\\label{eq:sroc}
\\end{align}
The HSROC curve is given by the SROC curve \\eqref{eq:sroc} with $\\rho=-1$.

The SAUC: 
\\begin{align}
SAUC(\\boldsymbol{\\mu}, \\boldsymbol{\\Omega}) 
= \\int_{0}^{1}SROC(x; \\boldsymbol{\\mu}, \\boldsymbol{\\Omega})dx.
\\label{sauc}
\\end{align}


<h4><b> 4. Likelihood based sensitivity analysis method</b></h4>
Publication bias is the phenomenon that studies with significant results are more likely to be published or selected for meta-analysis.
In meta-analysis of DTA, we consider to model the selective publication of each study by the selection function 
\\begin{align*}
P(\\text{Publish}|t_i)=\\Phi(\\alpha+\\beta\\times t_i\\},
\\end{align*}
which is the probit model on the $t$-type statistic of the linear combination of the logit-transformed sensitivity and specificity:
$
\\boldsymbol{c}^T \\boldsymbol{y}_i = c_1y_{1i}+c_2y_{2i},
$
where $\\boldsymbol{c} = (c_1, c_2)^T$ is a contrast vector.
The $t$-type statistic of the linear combination is 
$
t_i = {\\boldsymbol{c}^T \\boldsymbol{y}_i}/{\\sqrt{\\boldsymbol{c}^T\\boldsymbol{\\Sigma}_i\\boldsymbol{c}}}.
$
<br>
When $(c_1, c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$, it gives the $t$-statistic of the lnDOR.
By taking different contrast vectors, the $t$-type statistic can determine a variety of selective publication mechanisms.
For example, 
$(c_1, c_2) = (1, 0)$ and $(c_1, c_2) = (0, 1)$ indicate that the selective publication mechanisms are determined by the significance of sensitivity and specificity, respectively.
The contrast vector $\\boldsymbol{c}$ can be regarded as unknown parameters to be estimated or specified by user.

<br>
In the sensitivity analysis, we introduce the marginal probability of selective publication, $p=P(\\mathrm{select})=E\\{P(\\text{Publish}|t_i)\\}$.
The estimating model based on the joint distribution of observed data involving the selection probabilities can be constructed. 
Given various specified values of $p$, the bias-adjusted SROC curves and SAUC can be estimated from the maximum likelihood estimation.

<br>
<hr>
<h4><b>R packages used in this Application:</b></h4>
<ul>
<li>mada,
DT,
ggplot2,
plotly,
shiny,
shinythemes,
shinyWidgets,
mvmeta,
mada,
shinyAce,
latex2exp,
base,
</ul>


"
)
)),
hr()
),

#tablang("11DTA-Meta"),
tabstop(),
tablink()

# switchInput(
#   inputId = "explain_on_off",#
#   label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
#   inline = TRUE,
#   onLabel = "Close",
#   offLabel = "Details",
#   size = "default"
# )

))
# : Meta-Analysis of Diagnostic Accuracy. R package version 0.5.11, 
# \\begin{table}[]
# \\begin{tabular}{ll}
#     Package   name           & Link                                              \\\\hline
#     \\textit{DescTools}      & https://CRAN.R-project.org/package=DescTools      \\
#     \\textit{DT}             & https://CRAN.R-project.org/package=DT             \\
#     \\textit{exactRankTests} & https://CRAN.R-project.org/package=exactRankTests \\
#     \\textit{dunn.test}      & https://CRAN.R-project.org/package=dunn.test      \\
#     \\textit{ROCR}           & https://CRAN.R-project.org/package=ROCR           \\
#     \\textit{ggplot2}        & https://CRAN.R-project.org/package=ggplot2        \\
#     \\textit{magrittr}       & https://CRAN.R-project.org/package=magrittr       \\
#     \\textit{psych}          & https://CRAN.R-project.org/package=psych          \\
#     \\textit{pls}            & https://CRAN.R-project.org/package=pls            \\
#     \\textit{plotly}         & https://CRAN.R-project.org/package=plotly         \\
#     \\textit{reshape}        & https://CRAN.R-project.org/package=reshape        \\
#     \\textit{scales}         & https://CRAN.R-project.org/package=scales         \\
#     \\textit{shiny}          & https://CRAN.R-project.org/package=shiny          \\
#     \\textit{shinythemes}    & https://CRAN.R-project.org/package=shinythemes    \\
#     \\textit{shinyWidgets}   & https://CRAN.R-project.org/package=shinyWidgets   \\
#     \\textit{survival}       & https://CRAN.R-project.org/package=survival       \\
#     \\textit{survminer}      & https://CRAN.R-project.org/package=survminer      \\
#     \\textit{survAUC}        & https://CRAN.R-project.org/package=survAUC        \\
#     \\textit{spls}           & https://CRAN.R-project.org/package=spls           \\
#     \\textit{stargazer}      & https://CRAN.R-project.org/package=stargazer      \\
#     \\textit{mvmeta}         & https://CRAN.R-project.org/package=mvmeta         \\
#     \\textit{mada}           & https://CRAN.R-project.org/package=mada           \\
#     \\textit{shinyAce}       & https://CRAN.R-project.org/package=shinyAce       \\
#     \\textit{latex2exp}      & https://CRAN.R-project.org/package=latex2exp      \\
#     \\textit{base}           & https://CRAN.R-project.org/package=base           \\
#     \\textit{methods}        & https://CRAN.R-project.org/package=stargazer      \\
#     \\textit{graphics}       & https://CRAN.R-project.org/package=graphics       \\
#     \\textit{grDevices}      & https://CRAN.R-project.org/package=grDevices      \\
#     \\textit{stats}          & https://CRAN.R-project.org/package=stats          \\
#     \\textit{utils}          & https://CRAN.R-project.org/package=utils       
# \\end{tabular}
    
# \\end{table}<a href='https://cran.r-project.org/' target='_blank'>https://CRAN.R-project.org/package</a></li>
