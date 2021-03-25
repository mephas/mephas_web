
#shinyServer(

function(input, output) {

##########----------##########----------##########
options(digits=6)

source("server_N.R", local=TRUE)$value

source("server_E.R", local=TRUE)$value

source("server_G.R", local=TRUE)$value

source("server_B.R", local=TRUE)$value

source("server_T.R", local=TRUE)$value

source("server_Chi.R", local=TRUE)$value

source("server_F.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })




}
#)

