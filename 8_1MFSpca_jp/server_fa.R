#****************************************************************************************************************************************************fa

#output$x.fa = renderUI({
#selectInput(
#'x.fa',
#tags$b('1. Add / Remove independent variables (X)'),
#selected = type.num3(),
#choices = type.num3(),
#multiple = TRUE
#)
#})

output$x.fa = renderUI({
 shinyWidgets::pickerInput(
    inputId = "x.fa",
    label = "1. 独立変数の追加/削除（X）",
    selected =type.num3(),
    choices = type.num3(),
    multiple = TRUE,
    options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
  })

DF4.fa <- eventReactive(input$pca1.fa,{
  X()[,input$x.fa]
  })


output$table.x.fa <- DT::renderDT(
head(X()), options = list(scrollX = TRUE,dom = 't'))

fa <- eventReactive(input$pca1.fa,{

  X <- DF4.fa()
  a <- input$ncfa

validate(need(nrow(DF4.fa())>ncol(DF4.fa()), "Number of variables should be less than the number of rows"))
validate(need(input$ncfa>=1, "Components must be >= 1."))
validate(need(input$ncfa<=min(dim(X)), "Components must be <= the number of rows and the number of columns"))

  psych::fa(X, nfactors=a, rotate="varimax", fm="ml")
  #factanal(DF4.fa(), factors = input$ncfa, scores= "regression")
  })


output$fa  <- renderPrint({
  summary(fa())
  })

#fa1 <- eventReactive(input$pca1.fa,{
#  validate(need(nrow(DF4.fa())>ncol(DF4.fa()), "Number of variables should be less than the number of rows"))
#  psych::fa.parallel((DF4.fa()),fa="fa",fm="ml")
#  })

#output$fa.plot   <- renderPlot({ fa1()
#psych::fa.parallel((DF4.fa()),fa="fa",fm="ml")
#})

#output$fancomp   <- renderPrint({ 
##x <- psych::fa.parallel((DF4.fa()),fa="fa",fm="ml")
#cat(paste0("Parallel analysis suggests that the number of factors: ", fa1()$nfact))
#})


output$comp.fa <- DT::renderDT({as.data.frame(round(fa()$scores,6))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$load.fa <- DT::renderDT({
  validate(need(input$ncfa>=2, "Components must be >= 2."))
  as.data.frame(round(fa()$loadings[,1:input$ncfa],6))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$var.fa <- DT::renderDT({as.data.frame(round(fa()$Vaccounted,6))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pca.ind.fa  <- renderPlot({ 
validate(need(input$ncfa>=1, "Components are not enough to create the plot."))
psych::fa.diagram(fa(), cut = 0)
  })

##########----------##########----------##########---------- score plot
output$g.fa = renderUI({
selectInput(
'g.fa',
tags$b('1. 1群のカテゴリ変数を選択し、群の円に追加する'),
#selected = type.fac4()[1],
choices = c("NULL",type.fac4())
)
})

output$type.fa = renderUI({
radioButtons("type.fa", "楕円の種類",
 choices = c(
  "なし" = "",
  "T：多変量のt分布を想定" = 't',
 "正規：多変量の正規分布を想定" = "norm",
 "ユークリッド：中心からのユークリッド距離" = "euclid"),
 selected = 'euclid',
 width="500px")
})

output$fa.ind  <- plotly::renderPlotly({ 
#output$pca.ind  <- renderPlot({ 
validate(need(input$nc>=2, "Components are not enough to create the plot."))
df <- as.data.frame(fa()$scores)
if (input$g.fa == "NULL") {
#df$group <- rep(1, nrow(df))
p<-plot_score(df, input$c1.fa, input$c2.fa)

}
else {
  group <- X()[,input$g.fa]
  if (input$type.fa==""){
    p<-plot_scoreg(df, input$c1.fa, input$c2.fa, group)
  }
  else{
    p<-plot_scorec(df, input$c1.fa, input$c2.fa, group, input$type.fa)
}

}
plotly::ggplotly(p)
})


##########----------##########----------##########---------- load plot




output$pca.ind.fa2  <- plotly::renderPlotly({ 
#validate(need(input$ncfa>=1, "Components are not enough to create the plot."))
load <- as.data.frame(fa()$loadings[,1:input$ncfa])
p<-plot_load(loads=load, a=input$ncfa)
plotly::ggplotly(p)

  })

#fa.cor <- eventReactive(input$pca1.fa,{
#  as.data.frame(cor(DF4.fa()))
#  })
#output$cor.fa <- DT::renderDT({as.data.frame(cor(DF4.fa()))}, 
#  extensions = 'Buttons', 
#    options = list(
#    dom = 'Bfrtip',
#    buttons = c('copy', 'csv', 'excel'),
#    scrollX = TRUE))

#output$cor.fa.plot   <- renderPlot({ 
#plot_corr(DF4.fa())#

#})

output$fa.bp   <- plotly::renderPlotly({ 
  validate(need(input$ncfa>=2, "Components are not enough to create the plot."))
#biplot(fa(),labels=rownames(DF4.fa()), choose=c(input$c1.fa,input$c2.fa), main="")
score <- as.data.frame(fa()$scores)
load <- as.data.frame(fa()$loadings[,1:input$ncfa])
p<- plot_biplot(score, load, input$c1.fa, input$c2.fa)
plotly::ggplotly(p)

})

# Plot of the explained variance
output$tdplot.fa <- plotly::renderPlotly({ 

validate(need(input$ncfa>=3, "Components are not enough to create the plot."))
score <- as.data.frame(fa()$scores)
load <- as.data.frame(fa()$loadings[,1:input$ncfa])

plot_3D(scores=score, loads=load, nx=input$td1.fa,ny=input$td2.fa,nz=input$td3.fa, scale=input$lines.fa)


})

output$tdtrace.fa <- renderPrint({
  x <- rownames((fa()$loadings[,1:input$ncfa]))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
