
#shinyServer( 
function(input, output) {

#source("../tab/func.R")
##########----------##########----------##########

source("server_1.R", local=TRUE)$value
  
source("server_2.R", local=TRUE)$value

source("server_3.R", local=TRUE)$value

source("server_t.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
#)


