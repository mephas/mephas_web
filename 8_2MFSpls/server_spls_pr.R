#****************************************************************************************************************************************************spls-pred

newX.spls = reactive({
  inFile = input$newfile.spls
  if (is.null(inFile)){
    x <- nki2.test
    #if (input$edata=="NKI") {x <- nki2.test}
    #else {x<- liver.test}
    if(input$transform) {x <- t(nki2.train)}

    }
  else{
if(!input$newcol.spls){
    csv <- read.csv(inFile$datapath, header = input$newheader.spls, sep = input$newsep.spls, quote=input$newquote.spls)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$newheader.spls, sep = input$newsep.spls, quote=input$newquote.spls, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate(need(match(input$x.s, colnames(csv)), "New data do not cover all the independent variables"))

  x <- as.data.frame(csv)
}
   
  if(input$scale) {x <- scale(x)}

return(as.data.frame(x))
})


output$newX.spls  = DT::renderDT({newX.spls()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

pred.lp.spls = eventReactive(input$B.spls,
{x <- as.data.frame(predict(spls(), newdata = as.matrix(newX.spls())[,input$x.s], type="fit"))
colnames(x) <- input$y.s
return(x)
})

output$pred.lp.spls = DT::renderDT({
pred.lp.spls()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))




