if (!require(Hmisc)) {install.packages("Hmisc")}; library(Hmisc)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)

##----------#----------#----------#----------
##
## 4MFSproptest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyServer( 
function(input, output) {

##########----------##########----------##########

##----------1. Chi-square test for single sample ----------
output$b.test = renderTable({

  res = binom.test(x = input$x, n= input$n, p = input$p, alternative = input$alt)

   res.table = t(data.frame(
    Num.success = res$statistic,
    Num.trial = res$parameter,
    Estimated.prob.success = res$estimate,
    p.value = round(res$p.value,6),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],4),",",round(res$conf.int[2],4), ")")
    ))

  colnames(res.table) = res$method
  rownames(res.table) =c("Number of Success/Events", "Number of Total Trials/Samples", "Estimated Probability/Proportion", "P Value", "95% Confidence Interval")
  return(res.table)
  }, 
  rownames = TRUE)

output$b.test1 = renderTable({

  res = prop.test(x = input$x, n= input$n, p = input$p, alternative = input$alt, correct = TRUE)

    res.table = t(data.frame(
    X.squared = res$statistic,
    Estimated.prob.success = res$estimate,
    p.value = round(res$p.value,6),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],4),",",round(res$conf.int[2],4), ")")
    ))

  colnames(res.table) = res$method
  rownames(res.table) =c("X-squared Statistic", "Estimated Probability/Proportion", "P Value", "95% Confidence Interval")
  return(res.table)
  }, 
  rownames = TRUE)
 

output$makeplot <- renderPlot({  #shinysession 
  x = data.frame(
    group = c(unlist(strsplit(input$ln, "[\n, \t, ]"))), 
    value = c(input$x, input$n-input$x)
    )
  ggplot(x, aes(x="", y=x[,"value"], fill=x[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

##---------- 2. Two sample ----------

output$makeplot2 <- renderPlot({  #shinysession 
    x1 = data.frame(
    group = c(unlist(strsplit(input$ln2, "[\n, \t, ]"))), 
    value = c(input$x1, input$n1-input$x1)
    )
    x2 = data.frame(
    group = c(unlist(strsplit(input$ln2, "[\n, \t, ]"))), 
    value = c(input$x2, input$n2-input$x2)
    )
  p1 = ggplot(x1, aes(x="", y=x1[,"value"], fill=x1[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  p2 = ggplot(x2, aes(x="", y=x2[,"value"], fill=x2[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  grid.arrange(p1, p2, ncol=2)
  })

output$p.test = renderTable({
  x <- c(input$x1, input$x2)
  n <- c(input$n1, input$n2)
  res = prop.test(x = x, n= n, alternative = input$alt1, correct = input$cr)
  res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    Estimated.prop = paste0("prop.1 = ",round(res$estimate[1],4),", ","prop.2 = ",round(res$estimate[2],4)),
    P.value = round(res$p.value,6),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],4),",",round(res$conf.int[2],4), ")")
))

  colnames(res.table) = c(res$method)
    rownames(res.table) =c("X-squared Statistic", "Degree of Freedom","Estimated Probability/Proportion", "P Value", "95% Confidence Interval")

  return(res.table)}, 
  rownames = TRUE)


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
  res = prop.test(x = x, n= n, correct = input$ncr)
  res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    Estimated.prop = toString(round(X[["estimate"]],4)),
    P.value = round(res$p.value,6)
    ))
  colnames(res.table) = c(res$method)
  rownames(res.table) =c("X-squared Statistic", "Degree of Freedom","Estimated Probability/Proportions", "P Value")

  return(res.table)}, 
  rownames = TRUE, width = "800px")


##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
)


