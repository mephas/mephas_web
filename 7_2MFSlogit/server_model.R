#****************************************************************************************************************************************************model

type.bi <- reactive({
  df <- DF3()
  names <- apply(df,2,function(x) { length(levels(as.factor(x)))==2})
  x <- colnames(DF3())[names]
  return(x)
  })
## 
output$y = renderUI({
selectInput(
'y',
tags$b('1. Choose one dependent variable (Y), binary type'),
selected = type.bi()[1],
choices = type.bi())
})

DF4 <- reactive({
  df <-DF3()[ ,-which(names(DF3()) %in% c(input$y))]
return(df)
  })

#output$x = renderUI({
#selectInput(
#'x',
#tags$b('2. Add / Remove the independent variables (X)'),
#selected = names(DF4()),
#choices = names(DF4()),
#multiple = TRUE
#)
#})

output$x = renderUI({
shinyWidgets::pickerInput(
'x',
tags$b('2. Add / Remove independent variables (X)'),
selected = names(DF4()),
choices = names(DF4()),
multiple = TRUE,
options = pickerOptions(
      actionsBox=TRUE)
)
})

type.fac4 <- reactive({
colnames(DF4()[unlist(lapply(DF4(), is.factor))])
})

output$conf = renderUI({
shinyWidgets::pickerInput(
'conf',
tags$b('3 (Optional). Add interaction term between 2 categorical variables'),
choices = type.fac4(),
multiple = TRUE,
options = pickerOptions(
      maxOptions=2,
      actionsBox=TRUE)
)
})

output$Xdata2 <- DT::renderDT(
head(DF3()),
options = list(scrollX = TRUE,dom = 't'))
### for summary
output$str <- renderPrint({str(DF3())})

##3. regression formula
formula = reactive({
validate(need(input$x, "Please choose some independent variable"))

f <- paste0(input$y,' ~ ',paste0(input$x, collapse = "+"), input$intercept)

if(length(input$conf)==2) {f <- paste0(f, paste0("+",input$conf, collapse = ":"))}

return(f)

})

output$formula = renderPrint({
validate(need(input$x, "Please choose some independent variable"))
cat(formula())
})

## 4. output results
### 4.2. model
fit = eventReactive(input$B1, {
validate(need(input$x, "Please choose some independent variable"))
glm(as.formula(formula()),family = binomial(link = "logit"), data = DF3())
})


#gfit = eventReactive(input$B1, {
#  glm(formula(), data = DF3())
#})
# 
output$fit = renderPrint({ 
stargazer::stargazer(
fit(),
#out="logistic.txt",
header=FALSE,
dep.var.caption="Logistic Regression",
dep.var.labels = paste0("Y = ",input$y),
type = "text",
style = "all",
align = TRUE,
ci = TRUE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE)
})

output$fit2 = renderPrint({
stargazer::stargazer(
fit(),
#out="logistic.exp.txt",
header=FALSE,
dep.var.caption="Logistic Regression in Odds Ratio",
dep.var.labels = paste("Y = ",input$y),
type = "text",
style = "all2",
apply.coef = exp,
apply.ci = NULL,
align = TRUE,
ci = FALSE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE
)
})

#sp = reactive({step(fit())})
output$step = renderPrint({step(fit())})

# 
# # residual plot
 output$p.lm = plotly::renderPlotly({

  yhat <- predict(fit())
  y <- DF3()[,input$y]
  p<-plot_roc(yhat, y)
  #p <- ROCR::prediction(predict(fit()), DF3()[,input$y])
  #ps <- ROCR::performance(p, "tpr", "fpr")
  #pf <- ROCR::performance(p, "auc")

  #df <- data.frame(tpr=unlist(ps@y.values), 
  #  fpr=unlist(ps@x.values))

#p<- ggplot(df, aes(fpr,tpr)) + 
#  geom_step() +
#  coord_cartesian(xlim=c(0,1), ylim=c(0,1)) +
#  theme_minimal()+ ggtitle("") +
#  xlab("False positive rate (1-specificity)")+
#  ylab("True positive rate (sensitivity)")+
#  annotate("text", x = .75, y = .25, label = paste("AUC =",pf@y.values))
  plotly::ggplotly(p)
	})
# 
 fit.lm <- reactive({
 res <- data.frame(
  Y=DF3()[,input$y],
  nY=fit()$y,
 Fittings = (fit()[["linear.predictors"]]),
 Residuals = (fit()[["fitted.values"]])
 )
 colnames(res) <- c("Dependent Variable = Y", "Numeric Y", "Linear Predictors = bX", "Predicted Y = 1/(1+exp(-bX))")
 return(res)
 	})
# 
 output$fitdt0 = DT::renderDT(fit.lm(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))
# 

sst <- reactive({
pred <- ROCR::prediction(fit()[["fitted.values"]], DF3()[,input$y])
perf <- ROCR::performance(pred,"sens","spec")
perf2 <- data.frame(
  sen=unlist(perf@y.values), 
  spec=unlist(perf@x.values), 
  spec2=1-unlist(perf@x.values), 
  cut=unlist(perf@alpha.values))
colnames(perf2) <- c("Sensitivity", "Specificity", "1-Specificity","Cut-off Point")
return(perf2)
  })

 output$sst = DT::renderDT(sst(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

