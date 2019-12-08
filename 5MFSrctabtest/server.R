if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(psych)) {install.packages("psych")}; library(psych)
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)

##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyServer(
function(input, output) {
  
##########----------##########----------##########

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
  
##---------- 1. Chi-square test for R by C table ----------
T = reactive({ # prepare dataset
  x = as.numeric(unlist(strsplit(input$x, "[\n, \t, ]")))
  T = matrix(x, input$r, input$c)
  rownames(T) = unlist(strsplit(input$rn, "[\n, \t, ]"))
  colnames(T) = unlist(strsplit(input$cn, "[\n, \t, ]"))
  return(T)})

output$ct = renderDataTable({addmargins(T(), margin = seq_along(dim(T())), FUN = sum, quiet = TRUE)})

output$c.test = renderTable({
    x = T()
    res = chisq.test(x, correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
    res1 = chisq.test(x, correct = TRUE)
    res1.table = t(data.frame(X_statistic = res1$statistic,                            
                              Degree_of_freedom = res1$parameter,
                              P_value = res1$p.value))
    res2.table = cbind(res.table, res1.table)
    colnames(res2.table) <- c(res$method, res1$method)
    return(res2.table)}, rownames = TRUE)

output$c.e = renderTable({
  x = T()
  res = chisq.test(x, correct = FALSE)
  exp = res$expected
  return(exp)
}, rownames = TRUE, digits = 4)

output$prt = renderTable({prop.table(T(), 1)}, width = "50" ,rownames = TRUE, digits = 4)

output$pct = renderTable({prop.table(T(), 2)}, width = "50" ,rownames = TRUE, digits = 4)

output$pt = renderTable({prop.table(T())}, width = "50" ,rownames = TRUE, digits = 4)

output$makeplot <- renderPlot({  #shinysession 
    x <- as.data.frame(T())
    mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
    plot1 = ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
    plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
    grid.arrange(plot1, plot2, ncol=2)})

##---------- 2. Chi-square test for 2 by C table ----------
TR = reactive({ # prepare dataset
  inFile <- input$file2
    if (is.null(inFile)) {
      X <- as.numeric(unlist(strsplit(input$suc, "[\n, \t, ]")))
      Y <- as.numeric(unlist(strsplit(input$fail, "[\n, \t, ]")))
      Z <- X+Y
      P <- round(X/Z, 4)
      x <- data.frame(Case = X, Control = Y, Total = Z, Percentage = P)
      #names(x) = unlist(strsplit(input$cn2, "[\n, \t, ]"))
      return(x)}
    else {
      csv <- as.data.frame(read.csv(inFile$datapath, header=TRUE, sep=input$sep))
      return(csv)}
    })

#output$ct.tr = renderDataTable({addmargins(TR(), margin = seq_along(dim(TR())), FUN = sum, quiet = TRUE)},  width = "50" ,rownames = TRUE)
output$ct.tr = renderDataTable({TR()})

#output$pct.tr = renderTable({prop.table(TR(), 2)}, width = "50" ,rownames = TRUE, digits = 4)

output$tr.test = renderTable({
  x = TR()
  res = prop.trend.test(x$Case, x$Total)
  res.table = t(data.frame(X_statistic = res$statistic,                            
                            Degree_of_freedom = res$parameter,
                            P_value = res$p.value))
  colnames(res.table) <- c(res$method)
    return(res.table)}, rownames = TRUE)

output$makeplot.tr <- renderPlot({  #shinysession 
    x <- TR()
    ggplot(x, aes(x = rownames(x), y = x[,"Percentage"]))+geom_bar(stat = "identity", width = 0.5, position = position_dodge()) + ylab("Proportion") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
})

##---------- 3. Kappa test for K by K table ----------

K = reactive({ # prepare dataset
  x = as.numeric(unlist(strsplit(input$k, "[\n, \t, ]")))
  T = matrix(x, input$r.k, input$r.k)
  rownames(T) = unlist(strsplit(input$rater, "[\n, \t, ]"))
  colnames(T) = unlist(strsplit(input$rater, "[\n, \t, ]"))
  return(T)})

output$kt = renderDataTable({addmargins(K(), margin = seq_along(dim(K())), FUN = sum, quiet = TRUE)})

output$k.test = renderTable({

  x = K()
  k = cohen.kappa(x)
  res.table = data.frame(k.estimate = c(round(k$kappa, digits = 4), round(k$weighted.kappa, digits = 4)),
               CI.0.95 = c(paste0("(",round(k$confid[1], digits = 4),", ",round(k$confid[5], digits = 4), ")"),
                          paste0("(",round(k$confid[2], digits = 4),", ",round(k$confid[6], digits = 4), ")")),
               row.names = c("Kappa", "Weighted.kappa"))
  return(res.table)}, rownames = TRUE)

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


})



