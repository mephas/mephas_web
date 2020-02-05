
#shinyServer(

function(input, output) {

source("../tab/func.R")
##########----------##########----------##########

source("server_1.R", local=TRUE)$value
source("server_1m.R", local=TRUE)$value
source("server_2.R", local=TRUE)$value
source("server_2m.R", local=TRUE)$value
source("server_np1.R", local=TRUE)$value
source("server_np1m.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
#)


