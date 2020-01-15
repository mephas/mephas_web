##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
#----------  Panel 3: 2,2 dependent mcnemar ----------##

T2 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x2, "[,;\n\t ]")))
  validate(need(length(x)==4, "Please input 4 values"))

  x <- matrix(x,2,2, byrow=TRUE)
  validate(need(length(unlist(strsplit(input$cn2, "[\n]")))==2, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn2, "[\n]")))==2, "Please input correct row names"))

  rn = unlist(strsplit(input$rn2, "[\n]"))
  cn = unlist(strsplit(input$cn2, "[\n]"))
  rownames(x) <- paste(rn[1], cn)
  colnames(x) <- paste(rn[2], cn)
  return(x)
  })

output$dt2 = DT::renderDT({
  addmargins(T2(), 
    margin = seq_along(dim(T2())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt2.0 = DT::renderDT({
  res = chisq.test(T2())
  exp = res$expected
  return(exp)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt2.1 = DT::renderDT({prop.table(T2(), 1)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt2.2 = DT::renderDT({prop.table(T2(), 2)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt2.3 = DT::renderDT({prop.table(T2())}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot2 <- renderPlot({  #shinysession 
  x <- as.data.frame(T2())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  })

output$c.test2 = DT::renderDT({
    x = as.matrix(T2())
    if (input$yt2 == TRUE){
    res = mcnemar.test(x=x,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
  else{
    res = mcnemar.test(x=x, correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("McNemar Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

