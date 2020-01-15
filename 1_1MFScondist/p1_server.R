###---------- 1.1 Normal Distribution ----------

output$norm.plot <- renderPlot({
  
  mynorm = function (x) {
  norm = dnorm(x, input$mu, input$sigma)
  norm[x<=(input$mu-input$n*input$sigma) |x>=(input$mu+input$n*input$sigma)] = NA
  return(norm)
  }

  ggplot(data = data.frame(x = c(-(input$xlim), input$xlim)), aes(x)) +
  stat_function(fun = dnorm, n = 101, args = list(mean = input$mu, sd = input$sigma)) + 
  scale_y_continuous(breaks = NULL) +
  stat_function(fun = mynorm, geom = "area", fill="cornflowerblue", alpha = 0.3) + 
  scale_x_continuous(breaks = c(-input$xlim, input$xlim))+
  ylab("Density") + 
  theme_minimal() + 
  ggtitle("Normal distribution")+
  geom_vline(aes(xintercept=input$mu), color="red", linetype="dashed", size=0.5) +
  geom_vline(aes(xintercept=qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)), color="red", size=0.5) })

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
  digits = 6, colnames=FALSE, rownames=TRUE, width = "500px")

N = reactive({ 
  df = data.frame(x = rnorm(input$size, input$mu, input$sigma))
  return(df)})



output$norm.plot2 = renderPlot(
{df = N()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("Histogram of Random Numbers")+
ylab("Frequency")+ geom_histogram(binwidth = input$bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-input$xlim, input$xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm = FALSE)), color="red", size=0.5)
})


output$sum = renderTable({
  x = N()[,1]
  x <- matrix(c(mean(x), sd(x), quantile(x, probs = input$pr)),3,1)
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "500px")

output$info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click2))})

output$download1 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(N(), file)
    }
  )

NN <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.1 <- renderPlot({
  x = NN()
  ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin1, position = "identity") + 
  xlab("") + 
  ggtitle("Histogram") + 
  theme_minimal() + 
  theme(legend.title =element_blank())
  #plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())+geom_vline(aes(xintercept=quantile(x[,1], probs = input$pr, na.rm = FALSE)), color="red", size=0.5)
 
  #grid.arrange(plot2, plot3, ncol = 2)
  })

output$makeplot.2 <- renderPlot({
  x = NN()
  #ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin1, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  ggplot(x, aes(x = x[,1])) + 
  geom_density() + 
  ggtitle("Density Plot") + 
  xlab("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())+
  geom_vline(aes(xintercept=quantile(x[,1], probs = input$pr, na.rm = FALSE)), color="red", size=0.5)
 
  #grid.arrange(plot2, plot3, ncol = 2)
  })

output$sum2 = renderTable({
  x = NN()[,1]
  x <- matrix(c(mean(x), sd(x), quantile(x, probs = input$pr)),3,1)
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "500px")




