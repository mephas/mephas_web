if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(pastecs)) {install.packages("pastecs")}; library(pastecs)

##----------#----------#----------#----------
##
## 2MFSttest SERVER
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyServer(

function(input, output) {

##---------- 1. One sample t test---------

X <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    # input data
    X <- as.numeric(unlist(strsplit(input$x, "[\n, \t, ]")))
    X <- data.frame(X = X)
    names(X) = unlist(strsplit(input$cn, "[\n, \t, ]"))
    }
  else {
    # CSV data
    csv <- read.csv(inFile$datapath,
        header = input$header,
        sep = input$sep)

    X <- as.data.frame(csv)
    }
    return(X)
  })

output$table <-renderDataTable({X()}, options = list(pageLength = 5))


basic_desc <- reactive({
  x <- X()
  res <- stat.desc(x, norm = TRUE)
  return(res)})

output$bas <- renderTable({
  res <- basic_desc()[1:3,]
  names(res) = c("number.var", "number.null", "number.na")
  return(res)
  },   
  width = "200px", rownames = TRUE, digits = 0)

output$des <- renderTable({
  basic_desc()[4:14,]},   width = "200px", rownames = TRUE)

output$nor <- renderTable({
  basic_desc()[15:20,]},   width = "200px", rownames = TRUE)

output$download0 <- downloadHandler(
    filename = function() {
      "basic_desc.csv"
    },
    content = function(file) {
      write.csv(basic_desc(), file, row.names = TRUE)
    }
  )

# box plot
output$bp = renderPlot({
  x = X()
  ggplot(x, aes(x = "", y = x[, 1])) + geom_boxplot(width = 0.2, outlier.colour = "red") + geom_jitter(width = 0.1, size = 1.5) + ylab("") + xlab("") + ggtitle("") + theme_minimal()
  })

output$info1 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("The approximate value: ", round(e$y, 4))
  }
  paste0("Horizontal position: ", "\n", xy_str(input$plot_click1))
})

output$meanp = renderPlot({
  x <- as.numeric(unlist(strsplit(input$x, "[\n, \t, ]")))
  des = data.frame(t(stat.desc(x)))
  #p1 = ggplot(des, aes(x = rownames(des), y = mean)) + geom_errorbar(width = .1, aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev),data = des) +
  #  xlab("") + ylab(expression(Mean %+-% SD)) + geom_point(shape = 21, size = 3) + theme_minimal() + theme(legend.title = element_blank())
  p2 = ggplot(des, aes(x = rownames(des), y = mean)) + xlab("") + ylab(expression(Mean %+-% SD)) +  geom_bar(position = position_dodge(),stat = "identity",width = 0.2, alpha = .3) +
    geom_errorbar(width = .1,position = position_dodge(.9),aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev),data = des) + theme_minimal() + theme(legend.title = element_blank())
 
  grid.arrange(p2)
  })

output$makeplot <- renderPlot({
  x <- Z()
  plot1 <- ggplot(x, aes(sample = x[, 1])) + stat_qq() + ggtitle("Normal Q-Q Plot") + xlab("") + theme_minimal()  ## add line,
  plot2 <- ggplot(x, aes(x = x[, 1])) + geom_histogram(colour = "black",fill = "grey",binwidth = input$bin, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  plot3 <- ggplot(x, aes(x = x[, 1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())
 
  grid.arrange(plot1, plot2, plot3, ncol = 3)
  })

t.test0 <- reactive({
  x <- X()
  res <-t.test(
    as.vector(x[, 1]),
    mu = input$mu,
    alternative = input$alt)
  res.table <- t(
    data.frame(
      T_statistic = res$statistic,
      P_value = res$p.value,
      Estimated_mean = res$estimate,
      Confidence_interval_0.95 = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4),")"),
      Degree_of_freedom = res$parameter
      )
    )
  colnames(res.table) <- res$method
  return(res.table)
  })

output$t.test <- renderTable({
  t.test0()}, width = "500px", rownames = TRUE)

output$download1 <- downloadHandler(
    filename = function() {
      "t_test.csv"
    },
    content = function(file) {
      write.csv(t.test0(), file, row.names = TRUE)
    }
  )

##---------- 2. Two sample t test---------

Y <- reactive({
  inFile <- input$file2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[\n, \t, ]")))
    Y <- as.numeric(unlist(strsplit(input$x2, "[\n, \t, ]")))
    x <- data.frame(X = X, Y = Y)
    names(x) = unlist(strsplit(input$cn2, "[\n, \t, ]"))
    return(x)
    }
  else {
    csv <- as.data.frame(
      read.csv(
        inFile$datapath,
        header = input$header2,
        sep = input$sep2
        )
      )
    return(csv)
  }
  
})

output$table2 <- renderDataTable({Y()}, options = list(pageLength = 5))

basic_desc2 <- reactive({
  x <- Y()
  res <- stat.desc(x, norm = TRUE)
  return(res)})

output$bas2 <- renderTable({
  res <- basic_desc2()[1:3,]
  rownames(res) = c("number.var", "number.null", "number.na")
  return(res)
  },   
  width = "200px", rownames = TRUE, digits = 0)

