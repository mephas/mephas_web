#****************************************************************************************************************************************************1.3. gamma
output$g.plot <- renderPlot({
  ggplot(data = data.frame(x = c(0, input$g.xlim)), aes(x)) +
  stat_function(fun = dgamma, args = list(shape = input$g.shape, scale=input$g.scale)) + 
  xlim(0, input$g.xlim)+
  ylab("Density") +
  theme_minimal() + 
  ggtitle("")+
  geom_vline(aes(xintercept=input$g.shape*input$g.scale), color="red", linetype="dashed", size=0.5)+
  geom_vline(aes(xintercept=qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale)), colour = "red")
  })

output$g.rate <- renderPrint({
  cat(paste0("Input: shape (k) = ", (input$g.mean/input$g.sd)^2, " and  scale (theta) = ", input$g.sd^2/input$g.mean))
  })

output$g.plot.cdf <- renderPlot({#plotly::renderPlotly({
x0<- qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale)
mean <- input$g.shape*input$g.scale
p<-ggplot(data = data.frame(x = c(0, input$g.xlim)), mapping = aes(x = x)) +
  stat_function(fun = pgamma, args = list(shape = input$g.shape, scale=input$g.scale)) + 
  xlim(0, input$g.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)
p
# plotly::ggplotly(p)
})

output$g.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click11))})

output$g = renderTable({
  x <- data.frame(x.postion = qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

G = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rgamma(input$g.size, shape = input$g.shape, scale=input$g.scale))
  return(df)})

output$download3 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(G(), file)
    }
  )

output$g.plot2 = plotly::renderPlotly({
  df = G()
  x <- names(df)
p<-plot_hist1c(df, x, input$g.bin)
plotly::ggplotly(p)
})

output$g.sum = renderTable({
  x = G()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1])))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

Z <- reactive({
  inFile <- input$g.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.g, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$col){
    csv <- read.csv(inFile$datapath, header = input$g.header, sep = input$g.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$g.header, sep = input$g.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$Z <- DT::renderDT({Z()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 200,
      scroller = TRUE))

output$makeplot.g1 <- plotly::renderPlotly({
  df = Z()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin.g)
  plotly::ggplotly(p)
  })

output$makeplot.g2 <- plotly::renderPlotly({
    df = Z()
  x <- names(df)
  x0<-quantile(df[,x], probs = input$g.pr, na.rm = TRUE)
  p<-plot_density1(df, x)
  p<- p+geom_vline(aes(xintercept=x0), color="red", size=0.3)
  plotly::ggplotly(p)
  })

output$makeplot.g3 <- plotly::renderPlotly({
  
  df = Z()
  x <- df[,1]  
  p<- ggplot(df, aes(x)) + stat_ecdf(geom = "point")+
  ylab("Cumulative Density Function") + 
  theme_minimal()
  plotly::ggplotly(p)
  })

output$g.sum2 = renderTable({
  x = Z()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance =quantile(x[,1], probs = input$g.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")
