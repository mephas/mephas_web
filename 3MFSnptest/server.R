if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(DescTools)) {install.packages("DescTools")}; library(DescTools)  #SignTest
if (!require(RVAideMemoire)) {install.packages("RVAideMemoire")}; library(RVAideMemoire)  
if (!require(pastecs)) {install.packages("pastecs")}; library(pastecs)
##----------#----------#----------#----------
##
## 3MFSnptest SERVER
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
shinyServer(

 function(input, output) {

##---------- 1. one sample ----------
  A <- reactive({
    inFile <- input$file
    if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$a, "[\n, \t, ]")))
    x <- data.frame(X =X)
    names(x) = unlist(strsplit(input$cn, "[\n, \t, ]"))
    return(x)}
    else {
      csv <- as.data.frame(read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote))
      return(csv)} })

  #table 
  output$table <- renderDataTable({A()}, options = list(pageLength = 5))

  output$bas <- renderTable({  
    X <- as.numeric(unlist(strsplit(input$a, "[\n, \t, ]")))
    res <- stat.desc(X)[1:3]
    names(res) = c("number.var", "number.null", "number.na")
    #names(res) = unlist(strsplit(input$cn, "[\n, \t, ]"))
    return(res)},   width = "200px", rownames = TRUE, digits = 0)

  output$des <- renderTable({  
    X <- as.numeric(unlist(strsplit(input$a, "[\n, \t, ]")))
    res <- stat.desc(X)[4:14 ]
    #names = unlist(strsplit(input$cn, "[\n, \t, ]"))
    return(res)},   width = "200px", rownames = TRUE)

  output$nor <- renderTable({  
    X <- as.numeric(unlist(strsplit(input$a, "[\n, \t, ]")))
    res <- stat.desc(X, norm = TRUE)[15:20]
    #names(res) = unlist(strsplit(input$cn, "[\n, \t, ]"))
    return(res)},   width = "200px", rownames = TRUE)
  
  #plot
   output$bp = renderPlot({
    x = A()
    ggplot(x, aes(x = "", y = x[,1])) + geom_boxplot(width = 0.2, outlier.colour = "red", outlier.size = 2) + geom_jitter(width = 0.1, size = 1.5) + ylab("") + xlab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())}) 
  
  output$info <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position: ", "\n", xy_str(input$plot_click))})

  output$makeplot <- renderPlot({  #shinysession 
    x <- A()
    plot1 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin, position="identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title=element_blank())
    plot2 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })
  
  output$sign.test<-renderTable({
    x <- A()
    res <- SignTest(as.vector(x[,1]), mu = input$med, alternative = input$alt.st)
    res.table <- t(data.frame(S_statistic = res$statistic,
                              P_value = res$p.value,
                              Estimated_median = res$estimate,
                              Confidence_interval_0.95 = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    return(res.table)}, width = "500px", rownames = TRUE)

  output$ws.test<-renderTable({
    x <- A()
    res <- wilcox.test(as.vector(x[,1]), mu = input$med, alternative = input$alt.wsr, correct = input$nap.wsr, conf.int = TRUE, conf.level = 0.95)
    res.table <- t(data.frame(Z_statistic = res$statistic,
                              P_value = res$p.value,
                              Estimated_median = res$estimate,
                              Confidence_interval_0.95 = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    return(res.table)}, width = "500px", rownames = TRUE)

##---------- 2. two samples ----------

  B <- reactive({
    inFile <- input$file2
    if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[\n, \t, ]")))
    Y <- as.numeric(unlist(strsplit(input$x2, "[\n, \t, ]")))
    x <- data.frame(X =X, Y = Y)
    names(x) = unlist(strsplit(input$cn2, "[\n, \t, ]"))
    return(x)}
    else {
      csv <- as.data.frame(read.csv(inFile$datapath, header=input$header2, sep=input$sep2))
      return(csv)}
       })
  
  #table
  output$table2 <- renderDataTable({B()}, options = list(pageLength = 5))

  output$bas2 <- renderTable({  ## don't use renerPrint to do renderTable
    x <- B()
    res <- stat.desc(x)[1:3, ]
    rownames(res) = c("number.var", "number.null", "number.na")
    return(res)},   width = "200px", rownames = TRUE, digits = 0)

  output$des2 <- renderTable({  
    x <- B()
    res <- stat.desc(x)[4:14, ]
    return(res)},   width = "200px", rownames = TRUE)

  output$nor2 <- renderTable({  
    x <- B()
    res <- stat.desc(x, norm = TRUE)[15:20, ]
    return(res)},   width = "200px", rownames = TRUE)

  #plot
  output$bp2 = renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    ggplot(mx, aes(x = "variable", y = "value", fill="variable")) + geom_boxplot(alpha=.3, width = 0.2, outlier.color = "red", outlier.size = 2) + geom_jitter(width = 0.1, size = 1.5) + ylab("") + ggtitle("") + theme_minimal() + theme(legend.title=element_blank()) })

  output$info2 <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position: ", "\n", xy_str(input$plot_click2))})

  output$makeplot2 <- renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    # density plot
    plot1 <- ggplot(mx, aes(x=mx[,"value"], fill=mx[,"variable"])) + geom_histogram(binwidth=input$bin2, alpha=.5, position="identity") + ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    plot2 <- ggplot(mx, aes(x=mx[,"value"], colour=mx[,"variable"])) + geom_density()+ ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })

