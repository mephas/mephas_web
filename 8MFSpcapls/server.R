if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggfortify)) {install.packages("ggfortify")}; library(ggfortify)
if (!require(pls)) {install.packages("pls")}; library(pls)
if (!require(spls)) {install.packages("spls")}; library(spls)
##----------#----------#----------#----------
##
## 8MFSpcapls SERVER
##
## Language: EN
## 
## DT: 2019-01-15
##
##----------#----------#----------#----------

shinyServer(

function(input, output, session) {

#----------0. dataset input----------

source("0data_server.R", local=TRUE, encoding="UTF-8")

#----------1. PCA ----------
output$nc <- renderText({ input$nc })
# model
pca <- reactive({
  #pca = mixOmics::pca(as.matrix(X()), ncomp = input$nc, scale = TRUE)
  prcomp(as.matrix(X()), rank.=input$nc, scale. = input$scale1)
  })

pca.x <- reactive({ pca()$x })

#output$fit  <- renderPrint({
#  res <- rbind(pca()$explained_variance,pca()$cum.var)
#  rownames(res) <- c("explained_variance", "cumulative_variance")
#  res})
output$fit  <- renderPrint({
  summary(pca())
  })

output$comp <- renderDataTable({ round(pca.x(),3)}, options = list(pageLength = 6, scrollX = TRUE))

output$downloadData <- downloadHandler(
    filename = function() {
      "pca_components.csv"
    },
    content = function(file) {
      write.csv(pca.x(), file, row.names = FALSE)
    }
  )
# Plot of two components
output$pca.ind  <- renderPlot({ 

  if (input$frame == FALSE)
  {
  autoplot(pca(), data = data(), x = input$c1, y = input$c2, 
    scale = input$scale1, frame = FALSE,
    label = TRUE, label.size = 3, shape = FALSE)+ theme_minimal()
  }
  else
  {
  autoplot(pca(), data = data(), x = input$c1, y = input$c2, 
    scale = input$scale1, frame = TRUE, frame.type = input$type, 
    label = TRUE, label.size = 3, shape = FALSE, colour=names(data())[1])+ theme_minimal()
  }
  })
# Plot of the loadings of two components

output$pca.bp   <- renderPlot({ 
  autoplot(pca(), data=X(), x = input$c1, y = input$c2, label = TRUE, label.size = 3, shape = FALSE, 
    loadings = TRUE, loadings.label = TRUE, loadings.label.size = 3)+ theme_minimal()
})

# Plot of the explained variance
output$pca.plot <- renderPlot({ screeplot(pca(), npcs= input$nc, type="lines", main="") })

#----------2. PLS ----------

source("pls_server.R", local=TRUE, encoding="UTF-8") 

#----------3. SPLS ----------

source("spls_server.R", local=TRUE, encoding="UTF-8") 


#---------------------------##

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)



