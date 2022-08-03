#****************************************************************************************************************************************************

T9 = reactive({ # prepare dataset
  x1 <- as.numeric(unlist(strsplit(input$x9, "[,;\n\t ]")))
  x2 <- as.numeric(unlist(strsplit(input$x99, "[,;\n\t ]")))
  validate(need(length(x1)==length(x2), "Please input two groups of data with equal length"))
  x <- data.frame(x1=x1,x2=x2)

  validate(need(length(unlist(strsplit(input$cn9, "[\n]")))==2, "Please input correct column names"))

  colnames(x) <- unlist(strsplit(input$cn9, "[\n]"))
  rownames(x) <- paste0("Rater", 1:nrow(x))
  return(x)
  })

output$dt9 = DT::renderDT({T9()}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt9.0 =  DT::renderDT({
    x = T9()
    res = as.data.frame(psych::cohen.kappa(x)$agree)[,3]
    res.table <- round(matrix(res, nrow=nrow(x), ncol=nrow(x)),6)
    rownames(res.table) <- paste0("Rater", 1:nrow(x))
    colnames(res.table) <- paste0("Rater", 1:nrow(x))
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

output$dt9.1 =  DT::renderDT({
    x = T9()
    res = as.data.frame(round(psych::cohen.kappa(x)$weight,6))
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

output$c.test9 = DT::renderDT({
    x = as.matrix(T9())
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