output$des2 <- renderTable({
  basic_desc2()[4:14,]
  },   
  width = "200px", rownames = TRUE)

output$nor2 <- renderTable({
  basic_desc2()[15:20,]
  },   
  width = "200px", rownames = TRUE)


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
  ggplot(mx, aes(x = mx[,"variable"], y = mx[,"value"], fill = mx[,"variable"])) + geom_boxplot(width = 0.4,outlier.colour = "red",alpha = .3) + geom_jitter(width = 0.1, size = 1.5) + ylab(" ") + xlab(" ") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
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
  paste0("Horizontal postion: ", "\n", xy_str(input$plot_click2))
  })

  # test result

var.test0 <- reactive({
  x <- Y()
  res <- var.test(as.vector(x[, 1]), as.vector(x[, 2]))
  res.table <- t(
    data.frame(
      F_statistic = res$statistic,
      P_value = res$p.value,
      Confidence_interval_0.95 = paste0("(", round(res$conf.int[1], digits = 4), ", ", round(res$conf.int[2], digits = 4),")"),
      Estimated_var_ratio = res$estimate
      )
    )
  colnames(res.table) <- res$method
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
    T_statistic = res$statistic,
    P_value = res$p.value,
    Estimated_mean_X = res$estimate[1],
    Estimated_mean_Y = res$estimate[2],
    Estimated_mean_diff = res$estimate[1] - res$estimate[2],
    Confidence_interval_0.95 = paste0("(",round(res$conf.int[1], digits = 4),", ", round(res$conf.int[2], digits = 4), ")" ),
    Degree_of_freedom = res$parameter
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
      T_statistic = res1$statistic,
      P_value = res1$p.value,
      Estimated_mean_X = res1$estimate[1],
      Estimated_mean_Y = res1$estimate[2],
      Estimated_mean_diff = res1$estimate[1] - res1$estimate[2],
      Confidence_interval_0.95 = paste0("(",round(res1$conf.int[1], digits = 4),", ",round(res1$conf.int[2], digits = 4),")"),
      Degree_of_freedom = res1$parameter
      )
    )

  res2.table <- cbind(res.table, res1.table)
  colnames(res2.table) <- c(res$method, res1$method)
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


##---------- 3. Paired sample t test ---------

  #data
Z <- reactive({
  # prepare dataset
  inFile <- input$file.p
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1.p, "[\n, \t, ]")))
    Y <- as.numeric(unlist(strsplit(input$x2.p, "[\n, \t, ]")))
    x <- data.frame(X = X, Y = Y)
    x$diff <- round(x[, 1] - x[, 2],4)
    names(x) = unlist(strsplit(input$cn.p, "[\n, \t, ]"))
    return(x)
    }
  else {
    csv <- as.data.frame(
      read.csv(
        inFile$datapath,
        header = input$header.p,
        sep = input$sep.p
      ))
    csv$diff <- round(csv[, 1] - csv[, 2],4)
   
    return(csv)
  }
})

output$table.p <-renderDataTable({Z()}, options = list(pageLength = 5))

basic_desc3 <- reactive({
  x <- Z()
  res <- stat.desc(x, norm = TRUE)
  return(res)})

output$bas.p <- renderTable({
  x <- Z()
  res <- basic_desc3()[1:3,]
  rownames(res) = c("number.var", "number.null", "number.na")
  return(res)
  },   
  width = "200px", rownames = TRUE, digits = 0)

output$des.p <- renderTable({
  basic_desc3()[4:14,]
  },   
  width = "200px", rownames = TRUE)

output$nor.p <- renderTable({
  basic_desc3()[15:20,]
  },   
  width = "200px", rownames = TRUE)


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
  ggplot(x, aes(x = "", y = x[, 3])) + geom_boxplot(width = 0.2, outlier.colour = "red") + geom_jitter(width = 0.1, size = 1.5) + ylab("") + xlab("") + ggtitle("") + theme_minimal()
  })

output$meanp.p = renderPlot({
  x = Z()
  des = data.frame(t(stat.desc(x)))
  #p1 = ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
  #  geom_errorbar(width = .1, aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev),data = des) +
  #  xlab("") + ylab(expression(Mean %+-% SD)) + geom_point(shape = 21, size = 3) + theme_minimal() + theme(legend.title = element_blank())

  p2 = ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + xlab("") + ylab(expression(Mean %+-% SD)) + geom_bar(position = position_dodge(),stat = "identity",width = 0.2,alpha = .3) +
    geom_errorbar(width = .1,position = position_dodge(.9),aes(ymin = mean - des$std.dev, ymax = mean + des$std.dev),data = des) + theme_minimal() + theme(legend.title = element_blank())
  
  grid.arrange(p2)
  })

output$info3 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("The approximate value: ", round(e$y, 4))
  }
  paste0("Horizontal postion: ", "\n", xy_str(input$plot_click3))
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
      T_statistic = res$statistic,
      P_value = res$p.value,
      Estimated_mean_diff = res$estimate,
      Confidence_interval_0.95 = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4),")"),
      Degree_of_freedom = res$parameter
      )
    )
  colnames(res.table) <- res$method
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

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
)



