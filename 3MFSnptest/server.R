if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("reshape")) {install.packages("reshape")}; library("reshape")
if (!require("exactRankTests")) {install.packages("exactRankTests")}; library("exactRankTests")  
if (!require("psych")) {install.packages("psych")}; library("psych")
if (!require("DT")) {install.packages("DT")}; library("DT")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")

shinyServer(

 function(input, output) {

source("../func.R")
##########----------##########----------##########

source("p1_server.R", local=TRUE)$value

source("p2_server.R", local=TRUE)$value
 
source("p3_server.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
  
})


