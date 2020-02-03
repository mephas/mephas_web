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
      actionsBox=TRUE)
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
#c <- as.data.frame(cor(DF4()))
#c$group <- rownames(c)
#corrs.m <- reshape::melt(c, id="group",
#                            measure=rownames(c))

#ggplot(corrs.m, aes(group, variable, fill=abs(value))) + 
#  geom_tile() + #rectangles for each correlation
#  #add actual correlation value in the rectangle
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

#output$nc <- renderText({input$nc})
# model
pca <- eventReactive(input$pca1,{
  validate(need(nrow(DF4())>ncol(DF4()), "Number of variables should be less than the number of rows"))
  X <- DF4()
  a <- input$nc
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
selected = type.fac4()[1],
choices = type.fac4()
)
})

output$pca.ind  <- plotly::renderPlotly({ 
#output$pca.ind  <- renderPlot({ 
validate(need(input$nc>=2, "Components are not enough to create the plot."))
df <- as.data.frame(pca()$x)
if (input$frame == FALSE) {
df$group <- rep(1, nrow(df))
p<-plot_score(df, input$c1, input$c2)
plotly::ggplotly(p)
#ggplot(df,aes(x = df[,input$c1], y = df[,input$c2], color=group, label=rownames(df)))+
#geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
#theme_minimal()+
#xlab(paste0("PC", input$c1))+ylab(paste0("PC", input$c2))#+
#geom_text(aes(label=rownames(df)),hjust=0, vjust=0)
}
else {
df$group <- X()[,input$g]
p<-plot_scorec(df, input$c1, input$c2, input$type)
plotly::ggplotly(p)
#ggplot(df, aes(x = df[,input$c1], y = df[,input$c2], color=group,label=rownames(df)))+
#geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
#stat_ellipse(type = input$type)+ theme_minimal()+
#xlab(paste0("PC", input$c1))+ylab(paste0("PC", input$c2))#+
#eom_text(aes(label=rownames(df)),hjust=0, vjust=0)
}
#plotly::ggplotly(p)
})

output$pca.ind2  <- plotly::renderPlotly({ 
#validate(need(input$nc>=1, "Components are not enough to create the plot."))
load <- as.data.frame(pca()$rotation)
p<-plot_load(loads=load, a=input$nc)
plotly::ggplotly(p)

#ll$group <- rownames(ll)
#loadings.m <- reshape::melt(ll, id="group",
#                   measure=colnames(ll)[1:input$nc])

#ggplot(loadings.m, aes(group, abs(value), fill=value)) + 
#  facet_wrap(~ variable, nrow=1) + #place the factors in separate facets
#  geom_bar(stat="identity") + #make the bars
#  coord_flip() + #flip the axes so the test names can be horizontal  
#  #define the fill color gradient: blue=positive, red=negative
#  scale_fill_gradient2(name = "Loading", 
#                       high = "blue", mid = "white", low = "red", 
#                       midpoint=0, guide=F) +
#  ylab("Loading Strength") + #improve y-axis label
#  theme_bw(base_size=10)

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

# Scale factor for loadings
#scale.loads <- input$lines

#layout <- list(
#  scene = list(
#    xaxis = list(
#      title = paste0("PC", input$td1), 
#      showline = TRUE
#    ), 
#    yaxis = list(
#      title = paste0("PC", input$td2), 
#      showline = TRUE
#    ), 
#    zaxis = list(
#      title = paste0("PC", input$td3), 
#      showline = TRUE
#    )
#  ), 
#  title = "PCA (3D)"
#)

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

output$tdtrace <- renderPrint({
  x <- rownames(pca()$rotation)
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
