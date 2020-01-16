#****************************************************************************************************************************************************1. binom
B = reactive({
  x1 = pbinom(0:(input$m-1), input$m, input$p)
  x2 = pbinom(1:input$m, input$m, input$p)
  x = x2-x1
  data = data.frame(x0 = c(0:length(x)), Pr.at.x0 = round(c(0, x), 6), Pr.x0.cumulated = round(c(0, x2), 6))
  return(data) 
})

output$b.plot <- renderPlot({
X = B()
 ggplot(X, aes(X[,"x0"], X[,"Pr.at.x0"])) + geom_step() + 
  geom_point(aes(x = X$x0[input$k+1], y = X$Pr.at.x0[input$k+1]),color = "red", size = 2.5) +
  stat_function(fun = dnorm, args = list(mean = input$m*input$p, sd = sqrt(input$m*input$p*(1-input$p))), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) + 
  xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("")

})

output$b.k = renderTable({
  x <- t(B()[(input$k+1),])
  rownames(x) <- c("Red-Dot Position", "Probability of Red-Dot Position", "Cumulated Probability of Red-Dot Position")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

N = reactive({ 
  df = data.frame(x = rbinom(input$size, input$m, input$p))
  return(df)})

output$b.plot2 <- renderPlot({
df = N()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$bin, colour = "white", fill = "cornflowerblue", size = 1)
#geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm = FALSE)), color="red", size=0.5)

})


output$sum = renderTable({
  x = N()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

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
  ggtitle("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())

  })

output$sum2 = renderTable({
  x = NN()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

