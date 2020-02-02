#****************************************************************************************************************************************************2.np2

names2 <- reactive({
  x <- unlist(strsplit(input$cn2, "[\n]"))[1:2]
  return(x)
  })

B <- reactive({
  inFile <- input$file2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$x2, "[,;\n\t]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    validate( need(sum(!is.na(Y))>1, "Please input enough valid numeric data") )
    validate( need(length(X)==length(Y), "Please make sure two groups have equal length") )

    x <- data.frame(X = X, Y = Y)
    colnames(x) = names2()
    }
  else {
    if(!input$col2){
    csv <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2, row.names=1)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$header2==FALSE){
      colnames(x) = names2()
      }
    }
    return(as.data.frame(x))
})

output$table2 <-DT::renderDT({B()},
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

  B.des <- reactive({
    x <- B()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })
  output$bas2 <- DT::renderDT({  ## don't use renerPrint to do DT::renderDT
    res <- B.des()},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


  output$bp2 = plotly::renderPlotly({
    x <- B()
    p<-plot_box2(x)
    plotly::ggplotly(p)
    #mx <- melt(B(), idvar = colnames(x))
    #ggplot(mx, aes(x =mx[,"variable"], y = mx[,"value"], fill=mx[,"variable"])) + geom_boxplot(alpha=.3, width = 0.2, outlier.color = "red", outlier.size = 2)+ 
    #ylab("") + ggtitle("") + theme_minimal() + theme(legend.title=element_blank()) 
    })

  # output$info2 <- renderText({
  #   xy_str = function(e) {
  #     if(is.null(e)) return("NULL\n")
  #     paste0("Click to get the value: ", round(e$y, 4))
  #   }
  #   paste0("Y-axis position", "\n", xy_str(input$plot_click2))})

  output$makeplot2 <- plotly::renderPlotly({
    x <- B()
    p<-plot_hist2(x, input$bin2)
    plotly::ggplotly(p)
    #mx <- melt(B(), idvar = colnames(x))
    #ggplot(mx, aes(x=mx[,"value"], fill=mx[,"variable"])) + geom_histogram(binwidth=input$bin2, alpha=.5, position="identity") + xlab("")+ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    })
  output$makeplot2.1 <- plotly::renderPlotly({
    x <- B()
    p<-plot_density2(x)
    plotly::ggplotly(p)
    #mx <- melt(B(), idvar = colnames(x))
    #ggplot(mx, aes(x=mx[,"value"], colour=mx[,"variable"])) + geom_density()+ xlab("")+ ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    })
#test
  mwu.test <- reactive({
    x <- B()
     if (input$alt.md2 =="a"){
    res <- wilcox.test(x[,1], x[,2], 
      alternative = input$alt.wsr2, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md2 =="b") {
    res <- wilcox.test(x[,1], x[,2], 
      alternative = input$alt.wsr2, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md2 =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], x[,2],  
      alternative = input$alt.wsr2, exact=TRUE, conf.int = TRUE)

  }
  
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$mwu.test.t<-DT::renderDT({
    mwu.test()},
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

