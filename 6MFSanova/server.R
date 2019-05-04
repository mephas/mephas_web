 
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(psych)) {install.packages("psych")}; library(psych)
if (!require(Rmisc)) {install.packages("Rmisc")}; library(Rmisc)
##----------#----------#----------#----------
##
## 6MFSanova SERVER
##
## Language: EN
## 
## DT: 2019-04-07
##
##----------#----------#----------#----------

shinyServer(

function(input, output) {

##########----------##########----------##########
##---------- 1.One way ANOVA ----------

source("p1_server.R", local=TRUE)$value

##---------- 2. two way ANOVA ----------

source("p2_server.R", local=TRUE)$value

##---------- 3. multiple comparison ----------

source("p3_server.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)


