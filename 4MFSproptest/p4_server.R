##----------#----------#----------#----------
##
## 4MFSprop UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- Panel 4: 2, K table ----------

T4 = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$x4, "[\n, \t, ]")))
  Y <- as.numeric(unlist(strsplit(input$x44, "[\n, \t, ]")))
  x <- rbind(X,Y-X)
  x <- as.matrix(x)
  rownames(x) = unlist(strsplit(input$rn4, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cn4, "[\n, \t, ]"))
  return(x)
  })

output$dt4 = renderTable({
  addmargins(T4(), 
    margin = seq_along(dim(T4())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "800px")

output$dt4.2 = renderTable({prop.table(T4(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)


output$makeplot4 <- renderPlot({  #shinysession 
  x <- as.data.frame(T4())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  #plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
# grid.arrange(plot1, plot2, ncol=2)
 }) 

output$c.test4 = renderTable({
  X <- as.numeric(unlist(strsplit(input$x4, "[\n, \t, ]")))
  Y <- as.numeric(unlist(strsplit(input$x44, "[\n, \t, ]")))
  score <- as.numeric(unlist(strsplit(input$xs, "[\n, \t, ]")))

    res = prop.trend.test(X,Y,score)
    res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    P.value = round(res$p.value,6)
    ))
  colnames(res.table) = c(res$method)
  rownames(res.table) =c("Chi-Squared Statistic", "Degree of Freedom", "P Value")
  return(res.table)
    }, 
    rownames = TRUE, width="500px")

