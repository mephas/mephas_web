##----------#----------#----------#----------
##
## 6MFSanova SERVER
##
##		> P1
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
namesnp2 <- reactive({
  x <- unlist(strsplit(input$cnnp2, "[\n]"))
  return(x[1:2])
  }) 

levelnp2 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fnp2, "[,;\n\t]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names1()[2]
  return(x)
  })
output$level.tnp2 <- renderTable({levelnp2()},
   width = "700px", rownames=TRUE,colnames=TRUE)

Ynp2 <- reactive({
  inFile <- input$filenp2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xnp2, "[,;\n\t]")))
    F1 <-as.factor(unlist(strsplit(input$fnp2, "[,;\n\t]")))
    x <- data.frame(X = X, F1 = F1)
    colnames(x) = names1()
    }
  else {
    x <- read.csv(inFile$datapath, header = input$headernp2, sep = input$sepnp2)
    x <- as.data.frame(x)[,1:2]
    if(input$headernp2==FALSE){
      colnames(x) = namesnp2()
      }
    }
    return(as.data.frame(x))
})

#output$label1 <- renderTable({
#  x <-matrix(levels(as.factor(unlist(strsplit(input$f11, "[\n]")))),
#    ncol=1)
#  rownames(x) <- c(1:length(levels(as.factor(unlist(strsplit(input$f11, "[\n]"))))))
#  return(x)
#  }, 
#  width = "500px", rownames = TRUE, colnames=FALSE, digits = 4)

output$tablenp2 <- DT::renderDataTable({datatable(Ynp2() ,rownames = TRUE)})

basnp2 <- reactive({
  x <- Ynp2()
  res <- t(psych::describeBy(x[,1], x[,2], mat=TRUE))[-c(1,2,3,8,9),]
  colnames(res) <- levels(x[,2])
  rownames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$basnp2.t <- renderTable({
  basnp2()}, 
  width = "500px", rownames = TRUE)

output$downloadnp2.1 <- downloadHandler(
    filename = function() {
      "des.csv"
    },
    content = function(file) {
      write.csv(basnp2(), file, row.names = TRUE)
    }
  )

output$mmeannp2 = renderPlot({
  x = Ynp2()
  ggplot(x, aes(y=x[,1], x=x[,2], fill=x[,2])) + geom_boxplot()+ xlab("") +ylab("")+
    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

dunntest <- reactive({
  x <- Ynp2()
  res <- dunn.test::dunn.test(x[,1], x[,2], method=input$methodnp2)
  res.table <- data.frame(Z=res$Z, P=res$P, Q=res$P.adjusted, row.names = res$comparisons)
  colnames(res.table) <- c("Kruskal-Wallis chi-squared", "P Value","Adjusted P value")
  return(res.table)
  })

output$dunntest.t <- renderTable({dunntest()
    },width = "500px", rownames = TRUE, colnames=TRUE)

output$downloadnp2.2 <- downloadHandler(
    filename = function() {
      "des.csv"
    },
    content = function(file) {
      write.csv(dunntest(), file, row.names = TRUE)
    }
  )
