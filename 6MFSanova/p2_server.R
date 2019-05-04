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
Y <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x, "[\n, \t, ]")))
    F1 <- unlist(strsplit(input$f1, "[\n, \t, ]"))
    F2 <- unlist(strsplit(input$f2, "[\n, \t, ]"))
    Y <- data.frame(X = X, F1 = F1, F2 = F2)
    names(Y) = unlist(strsplit(input$cn, "[\n, \t, ]"))
    return(Y)
    }
  else {
    csv <- as.data.frame(
      read.csv(
        inFile$datapath,
        header = input$header,
        sep = input$sep
        )
      )
    return(csv)
  }
})

output$table <- renderDataTable({Y()}, options = list(pageLength = 5, scrollX = TRUE))

output$bas <- renderPrint({
  x <- Y()
  res <- describeBy(x[,1], x[,input$grp])
  #rownames(res) = c("number.var", "number.null", "number.na")
  return(res)
  })

output$meanp.a = renderPlot({
  x = Y()
  b = Rmisc::summarySE(x,names(x)[1], c(names(x)[2], names(x)[3]))

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
  b = Rmisc::summarySE(x,names(x)[1], c(names(x)[2], names(x)[3]))

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
    res.table <- summary(res)[[1]]
    rownames(res.table)[1:3] <- c(names(x)[2],names(x)[3], paste0(names(x)[2]," X ",names(x)[3]))
  }

  else {
    res <- aov(x[,1]~x[,2]+x[,3])
    res.table <- summary(res)[[1]]
    rownames(res.table)[1:2] <- names(x)[2:3]
  }
  
  return(res.table)
  })
output$anova <- renderTable({
  anova0()
  }, 
  width = "500px", rownames = TRUE)

 output$download2 <- downloadHandler(
    filename = function() {
      "anv2.csv"
    },
    content = function(file) {
      write.csv(anova0(), file, row.names = TRUE)
    }
  )