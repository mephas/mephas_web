#****************************************************************************************************************************************************

T2 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x2, "[,;\n\t ]")))
  validate(need(length(x)==4, "Please input 4 values"))

  x <- matrix(x,2,2, byrow=TRUE)
  validate(need(length(unlist(strsplit(input$cn2, "[\n]")))==2, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn2, "[\n]")))==2, "Please input correct row names"))

  rn = unlist(strsplit(input$rn2, "[\n]"))
  cn = unlist(strsplit(input$cn2, "[\n]"))
  rownames(x) <- paste(rn[1], cn)
  colnames(x) <- paste(rn[2], cn)
  return(x)
  })

output$dt2 = DT::renderDT({
  addmargins(T2(), 
    margin = seq_along(dim(T2())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt2.0 = DT::renderDT({
  res = chisq.test(T2())
  exp = round(res$expected,6)
  return(exp)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt2.1 = DT::renderDT({round(prop.table(T2(), 1),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt2.2 = DT::renderDT({round(prop.table(T2(), 2),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt2.3 = DT::renderDT({round(prop.table(T2()),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))


output$makeplot2 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T2())
  p<-plot_bar(x)
  plotly::ggplotly(p)
  })

output$c.test2 = DT::renderDT({
    x = as.matrix(T2())
    if (input$yt2 == TRUE){
    res = mcnemar.test(x=x,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
  else{
    res = mcnemar.test(x=x, correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("McNemar Chi-Square", "Degree of freedom", "P Value")
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

