###---------- T ----------

output$t.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-input$t.xlim, input$t.xlim)), aes(x)) + 
  stat_function(fun = dt, n = 100, args = list(df = input$t.df)) + 
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), color = "cornflowerblue") +
  ylab("Density") + 
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("")+
  geom_vline(aes(xintercept=qt(input$t.pr, df = input$t.df)), colour = "red")})

output$t.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click3))})

output$t = renderTable({
  x <-data.frame(x.position = qt(input$t.pr, df = input$t.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


T = reactive({ # prepare dataset
 #set.seed(1)
  df = data.frame(x = rt(input$t.size, input$t.df))
  return(df)})

output$download5 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(T(), file)
    }
  )

output$table2 = renderDataTable({head(T(), n = 100L)},  options = list(pageLength = 10))

output$t.plot2 = renderPlot(
{df = T()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$t.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-input$t.xlim, input$t.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$t.pr, na.rm = FALSE)), color="red", size=0.5)
})

output$t.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click4))})

output$t.sum = renderTable({
  x = T()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$t.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


TT <- reactive({
  inFile <- input$t.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.t, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$t.col){
    csv <- read.csv(inFile$datapath, header = input$t.header, sep = input$t.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$t.header, sep = input$t.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })


output$makeplot.t1 <- renderPlot({
  x = as.data.frame(TT())
  ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.t, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
   })
output$makeplot.t2 <- renderPlot({
  x = as.data.frame(TT())
  ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title =element_blank()) + geom_vline(aes(xintercept=quantile(x[,1], probs = input$t.pr, na.rm = FALSE)), color="red", size=0.5)
   })

output$t.sum2 = renderTable({
  x = TT()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$t.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")
