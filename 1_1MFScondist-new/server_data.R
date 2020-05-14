#****************************************************************************************************************************************************1.1. Normal
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
  x0<- quantile(df[,x], probs = input$pr.data, na.rm=TRUE)
  p<-plot_hist1(df, x, input$bin1)
  plotly::ggplotly(p)
  })

output$makeplot.2 <- plotly::renderPlotly({
  
  df = NN()
  x <- names(df)
  x0<- quantile(df[,x], probs = input$pr.data, na.rm=TRUE)
  p<-plot_density1(df, x)
  p<-p+geom_vline(aes(xintercept=x0), color="red", size=0.3)
  plotly::ggplotly(p)
  })

output$makeplot.3 <- plotly::renderPlotly({
  
  df = NN()
  x <- df[,1]
  p<- ggplot(df, aes(x)) + stat_ecdf(geom = "point")+
  ylab("Cumulative Density Function") + 
  theme_minimal()
  plotly::ggplotly(p)
  })

output$sum2 = renderTable({
  x = NN()[,1]
  x <- matrix(c(mean(x), sd(x), quantile(x, probs = input$pr.data)),3,1)
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")




