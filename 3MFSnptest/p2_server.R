
##----------#----------#----------#----------
##
## 3MFSnptest P2 SERVER
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

##---------- 2. two samples ----------
names2 <- reactive({
  x <- unlist(strsplit(input$cn2, "[\n]"))
  return(x[1:2])
  })

B <- reactive({
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

output$table2 <-DT::renderDataTable({datatable(B() ,rownames = TRUE)})

  B.des <- reactive({
    x <- B()
    res <- stat.desc(x, norm = TRUE)
    return(res)
    })
  output$bas2 <- renderTable({  ## don't use renerPrint to do renderTable
    res <- B.des()[-11, ]
    rownames(res) = c("How many values", "How many NULL values", "How many Missing values",
      "Minumum","Maximum","Range","Sum","Median","Mean","Standard Error", "Variance","Standard Deviation","Variation Coefficient",
      "Skewness Coefficient","Skew.2SE","Kurtosis Coefficient","Kurt.2SE","Normtest.W","Normtest.p")
    return(res)},   width = "500px", rownames = TRUE, digits = 0)


  output$download2b <- downloadHandler(
    filename = function() {
      "desc2.csv"
    },
    content = function(file) {
      write.csv(B.des(), file, row.names = TRUE)
    }
  )

  #plot
  output$bp2 = renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    ggplot(mx, aes(x = variable, y = value, fill=variable)) + geom_boxplot(alpha=.3, width = 0.2, outlier.color = "red", outlier.size = 2)+ 
    ylab("") + ggtitle("") + theme_minimal() + theme(legend.title=element_blank()) })

  output$info2 <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position", "\n", xy_str(input$plot_click2))})

  output$makeplot2 <- renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    # density plot
    plot1 <- ggplot(mx, aes(x=mx[,"value"], fill=mx[,"variable"])) + geom_histogram(binwidth=input$bin2, alpha=.5, position="identity") + xlab("")+ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    plot2 <- ggplot(mx, aes(x=mx[,"value"], colour=mx[,"variable"])) + geom_density()+ xlab("")+ ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })

#test
  mwu.test0 <- reactive({
    x <- B()
    res <- wilcox.test(x[,1], x[,2], paired = FALSE, alternative = input$alt.mwt, correct = input$nap.mwt, conf.int = TRUE)
    res.table <- t(data.frame(
      W = res$statistic, 
      P = res$p.value, 
      ED = res$estimate,
      CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("W statistic", "P Value","Estimated Difference in Medians","95% Confidence Interval")

    return(res.table)
    })
  output$mwu.test<-renderTable({
    mwu.test0()}, width = "500px", rownames = TRUE)

  output$download2.1 <- downloadHandler(
    filename = function() {
      "mwu.csv"
    },
    content = function(file) {
      write.csv(mwu.test0(), file, row.names = TRUE)
    }
  )

  output$mood.test<-renderTable({
    X <- B()[,1]; Y <- B()[,2]
    data <- data.frame(value = c(X, Y), group = c(rep(1, length(X)), rep(2, length(Y))))
    res <- mood.medtest(value~group, data = data, alternative = input$alt.md)
    res.table <- t(data.frame(P_value = res$p.value))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("P Value")
    return(res.table)}, width = "500px", rownames = TRUE)
