#****************************************************************************************************************************************************pca

#output$x = renderUI({
#selectInput(
#'x',
#tags$b('1. Add / Remove independent variable matrix (X)'),
#selected = type.num3(),
#choices = type.num3(),
#multiple = TRUE
#)
#})

output$x = renderUI({
  pickerInput(
    inputId = "x",
    label = "1. Add / Remove independent variables (X)",
    selected =type.num3(),
    choices = type.num3(),
    multiple = TRUE,
    options = pickerOptions(
      actionsBox=TRUE,
      size=5)
)
  })

DF4 <- eventReactive(input$pca1,{
  X()[,input$x]
  })

output$table.x <- DT::renderDT(
    head(X()), options = list(scrollX = TRUE,dom = 't'))

output$cor <- DT::renderDT({
  c <- as.data.frame(cor(DF4()))
  c <- c[ , order(names(c))]
  c <- c[order(rownames(c)),]
  return(c)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$cor.plot   <- renderPlot({ 
plot_corr(DF4())

})

pca <- eventReactive(input$pca1,{

  X <- as.data.frame(na.omit(DF4()))
  a <- input$nc

validate(need(nrow(DF4())>ncol(DF4()), "Number of variables should be less than the number of rows"))
validate(need(input$nc<=min(dim(X)), "Components must be <= the number of rows and the number of columns"))
validate(need(input$nc>=1, "Components must be >= 1."))

  prcomp(X, rank.=a, scale.=TRUE)
  })


output$var  <- DT::renderDT({
  validate(need(input$nc>=2, "Components must be >= 2."))
  res <- summary(pca())
  res.tab<- as.data.frame(res$importance)[,1:input$nc]
  return(res.tab)
  },
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$comp <- DT::renderDT({
  as.data.frame(pca()$x)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$load <- DT::renderDT({pca()$rotation}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


type.fac4 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

output$g = renderUI({
selectInput(
'g',
tags$b('Choose one group variable, categorical (if add group circle)'),
#selected = type.fac4()[1],
choices = c("NULL",type.fac4())
)
})

output$pca.ind  <- plotly::renderPlotly({ 
#output$pca.ind  <- renderPlot({ 
validate(need(input$nc>=2, "Components are not enough to create the plot."))
df <- as.data.frame(pca()$x)
if (input$g == "NULL") {
df$group <- rep(1, nrow(df))
p<-plot_score(df, input$c1, input$c2)

}
else {
df$group <- X()[,input$g]
p<-plot_scorec(df, input$c1, input$c2, input$type)

}
plotly::ggplotly(p)
})

output$pca.ind2  <- plotly::renderPlotly({ 
#validate(need(input$nc>=1, "Components are not enough to create the plot."))
load <- as.data.frame(pca()$rotation)
p<-plot_load(load, input$nc)
plotly::ggplotly(p)


  })

pcafa <- eventReactive(input$pca1, {
  validate(need(nrow(DF4())>ncol(DF4()), "Number of variables should be less than the number of rows"))
  psych::fa.parallel((DF4()),fa="pc",fm="ml")
  })

output$pc.plot   <- renderPlot({ 
pcafa()
})

output$pcncomp   <- renderPrint({ 
#x <- psych::fa.parallel((DF4()),fa="pc",fm="ml")
cat(paste0("Parallel analysis suggests that the number of components: ", pcafa()$ncomp))
})

output$pca.bp   <- plotly::renderPlotly({ 
validate(need(input$nc>=2, "Components are not enough to create the plot."))
score <- as.data.frame(pca()$x)
load <- as.data.frame(pca()$rotation)
p<- plot_biplot(score, load, input$c11, input$c22)
plotly::ggplotly(p)
#biplot(pca(), choice=c(input$c1,input$c2))
})

# Plot of the explained variance
output$pca.plot <- renderPlot({ screeplot(pca(), npcs= input$nc, type="lines", main="") })

output$tdplot <- plotly::renderPlotly({ 
validate(need(input$nc>=3, "Components are not enough to create the plot."))

score <- as.data.frame(pca()$x)
load <- as.data.frame(pca()$rotation)

plot_3D(scores=score, loads=load, nx=input$td1,ny=input$td2,nz=input$td3, scale=input$lines)


})

output$tdtrace <- renderPrint({
  x <- rownames(pca()$rotation)
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
