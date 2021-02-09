

library(shiny)
library(multcomp)

shinyServer(
  
  function(input, output, session) {

#panel 0 num
    source("0_datainput_server.R", local=TRUE,encoding = "utf-8")$value

    

    
  }
)
