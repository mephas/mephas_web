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
    return(round(res,6))
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
 })


  output$makeplot2 <- plotly::renderPlotly({
    x <- B()
    p<-plot_hist2(x, input$bin2)
    plotly::ggplotly(p)
    })
  output$makeplot2.1 <- plotly::renderPlotly({
    x <- B()
    p<-plot_density2(x)
    plotly::ggplotly(p)
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
  
    res.table <- t(data.frame(W = round(res$statistic, 6),
                              P = round(res$p.value, 6),
                              EM = round(res$estimate, 6),
                              CI = paste0("(",round(res$conf.int[1], 6),", ",round(res$conf.int[2], 6), ")")))
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

