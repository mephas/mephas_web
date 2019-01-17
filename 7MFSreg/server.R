if (!require(xtable)) {install.packages("xtable")}; library(xtable)
if (!require(stargazer)) {install.packages("stargazer")}; library(stargazer)
if (!require(ggfortify)) {install.packages("ggfortify")}; library(ggfortify)
if (!require(plotROC)) {install.packages("plotROC")}; library(plotROC)
if (!require(ROCR)) {install.packages("ROCR")}; library(ROCR)
if (!require(survival)) {install.packages("survival")}; library(survival)
if (!require(survminer)) {install.packages("survminer")}; library(survminer)
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(data.table)) {install.packages("data.table")}; library(data.table)
  
##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

# start server
shinyServer(

function(input, output, session) {

#----------0. dataset input----------
source("0data_server.R", local=TRUE) 

#----------1. Linear regression----------
source("1lm_server.R", local=TRUE)

#----------2. Logistic regression----------
source("2lr_server.R", local=TRUE)

#----------3. Cox regression----------
source("3cr_server.R", local=TRUE)


#---------------------------##
observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
})



