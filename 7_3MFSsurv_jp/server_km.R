#****************************************************************************************************************************************************km


DF4 <- reactive({
  if (input$time=="B") {df <-DF3()[ ,-which(names(DF3()) %in% c(input$c,input$t1,input$t2)), drop=FALSE]}
  else {df <-DF3()[ ,-which(colnames(DF3()) %in% c(input$c,input$t)), drop=FALSE]}
return(df)
  })

type.fac4 <- reactive({
colnames(DF4()[unlist(lapply(DF4(), is.factor))])
  # colnames(DF4())
})

#output$g = renderUI({
#selectInput(
#'g',
#tags$b('2. Choose categorical variable'),
#selected = type.fac4()[1],
#choices = type.fac4(),
#multiple=TRUE)
#})

output$g = renderUI({
shinyWidgets::pickerInput(
'g',
tags$b('2. カテゴリ変数を選択する'),
selected = type.fac4()[1],
choices = type.fac4(),
multiple = TRUE)
})


output$Xdata2 <- DT::renderDT(
head(DF3()),
options = list(scrollX = TRUE,dom = 't'))
### for summary
output$str <- renderPrint({str(DF3())})



## 4. output results
### 4.2. model

kmfit = reactive({
  validate(need(input$g, "Please choose categorical variable"))
if (input$time=="A") {surv <- surv()}
if (input$time=="B") {surv <- paste0("Surv(", input$t2, " - ", input$t1, ",", input$c, ")")}

  y <- paste0(surv, "~", paste0(as.factor(input$g), collapse = "+"))
  fit <- surv_fit(as.formula(y), data = DF3())
  fit$call <- NULL
  return(fit)
})


output$km.p= renderPlot({
  validate(need(input$g, "Please choose categorical variable"))
if (input$time=="A") {surv <- surv()}
if (input$time=="B") {surv <- paste0("Surv(", input$t2, " - ", input$t1, ",", input$c, ")")}

  y <- paste0(surv, "~", paste0(as.factor(input$g), collapse = "+"))
  fit <- surv_fit(as.formula(y), data = DF3())

ggsurvplot(fit, data=DF3(),
          fun=paste0(input$fun2), 
           conf.int = FALSE,
           pval = TRUE,
           risk.table = "abs_pct",
           #surv.median.line = "hv", 
           palette = "Set1",
           ggtheme = theme_minimal(),
           legend="bottom",
           risk.table.y.text.col = TRUE, # colour risk table text annotations.
           risk.table.y.text = FALSE,
           surv.plot.height =0.7,        
           risk.table.height =0.3) 
  })

output$kmt1= renderPrint({
(kmfit())
  })

output$kmt= renderPrint({
summary(kmfit())
  })
# 
 LR = reactive({
  validate(need(input$g, "Please choose categorical variable"))

 if (input$time=="A") {surv <- surv()}
if (input$time=="B") {surv <- paste0("Surv(", input$t2, " - ", input$t1, ",", input$c, ")")}

  y <- paste0(surv, "~", paste0(as.factor(input$g), collapse = "+"))
  fit <- survdiff(as.formula(y), rho=input$rho, data = DF3())
  #fit$call <- NULL
  return(fit)
})

output$kmlr = renderPrint({
LR()})

 PLR = reactive({
  validate(need(input$g, "Please choose categorical variable"))

  if (input$time=="A") {surv <- surv()}
if (input$time=="B") {surv <- paste0("Surv(", input$t2, " - ", input$t1, ",", input$c, ")")}

  y <- paste0(surv, "~", paste0(as.factor(input$g), collapse = "+"))

  if (input$pm == "B"){
  res <- pairwise_survdiff(as.formula(y), rho=input$rho2, p.adjust.method = "bonf", data = DF3())$p.value
}
  if (input$pm == "BH"){
  res <- pairwise_survdiff(as.formula(y), rho=input$rho2, p.adjust.method = "holm", data = DF3())$p.value
  }
  #if (input$method == "BHG"){
  #  res <- pairwise.t.test(x[,namesm()[1]], x[,namesm()[2]], 
  #  p.adjust.method = "hochberg")$p.value
  #}
  #  if (input$method == "BHL"){
  #  res <- pairwise.t.test(x[,namesm()[1]], x[,namesm()[2]], 
  #  p.adjust.method = "hommel")$p.value
  #}
    if (input$pm == "FDR"){
  res <- pairwise_survdiff(as.formula(y), rho=input$rho2, p.adjust.method = "BH", data = DF3())$p.value
  }
    if (input$pm == "BY"){
  res <- pairwise_survdiff(as.formula(y), rho=input$rho2, p.adjust.method = "BY", data = DF3())$p.value

  }
  res <- as.data.frame(res)
  return(round(res,6))
})

output$PLR = DT::renderDT({PLR()}, 
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))
# 
 