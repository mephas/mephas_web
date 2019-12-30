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



##---------- 3. Discrete RV ----------
###----------3.1 Binomial Distribution ----------

B = reactive({
  x1 = pbinom(0:(input$m-1), input$m, input$p)
  x2 = pbinom(1:input$m, input$m, input$p)
  x = x2-x1
  data = data.frame(x0 = c(0:length(x)), Pr.at.x0 = round(c(0, x), 6), Pr.x0.cumulated = round(c(0, x2), 6))
  return(data) 
})

output$b.plot <- plotly::renderPlotly({
X = B()
p<-ggplot(X, aes(X[,"x0"], X[,"Pr.at.x0"])) + geom_step() + 
  geom_point(aes(x = X$x0[input$k+1], y = X$Pr.at.x0[input$k+1]),color = "red", size = 2.5) +
  stat_function(fun = dnorm, args = list(mean = input$m*input$p, sd = sqrt(input$m*input$p*(1-input$p))), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) + 
  xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("Binomial Probability")
ggplotly(p)
})

output$b.k = DT::renderDT({
  x <- t(B()[(input$k+1),])
  rownames(x) <- c("Red-Dot Position", "Probability of Red-Dot Position", "Cumulated Probability of Red-Dot Position")
  colnames(x)="Result"
  return(round(x,6))
  })

N = reactive({ 
  df = data.frame(x = rbinom(input$size, input$m, input$p))
  return(df)})

output$b.plot2 <- plotly::renderPlotly({
df = N()
p <- ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("Histogram of Random Numbers")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$bin, colour = "white", fill = "cornflowerblue", size = 1)
#geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm = FALSE)), color="red", size=0.5)
ggplotly(p)
})

output$sum = DT::renderDT({
  x = N()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)="Result"
  return(round(x,6))
  })

output$simdata = DT::renderDT({N()},
  class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE,
    scrollY = 290,
    scroller = TRUE)
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

output$makeplot.1 <- plotly::renderPlotly({
  x = NN()
  p <-ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin1, position = "identity") + 
  xlab("") + 
  ggtitle("Histogram") + 
  theme_minimal() + 
  theme(legend.title =element_blank())
  ggplotly(p)
  #plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())+geom_vline(aes(xintercept=quantile(x[,1], probs = input$pr, na.rm = FALSE)), color="red", size=0.5)
 
  #grid.arrange(plot2, plot3, ncol = 2)
  })

output$sum2 = DT::renderDT({
  x = NN()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)="Result"
  return(round(x,6))
  })

