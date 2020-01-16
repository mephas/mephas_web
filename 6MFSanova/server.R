 
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(psych)) {install.packages("psych")}; library(psych)
if (!require(Rmisc)) {install.packages("Rmisc")}; library(Rmisc)
if (!require(dunn.test)) {install.packages("dunn.test")}; library(dunn.test)
if (!require(DT)) {install.packages("DT")}; library(DT)

shinyServer(

function(input, output) {

##########----------##########----------##########

source("p1_server.R", local=TRUE)$value
source("p2_server.R", local=TRUE)$value
source("p3_server.R", local=TRUE)$value
source("p4_server.R", local=TRUE)$value
source("p5_server.R", local=TRUE)$value
source("p6_server.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)


