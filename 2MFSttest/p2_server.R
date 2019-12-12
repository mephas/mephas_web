##----------#----------#----------#----------
##
## 2MFSttest SERVER
##
##    >Panel 2
##
## Language: EN
##
## DT: 2019-05-04
##
##----------#----------#----------#----------
names2 <- reactive({
  x <- unlist(strsplit(input$cn2, "[\n]"))
  return(x[1:2])
  })

Y <- reactive({
  inFile <- input$file2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[\n, \t, ]")))
    Y <- as.numeric(unlist(strsplit(input$x2, "[\n, \t, ]")))
    x <- data.frame(X = X, Y = Y)
    colnames(x) = names2()
    }
  else {
    x <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2)
    x <- as.data.frame(x)[,1:2]
    if(input$header==FALSE){
      colnames(x) = names2()
      }
    }
    return(as.data.frame(x))
})

output$table2 <-DT::renderDataTable({datatable(Y() ,rownames = TRUE)})

basic_desc2 <- reactive({
  x <- Y()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names2()
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas2 <- renderTable({
basic_desc2()
}, width = "500px", rownames = TRUE, colnames = TRUE)

output$download3 <- downloadHandler(
    filename = function() {
      "basic_desc.csv"
    },
    content = function(file) {
      write.csv(basic_desc2(), file, row.names = TRUE)
    }
  )

  #plots
output$bp2 = renderPlot({
  x = Y()
  mx = melt(x, idvar = names(x))
  ggplot(mx, aes(x = mx[,"variable"], y = mx[,"value"], fill = mx[,"variable"])) + 
  geom_boxplot(width = 0.4,outlier.colour = "red",alpha = .3) + 
  ylab(" ") + xlab(" ") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
  })

output$meanp2 = renderPlot({
  x = Y()
  des = data.frame(t(stat.desc(x)))
  #p1 = ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
  #  geom_errorbar(width = .1, aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev), data = des) + 
  #  xlab("") + ylab(expression(Mean %+-% SD)) + geom_point(shape = 21, size =3) + theme_minimal() + theme(legend.title = element_blank())
  p2 = ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
    xlab("") + ylab(expression(Mean %+-% SD)) + geom_bar(position = position_dodge(), stat = "identity", width = 0.2, alpha = .3) + 
    geom_errorbar(width = .1, position = position_dodge(.9), aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev), data = des) + 
    theme_minimal() + theme(legend.title = element_blank())

  grid.arrange(p2)
  })

output$makeplot2 <- renderPlot({
  x <- Y()
  mx <- melt(x, idvar = names(x))  ###bug: using as id variables
  # normal qq plot
  plot1 <- ggplot(x, aes(sample = x[, 1])) + stat_qq(color = "brown1") + ggtitle(paste0("Normal Q-Q Plot of ", colnames(x[1]))) + theme_minimal()
  plot2 <- ggplot(x, aes(sample = x[, 2])) + stat_qq(color = "forestgreen") + ggtitle(paste0("Normal Q-Q Plot of ", colnames(x[2]))) + theme_minimal()
  # histogram and density
  plot3 <- ggplot(mx, aes(x = mx[,"value"], colour = mx[,"variable"], fill = mx[,"variable"])) + 
    geom_histogram(binwidth = input$bin2, alpha = .3, position = "identity") + 
    ggtitle("Histogram") + xlab("") + theme_minimal() + theme(legend.title = element_blank())
  plot4 <- ggplot(mx, aes(x = mx[,"value"], colour = mx[,"variable"])) + geom_density() + 
    ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title = element_blank())

  grid.arrange(plot1, plot2, plot3, plot4, ncol = 2)
  })

output$info2 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("The approximate value: ", round(e$y, 4))
    }
  paste0("Horizontal position ", "\n", xy_str(input$plot_click2))
  })

  # test result

var.test0 <- reactive({
  x <- Y()
  res <- var.test(as.vector(x[, 1]), as.vector(x[, 2]),alternative=input$alt.t22)
  res.table <- t(
    data.frame(
      F = res$statistic,
      P = res$p.value,
      CI = paste0("(", round(res$conf.int[1], digits = 4), ", ", round(res$conf.int[2], digits = 4),")"),
      EVR = res$estimate
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("F Statistic", "P Value", "95% Confidence Interval", "Estimated Ratio of Variances (Var1/Var2)")
  return(res.table)
  })

output$var.test <- renderTable({
  var.test0() }, width = "500px", rownames = TRUE)

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
    CI = paste0("(",round(res$conf.int[1], digits = 4),", ", round(res$conf.int[2], digits = 4), ")" ),
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
      CI = paste0("(",round(res1$conf.int[1], digits = 4),", ",round(res1$conf.int[2], digits = 4),")"),
      DF = res1$parameter
      )
    )

  res2.table <- cbind(res.table, res1.table)
  colnames(res2.table) <- c(res$method, res1$method)
  rownames(res2.table) <- c("T Statistic", "P Value","Estimated Mean of Group 1","Estimated Mean of Group 2", "Estimated Mean Difference of 2 Groups" ,"95% Confidence Interval","Degree of Freedom")
  return(res2.table)
  })

output$t.test2 <- renderTable({
  t.test20()},  width = "800px", rownames = TRUE)

output$download2 <- downloadHandler(
    filename = function() {
      "var_test.csv"
    },
    content = function(file) {
      write.csv(var.test0(), file, row.names = TRUE)
    }
  )
output$download4 <- downloadHandler(
    filename = function() {
      "t2_test.csv"
    },
    content = function(file) {
      write.csv(t.test20(), file, row.names = TRUE)
    }
  )
