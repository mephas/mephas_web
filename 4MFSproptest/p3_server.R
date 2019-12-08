##----------#----------#----------#----------
##
## 4MFSproptest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

##---------- 3. More than 2 sample ----------

N = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$xx, "[\n, \t, ]")))
  Y <- as.numeric(unlist(strsplit(input$nn, "[\n, \t, ]")))
  #P <- round(X/Z, 4)
  x <- rbind(X,(Y-X))
  rownames(x) = unlist(strsplit(input$ln3, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$gn, "[\n, \t, ]"))
  return(x)
  })

output$n.t = renderTable({
  addmargins(N(), 
    margin = seq_along(dim(N())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  rownames = TRUE, width = "800px")

output$makeplot3 <- renderPlot({  #shinysession 
  X <- as.numeric(unlist(strsplit(input$xx, "[\n, \t, ]")))
  Y <- as.numeric(unlist(strsplit(input$nn, "[\n, \t, ]")))
  xm <- rbind(X,Y)
  rownames(xm) = unlist(strsplit(input$ln3, "[\n, \t, ]"))
  colnames(xm) = unlist(strsplit(input$gn, "[\n, \t, ]"))
  x <- melt(xm)
  ggplot(x, aes(fill=x[,1], y=x[,"value"], x=x[,2])) + geom_bar(position="fill", stat="identity")+ 
  xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })  

output$n.test = renderTable({
  x <- as.numeric(unlist(strsplit(input$xx, "[\n, \t, ]")))
  n <- as.numeric(unlist(strsplit(input$nn, "[\n, \t, ]")))
  res = prop.test(x, n)
  res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    Estimated.prop = toString(round(res$estimate,4)),
    P.value = round(res$p.value,6)
    ))
  colnames(res.table) = c(res$method)
  rownames(res.table) =c("X-squared Statistic", "Degree of Freedom","Estimated Probability/Proportions", "P Value")

  return(res.table)}, 
  rownames = TRUE, width = "800px")

