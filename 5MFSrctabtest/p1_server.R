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
    #class="row-border", 
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
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.1 = DT::renderDT({prop.table(T1(), 1)},
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.2 = DT::renderDT({prop.table(T1(), 2)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.3 = DT::renderDT({prop.table(T1())}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot1 <- renderPlot({  #shinysession 
  x <- as.data.frame(T1())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
})

output$makeplot1.1 <- renderPlot({  #shinysession 
  x <- as.data.frame(T1())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
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
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

