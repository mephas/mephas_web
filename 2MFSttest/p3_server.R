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
Z <- reactive({
  # prepare dataset
  inFile <- input$file.p
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1.p, "[\n, \t, ]")))
    Y <- as.numeric(unlist(strsplit(input$x2.p, "[\n, \t, ]")))
    x <- data.frame(X = X, Y = Y)
    x$diff <- round(x[, 2] - x[, 1], 4)
    }
  else {
    csv <- read.csv(
        inFile$datapath,
        header = input$header.p,
        sep = input$sep.p
      )
    x <- as.data.frame(csv)
    x$diff <- round(x[, 2] - x[, 1], 4)
  }
 
  names(x) = unlist(strsplit(input$cn.p, "[\n, \t, ]"))
  return(x)
})

output$table.p <-renderDataTable({Z()}, options = list(pageLength = 5))

basic_desc3 <- reactive({
  x <- Z()
  res <- stat.desc(x, norm = TRUE)
  return(res)})

output$bas.p <- renderTable({
  x <- Z()
  res <- basic_desc3()[-11,3]
  names(res) = c("How many values", "How many NULL values", "How many Missing values",
    "Minumum","Maximum","Range","Sum","Median","Mean","Standard Error", "Variance","Standard Deviation","Variation Coefficient",
    "Skewness Coefficient","Skew.2SE","Kurtosis Coefficient","Kurt.2SE","Normtest.W","Normtest.p")
  return(res)
  },   
  width = "500px", rownames = TRUE, colnames = FALSE, digits = 4)



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
  ggplot(x, aes(x = "", y = x[, 3])) + geom_boxplot(width = 0.2, outlier.colour = "red") + 
  ylab("") + xlab("") + ggtitle("") + theme_minimal()
  })

output$meanp.p = renderPlot({
  x = Z()[,3]
  des = data.frame(t(stat.desc(x)))
  #p1 = ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
  #  geom_errorbar(width = .1, aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev),data = des) +
  #  xlab("") + ylab(expression(Mean %+-% SD)) + geom_point(shape = 21, size = 3) + theme_minimal() + theme(legend.title = element_blank())

  p2 = ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
  xlab("") + ylab(expression(Mean %+-% SD)) + geom_bar(position = position_dodge(),stat = "identity",width = 0.2,alpha = .3) +
  geom_errorbar(width = .1,position = position_dodge(.9),aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev),data = des) + 
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