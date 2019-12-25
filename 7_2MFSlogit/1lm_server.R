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

## 2. choose variable to put in the model/ and summary
output$y = renderUI({
selectInput(
'y',
tags$b('1. Choose a dependent variable / outcome / response (Y), binary'),
selected = names(DF3())[1],
choices = names(DF3())
)
})

DF4 <- reactive({
  df <-dplyr::select(DF3(), subset=c(-input$y))
return(df)
  })

output$x = renderUI({
selectInput(
'x',
tags$b('2. Choose independent variables / factors / predictors (X)'),
selected = names(DF4())[1],
choices = names(DF4()),
multiple = TRUE
)
})

output$Xdata2 <- DT::renderDataTable(
head(DF3()), options = list(scrollX = TRUE))
### for summary
output$str <- renderPrint({str(DF3())})

##3. regression formula
formula = reactive({
as.formula(paste0(input$y,' ~ ',paste0(input$x, collapse = "+"), 
	input$conf, 
  input$intercept)
)

})

output$formula = renderPrint({
validate(need(length(levels(as.factor(DF3()[, input$y])))==2, "Please choose a binary variable as Y")) 
formula()})

## 4. output results
### 4.2. model
fit = eventReactive(input$B1, {
glm(formula(),family = binomial(link = "logit"), data = DF3())
          })


#gfit = eventReactive(input$B1, {
#  glm(formula(), data = DF3())
#})
# 
output$fit = renderUI({ 
HTML(
stargazer::stargazer(
fit(),
#out="logistic.txt",
header=FALSE,
dep.var.caption="Logistic Regression",
dep.var.labels = paste0("Y = ",input$y),
type = "html",
style = "all",
align = TRUE,
ci = TRUE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE
)
)
})

output$fit2 = renderUI({
HTML(
stargazer::stargazer(
fit(),
#out="logistic.exp.txt",
header=FALSE,
dep.var.caption="Logistic Regression in Odds Ratio",
dep.var.labels = paste("Y = ",input$y),
type = "html",
style = "all",
apply.coef = exp,
apply.ci = exp,
align = TRUE,
ci = TRUE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE
)
)
})

#afit = eventReactive(input$B1, {
#  res.table <- anova(fit())
#  colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
#  return(res.table)
#  })

#output$anova = renderTable({afit()}, rownames = TRUE)

sp = eventReactive(input$B1, {step(fit())})
output$step = renderPrint({sp()})

# 
# # residual plot
 output$p.lm = renderPlot({

  p <- ROCR::prediction(predict(fit()), DF3()[,input$y])
  ps <- ROCR::performance(p, "tpr", "fpr")
  pf <- ROCR::performance(p, "auc")

autoplot(ps)+ theme_minimal()+theme(legend.position="none") + ggtitle("") +
annotate("text", x = .75, y = .25, label = paste("AUC =",pf@y.values))

	})
# 
 fit.lm <- reactive({
 res <- data.frame(Y=DF3()[,input$y],
 Fittings = round(fit()[["linear.predictors"]], 4),
 Residuals = round(fit()[["fitted.values"]], 4)
 )
 colnames(res) <- c("Dependent Variable = Y", "Linear Predictors = bX", "Predicted Y = 1/(1+exp(-bX))")
 return(res)
 	})
# 
 output$fitdt0 = DT::renderDataTable({
 fit.lm()
 }, 
 options = list(scrollX = TRUE))
# 
 output$download11 <- downloadHandler(
     filename = function() {
       "lm.fitting.csv"
     },
     content = function(file) {
       write.csv(fit.lm(), file, row.names = TRUE)
     }
   )

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

 output$sst = DT::renderDataTable({ round(sst(),6) })

  output$download111 <- downloadHandler(
     filename = function() {
       "sens_spec.csv"
     },
     content = function(file) {
       write.csv(sst(), file, row.names = TRUE)
     }
   )
# 
# newX = reactive({
# inFile = input$newfile
# if (is.null(inFile))
# {
# df = DF3()[1:10, ] ##>  example data
# }
# else{
# df = read.csv(
# inFile$datapath,
# header = input$newheader,
# sep = input$newsep,
# quote = input$newquote
# )
# }
# return(df)
# })
 #prediction plot
# # prediction
# pred = eventReactive(input$B2,
# {
# fit = lm(formula(), data = DF3())
# pfit = predict(fit, newdata = newDF3(), interval = input$interval)
# })
# 
# pred.lm <- reactive({
# 	cbind(newDF3(), round(pred(), 4))
# 	})
# 
# output$pred = renderDataTable({
# pred.lm()
# }, 
# options = list(pageLength = 5, scrollX = TRUE))
# 
# output$download12 <- downloadHandler(
#     filename = function() {
#       "lm.pred.csv"
#     },
#     content = function(file) {
#       write.csv(pred.lm(), file, row.names = TRUE)
#     }
#   )
# 
# output$px = renderUI({
# selectInput(
# 'px',
# h5('Choose one independent Variable (X)'),
# selected = "NULL",
# choices = c("NULL", names(newDF3()))
# )
# })