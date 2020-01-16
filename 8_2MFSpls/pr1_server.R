#****************************************************************************************************************************************************pcr-pred

newX = reactive({
  inFile = input$newfile
  if (is.null(inFile)){
    if (input$edata=="NKI") {x <- nki.test}
    else {x<- liver.test}
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
output$newX  = DT::renderDT({newX()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

pred.lp = eventReactive(input$B.pcr,
{ as.data.frame(predict(pcr(), newdata = as.matrix(newX())[,input$x], type="response")[,,1:pcr()$ncomp])
})

pred.comp = eventReactive(input$B.pcr,
{as.data.frame(predict(pcr(), newdata = as.matrix(newX())[,input$x], type="scores"))
})



output$pred.lp = DT::renderDT({
pred.lp()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

output$pred.comp = DT::renderDT({
pred.comp()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))


