##----------#----------#----------#----------
##
## 6MFSanova SERVER
##
##		> P3
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
namesm2 <- reactive({
  x <- unlist(strsplit(input$cnm2, "[\n]"))
  return(x[1:2])
  }) 

#level2 <- reactive({
#  F1 <-as.factor(unlist(strsplit(input$fm2, "[,;\n\t]")))
#  x <- matrix(levels(F1), nrow=1)
#  colnames(x) <- c(1:length(x))
#  return(x)
#  })

#output$level.t2 <- renderTable({level()},
#   width = "700px", colnames=TRUE)

Ym2 <- reactive({
  inFile <- input$filem2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xm2, "[,;\n\t ]")))
    F1 <- as.factor(unlist(strsplit(input$fm1, "[,;\n\t]")))
    F2 <- as.factor(unlist(strsplit(input$fm2, "[,;\n\t]")))
    x <- data.frame(X = X, F1 = F1, F2 = F2)
    colnames(x) = names2()
    }
  else {
    x <- read.csv(inFile$datapath,header = input$headerm2,sep = input$sepm2)
    x <- as.data.frame(x)[,1:3]
    if(input$headerm2==FALSE){
      colnames(x) = namesm2()
      }
    }
    return(as.data.frame(x))
})

output$tablem2 <- DT::renderDataTable({datatable(Ym2() ,rownames = TRUE)})

basm2 <- reactive({
  x <- Ym2()
  x$grp <- paste0(x[,2]," : ",x[,3])
  res <- t(psych::describeBy(x[,1], x$grp, mat=TRUE))[-c(1,2,3,8,9),]
  colnames(res) <- levels(as.factor(x$grp))
  rownames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$basm.t2 <- renderTable({
  basm2()}, 
  width = "700px", rownames = TRUE)

output$download.m22 <- downloadHandler(
    filename = function() {
      "des.csv"
    },
    content = function(file) {
      write.csv(basm2(), file, row.names = TRUE)
    }
  )

output$mmeanm2 = renderPlot({
  x = Ym2()
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


multiple2 <- reactive({
  x <- Ym2()
    if (input$methodm2 == "SF"){
    res1 <- DescTools::ScheffeTest(aov(x[,names(x)[1]]~x[,names(x)[2]]+x[,names(x)[3]]))[[1]]
    colnames(res1) <-NULL
    res2 <- DescTools::ScheffeTest(aov(x[,names(x)[1]]~x[,names(x)[2]]+x[,names(x)[3]]))[[2]]
    colnames(res2) <-NULL
    res <- rbind(res1,res2)
  }
    if (input$methodm2 == "TH"){
    res1 <- TukeyHSD(aov(x[,names(x)[1]]~x[,names(x)[2]]+x[,names(x)[3]]))[[1]]
    colnames(res1) <-NULL
    res2 <- TukeyHSD(aov(x[,names(x)[1]]~x[,names(x)[2]]+x[,names(x)[3]]))[[2]]
    colnames(res2) <-NULL
    res <- rbind.data.frame(res1,res2)
  }
  res <- as.data.frame(res)
  colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )

  return(res)
})

output$multiple.t2 <- renderTable({multiple2()},
  width = "700px", rownames = TRUE, colnames=TRUE, digits=6)


 output$download.m222 <- downloadHandler(
    filename = function() {
      "multiple.csv"
    },
    content = function(file) {
      write.csv(multiple2(), file, row.names = TRUE)
    }
  )





