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

fit.reitsma <- reactive({
  reitsma(data(), 
  correction.control = input$allsingle, 
  level = input$ci.level, 
  correction = 0.5, 
  method=input$res.method
  )
})

output$reitsma <- renderPrint({
 fit <- fit.reitsma()
 fit$call <- NULL
 summary(fit)
  })

output$reitsma.dt <- renderDT({
  fit.reitsma <- fit.reitsma()

  par <- c(
    fit.reitsma$coeff[1], -fit.reitsma$coeff[2], 
    sqrt(fit.reitsma$Psi[1,1]), sqrt(fit.reitsma$Psi[2,2]), 
    -fit.reitsma$Psi[1,2]/sqrt(fit.reitsma$Psi[1,1]*fit.reitsma$Psi[2,2]))
  
  par.df <- data.frame(
    plogis(fit.reitsma$coeff[1]), plogis(-fit.reitsma$coeff[2]),
    SAUC(par),
    fit.reitsma$coeff[1], -fit.reitsma$coeff[2], 
    sqrt(fit.reitsma$Psi[1,1]), sqrt(fit.reitsma$Psi[2,2]), 
    -fit.reitsma$Psi[1,2]/sqrt(fit.reitsma$Psi[1,1]*fit.reitsma$Psi[2,2])
    )
  colnames(par.df) <- c("Sens", "Spec", "SAUC",
    "logit-Sens", "logit-Spec", "tau1", "tau2", "rho")
  rownames(par.df) <- c("Estimates")
  round(par.df,4)

})


fit.glmm <- reactive({
  GLMMmodel(data())
})
output$glmm <- renderPrint({
  fit.glmm()
  })

output$glmm.dt <- renderDT({
  fit.glmm <- fit.glmm()

  par <- c(
    fit.glmm$coeff[1,1], fit.glmm$coeff[2,1], 
    sqrt(fit.glmm$vcov[1,1]), sqrt(fit.glmm$vcov[2,2]), 
    fit.glmm$vcov[1,2]/sqrt(fit.glmm$vcov[1,1]*fit.glmm$vcov[2,2]))
  
  par.df <- data.frame(
    plogis(fit.glmm$coeff[1,1]), plogis(fit.glmm$coeff[2,1]),
    SAUC(par),
    fit.glmm$coeff[1,1], fit.glmm$coeff[2,1], 
    sqrt(fit.glmm$vcov[1,1]), sqrt(fit.glmm$vcov[2,2]), 
    fit.glmm$vcov[1,2]/sqrt(fit.glmm$vcov[1,1]*fit.glmm$vcov[2,2])
    )
  colnames(par.df) <- c("Sens", "Spec", "SAUC",
    "logit-Sens", "logit-Spec", "tau1", "tau2", "rho")
  rownames(par.df) <- c("Estimates")
  round(par.df, 4)

})


output$plot_sroc<-renderPlot({
  
  plot(NULL, 
      xlim = c(0, 1), ylim=c(0,1), 
      lty = 1, 
      xlab=input$sroc.xlab, ylab = input$sroc.ylab) 
  
  if(input$studypp2) points(1-sp(), se(), pch = 16)

  # if(input$ROCellipse) ROCellipse(data.cc(), 
  #   lty = 2,  level = input$ci.level, correction =0.5, method=input$ci.method, 
  #   pch = 16, add = TRUE)
  
  
  # if(input$Crosshair) crosshair(data.cc(), 
  #   lty = 2, level = input$ci.level, correction =0.5, method=input$ci.method, 
  #   pch = 16,add = TRUE)

    if(input$reitmaSROC) {

  fit.reitsma <- fit.reitsma()
      # lines(sroc(fit))
  par <- c(fit.reitsma$coeff[1], -fit.reitsma$coeff[2], sqrt(fit.reitsma$Psi[1,1]), sqrt(fit.reitsma$Psi[2,2]), -fit.reitsma$Psi[1,2]/sqrt(fit.reitsma$Psi[1,1]*fit.reitsma$Psi[2,2]))
  SROC(par, addon=TRUE, add.spoint = input$res.pt, sp.pch = 1)

      if(input$res.ci) {
        cr <- ROCellipse(fit.reitsma)
        lines(cr$ROCellipse)
      }

      # if(input$res.pt) {
      #   cr <- ROCellipse(fit.reitsma)
      #   points(cr$fprsens)
      # }
    }

    if(input$glmmSROC){

      fit.glmm <- GLMMmodel(data())
      par <- c(fit.glmm$coeff[1,1], fit.glmm$coeff[2,1], sqrt(fit.glmm$vcov[1,1]), sqrt(fit.glmm$vcov[2,2]), fit.glmm$vcov[1,2]/sqrt(fit.glmm$vcov[1,1]*fit.glmm$vcov[2,2]))
      SROC(par, addon = TRUE, add.spoint = input$glmm.pt, sp.pch = 1)

      #   if(input$glmm.pt) {
      #   points(1-plogis(par[2]), plogis(par[1]))
      # }
    }

    if(input$mslSROC) mslSROC(data(), 
    lty = 2,add = TRUE, extrapolate = TRUE, correction = 0.5, correction.control = input$allsingle)

    if (input$rsSROC) rsSROC(data(), 
    lty= 3,add = TRUE, extrapolate = TRUE, correction = 0.5, correction.control = input$allsingle)



  
})
