#****************************************************************************************************************************************************1.2. Exp distribution
output$e.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$e.xlim)), aes(x)) +
  stat_function(fun = "dexp", args = list(rate = input$r)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$e.ylim) +
  geom_vline(aes(xintercept=qexp(input$e.pr, rate = input$r)), colour = "red")
  })

output$e.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click9))})

output$e = renderTable({
  x <- data.frame(x.postion = qexp(input$e.pr, rate = input$r))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

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
p<-p+geom_vline(aes(xintercept=quantile(x, probs = input$e.pr, na.rm=TRUE)), color="red", size=0.3)
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
  p<-p+geom_vline(aes(xintercept=quantile(df[,x], probs = input$e.pr, na.rm=TRUE)), color="red", size=0.3)
  plotly::ggplotly(p)

   })
output$makeplot.e2 <- plotly::renderPlotly({
  df = Y()
  x <- names(df)
  p<-plot_density1(df, x)
  p<- p+geom_vline(aes(xintercept=quantile(df[,x], probs = input$e.pr, na.rm = TRUE)), color="red", size=0.3)
  plotly::ggplotly(p)
   })

output$e.sum2 = renderTable({
  x = Y()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$e.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


