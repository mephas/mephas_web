##----------------------------------------------------------------
##
## The regression models: lm, logistic model, cox model, server
##s
##    2. Logistic regression
## 
## DT: 2018-12-14
##
##----------------------------------------------------------------



## 2. choose variable to put in the model
output$y.l = renderUI({
  selectInput(
    'y.l',
    h5('Binary dependent Variable (Y)'),
    selected = NULL,
    choices = names(X())
    )
  })

output$x.l = renderUI({
  selectInput(
    'x.l',
    h5('Continuous independent variable (X)'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
    )
  })

output$fx.l = renderUI({
  selectInput(
    'fx.l',
    h5('Categorical independent variable (X)'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
    )
  })

# 3. regression formula
formula_l = eventReactive(input$F.l, {
  if (is.null(input$fx.l)) {
    fm = as.formula(paste0(
      input$y.l,
      '~',
      paste0(input$x.l, collapse = "+"),
      input$conf.l,
      input$intercept.l
    ))
  }
  else{
    fm = as.formula(paste0(
      input$y.l,
      '~',
      paste0(input$x.l, collapse = "+"),
      paste0("+ as.factor(", input$fx.l, ")", collapse = ""),
      input$conf.l,
      input$intercept.l
    ))
  }
  return(fm)
})

output$formula_l = renderPrint({
  formula_l()
})

### 4.2. model
fit.l = eventReactive(input$B1.l,
                      {
                        glm(formula_l(),
                            family = binomial(link = "logit"),
                            data = X())
                      })
output$fit.l = renderUI({
  HTML(
    stargazer::stargazer(
      fit.l(),
      type = "html",
      style = "all",
      align = TRUE,
      ci = TRUE,
      single.row = TRUE,
      model.names = TRUE
    )
  )
})
output$anova.l = renderTable({
  xtable::xtable(anova(fit.l()))
}, rownames = TRUE)

output$step.l = renderPrint({
  step(fit.l()) })


# ROC plot
fitdf = reactive({
  df = data.frame(
    fit.prob = round(fit.l()$fitted.values, 2),
    fit.value = ifelse(fit.l()$fitted.values > 0.5, 1, 0)
  )
  return(df)
})
output$fitdt = renderDataTable({
  fitdf()
}, options = list(pageLength = 10))

output$p2.l = renderPlot({
  df = data.frame(predictor = fit.l()$fitted.values,
                  y = X()[, input$y.l])
  ggplot(df, aes(d = "y", m = "predictor", model = NULL)) + geom_roc(n.cuts = 0) + theme_minimal()
})

output$auc = renderPrint({
  mis = mean(fitdf()$fit.value != X()[, input$y.l])
  auc = performance(prediction(fitdf()$fit.prob, X()[, input$y.l]), measure = "auc")
  list(Accuracy = 1 - mis, AUC = auc@y.values[[1]])
})

newX.l = reactive({
  inFile = input$newfile.l
  if (is.null(inFile))
  {
    df = X()[1:10, ] ##>  example data
  }
  else{
    df = read.csv(
      inFile$datapath,
      header = input$newheader.l,
      sep = input$newsep.l,
      quote = input$newquote.l
      )
    }
  return(df)
  
})
# prediction part
# prediction
pred.l = eventReactive(input$B2.l,
                       {
                         fit.l = glm(formula_l(),
                                     family = binomial(link = "logit"),
                                     data = X())
                         predict(fit.l, newdata = newX.l(), type = "response")
                       })
pred.v = eventReactive(input$B2.l,
                       {
                         ifelse(pred.l() > 0.5, 1, 0)
                       })
output$preddt.l = renderDataTable({
  data.frame(newX.l(), fit.prob = round(pred.l(), 4), fit = pred.v())
}, options = list(pageLength = 10))

