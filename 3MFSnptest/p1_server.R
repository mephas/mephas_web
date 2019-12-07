##----------#----------#----------#----------
##
## 3MFSnptest P1 SERVER
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

##########----------##########----------##########

##---------- 1. one sample ----------
  A <- reactive({
    inFile <- input$file
    if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$a, "[\n, \t, ]")))
    x <- data.frame(X =X)
    names(x) = unlist(strsplit(input$cn, "[\n, \t, ]"))
    return(x)}
    else {
      csv <- as.data.frame(read.csv(inFile$datapath, header=input$header, sep=input$sep))
      return(csv)} })

  #table 
  output$table <- renderDataTable({A()}, options = list(pageLength = 5))

  A.des <- reactive({
    X <- A()
    res <- stat.desc(X,norm=TRUE)
    return(res)
    })
  output$bas <- renderTable({  
    res <- A.des()[-11,]
    names(res) = c("How many values", "How many NULL values", "How many Missing values",
      "Minumum","Maximum","Range","Sum","Median","Mean","Standard Error", "Variance","Standard Deviation","Variation Coefficient",
      "Skewness Coefficient","Skew.2SE","Kurtosis Coefficient","Kurt.2SE","Normtest.W","Normtest.p")
    return(res)},   width = "500px", rownames = TRUE, colnames = FALSE, digits = 0)


  output$download1b <- downloadHandler(
    filename = function() {
      "des.csv"
    },
    content = function(file) {
      write.csv(A.des(), file, row.names = TRUE)
    }
  )

  #plot
   output$bp = renderPlot({
    x = A()
    ggplot(x, aes(x = "", y = x[,1])) + geom_boxplot(width = 0.2, outlier.colour = "red", outlier.size = 2) + 
    ylab("") + xlab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())}) 
  
  output$info <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position", "\n", xy_str(input$plot_click))})

  output$makeplot <- renderPlot({  #shinysession 
    x <- A()
    plot1 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin, position="identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title=element_blank())
    plot2 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })
  
  sign.test0 <- reactive({
    x <- A()
    res <- SignTest(as.vector(x[,1]), mu = input$med, alternative = input$alt.st)
    res.table <- t(data.frame(S = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("S Statistic", "P Value","Estimated Median","95% Confidence Interval")
    return(res.table)
    })
  output$sign.test<-renderTable({
    sign.test0()}, width = "500px", rownames = TRUE)

  ws.test0 <- reactive({x <- A()
    res <- wilcox.test(as.vector(x[,1]), mu = input$med, alternative = input$alt.wsr, correct = input$nap.wsr, conf.int = TRUE, conf.level = 0.95)
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)})
  
  output$ws.test<-renderTable({
    ws.test0()}, width = "500px", rownames = TRUE)

  output$download1.1 <- downloadHandler(
    filename = function() {
      "sign.csv"
    },
    content = function(file) {
      write.csv(sign.test0(), file, row.names = TRUE)
    }
  )

output$download1.2 <- downloadHandler(
    filename = function() {
      "ws.csv"
    },
    content = function(file) {
      write.csv(ws.test0(), file, row.names = TRUE)
    }
  )

