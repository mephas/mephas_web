if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(plotly)) {install.packages("plotly")}; library(plotly)
if (!require(psych)) {install.packages("psych")}; library(psych)


shinyServer(

function(input, output, session) {

source("../func.R")
##########----------##########----------##########
source("server_data.R", local=TRUE, encoding="UTF-8")

source("server_pca.R", local=TRUE, encoding="UTF-8")

source("server_fa.R", local=TRUE, encoding="UTF-8") 

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)



