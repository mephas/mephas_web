#****************************************************************************************************************************************************2.t2

names2 <- reactive({
  x <- unlist(strsplit(input$cn2, "[\n]"))[1:2]
  return(x)
  })

Y <- reactive({
  inFile <- input$file2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$x2, "[,;\n\t]")))
    
    validate( need(sum(!is.na(X))>1, "请检查数据是否有效。") )
    validate( need(sum(!is.na(Y))>1, "请检查数据是否有效。") )
    # validate( need(length(X)==length(Y), "Please make sure two groups have equal length") )
    
    x <- data.frame(data=c(X,Y), group=c(rep(1,length(X)), rep(2, length(Y))))
    colnames(x) = names2()
    }
  else {
    if(!input$col2){
    csv <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2, row.names=1)  
    }
    validate( need(length(X)>0, "请检查数据输入是否有效。") )
    validate( need(length(Y)>1, "请检查数据输入是否有效。") )

    x <- csv[,1:2]
    if(input$header2==FALSE){
      colnames(x) = names2()
      }
    }
    return(as.data.frame(x))
})

output$table2 <-DT::renderDT(Y(),
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

basic_desc2 <- reactive({
  x <- Y()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(round(res,6))
  })

output$bas2 <- DT::renderDT({basic_desc2()},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "基本统计量"),
        list(extend = 'excel', title = "基本统计量")
        ),
    scrollX = TRUE))


output$bp2 = plotly::renderPlotly({
  x = Y()
  p<-plot_box2(x)
  plotly::ggplotly(p)

  })

output$meanp2 = plotly::renderPlotly({
  x = Y()
  p<-plot_msd2(x)
  plotly::ggplotly(p)
  })


output$makeplot2 <- plotly::renderPlotly({
  x <- Y()
  p<- plot_qq2(x)
  plotly::ggplotly(p)
  })

output$makeplot2.3 <- plotly::renderPlotly({
  x <- Y()
  p<-plot_hist2(x, input$bin2)
  plotly::ggplotly(p)
  })
output$makeplot2.4 <- plotly::renderPlotly({
  x <- Y()
  p<-plot_density2(x)
  plotly::ggplotly(p)
   })


var.test0 <- reactive({
  x <- Y()
  res <- var.test(as.vector(x[, 1]), as.vector(x[, 2]),alternative=input$alt.t22)
  res.table <- t(
    data.frame(
      F = round(res$statistic,6),
      P = round(res$p.value,6),
      CI = paste0("(", round(res$conf.int[1], 6), ", ", round(res$conf.int[2], 6),")"),
      EVR = round(res$estimate,6)
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("F Statistic", "P Value", "95% Confidence Interval", "Estimated Ratio of Variances (Var1/Var2)")
  return(res.table)
  })

output$var.test <- DT::renderDT({
  var.test0() }, 

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "F检验结果"),
        list(extend = 'excel', title = "F检验结果")
        ),
    scrollX = TRUE))

t.test20 <- reactive({
  x <- Y()
  res <- t.test(
    as.vector(x[, 1])~as.vector(x[, 2]),
    alternative = input$alt.t2,
    var.equal = TRUE
    )

res.table <- t(
  data.frame(
    T = round(res$statistic,6),
    P = round(res$p.value,6),
    EMX = round(res$estimate[1],6),
    EMY = round(res$estimate[2],6),
    EMD = round(res$estimate[1] - res$estimate[2],6),
    CI = paste0("(",round(res$conf.int[1], 6),", ", round(res$conf.int[2], 6), ")" ),
    DF = res$parameter
    )
  )
  res1 <- t.test(
    as.vector(x[, 1])~as.vector(x[, 2]),
    alternative = input$alt.t2,
    var.equal = FALSE
    )
  res1.table <- t(
    data.frame(
      T = round(res1$statistic,6),
      P = round(res1$p.value,6),
      EMX = round(res1$estimate[1],6),
      EMY = round(res1$estimate[2],6),
      EMD = round(res1$estimate[1] - res1$estimate[2],6),
      CI = paste0("(",round(res1$conf.int[1], 6),", ",round(res1$conf.int[2], 6),")"),
      DF = res1$parameter
      )
    )

  res2.table <- cbind(res.table, res1.table)
  colnames(res2.table) <- c(res$method, res1$method)
  rownames(res2.table) <- c("T Statistic", "P Value","Estimated Mean of Group 1","Estimated Mean of Group 2", "Estimated Mean Difference of 2 Groups" ,"95% Confidence Interval","Degree of Freedom")
  return(res2.table)
  })

output$t.test2 <- DT::renderDT({
  t.test20()},  

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "检验结果"),
        list(extend = 'excel', title = "检验结果")
        ),
    scrollX = TRUE))

