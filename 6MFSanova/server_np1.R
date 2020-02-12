#****************************************************************************************************************************************************np-1way

namesnp1 <- reactive({
  x <- unlist(strsplit(input$cnnp1, "[\n]"))
  return(x[1:2])
  }) 


Ynp1.0 <- reactive({
  inFile <- input$filenp1
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xnp1, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    F1 <-as.factor(unlist(strsplit(input$fnp1, "[,;\n\t ]")))
    validate( need(length(X)==length(F1), "Please make sure two groups have equal length") )    
    x <- data.frame(X = X, F1 = F1)
    colnames(x) = names1()
    }
  else {
if(!input$colnp1){
    csv <- read.csv(inFile$datapath, header = input$headernp1, sep = input$sepnp1, quote=input$quotenp1, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$headernp1, sep = input$sepnp1, quote=input$quotenp1, row.names=1, stringsAsFactors=TRUE)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$headernp1==FALSE){
      colnames(x) = namesnp1()
      }
    }
    return(as.data.frame(x))
})

type.num3 <- reactive({
colnames(Ynp1.0()[unlist(lapply(Ynp1.0(), is.numeric))])
})

output$value3 = renderUI({
selectInput(
  'value3',
  HTML('For upload data, choose the numeric values'),
  choices = type.num3()
  )
})

Ynp1 <- reactive({
  inFile <- input$filenp1
  if (is.null(inFile)) {
    x <- Ynp1.0()
  }
  else{
    x <- data.frame(
      value = Ynp1.0()[, input$value3],
      factor = as.factor(Ynp1.0()[, -which(names(Ynp1.0()) %in% c(input$value3))])
      )
    colnames(x) = c(input$value3, names(Ynp1.0())[!names(Ynp1.0()) %in% input$value3])

  }
  return(as.data.frame(x))
  })


levelnp1 <- reactive({
F1 <- as.factor(Ynp1()[,2])  
x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names(Ynp1())[2]
  return(x)
  })
output$level.tnp1 <- DT::renderDT({levelnp1()}, options = list(dom = 't'))


output$tablenp1 <- DT::renderDT(Ynp1(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basnp1 <- reactive({
  x <- Ynp1()
  res <- (psych::describeBy(x[,1], x[,2], mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$basnp1.t <- DT::renderDT({
  basnp1()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$mmeannp1 = plotly::renderPlotly({
  x = Ynp1()
  p<-plot_boxm(x)
  plotly::ggplotly(p)
  })

output$kwtest <- DT::renderDT({
  x <- Ynp1()
  res <- kruskal.test(x[,1]~x[,2])
  res.table <- t(data.frame(W = res[["statistic"]][["Kruskal-Wallis chi-squared"]],
                            P = res[["p.value"]],
                            df= res[["parameter"]][["df"]]))
  colnames(res.table) <- res$method
  rownames(res.table) <- c("Kruskal-Wallis chi-squared", "P Value","Degree of Freedom")
  return(res.table)
    },
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))
