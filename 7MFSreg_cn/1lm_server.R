##----------------------------------------------------------------
##
## The regression models: lm, logistic model, cox model, server
##s
##    1. Linear regression
## 
## DT: 2018-12-13
##
##----------------------------------------------------------------

## 2. choose variable to put in the model/ and summary
output$y = renderUI({
  selectInput(
    'y',
    h5('连续型因变量 (Y)'),
    selected = NULL,
    choices = names(X())
    )
  })

output$x = renderUI({
  selectInput(
    'x',
    h5('连续型自变量 (X)'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
    )
  })


output$fx = renderUI({
  selectInput(
    'fx',
    h5('离散型自变量 (X)'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

### for summary


##3. regression formula
formula = eventReactive(input$F, {
  if (is.null(input$fx)) {
    fm = as.formula(paste0(
      input$y,
      '~',
      paste0(input$x, collapse = "+"),
      input$conf,
      input$intercept
    ))
  }
  else{
    fm = as.formula(paste0(
      input$y,
      '~',
      paste0("as.numeric(", input$x, ")",collapse = "+"),
      paste0("+ as.factor(", input$fx, ")", collapse = ""),
      input$conf,
      input$intercept
    ))
  }
  return(fm)
})

output$formula = renderPrint({formula()})

## 4. output results
### 4.2. model
fit = eventReactive(input$B1, {
  lm(formula(), data = X())
  })

sp = eventReactive(input$B1, {step(lm(formula(),  data = X()))})

#gfit = eventReactive(input$B1, {
#  glm(formula(), data = X())
#})
afit = eventReactive(input$B1, {anova(lm(formula(),  data = X()))})

output$fit = renderUI({
  #xtable(summary(gfit()), auto = TRUE)
  #list(Model = summary(fit()), AIC = summary(gfit())$aic)
  HTML(
    stargazer::stargazer(
      fit(),
      type = "html",
      style = "all",
      align = TRUE,
      ci = TRUE,
      single.row = TRUE,
      model.names = TRUE
      )
    )
  })

output$anova = renderTable({xtable::xtable(afit())}, rownames = TRUE)
output$step = renderPrint({sp()})

# residual plot
output$p.lm = renderPlot({autoplot(fit(), which = as.numeric(input$num)) + theme_minimal()})



output$fitdt0 = renderDataTable({
  data.frame(
    Linear.redictors = round(predict(fit()), 4),
    Residuals = round(fit()$residuals, 4)
    )
  }, 
  options = list(pageLength = 5, scrollX = TRUE))

newX = reactive({
  inFile = input$newfile
  if (is.null(inFile))
  {
    df = X()[1:10, ] ##>  example data
    }
  else{
    df = read.csv(
      inFile$datapath,
      header = input$newheader,
      sep = input$newsep,
      quote = input$newquote
      )
    }
  return(df)
  })
#prediction plot
# prediction
pred = eventReactive(input$B2,
       {
         fit = lm(formula(), data = X())
         pfit = predict(fit, newdata = newX(), interval = input$interval)
         })

output$pred = renderDataTable({
  cbind(newX(), round(pred(), 4))
  }, 
  options = list(pageLength = 5, scrollX = TRUE))

output$px = renderUI({
  selectInput(
    'px',
    h5('选择一个自变量 (X)'),
    selected = NULL,
    choices = names(newX())
  )
  })