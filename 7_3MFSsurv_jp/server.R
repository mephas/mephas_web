
#shinyServer(

function(input, output, session) {

#source("../tab/func.R")
##########----------##########----------##########

source("server_data.R", local=TRUE)$value

source("server_km.R", local=TRUE)$value

source("server_cox.R", local=TRUE)$value

source("server_cox_pr.R", local=TRUE)$value

source("server_aft.R", local=TRUE)$value

source("server_aft_pr.R", local=TRUE)$value


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

observeEvent(input$"Non-Parametric Model", showTab("navibar", target = "KM モデル", select = TRUE))
observeEvent(input$"Semi-Parametric Model", showTab("navibar", target = "コックス(Cox)モデルと予測", select = TRUE))
observeEvent(input$"Parametric Model", showTab("navibar", target = "AFTモデルと予測", select = TRUE))

}
#)

