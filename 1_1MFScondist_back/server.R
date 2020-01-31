if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")

shinyServer(

function(input, output) {

##########----------##########----------##########
source("../func.R")

source("p1_server.R", local=TRUE)$value

source("p2_server.R", local=TRUE)$value

source("p3_server.R", local=TRUE)$value

source("p4_server.R", local=TRUE)$value

source("p5_server.R", local=TRUE)$value

source("p6_server.R", local=TRUE)$value

source("p7_server.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
)

