#****************************************************************************************************************************************************1.3. gamma
output$g.plot <- renderPlot({
  ggplot(data = data.frame(x = c(0, input$g.xlim)), aes(x)) +
  stat_function(fun = "dgamma", args = list(shape = input$g.shape, scale=input$g.scale)) + 
  xlim(0, input$g.xlim)+
  ylab("Density") +
  theme_minimal() + 
  ggtitle("")+
  geom_vline(aes(xintercept=input$g.shape*input$g.scale), color="red", linetype="dashed", size=0.5)+
  geom_vline(aes(xintercept=qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale)), colour = "red")
  })

output$g.rate <- renderPrint({
  cat(paste0("Input: shape (k) = ", (input$g.mean/input$g.sd)^2, " and  scale (theta) = ", input$g.sd^2/input$g.mean))
  })

output$g.plot.cdf <- plotly::renderPlotly({
x0<- qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale)
mean <- input$g.shape*input$g.scale
p<-ggplot(data = data.frame(x = c(0, input$g.xlim)), mapping = aes(x = x)) +
  stat_function(fun = "pgamma", args = list(shape = input$g.shape, scale=input$g.scale)) + 
  xlim(0, input$g.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)

plotly::ggplotly(p)
})

output$g.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click11))})

output$g = renderTable({
  x <- data.frame(x.postion = qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

G = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rgamma(input$g.size, shape = input$g.shape, scale=input$g.scale))
  return(df)})

output$download3 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(G(), file)
    }
  )

output$g.plot2 = plotly::renderPlotly({
  df = G()
  x <- names(df)
p<-plot_hist1c(df, x, input$g.bin)
plotly::ggplotly(p)
})

output$g.sum = renderTable({
  x = G()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1])))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

