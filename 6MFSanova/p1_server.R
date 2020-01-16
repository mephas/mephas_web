#****************************************************************************************************************************************************1. 1way

names1 <- reactive({
  x <- unlist(strsplit(input$cn1, "[\n]"))
  return(x[1:2])
  }) 

level1 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$f11, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names1()[2]
  return(x)
  })
output$level.t1 <- DT::renderDT({level1()}, options = list(dom = 't'))

Y1 <- reactive({
  inFile <- input$file1
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )

    F1 <-as.factor(unlist(strsplit(input$f11, "[,;\n\t ]")))
    validate( need(length(X)==length(F1), "Please make sure two groups have equal length") )    
    x <- data.frame(X = X, F1 = F1)
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )

    colnames(x) = names1()
    }
  else {
if(!input$col1){
    csv <- read.csv(inFile$datapath, header = input$header1, sep = input$sep1, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header1, sep = input$sep1, row.names=1, stringsAsFactors=TRUE)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$header1==FALSE){
      colnames(x) = names1()
      }
    }
    return(as.data.frame(x))
})

#output$label1 <- DT::renderDT({
#  x <-matrix(levels(as.factor(unlist(strsplit(input$f11, "[\n]")))),
#    ncol=1)
#  rownames(x) <- c(1:length(levels(as.factor(unlist(strsplit(input$f11, "[\n]"))))))
#  return(x)
#  }, 
#  width = "500px", rownames = TRUE, colnames=FALSE, digits = 4)

output$table1 <- DT::renderDT(Y1(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

bas1 <- reactive({
  x <- Y1()
  res <- (describeBy(x[,1], x[,2], mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$bas1.t <- DT::renderDT({
  bas1()}, 
  #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$download1.1 <- downloadHandler(
#    filename = function() {
#      "des.csv"
#    },
#    content = function(file) {
#      write.csv(bas1(), file, row.names = TRUE)
#    }
#  )

output$mmean1 = renderPlot({
  x = Y1()
  b = Rmisc::summarySE(x,names(x)[1], names(x)[2])

  ggplot(b, aes(x=b[,1], y=b[,3], fill=b[,1])) + 
    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
    geom_errorbar(aes(ymin=b[,3]-b[,5], ymax=b[,3]+b[,5]),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9))+
    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

anova10 <- reactive({
  x <- Y1()
    res <- aov(x[,1]~x[,2])
    res.table <- anova(res)
    rownames(res.table)[1] <-colnames(x)[2]
    colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
  return(res.table)
  })

output$anova1 <- DT::renderDT({
  anova10()}, 
  #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$download1 <- downloadHandler(
#    filename = function() {
#      "anv1.csv"
#    },
#    content = function(file) {
#      write.csv(anova10(), file, row.names = TRUE)
#    }
#  )
