
#****************************************************************************************************************************************************2. poisson
P = reactive({
x1 = ppois(0:(input$k2-1), input$lad)
x2 = ppois(1:input$k2, input$lad)
x = x2-x1
data = data.frame(x0 = c(0:length(x)), Pr.at.x0 = round(c(x1[1], x), 6), Pr.x0.cumulated = round(ppois(0:input$k2, input$lad), 6))
return(data) 
})

output$p.plot <- plotly::renderPlotly({
X = P()
obs = X$x0[input$k+1]
y = X$Pr.at.x0[input$k+1]
x0= X[,"x0"]
prob = X[,"Pr.at.x0"]
p <-ggplot(X, aes(x0, prob)) + geom_step(size=0.3) + 
  geom_point(aes(x = obs, y = y),color = "red", size = 2) +
  stat_function(fun = dnorm, args = list(mean = input$lad, sd = sqrt(input$lad)), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) + 
  xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("")
plotly::ggplotly(p)
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

output$p.plot2 <- plotly::renderPlotly({
  df = N.p()
  x <- names(df)
p<-plot_hist1c(df, x, input$bin.p)
plotly::ggplotly(p)
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
    x <- as.numeric(unlist(strsplit(input$x.p, "[\n,\t; ]")))
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

output$makeplot.2 <- plotly::renderPlotly({

    df = NN.p()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin1.p)
  plotly::ggplotly(p)

  })

output$sum2.p = renderTable({
  x = NN.p()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)<- "Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

