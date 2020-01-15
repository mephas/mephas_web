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
namesm <- reactive({
  x <- unlist(strsplit(input$cnm, "[\n]"))
  return(x[1:2])
  }) 

level <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fm, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- namesm()[2]

  return(x)
  })

output$level.t <- DT::renderDT({level()},
   #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

Ym <- reactive({
  inFile <- input$filem
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xm, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )

    F1 <-as.factor(unlist(strsplit(input$fm, "[,;\n\t ]")))
    validate( need(length(X)==length(F1), "Please make sure two groups have equal length") )    
    x <- data.frame(X = X, F1 = F1)
    colnames(x) = namesm()
    }
  else {
  if(!input$colm){
    csv <- read.csv(inFile$datapath, header = input$headerm, sep = input$sepm, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$headerm, sep = input$sepm, row.names=1, stringsAsFactors=TRUE)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$headerm==FALSE){
      colnames(x) = namesm()
      }
    }
    return(as.data.frame(x))
})

output$tablem <- DT::renderDT(Ym(),
  #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

basm <- reactive({
  x <- Ym()
  res <- t(describeBy(x[,1], x[,2], mat=TRUE))[-c(1,2,3,8,9),]
  colnames(res) <- levels(x[,2])
  rownames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$basm.t <- DT::renderDT({
  basm()}, 
  #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$download.m <- downloadHandler(
#    filename = function() {
#      "des.csv"
#    },
#    content = function(file) {
#      write.csv(basm(), file, row.names = TRUE)
#    }
#  )

output$mmeanm = renderPlot({
  x = Ym()
  b = Rmisc::summarySE(x,names(x)[1], names(x)[2])

  ggplot(b, aes(x=b[,1], y=b[,3], fill=b[,1])) + 
    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
    geom_errorbar(aes(ymin=b[,3]-b[,5], ymax=b[,3]+b[,5]),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9))+
    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })


multiple <- reactive({
  x <- Ym()
  if (input$method == "B"){
    res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]], 
    p.adjust.method = "bonf")$p.value
  }
  if (input$method == "BH"){
    res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]], 
    p.adjust.method = "holm")$p.value
  }
  #if (input$method == "BHG"){
  #  res <- pairwise.t.test(x[,namesm()[1]], x[,namesm()[2]], 
  #  p.adjust.method = "hochberg")$p.value
  #}
  #  if (input$method == "BHL"){
  #  res <- pairwise.t.test(x[,namesm()[1]], x[,namesm()[2]], 
  #  p.adjust.method = "hommel")$p.value
  #}
    if (input$method == "FDR"){
    res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]], 
    p.adjust.method = "BH")$p.value
  }
    if (input$method == "BY"){
    res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]], 
    p.adjust.method = "BY")$p.value
  }
    if (input$method == "SF"){
    res <- DescTools::ScheffeTest(aov(x[,names(x)[1]]~x[,names(x)[2]]))[[1]]
    colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )
  }
    if (input$method == "TH"){
    res <- TukeyHSD(aov(x[,names(x)[1]]~x[,names(x)[2]]))[[1]]
    colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )

  }
    if (input$method == "DT"){
    x2 <- relevel(x[,names(x)[2]], ref=level()[input$control])
    res <- DescTools::DunnettTest(x[,names(x)[1]],x2)[[1]]
    colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )

  }
  res <- as.data.frame(res)
  return(res)
})

output$multiple.t <- DT::renderDT({multiple()},
  #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


 #output$download.m2 <- downloadHandler(
 #   filename = function() {
 #     "multiple.csv"
 #   },
 #   content = function(file) {
 #     write.csv(multiple(), file, row.names = TRUE)
 ##   }
 # )





