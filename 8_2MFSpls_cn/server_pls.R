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
tags$b('1. 选择一个以上的因变量（Y）'),
selected = type.num3()[1:3],
choices = type.num3(),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
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
tags$b('2. 添加/删除自变量（X）'),
selected = type.num4.r(),
choices = type.num4.r(),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
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

  DF<- data.frame(
   Y = I(as.matrix(X()[,input$y.r])),
  X = I(as.matrix(X()[,input$x.r]))
  )

  #validate(need(input$y.r, "Please choose dependent variable"))
  #validate(need(min(ncol(X), nrow(X))>input$nc.r, "Please choose enough independent variables"))
  #validate(need(input$nc.r>=1, "Please input correct number of components"))
  mvr(Y~X, data=DF, ncomp=input$nc.r, validation=input$val.r, model=FALSE, method = input$method.r,scale = input$scale.r, center = input$scale.r)
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
  s <- as.data.frame(round(predict(pls(), type="scores"),6))
  rownames(s) <- rownames(X())
  return(s)  })

load.r <- reactive({
  as.data.frame(round(pls()$loadings[,1:pls()$ncomp],6))
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
  as.data.frame(round(pls()$fitted.values[,,pls()$ncomp],6))
  }, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.coef <- DT::renderDT({as.data.frame(round(pls()$coefficients[,,pls()$ncomp],6))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.resi <- DT::renderDT({as.data.frame(round(pls()$residuals[,,pls()$ncomp],6))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



#output$pls.s.plot  <- plotly::renderPlotly({ 
#validate(need(input$nc.r>=2, "The number of components must be >= 2"))
#score <- score.r()
##p<-plot_score(score, input$c1.r, input$c2.r)
#plotly::ggplotly(p)

#  })

##########----------##########----------##########---------- score plot

output$g.pls = renderUI({
selectInput(
'g.pls',
tags$b('1. 选择一个组的分类变量，添入组圈'),
selected = "None",
choices = c("None",type.fac4())
)
})

output$type.pls = renderUI({
radioButtons("type.pls", "椭圆的类型",
 choices = c(
  "无" = "",
  "T：假设多元t分布" = 't',
 "正态分布：假设多元正态分布" = "norm",
 "欧几里得：到中心的欧几里得距离" = "euclid"),
 selected = 'euclid',
 width="500px")
})

output$pls.s.plot  <- plotly::renderPlotly({ 
#output$pca.ind  <- renderPlot({ 

if (input$g.pls == "None") {
#df$group <- rep(1, nrow(df))
df <- score.r()
p<-plot_score(df, input$c1.r, input$c2.r)

}
else {

  if (input$type.pls==""){
    df <- score.r()
    p<-plot_scoreg(df, input$c1.r, input$c2.r, X()[,input$g.pls])
  }
  else{
    df <- score.r()
    p<-plot_scorec(df, input$c1.r, input$c2.r, X()[,input$g.pls], input$type.pls)
}

}
plotly::ggplotly(p)
})

##########----------##########----------##########---------- load plot
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
