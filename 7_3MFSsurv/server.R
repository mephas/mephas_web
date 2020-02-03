if (!require("stargazer")) {install.packages("stargazer")}; library("stargazer")
if (!require("survival")) {install.packages("survival")}; library("survival")
if (!require("survminer")) {install.packages("survminer")}; library("survminer")
if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("psych")) {install.packages("psych")}; library("psych")
if (!require("reshape2")) {install.packages("reshape2")}; library("reshape2")
if (!require("survAUC")) {install.packages("survAUC")}; library("survAUC")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

#shinyServer(

function(input, output, session) {

source("../func.R")
##########----------##########----------##########

source("server_data.R", local=TRUE)$value

source("server_km.R", local=TRUE)$value

source("server_cox.R", local=TRUE)$value

source("server_cox_pr.R", local=TRUE)$value

source("server_aft.R", local=TRUE)$value

source("server_aft_pr.R", local=TRUE)$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

observeEvent(input$"Non-Parametric Model", showTab("navibar", target = "KM Model", select = TRUE))
observeEvent(input$"Semi-Parametric Model", showTab("navibar", target = "Cox Model and Prediction", select = TRUE))
observeEvent(input$"Parametric Model", showTab("navibar", target = "AFT Model and Prediction", select = TRUE))

}
#)



