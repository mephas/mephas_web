
#shinyServer(

function(input, output) {

#source("../tab/func.R")
##########----------##########----------##########

source("server_1.R", local=TRUE, encoding = "utf-8")$value

source("server_2.R", local=TRUE, encoding = "utf-8")$value
 
source("server_p.R", local=TRUE, encoding = "utf-8")$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
  
}
#)


