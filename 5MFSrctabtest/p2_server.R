##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
#----------  Panel 2: 2,2 dependent ----------##

T2 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x2, "[\n, \t, ]")))
  x <- matrix(x,2,2)
  rownames(x) = unlist(strsplit(input$rn2, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cn2, "[\n, \t, ]"))
  return(x)
  })

output$dt2 = renderTable({
  addmargins(T2(), 
    margin = seq_along(dim(T2())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "500px")

output$dt2.1 = renderTable({prop.table(T2(), 1)}, width = "400px" ,rownames = TRUE, digits = 4)

output$dt2.2 = renderTable({prop.table(T2(), 2)}, width = "400px" ,rownames = TRUE, digits = 4)

output$dt2.3 = renderTable({prop.table(T2())}, width = "400px" ,rownames = TRUE, digits = 4)


output$makeplot2 <- renderPlot({  #shinysession 
  x <- as.data.frame(T2())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  plot1 = ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
 grid.arrange(plot1, plot2, ncol=2)})

output$c.test2 = renderTable({
    x = as.matrix(T2())
    if (input$yt2 == TRUE){
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
    rownames = TRUE, width="500px")

