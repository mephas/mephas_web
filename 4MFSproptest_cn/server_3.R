#****************************************************************************************************************************************************2.prop2

N = reactive({ # prepare dataset
  

  X <- as.numeric(unlist(strsplit(input$xx, "[\n,;\t ]")))
  Y <- as.numeric(unlist(strsplit(input$nn, "[\n,;\t ]")))
  validate(need(length(Y)==length(X), "Please check whether your data groups have equal length "))

  #P <- round(X/Z, 4)
  x <- rbind(X,(Y-X))
  validate(need((sum((Y-X)<0))==0, "Please check your data whether x <= n"))
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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$makeplot3 <- plotly::renderPlotly({  #shinysession 

  x<-as.data.frame(N())
  p<-plot_bar1(x)
  plotly::ggplotly(p)
  })  

output$n.test = DT::renderDT({
  x <- as.numeric(unlist(strsplit(input$xx, "[\n,;\t ]")))
  n <- as.numeric(unlist(strsplit(input$nn, "[\n,;\t ]")))
  validate(need((sum((n-x)<0))==0, "Please check your data whether x <= n"))

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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

