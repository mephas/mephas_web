if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(plotly)) {install.packages("plotly")}; library(plotly)
if (!require(psych)) {install.packages("psych")}; library(psych)


shinyServer(

function(input, output, session) {


##########----------##########----------##########
source("0data_server.R", local=TRUE, encoding="UTF-8")

source("pca_server.R", local=TRUE, encoding="UTF-8")

source("fa_server.R", local=TRUE, encoding="UTF-8") 

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)



