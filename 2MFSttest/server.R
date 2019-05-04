if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(pastecs)) {install.packages("pastecs")}; library(pastecs)

##----------#----------#----------#----------
##
## 2MFSttest SERVER
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyServer(

function(input, output) {

##########----------##########----------##########
##---------- 1. One sample t test---------

source("p1_server.R", local=TRUE)$value

##---------- 2. Two sample t test---------

source("p2_server.R", local=TRUE)$value

##---------- 3. Paired sample t test ---------

source("p3_server.R", local=TRUE)$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
)



