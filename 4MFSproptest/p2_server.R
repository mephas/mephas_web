##----------#----------#----------#----------
##
## 4MFSproptest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------


##---------- 2. Two sample ----------
T = reactive({ # prepare dataset
  validate(need(input$n1>=input$x1, "Please check your data whether x1 <= n1"))
  validate(need(input$n2>=input$x2, "Please check your data whether x2 <= n2"))

 x <- matrix(c(input$x1,input$n1-input$x1,input$x2,input$n2-input$x2),2,2, byrow=TRUE)
  rownames(x) = unlist(strsplit(input$rn.2, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn.2, "[\n]"))
  return(x)
  })

output$n.t2 = DT::renderDT({
  addmargins(T(), 
    margin = seq_along(dim(N())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$makeplot2 <- renderPlot({  #shinysession 
  validate(need(input$n1>=input$x1, "Please check your data whether x <= n"))
  validate(need(input$n2>=input$x2, "Please check your data whether x <= n"))
    x1 = data.frame(
    group = c(unlist(strsplit(input$cn.2, "[\n]"))), 
    value = c(input$x1, input$n1-input$x1)
    )
    x2 = data.frame(
    group = c(unlist(strsplit(input$cn.2, "[\n]"))), 
    value = c(input$x2, input$n2-input$x2)
    )
  p1 = ggplot(x1, aes(x="", y=x1[,"value"], fill=x1[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab(rownames(T())[1])+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  p2 = ggplot(x2, aes(x="", y=x2[,"value"], fill=x2[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab(rownames(T())[2])+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  grid.arrange(p1, p2, ncol=2)
  })

output$p.test = DT::renderDT({
  validate(need(input$n1>=input$x1, "Please check your data whether x <= n"))
  validate(need(input$n2>=input$x2, "Please check your data whether x <= n"))
  x <- c(input$x1, input$x2)
  n <- c(input$n1, input$n2)
  res = prop.test(x = x, n= n, alternative = input$alt1, correct = input$cr)
  res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    Estimated.prop = paste0("prop.1 = ",round(res$estimate[1],6),", ","prop.2 = ",round(res$estimate[2],6)),
    P.value = (res$p.value),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],6),",",round(res$conf.int[2],6), ")")
))

  colnames(res.table) = c(res$method)
    rownames(res.table) =c("X-squared Statistic", "Degree of Freedom","Estimated Probability/Proportion", "P Value", "95% Confidence Interval")

  return(res.table)}, 
  class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


