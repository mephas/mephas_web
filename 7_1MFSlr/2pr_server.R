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
    x<-LR.new
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
	cbind.data.frame("Predicted Y"=(pred()),newX())
	})

output$pred = DT::renderDT({
pred.lm()
},
class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$download12 <- downloadHandler(
#    filename = function() {
#      "lm.pred.csv"
#    },
#    content = function(file) {
#      write.csv(pred.lm(), file, row.names = TRUE)
#    }
#  )

 output$p.s = plotly::renderPlotly({
  validate(need((pred.lm()[, input$y]), "This figure will not show unless Y is given in the new data"))
  min = min(c(pred.lm()[, input$y], pred.lm()[, 1]))
  max = max(c(pred.lm()[, input$y], pred.lm()[, 1]))
   p <- ggplot(pred.lm(), aes(x = pred.lm()[, input$y], y = pred.lm()[, 1])) + geom_point(shape = 1) + 
     geom_smooth(method = "lm") + xlab(input$y) + ylab("Prediction") + xlim(min, max)+ ylim(min, max)+ theme_minimal()
plotly::ggplotly(p)
   })




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
