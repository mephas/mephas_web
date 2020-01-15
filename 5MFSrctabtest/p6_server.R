
##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- Panel 6: k,k table ----------

T6 = reactive({ # prepare dataset
  rn = unlist(strsplit(input$rn6, "[\n]"))
  cn = unlist(strsplit(input$cn6, "[\n]"))

  x <- as.numeric(unlist(strsplit(input$x6, "[,;\n\t ]")))
  validate(need(length(x)==length(cn)*length(cn), "Please input enough values"))
  x <- matrix(x,length(cn),length(cn), byrow=TRUE)

  validate(need(length(cn)==ncol(x), "Please input correct names"))
  validate(need(length(rn)==2, "Please input correct names"))

  rownames(x) <- paste0(rn[1], " : ",cn)
  colnames(x) <- paste0(rn[2], " : ",cn)
  return(x)
  })

output$dt6 = DT::renderDT({
  addmargins(T6(), 
    margin = seq_along(dim(T6())), 
    FUN = list(Total=sum), quiet = TRUE)},
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt6.0 = DT::renderDT({
   x = as.matrix(T6())
  res = round(cohen.kappa(x)$agree,6)
    return(res)
}, 
#class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt6.1 = DT::renderDT({
   x = as.matrix(T6())
  res = round(cohen.kappa(x)$weight,6)
    return(res)
}, 
#class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$dt6.1 = renderTable({prop.table(T6(), 1)}, width = "700px" ,rownames = TRUE, digits = 4)

#output$dt6.2 = renderTable({prop.table(T6(), 2)}, width = "700px" ,rownames = TRUE, digits = 4)

#output$dt6.3 = renderTable({prop.table(T6())}, width = "700px" ,rownames = TRUE, digits = 4)


#output$makeplot6 <- renderPlot({  #shinysession 
#  x <- as.data.frame(T6())
#  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
#  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
#  })

output$c.test6 = DT::renderDT({
    x = as.matrix(T6())
    res = cohen.kappa(x)
    res.table = res[["confid"]]
    colnames(res.table) =c("95% CI Low", "Kappa Estimate", "95% CI High")
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

