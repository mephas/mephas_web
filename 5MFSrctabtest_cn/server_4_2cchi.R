#****************************************************************************************************************************************************

T3 = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$x3, "[,;\n\t ]")))
  Y <- as.numeric(unlist(strsplit(input$x33, "[,;\n\t ]")))
  validate(need(length(X)==length(Y), "请输入等长度的两组数据。"))
  x <- rbind(X,Y)
  x <- as.matrix(x)
  validate(need(length(unlist(strsplit(input$cn3, "[\n]")))==ncol(x), "请检查数据的命名。"))
  validate(need(length(unlist(strsplit(input$rn3, "[\n]")))==2, "请检查数据的命名。"))

  rownames(x) = unlist(strsplit(input$rn3, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn3, "[\n]"))
  return(x)
  })

output$dt3 = DT::renderDT({
  addmargins(T3(), 
    margin = seq_along(dim(T3())), 
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

output$dt3.0 = DT::renderDT({
  res = chisq.test(T3())
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

output$dt3.1 = DT::renderDT({round(prop.table(T3(), 1),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt3.2 = DT::renderDT({round(prop.table(T3(), 2),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt3.3 = DT::renderDT({round(prop.table(T3()),6)},
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))


output$makeplot3 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T3())
  p<-plot_bar(x)
  plotly::ggplotly(p)

 }) 

output$c.test3 = DT::renderDT({
    x = as.matrix(T3())

    res = chisq.test(x=x, y=NULL,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))

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

