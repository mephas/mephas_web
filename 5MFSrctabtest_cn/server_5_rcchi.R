#****************************************************************************************************************************************************

T5 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x5, "[,;\n\t ]")))
  r <- length(unlist(strsplit(input$rn5, "[\n]")))
  c <- length(unlist(strsplit(input$cn5, "[\n]")))

  validate(need(length(x)==r*c, "请检查数据输入是否有效。"))

  x <- matrix(x,r,c, byrow=TRUE)

  validate(need(length(unlist(strsplit(input$cn5, "[\n]")))==c, "请检查数据的命名"))
  validate(need(length(unlist(strsplit(input$rn5, "[\n]")))==r, "请检查数据的命名"))

  rownames(x) = unlist(strsplit(input$rn5, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn5, "[\n]"))
  return(x)
  })

output$dt5 = DT::renderDT({
  addmargins(T5(), 
    margin = seq_along(dim(T5())), 
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

output$dt5.0 = DT::renderDT({
  res = chisq.test(T5())
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

output$dt5.1 = DT::renderDT({round(prop.table(T5(), 1),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt5.2 = DT::renderDT({round(prop.table(T5(), 2),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt5.3 = DT::renderDT({round(prop.table(T5()),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))


output$makeplot5 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T5())
  p<-plot_bar(x)
  plotly::ggplotly(p)
 })

output$c.test5 = DT::renderDT({
    x = as.matrix(T5())

    res = chisq.test(x=x, y=NULL,correct = FALSE)
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

