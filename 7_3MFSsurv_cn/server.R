
#shinyServer(

function(input, output, session) {

#source("../tab/func.R")
##########----------##########----------##########

source("server_data.R", local=TRUE, encoding = "utf-8")$value

source("server_km.R", local=TRUE, encoding = "utf-8")$value

source("server_cox.R", local=TRUE, encoding = "utf-8")$value

source("server_cox_pr.R", local=TRUE, encoding = "utf-8")$value

source("server_aft.R", local=TRUE, encoding = "utf-8")$value

source("server_aft_pr.R", local=TRUE, encoding = "utf-8")$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

observeEvent(input$"Non-Parametric Model", showTab("navibar", target = "Kaplan-Meier模型", select = TRUE))
observeEvent(input$"Semi-Parametric Model", showTab("navibar", target = "Cox模型和预测", select = TRUE))
observeEvent(input$"Parametric Model", showTab("navibar", target = "AFT模型和预测", select = TRUE))

}
#)

