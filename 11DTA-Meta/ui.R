
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
library("shinyAce")
source("function.R")
#source("./ui_dtameta.R",local = TRUE)
source("./ui_uni.R",local = TRUE)
source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")



tagList(includeCSS("../www/style.css"),
        stylink(),
        
        fluidPage(
          shinyWidgets::switchInput(
            inputId = "explain_on_off",#
            label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
            inline = TRUE,
            onLabel = "Close",
            offLabel = "How to use",
            size = "mini"
          )
        )
        ,
        
navbarPage(
  theme = shinythemes::shinytheme("cerulean"),
  collapsible = TRUE,
  position="fixed-top",
  title = "DTA-META-SA",
  tabPanel("DTA",conditionalPanel(
    condition = "input.explain_on_off",
    HTML("<h4><b>Functionalities</b></h4>"),
    downloadButton("ManualPDF_download","Download Manual")
    ),
    source("./ui_dta.R",local = TRUE)),
  tabPanel("Univariate-meta",Univariate_Body),
  tablang("11DTA-Meta"),
  tabstop(),
  tablink()
  ))