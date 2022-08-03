#****************************************************************************************************************************************************

T6 = reactive({ # prepare dataset
  rn = unlist(strsplit(input$rn6, "[\n]"))
  cn = unlist(strsplit(input$cn6, "[\n]"))

  x <- as.numeric(unlist(strsplit(input$x6, "[,;\n\t ]")))
  validate(need(length(x)==length(cn)*length(cn), "请检查数据输入是否有效。"))
  x <- matrix(x,length(cn),length(cn), byrow=TRUE)

  validate(need(length(cn)==ncol(x), "请检查数据的命名。"))
  validate(need(length(rn)==2, "请检查数据的命名。"))

  rownames(x) <- paste0(rn[1], " : ",cn)
  colnames(x) <- paste0(rn[2], " : ",cn)
  return(x)
  })

output$dt6 = DT::renderDT({
  addmargins(T6(), 
    margin = seq_along(dim(T6())), 
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

output$dt6.0 = DT::renderDT({
   x = as.matrix(T6())
  res = round(psych::cohen.kappa(x)$agree,6)
    return(res)
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

output$dt6.1 = DT::renderDT({
   x = as.matrix(T6())
  res = round(psych::cohen.kappa(x)$weight,6)
    return(res)
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

output$c.test6 = DT::renderDT({
    x = as.matrix(T6())
    res = psych::cohen.kappa(x)
    res.table = round(res[["confid"]],6)
    colnames(res.table) =c("95% CI Low", "Kappa Estimate", "95% CI High")
    return(res.table)
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

