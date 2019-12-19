
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
names3 <- reactive({
  x <- unlist(strsplit(input$cn3, "[\n]"))
  return(x[1:3])
  })

  C <- reactive({
    inFile <- input$file3
    if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$y1, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$y2, "[,;\n\t]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    validate( need(sum(!is.na(Y))>1, "Please input enough valid numeric data") )
    validate( need(length(X)==length(Y), "Please make sure two groups have equal length") )
    d <- round(X-Y,4)
    x <- data.frame(X =X, Y = Y, diff = d)
    colnames(x) = names3()
  }

    else {
      if(!input$col3){
    csv <- read.csv(inFile$datapath, header = input$header3, sep = input$sep3)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header3, sep = input$sep3, row.names=1)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    x$diff <- round(x[, 2] - x[, 1], 4)
    if(input$header3==FALSE){
      colnames(x) = names.p()
      }
    }
    return(as.data.frame(x))
    })
  
  #table
output$table3 <-DT::renderDataTable({datatable(C() ,rownames = TRUE)})

  C.des <- reactive({
    x<- C()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })

  output$bas3 <- renderTable({  ## don't use renerPrint to do renderTable
    res <- C.des()}, width = "500px", rownames = TRUE, colnames = TRUE)
  
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
    ggplot(x, aes(x = 0, y = x[,3])) + geom_boxplot(width = 0.2, outlier.color = "red") + xlim(-1,1)+
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

psr.test <- reactive({
  x <- C()
  if (input$alt.md3 =="a"){
    res <- wilcox.test(x[,1], x[,2], paired = TRUE,
      alternative = input$alt.wsr3, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md3 =="b") {
    res <- wilcox.test(x[,1], x[,2], paired = TRUE,
      alternative = input$alt.wsr3, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md3 =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], x[,2],  paired = TRUE,
      alternative = input$alt.wsr3, exact=TRUE, conf.int = TRUE)

  }
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$psr.test.t <- renderTable({
    psr.test()}, width = "500px", rownames = TRUE)

  
output$download3.2 <- downloadHandler(
    filename = function() {
      "psr.csv"
    },
    content = function(file) {
      write.csv(psr.test(), file, row.names = TRUE)
    }
  )
