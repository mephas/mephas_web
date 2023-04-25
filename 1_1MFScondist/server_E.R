#****************************************************************************************************************************************************1.2. Exp distribution
output$e.plot <- renderPlot({
  ggplot(data = data.frame(x = c(0, input$e.xlim)), aes(x)) +
  stat_function(fun = dexp, args = list(rate = input$r)) + 
  ylab("Density") +
  xlim(0, input$e.xlim)+
  #scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$e.ylim) +
  geom_vline(aes(xintercept=1/input$r), color="red", linetype="dashed", size=0.5)+
  geom_vline(aes(xintercept=qexp(input$e.pr, rate = input$r)), colour = "red", size=0.5)
  })

output$e.rate <- renderPrint({
  cat(paste0("Input: Rate = ", 1/input$e.mean))
  })

output$e.plot.cdf <- renderPlot({
x0<- qexp(input$e.pr, rate = input$r)
mean <- 1/input$r
p<-ggplot(data = data.frame(x = c(0, input$e.xlim)), mapping = aes(x = x)) +
  stat_function(fun = pexp, args = list(rate = input$r)) + 
  xlim(0, input$e.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)

# plotly::ggplotly(p)
})

output$e.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click9))})

output$e = renderPrint({
  x <- data.frame(x.postion = qexp(input$e.pr, rate = input$r))
  cat(paste0("x0 = ", x))
  })

E = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rexp(input$e.size, rate = input$r))
  return(df)})

output$download2 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(E(), file)
    }
  )

output$e.plot2 = plotly::renderPlotly({
  df = E()
  x <- names(df)
p<-plot_hist1c(df, x, input$e.bin)
plotly::ggplotly(p)
})

output$e.sum = renderTable({
  x = E()[,1]
  x <- t(data.frame(Mean = mean(x), SD = sd(x), Variance = quantile(x, probs = input$e.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

Y <- reactive({
  inFile <- input$e.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.e, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$e.col){
    csv <- read.csv(inFile$datapath, header = input$e.header, sep = input$e.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$e.header, sep = input$e.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$Y <- DT::renderDT({Y()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 200,
      scroller = TRUE))

output$makeplot.e1 <- plotly::renderPlotly({
  df = Y()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin.e)
  plotly::ggplotly(p)

   })
output$makeplot.e2 <- plotly::renderPlotly({
  df = Y()
  x <- names(df)
  x0<- quantile(df[,x], probs = input$e.pr, na.rm = TRUE)
  p<-plot_density1(df, x)
  p<- p+geom_vline(aes(xintercept=x0), color="red", size=0.3)
  plotly::ggplotly(p)
   })

output$makeplot.e3 <- plotly::renderPlotly({
  
  df = Y()
  x <- df[,1]  
  p<- ggplot(df, aes(x)) + stat_ecdf(geom = "point")+
  ylab("Cumulative Density Function") + 
  theme_minimal()
  plotly::ggplotly(p)
  })

output$e.sum2 = renderTable({
  x = Y()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$e.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


