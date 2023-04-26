#****************************************************************************************************************************************************1.7. F
output$f.plot <- renderPlot({
  ggplot(data = data.frame(x = c(0, input$f.xlim)), aes(x)) +
  stat_function(fun = df, n= 100, args = list(df1 = input$df11, df2 = input$df21)) + 
  ylab("Density") +
  xlim(0, input$f.xlim)+
  #scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$f.ylim) +
  geom_vline(aes(xintercept=input$df21/(input$df21-2)), color="red", linetype="dashed", size=0.5)+
  geom_vline(aes(xintercept=qf(input$f.pr, df1 = input$df11, df2 = input$df21)), colour = "red")})

output$f.plot.cdf <- renderPlot({#plotly::renderPlotly({
x0<- qf(input$f.pr, df1 = input$df11, df2 = input$df21)
mean <- input$df21/(input$df21-2)
p<-ggplot(data = data.frame(x = c(0, input$f.xlim)), mapping = aes(x = x)) +
  stat_function(fun = pf, n= 100, args = list(df1 = input$df11, df2 = input$df21)) + 
  xlim(0, input$f.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=mean), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)
p
# plotly::ggplotly(p)
})

output$f.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click7))})

output$f = renderTable({
  x <- data.frame(x.postion = qf(input$f.pr, df1 = input$df11, df2 = input$df21))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


F = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rf(input$f.size, input$df11, input$df21))
  return(df)})

output$download7 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(F(), file)
    }
  )

output$table4 = renderDataTable({head(F(), n = 100L)},  options = list(pageLength = 10))

output$f.plot2 = plotly::renderPlotly({
  df = F()
  x <- names(df)
p<-plot_hist1c(df, x, input$f.bin)
plotly::ggplotly(p)

})

output$f.sum = renderTable({
  x = F()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$f.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


FF <- reactive({
  inFile <- input$f.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.f, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$f.col){
    csv <- read.csv(inFile$datapath, header = input$f.header, sep = input$f.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$f.header, sep = input$f.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$FF <- DT::renderDT({FF()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 200,
      scroller = TRUE))

output$makeplot.f1 <- plotly::renderPlotly({
    df = FF()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin.f)
  plotly::ggplotly(p)  
  })
output$makeplot.f2 <- plotly::renderPlotly({
    df = FF()
  x <- names(df)
  x0 <- quantile(df[,x], probs = input$f.pr, na.rm = TRUE)
  p<-plot_density1(df, x)
  p<- p+geom_vline(aes(xintercept=x0), color="red", size=0.3)
  plotly::ggplotly(p)
 })
output$makeplot.f3 <- plotly::renderPlotly({
  
  df = FF()
  x <- df[,1]  
  p<- ggplot(df, aes(x)) + stat_ecdf(geom = "point")+
  ylab("Cumulative Density Function") + 
  theme_minimal()
  plotly::ggplotly(p)
  })

output$f.sum2 = renderTable({
  x = FF()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$f.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")
