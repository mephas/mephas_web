
output$x.r = renderUI({
selectInput(
'x.r',
tags$b('1. Choose independent variable matrix'),
selected = type.num3()[-c(1:3)],
choices = type.num3(),
multiple = TRUE
)
})

DF4.r <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$x.r))]
return(df)
  })

output$y.r = renderUI({
selectInput(
'y.r',
tags$b('2. Choose dependent variable matrix'),
selected = names(DF4.r())[1],
choices = names(DF4.r()),
multiple = TRUE
)
})


output$pls.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$nc.r <- renderText({input$nc.r})
# model
pls <- eventReactive(input$pls1,{

  Y <- as.matrix(X()[,input$y.r])
  X <- as.matrix(X()[,input$x.r])
  validate(need(min(ncol(X), nrow(X))>input$nc.r, "Please input enough independent variables"))
  mvr(Y~X, ncomp=input$nc.r, validation=input$val.r, model=FALSE, method = input$method.r,scale = TRUE, center = TRUE)
  })

#pca.x <- reactive({ pca()$x })

#output$fit  <- renderPrint({
#  res <- rbind(pca()$explained_variance,pca()$cum.var)
#  rownames(res) <- c("explained_variance", "cumulative_variance")
#  res})
output$pls  <- renderPrint({
  summary(pls())
  })

output$pls.s <- DT::renderDT({as.data.frame(pls()$scores[,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.l <- DT::renderDT({as.data.frame(pls()$loadings[,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.pres <- DT::renderDT({as.data.frame(pls()$fitted.values[,,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.resi <- DT::renderDT({as.data.frame(pls()$residuals[,,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



output$pls.s.plot  <- renderPlot({ 

df <- as.data.frame(pls()$scores[,1:input$nc.r])

  ggplot(df, aes(x = df[,input$c1], y = df[,input$c2]))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  theme_minimal()+
  xlab(paste0("Comp", input$c1))+ylab(paste0("Comp", input$c2))

  })

output$pls.l.plot  <- renderPlot({ 
ll <- as.data.frame(pls()$loadings[,1:input$nc.r])
ll$group <- rownames(ll)
loadings.m <- reshape::melt(ll, id="group",
                   measure=colnames(ll)[1:input$nc.r])

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

output$pls.bp   <- renderPlot({ 
plot(pls(), plottype = c("biplot"), comps=c(input$c1.r,input$c2.r),var.axes = TRUE)
})

# Plot of the explained variance
#output$pca.plot <- renderPlot({ screeplot(pca(), npcs= input$nc.r, type="lines", main="") })

output$pls.tdplot <- plotly::renderPlotly({ 

scores <- as.data.frame(pls()$scores[,1:input$nc.r])
x <- scores[,input$td1.r]
y <- scores[,input$td2.r]
z <- scores[,input$td3.r]

loads <- as.data.frame(pls()$loadings[,1:input$nc.r])

# Scale factor for loadings
scale.loads <- input$lines.r

layout <- list(
  scene = list(
    xaxis = list(
      title = paste0("PC", input$td1.r), 
      showline = TRUE
    ), 
    yaxis = list(
      title = paste0("PC", input$td2.r), 
      showline = TRUE
    ), 
    zaxis = list(
      title = paste0("PC", input$td3.r), 
      showline = TRUE
    )
  ), 
  title = "PLS (3D)"
)

rnn <- rownames(as.data.frame(pls()$scores[,1:input$nc.r]))

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

output$pls_tdtrace <- renderPrint({
  x <- rownames(as.data.frame(pls()$loadings[,1:input$nc.r]))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
