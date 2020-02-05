#****************************************************************************************************************************************************plsr

#output$x.r = renderUI({
#selectInput(
#'x.r',
#tags$b('1. Add / Remove independent variable matrix (X)'),
#selected = type.num3()[-c(1:3)],
#choices = type.num3(),
#multiple = TRUE
#)
#})

output$y.r = renderUI({
shinyWidgets::pickerInput(
'y.r',
tags$b('1. Choose one or more dependent variables (Y)'),
selected = type.num3()[1:3],
choices = type.num3(),
multiple = TRUE,
options = pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})

type.num4.r <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$y.r))]
  df <- colnames(df[unlist(lapply(df, is.numeric))])
return(df)
  })

output$x.r = renderUI({
shinyWidgets::pickerInput(
'x.r',
tags$b('2. Add / Remove independent variables (X)'),
selected = type.num4.r(),
choices = type.num4.r(),
multiple = TRUE,
options = pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})
#output$y.r = renderUI({
#selectInput(
#'y.r',
#tags$b('2. Choose one or more dependent variables (Y)'),
#selected = names(DF4.r())[1],
#choices = names(DF4.r()),
#multiple = TRUE
#)
#})

output$pls.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))

#output$nc.r <- renderText({input$nc.r})
# model
pls <- eventReactive(input$pls1,{

  Y <- as.matrix(X()[,input$y.r])
  X <- as.matrix(X()[,input$x.r])

  validate(need(input$y.r, "Please choose dependent variable"))
  validate(need(min(ncol(X), nrow(X))>input$nc.r, "Please choose enough independent variables"))
  validate(need(input$nc.r>=1, "Please input correct number of components"))
  mvr(Y~X, ncomp=input$nc.r, validation=input$val.r, model=FALSE, method = input$method.r,scale = FALSE, center = FALSE)
  })

output$pls  <- renderPrint({
  summary(pls())
  })

output$pls_r  <- renderPrint({
  R2(pls(),estimate = "all")
  })

output$pls_msep  <- renderPrint({
  MSEP(pls(),estimate = "all")
  })

output$pls_rmsep  <- renderPrint({
  RMSEP(pls(),estimate = "all")
  })

score.r <- reactive({
  s <- as.data.frame(predict(pls(), type="scores"))
  rownames(s) <- rownames(X())
  return(s)  })

load.r <- reactive({
  as.data.frame(pls()$loadings[,1:pls()$ncomp])
  })

output$pls.s <- DT::renderDT({score.r()}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.l <- DT::renderDT({load.r()}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.pres <- DT::renderDT({
  as.data.frame(pls()$fitted.values[,,pls()$ncomp])
  }, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.coef <- DT::renderDT({as.data.frame(pls()$coefficients[,,pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.resi <- DT::renderDT({as.data.frame(pls()$residuals[,,pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



output$pls.s.plot  <- plotly::renderPlotly({ 
validate(need(input$nc.r>=2, "The number of components must be >= 2"))
score <- score.r()
p<-plot_score(score, input$c1.r, input$c2.r)
plotly::ggplotly(p)

  })

output$pls.l.plot  <- plotly::renderPlotly({ 
load <- load.r()
p<-plot_load(loads=load, a=pls()$ncomp)
plotly::ggplotly(p)

  })

output$pls.bp   <- plotly::renderPlotly({ 
  validate(need(input$nc.r>=2, "The number of components must be >= 2"))
  score <- score.r()
load <- load.r()
p<-plot_biplot(score, load, input$c11.r, input$c22.r)
plotly::ggplotly(p)
})


output$pls.tdplot <- plotly::renderPlotly({ 
validate(need(input$nc.r>=3, "The number of components must be >= 3"))
score <- score.r()
load <- load.r()

plot_3D(scores=score, loads=load, nx=input$td1.r,ny=input$td2.r,nz=input$td3.r, scale=input$lines.r)

})

output$pls_tdtrace <- renderPrint({
  x <- rownames(as.data.frame(pls()$loadings[,1:pls()$ncomp]))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
