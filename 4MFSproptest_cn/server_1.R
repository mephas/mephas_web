#****************************************************************************************************************************************************1.prop1

output$b.test = DT::renderDT({
validate(need(input$n>=input$x, "请检查数据是否满足 x <= n"))
  res = binom.test(x = input$x, n= input$n, p = input$p, alternative = input$alt)

   res.table = t(data.frame(
    Num.success = round(res$statistic,6),
    Num.trial = round(res$parameter,6),
    Estimated.prob.success = round(res$estimate,6),
    p.value = round(res$p.value,6),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],6),",",round(res$conf.int[2],6), ")")
    ))

  colnames(res.table) = res$method
  rownames(res.table) =c("Number of Success/Events", "Number of Total Trials/Samples", "Estimated Probability/Proportion", "P Value", "95% Confidence Interval")
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

output$b.test1 = DT::renderDT({
validate(need(input$n>=input$x, "请检查数据是否满足 x <= n"))
  res = prop.test(x = input$x, n= input$n, p = input$p, alternative = input$alt, correct = TRUE)

    res.table = t(data.frame(
    X.squared = round(res$statistic,6),
    Estimated.prob.success = round(res$estimate,6),
    p.value = round(res$p.value,6),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],6),",",round(res$conf.int[2],6), ")")
    ))

  colnames(res.table) = res$method
  rownames(res.table) =c("X-squared Statistic", "Estimated Probability/Proportion", "P Value", "95% Confidence Interval")
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
 

output$makeplot <- plotly::renderPlotly({  #shinysession 
  x = data.frame(
    group = c(unlist(strsplit(input$ln, "[\n]"))), 
    value = c(input$x, input$n-input$x)
    )
  plot_piely(x)
  })