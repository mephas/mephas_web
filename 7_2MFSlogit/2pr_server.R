#****************************************************************************************************************************************************pred

newX = reactive({
  inFile = input$newfile
  if (is.null(inFile)){
    x<-LGT.new
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
pred = eventReactive(input$B2,
{
  res <- data.frame(lp = predict(fit(), newdata = newX(), type="link"),
  predict= predict(fit(), newdata = newX(), type="response"))
  colnames(res) <- c("Linear Predictors", "Predicted Y")
  return(res)
})

pred.lm <- reactive({
	cbind.data.frame((pred()), newX())
	})

output$pred = DT::renderDT(pred.lm(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

 output$p.s = plotly::renderPlotly({
  validate(need((pred.lm()[, input$y]), "This evaluation plot will not show unless dependent variable Y is given in the new data"))

  yhat <- pred.lm()[,2]
  y <- pred.lm()[,input$y]
  p<-MFSroc(yhat, y)
  plotly::ggplotly(p)

  #p <- ROCR::prediction(pred.lm()[,2], pred.lm()[,input$y])
  #ps <- ROCR::performance(p, "tpr", "fpr")
  #pf <- ROCR::performance(p, "auc")
  
  #df <- data.frame(tpr=unlist(ps@y.values), 
  #  fpr=unlist(ps@x.values))

#ggplot(df, aes(fpr,tpr)) + 
#  geom_step() +
#  coord_cartesian(xlim=c(0,1), ylim=c(0,1)) +
#  theme_minimal()+ ggtitle("ROC plot") +
#  xlab("False positive rate (1-specificity)")+
#  ylab("True positive rate (sensitivity)")+
#  annotate("text", x = .75, y = .25, label = paste("AUC =",pf@y.values))

  })

sst.s <- reactive({
validate(need((pred.lm()[, input$y]), "This evaluation plot will not show unless dependent variable Y is given in the new data"))

pred <- ROCR::prediction(pred.lm()[,2], pred.lm()[,input$y])
perf <- ROCR::performance(pred,"sens","spec")
perf2 <- data.frame(
  sen=unlist(perf@y.values), 
  spec=unlist(perf@x.values), 
  spec2=1-unlist(perf@x.values), 
  cut=unlist(perf@alpha.values))
colnames(perf2) <- c("Sensitivity", "Specificity", "1-Specificity","Cut-off Point")
return(perf2)
  })

 output$sst.s = DT::renderDT((sst.s()),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

