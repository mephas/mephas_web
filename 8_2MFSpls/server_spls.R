#****************************************************************************************************************************************************spls

#output$x.s = renderUI({
#selectInput(
#'x.s',
#tags$b('1. Choose independent variable matrix (X)'),
#selected = type.num3()[-c(1:3)],
#choices = type.num3(),
#multiple = TRUE
#)
#})

output$y.s = renderUI({
shinyWidgets::pickerInput(
'y.s',
tags$b('1. Choose one or more dependent variables (Y)'),
selected = type.num3()[1:3],
choices = type.num3(),
multiple = TRUE,
options = pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})

type.num4.s <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$y.s))]
  df <- colnames(X()[unlist(lapply(X(), is.numeric))])
return(df)
  })

#output$y.s = renderUI({
#selectInput(
#'y.s',
#tags$b('2. Choose one or more dependent variable (Y)'),
#selected = names(DF4.s())[1],
#choices = names(DF4.s()),
#multiple = TRUE
#)
#})

output$x.s = renderUI({
shinyWidgets::pickerInput(
'x.s',
tags$b('2. Add / Remove independent variables (X)'),
selected = type.num4.s(),
choices = type.num4.s(),
multiple = TRUE,
options = pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})


output$spls.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))

output$spls_cv  <- renderPrint({
  Y <- as.matrix(X()[,input$y.s])
  X <- as.matrix(X()[,input$x.s])
  validate(need(input$y.s, "Please choose dependent variable"))

  validate(need(min(ncol(X), nrow(X))>input$cv.s, "Please choose enough independent variables"))
  validate(need(input$cv.s>=1, "Please input correct number of components"))
  validate(need(input$cv.eta>0 && input$nc.eta<1, "Please input correct parameters"))
  spls::cv.spls(X,Y, eta = seq(0.1,input$cv.eta,0.1), K = c(1:input$cv.s),
    select="pls2", fit = input$method.s, plot.it = FALSE)
  
  })

spls <- eventReactive(input$spls1,{

  Y <- as.matrix(X()[,input$y.s])
  X <- as.matrix(X()[,input$x.s])
  validate(need(min(ncol(X), nrow(X))>input$nc.s, "Please input enough independent variables"))
  validate(need(input$nc.s>=1, "Please input correct number of components"))
  validate(need(input$nc.eta>0 && input$nc.eta<1, "Please correct parameters"))
  spls::spls(X, Y, K=input$nc.s, eta=input$nc.eta, kappa=0.5, select="pls2", fit=input$method.s)
  })


output$spls  <- renderPrint({
  print(spls())
  })

output$spls.bp   <- renderPlot({ 
plot(spls(), yvar=input$spls.y)
})

score.s <- reactive({
  data.frame(as.matrix(X()[spls()$A])%*%as.matrix(spls()$projection))
  }) 
load.s <- reactive({
  as.data.frame(spls()$projection)
  })

output$spls.coef <- DT::renderDT({
  cletters <- rep(input$y.s, times=spls()$K)
  cindexes <- rep(1:spls()$K,   each=length(input$y.s))
  cnames   <- paste(cletters, cindexes, sep="")
  x<-as.data.frame(spls()$betamat)
  colnames(x) <- cnames#paste0(input$y.s, "at comp", 1:spls()$K)
  rownames(x) <- input$x.s
  return(x)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.s <- DT::renderDT({score.s()}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.l <- DT::renderDT({load.s()}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.pres <- DT::renderDT({
  x <- as.data.frame(predict(spls(), type="fit"))
  colnames(x) <- input$y.s
  return(x)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.sv <- DT::renderDT({as.data.frame(X()[spls()$A])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



output$spls.s.plot  <- plotly::renderPlotly({ 
  validate(need(input$nc.s>=2, "The number of components must be >=2"))

  score <- score.s()
  p<-plot_score(score, input$c1.s, input$c2.s)
  plotly::ggplotly(p)
  })

output$spls.l.plot  <- plotly::renderPlotly({ 
load <- load.s()
p <- plot_load(loads=load, a=input$nc.s)
plotly::ggplotly(p)
  })

output$spls.biplot<- plotly::renderPlotly({ 
validate(need(input$nc>=2, "The number of components must be >= 2"))
score <- score.s()
load <- load.s()
p<-plot_biplot(score, load, input$c11.s, input$c22.s)
plotly::ggplotly(p)
})

output$tdplot.s <- plotly::renderPlotly({ 
  validate(need(input$nc.s>=3, "The number of components must be >=3"))

score <- score.s()
load <- load.s()

plot_3D(scores=score, loads=load, nx=input$td1.s,ny=input$td2.s,nz=input$td3.s, scale=input$lines.s)


})

output$tdtrace.s <- renderPrint({
  x <- rownames(as.data.frame(spls()$projection))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
