#****************************************************************************************************************************************************3.tp

names.p <- reactive({
  x <- unlist(strsplit(input$cn.p, "[\n]"))
  return(x[1:3])
  })

Z <- reactive({
  # prepare dataset
  inFile <- input$file.p
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1.p, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$x2.p, "[,;\n\t]")))
    
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    validate( need(sum(!is.na(Y))>1, "Please input enough valid numeric data") )
    validate( need(length(X)==length(Y), "Please make sure two groups have equal length") )
    x <- data.frame(X = X, Y = Y)
    x$diff <- round(x[, 2] - x[, 1], 4)
    colnames(x) = names.p()
    }
  else {
    if(!input$col.p){
    csv <- read.csv(inFile$datapath, header = input$header.p, sep = input$sep.p)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header.p, sep = input$sep.p, row.names=1)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    x$diff <- round(x[, 2] - x[, 1], 4)
    if(input$header.p==FALSE){
      colnames(x) = names.p()
      }
    }
    return(as.data.frame(x))
})
 

output$table.p <-DT::renderDT({Z()},
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basic_desc3 <- reactive({
  x <- Z()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas.p <- DT::renderDT({
  basic_desc3()
  }, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$bp.p = plotly::renderPlotly({

  x = Z()
  var <- names(Z())[3]
  p<-plot_box1(x, var)
  plotly::ggplotly(p)
 })

output$meanp.p = plotly::renderPlotly({
  x = Z()
  var <- names(Z())[3]
  p<-plot_msd1(x, var)
  plotly::ggplotly(p)  
  })


output$makeplot.p <- plotly::renderPlotly({
  x <- Z()
  var <- colnames(x)[3]
  p <- plot_qq1(x, var)
  plotly::ggplotly(p)
  })
output$makeplot.p2 <- plotly::renderPlotly({
  x <- Z()
  var <- colnames(x)[3]
  p <- plot_hist1(x, var, input$bin.p)
  plotly::ggplotly(p)
  })
output$makeplot.p3 <- plotly::renderPlotly({
  x <- Z()
  var <- names(x)[3]
  p <- plot_density1(x, var)
  plotly::ggplotly(p)
  })

t.test.p0 <- reactive({
  x <- Z()
  res <-t.test(
    x[, 1],
    x[, 2],
    data = x,
    paired = TRUE,
    alternative = input$alt.pt
  )

  res.table <- t(
    data.frame(
      T = res$statistic,
      P = res$p.value,
      EMD = res$estimate,
      CI = paste0("(",round(res$conf.int[1], digits = 6),", ",round(res$conf.int[2], digits = 6),")"),
      DF = res$parameter
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("T Statistic", "P Value", "Estimated Mean Difference of 2 Groups" ,"95% Confidence Interval","Degree of Freedom")
  return(res.table)

  })
output$t.test.p <- DT::renderDT({
  t.test.p0()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))
