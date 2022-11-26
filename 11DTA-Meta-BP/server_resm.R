## DTA meta

## reitsma's model
# reitsma <- reactive(

#   reitsma(data(), 
#   correction.control = input$allsingle, 
#   level = input$ci.level, correction = 0.5, 
#   method=input$ci.method,
#   alphasens = input$alpha, alphafpr = input$alpha 
#   )

#   )

output$reitsma <- renderPrint({
  fit <- reitsma(data(), 
  correction.control = input$allsingle, 
  level = input$ci.level, correction = 0.5, 
  method=input$res.method,
  alphasens = as.numeric(input$alpha), 
  alphafpr = as.numeric(input$alpha) 
  )

  fit$call <- NULL

  summary(fit)
  })


output$plot_sroc<-renderPlot({
  
  plot(NULL, 
      xlim = c(0, 1), ylim=c(0,1), 
      lty = 1, pch = 16,
      xlab=input$sroc.xlab, ylab = input$sroc.ylab) 
  
  if(input$studypp2) points(1-sp(), se(), pch = 16)

  # if(input$ROCellipse) ROCellipse(data.cc(), 
  #   lty = 2,  level = input$ci.level, correction =0.5, method=input$ci.method, 
  #   pch = 16, add = TRUE)
  
  
  # if(input$Crosshair) crosshair(data.cc(), 
  #   lty = 2, level = input$ci.level, correction =0.5, method=input$ci.method, 
  #   pch = 16,add = TRUE)

    if(input$reitmaSROC) {

  fit <- reitsma(data(), 
  correction.control = input$allsingle, 
  level = input$ci.level, correction = 0.5, 
  method=input$res.method,
  alphasens = as.numeric(input$alpha), 
  alphafpr = as.numeric(input$alpha) 
  )
      lines(sroc(fit))

      if(input$res.ci) {
        cr <- ROCellipse(fit)
        lines(cr$ROCellipse)
      }

      if(input$res.pt) {
        cr <- ROCellipse(fit)
        points(cr$fprsens)
      }
    }

    if(input$mslSROC) mslSROC(data(), 
    lty = 2,add = TRUE, extrapolate = TRUE, correction = 0.5, correction.control = input$allsingle)

    if (input$rsSROC) rsSROC(data(), 
    lty= 3,add = TRUE, extrapolate = TRUE, correction = 0.5, correction.control = input$allsingle)

  
})
