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
  df <- colnames(df[unlist(lapply(df, is.numeric))])
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
options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})


output$pcr.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))


pcr <- eventReactive(input$pcr1,{

DF<- data.frame(
  Y = I(as.matrix(X()[,input$y])),
  X = I(as.matrix(X()[,input$x]))
  )
mvr(Y~X, ncomp=input$nc, validation=input$val, model=FALSE, method = "svdpc",scale = input$scale, center = input$scale.r, data=DF)
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
  s <- as.data.frame(predict(pcr(), type="scores"))
  rownames(s) <- rownames(X())
  return(s)
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

output$pcr.pres <- DT::renderDT({
  y <- data.frame(
    Predict.Y=predict(pcr(), comps=pcr()$ncomp, type="response"),
    Residuals=pcr()$residuals[,,pcr()$ncomp])
  rownames(y) <- rownames(X())
  return(y)
  }, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.coef <- DT::renderDT({
  data.frame(Coefficient = pcr()$coefficients[,, pcr()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

##########----------##########----------##########---------- score plot
type.fac4 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

output$g = renderUI({
selectInput(
'g',
tags$b('1. Choose one group variable, categorical to add group circle'),
selected = "None",
choices = c("None",type.fac4())
)
})

output$type = renderUI({
radioButtons("type", "The type of ellipse",
 choices = c(
  "None" = "",
  "T: assumes a multivariate t-distribution" = 't',
 "Normal: assumes a multivariate normal-distribution" = "norm",
 "Euclid: the euclidean distance from the center" = "euclid"),
 selected = 'euclid',
 width="500px")
})

output$pcr.s.plot  <- plotly::renderPlotly({ 
#output$pca.ind  <- renderPlot({ 
df <- score()
if (input$g == "None") {
#df$group <- rep(1, nrow(df))
p<-plot_score(df, input$c1, input$c2)

}
else {
  group <- X()[,input$g]
  if (input$type==""){
    
    p<-plot_scoreg(df, input$c1, input$c2, group)
  }
  else{
    p<-plot_scorec(df, input$c1, input$c2, group, input$type)
}

}
plotly::ggplotly(p)
})

##########----------##########----------##########---------- load plot

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
validate(need(input$nc>=3, "The number of components must be >= 2"))

score <- score()
load <- load()

plot_3D(score, load, input$td1,input$td2,input$td3,input$lines)


})

output$tdtrace <- renderPrint({
  x <- rownames(load())
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
