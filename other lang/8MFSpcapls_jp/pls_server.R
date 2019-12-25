##----------#----------#----------#----------
##
## 8MFSpcapls SERVER
##
##		>pls
##
## Language: JP
## 
## DT: 2019-01-15
##
##----------#----------#----------#----------

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


output$pls.pbiplot <- renderPlot({ biplot(pls(), comps = c(input$c1.pls, input$c2.pls), which = input$which, var.axes = TRUE)})
output$pls.pscore  <- renderPlot({ scoreplot(pls(),comps=c(input$c1.pls, input$c2.pls)) })

output$pls.pload <- renderPlot({ loadingplot(pls(), comps=c(input$c1.pls: input$c2.pls)) })
output$pls.pcoef <- renderPlot({ plot(pls(), "coefficients", comps=c(input$c1.pls: input$c2.pls) ) })

output$pls.pred <- renderPlot({ plot(pls(), "prediction", ncomp= input$snum)})
output$pls.pval <- renderPlot({ plot(pls(), "validation") })