if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("DT")) {install.packages("DT")}
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("psych")) {install.packages("psych")}; library("psych")

shinyServer(

function(input, output, session) {

source("../func.R")
##########----------##########----------##########

source("0data_server.R", local=TRUE)$value

source("1lm_server.R", local=TRUE)$value

source("2pr_server.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
})



