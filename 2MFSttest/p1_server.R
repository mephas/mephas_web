#****************************************************************************************************************************************************1.t1
names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1])
  })


X <- reactive({

  inFile <- input$file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[,;\n\t]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    colnames(x) <- names1()

    }
  else {
    if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, row.names=1)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- as.data.frame(csv[,1])
    colnames(x) <- names(csv)[1]
    #validate( need(sum(!is.na(csv))>1, "Please input enough valid numeric data") )
    if(input$header!=TRUE){
      names(x) <- names1()
      }
    }
  x <- as.data.frame(x)
  return(x)
  })

output$table <- DT::renderDT({X()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basic_desc <- reactive({
  x <- X()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas <- DT::renderDT({basic_desc()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$download0 <- downloadHandler(
#    filename = function() {
#      "basic_desc.csv"
#    },
#    content = function(file) {
#      write.csv(basic_desc(), file, row.names = TRUE)
#    }
#  )

# box plot
output$bp = plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  #ggplot(x, aes(x = 0, y = x[,1])) + geom_boxplot(width = 0.2, outlier.colour = "red") + xlim(-1,1) + ylab("") + xlab(names(x)) + ggtitle("") + theme_minimal()
  p<-MFSbox1(x, var)
  plotly::ggplotly(p)
  })

output$info1 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("Click to get value: ", round(e$y, 4))
  }
  paste0("Y-axis position", "\n", xy_str(input$plot_click1))
})

output$meanp = plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p<-MFSmsd1(x, var)
  plotly::ggplotly(p)
  #des = data.frame(psych::describe(x))
  ##rownames(des) = names(x)
  #ggplot(des, aes(x = rownames(des), y = mean)) + 
  #geom_bar(position = position_dodge(),stat = "identity",width = 0.2, alpha = .3) +
  #geom_errorbar(width = .1,position = position_dodge(.9),aes(ymin = mean - des$sd, ymax = mean + des$sd),data = des) + 
  #xlab("") + ylab(expression(Mean %+-% SD)) + 
  #theme_minimal() + theme(legend.title = element_blank())
  })

output$makeplot1 <- plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p <- MFSqq1(x, var)
  plotly::ggplotly(p)
  #ggplot(x, aes(sample = x[,1])) + stat_qq() + ggtitle("") + xlab("") + theme_minimal()  ## add line, 
  })
output$makeplot1.2 <- plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p <- MFShist1(x, var, input$bin)
  plotly::ggplotly(p)
  #ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank()) 
  })
output$makeplot1.3 <- plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p <- MFSdensity1(x, var)
  plotly::ggplotly(p)
  #ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title =element_blank())
  })

t.test0 <- reactive({
  x <- X()
  res <-t.test(
    x[,1],
    mu = input$mu,
    alternative = input$alt)
  res.table <- t(
    data.frame(
      T = round(res$statistic, digits=6),
      P = res$p.value,
      E.M = round(res$estimate, digits=6),
      CI = paste0("(",round(res$conf.int[1], digits = 6),", ",round(res$conf.int[2], digits = 6),")"),
      DF = res$parameter
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("T Statistic", "P Value","Estimated Mean","95% Confidence Interval","Degree of Freedom")

  return(res.table)
  })

output$t.test <- DT::renderDT({t.test0()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))
