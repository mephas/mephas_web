#****************************************************************************************************************************************************aft

#output$var.x = renderUI({
#selectInput(
#'var.x',
#tags$b('2. Choose some independent variables (X)'),
#selected = names(DF4()),
#choices = names(DF4()),
#multiple=TRUE)
#})
output$var.x = renderUI({
shinyWidgets::pickerInput(
'var.x',
tags$b('2. 添加/删除自变量（X）'),
selected = names(DF4())[1],
choices = names(DF4()),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})

output$conf = renderUI({
shinyWidgets::pickerInput(
'conf',
tags$b('4 （可选）添加变量交互项'),
choices = type.fac4(),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      maxOptions=2,
      actionsBox=TRUE,
      size=5)
)
})

DF6 <- reactive(
  DF4()[ ,-which(names(DF4()) %in% c(input$conf,input$var.x))]
  )

output$fx.c = renderUI({
selectInput(
  'fx.c',
  tags$b('选择一个变量效果变量'),
selected = names(DF6())[1],
choices = names(DF6()),
)
})

output$Xdata3 <- DT::renderDT(
head(DF3()),     
options = list(scrollX = TRUE,dom = 't'))
### for summary
output$str3 <- renderPrint({str(DF3())})


aft = reactive({
validate(need(input$var.x, "选择独立变量"))
if (input$time=="A") {surv <- surv()}
if (input$time=="B") {surv <- paste0("Surv(", input$t2, " - ", input$t1, ",", input$c, ")")}

f = paste0(surv, '~', paste0(input$var.x, collapse = "+"))
if(length(input$conf)==2) {f = paste0(f, "+",paste0(input$conf, collapse = ":"))}

if (input$effect=="") {f = paste0(f, input$intercept)}
if (input$effect=="Strata") {f = paste0(f, "+strata(", input$fx.c, ")",input$intercept)}
if (input$effect=="Cluster") {f = paste0(f, "+cluster(", input$fx.c, ")",input$intercept)}
#if (input$effect=="Gamma Frailty") {f = paste0(surv(), '~', paste0(input$var, collapse = "+"), "+frailty(", input$fx.c, ")", input$conf,input$intercept)}
#if (input$effect=="Gaussian Frailty") {f = paste0(surv(), '~', paste0(input$var, collapse = "+"), "+frailty.gaussian(", input$fx.c, ")", input$conf,input$intercept)}

  #fit <- survreg(as.formula(f), data = DF3(), dist=input$dist)
 
  return(f)
})

output$aft_form = renderPrint({cat(aft()) })

aftfit = eventReactive(input$B1, {
  survreg(as.formula(aft()), data = DF3(), dist=input$dist)
  })


#gfit = eventReactive(input$B1, {
#  glm(formula(), data = DF3())
#})
# 
output$fit = renderPrint({ 
res <- summary(aftfit())
res$call <- "AFT Model Result"
return(res)
})

output$step2 = renderPrint({step(aftfit())})


fit.aft <- eventReactive(input$B1, {

if (input$time=="B") {y = DF3()[,input$t2]-DF3()[,input$t1]}
else {y=DF3()[,input$t]}

 res <- data.frame(
  Y = y,
  c= DF3()[,input$c],
  lp = aftfit()$linear.predictors,
  fit = predict(aftfit(), type="response"),
  Residuals = resid(aftfit(),  type="response"),
  devres = -resid(aftfit(),  type="deviance")
 )
 res$std <- (log(res[,1])-res[,3])/aftfit()$scale
  
  if (input$dist=="weibull") {res$csr <- -log(exp(-exp(res$std)))}
  if (input$dist=="exponential") {res$csr <- -log(-exp(-exp(res$std)))}
  #if (input$dist=="extreme") {res$csr <- -log(exp(-exp(res$std)))}
  if (input$dist=="lognormal") {res$csr <- -log(1-pnorm(res$std))}
  if (input$dist=="loglogistic") {res$csr <- -log(1-plogis(res$std))}

res$mar <- res$c- res$csr

 colnames(res) <- c("Times", "Censor","Linear Part = bX", "Predicted Time","Residuals = Time - Predicted Time", "Deviance residuals",
  "Standardized residuals = (log(Times)-bX)/scale", "Cox-snell Residuals", "Martingale residuals = censor - Cox-snell")
 return(res)
  })
# 
 output$fit.aft = DT::renderDT({round(fit.aft(),6)},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$csplot = plotly::renderPlotly({

fit = survfit(Surv(fit.aft()[,8], fit.aft()[,2]) ~ 1)
Htilde=cumsum(fit$n.event/fit$n.risk)

d = data.frame(time = fit$time, H = Htilde)
p<-plot_coxstep(d)
plotly::ggplotly(p)
  })

output$deplot = plotly::renderPlotly({

df <- data.frame(id=seq_len(nrow(fit.aft())), dev=fit.aft()[,6])

p<-plot_res(df, "id", "dev")+
xlab("Observation Id") + ylab("Deviance residuals")+
geom_point(shape = 19, size=1, color=(fit.aft()[,2]+1))
plotly::ggplotly(p)
  })

output$var.mr2 = renderUI({
selectInput(
'var.mr2',
tags$b('选择一个连续自变量'),
selected = type.num4()[1],
choices = type.num4())
})

output$mrplot = plotly::renderPlotly({

df <- data.frame(id=DF3()[,input$var.mr2], dev=fit.aft()[,9])
#df <- data.frame(id=seq_len(nrow(fit.aft())), dev=fit.aft()[,9])

validate(need(length(levels(as.factor(DF3()[,input$var.mr2])))>2, "Please choose a continuous variable"))

p<-plot_res(df, "id", "dev")+xlab(input$var.mr2) + ylab("Martingale residuals")+geom_point(shape = 19, size=1, color=(fit.aft()[,2]+1))
plotly::ggplotly(p)
  })


