#if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(psych)) {install.packages("psych")}; library(psych)
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(DT)) {install.packages("DT")}; library(DT)

##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyServer(
function(input, output) {
  
##----------1. 2,2 independent ----------
source("p1_server.R", local=TRUE)$value
##----------2. 2,2 dependent ----------
source("p2_server.R", local=TRUE)$value
##----------2. small 2,2 dependent ----------
source("p4_server.R", local=TRUE)$value
##----------3. 2,C independent ----------
source("p3_server.R", local=TRUE)$value
##----------4. R,C independent ----------
source("p5_server.R", local=TRUE)$value
##----------5. K,K independent ----------
source("p6_server.R", local=TRUE)$value

source("p7_server.R", local=TRUE)$value

source("p8_server.R", local=TRUE)$value
source("p9_server.R", local=TRUE)$value

##########----------##########----------##########


observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


})



