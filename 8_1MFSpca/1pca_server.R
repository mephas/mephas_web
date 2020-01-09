
output$y = renderUI({
selectInput(
'y',
tags$b('1. Remove variables (not put in the independent matrix)'),
selected = "NULL",
choices = c("NULL",type.num3()),
multiple = TRUE
)
})

DF4 <- reactive({
  df <- X()[,type.num3()]
  validate(need(input$y, "Please choose NULL or some variable to remove"))
  if ("NULL" %in% input$y) {df <-df[ ,type.num3()]}
  else {df <-df[ ,-which(type.num3() %in% c(input$y))]}
return(df)
  })

output$x <- renderPrint({colnames(DF4()) })

output$table.x <- DT::renderDT(
    head(X()), 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$nc <- renderText({input$nc})
# model
pca <- eventReactive(input$pca1,{
  #pca = mixOmics::pca(as.matrix(X()), ncomp = input$nc, scale = TRUE)
  prcomp(as.matrix(DF4()), rank.=input$nc, scale. = input$scale1)
  })

#pca.x <- reactive({ pca()$x })

#output$fit  <- renderPrint({
#  res <- rbind(pca()$explained_variance,pca()$cum.var)
#  rownames(res) <- c("explained_variance", "cumulative_variance")
#  res})
output$fit  <- DT::renderDT({
  res <- summary(pca())
  res.tab<- as.data.frame(res$importance)
  return(t(res.tab))
  },
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$comp <- DT::renderDT({pca()$x}, 
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

#output$downloadData <- downloadHandler(
#    filename = function() {
#      "pca_components.csv"
#    },
#    content = function(file) {
#      write.csv(pca.x(), file, row.names = FALSE)
#    }
#  )
# Plot of two components
type.fac4 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

output$g = renderUI({
selectInput(
'g',
tags$b('4. Choose one group variable, categorical (if add group circle)'),
selected = type.fac4()[1],
choices = type.fac4()
)
})

output$pca.ind  <- renderPlot({ 

df <- as.data.frame(pca()$x)
  if (input$frame == FALSE)
  {
  df$group <- rep(1, nrow(df))
  ggplot(df,aes(x = df[,input$c1], y = df[,input$c2], color=group))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  theme_minimal()+
  xlab(paste0("PC", input$c1))+ylab(paste0("PC", input$c2))
  }
  else
  {
  df$group <- X()[,1]
  ggplot(df, aes(x = df[,input$c1], y = df[,input$c2], color=group))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  stat_ellipse(type = input$type)+ theme_minimal()+
  xlab(paste0("PC", input$c1))+ylab(paste0("PC", input$c2))
  }
  })
# Plot of the loadings of two components

output$pca.bp   <- renderPlot({ 
  #autoplot(pca(), data=X(), x = input$c1, y = input$c2, label = TRUE, label.size = 3, shape = FALSE, 
  #  loadings = TRUE, loadings.label = TRUE, loadings.label.size = 3)+ theme_minimal()
#pca3d(pca(), group=X()[,1], biplot=TRUE)
biplot(pca(), choice=c(input$c1,input$c2))
})

# Plot of the explained variance
output$pca.plot <- renderPlot({ screeplot(pca(), npcs= input$nc, type="lines", main="") })

output$tdplot <- plotly::renderPlotly({ 

scores <- pca()$x
x <- scores[,input$td1]
y <- scores[,input$td2]
z <- scores[,input$td3]

loads <- pca()$rotation

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

p <- plot_ly() %>%
  add_trace(x=x, y=y, z=z, 
            type="scatter3d", mode="markers",
            marker = list(size=5, 
                          color="gray", 
                          opacity = 0.7)
            ) %>%
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
  x <- rownames(pca()$rotation)
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
