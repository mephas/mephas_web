
output$x = renderUI({
selectInput(
'x',
tags$b('1. Choose independent variable matrix'),
selected = type.num3()[-c(1:3)],
choices = type.num3(),
multiple = TRUE
)
})

DF4 <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$x))]
return(df)
  })

output$y = renderUI({
selectInput(
'y',
tags$b('2. Choose dependent variable matrix'),
selected = names(DF4())[1],
choices = names(DF4()),
multiple = FALSE
)
})


output$pcr.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$nc <- renderText({input$nc})
# model
pcr <- eventReactive(input$pcr1,{

  Y <- as.matrix(X()[,input$y])
  X <- as.matrix(X()[,input$x])
  validate(need(min(ncol(X), nrow(X))>input$nc, "Please input enough independent variables"))
  mvr(Y~X, ncomp=input$nc, validation="none", model=FALSE, method = "svdpc")
  })

#pca.x <- reactive({ pca()$x })

#output$fit  <- renderPrint({
#  res <- rbind(pca()$explained_variance,pca()$cum.var)
#  rownames(res) <- c("explained_variance", "cumulative_variance")
#  res})
output$pcr  <- renderPrint({
  summary(pcr())
  })

output$pcr.s <- DT::renderDT({as.data.frame(pcr()$scores[,1:input$nc])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.l <- DT::renderDT({as.data.frame(pcr()$loadings[,1:input$nc])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



output$pcr.s.plot  <- renderPlot({ 

df <- as.data.frame(pcr()$scores[,1:input$nc])

  ggplot(df, aes(x = df[,input$c1], y = df[,input$c2]))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  theme_minimal()+
  xlab(paste0("Comp", input$c1))+ylab(paste0("Comp", input$c2))

  })

output$pcr.bp   <- renderPlot({ 
plot(pcr(), plottype = c("biplot"), comps=c(input$c1,input$c2))
})

# Plot of the explained variance
#output$pca.plot <- renderPlot({ screeplot(pca(), npcs= input$nc, type="lines", main="") })

output$tdplot <- plotly::renderPlotly({ 

scores <- as.data.frame(pcr()$scores[,1:input$nc])
x <- scores[,input$td1]
y <- scores[,input$td2]
z <- scores[,input$td3]

loads <- as.data.frame(pcr()$loadings[,1:input$nc])

# Scale factor for loadings
scale.loads <- input$lines

layout <- list(
  scene = list(
    xaxis = list(
      title = paste0("PC", input$td1), 
      showline = TRUE
    ), 
    yaxis = list(
      title = paste0("PC", input$td2), 
      showline = TRUE
    ), 
    zaxis = list(
      title = paste0("PC", input$td3), 
      showline = TRUE
    )
  ), 
  title = "PCA (3D)"
)

rnn <- rownames(as.data.frame(pcr()$scores[,1:input$nc]))

p <- plot_ly() %>%
  add_trace(x=x, y=y, z=z, 
            type="scatter3d", mode = "text+markers", 
            name = "original", 
            linetypes = NULL, 
            opacity = 0.5,
            marker = list(size=2),
            text = rnn) %>%
  layout(p, scene=layout$scene, title=layout$title)

for (k in 1:nrow(loads)) {
  x <- c(0, loads[k,1])*scale.loads
  y <- c(0, loads[k,2])*scale.loads
  z <- c(0, loads[k,3])*scale.loads
  p <- p %>% add_trace(x=x, y=y, z=z,
                       type="scatter3d", mode="lines",
                       line = list(width=4),
                       opacity = 1) 
}
p

})

output$tdtrace <- renderPrint({
  x <- rownames(as.data.frame(pcr()$loadings[,1:input$nc]))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
