
##----------#----------#----------#----------
##
## 1MFSdistribution SERVER
##
## Language: EN
## 
## DT: 2019-01-08
## Update: 2019-12-05
##
##----------#----------#----------#----------

###---------- 2.2. exp Distribution ----------

output$e.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$e.xlim)), aes(x)) +
  stat_function(fun = "dexp", args = list(rate = input$r)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + theme_minimal() + ggtitle("") + #ylim(0, input$e.ylim) +
  geom_vline(aes(xintercept=qexp(input$e.pr, rate = input$r)), colour = "red")})

output$e.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click9))})

output$e = renderTable({
  x <- data.frame(x.postion = qexp(input$e.pr, rate = input$r))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")

E = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rexp(input$e.size, rate = input$r))
  return(df)})

output$table5 = renderDataTable({head(E(), n = 100L)},  options = list(pageLength = 10))

output$e.plot2 = renderPlot(
{df = E()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$e.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$e.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$e.pr, na.rm=TRUE)), color="red", size=0.5)})

output$e.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Position: ", "\n", xy_str(input$plot_click10))})

output$e.sum = renderTable({
  x = E()[,1]
  x <- t(data.frame(Mean = mean(x), SD = sd(x), Variance = quantile(x, probs = input$e.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")

Y <- reactive({
  inFile <- input$e.file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$x.e, "[\n,\t;]")))
    X <- as.data.frame(x)
    }
  else {
    # CSV data
    csv <- read.csv(inFile$datapath,
        header = input$e.header,
        sep = input$e.sep)[,1]
    X <- as.data.frame(csv)
    }
    colnames(X) = c("X")
    return(as.data.frame(X))
  })

output$makeplot.e <- renderPlot({
  x = Y()
  plot2 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.e, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())+geom_vline(aes(xintercept=quantile(x[,1], probs = input$e.pr, na.rm = TRUE)), color="red", size=0.5)
 
  grid.arrange(plot2, plot3, ncol = 2)
  })

output$e.sum2 = renderTable({
  x = Y()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$e.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")


