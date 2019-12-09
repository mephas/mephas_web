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

###---------- 2.3 F distribution ----------
output$f.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$f.xlim)), aes(x)) +
  stat_function(fun = "df", n= 100, args = list(df1 = input$df11, df2 = input$df21)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + theme_minimal() + ggtitle("") + ylim(0, input$f.ylim) +
  geom_vline(aes(xintercept=qf(input$f.pr, df1 = input$df11, df2 = input$df21)), colour = "red")})

output$f.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click7))})

output$f = renderTable({
  x <- data.frame(x.postion = qf(input$f.pr, df1 = input$df11, df2 = input$df21))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")


F = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rf(input$f.size, input$df11, input$df21))
  return(df)})

output$table4 = renderDataTable({head(F(), n = 100L)},  options = list(pageLength = 10))

output$f.plot2 = renderPlot(
{df = F()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$f.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$f.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$f.pr, na.rm = FALSE)), color="red", size=0.5)})

output$f.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Position: ", "\n", xy_str(input$plot_click8))})

output$f.sum = renderTable({
  x = F()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1])))
  rownames(x) <- c("Mean", "Standard Deviation", "Variance")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")


FF <- reactive({
  inFile <- input$f.file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$x.f, "[\n, \t, ]")))
    X <- as.data.frame(x)
    }
  else {
    # CSV data
    csv <- read.csv(inFile$datapath,
        header = input$f.header,
        sep = input$f.sep)
    X <- as.data.frame(csv)
    }
    colnames(X) = c("X")
    return(X)
  })

output$makeplot.f <- renderPlot({
  x = as.data.frame(FF())
  plot2 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.f, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())
 
  grid.arrange(plot2, plot3, ncol = 2)
  })

