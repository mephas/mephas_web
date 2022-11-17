## Funnel Plot


ml.lnDOR <- reactive({

  metabin(TP, with(data.cc(), TP+FN), FP, with(data.cc(), TN+FP), 
    data = data.cc(), sm ="OR", 
    fixed = FALSE)

  })


output$ml.lnDOR.bias <- renderPrint({
  #ml.lnDOR()
  #print(input$method.bias)
  metabias(ml.lnDOR(), method.bias = input$method.bias)#"Begg")#)

  })



output$ml.lnDOR_funnel<-renderPlot({

# ml.lnDOR <- metabin(TP, with(data.cc(), TP+FN), FP, with(data.cc(), TN+FP), 
#     data = data.cc(), sm ="OR", 
#     fixed = FALSE)

tf.lndor <- trimfill(ml.lnDOR(), fixed = FALSE)

if(input$cont=="yes") contour <- c(0.9, 0.95, 0.99) else contour <- NULL

funnel(tf.lndor, xlab = "lnDOR", 
     #pch = c(shapes, rep(1, sum(tf.lndor[["trimfill"]]))),
     # bg = data.cc2$cutoff.grp+1,
     # col = c(data.cc$cutoff.grp+1, rep(1, sum(tf.lndor[["trimfill"]]))),
     cex = 1.5, studlab = FALSE, backtransf = FALSE,
     ref = exp(ml.lnDOR()$TE.random),
     level = 0.95,
     contour = contour)
})


## logit-Sens

output$logit.Sens_plot<-renderPlot({

ml.se <- metabin(TP, with(data.cc(), TP+FN), FN, with(data.cc(), TP+FN), 
    data = data.cc(), sm ="OR", fixed = FALSE)

tf.se <-trimfill(ml.se, fixed = FALSE)
tf.se[["TE"]] <- (tf.se[["TE"]]/2)
tf.se[["seTE"]] <- (tf.se[["seTE"]]/sqrt(2) )

if(input$cont=="yes") contour <- c(0.9, 0.95, 0.99) else contour <- NULL

funnel(tf.se, xlab = "logit(sensitivity)",
     #pch = c(shapes, rep(1, sum(tf.se[["trimfill"]]))),
     #bg = data.cc2$cutoff.grp+1,
     cex = 1.5, studlab = FALSE, backtransf = FALSE,
     ref = exp(ml.se$TE.random),
     level = 0.95,
     contour = contour
)

})


## logit-Spec

output$logit.Spec_plot<-renderPlot({

ml.sp <- metabin(TN, with(data.cc(), TN+FP), FP, with(data.cc(), TN+FP), 
  data = data.cc(), sm ="OR", fixed = FALSE)

tf.sp<- trimfill(ml.sp, fixed = FALSE)
tf.sp[["TE"]] <- tf.sp[["TE"]]/2
tf.sp[["seTE"]] <- tf.sp[["seTE"]]/sqrt(2)

if(input$cont=="yes") contour <- c(0.9, 0.95, 0.99) else contour <- NULL


funnel(tf.sp, xlab = "logit(specificity)", fixed = FALSE,
     #pch = c(shapes, rep(1, sum(tf.sp[["trimfill"]]))),
     #bg = data.cc2$cutoff.grp+1,
     cex = 1.5, studlab = FALSE, backtransf = FALSE,
     ref = exp(ml.sp$TE.random),
     level = 0.95,
     contour = contour
)


})
