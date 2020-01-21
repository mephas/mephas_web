#****************************************************************************************************************************************************pcr

output$x = renderUI({
selectInput(
'x',
tags$b('1. Choose independent variable matrix (X)'),
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
tags$b('2. Choose one dependent variable (Y)'),
selected = names(DF4())[1],
choices = names(DF4()),
multiple = FALSE
)
})


output$pcr.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))

#output$nc <- renderText({input$nc})
# model
pcr <- eventReactive(input$pcr1,{

  Y <- as.matrix(X()[,input$y])
  X <- as.matrix(X()[,input$x])
  validate(need(min(ncol(X), nrow(X))>input$nc, "Please input enough independent variables"))
  validate(need(input$nc>=1, "Please input correct number of components"))
  mvr(Y~X, ncomp=input$nc, validation=input$val, model=FALSE, method = "svdpc",scale = TRUE, center = TRUE)
  })

#pca.x <- reactive({ pca()$x })

#output$fit  <- renderPrint({
#  res <- rbind(pca()$explained_variance,pca()$cum.var)
#  rownames(res) <- c("explained_variance", "cumulative_variance")
#  res})
output$pcr  <- renderPrint({
  summary(pcr())
  })

output$pcr_r  <- renderPrint({
  R2(pcr(),estimate = "all")
  })

output$pcr_msep  <- renderPrint({
  MSEP(pcr(),estimate = "all")
  })

output$pcr_rmsep  <- renderPrint({
  RMSEP(pcr(),estimate = "all")
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

output$pcr.pres <- DT::renderDT({as.data.frame(pcr()$fitted.values[,,1:input$nc])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.coef <- DT::renderDT({as.data.frame(pcr()$coefficients)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.resi <- DT::renderDT({as.data.frame(pcr()$residuals[,,1:input$nc])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$pcr.s.plot  <- renderPlot({ 
validate(need(input$nc>=2, "The number of components must be >= 2"))
df <- as.data.frame(pcr()$scores[,1:input$nc])

  ggplot(df, aes(x = df[,input$c1], y = df[,input$c2]))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  theme_minimal()+
  xlab(paste0("Score", input$c1))+ylab(paste0("Score", input$c2))

  })

output$pcr.l.plot  <- renderPlot({ 
load <- as.data.frame(pcr()$loadings[,1:input$nc])
MFSload(loads=load, a=input$nc)
#ll$group <- rownames(ll)
#loadings.m <- reshape::melt(ll, id="group",
#                   measure=colnames(ll)[1:input$nc])

#ggplot(loadings.m, aes(loadings.m$group, abs(loadings.m$value), fill=loadings.m$value)) + 
#  facet_wrap(~ loadings.m$variable, nrow=1) + #place the factors in separate facets
#  geom_bar(stat="identity") + #make the bars
#  coord_flip() + #flip the axes so the test names can be horizontal  
  #define the fill color gradient: blue=positive, red=negative
#  scale_fill_gradient2(name = "Loading", 
#                       high = "blue", mid = "white", low = "red", 
#                       midpoint=0, guide=F) +
#  ylab("Loading Strength") + #improve y-axis label
#  theme_bw(base_size=10)

  })

output$pcr.bp   <- renderPlot({ 
validate(need(input$nc>=2, "The number of components must be >= 2"))
plot(pcr(), plottype = c("biplot"), comps=c(input$c1,input$c2),var.axes = TRUE, main="")
})

# Plot of the explained variance
#output$pca.plot <- renderPlot({ screeplot(pca(), npcs= input$nc, type="lines", main="") })

output$tdplot <- plotly::renderPlotly({ 
validate(need(input$nc>=3, "The number of components must be >= 3"))

score <- as.data.frame(pcr()$scores[,1:input$nc])
load <- as.data.frame(pcr()$loadings[,1:input$nc])

MFS3D(scores=score, loads=load, nx=input$td1,ny=input$td2,nz=input$td3, scale=input$lines)

#x <- scores[,input$td1]
#y <- scores[,input$td2]
#z <- scores[,input$td3]
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

#rnn <- rownames(as.data.frame(pcr()$scores[,1:input$nc]))

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
  validate(need(input$nc>=3, "The number of components must be >= 3"))
  x <- rownames(as.data.frame(pcr()$loadings[,1:input$nc]))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
