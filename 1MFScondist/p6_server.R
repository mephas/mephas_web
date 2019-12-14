#----------#----------#----------#----------
##
## 1MFSdistribution SERVER
##
## Language: EN
## 
## DT: 2019-01-08
## Update: 2019-12-05
##
##----------#----------#----------#----------

###---------- 1.3 chi Distribution ----------

output$x.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$x.xlim)), aes(x)) +
  stat_function(fun = dchisq, n = 100, args = list(df = input$x.df)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + theme_minimal() + ggtitle("") + #ylim(0, input$x.ylim) +
  geom_vline(aes(xintercept=qchisq(input$x.pr, df = input$x.df)), colour = "red")})

output$x.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click5))})

output$xn = renderTable({
  x <- data.frame(x.postion = qchisq(input$x.pr, df = input$x.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")

X = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rchisq(input$x.size, input$x.df))
  return(df)})

output$x.plot2 = renderPlot(
{df = X()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$x.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$x.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$x.pr, na.rm = FALSE)), color="red", size=0.5)})

output$x.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click6))})

output$x.sum = renderTable({
  x = X()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")

XX <- reactive({
  inFile <- input$x.file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$x.x, "[\n, \t, ]")))
    X <- as.data.frame(x)
    }
  else {
    # CSV data
    csv <- read.csv(inFile$datapath,
        header = input$x.header,
        sep = input$x.sep)[,1]
    X <- as.data.frame(csv)
    }
    colnames(X) = c("X")
    return(X)
  })

output$makeplot.x <- renderPlot({
  x = as.data.frame(XX())
  plot2 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.x, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())+ geom_vline(aes(xintercept=quantile(x[,1], probs = input$x.pr, na.rm = FALSE)), color="red", size=0.5)
 
  grid.arrange(plot2, plot3, ncol = 2)
  })

output$x.sum2 = renderTable({
  x = XX()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")
