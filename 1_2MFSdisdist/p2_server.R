if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)

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


###---------- 3.2 Poisson Distribution ----------

P = reactive({
x1 = ppois(0:(input$k2-1), input$lad)
x2 = ppois(1:input$k2, input$lad)
x = x2-x1
data = data.frame(x0 = c(0:length(x)), Pr.at.x0 = round(c(x1[1], x), 6), Pr.x0.cumulated = round(ppois(0:input$k2, input$lad), 6))
return(data) 
})

output$p.plot <- renderPlot({
X = P()
 ggplot(X, aes(X[,"x0"],X[,"Pr.at.x0"])) + geom_step() + 
  geom_point(aes(x = X$x0[input$x0+1], y = X$Pr.at.x0[input$x0+1]),color = "red", size = 2.5) +
  stat_function(fun = dnorm, args = list(mean = input$lad, sd = sqrt(input$lad)), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) + 
  xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("")
 
   })

output$p.k = renderTable({
  x <- t(P()[(input$x0+1),])
rownames(x) <- c("Red-Dot Position", "Probability of Red-Dot Position", "Cumulated Probability of Red-Dot Position")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

N.p = reactive({ 
  df = data.frame(x = rpois(input$size.p, input$lad))
  return(df)})

output$p.plot2 <- renderPlot({
df = N.p()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$bin.p, colour = "white", fill = "cornflowerblue", size = 1)
#geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm = FALSE)), color="red", size=0.5)

})

output$sum.p = renderTable({
  x = N.p()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x) <-"Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

output$download2 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(N.p(), file)
    }
  )


NN.p <- reactive({
  inFile <- input$file.p
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$col.p){
    csv <- read.csv(inFile$datapath, header = input$header.p, sep = input$sep.p, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header.p, sep = input$sep.p)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.2 <- renderPlot({
  x = NN.p()
  ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin1.p, position = "identity") + 
  xlab("") + 
  ggtitle("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())
  
  #plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())+geom_vline(aes(xintercept=quantile(x[,1], probs = input$pr, na.rm = FALSE)), color="red", size=0.5)
 
  #grid.arrange(plot2, plot3, ncol = 2)
  })

output$sum2.p = renderTable({
  x = NN.p()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)<- "Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

