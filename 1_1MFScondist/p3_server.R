###---------- 2.3 Gamma distribution ----------

output$g.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$g.xlim)), aes(x)) +
  stat_function(fun = "dgamma", args = list(shape = input$g.shape, scale=input$g.scale)) + 
  ylab("Density") +
  theme_minimal() + 
  ggtitle("Gamma distribution")+
  scale_y_continuous(breaks = NULL) + #ylim(0, input$g.ylim) +
  geom_vline(aes(xintercept=qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale)), colour = "red")
  })

output$g.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click11))})

output$g = renderTable({
  x <- data.frame(x.postion = qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")

G = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rgamma(input$g.size, shape = input$g.shape, scale=input$g.scale))
  return(df)})

output$download3 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(G(), file)
    }
  )

output$g.plot2 = renderPlot(
{df = G()
ggplot(df, aes(x = x)) + 
ylab("Frequency")+ 
theme_minimal() + 
ggtitle("Histogram of Random Numbers")+
geom_histogram(binwidth = input$g.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$g.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$g.pr, na.rm = FALSE)), color="red", size=0.5)})

output$g.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Click Position: ", "\n", xy_str(input$plot_click12))})

output$g.sum = renderTable({
  x = G()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1])))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")

Z <- reactive({
  inFile <- input$g.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.g, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$col){
    csv <- read.csv(inFile$datapath, header = input$g.header, sep = input$g.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$g.header, sep = input$g.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.g1 <- renderPlot({
  x = Z()
  ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.g, position = "identity") + 
  xlab("") + 
  ggtitle("Histogram") + 
  theme_minimal() + 
  theme(legend.title =element_blank())
 
  })

output$makeplot.g2 <- renderPlot({
  x = Z()
  ggplot(x, aes(x = x[,1])) + 
  geom_density() + 
  ggtitle("Density Plot") + 
  xlab("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())+ 
  geom_vline(aes(xintercept=quantile(x[,1], probs = input$g.pr, na.rm = FALSE)), color="red", size=0.5)
 
  })

output$g.sum2 = renderTable({
  x = Z()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance =quantile(x[,1], probs = input$g.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")
