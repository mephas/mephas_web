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
names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))[1]
  return(x)
  })


X <- reactive({
  validate( need(as.numeric(unlist(strsplit(input$x, "[,;\n\t]"))), "Please input numeric data") )

  inFile <- input$file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[,;\n\t]")))
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
    validate( need(ncol(csv)>0, "Please Check row names, column names, and spectators") )
    x <- data.frame(x=csv[,1])
    colnames(x) <- names(csv)[1]
    if(input$header!=TRUE){
      colnames(x) <- names1()
      }
    }
    return(as.data.frame(x))
  })

output$table <- DT::renderDataTable({X()},server = FALSE)

basic_desc <- reactive({
  x <- X()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas <- renderTable({
  basic_desc()
  }, width = "500px", rownames = TRUE, colnames = TRUE)

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
  ggplot(x, aes(x = 0, y = x[,1])) + geom_boxplot(width = 0.2, outlier.colour = "red") + xlim(-1,1) + ylab("") + xlab(names(x)) + ggtitle("") + theme_minimal()
  })

output$info1 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("The approximate value: ", round(e$y, 4))
  }
  paste0("Horizontal position", "\n", xy_str(input$plot_click1))
})

output$meanp = renderPlot({
  x = X()
  des = data.frame((psych::describe(x)))
  rownames(des) = names(x)
  p2 = ggplot(des, aes(x = rownames(des), y = mean)) + 
  geom_bar(position = position_dodge(),stat = "identity",width = 0.2, alpha = .3) +
  geom_errorbar(width = .1,position = position_dodge(.9),aes(ymin = mean - des$sd, ymax = mean + des$sd),data = des) + 
  xlab("") + ylab(expression(Mean %+-% SD)) + 
  theme_minimal() + theme(legend.title = element_blank())
 
  grid.arrange(p2)
  })

output$makeplot <- renderPlot({
  x = X()
  plot1 <- ggplot(x, aes(sample = x[,1])) + stat_qq() + ggtitle("Normal Q-Q Plot") + xlab("") + theme_minimal()  ## add line,
  plot2 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin, position = "identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title =element_blank())
  plot3 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title =element_blank())
 
  grid.arrange(plot1, plot2, plot3, ncol = 3)
  })

t.test0 <- reactive({
  x <- X()
  validate( need(length(x)>1, "Please input enough data") )
  res <-t.test(
    x[,1],
    mu = input$mu,
    alternative = input$alt)
  res.table <- t(
    data.frame(
      T = round(res$statistic, digits=4),
      P = res$p.valu,
      E.M = round(res$estimate, digits=4),
      CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4),")"),
      DF = res$parameter
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("T Statistic", "P Value","Estimated Mean","95% Confidence Interval","Degree of Freedom")

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