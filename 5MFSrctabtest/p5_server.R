
##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- Panel 3: 2, C table ----------

T5 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x5, "[\n, \t, ]")))
  r <- length(unlist(strsplit(input$rn5, "[\n, \t, ]")))
  c <- length(unlist(strsplit(input$cn5, "[\n, \t, ]")))
  x <- matrix(x,r,c)

  rownames(x) = unlist(strsplit(input$rn5, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cn5, "[\n, \t, ]"))
  return(x)
  })

output$dt5 = renderTable({
  addmargins(T5(), 
    margin = seq_along(dim(T5())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "800px")

output$dt5.0 = renderTable({
  res = chisq.test(T5(), correct = FALSE)
  exp = res$expected
  return(exp)}, 
  width = "700px" ,rownames = TRUE, digits = 2)

output$dt5.1 = renderTable({prop.table(T5(), 1)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt5.2 = renderTable({prop.table(T5(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt5.3 = renderTable({prop.table(T5())}, width = "700px" ,rownames = TRUE, digits = 4)


output$makeplot5 <- renderPlot({  #shinysession 
  x <- as.data.frame(T5())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  #plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
 })

output$c.test5 = renderTable({
    x = as.matrix(T5())

    res = chisq.test(x=x, y=NULL,correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
    rownames = TRUE, width="700px")

