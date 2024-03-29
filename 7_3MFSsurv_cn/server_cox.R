#****************************************************************************************************************************************************cox


#output$var.cx = renderUI({
#selectInput(
#'var.cx',
#tags$b('2. Choose some independent variables (X)'),
#selected = names(DF4())[1],
#choices = names(DF4()),
#multiple=TRUE)
#})
output$var.cx = renderUI({
shinyWidgets::pickerInput(
'var.cx',
tags$b('2. 添加/删除自变量（X）'),
selected = names(DF4())[1],
choices = names(DF4()),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})

output$conf.cx = renderUI({
shinyWidgets::pickerInput(
'conf.cx',
tags$b('3 （可选）添加变量交互项'),
choices = type.fac4(),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      maxOptions=2,
      actionsBox=TRUE,
      size=5)
)
})

DF5 <- reactive(
  DF4()[ ,-which(names(DF4()) %in% c(input$conf.cx,input$var.cx))]
  )


output$fx.cx = renderUI({
selectInput(
  'fx.cx',
  tags$b('Choose one random effect variable'),
selected = names(DF5())[1],
choices = names(DF5())
)
})

output$Xdata4 <- DT::renderDT(
head(DF3()),     
options = list(scrollX = TRUE,dom = 't'))
### for summary
output$str4 <- renderPrint({str(DF3())})


cox = reactive({

validate(need(input$var.cx, "Please choose some independent variable"))

f = paste0(surv(), '~', paste0(input$var.cx, collapse = "+"))

if(length(input$conf.cx)==2) {f = paste0(f, "+",paste0(input$conf.cx, collapse = ":"))}

if (input$effect.cx=="") {f = f}
if (input$effect.cx=="Strata") {f = paste0(f, "+strata(", input$fx.cx, ")")}
if (input$effect.cx=="Cluster") {f = paste0(f, "+cluster(", input$fx.cx, ")")}
if (input$effect.cx=="Gamma Frailty") {f = paste0(f, "+frailty(", input$fx.cx, ")")}
if (input$effect.cx=="Gaussian Frailty") {f = paste0(f, "+frailty.gaussian(", input$fx.cx, ")")}

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

output$step = renderPrint({step(coxfit())})

output$zphplot = renderPlot({
  validate(need((input$effect.cx =="" ), "Models with random effect terms can not be used in this plot."))

f<-cox.zph(coxfit())
p <- ggcoxzph(f,
  point.col = "red", point.size = 1, point.shape = 19,
  point.alpha = 0.7, caption = NULL, 
  ggtheme = theme_minimal(), palette = "Set1",
  font.x = 12,font.y = 12,font.main = 12)
p[input$num]
  })

output$zph = DT::renderDT({ 
res <- cox.zph(coxfit())
res.tab<- as.data.frame(res[["table"]])
colnames(res.tab) <- c("Chi-squared", "Degree of Freedom", "P Value")
return(round(res.tab,6))
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = 
      list('copy',
        list(extend = 'csv', title = "数据结果"),
        list(extend = 'excel', title = "数据结果")
        ),
scrollX = TRUE))


fit.cox <- reactive({
if (input$time=="B") {y = DF3()[,input$t2]-DF3()[,input$t1]}
else {y=DF3()[,input$t]}
 res <- data.frame(
  Y = y,
  E = DF3()[,input$c],
  lp = coxfit()$linear.predictors,
  risk=exp(coxfit()$linear.predictors),
  #expected=predict(coxfit(),type="expected"),
  #survival=predict(coxfit(),type="survival"),
  Residuals = resid(coxfit(), type="martingale"),
  Residuals2 = resid(coxfit(), type="deviance"),
  Residuals3 = DF3()[,input$c]-resid(coxfit(), type="martingale")
 )

 colnames(res) <- c("Time", "Censor", "Linear Part = bX", "Risk Score = exp(bX)", 
  #"Expected number of events", "survival Prob. = exp(-Expected number of events)",
  "Martingale Residuals", "Deviance Residuals", "Cox-Snell Residuals")
 return(round(res,6))
  })
# 
 output$fit.cox = DT::renderDT(fit.cox(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv', title = "数据结果"),
        list(extend = 'excel', title = "数据结果")
        ),
    scrollX = TRUE))

output$splot = renderPlot({
validate(need((input$effect.cx =="" || input$effect.cx=="Strata" ||input$effect.cx=="Cluster"), "Frailty models can not be used in this plot."))
ggadjustedcurves(coxfit(), data=DF3(),
  ggtheme = theme_minimal(), palette = "Set1",
  font.x = 12,font.y = 12,font.main = 12)
  })

output$csplot.cx = plotly::renderPlotly({

fit=survfit(Surv(fit.cox()[,7],fit.cox()[,2])~1)
Htilde=cumsum(fit$n.event/fit$n.risk)

d = data.frame(time = fit$time, H = Htilde)
p<-plot_coxstep(d)
plotly::ggplotly(p)
#ggplot() + geom_step(data = d, mapping = aes(x = d[,"time"], y = d[,"H"])) + 
#  geom_abline(intercept =0,slope = 1, color = "red") +
#  theme_minimal() + xlab("Cox-Snell residuals") + ylab("Estimated Cumulative Hazard Function")
  })

type.num4 <- reactive({
colnames(DF4()[unlist(lapply(DF4(), is.numeric))])
})

output$var.mr = renderUI({
selectInput(
'var.mr',
tags$b('选择一个连续自变量'),
selected = type.num4()[1],
choices = type.num4())
})

output$diaplot1 = plotly::renderPlotly({

df <- data.frame(id=DF3()[,input$var.mr], dev=fit.cox()[,5])

validate(need(length(levels(as.factor(DF3()[,input$var.mr])))>2, "Please choose a continuous variable"))

p<-plot_res(df, "id", "dev")+xlab(input$var.mr) + ylab("Martingale residuals")+
geom_point(shape = 19, size=1, color=(fit.cox()[,2]+1))
plotly::ggplotly(p)

  })


output$diaplot2 = plotly::renderPlotly({

df <- data.frame(id=seq_len(nrow(fit.cox())), dev=fit.cox()[,6])

p<-plot_res(df, "id", "dev")+
xlab("Observation Id") + ylab("Deviance residuals")+
geom_point(shape = 19, size=1, color=(fit.cox()[,2]+1))
plotly::ggplotly(p)

  })

