
#shinyServer(

function(input, output, session) {
	
##########----------##########----------##########
source("server_data.R", local=TRUE, encoding="UTF-8")


source("server_pcr.R", local=TRUE, encoding="UTF-8")
source("server_pcr_pr.R", local=TRUE, encoding="UTF-8")

source("server_pls.R", local=TRUE, encoding="UTF-8") 
source("server_pls_pr.R", local=TRUE, encoding="UTF-8")

source("server_spls.R", local=TRUE, encoding="UTF-8") 
source("server_spls_pr.R", local=TRUE, encoding="UTF-8")


##########----------##########----------##########
observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

observeEvent(input$"ModelPCR", showTab("navibar", target = "PCR and Prediction", select = TRUE))
observeEvent(input$"ModelPLSR", showTab("navibar", target = "PLSR and Prediction", select = TRUE))
observeEvent(input$"ModelSPLSR", showTab("navibar", target = "SPLSR and Prediction", select = TRUE))

}
#)



