#****************************************************************************************************************************************************fa

output$x.fa = renderUI({
selectInput(
'x.fa',
tags$b('1. Choose independent variable matrix (X)'),
selected = type.num3(),
choices = type.num3(),
multiple = TRUE
)
})

DF4.fa <- reactive({
  X()[,input$x.fa]
  })


output$table.x.fa <- DT::renderDT(
    head(X()), options = list(scrollX = TRUE,dom = 't'))

fa <- eventReactive(input$pca1.fa,{
  X <- DF4.fa()
  a <- input$ncfa
  validate(need(input$ncfa>=1, "Components must be >= 1."))
  psych::fa(X, nfactors=a, rotate="varimax", fm="ml")
  #factanal(DF4.fa(), factors = input$ncfa, scores= "regression")
  })


output$fa  <- renderPrint({
  summary(fa())
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

output$load.fa <- DT::renderDT({
  validate(need(input$ncfa>=2, "Components must be >= 2."))
  as.data.frame(fa()$loadings[,1:input$ncfa])}, 
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
    validate(need(input$ncfa>=1, "Components are not enough to create the plot."))
psych::fa.diagram(fa(), cut = 0)
  })

output$pca.ind.fa2  <- plotly::renderPlotly({ 
#validate(need(input$ncfa>=1, "Components are not enough to create the plot."))
load <- as.data.frame(fa()$loadings[,1:input$ncfa])
p<-MFSload(loads=load, a=input$ncfa)
plotly::ggplotly(p)
#ll$group <- rownames(ll)
#loadings.m <- reshape::melt(ll, id="group",
#                   measure=colnames(ll)[1:input$ncfa])

#ggplot(loadings.m, aes(group, abs(value), fill=value)) + 
#  facet_wrap(~ variable, nrow=1) + #place the factors in separate facets
#  geom_bar(stat="identity") + #make the bars
#  coord_flip() + #flip the axes so the test names can be horizontal  
  #define the fill color gradient: blue=positive, red=negative
#  scale_fill_gradient2(name = "Loading", 
#                       high = "blue", mid = "white", low = "red", 
#                       midpoint=0, guide=F) +
#  ylab("Loading Strength") + #improve y-axis label
#  theme_bw(base_size=10)

  })

output$cor.fa <- DT::renderDT({as.data.frame(cor(DF4.fa()))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$cor.fa.plot   <- renderPlot({ 
MFScorr(DF4.fa())
#c <- as.data.frame(cor(DF4.fa()))
#c$group <- rownames(c)
#corrs.m <- reshape::melt(c, id="group",
#                            measure=rownames(c))

#ggplot(corrs.m, aes(group, variable, fill=abs(value))) + 
#  geom_tile() + #rectangles for each correlation
  #add actual correlation value in the rectangle
#  geom_text(aes(label = round(value, 2)), size=2.5) + 
#  theme_bw(base_size=10) + #black and white theme with set font size
  #rotate x-axis labels so they don't overlap, 
  #get rid of unnecessary axis titles
  #adjust plot margins
#  theme(axis.text.x = element_text(angle = 90), 
#        axis.title.x=element_blank(), 
#        axis.title.y=element_blank(), 
#        plot.margin = unit(c(3, 1, 0, 0), "mm")) +
  #set correlation fill gradient
#  scale_fill_gradient(low="white", high="red") + 
#  guides(fill=F) #omit unnecessary gradient legend

})

output$fa.bp   <- renderPlot({ 
  validate(need(input$ncfa>=2, "Components are not enough to create the plot."))
biplot(fa(),labels=rownames(DF4.fa()), choose=c(input$c1.fa,input$c2.fa), main="")

})

# Plot of the explained variance
output$tdplot.fa <- plotly::renderPlotly({ 

validate(need(input$ncfa>=3, "Components are not enough to create the plot."))
score <- as.data.frame(fa()$scores)
load <- as.data.frame(fa()$loadings[,1:input$ncfa])

MFS3D(scores=score, loads=load, nx=input$td1.fa,ny=input$td2.fa,nz=input$td3.fa, scale=input$lines.fa)
#x <- scores[,input$td1.fa]
#y <- scores[,input$td2.fa]
#z <- scores[,input$td3.fa]
#scale.loads <- input$lines.fa

#layout <- list(
#  scene = list(
#    xaxis = list(
#      title = names(scores)[input$td1.fa], 
#      showline = TRUE
#    ), 
#    yaxis = list(
#      title = names(scores)[input$td2.fa], 
#      showline = TRUE
#    ), 
#    zaxis = list(
#      title = names(scores)[input$td3.fa], 
#      showline = TRUE
#    )
#  ), 
#  title = "FA (3D)"
#)#

#rnn <- rownames(as.data.frame(scores))

#p <- plot_ly() %>%
#  add_trace(x=x, y=y, z=z, 
#            type="scatter3d", mode = "text+markers", 
#            name = "original", 
#            linetypes = NULL, 
#            opacity = 0.5,
#            marker = list(size=2),
#            text = rnn) %>%
#  layout(p, scene=layout$scene, title=layout$title)

#for (k in 1:nrow(loads)) {
#  x <- c(0, loads[k,1])*scale.loads
#  y <- c(0, loads[k,2])*scale.loads
#  z <- c(0, loads[k,3])*scale.loads
#  p <- p %>% add_trace(x=x, y=y, z=z,
#                       type="scatter3d", mode="lines",
#                       line = list(width=4),
#                       opacity = 1) 
#}
#p

})

output$tdtrace.fa <- renderPrint({
  x <- rownames((fa()$loadings[,1:input$ncfa]))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
