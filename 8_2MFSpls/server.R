if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(DT)) {install.packages("DT")}; library(DT)
if (!require(psych)) {install.packages("psych")}; library(psych)
if (!require(pls)) {install.packages("pls")}; library(pls)
if (!require(spls)) {install.packages("spls")}; library(spls)
if (!require(plotly)) {install.packages("plotly")}; library(plotly)

shinyServer(

function(input, output, session) {

source("../func.R")
##########----------##########----------##########
source("0data_server.R", local=TRUE, encoding="UTF-8")


source("pcr_server.R", local=TRUE, encoding="UTF-8")
source("pr1_server.R", local=TRUE, encoding="UTF-8")

source("plsr_server.R", local=TRUE, encoding="UTF-8") 
source("pr2_server.R", local=TRUE, encoding="UTF-8")

source("spls_server.R", local=TRUE, encoding="UTF-8") 
source("pr3_server.R", local=TRUE, encoding="UTF-8")


##########----------##########----------##########
observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)



