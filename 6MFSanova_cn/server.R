
#shinyServer(

function(input, output) {

##########----------##########----------##########

source("server_1.R", local=TRUE, encoding = "utf-8")$value
source("server_1m.R", local=TRUE, encoding = "utf-8")$value
source("server_2.R", local=TRUE, encoding = "utf-8")$value
source("server_2m.R", local=TRUE, encoding = "utf-8")$value
source("server_np1.R", local=TRUE, encoding = "utf-8")$value
source("server_np1m.R", local=TRUE, encoding = "utf-8")$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
#)


