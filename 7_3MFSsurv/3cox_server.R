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
selected = names(DF4())[2],
choices = names(DF4()),
multiple=TRUE)
})


output$fx.cx = renderUI({
selectInput(
  'fx.cx',
  tags$b('3.2. Choose random effect variable as additional effect, categorical'),
selected = names(DF4())[2],
choices = names(DF4())
)
})

output$Xdata4 <- DT::renderDT(
head(DF3()), options = list(scrollX = TRUE))
### for summary
output$str4 <- renderPrint({str(DF3())})


cox = reactive({

if (input$effect.cx=="") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), input$conf.cx)}
if (input$effect.cx=="Strata") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), "+strata(", input$fx.cx, ")",input$conf.cx)}
if (input$effect.cx=="Cluster") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), "+cluster(", input$fx.cx, ")", input$conf.cx)}
if (input$effect.cx=="Gamma Frailty") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), "+frailty(", input$fx.cx, ")", input$conf.cx)}
if (input$effect.cx=="Gaussian Frailty") {f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"), "+frailty.gaussian(", input$fx.cx, ")", input$conf.cx)}

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
res$call <- "Cox Regression Result"
return(res)
})

output$zphplot = renderPlot({
f<-cox.zph(coxfit())
p <- ggcoxzph(f,
  point.col = "red", point.size = 0.5, point.shape = 10,
  point.alpha = 1, caption = NULL, ggtheme = theme_minimal(),
  font.x = 12,font.y = 12,font.main = 12)
p[input$num]
  })

output$zph = DT::renderDT({ 
res <- cox.zph(coxfit())
res.tab<- as.data.frame(res[["table"]])
colnames(res.tab) <- c("Chi-squared", "Degree of Freedom", "P Value")
return(res.tab)
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))


fit.cox <- reactive({
 res <- data.frame(
  #Y = DF3()[,input$t],
  #E = DF3()[,input$c],
  lp = coxfit()$linear.predictors,
  risk=exp(coxfit()$linear.predictors),
  expected=predict(coxfit(),type="expected"),
  survival=predict(coxfit(),type="survival"),
  Residuals = resid(coxfit(), type="martingale"),
  Residuals2 = resid(coxfit(), type="deviance"),
  Residuals3 = DF3()[,input$c]-resid(coxfit(), type="martingale")
 )

 colnames(res) <- c("Time", "Censor", "Linear Part = bX", "Risk Score = exp(bX)", 
  "Expected number of events", "survival Prob. = exp(-Expected number of events)",
  "Martingale Residuals", "Deviance Residuals", "Cox-Snell Residuals")
 return(res)
  })
# 
 output$fit.cox = DT::renderDT(fit.cox(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$splot = renderPlot({
ggadjustedcurves(coxfit(), data=DF3(),
  ggtheme = theme_minimal(), palette = "Paired",
  font.x = 12,font.y = 12,font.main = 12)
  })

output$csplot.cx = renderPlot({

fit=survfit(Surv(fit.cox()[,9],fit.cox()[,2])~1)
Htilde=cumsum(fit$n.event/fit$n.risk)

d = data.frame(time = fit$time, H = Htilde)
ggplot() + geom_step(data = d, mapping = aes(x = d[,"time"], y = d[,"H"])) + 
  geom_abline(intercept =0,slope = 1, color = "red") +
  theme_minimal() + xlab("Cox-Snell residuals") + ylab("Estimated Cumulative Hazard Function")
  })

output$diaplot1 = renderPlot({
ggcoxdiagnostics(coxfit(), ox.scale ="observation.id",
  type = "martingale", hline.size = 0.5,point.size = 0.5, point.shape = 10,
  ggtheme = theme_minimal(),font.x = 12,font.y = 12,font.main = 12)
  })

output$diaplot2 = renderPlot({
ggcoxdiagnostics(coxfit(), ox.scale ="observation.id",
  type = "deviance", hline.size = 0.5,point.size = 0.5, point.shape = 10,
  ggtheme = theme_minimal(),font.x = 12,font.y = 12,font.main = 12)
  })

