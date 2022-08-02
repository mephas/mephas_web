#****************************************************************************************************************************************************2.prop2

T = reactive({ # prepare dataset
  validate(need(input$n1>=input$x1, "请检查数据是否满足 x1 <= n1"))
  validate(need(input$n2>=input$x2, "请检查数据是否满足 x2 <= n2"))

 x <- matrix(c(input$x1,input$n1-input$x1,input$x2,input$n2-input$x2),2,2, byrow=TRUE)
  validate(need(length(unlist(strsplit(input$rn.2, "[\n]")))==2, "请检查数据的命名"))
  validate(need(length(unlist(strsplit(input$cn.2, "[\n]")))==2, "请检查数据的命名"))
  rownames(x) = unlist(strsplit(input$rn.2, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn.2, "[\n]"))
  return(x)
  })

output$n.t2 = DT::renderDT({
  addmargins(T(), 
    margin = seq_along(dim(N())), 
    FUN = list(Total=sum), quiet = TRUE)},  

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "数据确认"),
        list(extend = 'excel', title = "数据确认")
        ),
    scrollX = TRUE))

output$makeplot2 <- plotly::renderPlotly({  #shinysession 
  validate(need(input$n1>=input$x1, "请检查数据是否满足 x <= n"))
  #validate(need(input$n2>=input$x2, "请检查数据是否满足 x <= n"))
    x1 = data.frame(
    group = c(unlist(strsplit(input$cn.2, "[\n]"))), 
    value = c(input$x1, input$n1-input$x1)
    )
  plot_piely(x1)
    
  })
output$makeplot2.1 <- plotly::renderPlotly({  #shinysession 
  #validate(need(input$n1>=input$x1, "请检查数据是否满足 x <= n"))
  validate(need(input$n2>=input$x2, "请检查数据是否满足 x <= n"))
    x2 = data.frame(
    group = c(unlist(strsplit(input$cn.2, "[\n]"))), 
    value = c(input$x2, input$n2-input$x2)
    )
  plot_piely(x2)
  })

output$p.test = DT::renderDT({
  validate(need(input$n1>=input$x1, "请检查数据是否满足 x <= n"))
  validate(need(input$n2>=input$x2, "请检查数据是否满足 x <= n"))
  x <- c(input$x1, input$x2)
  n <- c(input$n1, input$n2)
  res = prop.test(x = x, n= n, alternative = input$alt1, correct = input$cr)
  res.table = t(data.frame(
    Statistic = round(res$statistic,6),
    Degree.of.freedom = round(res$parameter,6),
    Estimated.prop = paste0("prop.1 = ",round(res$estimate[1],6),", ","prop.2 = ",round(res$estimate[2],6)),
    P.value = round(res$p.value,6),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],6),",",round(res$conf.int[2],6), ")")
))

  colnames(res.table) = c(res$method)
    rownames(res.table) =c("X-squared Statistic", "Degree of Freedom","Estimated Probability/Proportion", "P Value", "95% Confidence Interval")

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


