#****************************************************************************************************************************************************

T5 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x5, "[,;\n\t ]")))
  r <- length(unlist(strsplit(input$rn5, "[\n]")))
  c <- length(unlist(strsplit(input$cn5, "[\n]")))

  validate(need(length(x)==r*c, "Please input enough values"))

  x <- matrix(x,r,c, byrow=TRUE)

  validate(need(length(unlist(strsplit(input$cn5, "[\n]")))==c, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn5, "[\n]")))==r, "Please input correct row names"))

  rownames(x) = unlist(strsplit(input$rn5, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn5, "[\n]"))
  return(x)
  })

output$dt5 = DT::renderDT({
  addmargins(T5(), 
    margin = seq_along(dim(T5())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt5.0 = DT::renderDT({
  res = chisq.test(T5())
  exp = res$expected
  return(exp)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt5.1 = DT::renderDT({prop.table(T5(), 1)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt5.2 = DT::renderDT({prop.table(T5(), 2)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt5.3 = DT::renderDT({prop.table(T5())}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot5 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T5())
  p<-plot_bar(x)
  plotly::ggplotly(p)
  #mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  #ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  #plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
 })

output$c.test5 = DT::renderDT({
    x = as.matrix(T5())

    res = chisq.test(x=x, y=NULL,correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

