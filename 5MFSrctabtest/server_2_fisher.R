#****************************************************************************************************************************************************

T4 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x4, "[,;\n\t ]")))
  validate(need(length(x)==4, "Please input 4 values"))

  x <- matrix(x,2,2, byrow=TRUE)

  validate(need(length(unlist(strsplit(input$cn4, "[\n]")))==2, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn4, "[\n]")))==2, "Please input correct row names"))

  rownames(x) = unlist(strsplit(input$rn4, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn4, "[\n]"))
  return(x)
  })

output$dt4 = DT::renderDT({
  addmargins(T4(), 
    margin = seq_along(dim(T4())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.0 = DT::renderDT({
  res = chisq.test(T4())
  exp = res$expected
  return(exp)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.1 = DT::renderDT({prop.table(T4(), 1)}, 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.2 = DT::renderDT({prop.table(T4(), 2)}, #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.3 = DT::renderDT({prop.table(T4())}, #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot4 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(T4())
  p<-plot_bar(x)
  plotly::ggplotly(p)
  })
output$makeplot4.1 <- plotly::renderPlotly({  #shinysession 
  x <- as.data.frame(t(T4()))
  p<-plot_bar(x)
  plotly::ggplotly(p)
 })

output$c.test4 = DT::renderDT({
    x = as.matrix(T4())
    res = fisher.test(x=x, y=NULL,alternative = input$yt4)
    res.table = t(data.frame(odds_ratio = res$estimate,                           
                            P_value = res$p.value,
                            CI = paste0("(", res$conf.int[1],",",res$conf.int[2], ")")
))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Odds Ratio (Group 1 vs Group 2)","P Value", "95% Confidence Interval")
    return(res.table)
    }, 
   #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

