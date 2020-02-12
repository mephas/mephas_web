#****************************************************************************************************************************************************aft-pred

newX = reactive({
  inFile = input$newfile
  if (is.null(inFile)){
    if (input$edata=="Diabetes") {x <- dia.test}
    else {x<- nki.test}
    }
  else{
if(!input$newcol){
    csv <- read.csv(inFile$datapath, header = input$newheader, sep = input$newsep, quote=input$newquote)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$newheader, sep = input$newsep, quote=input$newquote, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})
#prediction plot
# prediction
pred = eventReactive(input$B1.1,
{
  res <- data.frame(
  lp = predict(aftfit(), newdata = newX(), type="link"),
  predict= predict(aftfit(), newdata = newX(), type="response"))
  colnames(res) <- c("Linear Predictors", "Predictors")
  res <- cbind.data.frame(round(res,6), newX())
  return(res)
})

output$pred = DT::renderDT({
pred()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))


pred.n <- reactive({
  ptime <- predict(aftfit(), newdata=pred()[input$line,], type='quantile', p=c(1:98/100), se=TRUE)
  df <- data.frame(estimate =ptime$fit, 
                   up.band =ptime$fit + 2*ptime$se.fit,
                   low.band=ptime$fit - 2*ptime$se.fit,
                   ybreak=1-c(1:98/100))
  colnames(df)=c("Estimated Times", "95% CI up band", "95% CI lower band", "Survival Probability")
  return(rounf(df,6))
})

output$pred.n = DT::renderDT({
pred.n()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))
 output$p.s = plotly::renderPlotly({
  

 #matplot(cbind(ptime$fit, ptime$fit + 1.96*ptime$se.fit,
 #                          ptime$fit - 1.96*ptime$se.fit), 1-c(1:98/100),
 #       xlab="Time", ylab="Survival", type='l', lty=c(1,2,2), col=1)
  p<-plot_mat(pred.n(), "Survival Probability")+xlab("Estimated Times") +ylab("Survival Probability")
  plotly::ggplotly(p)
  })



