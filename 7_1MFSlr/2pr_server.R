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
    x<-data()
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
{predict(fit(), newdata = newX())
})

pred.lm <- reactive({
	cbind.data.frame(newX(), Predict=round(pred(), 4))
	})

output$pred = DT::renderDataTable({
pred.lm()
},
options = list(scrollX = TRUE))

output$download12 <- downloadHandler(
    filename = function() {
      "lm.pred.csv"
    },
    content = function(file) {
      write.csv(pred.lm(), file, row.names = TRUE)
    }
  )



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
