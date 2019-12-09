
##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

#----------  Panel 1: 2,2 independent ----------##

T1 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x1, "[\n, \t, ]")))
  x <- matrix(x,2,2)
  rownames(x) = unlist(strsplit(input$rn1, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cn1, "[\n, \t, ]"))
  return(x)
  })

output$dt1 = renderTable({
  addmargins(T1(), 
    margin = seq_along(dim(T1())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "800px")

output$dt1.0 = renderTable({
  res = chisq.test(T1(), correct = FALSE)
  exp = res$expected
  return(exp)}, 
  width = "700px" ,rownames = TRUE, digits = 2)

output$dt1.1 = renderTable({prop.table(T1(), 1)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt1.2 = renderTable({prop.table(T1(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt1.3 = renderTable({prop.table(T1())}, width = "700px" ,rownames = TRUE, digits = 4)


output$makeplot1 <- renderPlot({  #shinysession 
  x <- as.data.frame(T1())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  plot1 = ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
 grid.arrange(plot1, plot2, ncol=2)})

output$c.test1 = renderTable({
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
    rownames = TRUE, width="700px")

