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



newX2 = reactive({
  inFile = input$newfile2
  if (is.null(inFile)){
    x<-Surv.new
    }
  else{
if(!input$newcol2){
    csv <- read.csv(inFile$datapath, header = input$newheader2, sep = input$newsep2, quote=input$newquote2)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$newheader2, sep = input$newsep2, quote=input$newquote2, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})
#prediction plot
# prediction
pred2 = eventReactive(input$B2.1,
{
  res <- data.frame(
  lp = predict(coxfit(), newdata = newX2(), type="lp"),
  risk= predict(coxfit(), newdata = newX2(), type="risk"))
  colnames(res) <- c("Linear Predictors = bX", "Risk score = exp(bX)")
  res <- cbind.data.frame(res, newX2())
  return(res)
})

output$pred2 = DT::renderDT({
pred2()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

BStab <- reactive(
{
if (input$t=="NULL") {
Surv.rsp <- Surv(DF3()[,input$t1], DF3()[,input$t2], DF3()[,input$c])
Surv.rsp.new <- Surv(pred2()[,input$t1], pred2()[,input$t2], pred2()[,input$c])
}
else {
Surv.rsp <- Surv(DF3()[,input$t], DF3()[,input$c])
Surv.rsp.new <- Surv(pred2()[,input$t], pred2()[,input$c])  
}

lp <- predict(coxfit())
lpnew <- predict(coxfit(), newdata=pred2())

times <- seq(input$ss,input$ee, input$by)                  

BrierScore <- survAUC::predErr(Surv.rsp, Surv.rsp.new, lp, lpnew, times, 
                      type = "brier", int.type = "weighted")

df <- data.frame(Times=BrierScore$times, BrierScore=BrierScore$error, IBS=rep(BrierScore$ierror, length(times)))
colnames(df) <- c("Times", "BrierScore", "Integrated Brier Score")
return(df)
})

output$bstab = DT::renderDT({
BStab()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

output$bsplot = renderPlot({

ggplot(BStab(), aes(x=Times, y=BrierScore)) + geom_line() +ylim(0,1) + theme_minimal()

  })

#AUCtab <- eventReactive(input$B2.1,
AUCtab <- reactive(
{
if (input$t=="NULL") {
Surv.rsp <- Surv(DF3()[,input$t1], DF3()[,input$t2], DF3()[,input$c])
Surv.rsp.new <- Surv(pred2()[,input$t1], pred2()[,input$t2], pred2()[,input$c])
}
else {
Surv.rsp <- Surv(DF3()[,input$t], DF3()[,input$c])
Surv.rsp.new <- Surv(pred2()[,input$t], pred2()[,input$c])  
}

lp <- predict(coxfit())
lpnew <- predict(coxfit(), newdata=pred2())

times <- seq(input$ss1,input$ee1, input$by1)                  

if (input$auc=="a") {AUC <- survAUC::AUC.cd(Surv.rsp, Surv.rsp.new, lp, lpnew, times)}
if (input$auc=="b") {AUC <- survAUC::AUC.hc(Surv.rsp, Surv.rsp.new, lpnew, times)}
if (input$auc=="c") {AUC <- survAUC::AUC.sh(Surv.rsp, Surv.rsp.new, lp, lpnew, times)}
if (input$auc=="d") {AUC <- survAUC::AUC.uno(Surv.rsp, Surv.rsp.new, lpnew, times)}


df <- data.frame(Times=AUC$times, AUC=AUC$auc, IAUC=rep(AUC$iauc, length(times)))
colnames(df) <- c("Times", "AUC", "Integrated AUC")
return(df)
})

output$auctab = DT::renderDT({
AUCtab()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

output$aucplot = renderPlot({

ggplot(AUCtab(), aes(x=Times, y=AUC)) + geom_line() +ylim(0,1) + theme_minimal()
  })
