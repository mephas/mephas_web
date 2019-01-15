if (!require(xtable)) {install.packages("xtable")}; library(xtable)
if (!require(stargazer)) {install.packages("stargazer")}; library(stargazer)
if (!require(ggfortify)) {install.packages("ggfortify")}; library(ggfortify)
if (!require(plotROC)) {install.packages("plotROC")}; library(plotROC)
if (!require(ROCR)) {install.packages("ROCR")}; library(ROCR)
if (!require(survival)) {install.packages("survival")}; library(survival)
if (!require(survminer)) {install.packages("survminer")}; library(survminer)
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
  
##----------------------------------------------------------------
##
## The regression models: lm, logistic model, cox model, server
## 
## DT: 2018-11-30
##
##----------------------------------------------------------------

# start server
shinyServer(

function(input, output, session) {

#----------0. dataset input----------
source("0data_server.R", local=TRUE,encoding = "UTF-8") 

#----------1. Linear regression----------
source("1lm_server.R", local=TRUE,encoding = "UTF-8")

#----------2. Logistic regression----------
source("2lr_server.R", local=TRUE,encoding = "UTF-8")

#----------3. Cox regression----------
source("3cr_server.R", local=TRUE,encoding = "UTF-8")


#---------------------------##
observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
})



