#if (!require("Hmisc")) {install.packages("Hmisc")};library("Hmisc")
if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("DT")) {install.packages("DT")}; library("DT")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

#shinyServer( 
function(input, output) {

source("../func.R")
##########----------##########----------##########

source("server_1.R", local=TRUE)$value
  
source("server_2.R", local=TRUE)$value

source("server_3.R", local=TRUE)$value

source("server_t.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
#)


