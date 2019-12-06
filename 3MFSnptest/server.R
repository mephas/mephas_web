if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(DescTools)) {install.packages("DescTools")}; library(DescTools)  #SignTest
if (!require(RVAideMemoire)) {install.packages("RVAideMemoire")}; library(RVAideMemoire)  
if (!require(pastecs)) {install.packages("pastecs")}; library(pastecs)
##----------#----------#----------#----------
##
## 3MFSnptest SERVER
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
shinyServer(

 function(input, output) {

##########----------##########----------##########

##---------- 1. one sample ----------
source("p1_server.R", local=TRUE)$value

##---------- 2. two samples ----------

source("p2_server.R", local=TRUE)$value
 
##---------- 3. paired sample ----------
source("p3_server.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
  
##########----------##########----------##########

})


