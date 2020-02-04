#****************************************************************************************************************************************************2way

names2 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1:3])
  }) 

level21 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$f1, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names2()[2]
  return(x)
  })
output$level.t21 <- DT::renderDT({level21()}, options = list(dom = 't'))

level22 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$f2, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names2()[3]
  return(x)
  })
output$level.t22 <- DT::renderDT({level22()}, options = list(dom = 't'))


Y <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    F1 <- as.factor(unlist(strsplit(input$f1, "[,;\n\t ]")))
    F2 <- as.factor(unlist(strsplit(input$f2, "[,;\n\t ]")))
    validate( need(length(X)==length(F1)&length(X)==length(F2), "Please make sure two groups have equal length") )    
    x <- data.frame(X = X, F1 = F1, F2 = F2)
    colnames(x) = names2()
    }
  else {
if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1, stringsAsFactors=TRUE)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:3]
    if(input$header==FALSE){
      colnames(x) = names2()
      }
    }
    return(as.data.frame(x))
})

output$table <- DT::renderDT({Y()},
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))


output$bas.t <- DT::renderDT({
  x <- Y()
  if (input$bas.choice=="A"){
  res <- (psych::describeBy(x[,1], x[,2],mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
    }
  else if (input$bas.choice=="B"){
  res <- (psych::describeBy(x[,1], x[,3],mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,3])
    }
  else{
  x$grp <- paste0(x[,2]," : ",x[,3])
  res <- (psych::describeBy(x[,1], x$grp, mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(as.factor(x$grp))
    }
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  }, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$meanp.a = plotly::renderPlotly({
  x = Y()

  if (input$tick == "TRUE"){
  p<-plot_line2(x, names(x)[1], names(x)[2], names(x)[3])
    }

  else {
  p<-plot_line2(x, names(x)[1], names(x)[3], names(x)[2])
  }
  plotly::ggplotly(p)
  })

output$mmean.a = plotly::renderPlotly({
  x = Y()  

  if (input$tick2 == "TRUE"){
  p<-plot_msdm(x, names(x)[1], names(x)[2])
    }

  else {
  p<-plot_msdm(x, names(x)[1], names(x)[3])
  }
plotly::ggplotly(p)
  })

anova0 <- reactive({
  x <- Y()

  if (input$inter == "TRUE"){
    res <- aov(x[,1]~x[,2]*x[,3])
    res.table <- anova(res)
    rownames(res.table)[1:3] <- c(names(x)[2],names(x)[3], paste0(names(x)[2]," : ",names(x)[3]))
    colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
  }

  else {
    res <- aov(x[,1]~x[,2]+x[,3])
    res.table <- anova(res)
    rownames(res.table)[1:2] <- names(x)[2:3]
    colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")

  }
  
  return(res.table)
  })
output$anova <- DT::renderDT({
  anova0()
  }, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

