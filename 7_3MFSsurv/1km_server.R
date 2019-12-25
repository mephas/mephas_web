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

DF4 <- reactive({
  df <-dplyr::select(DF3(), subset=c(-input$c))
return(df)
  })
type.fac4 <- reactive({
DF3() %>% select_if(is.factor) %>% colnames()
})

output$g = renderUI({
selectInput(
'g',
tags$b('Choose group variable'),
selected = type.fac4()[2],
choices = type.fac4())
})


output$Xdata2 <- DT::renderDataTable(
head(DF3()), options = list(scrollX = TRUE))
### for summary
output$str <- renderPrint({str(DF3())})



## 4. output results
### 4.2. model


kmfit = eventReactive(input$B1, {
  y <- paste0(surv(), "~", input$g)
  fit <- survfit(as.formula(y), data = DF3())
  return(fit)
})

# 
# # residual plot
 output$km.p= renderPlot({

autoplot(kmfit(), conf.int = FALSE)+ theme_minimal() + ggtitle("") +
annotate("text", x = .75, y = .25, label = paste("P value ="))
	})
# 

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