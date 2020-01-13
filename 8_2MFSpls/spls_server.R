
output$x.s = renderUI({
selectInput(
'x.s',
tags$b('1. Choose independent variable matrix'),
selected = type.num3()[-c(1:3)],
choices = type.num3(),
multiple = TRUE
)
})

DF4.s <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$x.s))]
return(df)
  })

output$y.s = renderUI({
selectInput(
'y.s',
tags$b('2. Choose dependent variable matrix'),
selected = names(DF4.s())[1],
choices = names(DF4.s()),
multiple = TRUE
)
})


output$spls.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.cv  <- renderPrint({
  Y <- as.matrix(X()[,input$y.s])
  X <- as.matrix(X()[,input$x.s])
  set.seed(10)
  spls::cv.spls(X,Y, eta = seq(0.1,input$cv.eta,0.1), K = c(1:input$cv.s),
    select="pls2", fit = input$method.s, plot.it = FALSE)
  
  })

#output$heat.cv <- renderPlot({ 
#  Y <- as.matrix(X()[,input$y.s])
#  X <- as.matrix(X()[,input$x.s])
#  set.seed(10)
#  spls::cv.spls(X,Y, eta = seq(0.1,input$cv.eta,0.1), K = c(1:input$cv.s),
#    select="pls2", fit = input$method.s, plot.it = TRUE)
#  })


#output$nc <- renderText({input$nc})
# model
spls <- eventReactive(input$spls1,{

  Y <- as.matrix(X()[,input$y.s])
  X <- as.matrix(X()[,input$x.s])
  validate(need(min(ncol(X), nrow(X))>input$nc.s, "Please input enough independent variables"))
  spls::spls(X, Y, K=input$nc.s, eta=input$nc.eta, kappa=0.5, select="pls2", fit=input$method.s)
  })


output$spls  <- renderPrint({
  print(spls())
  })

output$spls.bp   <- renderPlot({ 
plot(spls())
})

output$spls.coef <- DT::renderDT({
  x<-as.data.frame(spls()$betamat)
  colnames(x) <- paste0("step", 1:spls()$K)
  rownames(x) <- input$x.s
  return(x)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.s <- DT::renderDT({data.frame(as.matrix(X()[spls()$A])%*%as.matrix(spls()$projection))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.l <- DT::renderDT({as.data.frame(spls()$projection)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.pres <- DT::renderDT({
  x <- as.data.frame(predict(spls(), type="fit"))
  colnames(x) <- input$y.s
  return(x)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.sv <- DT::renderDT({as.data.frame(X()[spls()$A])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



output$spls.s.plot  <- renderPlot({ 

df <- data.frame(as.matrix(X()[spls()$A])%*%as.matrix(spls()$projection))

  ggplot(df, aes(x = df[,input$c1.s], y = df[,input$c2.s]))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  theme_minimal()+
  xlab(paste0("Comp", input$c1.s))+ylab(paste0("Comp", input$c2.s))

  })

output$spls.l.plot  <- renderPlot({ 
ll <- as.data.frame(spls()$projection)
ll$group <- rownames(ll)
loadings.m <- reshape::melt(ll, id="group",
                   measure=colnames(ll)[1:spls()$K])

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



# Plot of the explained variance
#output$pca.plot <- renderPlot({ screeplot(pca(), npcs= input$nc, type="lines", main="") })

output$tdplot.s <- plotly::renderPlotly({ 

scores <- data.frame(as.matrix(X()[spls()$A])%*%as.matrix(spls()$projection))
x <- scores[,input$td1.s]
y <- scores[,input$td2.s]
z <- scores[,input$td3.s]

loads <- as.data.frame(spls()$projection)

# Scale factor for loadings
scale.loads <- input$lines.s

layout <- list(
  scene = list(
    xaxis = list(
      title = paste0("PC", input$td1.s), 
      showline = TRUE
    ), 
    yaxis = list(
      title = paste0("PC", input$td2.s), 
      showline = TRUE
    ), 
    zaxis = list(
      title = paste0("PC", input$td3.s), 
      showline = TRUE
    )
  ), 
  title = "SPLS (3D)"
)

rnn <- rownames(scores)

p <- plot_ly() %>%
  add_trace(x=x, y=y, z=z, 
            type="scatter3d", mode = "text+markers", 
            name = "original", 
            linetypes = NULL, 
            opacity = 0.5,
            marker = list(size=2),
            text = rnn
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

output$tdtrace.s <- renderPrint({
  x <- rownames(as.data.frame(spls()$projection))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
