###---------- 1.3 chi Distribution ----------

output$x.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$x.xlim)), aes(x)) +
  stat_function(fun = dchisq, n = 100, args = list(df = input$x.df)) + 
  ylab("Density") +
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$x.ylim) +
  geom_vline(aes(xintercept=qchisq(input$x.pr, df = input$x.df)), colour = "red")})

output$x.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click5))})

output$xn = renderTable({
  x <- data.frame(x.postion = qchisq(input$x.pr, df = input$x.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "50%")

X = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rchisq(input$x.size, input$x.df))
  return(df)})

output$download6 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(X(), file)
    }
  )

output$x.plot2 = renderPlot(
{df = X()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$x.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$x.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$x.pr, na.rm = FALSE)), color="red", size=0.5)})

output$x.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click6))})

output$x.sum = renderTable({
  x = X()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "50%")

XX <- reactive({
  inFile <- input$x.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.x, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$x.col){
    csv <- read.csv(inFile$datapath, header = input$x.header, sep = input$x.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$x.header, sep = input$x.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.x1 <- renderPlot({
  x = as.data.frame(XX())
  ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.x, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
   })
output$makeplot.x2 <- renderPlot({
  x = as.data.frame(XX())
ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title =element_blank())+ geom_vline(aes(xintercept=quantile(x[,1], probs = input$x.pr, na.rm = FALSE)), color="red", size=0.5)
   })

output$x.sum2 = renderTable({
  x = XX()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "50%")
