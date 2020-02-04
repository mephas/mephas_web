#****************************************************************************************************************************************************1.1. Normal
output$norm.plot <- renderPlot({
  
  mynorm = function (x) {
  norm = dnorm(x, input$mu, input$sigma)
  norm[x<=(input$mu-input$n*input$sigma) |x>=(input$mu+input$n*input$sigma)] = NA
  return(norm)
  }

  ggplot(data = data.frame(x = c(-(input$xlim), input$xlim)), aes(x)) +
  stat_function(fun = dnorm, n = 101, args = list(mean = input$mu, sd = input$sigma)) + 
  scale_y_continuous(breaks = NULL) +
  stat_function(fun = mynorm, geom = "area", fill="cornflowerblue", alpha = 0.3) + 
  scale_x_continuous(breaks = c(-input$xlim, input$xlim))+
  ylab("Density") + 
  theme_minimal() + 
  ggtitle("")+
  geom_vline(aes(xintercept=input$mu), color="red", linetype="dashed", size=0.5) +
  geom_vline(aes(xintercept=qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)), color="red", size=0.5) })

output$info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click))})

output$xs = renderTable({
  a = qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)
  b = 100*pnorm(input$mu+input$n*input$sigma, input$mu, input$sigma)-pnorm(input$mu-input$n*input$sigma, input$mu, input$sigma)
  x <- t(data.frame(x.position = a, blue.area = b))
  rownames(x) <- c("Red-line Position (x0)", "Blue Area, Probability %")
  return(x)}, 
  digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

N = reactive({ 
  df = data.frame(x = rnorm(input$size, input$mu, input$sigma))
  return(df)})



output$norm.plot2 = plotly::renderPlotly({

  df = N()
  x <- names(df)
p<-plot_hist1c(df, x, input$bin)
p<-p+geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm=TRUE)), color="red", size=0.3)
plotly::ggplotly(p)
})


output$sum = renderTable({
  x = N()[,1]
  x <- matrix(c(mean(x), sd(x), quantile(x, probs = input$pr)),3,1)
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
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

output$NN <- DT::renderDT({NN()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 200,
      scroller = TRUE))

output$makeplot.1 <- plotly::renderPlotly({

  df = NN()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin1)
  p<-p+geom_vline(aes(xintercept=quantile(df[,x], probs = input$pr, na.rm=TRUE)), color="red", size=0.3)
  plotly::ggplotly(p)
  })

output$makeplot.2 <- plotly::renderPlotly({
  
  df = NN()
  x <- names(df)
  p<-plot_density1(df, x)
  p<-p+geom_vline(aes(xintercept=quantile(df[,x], probs = input$pr, na.rm=TRUE)), color="red", size=0.3)
  plotly::ggplotly(p)
  })

output$sum2 = renderTable({
  x = NN()[,1]
  x <- matrix(c(mean(x), sd(x), quantile(x, probs = input$pr)),3,1)
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")




