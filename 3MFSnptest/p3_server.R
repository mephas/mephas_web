
##----------#----------#----------#----------
##
## 3MFSnptest P3 SERVER
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

##---------- 3. paired sample ----------

  C <- reactive({
    inFile <- input$file3
    if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$y1, "[\n, \t, ]")))
    Y <- as.numeric(unlist(strsplit(input$y2, "[\n, \t, ]")))
    d <- X-Y
    x <- data.frame(X =X, Y = Y, diff = d)
  }

    else {
      csv <- read.csv(inFile$datapath, header=input$header3, sep=input$sep3)
      x <- as.data.frame(csv)
      x$diff <- round(x[, 1] - x[, 2],4)
      } 

    names(x) = unlist(strsplit(input$cn3, "[\n, \t, ]"))
    return(x)

    })
  
  #table
  output$table3 <- renderDataTable({C()}, options = list(pageLength = 5))

  C.des <- reactive({
     x<- C()
    res <- stat.desc(x, norm=TRUE)
    return(res)
    })

  output$bas3 <- renderTable({  ## don't use renerPrint to do renderTable
    res <- C.des()[-11, 3]
    names(res) = c("How many values", "How many NULL values", "How many Missing values",
      "Minumum","Maximum","Range","Sum","Median","Mean","Standard Error", "Variance","Standard Deviation","Variation Coefficient",
      "Skewness Coefficient","Skew.2SE","Kurtosis Coefficient","Kurt.2SE","Normtest.W","Normtest.p")
    return(res)},   width = "500px", rownames = TRUE, colnames=FALSE, digits = 4)
  
  output$download3b <- downloadHandler(
    filename = function() {
      "desc3.csv"
    },
    content = function(file) {
      write.csv(C.des(), file, row.names = TRUE)
    }
  )
  # plots
  output$bp3 = renderPlot({
    x <- C()
    ggplot(x, aes(x = "", y = x[,3])) + geom_boxplot(width = 0.2, outlier.color = "red") + 
    ylab("") + ggtitle("") + theme_minimal()})

  output$info3 <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position", "\n", xy_str(input$plot_click3))})

  output$makeplot3 <- renderPlot({
    x <- C()
    plot1 <- ggplot(x, aes(x=x[,3])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin3, alpha=.5, position="identity") + ylab("Frequncy") + xlab("") +  ggtitle("Histogram") + theme_minimal() + theme(legend.title=element_blank())
    plot2 <- ggplot(x, aes(x=x[,3])) + geom_density() + ggtitle("Density Plot") + theme_minimal() + ylab("Density") + xlab("") + theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })

psr.test0 <- reactive({
  x <- C()
    res <- wilcox.test(x[,1], x[,2], paired = TRUE, alternative = input$alt.pwsr, correct = input$nap, conf.int = TRUE)
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              ED = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Z Statistic", "P Value","Estimated Difference Median","95% Confidence Interval")


    return(res.table)
  })

  output$psr.test <- renderTable({
    psr.test0()}, width = "500px", rownames = TRUE)

  psign.test0 <- reactive({
    x <- C()
    res <- SignTest(x[,1], x[,2], alternative = input$alt.ps)
    res.table <- t(data.frame(S = res$statistic,
                              P = res$p.value,
                              ED = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("S Statistic", "P Value","Estimated Difference Median","95% Confidence Interval")

    return(res.table)
    })
 output$psign.test <- renderTable({
    psign.test0()}, width = "500px", rownames = TRUE)


output$download3.1 <- downloadHandler(
    filename = function() {
      "psign.csv"
    },
    content = function(file) {
      write.csv(psign.test0(), file, row.names = TRUE)
    }
  )
output$download3.2 <- downloadHandler(
    filename = function() {
      "psr.csv"
    },
    content = function(file) {
      write.csv(psr.test0(), file, row.names = TRUE)
    }
  )
