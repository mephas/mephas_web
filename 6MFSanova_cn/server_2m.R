#**************************************************************************************************************************************************** 2-2way

multiple2 <- eventReactive(input$M2,{
  x <- Y()
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

  return(round(res,6))
})

output$multiple.t2 <- DT::renderDT({multiple2()},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "多重比较结果"),
        list(extend = 'excel', title = "多重比较结果")
        ),
    scrollX = TRUE))





