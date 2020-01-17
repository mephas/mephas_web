if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)

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

