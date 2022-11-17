#****************************************************************************************************************************************************1.1. Normal
output$norm.plot <- renderPlot({
  
  mynorm = function (x) {
  norm = dnorm(x, input$mu, input$sigma)
  norm[x<=(input$mu-input$n*input$sigma) |x>=(input$mu+input$n*input$sigma)] = NA
  return(norm)
  }

  #myprob = function (x) {
  #norm = dnorm(x, input$mu, input$sigma)
  #norm[x>qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)] = NA
  #return(norm)
  #}

  ggplot(data = data.frame(x = c(-(input$xlim), input$xlim)), aes(x)) +
  stat_function(fun = dnorm, args = list(mean = input$mu, sd = input$sigma)) + 
  #scale_y_continuous(breaks = NULL) +
  stat_function(fun = mynorm, geom = "area", fill="cornflowerblue", alpha = 0.3) + 
  #stat_function(fun = myprob, geom = "area", fill="red", alpha = 0.1) + 
  xlim(-input$xlim, input$xlim)+
  ylab("Density Function") + 
  theme_minimal() + 
  ggtitle("")+
  geom_vline(aes(xintercept=input$mu), color="red", linetype="dashed", size=0.5)+
  geom_vline(aes(xintercept=qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)), color="red", size=0.5)
})


output$norm.plot.cdf <- plotly::renderPlotly({
x0<- qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)
mean <- input$mu
p<-ggplot(data = data.frame(x = c(-input$xlim, input$xlim)), mapping = aes(x = x)) +
  stat_function(fun = pnorm, args = list(mean = input$mu, sd = input$sigma))+
  xlim(-input$xlim, input$xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)

plotly::ggplotly(p)
})


output$info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click))})

output$xs = renderTable({
  a = qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)
  b = 100*pnorm(input$mu+input$n*input$sigma, input$mu, input$sigma)-pnorm(input$mu-input$n*input$sigma, input$mu, input$sigma)
  x <- t(data.frame(x.position = a, blue.area = b))
  rownames(x) <- c("Red-line Position (x0)", "Blue Area, Probability %")
  return(x)}, 
  digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


N = reactive({ 
  df = data.frame(x = rnorm(input$size, input$mu, input$sigma))
  return(df)})



output$norm.plot2 = plotly::renderPlotly({

  df = N()
  x <- names(df)
p<-plot_hist1c(df, x, input$bin) 
plotly::ggplotly(p)
})


output$sum = renderTable({
  x = N()[,1]
  x <- matrix(c(mean(x), sd(x), quantile(x, probs = input$pr)),3,1)
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position, Pr(X<x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

output$download1 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(N(), file)
    }
  )

