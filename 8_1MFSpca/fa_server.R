
output$y.fa = renderUI({
selectInput(
'y.fa',
tags$b('1. Remove variables (not put in the independent matrix)'),
selected = "NULL",
choices = c("NULL",type.num3()),
multiple = TRUE
)
})

DF4.fa <- reactive({
  df <- X()[,type.num3()]
  validate(need(input$y.fa, "Please choose NULL or some variable to remove"))
  if ("NULL" %in% input$y.fa) {df <-df}
  else {df <-df[ ,-which(type.num3() %in% c(input$y.fa))]}
return(df)
  })

output$x_fa <- renderPrint({colnames(DF4.fa()) })

output$table.x.fa <- DT::renderDT(
    head(X()), 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$nc <- renderText({input$nc})
# model
fa <- eventReactive(input$pca1.fa,{
  #pca = mixOmics::pca(as.matrix(X()), ncomp = input$nc, scale = TRUE)
  psych::fa(DF4.fa(),nfactors=input$ncfa, rotate="varimax", fm="ml")
  #factanal(DF4.fa(), factors = input$ncfa, scores= "regression")
  })

#pca.x <- reactive({ pca()$x })

#output$fit  <- renderPrint({
#  res <- rbind(pca()$explained_variance,pca()$cum.var)
#  rownames(res) <- c("explained_variance", "cumulative_variance")
#  res})
output$fa  <- renderPrint({
  fa()
  })

output$fa.plot   <- renderPlot({ 
psych::fa.parallel((DF4.fa()),fa="fa",fm="ml")
})

output$fancomp   <- renderPrint({ 
x <- psych::fa.parallel((DF4.fa()),fa="fa",fm="ml")
cat(paste0("Parallel analysis suggests that the number of factors: ", x$nfact))
})


output$comp.fa <- DT::renderDT({as.data.frame(fa()$scores)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$load.fa <- DT::renderDT({as.data.frame(fa()$loadings[,1:input$ncfa])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$var.fa <- DT::renderDT({as.data.frame(fa()$Vaccounted)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$pca.ind.fa  <- renderPlot({ 
psych::fa.diagram(fa(), cut = 0)
  })

output$pca.ind.fa2  <- renderPlot({ 
ll <- as.data.frame(fa()$loadings[,1:input$ncfa])
ll$group <- rownames(ll)
loadings.m <- reshape::melt(ll, id="group",
                   measure=colnames(ll)[1:input$ncfa])

ggplot(loadings.m, aes(group, abs(value), fill=value)) + 
  facet_wrap(~ variable, nrow=1) + #place the factors in separate facets
  geom_bar(stat="identity") + #make the bars
  coord_flip() + #flip the axes so the test names can be horizontal  
  #define the fill color gradient: blue=positive, red=negative
  scale_fill_gradient2(name = "Loading", 
                       high = "blue", mid = "white", low = "red", 
                       midpoint=0, guide=F) +
  ylab("Loading Strength") + #improve y-axis label
  theme_bw(base_size=10)

  })

output$cor.fa <- DT::renderDT({as.data.frame(cor(DF4()))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$cor.fa.plot   <- renderPlot({ 
c <- as.data.frame(fa()$residual+fa()$model)
c$group <- rownames(c)
corrs.m <- reshape::melt(c, id="group",
                            measure=rownames(c))

ggplot(corrs.m, aes(group, variable, fill=abs(value))) + 
  geom_tile() + #rectangles for each correlation
  #add actual correlation value in the rectangle
  geom_text(aes(label = round(value, 2)), size=2.5) + 
  theme_bw(base_size=10) + #black and white theme with set font size
  #rotate x-axis labels so they don't overlap, 
  #get rid of unnecessary axis titles
  #adjust plot margins
  theme(axis.text.x = element_text(angle = 90), 
        axis.title.x=element_blank(), 
        axis.title.y=element_blank(), 
        plot.margin = unit(c(3, 1, 0, 0), "mm")) +
  #set correlation fill gradient
  scale_fill_gradient(low="white", high="red") + 
  guides(fill=F) #omit unnecessary gradient legend

})

# Plot of the explained variance
output$tdplot.fa <- plotly::renderPlotly({ 

scores <- fa()$scores
x <- scores[,input$td1]
y <- scores[,input$td2]
z <- scores[,input$td3]

loads <- (fa()$loadings[,1:input$ncfa])

# Scale factor for loadings
scale.loads <- input$lines

layout <- list(
  scene = list(
    xaxis = list(
      title = paste0("ML", input$td1.fa), 
      showline = TRUE
    ), 
    yaxis = list(
      title = paste0("ML", input$td2.fa), 
      showline = TRUE
    ), 
    zaxis = list(
      title = paste0("ML", input$td3.fa), 
      showline = TRUE
    )
  ), 
  title = "FA (3D)"
)

rnn <- rownames(as.data.frame(scores))

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

output$tdtrace.fa <- renderPrint({
  x <- rownames((fa()$loadings[,1:input$ncfa]))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
