##----------#----------#----------#----------
##
## 6MFSanova SERVER
##
##		> P2
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
names2 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1:3])
  }) 

level21 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$f1, "[,;\n\t]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names2()[2]
  return(x)
  })
output$level.t21 <- renderTable({level21()},
   width = "700px", rownames=TRUE,colnames=TRUE)

level22 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$f2, "[,;\n\t]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names2()[3]
  return(x)
  })
output$level.t22 <- renderTable({level22()},
   width = "700px", rownames=TRUE,colnames=TRUE)


Y <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    F1 <- as.factor(unlist(strsplit(input$f1, "[,;\n\t]")))
    F2 <- as.factor(unlist(strsplit(input$f2, "[,;\n\t]")))
    validate( need(length(X)==length(F1)&length(X)==length(F2), "Please make sure two groups have equal length") )    
    x <- data.frame(X = X, F1 = F1, F2 = F2)
    colnames(x) = names2()
    }
  else {
if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, row.names=1, stringsAsFactors=TRUE)  
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

output$table <- DT::renderDataTable({datatable(Y() ,rownames = TRUE)})

bas <- reactive({
  x <- Y()
  x$grp <- paste0(x[,2]," : ",x[,3])
  res <- t(psych::describeBy(x[,1], x$grp, mat=TRUE))[-c(1,2,3,8,9),]
  colnames(res) <- levels(as.factor(x$grp))
  rownames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$bas.t <- renderTable({
  bas()}, 
  width = "700px", rownames = TRUE)

output$download2.1 <- downloadHandler(
    filename = function() {
      "des.csv"
    },
    content = function(file) {
      write.csv(bas(), file, row.names = TRUE)
    }
  )


output$meanp.a = renderPlot({
  x = Y()
  b = Rmisc::summarySE(x,colnames(x)[1], c(colnames(x)[2], colnames(x)[3]))

  if (input$tick == "TRUE"){
  ggplot(b, aes(x=b[,1], y=b[,4], colour=b[,2], group=b[,2])) + 
      geom_line() + xlab("") +ylab("")+
      geom_point(shape=21, size=3, fill="white") +
      theme_minimal() + theme(legend.title = element_blank())
    }

  else {
  ggplot(b, aes(x=b[,2], y=b[,4], colour=b[,1], group=b[,1])) + 
      geom_line() + xlab("") +ylab("")+
      geom_point(shape=21, size=3, fill="white") +
      theme_minimal() + theme(legend.title = element_blank())
  }

  })

output$mmean.a = renderPlot({
  x = Y()  
  b = Rmisc::summarySE(x,colnames(x)[1], c(colnames(x)[2], colnames(x)[3]))

  if (input$tick2 == "TRUE"){
  ggplot(b, aes(x=b[,1], y=b[,4], fill=b[,2])) + 
    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
    geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9))+
    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
    }

  else {
  ggplot(b, aes(x=b[,2], y=b[,4], fill=b[,1])) + 
    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
        geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9))+
    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  }

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
output$anova <- renderTable({
  anova0()
  }, 
  width = "700px", rownames = TRUE)

 output$download2 <- downloadHandler(
    filename = function() {
      "anv2.csv"
    },
    content = function(file) {
      write.csv(anova0(), file, row.names = TRUE)
    }
  )