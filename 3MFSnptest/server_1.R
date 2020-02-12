#****************************************************************************************************************************************************1.np1

names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1])
  })


  A <- reactive({
    inFile <- input$file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$a, "[,;\n\t]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    colnames(x) = names1()
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
    if(input$header!=TRUE){
      names(x) <- names1()
      }
    }
  x <- as.data.frame(x)
  })

  #table 
output$table <- DT::renderDT(A(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

  A.des <- reactive({
    x <- A()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(round(res,6))
  })

  output$bas <- DT::renderDT({  
    res <- A.des()
    },
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

   output$bp = plotly::renderPlotly({
    x = A()
    var <- names(x)[1]
    p<-plot_box1(x, var)
    plotly::ggplotly(p)
    }) 
  
  output$makeplot <- plotly::renderPlotly({  #shinysession 
    x <- A()
    var <- names(x)[1]
    p <- plot_hist1(x, var, input$bin)
    plotly::ggplotly(p)
    
    })
  output$makeplot.1 <- plotly::renderPlotly({  #shinysession 
    x <- A()
    var <- names(x)[1]
    p <- plot_density1(x, var)
    plotly::ggplotly(p)
    })
  

  ws.test<- reactive({
    x <- A()
    if (input$alt.md =="a"){
    res <- wilcox.test((x[,1]), mu = input$med, 
      alternative = input$alt.wsr, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md =="b") {
    res <- wilcox.test((x[,1]), 
      mu = input$med, 
      alternative = input$alt.wsr, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], mu = input$med, 
      alternative = input$alt.wsr, exact=TRUE, conf.int = TRUE)

  }
  
    res.table <- t(data.frame(W = round(res$statistic, 6),
                              P = round(res$p.value, 6),
                              EM = round(res$estimate, 6),
                              CI = paste0("(",round(res$conf.int[1], 6),", ",round(res$conf.int[2], 6), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$ws.test.t <- DT::renderDT({ws.test()},
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

