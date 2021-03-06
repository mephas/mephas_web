#****************************************************************************************************************************************************

T3 = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$x3, "[,;\n\t ]")))
  Y <- as.numeric(unlist(strsplit(input$x33, "[,;\n\t ]")))
  validate(need(length(X)==length(Y), "Please input two groups of data with equal length"))
  x <- rbind(X,Y)
  x <- as.matrix(x)
  validate(need(length(unlist(strsplit(input$cn3, "[\n]")))==ncol(x), "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn3, "[\n]")))==2, "Please input correct row names"))

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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt3.0 = DT::renderDT({
  res = chisq.test(T3())
  exp = round(res$expected,6)
  return(exp)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt3.1 = DT::renderDT({round(prop.table(T3(), 1),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt3.2 = DT::renderDT({round(prop.table(T3(), 2),6)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt3.3 = DT::renderDT({round(prop.table(T3()),6)},
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

