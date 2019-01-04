
# Cox regression

## 1. input data
### training data
X.c = reactive({
  inFile = input$file.c
  if (is.null(inFile))
  {
    df = survival::cancer
    df$status = survival::cancer$status - 1  ##>  example data
  }
  else{
    df = read.csv(
      ##> user data
      input$file.c$datapath,
      header = input$header.c,
      sep = input$sep.c,
      quote = input$quote.c
    )
  }
  return(df)
})

### testing data
newX.c = reactive({
  inFile = input$newfile.c
  if (is.null(inFile))
  {
    df = lung[1:10, ]
    df$status = lung[1:10, ]$status - 1 ##>  example data
  }
  else{
    df = read.csv(
      # user data
      input$newfile.c$datapath,
      header = input$newheader.c,
      sep = input$newsep.c,
      quote = input$newquote.c
    )
  }
  return(df)
  
})

output$table.c = renderDataTable(## > shiny
  X.c(),
  options = list(pageLength = 5))

## 2. choose variable to put in the model
output$t1.c = renderUI({
  selectInput(
    't1.c',
    h5('Follow-up (or start-up time-point)'),
    selected = NULL,
    choices = names(X.c())
  )
})

output$t2.c = renderUI({
  selectInput(
    't2.c',
    h5('NULL (or end-up time-point)'),
    selected = "NULL",
    choices = c("NULL", names(X.c()))
  )
})

output$c.c = renderUI({
  selectInput('c.c',
              h5('Status Variable'),
              selected = NULL,
              choices = names(X.c()))
})

output$x.c = renderUI({
  selectInput(
    'x.c',
    h5('Continuous Independent Variable'),
    selected = NULL,
    choices = names(X.c()),
    multiple = TRUE
  )
})

output$fx.c = renderUI({
  selectInput(
    'fx.c',
    h5('Categorical Independent Variable'),
    selected = NULL,
    choices = names(X.c()),
    multiple = TRUE
  )
})

output$sx.c = renderUI({
  selectInput(
    'sx.c',
    h5('Stratified Variable'),
    selected = NULL,
    choices = names(X.c()),
    multiple = TRUE
  )
})

output$clx.c = renderUI({
  selectInput(
    'clx.c',
    h5('Cluster Variable'),
    selected = NULL,
    choices = names(X.c()),
    multiple = TRUE
  )
})

### for summary
output$cv.c = renderUI({
  selectInput(
    'cv.c',
    h5('Continuous variable'),
    selected = NULL,
    choices = names(X.c()),
    multiple = TRUE
  )
})

output$dv.c = renderUI({
  selectInput(
    'dv.c',
    h5('Categorical variable'),
    selected = NULL,
    choices = names(X.c()),
    multiple = TRUE
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

formula.c = eventReactive(input$F.c, {
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


output$formula.c = renderPrint({
  formula.c()
})

## 4. output results
### 4.1. variables' summary
sum.c = eventReactive(input$Bc.c,
                      {
                        pastecs::stat.desc(X.c()[, input$cv.c], desc = FALSE)
                      })
fsum.c = eventReactive(input$Bd.c,
                       {
                         data = as.data.frame(X.c()[, input$dv.c])
                         colnames(data) = input$dv.c
                         lapply(data, table)
                       })

output$sum.c = renderTable({
  sum.c()
},
rownames = TRUE)
output$fsum.c = renderPrint({
  fsum.c()
})

### 4.2. model
fit.c = eventReactive(input$B1.c,
{
  coxph(formula.c(), data = X.c())
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
  fit = surv_fit(f, data = X.c())
  ggsurvplot(fit, data = X.c(), risk.table = TRUE)
  #plot(fit)
})
output$tx.c = renderUI({
  selectInput(
    'tx.c',
    h5('Categorical variable as group'),
    selected = names(X.c())[5],
    choices = names(X.c())
  )
})
output$p1.c = renderPlot({
  f = as.formula(paste0(y.c(), "~", input$tx.c))
  fit = surv_fit(f, data = X.c())
  ggsurvplot(fit,
             data = X.c(),
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

# histogram
output$hx.c = renderUI({
  selectInput(
    'hx.c',
    h5('Variable to Plot'),
    selected = names(X.c())[4],
    choices = names(X.c())
  )
})
output$p3.c = renderPlot({
  ggplot(X.c(), aes(x = X.c()[, input$hx.c])) + geom_histogram(
    colour = "black",
    fill = "grey",
    binwidth = input$bin.c,
    position = "identity"
  ) + xlab("") + theme_minimal() + theme(legend.title = element_blank())
})

# Residual output


output$p4.c = renderPlot({
  if (input$res.c=="martingale")
  {ggcoxdiagnostics(fit.c(), type = "martingale") + theme_minimal()}
  else if (input$res.c=="deviance")
  {ggcoxdiagnostics(fit.c(), type = "deviance") + theme_minimal()}
  else
  {
  cox.snell = (X.c()[, input$c.c]) - residuals(fit.c(), type = "martingale")
  coxph.res = survfit(coxph(Surv(cox.snell, X.c()[, input$c.c]) ~ 1, method = 'breslow'), type = 'aalen')
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
}, options = list(pageLength = 5))

#prediction plot
# prediction
pfit.c = eventReactive(input$B2.c, 
  {coxph(formula.c(), data = X.c())}
  )

output$pred.c = renderDataTable({
  df = data.frame(
    risk = predict(pfit.c(), newdata = newX.c(), type = "risk"),
    #survival=predict(fit.c(), newdata=newX.c(), type="survival"),
    #expected=predict(fit.c(), newdata=newX.c(), type="expected"),
    linear.predictors = predict(pfit.c(), newdata = newX.c(), type = "lp")
  )
  cbind(newX.c(), round(df, 4))
}, options = list(pageLength = 10))


output$p6.c = renderPlot({
  cox.snell = predict(pfit.c(), newdata = newX.c(), type = "expected")
  res = survfit(coxph(Surv(cox.snell, newX.c()[, input$c.c]) ~ 1, method = 'breslow'), type = 'aalen')
  d = data.frame(x = res$time, y = -log(res$surv))
  ggplot() + geom_step(data = d, mapping = aes(x = x, y = y)) + geom_abline(intercept =
                                                                              0,
                                                                            slope = 1,
                                                                            color = "red") +
    theme_minimal() + xlab("Modified Cox-Snell residuals") + ylab("Cumulative hazard")
})
