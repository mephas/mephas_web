#****************************************************************************************************************************************************1.t1
names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1])
  })


X <- reactive({

  inFile <- input$file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[,;\n\t]")))
    validate( need(sum(!is.na(x))>1, "请检查数据是否存在缺失值。") )
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
    validate( need(ncol(csv)>0, "请检查数据格式，列数是否有效。") )
    validate( need(nrow(csv)>1, "请检查数据格式，行数是否有效。") )

    x <- as.data.frame(csv[,1])
    colnames(x) <- names(csv)[1]
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
      buttons = 
      list('copy',
        list(extend = 'csv', title = "数据确认"),
        list(extend = 'excel', title = "数据确认")
        ),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basic_desc <- reactive({
  x <- X()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(round(res,6))
  })

output$bas <- DT::renderDT({basic_desc()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "描述性统计量"),
        list(extend = 'excel', title = "描述性统计量")
        ),
    scrollX = TRUE))


# box plot
output$bp = plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p<-plot_box1(x, var)
  plotly::ggplotly(p)
  })



output$meanp = plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p<-plot_msd1(x, var)
  plotly::ggplotly(p)

  })

output$makeplot1 <- plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p <- plot_qq1(x, var)
  plotly::ggplotly(p)
  })

output$makeplot1.2 <- plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p <- plot_hist1(x, var, input$bin)
  plotly::ggplotly(p)
  })
output$makeplot1.3 <- plotly::renderPlotly({
  x = X()
  var <- names(x)[1]
  p <- plot_density1(x, var)
  plotly::ggplotly(p)
  })

t.test0 <- reactive({
  x <- X()
  validate(need(input$mu, "需要指定一个均值。"))
  res <-t.test(
    x[,1],
    mu = input$mu,
    alternative = input$alt)
  res.table <- t(
    data.frame(
      T = round(res$statistic, 6),
      P = round(res$p.value,6),
      E.M = round(res$estimate, 6),
      CI = paste0("(",round(res$conf.int[1], 6),", ",round(res$conf.int[2], 6),")"),
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
    buttons = 
      list('copy',
        list(extend = 'csv', title = "检验结果"),
        list(extend = 'excel', title = "检验结果")
        ),
    scrollX = TRUE))
