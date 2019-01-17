if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(mixOmics)) {install.packages("mixOmics")}; library(mixOmics)

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

source("0data_server.R", local=TRUE) 

#----------1. PCA ----------
output$nc <- renderText({ input$nc })
# model
pca <- reactive({
  pca = mixOmics::pca(as.matrix(X()), ncomp = input$nc, scale = TRUE)
  pca})

pca.x <- reactive({ pca()$x })

output$fit  <- renderPrint({
  res <- rbind(pca()$explained_variance,pca()$cum.var)
  rownames(res) <- c("explained_variance", "cumulative_variance")
  res})

output$comp <- renderDataTable({ round(pca.x(),3)}, options = list(pageLength = 5, scrollX = TRUE))

output$downloadData <- downloadHandler(
    filename = function() {
      "pca_components.csv"
    },
    content = function(file) {
      write.csv(pca.x(), file, row.names = FALSE)
    }
  )

output$pca.ind  <- renderPlot({ plotIndiv(pca(), comp=c(input$c1, input$c2))})
output$pca.var  <- renderPlot({ plotVar(pca(),   comp=c(input$c1, input$c2))})
output$pca.bp   <- renderPlot({ biplot(pca())})
output$pca.plot <- renderPlot({ plot(pca())})

#----------2. PLS ----------

pls <- reactive({
  pls = mixOmics::pls(as.matrix(X()),as.matrix(Y()), ncomp = input$nc.pls, scale = TRUE)
  pls})

pls.x <- reactive({ pls()$variates$X })
pls.y <- reactive({ pls()$variates$Y })

output$comp.x <- renderDataTable({ round(pls.x(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$comp.y <- renderDataTable({ round(pls.x(),3)}, options = list(pageLength = 5, scrollX = TRUE))

output$downloadData.pls.x <- downloadHandler(
    filename = function() {
      "pls_components_x.csv"
    },
    content = function(file) {
      write.csv(pls.x(), file, row.names = FALSE)
    }
  )

output$downloadData.pls.y <- downloadHandler(
    filename = function() {
      "pls_components_y.csv"
    },
    content = function(file) {
      write.csv(pls.y(), file, row.names = FALSE)
    }
  )

output$pls.ind  <- renderPlot({ plotIndiv(pls(), comp=c(input$c1.pls, input$c2.pls)) })
output$pls.var  <- renderPlot({ plotVar(pls(),   comp=c(input$c1.pls, input$c2.pls)) })

#----------3. SPLS ----------

spls <- reactive({
  spls = mixOmics::spls(as.matrix(X()),as.matrix(Y()), ncomp = input$nc.spls, scale = TRUE,
    keepX=input$x.spls, keepY=input$y.spls)
  spls})

spls.x <- reactive({ spls()$variates$X })
spls.y <- reactive({ spls()$variates$Y })

output$comp.sx <- renderDataTable({ round(spls.x(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$comp.sy <- renderDataTable({ round(spls.x(),3)}, options = list(pageLength = 5, scrollX = TRUE))

output$downloadData.spls.x <- downloadHandler(
    filename = function() {
      "spls_components_x.csv"
    },
    content = function(file) {
      write.csv(spls.x(), file, row.names = FALSE)
    }
  )

output$downloadData.spls.y <- downloadHandler(
    filename = function() {
      "spls_components_y.csv"
    },
    content = function(file) {
      write.csv(spls.y(), file, row.names = FALSE)
    }
  )

output$spls.ind  <- renderPlot({ plotIndiv(spls(), comp=c(input$c1.spls, input$c2.spls)) })
output$spls.var  <- renderPlot({ plotVar(spls(),   comp=c(input$c1.spls, input$c2.spls)) })
output$spls.load <- renderPlot({ plotLoadings(spls()) })

#---------------------------##

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


})



