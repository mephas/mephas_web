if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(plotly)) {install.packages("plotly")}; library(plotly)
#if (!require(dplyr)) {install.packages("dplyr")}; library(dplyr)
if (!require(stargazer)) {install.packages("stargazer")}; library(stargazer)
if (!require(ROCR)) {install.packages("ROCR")}; library(ROCR)
##----------#----------#----------#----------
## logistic regression
shinyServer(

function(input, output, session) {

#----------0. dataset input----------
source("0data_server.R", local=TRUE)$value

#----------1. Linear regression----------
source("1lm_server.R", local=TRUE)$value

#----------2. Logistic regression----------
source("2pr_server.R", local=TRUE)$value

#----------3. Cox regression----------
#source("3cr_server.R", local=TRUE)$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
})



