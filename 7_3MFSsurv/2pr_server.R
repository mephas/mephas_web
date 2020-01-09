##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >Linear regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------



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
  res <- cbind.data.frame(res, newX())
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



 output$p.s = renderPlot({
  ptime <- predict(aftfit(), newdata=pred()[input$line,], type='quantile', p=c(1:98/100), se=TRUE)
  matplot(cbind(ptime$fit, ptime$fit + 1.96*ptime$se.fit,
                           ptime$fit - 1.96*ptime$se.fit), 1-c(1:98/100),
        xlab="Time", ylab="Survival", type='l', lty=c(1,2,2), col=1)
  })



