#****************************************************************************************************************************************************1.4. beta
output$b.plot <- renderPlot({
  validate(need(input$b.xlim && input$b.shape && input$b.scale && input$b.pr, "Please input correct parameters"))
  validate(need(input$b.shape >0 && input$b.scale>0, "Please input correct parameters"))
  validate(need(input$b.pr >=0 && input$b.pr<=1, "Please input correct parameters"))

  ggplot(data = data.frame(x = c(-0.1, input$b.xlim)), aes(x)) +
  stat_function(fun = "dbeta", args = list(shape1 = input$b.shape, shape2=input$b.scale)) + 
  ylab("Density") +
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$b.ylim) +
  geom_vline(aes(xintercept=qbeta(input$b.pr, shape1 = input$b.shape, shape2=input$b.scale)), colour = "red")})

output$b.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click13))})

output$b = renderTable({
  validate(need(input$b.shape >0 && input$b.scale>0, "Please input correct parameters"))
  validate(need(input$b.pr >=0 && input$b.pr<=1, "Please input correct parameters"))

  x <- data.frame(x.postion = qbeta(input$b.pr, shape1 = input$b.shape, shape2=input$b.scale))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

##########--------------------##########--------------------##########--------------------##########--------------------##########--------------------##########
B = reactive({ # prepare dataset
  #set.seed(1)
  validate(need(input$b.size, "Please input correct parameters"))
  validate(need(input$b.pr >=0 && input$b.pr<=1, "Please input correct parameters"))
  df = data.frame(x = rbeta(input$b.size, shape1 = input$b.shape, shape2=input$b.scale))
  return(df)})

output$download4 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(B(), file)
    }
  )

output$b.plot2 = plotly::renderPlotly({
  df = B()
  x <- names(df)
p<-plot_hist1c(df, x, input$b.bin)
p<-p+geom_vline(aes(xintercept=quantile(x, probs = input$b.pr, na.rm=TRUE)), color="red", size=0.3)
plotly::ggplotly(p)
})

output$b.sum = renderTable({
  x = B()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), va=quantile(x[,1], probs = input$b.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation","Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


##########--------------------##########--------------------##########--------------------##########--------------------##########--------------------##########

ZZ <- reactive({
  inFile <- input$b.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.b, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$b.col){
    csv <- read.csv(inFile$datapath, header = input$b.header, sep = input$b.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$b.header, sep = input$b.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$ZZ <- DT::renderDT({ZZ()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 200,
      scroller = TRUE))

output$makeplot.b1 <- plotly::renderPlotly({
  df = ZZ()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin.b)
  p<-p+geom_vline(aes(xintercept=quantile(df[,x], probs = input$b.pr, na.rm=TRUE)), color="red", size=0.3)
  plotly::ggplotly(p)
   })

output$makeplot.b2 <- plotly::renderPlotly({
  df = ZZ()
  x <- names(df)
  p<-plot_density1(df, x)
  p<- p+geom_vline(aes(xintercept=quantile(df[,x], probs = input$b.pr, na.rm = TRUE)), color="red", size=0.3)
  plotly::ggplotly(p)
   })

output$b.sum2 = renderTable({
  x = ZZ()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance =quantile(x[,1], probs = input$b.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


