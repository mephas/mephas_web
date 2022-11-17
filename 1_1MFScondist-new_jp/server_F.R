#****************************************************************************************************************************************************1.7. F
output$f.plot <- renderPlot({
  ggplot(data = data.frame(x = c(0, input$f.xlim)), aes(x)) +
  stat_function(fun = df, n= 100, args = list(df1 = input$df11, df2 = input$df21)) + 
  ylab("Density") +
  xlim(0, input$f.xlim)+
  #scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$f.ylim) +
  geom_vline(aes(xintercept=input$df21/(input$df21-2)), color="red", linetype="dashed", size=0.5)+
  geom_vline(aes(xintercept=qf(input$f.pr, df1 = input$df11, df2 = input$df21)), colour = "red")})

output$f.plot.cdf <- plotly::renderPlotly({
x0<- qf(input$f.pr, df1 = input$df11, df2 = input$df21)
mean <- input$df21/(input$df21-2)
p<-ggplot(data = data.frame(x = c(0, input$f.xlim)), mapping = aes(x = x)) +
  stat_function(fun = pf, n= 100, args = list(df1 = input$df11, df2 = input$df21)) + 
  xlim(0, input$f.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)

plotly::ggplotly(p)
})

output$f.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click7))})

output$f = renderTable({
  x <- data.frame(x.postion = qf(input$f.pr, df1 = input$df11, df2 = input$df21))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


F = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rf(input$f.size, input$df11, input$df21))
  return(df)})

output$download7 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(F(), file)
    }
  )

output$table4 = renderDataTable({head(F(), n = 100L)},  options = list(pageLength = 10))

output$f.plot2 = plotly::renderPlotly({
  df = F()
  x <- names(df)
p<-plot_hist1c(df, x, input$f.bin)
plotly::ggplotly(p)

})

output$f.sum = renderTable({
  x = F()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$f.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


