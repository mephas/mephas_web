##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >Cox regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------


### testing data
newX.c = reactive({
inFile = input$newfile.c
if (is.null(inFile))
{
  df = X()[1:10, ]
  
}
else{
  df = read.csv(
    # user data
    inFile$datapath,
    header = input$newheader.c,
    sep = input$newsep.c,
    quote = input$newquote.c
  )
}
return(df)
})

## 2. choose variable to put in the model
output$t1.c = renderUI({
selectInput(
  't1.c',
  h5('Continuous follow-up time (or start-up time-point)'),
  selected = "NULL",
  choices = c("NULL", names(X()))
)
})

output$t2.c = renderUI({
selectInput(
  't2.c',
  h5('NULL (or end-up time-point)'),
  selected = "NULL",
  choices = c("NULL", names(X()))
)
})

output$c.c = renderUI({
selectInput('c.c',
            h5('Status variable (0=censor, 1=event)'),
            selected = "NULL",
            choices = c("NULL", names(X()))
            )
})

output$x.c = renderUI({
selectInput(
  'x.c',
  h5('Independent variable'),
  selected = NULL,
  choices = names(X()),
  multiple = TRUE
)
})

output$fx.c = renderUI({
selectInput(
  'fx.c',
  h5('Factor variable as additional effect'),
  selected = "NULL",
  choices = c("NULL", names(X()))
)
})

# 3. regression formula
y = reactive({
if (input$t2.c == "NULL") {
  y = paste0("Surv(", input$t1.c, ",", input$c.c, ")")
}
else{
  y = paste0("Surv(", input$t1.c, ",", input$t2.c, ",", input$c.c, ")")
}
return(y)
})

formula_c = eventReactive(input$F.c, {

if (input$effect=="") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), input$conf.c)}
if (input$effect=="Strata") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), "+strata(", input$fx.c, ")",input$conf.c)}
if (input$effect=="Cluster") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), "+cluster(", input$fx.c, ")", input$conf.c)}
if (input$effect=="Frailty") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), "+frailty(", input$fx.c, ")", input$conf.c)}

return(as.formula(f))
})


output$formula_c = renderPrint({
formula_c()
})

## 4. output results
### 4.1. variables' summary

### 4.2. model
fit.c = eventReactive(input$B1.c,
{
coxph(formula_c(), data = X())
})

output$fit.c = renderUI({
HTML(
  stargazer::stargazer(
    fit.c(),
    #out="cox.txt",
    header=FALSE,
    dep.var.caption="Cox Regression",
    dep.var.labels = "Estimate with 95% CI, t, p",
    type = "html",
    style = "all",
    align = TRUE,
    ci = TRUE,
    single.row = FALSE,
    title=paste("Cox Regression", Sys.time()),
    model.names = FALSE
  )
)
})

output$fit.ce = renderUI({
HTML(
  stargazer::stargazer(
    fit.c(),
    #out="cox.txt",
    header=FALSE,
    dep.var.caption="Cox Regression with HR",
    dep.var.labels = "(HR=Exp(estimate) with 95% CI, t, p)",
    type = "html",
    style = "all",
    apply.coef = exp,
    apply.ci = exp,
    align = TRUE,
    ci = TRUE,
    single.row = FALSE,
    title=paste("Cox Regression with HR", Sys.time()),
    model.names = FALSE
  )
)
})

output$anova.c = renderTable({
xtable::xtable(anova(fit.c()))
}, rownames = TRUE)

output$step.c = renderPrint({
step(fit.c()) })


# K-M plot
y.c = eventReactive(input$Y.c,
{
y=y()
})
output$p0.c = renderPlot({
f = as.formula(paste0(y.c(), "~1"))
fit = surv_fit(f, data = X())
ggsurvplot(fit, data = X(), risk.table = TRUE)
#plot(fit)
})
output$tx.c = renderUI({
selectInput(
  'tx.c',
  h5('Categorical variable as group'),
  selected = "NULL",
  choices = c("NULL",names(X()))
)
})
output$p1.c = renderPlot({
validate(
  need(input$tx.c != "NULL", "Please select one group variable")
)
f = as.formula(paste0(y.c(), "~",input$tx.c))
fit = surv_fit(f, data = X())

ggsurvplot(fit,
           data = X(),
           risk.table = TRUE,
           pval = TRUE)
#plot(fit)
})

# coxzph plot
zph = eventReactive(input$B1.c, {
cox.zph(fit.c())
})
output$zph.c = renderTable({
as.data.frame(zph()$table)
}, rownames=TRUE)

output$p2.c = renderPlot({
#ggcoxzph(zph())+ggtitle("")
#p1= ggcoxdiagnostics(fit.c(), type = "schoenfeld") + theme_minimal()
ggcoxdiagnostics(fit.c(), type = "schoenfeld", ox.scale = "time") + theme_minimal()
#grid.arrange( p1,p2, ncol=2)
})

# Residual output

output$p4.c = renderPlot({
if (input$res.c=="martingale")
{ggcoxdiagnostics(fit.c(), type = "martingale") + theme_minimal()}
else if (input$res.c=="deviance")
{ggcoxdiagnostics(fit.c(), type = "deviance") + theme_minimal()}
else
{
cox.snell = (as.numeric(X()[, input$c.c])) - residuals(fit.c(), type = "martingale")
coxph.res = survfit(coxph(Surv(cox.snell, X()[, input$c.c]) ~ 1, method = 'breslow'), type = 'aalen')
d = data.frame(x = as.numeric(coxph.res$time), y = -log(coxph.res$surv))
ggplot() + geom_step(data = d, mapping = aes(x = d[,"x"], y = d[,"y"])) + 
  geom_abline(intercept =0,slope = 1, color = "red") +
  theme_minimal() + xlab("Modified Cox-Snell residuals") + ylab("Cumulative hazard")
}
})

fit.cox <- reactive({
  data.frame(
  Residual = round(fit.c()$residuals, 4),
  Linear.predictors = round(fit.c()$linear.predictors, 4)
)
  })

output$fitdt.c = renderDataTable({
fit.cox()
}, options = list(pageLength = 5, scrollX = TRUE))

output$download31 <- downloadHandler(
    filename = function() {
      "cox.fitting.csv"
    },
    content = function(file) {
      write.csv(fit.cox(), file, row.names = TRUE)
    }
  )
#prediction plot
# prediction
pfit.c = eventReactive(input$B2.c, 
{coxph(formula_c(), data = X())}
)

pred.cox <- reactive({
df = data.frame(
  risk = predict(pfit.c(), newdata = newX.c(), type = "risk"),
  #survival=predict(fit.c(), newdata=newX.c(), type="survival"),
  #expected=predict(fit.c(), newdata=newX.c(), type="expected"),
  linear.predictors = predict(pfit.c(), newdata = newX.c(), type = "lp")
)
cbind(newX.c(), round(df, 4))
  })
output$pred.c = renderDataTable({
pred.cox()
}, options = list(pageLength = 5, scrollX = TRUE))

output$download32 <- downloadHandler(
    filename = function() {
      "cox.pred.csv"
    },
    content = function(file) {
      write.csv(pred.cox(), file, row.names = TRUE)
    }
  )
