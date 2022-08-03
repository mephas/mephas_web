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
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt4.0 = DT::renderDT({
  res = chisq.test(T4())
  exp = round(res$expected,6)
  return(exp)}, 

  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt4.1 = DT::renderDT({round(prop.table(T4(), 1),6)}, 

  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt4.2 = DT::renderDT({round(prop.table(T4(), 2),6)},

  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$dt4.3 = DT::renderDT({round(prop.table(T4()),6)}, 

  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
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
    res.table = t(data.frame(odds_ratio = round(res$estimate,6),                           
                            P_value = round(res$p.value,6),
                            CI = paste0("(", round(res$conf.int[1],6),",",round(res$conf.int[2],6), ")")
))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Odds Ratio (Group 1 vs Group 2)","P Value", "95% Confidence Interval")
    return(res.table)
    }, 
    
   #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

