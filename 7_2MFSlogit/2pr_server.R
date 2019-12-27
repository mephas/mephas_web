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
  colnames(res) <- c("Linear Predictors", "Predictors")
  return(res)
})

pred.lm <- reactive({
	cbind.data.frame(round(pred(), 4), newX())
	})

output$pred = DT::renderDataTable(pred.lm(),
 class="row-border", 
  extensions = c('Buttons'), 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
        scrollX = TRUE,
    scrollY = 290,
    scroller = TRUE))

 output$p.s = plotly::renderPlotly({
  p <- ROCR::prediction(pred.lm()[,2], pred.lm()[,input$y])
  ps <- ROCR::performance(p, "tpr", "fpr")
  pf <- ROCR::performance(p, "auc")
  
  df <- data.frame(tpr=unlist(ps@y.values), 
    fpr=unlist(ps@x.values))

p<-ggplot(df, aes(fpr,tpr)) + 
  geom_step() +
  coord_cartesian(xlim=c(0,1), ylim=c(0,1)) +
  theme_minimal()+ ggtitle("ROC plot") +
  xlab("False positive rate (1-specificity)")+
  ylab("True positive rate (sensitivity)")
  annotate("text", x = .75, y = .25, label = paste("AUC =",pf@y.values))
plotly::ggplotly(p)
  })

sst.s <- reactive({
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

 output$sst.s = DT::renderDataTable(round(sst.s(),6),
   class="row-border", 
  extensions = c('Buttons'), 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
        scrollX = TRUE,
    scrollY = 290,
    scroller = TRUE))


# sx <- reactive({input$x})
# 
# output$sx = renderUI({
# selectInput(
# 'sx',
# tags$b('Choose one independent variables / factors / predictors (X)'),
# selected = sx()[1],
# choices = sx()
# )
# })
# 
# pred.s = eventReactive(input$B2,
# {
# pfit1 = predict(fit(), newdata = select(newX(), subset=c(input$sx)), interval = "prediction")
# pfit2 = predict(fit(), newdata = select(newX(), subset=c(input$sx)), interval = "confidence")
# mat <- cbind(pfit1, pfit2[,-1])
# return(mat)
# 
# })
# 
# output$p.s = renderPlot({
# 	graphics::matplot(
# 		pred.s(), ty = c(1,2,2,3,3), type = "l", ylab = "predicted y")
# 	})
