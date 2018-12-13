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
## The univariate regression models: lm, logistic model, cox model, server JP
## 
## DT: 2018-11-30
##
##----------------------------------------------------------------

# start server
function(input, output, session) {
  #options(warn = -1)
  #options(digits= 6)

# 1. Linear regression
source("lm_s.R", local=TRUE)
#---------------------------##
# 2. logistic regression
source("log_s.R", local=TRUE)
#---------------------------##
# 3. cox regression
source("cox_s.R", local=TRUE)
#---------------------------##
observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

#session$allowReconnect(TRUE)
}
