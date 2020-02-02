#****************************************************************************************************************************************************plsr

output$x.r = renderUI({
selectInput(
'x.r',
tags$b('1. Add / Remove independent variable matrix (X)'),
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
tags$b('2. Choose one or more dependent variables (Y)'),
selected = names(DF4.r())[1],
choices = names(DF4.r()),
multiple = TRUE
)
})


output$pls.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))

#output$nc.r <- renderText({input$nc.r})
# model
pls <- eventReactive(input$pls1,{

  Y <- as.matrix(X()[,input$y.r])
  X <- as.matrix(X()[,input$x.r])
  validate(need(min(ncol(X), nrow(X))>input$nc.r, "Please input enough independent variables"))
  validate(need(input$nc.r>=1, "Please input correct number of components"))
  mvr(Y~X, ncomp=input$nc.r, validation=input$val.r, model=FALSE, method = input$method.r,scale = TRUE, center = TRUE)
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
  as.data.frame(pls()$scores[,1:pls()$ncomp])
  })

load.r <- reactive({
  as.data.frame(pls()$loadings[,1:pls()$ncomp])
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

output$pls.pres <- DT::renderDT({as.data.frame(pls()$fitted.values[,,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.coef <- DT::renderDT({as.data.frame(pls()$coefficients)}, 
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



output$pls.s.plot  <- plotly::renderPlotly({ 
validate(need(input$nc.r>=2, "The number of components must be >= 2"))
score <- score.r()
p<-plot_score(score, input$c1.r, input$c2.r)
plotly::ggplotly(p)
#  ggplot(df, aes(x = df[,input$c1], y = df[,input$c2]))+
#  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
#  theme_minimal()+
#  xlab(paste0("Comp", input$c1))+ylab(paste0("Comp", input$c2))

  })

output$pls.l.plot  <- plotly::renderPlotly({ 
load <- load.r()
p<-plot_load(loads=load, a=pls()$ncomp)
plotly::ggplotly(p)
#ll$group <- rownames(ll)
#loadings.m <- reshape::melt(ll, id="group",
#                   measure=colnames(ll)[1:input$nc.r])

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

output$pls.bp   <- plotly::renderPlotly({ 
  validate(need(input$nc.r>=2, "The number of components must be >= 2"))
  score <- score.r()
load <- load.r()
p<-plot_biplot(score, load, input$c11.r, input$c22.r)
plotly::ggplotly(p)
#plot(pls(), plottype = c("biplot"), comps=c(input$c1.r,input$c2.r),var.axes = TRUE)
})

# Plot of the explained variance
#output$pca.plot <- plotly::renderPlotly({ screeplot(pca(), npcs= input$nc.r, type="lines", main="") })

output$pls.tdplot <- plotly::renderPlotly({ 
validate(need(input$nc.r>=3, "The number of components must be >= 3"))
score <- score.r()
load <- load.r()

plot_3D(scores=score, loads=load, nx=input$td1.r,ny=input$td2.r,nz=input$td3.r, scale=input$lines.r)


# x <- scores[,input$td1.r]
# y <- scores[,input$td2.r]
# z <- scores[,input$td3.r]
# # Scale factor for loadings
# scale.loads <- input$lines.r
# 
# layout <- list(
#   scene = list(
#     xaxis = list(
#       title = paste0("PC", input$td1.r), 
#       showline = TRUE
#     ), 
#     yaxis = list(
#       title = paste0("PC", input$td2.r), 
#       showline = TRUE
#     ), 
#     zaxis = list(
#       title = paste0("PC", input$td3.r), 
#       showline = TRUE
#     )
#   ), 
#   title = "PLS (3D)"
# )
# 
# rnn <- rownames(as.data.frame(pls()$scores[,1:input$nc.r]))
# 
# p <- plot_ly() %>%
#   add_trace(x=x, y=y, z=z, 
#             type="scatter3d", mode = "text+markers", 
#             name = "original", 
#             linetypes = NULL, 
#             opacity = 0.5,
#             marker = list(size=2),
#             text = rnn) %>%
#   layout(p, scene=layout$scene, title=layout$title)
# 
# for (k in 1:nrow(loads)) {
#   x <- c(0, loads[k,1])*scale.loads
#   y <- c(0, loads[k,2])*scale.loads
#   z <- c(0, loads[k,3])*scale.loads
#   p <- p %>% add_trace(x=x, y=y, z=z,
#                        type="scatter3d", mode="lines",
#                        line = list(width=4),
#                        opacity = 1) 
# }
# p

})

output$pls_tdtrace <- renderPrint({
  x <- rownames(as.data.frame(pls()$loadings[,1:pls()$ncomp]))
  names(x) <- paste0("trace", 1:length(x)) 
  return(x)
  })
