#****************************************************************************************************************************************************1.2. Exp distribution
output$e.plot <- renderPlot({
  ggplot(data = data.frame(x = c(0, input$e.xlim)), aes(x)) +
  stat_function(fun = dexp, args = list(rate = input$r)) + 
  ylab("Density") +
  xlim(0, input$e.xlim)+
  #scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$e.ylim) +
  geom_vline(aes(xintercept=1/input$r), color="red", linetype="dashed", size=0.5)+
  geom_vline(aes(xintercept=qexp(input$e.pr, rate = input$r)), colour = "red", size=0.5)
  })

output$e.rate <- renderPrint({
  cat(paste0("Input: Rate = ", 1/input$e.mean))
  })

output$e.plot.cdf <- plotly::renderPlotly({
x0<- qexp(input$e.pr, rate = input$r)
mean <- 1/input$r
p<-ggplot(data = data.frame(x = c(0, input$e.xlim)), mapping = aes(x = x)) +
  stat_function(fun = pexp, args = list(rate = input$r)) + 
  xlim(0, input$e.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)

plotly::ggplotly(p)
})

output$e.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click9))})

output$e = renderPrint({
  x <- data.frame(x.postion = qexp(input$e.pr, rate = input$r))
  cat(paste0("x0 = ", x))
  })

E = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rexp(input$e.size, rate = input$r))
  return(df)})

output$download2 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(E(), file)
    }
  )

output$e.plot2 = plotly::renderPlotly({
  df = E()
  x <- names(df)
p<-plot_hist1c(df, x, input$e.bin)
plotly::ggplotly(p)
})

output$e.sum = renderTable({
  x = E()[,1]
  x <- t(data.frame(Mean = mean(x), SD = sd(x), Variance = quantile(x, probs = input$e.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

