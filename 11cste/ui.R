#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# pkgs
if(!requireNamespace("CSTE",quietly=TRUE)) devtools::install_github("mephas/CSTEforShiny")
library("CSTE",quietly=TRUE)
if(!requireNamespace("magrittr",quietly=TRUE)) install.packages("magrittr")
library("magrittr",quietly=TRUE)
if(!requireNamespace("shinyWidgets",quietly=TRUE)) install.packages("shinyWidgets")
library("shinyWidgets",quietly=TRUE)
if(!requireNamespace("shiny",quietly=TRUE)) install.packages("shiny")
library("shiny",quietly=TRUE)
if(!requireNamespace("DT",quietly=TRUE)) install.packages("DT")
library("DT",quietly=TRUE)
if(!requireNamespace("htmltools",quietly=TRUE)) install.packages("htmltools")
library("htmltools",quietly=TRUE)
if(!requireNamespace("dplyr",quietly=TRUE)) install.packages("dplyr")
library("dplyr",quietly=TRUE)
if(!requireNamespace("ggplot2",quietly=TRUE)) install.packages("ggplot2")
library("ggplot2",quietly=TRUE)
if(!requireNamespace("plotly",quietly=TRUE)) install.packages("plotly")
library("plotly",quietly=TRUE)
if(!requireNamespace("shinythemes",quietly=TRUE)) install.packages("shinythemes")
library("shinythemes",quietly=TRUE)
if(!requireNamespace("shinycssloaders",quietly=TRUE)) install.packages("shinycssloaders")
library("shinycssloaders",quietly=TRUE)
if(!requireNamespace("shinyjs",quietly=TRUE)) install.packages("shinyjs")
library("shinyjs",quietly=TRUE)
if(!requireNamespace("latex2exp",quietly=TRUE)) install.packages("latex2exp")
library("latex2exp",quietly=TRUE)
if(!requireNamespace("fastDummies",quietly=TRUE)) install.packages("fastDummies")
library("fastDummies",quietly=TRUE)
# Define UI for application that draws a histogram
# fluidPage(
tagList(
withMathJax(),
navbarPage(
theme = shinytheme("cerulean"), #united #simplex
title = ("CSTEapp (ver 1.0.0)"),
# collapsible = TRUE,
# id = "navibar",
# position = "static-top",
  tabPanel("Wiki",
  # HTML("")
  includeMarkdown("intro.md")
# HTML('

# <h3 id="introduction-of-cste-ver-1-0-0-">Introduction of <em>CSTE</em> (ver 1.0.0)</h3>
# <p><em>CSTE</em> provides a uniform statistical inferential tool for estimating individualized treatment rule.</p>
# <p><em>CSTE</em> estimates differences of average outcomes between different treatment groups conditional on patients characteristics and provides the corresponding simultaneous confidence bands. Based on the CSTE curve and the simultaneous confidence bands, one can decide the subgroups of patients that benefit from each treatment and then make individualized treatment selections.</p>
# <p><strong>The current <em>CSTE</em> can analyze the following types of datasets:</strong></p>
# <ul>
# <li><p>Datasets with binary outcomes, 2-arm treatments, and single or multiple (even high-dimensional) covariates.<a href="#1">[1-2]</a></p>
# </li>
# <li><p>Datasets with right censored time-to-event outcomes, multi-arm treatments, and a single covariate of the biomarker.<a href="#4">[3-4]</a></p>
# </li>
# </ul>
# <p><em>CSTE</em> will consider more types of datasets in the future.</p>
# <h3 id="r-package">R package</h3>
# <p>CSTE: Covariate Specific Treatment Effect (CSTE) Curve (<a href="https://CRAN.R-project.org/package=CSTE">https://CRAN.R-project.org/package=CSTE</a>)</p>
# <hr>
# <h4 id="references">References</h4>
# <p><a id="1">[1]</a> Han K, Zhou X, Liu B. CSTE curve for selection of the optimal treatment when outcome is binary. SCIENTIA SINICA Mathematica. 2017;47(4):497–514.</p>
# <p><a id="2">[2]</a> Guo W, Zhou XH, Ma S. Estimation of optimal individualized treatment rules using a covariate-specific treatment effect curve with high-dimensional covariates. Journal of the American Statistical Association. 2021;116(533):309–21. <a href="https://doi.org/10.1080/01621459.2020.1865167">https://doi.org/10.1080/01621459.2020.1865167</a></p>
# <p><a id="3">[3]</a> Zhou XH, Ma Y. BATE curve in assessment of clinical utility of predictive biomarkers. Science China Mathematics. 2012 Aug 18;55(8):1529–52. <a href="http://link.springer.com/10.1007/s11425-012-4473-0">http://link.springer.com/10.1007/s11425-012-4473-0</a></p>
# <p><a id="4">[4]</a> Ma Y, Zhou XH. Treatment selection in a randomized clinical trial via covariate-specific treatment effect curves. Statistical Methods in Medical Research. 2017 Feb;26(1):124–41. <a href="http://journals.sagepub.com/doi/10.1177/0962280214541724">http://journals.sagepub.com/doi/10.1177/0962280214541724</a></p>

# <hr>
# <h4 id="contact">Contact</h4>
# <p>yzhou_at_pku.edu.cn</p>
# <hr>
# <h4 id="release-history">Release history</h4>
# <style type="text/css">
# .tg  {border-collapse:collapse;border-spacing:0;}
# .tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
#   overflow:hidden;padding:10px 5px;word-break:normal;}
# .tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
#   font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
# .tg .tg-llyw{background-color:#c0c0c0;border-color:inherit;text-align:left;vertical-align:top}
# .tg .tg-0pky{border-color:inherit;text-align:left;vertical-align:top}
# </style>
# <table class="tg">
# <thead>
#   <tr>
#     <th class="tg-llyw">Date</th>
#     <th class="tg-llyw">Version</th>
#     <th class="tg-llyw">Details</th>
#   </tr>
# </thead>
# <tbody>
#   <tr>
#     <td class="tg-0pky">2023-09-30</td>
#     <td class="tg-0pky">0.9.0</td>
#     <td class="tg-0pky">First release</td>
#   </tr>
# </tbody>
# </table>
# ')
),

tabPanel("Binary outcomes",
source("ui1.R",local = T, encoding = "UTF-8")$value
),
tabPanel("Survival outcomes",
source("ui2.R",local = T, encoding = "UTF-8")$value
),


navbarMenu("Close and more", icon = icon("power-off"),
           tabPanel(
             actionLink(
               "close", "Stop", 
               icon = icon("power-off"),
               onclick = "setTimeout(function(){window.close();}, 100);"
               # onclick = "stopApp()"
             )
           ),
           tabPanel(
             tags$a("",
                    #target = "_blank",
                    #style = "margin-top:-30px; color:DodgerBlue",
                    href = paste0("javascript:history.go(0)"),#,
                    list(icon("rotate"), "Restart"))
           )
),
hr()
)
# includeMarkdown("cste.md"),
)
# )