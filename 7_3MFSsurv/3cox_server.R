##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >Linear regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

## 2. choose variable to put in the model/ and summary

#DF4 <- reactive({
#  df <-dplyr::select(DF3(), subset=c(-input$c))
#return(df)
#  })
#type.fac4 <- reactive({
#DF3() %>% select_if(is.factor) %>% colnames()
#})

output$var.cx = renderUI({
selectInput(
'var.cx',
tags$b('1. Choose one or more independent variables'),
selected = names(DF4())[3],
choices = names(DF4()),
multiple=TRUE)
})


output$fx.cx = renderUI({
selectInput(
  'fx.cx',
  tags$b('3.2. Choose random effect variable as additional effect, categorical'),
  selected = "NULL",
  choices = c("NULL", names(DF4()))
)
})

output$Xdata4 <- DT::renderDT(
head(DF3()), options = list(scrollX = TRUE))
### for summary
output$str4 <- renderPrint({str(DF3())})


cox = reactive({

if (input$effect.cx=="") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), input$conf.cx,input$intercept.cx)}
if (input$effect.cx=="Strata") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), "+strata(", input$fx.cx, ")",input$conf.cx,input$intercept.cx)}
if (input$effect.cx=="Cluster") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), "+cluster(", input$fx.cx, ")", input$conf.cx,input$intercept.cx)}
if (input$effect.cx=="Gamma Frailty") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), "+frailty(", input$fx.cx, ")", input$conf.cx,input$intercept.cx)}
if (input$effect.cx=="Gaussian Frailty") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), "+frailty.gaussian(", input$fx.cx, ")", input$conf.cx,input$intercept.cx)}

  #fit <- survreg(as.formula(f), data = DF3(), dist=input$dist)
 
  return(f)
})

output$cox_form = renderPrint({cat(cox()) })

coxfit = eventReactive(input$B2, {
  coxph(as.formula(cox()), data = DF3(), ties=input$tie)
  })


#gfit = eventReactive(input$B1, {
#  glm(formula(), data = DF3())
#})
# 
output$fitcx = renderPrint({ 
res <- summary(coxfit())
res$call <- "Cox Model Result"
return(res)
})

fit.cox <- reactive({
 res <- data.frame(
  Y = DF3()[,input$t],
  lp = coxfit()$linear.predictors,
  #fit = predict(coxfit(), type="lp"),
  Residuals = resid(coxfit(), type="martingale")
 )

res$csres=DF3()[,input$c]-res[,3]
 colnames(res) <- c("Time", "Linear Part = bX", "Martingale Residuals", "Cox-snell Residuals")
 return(res)
  })
# 
 output$fit.cox = DT::renderDT(fit.cox(),
 class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$csplot.cx = renderPlot({

fit = survfit(Surv(fit.cox()[,4], DF3()[, input$c]) ~ 1)
Htilde=cumsum(fit$n.event/fit$n.risk)

d = data.frame(time = fit$time, H = Htilde)
ggplot() + geom_step(data = d, mapping = aes(x = d[,"time"], y = d[,"H"])) + 
  geom_abline(intercept.cx =0,slope = 1, color = "red") +
  theme_minimal() + xlab("Cox-Snell residuals") + ylab("Estimated Cumulative Hazard Function")
  })


