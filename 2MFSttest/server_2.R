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

output$table2 <-DT::renderDT(Y(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basic_desc2 <- reactive({
  x <- Y()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas2 <- DT::renderDT({
basic_desc2()
},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$bp2 = plotly::renderPlotly({
  x = Y()
  p<-plot_box2(x)
  plotly::ggplotly(p)
  #mx = melt(x, idvar = names(x))
  #ggplot(mx, aes(x = mx[,"variable"], y = mx[,"value"], fill = mx[,"variable"])) + 
  #geom_boxplot(width = 0.4,outlier.colour = "red",alpha = .3) + 
  #ylab(" ") + xlab(" ") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
  })

output$meanp2 = plotly::renderPlotly({
  x = Y()
  p<-plot_msd2(x)
  plotly::ggplotly(p)
  #des = data.frame(psych::describe(x))
  #rownames(des) = names(x)
  #ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
  #  xlab("") + ylab(expression(Mean %+-% SD)) + geom_bar(position = position_dodge(), stat = "identity", width = 0.2, alpha = .3) + 
  #  geom_errorbar(width = .1, position = position_dodge(.9), aes(ymin = mean - des$sd, ymax = mean + des$sd), data = des) + 
  #  theme_minimal() + theme(legend.title = element_blank())
  })


output$makeplot2 <- plotly::renderPlotly({
  x <- Y()
  p<- plot_qq2(x)
  plotly::ggplotly(p)
  #mx <- melt(x, idvar = names(x))  ###bug: using as id variables
  # normal qq plot
  #ggplot(x, aes(sample = x[, 1])) + stat_qq(color = "brown1") + ggtitle(paste0("Normal Q-Q Plot of ", colnames(x[1]))) + theme_minimal()
  })
#output$makeplot2.2 <- renderPlot({
#  x <- Y()
#  mx <- melt(x, idvar = names(x))  ###bug: using as id variables
#  # normal qq plot
#  ggplot(x, aes(sample = x[, 2])) + stat_qq(color = "forestgreen") + ggtitle(paste0("Normal Q-Q Plot of ", colnames(x[2]))) + theme_minimal()#

#  })
output$makeplot2.3 <- plotly::renderPlotly({
  x <- Y()
  p<-plot_hist2(x, input$bin2)
  plotly::ggplotly(p)
  #mx <- melt(x, idvar = names(x))  ###bug: using as id variables
  #ggplot(mx, aes(x = mx[,"value"], colour = mx[,"variable"], fill = mx[,"variable"])) + 
  #  geom_histogram(binwidth = input$bin2, alpha = .3, position = "identity") + 
  #  ggtitle("Histogram") + xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })
output$makeplot2.4 <- plotly::renderPlotly({
  x <- Y()
  p<-plot_density2(x)
  plotly::ggplotly(p)
  #mx <- melt(x, idvar = names(x))  ###bug: using as id variables
  #ggplot(mx, aes(x = mx[,"value"], colour = mx[,"variable"])) + geom_density() + 
  #  ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })


# output$info2 <- renderText({
#   xy_str = function(e) {
#     if (is.null(e))
#     return("NULL\n")
#     paste0("Click to get value: ", round(e$y, 4))
#     }
#   paste0("Y-axis position", "\n", xy_str(input$plot_click2))
#   })

  # test result

var.test0 <- reactive({
  x <- Y()
  res <- var.test(as.vector(x[, 1]), as.vector(x[, 2]),alternative=input$alt.t22)
  res.table <- t(
    data.frame(
      F = res$statistic,
      P = res$p.value,
      CI = paste0("(", round(res$conf.int[1], digits = 6), ", ", round(res$conf.int[2], digits = 6),")"),
      EVR = res$estimate
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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

t.test20 <- reactive({
  x <- Y()
  res <- t.test(
    as.vector(x[, 1]),
    as.vector(x[, 2]),
    alternative = input$alt.t2,
    var.equal = TRUE
    )

res.table <- t(
  data.frame(
    T = res$statistic,
    P = res$p.value,
    EMX = res$estimate[1],
    EMY = res$estimate[2],
    EMD = res$estimate[1] - res$estimate[2],
    CI = paste0("(",round(res$conf.int[1], digits = 6),", ", round(res$conf.int[2], digits = 6), ")" ),
    DF = res$parameter
    )
  )
  res1 <- t.test(
    as.vector(x[, 1]),
    as.vector(x[, 2]),
    alternative = input$alt.t2,
    var.equal = FALSE
    )
  res1.table <- t(
    data.frame(
      T = res1$statistic,
      P = res1$p.value,
      EMX = res1$estimate[1],
      EMY = res1$estimate[2],
      EMD = res1$estimate[1] - res1$estimate[2],
      CI = paste0("(",round(res1$conf.int[1], digits = 6),", ",round(res1$conf.int[2], digits = 6),")"),
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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

