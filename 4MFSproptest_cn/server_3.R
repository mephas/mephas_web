#****************************************************************************************************************************************************2.prop2

N = reactive({ # prepare dataset
  

  X <- as.numeric(unlist(strsplit(input$xx, "[\n,;\t ]")))
  Y <- as.numeric(unlist(strsplit(input$nn, "[\n,;\t ]")))
  validate(need(length(Y)==length(X), "请检查两组数据是否一样长。"))

  #P <- round(X/Z, 4)
  x <- rbind(X,(Y-X))
  validate(need((sum((Y-X)<0))==0, "请检查数据是否满足 x <= n"))
  validate(need(length(unlist(strsplit(input$ln3, "[\n]")))==nrow(x), "请检查数据的命名"))
  validate(need(length(unlist(strsplit(input$gn, "[\n]")))==ncol(x), "请检查数据的命名"))
  rownames(x) = unlist(strsplit(input$ln3, "[\n]"))
  colnames(x) = unlist(strsplit(input$gn, "[\n]"))
  return(x)
  })

output$n.t = DT::renderDT({
  addmargins(N(), 
    margin = seq_along(dim(N())), 
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

output$makeplot3 <- plotly::renderPlotly({  #shinysession 

  x<-as.data.frame(N())
  p<-plot_bar1(x)
  plotly::ggplotly(p)
  })  

output$n.test = DT::renderDT({
  x <- as.numeric(unlist(strsplit(input$xx, "[\n,;\t ]")))
  n <- as.numeric(unlist(strsplit(input$nn, "[\n,;\t ]")))
  validate(need((sum((n-x)<0))==0, "请检查数据是否满足 x <= n"))

  res = prop.test(x, n)
  res.table = t(data.frame(
    Statistic = round(res$statistic,6),
    Degree.of.freedom = round(res$parameter,6),
    Estimated.prop = toString(round(res$estimate,6)),
    P.value = round(res$p.value,6)
    ))
  colnames(res.table) = c(res$method)
  rownames(res.table) =c("X-squared Statistic", "Degree of Freedom","Estimated Probability/Proportions", "P Value")

  return(res.table)}, 

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "检验结果"),
        list(extend = 'excel', title = "检验结果")
        ),
    scrollX = TRUE))

