#shinyServer(

function(input, output, session) {

##########----------##########----------##########
source("server_data.R", local=TRUE, encoding="UTF-8")

source("server_pca.R", local=TRUE, encoding="UTF-8")

source("server_fa.R", local=TRUE, encoding="UTF-8") 

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
observeEvent(input$ModelPCA, showTab("navibar", target = "主成分分析(PCA)", select = TRUE))
observeEvent(input$ModelEFA, showTab("navibar", target = "探索的因子分析(EFA)", select = TRUE))

}
#)
