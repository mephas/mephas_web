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

##########----------##########----------##########

##---------- 1. one sample ----------
#source("p1_server.R", local=TRUE)$value
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


##---------- 2. two samples ----------

#source("p2_server.R", local=TRUE)$value
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
    plot1 <- ggplot(mx, aes(x=mx[,"value"], fill=mx[,"variable"])) + geom_histogram(binwidth=input$bin2, alpha=.5, position="identity") + ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    plot2 <- ggplot(mx, aes(x=mx[,"value"], colour=mx[,"variable"])) + geom_density()+ ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
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
 
##---------- 3. paired sample ----------
#source("p3_server.R", local=TRUE)$value
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

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
  
##########----------##########----------##########

})


