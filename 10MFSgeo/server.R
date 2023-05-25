library(shiny)
library(multcomp)
library(clusterProfiler)
library(gplots)
#library(bitr)

#shinyServer(
  
  function(input, output, session) {

#panel 0 num
    source("0_datainput_server.R", local=TRUE,encoding = "utf-8")$value

    
##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
    
  }
#)
