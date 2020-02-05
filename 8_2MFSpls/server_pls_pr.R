#****************************************************************************************************************************************************pls-pred

newX.pls = reactive({
  inFile = input$newfile.pls
  if (is.null(inFile)){
    x <- nki2.test
    #if (input$edata=="NKI") {x <- nki2.test}
    #else {x<- liver.test}
    if(input$transform) {x <- t(nki2.train)}

    }
  else{
if(!input$newcol.pls){
    csv <- read.csv(inFile$datapath, header = input$newheader.pls, sep = input$newsep.pls, quote=input$newquote.pls)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$newheader.pls, sep = input$newsep.pls, quote=input$newquote.pls, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate(need(match(input$x.r, colnames(csv)), "New data do not cover all the independent variables"))

  x <- as.data.frame(csv)
}
   
if(input$scale) {x <- scale(x)}

return(as.data.frame(x))
})
#prediction plot
# prediction
output$newX.pls  = DT::renderDT({newX.pls()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

pred.lp.pls = eventReactive(input$B.pls,
{
x <- as.data.frame(predict(pls(), comps=pls()$ncomp, newdata = as.matrix(newX.pls())[,input$x.r], type="response"))
colnames(x) <- input$y.r
return(x)
})

pred.comp.pls = eventReactive(input$B.pls,
{as.data.frame(predict(pls(), comps=1:pls()$ncomp, newdata = as.matrix(newX.pls())[,input$x.r], type="scores"))
})



output$pred.lp.pls = DT::renderDT({
pred.lp.pls()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

output$pred.comp.pls = DT::renderDT({
pred.comp.pls()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))


