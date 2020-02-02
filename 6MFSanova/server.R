 
if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("psych")) {install.packages("psych")}; library("psych")
if (!require("DescTools")) {install.packages("DescTools")}; library("DescTools")
if (!require("dunn.test")) {install.packages("dunn.test")}; library("dunn.test")
if (!require("DT")) {install.packages("DT")}; library("DT")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

#shinyServer(

function(input, output) {

source("../func.R")
##########----------##########----------##########

source("server_1.R", local=TRUE)$value
source("server_1m.R", local=TRUE)$value
source("server_2.R", local=TRUE)$value
source("server_2m.R", local=TRUE)$value
source("server_np1.R", local=TRUE)$value
source("server_np1m.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
#)


