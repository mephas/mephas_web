#****************************************************************************************************************************************************

T6 = reactive({ # prepare dataset
  rn = unlist(strsplit(input$rn6, "[\n]"))
  cn = unlist(strsplit(input$cn6, "[\n]"))

  x <- as.numeric(unlist(strsplit(input$x6, "[,;\n\t ]")))
  validate(need(length(x)==length(cn)*length(cn), "Please input enough values"))
  x <- matrix(x,length(cn),length(cn), byrow=TRUE)

  validate(need(length(cn)==ncol(x), "Please input correct names"))
  validate(need(length(rn)==2, "Please input correct names"))

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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt6.0 = DT::renderDT({
   x = as.matrix(T6())
  res = round(cohen.kappa(x)$agree,6)
    return(res)
}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt6.1 = DT::renderDT({
   x = as.matrix(T6())
  res = round(cohen.kappa(x)$weight,6)
    return(res)
}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$c.test6 = DT::renderDT({
    x = as.matrix(T6())
    res = cohen.kappa(x)
    res.table = round(res[["confid"]],6)
    colnames(res.table) =c("95% CI Low", "Kappa Estimate", "95% CI High")
    return(res.table)
    }, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

