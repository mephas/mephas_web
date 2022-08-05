
#shinyServer(

function(input, output) {

##########----------##########----------##########
#source("../tab/func.R")
source("server_bio.R", local=TRUE, encoding = "utf-8")$value

source("server_poi.R", local=TRUE, encoding = "utf-8")$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
}
#)

