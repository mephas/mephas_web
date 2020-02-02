if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("psych")) {install.packages("psych")}; library("psych")
if (!require("stargazer")) {install.packages("stargazer")}; library("stargazer")
if (!require("ROCR")) {install.packages("ROCR")}; library("ROCR")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

#shinyServer(

function(input, output, session) {
	
source("../func.R")
##########----------##########----------##########
source("server_data.R", local=TRUE)$value

source("server_model.R", local=TRUE)$value

source("server_pr.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
observeEvent(input$Model, showTab("navibar", target = "Model", select = TRUE))


}

#)



