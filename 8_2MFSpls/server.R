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
source("server_data.R", local=TRUE, encoding="UTF-8")


source("server_pcr.R", local=TRUE, encoding="UTF-8")
source("server_pcr_pr.R", local=TRUE, encoding="UTF-8")

source("server_pls.R", local=TRUE, encoding="UTF-8") 
source("server_pls_pr.R", local=TRUE, encoding="UTF-8")

source("server_spls.R", local=TRUE, encoding="UTF-8") 
source("server_spls_pr.R", local=TRUE, encoding="UTF-8")


##########----------##########----------##########
observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)



