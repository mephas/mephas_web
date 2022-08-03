#****************************************************************************************************************************************************

T1 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t ]")))
  validate(need(length(x)==4, "请输入4个值"))
  x <- matrix(x,2,2, byrow=TRUE)

  validate(need(length(unlist(strsplit(input$cn1, "[\n]")))==2, "请检查数据的命名"))
  validate(need(length(unlist(strsplit(input$rn1, "[\n]")))==2, "请检查数据的命名"))

  rownames(x) = unlist(strsplit(input$rn1, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn1, "[\n]"))
  return(x)
  })

output$dt1 = DT::renderDT({
  addmargins(T1(), 
    margin = seq_along(dim(T1())), 
    FUN = list(Total=sum), quiet = TRUE)},

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE)
  )

output$dt1.0 = DT::renderDT({
  res = chisq.test(T1())
  exp = round(res$expected,6)
  return(exp)
  }, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "检验结果"),
        list(extend = 'excel',  title = "检验结果")
        ),
    scrollX = TRUE))

output$dt1.1 = DT::renderDT({round(prop.table(T1(), 1),6)},
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt1.2 = DT::renderDT({round(prop.table(T1(), 2),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt1.3 = DT::renderDT({round(prop.table(T1()),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))


output$makeplot1 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T1())
  p<-plot_bar(x)
  plotly::ggplotly(p)  
})

output$makeplot1.1 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(t(T1()))
  p<-plot_bar(x)
  plotly::ggplotly(p)
})

output$c.test1 = DT::renderDT({
    x = as.matrix(T1())
    if (input$yt1 == TRUE){
    res = chisq.test(x=x, y=NULL,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
  else{
    res = chisq.test(x=x, y=NULL,correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Chi-Square", "Degree of freedom", "P Value")
    return(round(res.table,6))
    }, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

