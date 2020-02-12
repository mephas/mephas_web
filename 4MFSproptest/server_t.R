#****************************************************************************************************************************************************4.prop.t

T4 = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$x4, "[\n,;\t ]")))
  Y <- as.numeric(unlist(strsplit(input$x44, "[\n,;\t ]")))
  validate(need(length(Y)==length(X), "Please check whether your data groups have equal length "))

  x <- rbind(X,Y-X)
  validate(need((sum((Y-X)<0))==0, "Please check your data whether x <= n"))
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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.2 = DT::renderDT({prop.table(T4(), 2)},

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot4 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T4())
  p<-plot_bar(x)
  plotly::ggplotly(p)
 }) 

output$c.test4 = DT::renderDT({
  X <- as.numeric(unlist(strsplit(input$x4, "[\n;\t, ]")))
  Y <- as.numeric(unlist(strsplit(input$x44, "[\n;\t, ]")))
  validate(need((sum((Y-X)<0))==0, "Please check your data whether x <= n"))

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
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

