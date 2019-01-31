##----------#----------#----------#----------
##
## 8MFSpcapls SERVER
##
##    >pls
##
## Language: EN
## 
## DT: 2019-01-15
##
##----------#----------#----------#----------

#cv.spls <- reactive({
#  spls = spls::cv.spls(as.matrix(X()),as.matrix(Y()), eta = seq(0.1,0.9,0.1), K = c(input$cv1:input$cv2),
#    select=input$s.select, fit = input$s.fit, scale.x = input$sc.x, scale.y = input$sc.y, plot.it = FALSE)
#  return(list(Optimal.eta =spls$eta.opt, Optimal.component.number = spls$K.opt))
#  })

output$spls.cv  <- renderPrint({
  spls = spls::cv.spls(as.matrix(X()),as.matrix(Y()), eta = seq(0.1,0.9,0.1), K = c(input$cv1:input$cv2),
    select=input$s.select, fit = input$s.fit, scale.x = input$sc.x, scale.y = input$sc.y, plot.it = FALSE)
  return(list(Optimal.eta =spls$eta.opt, Optimal.component.number = spls$K.opt))
  })

output$heat.cv <- renderPlot({ 
  spls::cv.spls(as.matrix(X()),as.matrix(Y()), eta = seq(0.1,0.9,0.1), K = c(input$cv1:input$cv2),
    select=input$s.select, fit = input$s.fit, scale.x = input$sc.x, scale.y = input$sc.y, plot.it = TRUE })


spls <- reactive({
  spls::spls(as.matrix(X()),as.matrix(Y()), K=input$nc.spls, eta=input$eta, kappa=input$kappa, 
    select=input$s.select, fit=input$s.fit, scale.x=input$sc.x, scale.y=input$sc.y, 
    eps=1e-4, maxstep=100, trace=input$trace)
  })

spls.sv <- reactive({ X()[spls()$A] })
spls.comp <- reactive({ data.frame(as.matrix(X()[spls()$A])%*%as.matrix(spls()$projection)) })
spls.cf <- reactive({ coef(spls()) })
spls.pj <- reactive({ spls()$projection})
spls.pd <- reactive({ predict(spls(), type="fit")})

output$s.sv <- renderDataTable({ spls.sv()}, options = list(pageLength = 5, scrollX = TRUE))
output$s.comp <- renderDataTable({ round(spls.comp(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$s.cf <- renderDataTable({ round(spls.cf(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$s.pj <- renderDataTable({ round(spls.pj(),3)}, options = list(pageLength = 5, scrollX = TRUE))
output$s.pd <- renderDataTable({ round(spls.pd(),3)}, options = list(pageLength = 5, scrollX = TRUE))


output$downloadData.s.sv <- downloadHandler(
    filename = function() {
      "spls_select_var.csv"
    },
    content = function(file) {
      write.csv(spls.sv(), file, row.names = FALSE)
    }
  )

output$downloadData.s.comp <- downloadHandler(
    filename = function() {
      "spls_components_x.csv"
    },
    content = function(file) {
      write.csv(spls.comp(), file, row.names = FALSE)
    }
  )

output$downloadData.s.cf <- downloadHandler(
    filename = function() {
      "spls_coefficient.csv"
    },
    content = function(file) {
      write.csv(spls.cf(), file, row.names = FALSE)
    }
  )

output$downloadData.s.pj <- downloadHandler(
    filename = function() {
      "spls_project.csv"
    },
    content = function(file) {
      write.csv(spls.pj(), file, row.names = FALSE)
    }
  )

output$downloadData.s.pd <- downloadHandler(
    filename = function() {
      "spls_predict.csv"
    },
    content = function(file) {
      write.csv(spls.pd(), file, row.names = FALSE)
    }
  )

#output$spls.ind  <- renderPlot({ plotIndiv(spls(), comp=c(input$c1.spls, input$c2.spls)) })
#output$spls.var  <- renderPlot({ plotVar(spls(),   comp=c(input$c1.spls, input$c2.spls)) })
#output$spls.load <- renderPlot({ plotLoadings(spls()) })