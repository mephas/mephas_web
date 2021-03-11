#****************************************************************************************************************************************************2-1way
output$dt.ref = renderUI({
selectInput(
'dt.ref',
tags$b('针对Dunnett方法，可以从上面的因子群中更改控制因子'),
selected = level1()[1],
choices = level1()
)
})

multiple <- eventReactive(input$M1, {
  x <- Y1()
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
    x2 <- relevel(x[,names(x)[2]], ref=input$dt.ref)
    res <- DescTools::DunnettTest(x[,names(x)[1]],x2)[[1]]
    colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )

  }
  res <- as.data.frame(res)
  return(round(res,6))
})

output$multiple.t <- DT::renderDT({multiple()},
  #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))







