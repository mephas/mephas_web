
##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- Panel 9: 2,k kappa ----------

T9 = reactive({ # prepare dataset
  x1 <- as.numeric(unlist(strsplit(input$x9, "[,;\n\t ]")))
  x2 <- as.numeric(unlist(strsplit(input$x99, "[,;\n\t ]")))
  validate(need(length(x1)==length(x2), "Please input two groups of data with equal length"))
  x <- data.frame(x1=x1,x2=x2)

  validate(need(length(unlist(strsplit(input$cn9, "[\n]")))==2, "Please input correct column names"))

  colnames(x) <- unlist(strsplit(input$cn9, "[\n]"))
  rownames(x) <- paste0("Rater", 1:nrow(x))
  return(x)
  })

output$dt9 = DT::renderDataTable({T9()}, options = list(scrollX = TRUE))

output$dt9.0 =  DT::renderDataTable({
    x = T9()
    res = as.data.frame(cohen.kappa(x)$agree)[,3]
    res.table <- round(matrix(res, nrow=nrow(x), ncol=nrow(x)),6)
    rownames(res.table) <- paste0("Rater", 1:nrow(x))
    colnames(res.table) <- paste0("Rater", 1:nrow(x))
    return(res.table)
    }, options = list(scrollX = TRUE))

output$dt9.1 =  DT::renderDataTable({
    x = T9()
    res = as.data.frame(round(cohen.kappa(x)$weight,6))
    return(res)
    }, options = list(scrollX = TRUE))

#output$dt9.1 = renderTable({prop.table(T9(), 1)}, width = "700px" ,rownames = TRUE, digits = 4)

#output$dt9.2 = renderTable({prop.table(T9(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)

#output$dt9.3 = renderTable({prop.table(T9())}, width = "700px" ,rownames = TRUE, digits = 4)


output$c.test9 = renderTable({
    x = as.matrix(T9())
    res = cohen.kappa(x)
    res.table = res[["confid"]]
    colnames(res.table) =c("95% CI Low", "Kappa Estimate", "95% CI High")
    return(res.table)
    }, rownames = TRUE, width="700px")

