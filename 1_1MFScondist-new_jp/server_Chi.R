#****************************************************************************************************************************************************1.6. chi
output$x.plot <- renderPlot({
  ggplot(data = data.frame(x = c(0, input$x.xlim)), aes(x)) +
  stat_function(fun = dchisq, args = list(df = input$x.df)) + 
  ylab("Density") +
  xlim(0, input$x.xlim)+
  geom_vline(aes(xintercept=input$x.df), color="red", linetype="dashed", size=0.5)+
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$x.ylim) +
  geom_vline(aes(xintercept=qchisq(input$x.pr, df = input$x.df)), colour = "red")})

output$x.plot.cdf <- plotly::renderPlotly({
x0<- qchisq(input$x.pr, df = input$x.df)
mean <- input$x.df
p<-ggplot(data = data.frame(x = c(0, input$x.xlim)), mapping = aes(x = x)) +
  stat_function(fun = pchisq, args = list(df = input$x.df)) + 
  xlim(0, input$x.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)

plotly::ggplotly(p)
})

output$x.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click5))})

output$xn = renderTable({
  x <- data.frame(x.postion = qchisq(input$x.pr, df = input$x.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

X = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rchisq(input$x.size, input$x.df))
  return(df)})

output$download6 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(X(), file)
    }
  )

output$x.plot2 = plotly::renderPlotly({
  df = X()
  x <- names(df)
p<-plot_hist1c(df, x, input$x.bin)
plotly::ggplotly(p)

})

output$x.sum = renderTable({
  x = X()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

output$x = renderTable({
  x <- data.frame(x.postion = qchisq(input$x.pr, df = input$x.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

