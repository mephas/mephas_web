##----------#----------#----------#----------
##
## 4MFSproptest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------


##----------1. Chi-square test for single sample ----------
output$b.test = renderTable({
validate(need(input$n>=input$x, "Please check your data whether x <= n"))
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
validate(need(input$n>=input$x, "Please check your data whether x <= n"))
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
    group = c(unlist(strsplit(input$ln, "[\n]"))), 
    value = c(input$x, input$n-input$x)
    )
  ggplot(x, aes(x="", y=x[,"value"], fill=x[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })