##----------#----------#----------#----------
##
## 2MFSttest SERVER
##
##    >Panel 1
##
## Language: EN
##
## DT: 2019-05-04
##
##----------#----------#----------#----------
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
  res <- basic_desc()[4:14,]
  names(res) = c("min","max","range","sum","median","mean","SE.mean","CI.mean.0.95","var","std.dev","coef.var")
  return(res)}, 
    width = "200px", rownames = TRUE)

output$nor <- renderTable({
  res <- basic_desc()[15:20,]
  names(res) = c("skewness","skew.2SE","kurtosis","kurt.2SE","normtest.W","normtest.p")
  return(res)},   width = "200px", rownames = TRUE)

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