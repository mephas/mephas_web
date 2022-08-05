
#shinyServer(

function(input, output, session) {

#source("../tab/func.R")
##########----------##########----------##########

source("server_data.R", local=TRUE, encoding = "utf-8")$value

source("server_model.R", local=TRUE, encoding = "utf-8")$value

source("server_pr.R", local=TRUE, encoding = "utf-8")$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

observeEvent(input$Model, showTab("navibar", target = "モデルの構築とデータの予測", select = TRUE))

}

#)



