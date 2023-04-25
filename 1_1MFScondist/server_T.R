#****************************************************************************************************************************************************1.5. T
output$t.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-input$t.xlim, input$t.xlim)), aes(x)) + 
  stat_function(fun = dt, args = list(df = input$t.df)) + 
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), color = "cornflowerblue") +
  ylab("Density") + 
  xlim(-input$t.xlim, input$t.xlim)+
  geom_vline(aes(xintercept=0), color="red", linetype="dashed", size=0.5)+
  theme_minimal() + 
  ggtitle("")+
  geom_vline(aes(xintercept=qt(input$t.pr, df = input$t.df)), colour = "red")})

output$t.rate <- renderPrint({
  cat(paste0("Input: DF (v) = ", 2*input$t.sd^2/(input$t.sd^2-1)))
  })

output$t.plot.cdf <- renderPlot({#plotly::renderPlotly({
x0<- qt(input$t.pr, df = input$t.df)
p<-ggplot(data = data.frame(x = c(-input$t.xlim, input$t.xlim)), mapping = aes(x = x)) +
  stat_function(fun = pt, args = list(df = input$t.df)) + 
  xlim(-input$t.xlim, input$t.xlim)+
  ylab("Cumulative Density Function") + 
  theme_minimal() + 
  geom_vline(aes(xintercept=0), color="red", linetype="dashed", size=0.3)+
  geom_vline(aes(xintercept=x0), color="red", size=0.3)

# plotly::ggplotly(p)
})

output$t.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click3))})

output$t = renderTable({
  x <-data.frame(x.position = qt(input$t.pr, df = input$t.df))
  rownames(x) <- c("Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


T = reactive({ # prepare dataset
 #set.seed(1)
  df = data.frame(x = rt(input$t.size, input$t.df))
  return(df)})

output$download5 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(T(), file)
    }
  )
output$t.plot2 = plotly::renderPlotly({
  df = T()
  x <- names(df)
p<-plot_hist1c(df, x, input$t.bin)
plotly::ggplotly(p)
})

output$t.sum = renderTable({
  x = T()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$t.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


TT <- reactive({
  inFile <- input$t.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.t, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$t.col){
    csv <- read.csv(inFile$datapath, header = input$t.header, sep = input$t.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$t.header, sep = input$t.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$TT <- DT::renderDT({TT()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 200,
      scroller = TRUE))

output$makeplot.t1 <- plotly::renderPlotly({
  df = TT()
  x <- names(df)
  p<-plot_hist1(df, x, input$bin.t)
  plotly::ggplotly(p)
   })
output$makeplot.t2 <- plotly::renderPlotly({
  df = TT()
  x <- names(df)
  x0<-quantile(df[,x], probs = input$t.pr, na.rm = TRUE)
  p<-plot_density1(df, x)
  p<- p+geom_vline(aes(xintercept=x0), color="red", size=0.3)
  plotly::ggplotly(p)
   })
output$makeplot.t3 <- plotly::renderPlotly({
  
  df = TT()
  x <- df[,1]  
  p<- ggplot(df, aes(x)) + stat_ecdf(geom = "point")+
  ylab("Cumulative Density Function") + 
  theme_minimal()
  plotly::ggplotly(p)
  })

output$t.sum2 = renderTable({
  x = TT()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$t.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")
