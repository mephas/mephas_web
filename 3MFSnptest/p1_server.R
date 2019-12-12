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
names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1])
  })


  A <- reactive({
    inFile <- input$file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$a, "[,;\n\t ]")))
    x <- as.data.frame(x)
    colnames(x) = names1()
    }
else {
    x <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    x <- as.data.frame(x)[,1]
    if(input$header==FALSE){
      colnames(x) = names1()
      }
    }
    return(as.data.frame(x))
  })

  #table 
output$table <-renderDT({datatable(A() ,rownames = TRUE)})

  A.des <- reactive({
    x <- A()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names1()
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })

  output$bas <- renderTable({  
    res <- A.des()
    }, width = "500px", rownames = TRUE, colnames = TRUE)


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
  

  ws.test<- reactive({
    x <- A()
    if (input$alt.md =="a"){
    res <- wilcox.test((x[,1]), mu = input$med, 
      alternative = input$alt.wsr, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md =="b") {
    res <- wilcox.test((x[,1]), 
      mu = input$med, 
      alternative = input$alt.wsr, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], mu = input$med, 
      alternative = input$alt.wsr, exact=TRUE, conf.int = TRUE)

  }
  
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$ws.test.t <- renderTable({ws.test()},
    width = "500px", rownames = TRUE, colnames = TRUE)


output$download1 <- downloadHandler(
    filename = function() {
      "ws.csv"
    },
    content = function(file) {
      write.csv(ws.test(), file, row.names = TRUE)
    }
  )

