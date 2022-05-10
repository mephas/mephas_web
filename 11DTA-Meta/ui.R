
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!requireNamespace("shinyWidgets", quietly = TRUE)) {install.packages("shinyWidgets")}; require("shinyWidgets",quietly = TRUE)
if (!requireNamespace("latex2exp", quietly = TRUE)) {install.packages("latex2exp")}; require("latex2exp",quietly = TRUE)
if (!requireNamespace("dtametasa", quietly = TRUE)) {install.packages("dtametasa")}; require("dtametasa",quietly = TRUE)
if (!requireNamespace("DT", quietly = TRUE)) {install.packages("DT")}; require("DT",quietly = TRUE)

source("function.R")
#source("./ui_dtameta.R",local = TRUE)
source("./ui_uni.R",local = TRUE)
source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")
# tabOF <- function(){
#   fluidPage(#
#     shinyWidgets::switchInput(#
#       inputId = "explain_on_off",#
#       label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
#       inline = TRUE,
#       onLabel = "Show",
#       offLabel = "Hide",
#       size = "mini"
#     )
#   )
# }
tagList(includeCSS("../www/style.css"),
        stylink(),
  hr(),hr(),tabOF(),
        
navbarPage(
  theme = shinythemes::shinytheme("cerulean"),
  collapsible = TRUE,
  position="fixed-top",
  title = "DTA-META-SA",
  tabPanel("DTA",conditionalPanel(
    condition = "input.explain_on_off",
    HTML("<h4><b>Functionalities</b></h4>")),
    source("./ui_dta.R",local = TRUE)),
  tabPanel("Univariate-meta",Univariate_Body),
  tablang("11DTA-Meta"),
  tabstop(),
  tablink()
  ))