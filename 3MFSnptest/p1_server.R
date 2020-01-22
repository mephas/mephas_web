#****************************************************************************************************************************************************1.np1

names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1])
  })


  A <- reactive({
    inFile <- input$file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$a, "[,;\n\t]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    colnames(x) = names1()
    }
  else {
    if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, row.names=1)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- as.data.frame(csv[,1])
    colnames(x) <- names(csv)[1]
    #validate( need(sum(!is.na(csv))>1, "Please input enough valid numeric data") )
    if(input$header!=TRUE){
      names(x) <- names1()
      }
    }
  x <- as.data.frame(x)
  })

  #table 
output$table <- DT::renderDT(A(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

  A.des <- reactive({
    x <- A()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })

  output$bas <- DT::renderDT({  
    res <- A.des()
    },
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

   output$bp = plotly::renderPlotly({
    x = A()
    var <- names(x)[1]
    p<-MFSbox1(x, var)
    plotly::ggplotly(p)
    #ggplot(x, aes(x = 0, y = x[,1])) + geom_boxplot(width = 0.2, outlier.colour = "red", outlier.size = 2) + xlim(-1,1)+
    #ylab("") + xlab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    }) 
  
  # output$info <- renderText({
  #   xy_str = function(e) {
  #     if(is.null(e)) return("NULL\n")
  #     paste0("Click to get the value: ", round(e$y, 4))
  #   }
  #   paste0("Y-axis position", "\n", xy_str(input$plot_click))})

  output$makeplot <- plotly::renderPlotly({  #shinysession 
    x <- A()
    var <- names(x)[1]
    p <- MFShist1(x, var, input$bin)
    plotly::ggplotly(p)
    
    #ggplot(x, aes(x = x[,1])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin, position="identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title=element_blank())
    })
  output$makeplot.1 <- plotly::renderPlotly({  #shinysession 
    x <- A()
    var <- names(x)[1]
    p <- MFSdensity1(x, var)
    plotly::ggplotly(p)
    #ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title=element_blank())
    })
  

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

  output$ws.test.t <- DT::renderDT({ws.test()},
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