#test
  output$mwu.test<-renderTable({
    x <- B()
    res <- wilcox.test(x[,1], x[,2], paired = FALSE, alternative = input$alt.mwt, correct = input$nap.mwt, conf.int = TRUE)
    res.table <- t(data.frame(W_statistic = res$statistic, P_value = res$p.value, Estimated_diff = res$estimate,
                              Confidence_interval_0.95 = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- c(res$method)
    return(res.table)}, width = "500px", rownames = TRUE)

  output$mood.test<-renderTable({
    X <- B()[,1]; Y <- B()[,2]
    data <- data.frame(value = c(X, Y), group = c(rep(1, length(X)), rep(2, length(Y))))
    res <- mood.medtest(value~group, data = data, alternative = input$alt.md)
    res.table <- t(data.frame(P_value = res$p.value))
    colnames(res.table) <- c(res$method)
    return(res.table)}, width = "500px", rownames = TRUE)

##---------- 3. paired sample ----------

  C <- reactive({
    inFile <- input$file3
    if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$y1, "[\n, \t, ]")))
    Y <- as.numeric(unlist(strsplit(input$y2, "[\n, \t, ]")))
    d <- X-Y
    x <- data.frame(X =X, Y = Y, diff = d)
    names(x) = unlist(strsplit(input$cn3, "[\n, \t, ]"))
    return(x)}
    else {
      csv <- as.data.frame(read.csv(inFile$datapath, header=input$header3, sep=input$sep3))
      csv$diff <- round(csv[, 1] - csv[, 2],4)
      return(csv)} })
  
  #table
  output$table3 <- renderDataTable({C()}, options = list(pageLength = 5))

  output$bas3 <- renderTable({  ## don't use renerPrint to do renderTable
    x <- C()
    res <- stat.desc(x)[1:3, ]
    rownames(res) = c("number.var", "number.null", "number.na")
    return(res)},   width = "200px", rownames = TRUE, digits = 0)

  output$des3 <- renderTable({  
    x <- C()
    res <- stat.desc(x)[4:14, ]
    return(res)},   width = "200px", rownames = TRUE)

  output$nor3 <- renderTable({  
    x <- C()
    res <- stat.desc(x, norm = TRUE)[15:20, ]
    return(res)},   width = "200px", rownames = TRUE)
  
  # plots
  output$bp3 = renderPlot({
    x <- C()
    mx <- melt(C(), idvar = colnames(x))
    ggplot(mx, aes(x = "variable", y = "value", fill="variable")) + geom_boxplot(alpha=.3, width = 0.2, outlier.color = "red", outlier.size = 2) + geom_jitter(width = 0.1, size = 1.5) + ylab("") + ggtitle("") + theme_minimal() + theme(legend.title=element_blank()) })

  output$info3 <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position: ", "\n", xy_str(input$plot_click3))})

  output$makeplot3 <- renderPlot({
    x <- C()
    plot1 <- ggplot(x, aes(x=x[,3])) + geom_histogram(binwidth=.3, alpha=.5, position="identity") + ylab("Frequncy") + xlab("") +  ggtitle("Histogram") + theme_minimal() + theme(legend.title=element_blank())
    plot2 <- ggplot(x, aes(x=x[,3])) + geom_density() + ggtitle("Density Plot") + theme_minimal() + ylab("Density") + xlab("") + theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })


  output$psr.test <- renderTable({
    x <- C()
    res <- wilcox.test(x[,1], x[,2], paired = TRUE, alternative = input$alt.pwsr, correct = input$nap, conf.int = TRUE)
    res.table <- t(data.frame(W_statistic = res$statistic,
                              P_value = res$p.value,
                              Estimated_diff = res$estimate,
                              Confidence_interval_0.95 = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- c(res$method)
    return(res.table)}, width = "500px", rownames = TRUE)

 output$psign.test <- renderTable({
    x <- C()
    res <- SignTest(x[,1], x[,2], alternative = input$alt.ps)
    res.table <- t(data.frame(S_statistic = res$statistic,
                              P_value = res$p.value,
                              Estimated_diff = res$estimate,
                              Confidence_interval_0.95 = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    return(res.table)}, width = "500px", rownames = TRUE)


 
observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
  


})


