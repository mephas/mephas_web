#if (!require("Hmisc")) {install.packages("Hmisc")};library("Hmisc")
if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("DT")) {install.packages("DT")}; library("DT")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")

shinyServer( 
function(input, output) {

source("../func.R")
##########----------##########----------##########

source("p1_server.R", local=TRUE)$value
  
source("p2_server.R", local=TRUE)$value

source("p3_server.R", local=TRUE)$value

source("p4_server.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
)


