if (!require(stargazer)) {install.packages("stargazer")}; library(stargazer)
if (!require(survival)) {install.packages("survival")}; library(survival)
if (!require(survminer)) {install.packages("survminer")}; library(survminer)
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(psych)) {install.packages("psych")}; library(psych)
if (!require(reshape2)) {install.packages("reshape2")}; library(reshape2)
if (!require(survAUC)) {install.packages("survAUC")}; library(survAUC)
  
shinyServer(

function(input, output, session) {


##########----------##########----------##########

source("0data_server.R", local=TRUE)$value

source("1km_server.R", local=TRUE)$value

source("2aft_server.R", local=TRUE)$value

source("2pr_server.R", local=TRUE)$value

source("3cox_server.R", local=TRUE)$value

source("3pr_server.R", local=TRUE)$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
})



