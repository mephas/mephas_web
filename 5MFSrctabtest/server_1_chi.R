#****************************************************************************************************************************************************

T1 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t ]")))
  validate(need(length(x)==4, "Please input 4 values"))
  x <- matrix(x,2,2, byrow=TRUE)

  validate(need(length(unlist(strsplit(input$cn1, "[\n]")))==2, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn1, "[\n]")))==2, "Please input correct row names"))

  rownames(x) = unlist(strsplit(input$rn1, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn1, "[\n]"))
  return(x)
  })

output$dt1 = DT::renderDT({
  addmargins(T1(), 
    margin = seq_along(dim(T1())), 
    FUN = list(Total=sum), quiet = TRUE)},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE)
  )

output$dt1.0 = DT::renderDT({
  res = chisq.test(T1())
  exp = res$expected
  return(exp)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.1 = DT::renderDT({prop.table(T1(), 1)},
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.2 = DT::renderDT({prop.table(T1(), 2)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.3 = DT::renderDT({prop.table(T1())}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot1 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T1())
  p<-plot_bar(x)
  plotly::ggplotly(p)  
})

output$makeplot1.1 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(t(T1()))
  p<-plot_bar(x)
  plotly::ggplotly(p)
})

output$c.test1 = DT::renderDT({
    x = as.matrix(T1())
    if (input$yt1 == TRUE){
    res = chisq.test(x=x, y=NULL,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
  else{
    res = chisq.test(x=x, y=NULL,correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

