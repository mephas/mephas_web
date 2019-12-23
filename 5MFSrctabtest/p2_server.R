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

output$dt2 = renderTable({
  addmargins(T2(), 
    margin = seq_along(dim(T2())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "800px")

output$dt2.0 = renderTable({
  res = chisq.test(T2(), correct = FALSE)
  exp = res$expected
  return(exp)}, 
  width = "700px" ,rownames = TRUE, digits = 2)

output$dt2.1 = renderTable({prop.table(T2(), 1)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt2.2 = renderTable({prop.table(T2(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt2.3 = renderTable({prop.table(T2())}, width = "700px" ,rownames = TRUE, digits = 4)


output$makeplot2 <- renderPlot({  #shinysession 
  x <- as.data.frame(T2())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  })

output$c.test2 = renderTable({
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
    rownames = TRUE, width="700px")

