if (!require(Hmisc)) {install.packages("Hmisc")}; library(Hmisc)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)

##----------#----------#----------#----------
##
## 4MFSproptest SERVER
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyServer( 
function(input, output) {


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
  return(res.table)
  }, 
  rownames = TRUE)

output$makeplot <- renderPlot({  #shinysession 
  x = data.frame(
    group = c("Success", "Failure"), 
    value = c(input$x, input$n-input$x)
    )
  ggplot(x, aes(x="", y=x[,"value"], fill=x[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

##---------- 2. Chi-square test for 2 by C table ----------
P = reactive({ # prepare dataset

  X <- as.numeric(unlist(strsplit(input$x1, "[\n, \t, ]")))
  Y <- as.numeric(unlist(strsplit(input$x2, "[\n, \t, ]")))
  #P <- round(X/Z, 4)
  x <- cbind(X,Y)
  rownames(x) = unlist(strsplit(input$rn, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cn, "[\n, \t, ]"))
  return(x)
  })

output$t = renderTable({
  addmargins(P(), margin = seq_along(dim(P())), FUN = sum, quiet = TRUE)
  },  
  width = "50" ,rownames = TRUE)

output$p.t = renderTable({
  prop.table(P(), 2)
  }, 
  width = "50" ,rownames = TRUE, digits = 4)


output$makeplot2 <- renderPlot({  #shinysession 
  x = as.data.frame(P())
  p1 = ggplot(x, aes(x="", y= x[,1], fill = rownames(x)))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  p2 = ggplot(x, aes(x="", y= x[,2], fill = rownames(x)))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  grid.arrange(p1, p2, ncol=2)
  })

output$p.test = renderTable({
  x = P()
  res = prop.test(x = x[,1], n= x[,1]+x[,2], alternative = input$alt1, correct = input$cr)
  res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    Estimated.prop = paste0("prop.1 = ",round(res$estimate[1],4),", ","prop.2 = ",round(res$estimate[2],4)),
    P.value = round(res$p.value,6)))

  colnames(res.table) = c(res$method)
  return(res.table)}, 
  rownames = TRUE)

output$e.t = renderTable({
  x = P()
  res = chisq.test(x)
  res$expected}, rownames = TRUE)

  output$f.test = renderTable({
  x = P()
  res = fisher.test(x= x, alternative = input$alt1)
  res.table = t(data.frame(Estimated.odds = res$estimate,
                           P.value = round(res$p.value, 6)))
  colnames(res.table) = c(res$method)
  return(res.table)}, 
  rownames = TRUE)

##---------- 3. Mcnemar test for 2 matched data ----------

N = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$xn1, "[\n, \t, ]")))
  Y <- as.numeric(unlist(strsplit(input$xn2, "[\n, \t, ]")))
  #P <- round(X/Z, 4)
  x <- cbind(X,Y)
  rownames(x) = unlist(strsplit(input$ra, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cb, "[\n, \t, ]"))
  return(x)
  })

output$n.t = renderTable({
  addmargins(N(), margin = seq_along(dim(N())), FUN = sum, quiet = TRUE)},  
  width = "50" ,rownames = TRUE)

output$n.test = renderTable({
  x = N()
  res1 = mcnemar.test(x = x, correct = FALSE)
  res.table1 = t(data.frame(
    X.statistic = res1$statistic,
    Degree.of.freedom = res1$parameter,
    P.value = round(res1$p.value, 6)))
  res2 = mcnemar.test(x = x, correct = TRUE)

  res.table2 = t(data.frame(
    X.statistic = res2$statistic,
    Degree.of.freedom = res2$parameter,
    P.value = round(res2$p.value, 6)))

  res.table = cbind(res.table1, res.table2)
  colnames(res.table) = c(res1$method, res2$method)
  return(res.table)}, 
  rownames = TRUE)

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}
)


