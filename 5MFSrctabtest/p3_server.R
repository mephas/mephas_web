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

output$dt3 = renderTable({
  addmargins(T3(), 
    margin = seq_along(dim(T3())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "800px")

output$dt3.0 = renderTable({
  res = chisq.test(T3(), correct = FALSE)
  exp = res$expected
  return(exp)}, 
  width = "700px" ,rownames = TRUE, digits = 2)

output$dt3.1 = renderTable({prop.table(T3(), 1)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt3.2 = renderTable({prop.table(T3(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt3.3 = renderTable({prop.table(T3())}, width = "700px" ,rownames = TRUE, digits = 4)


output$makeplot3 <- renderPlot({  #shinysession 
  x <- as.data.frame(T3())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  #plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
# grid.arrange(plot1, plot2, ncol=2)
 }) 

output$c.test3 = renderTable({
    x = as.matrix(T3())

    res = chisq.test(x=x, y=NULL,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))

    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
    rownames = TRUE, width="700px")

