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

###---------- T ----------

output$t.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-input$t.xlim, input$t.xlim)), aes(x)) + 
  stat_function(fun = dt, n = 100, args = list(df = input$t.df)) + 
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), color = "cornflowerblue") +
  ylab("Density") + scale_y_continuous(breaks = NULL) + theme_minimal() + #ylim(0, input$t.ylim) + 
  theme_bw() + geom_vline(aes(xintercept=qt(input$t.pr, df = input$t.df)), colour = "red")})

output$t.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click3))})

output$t = renderTable({
  x <-data.frame(x.position = qt(input$t.pr, df = input$t.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")


T = reactive({ # prepare dataset
 #set.seed(1)
  df = data.frame(x = rt(input$t.size, input$t.df))
  return(df)})

output$table2 = renderDataTable({head(T(), n = 100L)},  options = list(pageLength = 10))

output$t.plot2 = renderPlot(
{df = T()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$t.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-input$t.xlim, input$t.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$t.pr, na.rm = FALSE)), color="red", size=0.5)
})

output$t.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click4))})

output$t.sum = renderTable({
  x = T()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$t.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")


TT <- reactive({
  inFile <- input$t.file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$x.t, "[\n, \t, ]")))
    X <- as.data.frame(x)
    }
  else {
    # CSV data
    csv <- read.csv(inFile$datapath,
        header = input$t.header,
        sep = input$t.sep)[,1]
    X <- as.data.frame(csv)
    }
    colnames(X) = c("X")
    return(X)
  })

output$makeplot.t <- renderPlot({
  x = as.data.frame(TT())
  plot2 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.t, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank()) + geom_vline(aes(xintercept=quantile(x[,1], probs = input$t.pr, na.rm = FALSE)), color="red", size=0.5)
 
  grid.arrange(plot2, plot3, ncol = 2)
  })

output$t.sum2 = renderTable({
  x = TT()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$t.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")
