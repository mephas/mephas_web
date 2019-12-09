if (!require(Hmisc)) {install.packages("Hmisc")}; library(Hmisc)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)

##----------#----------#----------#----------
##
## 4MFSproptest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyServer( 
function(input, output) {

##########----------##########----------##########

##----------1. Chi-square test for single sample ----------
source("p1_server.R", local=TRUE)$value
##---------- 2. Two sample ----------

source("p2_server.R", local=TRUE)$value
##---------- 3. More than 2 sample ----------

source("p3_server.R", local=TRUE)$value

##---------- 4. trend More than 2 sample ----------

source("p4_server.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
)


