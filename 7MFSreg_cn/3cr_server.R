##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >Linear Regression
##
## Language: CN
## 
## DT: 2019-01-16
##
##----------#----------#----------#----------

## 1. input data
### training data


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
    h5('随访时间 (或者起始时间点)'),
    selected = NULL,
    choices = names(X())
  )
})

output$t2.c = renderUI({
  selectInput(
    't2.c',
    h5('无 (或者结束时间点)'),
    selected = "NULL",
    choices = c("NULL", names(X()))
  )
})

output$c.c = renderUI({
  selectInput('c.c',
              h5('状态变量 (0=删失, 1=事件)'),
              selected = NULL,
              choices = names(X()))
})

output$x.c = renderUI({
  selectInput(
    'x.c',
    h5('连续型自变量'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

output$fx.c = renderUI({
  selectInput(
    'fx.c',
    h5('离散型自变量'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

output$sx.c = renderUI({
  selectInput(
    'sx.c',
    h5('分层变量'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

output$clx.c = renderUI({
  selectInput(
    'clx.c',
    h5('分类变量'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})


# 3. regression formula
y = reactive({
  if (input$t2.c == "NULL") {
    y = paste0("Surv(as.numeric(", input$t1.c, "),as.numeric(", input$c.c, "))")
  }
  else{
    y = paste0("Surv(as.numeric(", input$t1.c, "),as.numeric(", input$t2.c, "),as.numeric(", input$c.c, "))")
  }
  return(y)
})

formula_c = eventReactive(input$F.c, {
  f1 = paste0(y(), '~', paste0(input$x.c, collapse = "+"), input$conf.c)
  
  f2 = paste0(f1, "+ as.factor(", input$fx.c, ")")
  f3 = paste0(f1, "+ strata(",    input$sx.c, ")")
  f4 = paste0(f1, "+ cluster(",   input$clx.c, ")")
  
  f5 = paste0(f1,
              "+ as.factor(",
              input$fx.c,
              ")",
              "+ strata(",
              input$sx.c,
              ")")
  f6 = paste0(f1,
              "+ as.factor(",
              input$fx.c,
              ")",
              "+ cluster(",
              input$clx.c,
              ")")
  f7 = paste0(f1, "+ strata(",  input$sx.c, ")", "+ cluster(", input$clx.c, ")")
  
  f8 = paste0(
    f1,
    "+ as.factor(",
    input$fx.c,
    ")",
    "+ strata(",
    input$sx.c,
    ")",
    "+ cluster(",
    input$clx.c,
    ")"
  )
  
  if (is.null(input$fx.c) &&
      is.null(input$sx.c) && is.null(input$clx.c))
  {
    f = as.formula(f1)
  }
  if (is.null(input$fx.c) &&
      is.null(input$sx.c) && (!is.null(input$clx.c)))
  {
    f = as.formula(f4)
  }
  
  if (is.null(input$fx.c) &&
      !is.null(input$sx.c) && is.null(input$clx.c))
  {
    f = as.formula(f3)
  }
  if (is.null(input$fx.c) &&
      !is.null(input$sx.c) && !is.null(input$clx.c))
  {
    f = as.formula(f7)
  }
  
  if (!is.null(input$fx.c) &&
      is.null(input$sx.c) && is.null(input$clx.c))
  {
    f = as.formula(f2)
  }
  if (!is.null(input$fx.c) &&
      is.null(input$sx.c) && !is.null(input$clx.c))
  {
    f = as.formula(f6)
  }
  
  if (!is.null(input$fx.c) &&
      !is.null(input$sx.c) && is.null(input$clx.c))
  {
    f = as.formula(f5)
  }
  if (!is.null(input$fx.c) &&
      !is.null(input$sx.c) && !is.null(input$clx.c))
  {
    f = as.formula(f8)
  }
  
  return(f)
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
      type = "html",
      style = "all",
      align = TRUE,
      ci = TRUE,
      single.row = TRUE,
      model.names = TRUE
    )
  )
})
output$anova.c = renderTable({
  xtable::xtable(anova(fit.c()))
}, rownames = TRUE)

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
    h5('分类变量作为分组'),
    selected = names(X())[5],
    choices = names(X())
  )
})
output$p1.c = renderPlot({
  f = as.formula(paste0(y.c(), "~", input$tx.c))
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
  cox.snell = (X()[, input$c.c]) - residuals(fit.c(), type = "martingale")
  coxph.res = survfit(coxph(Surv(cox.snell, X()[, input$c.c]) ~ 1, method = 'breslow'), type = 'aalen')
  d = data.frame(x = coxph.res$time, y = -log(coxph.res$surv))
  ggplot() + geom_step(data = d, mapping = aes(x = x, y = y)) + geom_abline(intercept =0,
                                                                             slope = 1,
                                                                            color = "red") +
    theme_minimal() + xlab("Modified Cox-Snell residuals") + ylab("Cumulative hazard")
  }
})

output$fitdt.c = renderDataTable({
  data.frame(
    Residual = round(fit.c()$residuals, 4),
    Linear.predictors = round(fit.c()$linear.predictors, 4)
  )
}, options = list(pageLength = 5, scrollX = TRUE))

#prediction plot
# prediction
pfit.c = eventReactive(input$B2.c, 
  {coxph(formula_c(), data = X())}
  )

output$pred.c = renderDataTable({
  df = data.frame(
    risk = predict(pfit.c(), newdata = newX.c(), type = "risk"),
    #survival=predict(fit.c(), newdata=newX.c(), type="survival"),
    #expected=predict(fit.c(), newdata=newX.c(), type="expected"),
    linear.predictors = predict(pfit.c(), newdata = newX.c(), type = "lp")
  )
  cbind(newX.c(), round(df, 4))
}, options = list(pageLength = 5, scrollX = TRUE))
