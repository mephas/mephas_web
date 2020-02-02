#**************************************************************************************************************************************************** 2-2way

namesm2 <- reactive({
  x <- unlist(strsplit(input$cnm2, "[\n]"))
  return(x[1:2])
  }) 

level21m <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fm1, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- namesm2()[2]
  return(x)
  })
output$level.t21m <- DT::renderDT({level21m()}, options = list(dom = 't'))

level22m <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fm2, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- namesm2()[3]
  return(x)
  })
output$level.t22m <- DT::renderDT({level22m()}, options = list(dom = 't'))

Ym2 <- reactive({
  inFile <- input$filem2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xm2, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    F1 <- as.factor(unlist(strsplit(input$fm1, "[,;\n\t ]")))
    F2 <- as.factor(unlist(strsplit(input$fm2, "[,;\n\t ]")))
    validate( need(length(X)==length(F1)&length(X)==length(F2), "Please make sure two groups have equal length") )    
    x <- data.frame(X = X, F1 = F1, F2 = F2)
    colnames(x) = namesm2()
    }
  else {
if(!input$colm2){
    csv <- read.csv(inFile$datapath, header = input$headerm2, sep = input$sepm2, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$headerm2, sep = input$sepm2, row.names=1, stringsAsFactors=TRUE)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:3]
    if(input$headerm2==FALSE){
      colnames(x) = namesm2()
      }
    }
    return(as.data.frame(x))
})

output$tablem2 <- DT::renderDT(Ym2(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

output$bas.t2 <- DT::renderDT({
  x <- Ym2()
  if (input$bas.choice2=="A"){
  res <- (psych::describeBy(x[,1], x[,2],mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
    }
  else if (input$bas.choice2=="B"){
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

#output$download.m22 <- downloadHandler(
#    filename = function() {
#      "des.csv"
#    },
##    content = function(file) {
 #     write.csv(basm2(), file, row.names = TRUE)
 ##   }
 # )

#output$mmeanm2 = renderPlot({
#  x = Ym2()
  # = Rmisc::summarySE(x,colnames(x)[1], c(colnames(x)[2], colnames(x)[3]))

#  if (input$tick2 == "TRUE"){
  #ggplot(b, aes(x=b[,1], y=b[,4], fill=b[,2])) + 
  #  geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
  #  geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
  #                width=.2,                    # Width of the error bars
  #                position=position_dodge(.9))+
  #  scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  #  }

  #else {
  #ggplot(b, aes(x=b[,2], y=b[,4], fill=b[,1])) + 
  #  geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
  #      geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
  #                width=.2,                    # Width of the error bars
  #                position=position_dodge(.9))+
  #  scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  #}

  #})


output$meanp.am = plotly::renderPlotly({
  x = Ym2()

  if (input$tickm == "TRUE"){
  p<-plot_line2(x, names(x)[1], names(x)[2], names(x)[3])
    }

  else {
  p<-plot_line2(x, names(x)[1], names(x)[3], names(x)[2])
  }
  plotly::ggplotly(p)
  })

output$mmean.am = plotly::renderPlotly({
  x = Ym2()  
  if (input$tick2m == "TRUE"){
  p<-plot_msdm(x, names(x)[1], names(x)[2])
    }

  else {
  p<-plot_msdm(x, names(x)[1], names(x)[3])
  }
plotly::ggplotly(p)
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

output$multiple.t2 <- DT::renderDT({multiple2()},
  #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))





