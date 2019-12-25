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
tags$b('1. Choose a dependent variable / outcome / response (Y)'),
selected = type.num3()[1],
choices = type.num3()
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

output$formula = renderPrint({formula()})

## 4. output results
### 4.2. model
fit = eventReactive(input$B1, {
lm(formula(), data = DF3())
})


#gfit = eventReactive(input$B1, {
#  glm(formula(), data = DF3())
#})
# 
 output$fit = renderUI({
 
 HTML(
 stargazer::stargazer(
 fit(),
 #out="linear.txt",
 header=FALSE,
 dep.var.caption = "Linear Regression",
 dep.var.labels = paste0("Y = ",input$y),
 type = "html",
 style = "all",
 align = TRUE,
 ci = TRUE,
 single.row = TRUE,
 #no.space=TRUE,
 title=paste(Sys.time()),
 model.names =FALSE)
 )
 
 })

afit = eventReactive(input$B1, {
  res.table <- anova(fit())
  colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
  return(res.table)
  })

output$anova = renderTable({afit()}, rownames = TRUE)

sp = eventReactive(input$B1, {step(fit())})
output$step = renderPrint({sp()})

# 
# # residual plot
 output$p.lm = renderPlot({
	autoplot(fit(), which = as.numeric(input$num)) + theme_minimal()
	})
# 
 fit.lm <- reactive({
 res <- data.frame(Y=DF3()[,input$y],
 Fittings = round(fit()[["fitted.values"]], 4),
 Residuals = round(fit()[["residuals"]], 4)
 )
 colnames(res) <- c("Dependent Variable = Y", "Fittings = Predicted Y", "Residuals = Y - Predicted Y")
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