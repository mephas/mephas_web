#****************************************************************************************************************************************************1. binom
B = reactive({
  x1 = pbinom(0:(input$m-1), input$m, input$p)
  x2 = pbinom(1:input$m, input$m, input$p)
  x = x2-x1
  data = data.frame(x0 = c(0:length(x)), Pr.at.x0 = round(c(0, x), 6), Pr.x0.cumulated = round(c(0, x2), 6))
  return(data) 
})

output$b.plot <- plotly::renderPlotly({
X = B()
obs = X$x0[input$k+1]
y = X$Pr.at.x0[input$k+1]
x0= X[,"x0"]
prob = X[,"Pr.at.x0"]
mean <- input$m*input$p
p <-ggplot(X, aes(x0, prob)) + geom_step(size=0.3) + 
  geom_point(aes(x = obs, y = y),color = "red", size = 2) +
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  stat_function(fun = dnorm, args = list(mean = input$m*input$p, sd = sqrt(input$m*input$p*(1-input$p))), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) + 
  xlab("") + ylab("Probability Mass Function")  + theme_minimal() + ggtitle("")
plotly::ggplotly(p)
})


output$b.plot.cdf <- plotly::renderPlotly({
#x0<- qbinom(input$e.pr, rate = input$r)
X = B()
obs = X$x0[input$k+1]
y = X$Pr.x0.cumulated[input$k+1]
mean <- input$m*input$p
x0= X[,"x0"]
prob = X[,"Pr.x0.cumulated"]
p<-ggplot(X, aes(x0, prob)) + geom_step(size=0.3) + 
  #stat_function(fun = ~ pbinom(q = .,input$m, input$p))+
  geom_point(aes(x = obs, y = y),color = "red", size = 2) +
  #xlim(c(1:input$m))+
  ylab("Cumulative Mass Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)
  #geom_vline(aes(xintercept=x0), color="red", size=0.3)

plotly::ggplotly(p)
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

output$b.plot2 <- plotly::renderPlotly({

  df = N()
  x <- names(df)
p<-plot_hist1c(df, x, input$bin)
plotly::ggplotly(p)
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

output$makeplot.1 <- plotly::renderPlotly({
  df = NN()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin1)
  plotly::ggplotly(p)

  })

output$makeplot.11 <- plotly::renderPlotly({
  df = NN()
  x <- df[,1]  
  p<- ggplot(df, aes(x)) + stat_ecdf(geom = "point")+
  ylab("Cumulative Mass Function") + 
  theme_minimal()
  plotly::ggplotly(p)
  })

output$sum2 = renderTable({
  x = NN()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

