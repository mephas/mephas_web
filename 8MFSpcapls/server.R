if (!require(shiny)) {install.packages("shiny")}; library(shiny)
#if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(ggfortify)) {install.packages("ggfortify")}; library(ggfortify)
if (!require(pls)) {install.packages("pls")}; library(pls)
if (!requireNamespace("BiocManager", quietly = TRUE)) {install.packages("BiocManager")}
if (!require(mixOmics)) {BiocManager::install("mixOmics", version = "3.8")}; library(mixOmics)

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

output$comp <- renderDataTable({ round(pca.x(),3)}, options = list(pageLength = 5, scrollX = TRUE))

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

pls <- reactive({
  Y <- as.matrix(Y())
  X <- as.matrix(X())
  pls = mvr(Y~X, ncomp = input$nc.pls, scale = input$scale2, 
    method=input$mtd.pls, validation=input$val)
  pls})

output$pls.sum  <- renderPrint({
  summary(pls())
  })

pls.x <- reactive({ 
  xs <- as.matrix.data.frame(pls()$scores)
  dimnames(xs) <- dimnames(pls()$scores) 
  xs
  })
pls.y <- reactive({ 
  ys <- as.matrix.data.frame(pls()$Yscores) 
  dimnames(ys) <- dimnames(pls()$Yscores) 
  ys
  })

pls.xload <- reactive({ 
  xl <- as.matrix.data.frame(pls()$loadings)
  dimnames(xl) <- dimnames(pls()$loadings) 
  xl
  })
pls.yload <- reactive({ 
  yl <- as.matrix.data.frame(pls()$Yloadings)
  dimnames(yl) <- dimnames(pls()$Yloadings) 
  yl
  })

pls.coef <- reactive({ as.data.frame(pls()$coefficients) })
pls.proj <- reactive({ as.data.frame(pls()$projection) })

pls.fit <- reactive({ as.data.frame(pls()$fitted.values) })
pls.res <- reactive({ as.data.frame(pls()$residuals) })

#table

output$comp.x <- renderDataTable({ round(pls.x(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$comp.y <- renderDataTable({ round(pls.y(),3)}, options = list(pageLength = 5, scrollX = TRUE))

output$load.x <- renderDataTable({ round(pls.xload(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$load.y <- renderDataTable({ round(pls.yload(),3)}, options = list(pageLength = 5, scrollX = TRUE))

output$coef <- renderDataTable({ round(pls.coef(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$proj <- renderDataTable({ round(pls.proj(),3)}, options = list(pageLength = 5, scrollX = TRUE))

output$fit.pls <- renderDataTable({ round(pls.fit(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$res.pls <- renderDataTable({ round(pls.res(),3)}, options = list(pageLength = 5, scrollX = TRUE))



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

output$downloadData.pls.xload <- downloadHandler(
    filename = function() {
      "pls_loadings_x.csv"
    },
    content = function(file) {
      write.csv(pls.xload(), file, row.names = FALSE)
    }
  )
output$downloadData.pls.yload <- downloadHandler(
    filename = function() {
      "pls_loadings_y.csv"
    },
    content = function(file) {
      write.csv(pls.yload(), file, row.names = FALSE)
    }
  )

output$downloadData.pls.coef <- downloadHandler(
    filename = function() {
      "pls_coefficient.csv"
    },
    content = function(file) {
      write.csv(pls.coef(), file, row.names = FALSE)
    }
  )
output$downloadData.pls.proj <- downloadHandler(
    filename = function() {
      "pls_project.csv"
    },
    content = function(file) {
      write.csv(pls.proj(), file, row.names = FALSE)
    }
  )

output$downloadData.pls.fit <- downloadHandler(
    filename = function() {
      "pls_fit_values.csv"
    },
    content = function(file) {
      write.csv(pls.fit(), file, row.names = FALSE)
    }
  )

output$downloadData.pls.res <- downloadHandler(
    filename = function() {
      "pls_residuals.csv"
    },
    content = function(file) {
      write.csv(pls.res(), file, row.names = FALSE)
    }
  )


output$pls.pbiplot  <- renderPlot({ biplot(pls(), comps = c(input$c1.pls, input$c2.pls), which = input$which, var.axes = TRUE)})
output$pls.pscore  <- renderPlot({ scoreplot(pls(),comps=c(input$c1.pls, input$c2.pls)) })

output$pls.pload <- renderPlot({ loadingplot(pls(), comps=c(input$c1.pls: input$c2.pls)) })
output$pls.pcoef <- renderPlot({ plot(pls(), "coefficients", comps=c(input$c1.pls: input$c2.pls) ) })

output$pls.pred <- renderPlot({ plot(pls(), "prediction", ncomp= input$snum)})
output$pls.pval <- renderPlot({ plot(pls(), "validation") })

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



