#****************************************************************************************************************************************************pca

#output$x = renderUI({
#selectInput(
#'x',
#tags$b('1. 独立変数の追加/削除（X）'),
#selected = type.num3(),
#choices = type.num3(),
#multiple = TRUE
#)
#})

output$x = renderUI({
  shinyWidgets::pickerInput(
    inputId = "x",
    label = "1. 独立変数の追加/削除（X）",
    selected =type.num3(),
    choices = type.num3(),
    multiple = TRUE,
    options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
  })

DF4 <- eventReactive(input$pca1,{
  X()[,input$x]
  })

output$table.x <- DT::renderDT(
    head(X()), options = list(scrollX = TRUE,dom = 't'))

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
  return(round(res.tab,6))
  },
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$comp <- DT::renderDT({
  as.data.frame(round(pca()$x,6))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$load <- DT::renderDT({round(pca()$rotation,6)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


type.fac4 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

##########----------##########----------##########---------- score plot
output$g = renderUI({
selectInput(
'g',
tags$b('1. 1群のカテゴリ変数を選択し、群の円に追加する'),
#selected = type.fac4()[1],
choices = c("NULL",type.fac4())
)
})

output$type = renderUI({
radioButtons("type", "楕円の種類",
 choices = c(
  "なし" = "",
  "T：多変量のt分布を想定" = 't',
 "正規：多変量の正規分布を想定" = "norm",
 "ユークリッド：中心からのユークリッド距離" = "euclid"),
 selected = 'euclid',
 width="500px")
})

output$pca.ind  <- plotly::renderPlotly({ 
#output$pca.ind  <- renderPlot({ 
validate(need(input$nc>=2, "Components are not enough to create the plot."))
df <- as.data.frame(pca()$x)
if (input$g == "NULL") {
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
