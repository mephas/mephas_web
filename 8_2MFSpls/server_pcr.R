#****************************************************************************************************************************************************pcr

output$y = renderUI({
selectInput(
'y',
tags$b('1. Choose one dependent variable (Y)'),
selected = type.num3()[1],
choices = type.num3(),
multiple = FALSE
)
})

type.num4 <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$y))]
  df <- colnames(X()[unlist(lapply(X(), is.numeric))])
return(df)
  })

#output$x = renderUI({
#selectInput(
#'x',
#tags$b('1. Add / Remove independent variables (X)'),
#selected = type.num3()[-c(1:3)],
#choices = type.num3(),
#multiple = TRUE
#)
#})

output$x = renderUI({
shinyWidgets::pickerInput(
'x',
tags$b('2. Add / Remove independent variables (X)'),
selected = type.num4(),
choices = type.num4(),
multiple = TRUE,
options = pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})


output$pcr.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))


pcr <- eventReactive(input$pcr1,{

  Y <- as.matrix(X()[,input$y])
  X <- as.matrix(X()[,input$x])

  validate(need(min(ncol(X), nrow(X))>input$nc, "Please input enough independent variables"))
  validate(need(input$nc>=1, "Please input correct number of components"))
  mvr(Y~X, ncomp=input$nc, validation=input$val, model=FALSE, method = "svdpc",scale = TRUE, center = TRUE)
  })


output$pcr  <- renderPrint({
  summary(pcr())
  })

output$pcr_r  <- renderPrint({
  R2(pcr(),estimate = "all")
  })

output$pcr_msep  <- renderPrint({
  MSEP(pcr(),estimate = "all")
  })

output$pcr_rmsep  <- renderPrint({
  RMSEP(pcr(),estimate = "all")
  })

score <- eventReactive(input$pcr1,{
  as.data.frame(pcr()$scores[,1:pcr()$ncomp])
  })

load <- eventReactive(input$pcr1,{
  as.data.frame(pcr()$loadings[,1:pcr()$ncomp])
  })

output$pcr.s <- DT::renderDT({score()}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.l <- DT::renderDT({load()}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.pres <- DT::renderDT({as.data.frame(pcr()$fitted.values[,,1:pcr()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.coef <- DT::renderDT({as.data.frame(pcr()$coefficients)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.resi <- DT::renderDT({as.data.frame(pcr()$residuals[,,1:pcr()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$pcr.s.plot  <- plotly::renderPlotly({ 
validate(need(input$nc>=2, "The number of components must be >= 2"))
score <- score()
p<-plot_score(score, input$c1, input$c2)
plotly::ggplotly(p)
  })

output$pcr.l.plot  <- plotly::renderPlotly({ 
load <- load()
p<-plot_load(loads=load, a=input$nc)
plotly::ggplotly(p)

  })

output$pcr.bp   <- plotly::renderPlotly({ 
validate(need(input$nc>=2, "The number of components must be >= 2"))
score <- score()
load <- load()
p<-plot_biplot(score, load, input$c11, input$c22)
plotly::ggplotly(p)
})

output$tdplot <- plotly::renderPlotly({ 
validate(need(input$nc>=3, "The number of components must be >= 3"))

score <- score()
load <- load()

plot_3D(scores=score, loads=load, nx=input$td1,ny=input$td2,nz=input$td3, scale=input$lines)


})

output$tdtrace <- renderPrint({
  validate(need(input$nc>=3, "The number of components must be >= 3"))
  x <- rownames(load())
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
