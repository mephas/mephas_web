#****************************************************************************************************************************************************pred

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
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

 output$p.s = plotly::renderPlotly({
  validate(need((pred.lm()[, input$y]), "This evaluation plot will not show unless dependent variable Y is given in the new data"))
  #min = min(c(pred.lm()[, input$y], pred.lm()[, 1]))
  #max = max(c(pred.lm()[, input$y], pred.lm()[, 1]))
  x <- pred.lm()
  vx <- input$y
  vy <- names(x)[1] 
  p<-plot_scat(x, vx, vy, input$y, "Predicted Y")
  plotly::ggplotly(p)
   })


