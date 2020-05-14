# ****************************************************************************************************************************************************1.4.
# beta
output$b.plot <- renderPlot({
  validate(need(input$b.xlim && input$b.shape && input$b.scale && input$b.pr, "Please input correct parameters"))
  validate(need(input$b.shape >0 && input$b.scale>0, "Please input correct parameters"))
  validate(need(input$b.pr >=0 && input$b.pr<=1, "Please input correct parameters"))
mean <- input$b.shape/(input$b.scale+input$b.shape)

  ggplot(data = data.frame(x = c(0, input$b.xlim)), aes(x)) +
  stat_function(fun = "dbeta", args = list(shape1 = input$b.shape, shape2=input$b.scale)) + 
  ylab("Density") +
  xlim(0, input$b.xlim)+
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$b.ylim) +
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=qbeta(input$b.pr, shape1 = input$b.shape, shape2=input$b.scale)), colour = "red")})

output$b.rate <- renderPrint({
  cat(paste0("Input: shape (alpha) = ", ((1 - input$b.mean) / input$b.sd^2 - 1 / input$b.mean) * input$b.mean ^ 2, 
    " and  shape (beta) = ", (((1 - input$b.mean) / input$b.sd^2 - 1 / input$b.mean) * input$b.mean ^ 2)*(1/input$b.mean-1)
    ))
  })


output$b.plot.cdf <- plotly::renderPlotly({
x0<- qbeta(input$b.pr, shape1 = input$b.shape, shape2=input$b.scale)
mean <- input$b.shape/(input$b.scale+input$b.shape)
p<-ggplot(data = data.frame(x = c(0, input$b.xlim)), mapping = aes(x = x)) +
  stat_function(fun = "pbeta", args = list(shape1 = input$b.shape, shape2=input$b.scale)) + 
  xlim(0, input$b.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)

plotly::ggplotly(p)
})


output$b.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click13))})

output$b = renderTable({
  validate(need(input$b.shape >0 && input$b.scale>0, "Please input correct parameters"))
  validate(need(input$b.pr >=0 && input$b.pr<=1, "Please input correct parameters"))

  x <- data.frame(x.postion = qbeta(input$b.pr, shape1 = input$b.shape, shape2=input$b.scale))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

##########--------------------##########--------------------##########--------------------##########--------------------##########--------------------##########
B = reactive({ # prepare dataset
  #set.seed(1)
  validate(need(input$b.size, "Please input correct parameters"))
  validate(need(input$b.pr >=0 && input$b.pr<=1, "Please input correct parameters"))
  df = data.frame(x = rbeta(input$b.size, shape1 = input$b.shape, shape2=input$b.scale))
  return(df)})

output$download4 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(B(), file)
    }
  )

output$b.plot2 = plotly::renderPlotly({
  df = B()
  x <- names(df)
p<-plot_hist1c(df, x, input$b.bin)
plotly::ggplotly(p)
})

output$b.sum = renderTable({
  x = B()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), va=quantile(x[,1], probs = input$b.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation","Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

