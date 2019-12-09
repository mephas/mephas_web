
##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- Panel 6: k,k table ----------

T6 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x6, "[\n, \t, ]")))
  x <- matrix(x,2,2)
  rn = unlist(strsplit(input$rn6, "[\n, \t, ]"))
  cn = unlist(strsplit(input$cn6, "[\n, \t, ]"))
  rownames(x) <- paste(rn[1], cn)
  colnames(x) <- paste(rn[2], cn)
  return(x)
  })

output$dt6 = renderTable({
  addmargins(T6(), 
    margin = seq_along(dim(T6())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "800px")

output$dt6.0 = renderTable({
  res = chisq.test(T6(), correct = FALSE)
  exp = res$expected
  return(exp)}, 
  width = "700px" ,rownames = TRUE, digits = 2)

output$dt6.1 = renderTable({prop.table(T6(), 1)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt6.2 = renderTable({prop.table(T6(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt6.3 = renderTable({prop.table(T6())}, width = "700px" ,rownames = TRUE, digits = 4)


output$makeplot6 <- renderPlot({  #shinysession 
  x <- as.data.frame(T6())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  })

output$c.test6 = renderTable({
    x = as.matrix(T6())
    res = cohen.kappa(x)
    res.table = t(data.frame(
      k.estimate = c(round(res$kappa, digits = 4)),
      var.kappa = c(round(res$var.kappa, digits = 4)),
     CI.0.95 = c(paste0("(",round(res$confid[1], digits = 4),", ",round(res$confid[5], digits = 4), ")"))
     ))
    colnames(res.table) <- c("Cohen's Kappa")
    rownames(res.table) <- c("Cohen's Kappa Statistic", "Variance of Kappa", "95% Confidence Interval")
    return(res.table)
    }, 
    rownames = TRUE, width="700px")

