##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- 1. Fisher test 2,2 ----------

T4 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x4, "[\n, \t, ]")))
  x <- matrix(x,2,2)
  rownames(x) = unlist(strsplit(input$rn4, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cn4, "[\n, \t, ]"))
  return(x)
  })

output$dt4 = renderTable({
  addmargins(T4(), 
    margin = seq_along(dim(T4())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "800px")

output$dt4.0 = renderTable({
  res = chisq.test(T4(), correct = FALSE)
  exp = res$expected
  return(exp)}, 
  width = "700px" ,rownames = TRUE, digits = 2)

output$dt4.1 = renderTable({prop.table(T4(), 1)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt4.2 = renderTable({prop.table(T4(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)

output$dt4.3 = renderTable({prop.table(T4())}, width = "700px" ,rownames = TRUE, digits = 4)


output$makeplot4 <- renderPlot({  #shinysession 
  x <- as.data.frame(T4())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  plot1 = ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
 grid.arrange(plot1, plot2, ncol=2)})

output$c.test4 = renderTable({
    x = as.matrix(T4())
    res = fisher.test(x=x, y=NULL,alternative = input$yt4)
    res.table = t(data.frame(odds_ratio = res$estimate,                           
                            P_value = round(res$p.value,6),
                            CI = paste0("(", round(res$conf.int[1],4),",",round(res$conf.int[2],4), ")")
))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Odds Ratio (Group 1 vs Group 2)","P Value", "95% Confidence Interval")
    return(res.table)
    }, 
    rownames = TRUE, width="700px")

