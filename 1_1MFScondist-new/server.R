
#shinyServer(

function(input, output) {

##########----------##########----------##########
options(digits=6)

source("server_N.R", local=TRUE, encoding = "utf-8")$value

source("server_E.R", local=TRUE, encoding = "utf-8")$value

source("server_G.R", local=TRUE, encoding = "utf-8")$value

source("server_B.R", local=TRUE, encoding = "utf-8")$value

source("server_T.R", local=TRUE, encoding = "utf-8")$value

source("server_Chi.R", local=TRUE, encoding = "utf-8")$value

source("server_F.R", local=TRUE, encoding = "utf-8")$value

source("server_data.R", local=TRUE, encoding = "utf-8")$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })




}
#)

