#****************************************************************************************************************************************************1.6. chi
output$x.plot <- renderPlot({
  ggplot(data = data.frame(x = c(0, input$x.xlim)), aes(x)) +
  stat_function(fun = dchisq, args = list(df = input$x.df)) + 
  ylab("Density") +
  xlim(0, input$x.xlim)+
  geom_vline(aes(xintercept=input$x.df), color="red", linetype="dashed", size=0.5)+
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$x.ylim) +
  geom_vline(aes(xintercept=qchisq(input$x.pr, df = input$x.df)), colour = "red")})

output$x.plot.cdf <- renderPlot({
x0<- qchisq(input$x.pr, df = input$x.df)
mean <- input$x.df
p<-ggplot(data = data.frame(x = c(0, input$x.xlim)), mapping = aes(x = x)) +
  stat_function(fun = pchisq, args = list(df = input$x.df)) + 
  xlim(0, input$x.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)
#plotly::renderPlotly({
# plotly::ggplotly(p)
})

output$x.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click5))})

output$xn = renderTable({
  x <- data.frame(x.postion = qchisq(input$x.pr, df = input$x.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

X = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rchisq(input$x.size, input$x.df))
  return(df)})

output$download6 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(X(), file)
    }
  )

output$x.plot2 = plotly::renderPlotly({
  df = X()
  x <- names(df)
p<-plot_hist1c(df, x, input$x.bin)
plotly::ggplotly(p)

})

output$x.sum = renderTable({
  x = X()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

output$x = renderTable({
  x <- data.frame(x.postion = qchisq(input$x.pr, df = input$x.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


XX <- reactive({
  inFile <- input$x.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.x, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$x.col){
    csv <- read.csv(inFile$datapath, header = input$x.header, sep = input$x.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$x.header, sep = input$x.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$XX <- DT::renderDT({XX()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 200,
      scroller = TRUE))

output$makeplot.x1 <- plotly::renderPlotly({
  df = XX()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin.x)
  plotly::ggplotly(p)
   })
output$makeplot.x2 <- plotly::renderPlotly({
  df = XX()
  x <- names(df)
  x0<- quantile(df[,x], probs = input$x.pr, na.rm = TRUE)
  p<-plot_density1(df, x)
  p<- p+geom_vline(aes(xintercept=x0), color="red", size=0.3)
  plotly::ggplotly(p)
   })
output$makeplot.x3 <- plotly::renderPlotly({
  
  df = XX()
  x <- df[,1]  
  p<- ggplot(df, aes(x)) + stat_ecdf(geom = "point")+
  ylab("Cumulative Density Function") + 
  theme_minimal()
  plotly::ggplotly(p)
  })

output$x.sum2 = renderTable({
  x = XX()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")
