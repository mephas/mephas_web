if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
#if (!require(plotly)) {install.packages("plotly")}; library(plotly)
#if (!require(DT)) {install.packages("DT")}; library(DT)
##----------#----------#----------#----------
##
## 1MFSdistribution SERVER
##
## Language: EN
## 
## DT: 2019-01-08
## Update: 2019-12-05
##
##----------#----------#----------#----------

shinyServer(

function(input, output) {

##########----------##########----------##########

source("p1_server.R", local=TRUE)$value

source("p2_server.R", local=TRUE)$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
)

