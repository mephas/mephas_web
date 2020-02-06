
#shinyServer(

function(input, output) {

##########----------##########----------##########
source("../tab/func.R")
source("server_bio.R", local=TRUE)$value

source("server_poi.R", local=TRUE)$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
}
#)

