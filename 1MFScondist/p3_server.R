
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

###---------- 2.3 Gamma distribution ----------

output$g.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$g.xlim)), aes(x)) +
  stat_function(fun = "dgamma", args = list(shape = input$g.shape, scale=input$g.scale)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + theme_minimal() + ggtitle("") + ylim(0, input$g.ylim) +
  geom_vline(aes(xintercept=qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale)), colour = "red")})

output$g.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click11))})

output$g = renderTable({
  x <- data.frame(x.postion = qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")

G = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rgamma(input$g.size, shape = input$g.shape, scale=input$g.scale))
  return(df)})

output$g.plot2 = renderPlot(
{df = G()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$g.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$g.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$g.pr, na.rm = FALSE)), color="red", size=0.5)})

output$g.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Position: ", "\n", xy_str(input$plot_click12))})

output$g.sum = renderTable({
  x = G()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1])))
  rownames(x) <- c("Mean", "Standard Deviation", "Variance")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")

Z <- reactive({
  inFile <- input$g.file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$x.g, "[\n, \t, ]")))
    X <- as.data.frame(x)
    }
  else {
    # CSV data
    csv <- read.csv(inFile$datapath,
        header = input$g.header,
        sep = input$g.sep)
    X <- as.data.frame(csv)
    }
    colnames(X) = c("X")
    return(X)
  })

output$makeplot.g <- renderPlot({
  x = as.data.frame(Z())
  plot2 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.g, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())
 
  grid.arrange(plot2, plot3, ncol = 2)
  })

