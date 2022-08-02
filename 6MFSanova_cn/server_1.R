#****************************************************************************************************************************************************1. 1way

names1 <- reactive({
  x <- unlist(strsplit(input$cn1, "[\n]"))
  return(x[1:2])
  }) 

Y1.0 <- reactive({
  inFile <- input$file1
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "请检查数据输入是否有效。") )

    F1 <-as.factor(unlist(strsplit(input$f11, "[,;\n\t ]")))
    validate( need(length(X)==length(F1), "请检查输入的数据和因子数据是否一样长。") )    
    x <- data.frame(X = X, F1 = F1)
    validate( need(sum(!is.na(x))>1, "请检查数据输入是否有效。") )

    colnames(x) = names1()
    }
  else {
if(!input$col1){
    csv <- read.csv(inFile$datapath, header = input$header1, sep = input$sep1, quote=input$quote1, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header1, sep = input$sep1, row.names=1, quote=input$quote1, stringsAsFactors=TRUE)  
    }
    validate( need(ncol(csv)>0, "请检查数据格式，列数是否有效。") )
    validate( need(nrow(csv)>1, "请检查数据格式，行数是否有效。") )

    x <- csv[,1:2]
    if(input$header1==FALSE){
      colnames(x) = names1()
      }
    }
    return(as.data.frame(x))
})


type.num <- reactive({
colnames(Y1.0()[unlist(lapply(Y1.0(), is.numeric))])
})

output$value = renderUI({
selectInput(
  'value',
  HTML('请选择要进行方差分析的变量'),
  choices = type.num()
  )
})


Y1 <- reactive({
  inFile <- input$file1
  if (is.null(inFile)) {
    x <- Y1.0()
  }
  else{
    x <- data.frame(
      value = Y1.0()[, input$value],
      factor = as.factor(Y1.0()[, -which(names(Y1.0()) %in% c(input$value))])
      )
    colnames(x) = c(input$value, names(Y1.0())[!names(Y1.0()) %in% input$value])

  }
  return(as.data.frame(x))
  })


level1 <- reactive({
  #F1 <-as.factor(unlist(strsplit(input$f11, "[,;\n\t ]")))
  F1 <- as.factor(Y1()[,2])
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names(Y1())[2]
  return(x)
  })
output$level.t1 <- DT::renderDT({level1()}, options = list(dom = 't'))



output$table1 <- DT::renderDT({Y1()},
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = 
      list('copy',
        list(extend = 'csv', title = "数据确认"),
        list(extend = 'excel', title = "数据确认")
        ),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

bas1 <- reactive({
  x <- Y1()
  res <- psych::describeBy(x[,1], x[,2], mat=TRUE)[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(round(res,6))
  })

output$bas1.t <- DT::renderDT({bas1()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "描述性统计量"),
        list(extend = 'excel', title = "描述性统计量")
        ),
    scrollX = TRUE))


output$mbp1 = plotly::renderPlotly({
  x = Y1()
  p<-plot_boxm(x)
  plotly::ggplotly(p)
  })

output$mmean1 = plotly::renderPlotly({
  x = Y1()
  p<- plot_msdm(x, names(x)[1], names(x)[2])
  plotly::ggplotly(p)
  })

anova10 <- reactive({
  x <- Y1()
    res <- aov(x[,1]~x[,2])
    res.table <- anova(res)
    rownames(res.table)[1] <-colnames(x)[2]
    colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
  return(round(res.table,6))
  })

output$anova1 <- DT::renderDT({anova10()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "方差分析表"),
        list(extend = 'excel', title = "方差分析表")
        ),
    scrollX = TRUE))


