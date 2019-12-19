##----------#----------#----------#----------
##
## 2MFSttest SERVER
##
##    >Panel 3
##
## Language: EN
##
## DT: 2019-05-04
##
##----------#----------#----------#----------
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
 

output$table.p <-DT::renderDataTable({datatable(Z() ,rownames = TRUE)})

basic_desc3 <- reactive({
  x <- Z()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas.p <- renderTable({
  basic_desc3()
  },  width = "500px", rownames = TRUE, colnames = TRUE)



output$download5 <- downloadHandler(
    filename = function() {
      "basic_desc.csv"
    },
    content = function(file) {
      write.csv(basic_desc3(), file, row.names = TRUE)
    }
  )

output$bp.p = renderPlot({
  x = Z()
  ggplot(x, aes(x = 0, y = x[, 3])) + geom_boxplot(width = 0.2, outlier.colour = "red") + xlim(-1,1) +
  ylab("") + xlab("") + ggtitle("") + theme_minimal()
  })

output$meanp.p = renderPlot({
  x = Z()[,3]
  des = data.frame(psych::describe(x))
  rownames(des) = names(x)
  #p1 = ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
  #  geom_errorbar(width = .1, aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev),data = des) +
  #  xlab("") + ylab(expression(Mean %+-% SD)) + geom_point(shape = 21, size = 3) + theme_minimal() + theme(legend.title = element_blank())

  p2 = ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
    xlab("") + ylab(expression(Mean %+-% SD)) + geom_bar(position = position_dodge(), stat = "identity", width = 0.2, alpha = .3) + 
    geom_errorbar(width = .1, position = position_dodge(.9), aes(ymin = mean - des$sd, ymax = mean + des$sd), data = des) + 
    theme_minimal() + theme(legend.title = element_blank())
  
  grid.arrange(p2)
  })

output$info3 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("The approximate value: ", round(e$y, 4))
  }
  paste0("Horizontal position ", "\n", xy_str(input$plot_click3))
  })

output$makeplot.p <- renderPlot({
  x <- Z()
  plot1 <- ggplot(x, aes(sample = x[, 3])) + stat_qq() + ggtitle("Normal Q-Q Plot of the Mean Differences") + xlab("") + theme_minimal()  ## add line,
  plot2 <- ggplot(x, aes(x = x[, 3])) + geom_histogram(colour = "black",fill = "grey", binwidth = input$bin.p, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  plot3 <- ggplot(x, aes(x = x[, 3])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title = element_blank())

  grid.arrange(plot1, plot2, plot3, ncol = 3)
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
      CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4),")"),
      DF = res$parameter
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("T Statistic", "P Value", "Estimated Mean Difference of 2 Groups" ,"95% Confidence Interval","Degree of Freedom")
  return(res.table)

  })
output$t.test.p <- renderTable({
  t.test.p0()}, width = "500px", rownames = TRUE)

output$download6 <- downloadHandler(
    filename = function() {
      "tp_test.csv"
    },
    content = function(file) {
      write.csv(t.test.p0(), file, row.names = TRUE)
    }
  )