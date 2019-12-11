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
name1 <- reactive({
  unlist(strsplit(input$cn1, "[\n, \t, ]"))
  }) 

Y1 <- reactive({
  inFile <- input$file1
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[\n, \t, ]")))
    F1 <-as.numeric(as.factor(unlist(strsplit(input$f11, "[\n, \t, ]"))))
    x <- data.frame(X = X, F1 = F1)
    }
  else {
    csv <- read.csv(
        inFile$datapath,
        header = input$header1,
        sep = input$sep1
        )
    x <- as.data.frame(csv)
  }
colnames(x) = name1()
return(x)
})

output$label1 <- renderTable({
  x <-matrix(levels(as.factor(unlist(strsplit(input$f11, "[\n, \t, ]")))),
    ncol=1)
  rownames(x) <- c(1:length(levels(as.factor(unlist(strsplit(input$f11, "[\n, \t, ]"))))))
  return(x)
  }, 
  width = "500px", rownames = TRUE, colnames=FALSE, digits = 4)

output$table1 <- renderDataTable({Y1()}, options = list(pageLength = 5))

output$bas1 <- renderTable({
  x <- Y1()
  n <- name1()
  res <- t(describeBy(x[,n[1]], x[,n[2]], mat=TRUE))[-c(1,2,3,8,9),]
  colnames(res) <- n
  rownames(res) <- c("Number of valid cases","Mean",
    "Standard Deviation", "Median", "Minimum","Maximum",
    "Range","Skew", "Kurtosis","Standard Error")
  return(res)
  },
  width = "500px", rownames = TRUE, colnames=FALSE, digits = 4)

output$download1.1 <- downloadHandler(
    filename = function() {
      "des.csv"
    },
    content = function(file) {
      write.csv(bas1(), file, row.names = TRUE)
    }
  )

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
    res.table <- summary(res)[[1]]
    rownames(res.table)[1] <- c(names(x)[2])
  return(res.table)
  })
output$anova1 <- renderTable({
  anova10()}, 
  width = "500px", rownames = TRUE)

output$download1 <- downloadHandler(
    filename = function() {
      "anv1.csv"
    },
    content = function(file) {
      write.csv(anova10(), file, row.names = TRUE)
    }
  )
