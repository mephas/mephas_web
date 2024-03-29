#****************************************************************************************************************************************************4.prop.t

T4 = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$x4, "[\n,;\t ]")))
  Y <- as.numeric(unlist(strsplit(input$x44, "[\n,;\t ]")))
  validate(need(length(Y)==length(X), "请检查两组数据是否一样长。"))

  x <- rbind(X,Y-X)
  validate(need((sum((Y-X)<0))==0, "请检查数据是否满足r x <= n"))
  validate(need(length(unlist(strsplit(input$rn4, "[\n]")))==nrow(x), "请检查数据的命名"))
  validate(need(length(unlist(strsplit(input$cn4, "[\n]")))==ncol(x), "请检查数据的命名"))
  x <- as.matrix(x)
  rownames(x) = unlist(strsplit(input$rn4, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn4, "[\n]"))
  return(x)
  })

output$dt4 = DT::renderDT({
  addmargins(T4(), 
    margin = seq_along(dim(T4())), 
    FUN = list(Total=sum), quiet = TRUE)},  

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "数据表"),
        list(extend = 'excel', title = "数据表")
        ),
    scrollX = TRUE))

output$dt4.2 = DT::renderDT({round(prop.table(T4(), 2),6)},

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "百分比表"),
        list(extend = 'excel', title = "百分比表")
        ),
    scrollX = TRUE))


output$makeplot4 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T4())
  p<-plot_bar(x)
  plotly::ggplotly(p)
 }) 

output$c.test4 = DT::renderDT({
  X <- as.numeric(unlist(strsplit(input$x4, "[\n;\t, ]")))
  Y <- as.numeric(unlist(strsplit(input$x44, "[\n;\t, ]")))
  validate(need((sum((Y-X)<0))==0, "请检查数据是否满足r x <= n"))

  score <- as.numeric(unlist(strsplit(input$xs, "[\n;\t, ]")))

    res = prop.trend.test(X,Y,score)
    res.table = t(data.frame(
    Statistic = round(res$statistic,6),
    Degree.of.freedom = round(res$parameter,6),
    P.value = round(res$p.value,6)
    ))
  colnames(res.table) = c(res$method)
  rownames(res.table) =c("Chi-Squared Statistic", "Degree of Freedom", "P Value")
  return(res.table)
    }, 
 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "检验结果"),
        list(extend = 'excel', title = "检验结果")
        ),
    scrollX = TRUE))

