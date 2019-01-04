# Logistic regression

## 1. input data
### training data
X.l = reactive({
  inFile = input$file.l
  if (is.null(inFile))
  {
    df = mtcars[-(1:10),] ##>  example data
  }
  else{
    df = read.csv(
      ##> user data
      input$file.l$datapath,
      header = input$header.l,
      sep = input$sep.l,
      quote = input$quote.l
      )
    }
  return(df)
})

### testing data
newX.l = reactive({
  # req(input$file)
  inFile = input$newfile.l
  if (is.null(inFile))
  {
    df = mtcars[1:10, ] ##>  example data
  }
  else{
    df = read.csv(
      ##> user data
      
      input$newfile.l$datapath,
      header = input$newheader.l,
      sep = input$newsep.l,
      quote = input$newquote.l
      )
    }
  return(df)
  
})

output$table.l = renderDataTable(## > shiny
  X.l(),
  options = list(pageLength = 5))

## 2. choose variable to put in the model
output$y.l = renderUI({
  selectInput(
    'y.l',
    h5('Binary dependent Variable (Y)'),
    selected = NULL,
    choices = names(X.l())
    )
  })

output$x.l = renderUI({
  selectInput(
    'x.l',
    h5('Continuous independent variable (X)'),
    selected = NULL,
    choices = names(X.l()),
    multiple = TRUE
    )
  })

output$fx.l = renderUI({
  selectInput(
    'fx.l',
    h5('Categorical independent variable (X)'),
    selected = NULL,
    choices = names(X.l()),
    multiple = TRUE
    )
  })

### for summary
output$cv.l = renderUI({
  selectInput(
    'cv.l',
    h5('Continuous variable'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

output$dv.l = renderUI({
  selectInput(
    'dv.l',
    h5('Categorical variable'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

# 3. regression formula
formula.l = eventReactive(input$F.l, {
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

output$formula.l = renderPrint({
  formula.l()
})

## 4. output results
### 4.1. variables' summary
sum.l = eventReactive(input$Bc.l,
                      {
                        pastecs::stat.desc(X.l()[, input$cv.l], desc = FALSE)
                      })
fsum.l = eventReactive(input$Bd.l,
                       {
                         data = as.data.frame(X.l()[, input$dv.l])
                         colnames(data) = input$dv.l
                         lapply(data, table)
                       })

output$sum.l = renderTable({
  sum.l()
},
rownames = TRUE)
output$fsum.l = renderPrint({
  fsum.l()
})

### 4.2. model
fit.l = eventReactive(input$B1.l,
                      {
                        glm(formula.l(),
                            family = binomial(link = "logit"),
                            data = X.l())
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

# box plot
output$tx.l = renderUI({
  selectInput(
    'tx.l',
    h5('Independent variable (X)'),
    selected = names(X.l())[3],
    choices = names(X.l())
  )
})
output$ty.l = renderUI({
  selectInput(
    'ty.l',
    h5('Categorical variable as group '),
    selected = names(X.l())[8],
    choices = names(X.l())
  )
})
output$p1.l = renderPlot({
  ggplot(X.l(), aes(
    x = as.factor(X.l()[, input$ty.l]),
    y = X.l()[, input$tx.l],
    fill = as.factor(X.l()[, input$ty.l])
  )) + geom_boxplot(width = 0.4,
                    outlier.colour = "red",
                    alpha = .3) + xlab(input$ty.l) + ylab(input$tx.l) + ggtitle("") + theme_minimal() + theme(legend.title =
                                                                                                                element_blank())
})

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
                  y = X.l()[, input$y.l])
  ggplot(df, aes(d = y, m = "predictor", model = NULL)) + geom_roc(n.cuts = 0) +
    theme_minimal()
})

output$auc = renderPrint({
  mis = mean(fitdf()$fit.value != X.l()[, input$y.l])
  auc = performance(prediction(fitdf()$fit.prob, X.l()[, input$y.l]), measure = "auc")
  list(Accuracy = 1 - mis, AUC = auc@y.values[[1]])
})


# histogram
output$hx.l = renderUI({
  selectInput(
    'hx.l',
    h5('Variable to Plot'),
    selected = names(X.l())[1],
    choices = names(X.l())
  )
})
output$p3.l = renderPlot({
  ggplot(X.l(), aes(x = X.l()[, input$hx.l])) + geom_histogram(
    colour = "black",
    fill = "grey",
    binwidth = input$bin.l,
    position = "identity"
  ) + xlab("") + theme_minimal() + theme(legend.title = element_blank())
})

# prediction part
# prediction
pred.l = eventReactive(input$B2.l,
                       {
                         fit.l = glm(formula.l(),
                                     family = binomial(link = "logit"),
                                     data = X.l())
                         predict(fit.l, newdata = newX.l(), type = "response")
                       })
pred.v = eventReactive(input$B2.l,
                       {
                         ifelse(pred.l() > 0.5, 1, 0)
                       })
output$preddt.l = renderDataTable({
  data.frame(newX.l(), fit.prob = round(pred.l(), 4), fit = pred.v())
}, options = list(pageLength = 10))


output$p4.l = renderPlot({
  df = data.frame(predictor = pred.l(),
                  y = newX.l()[, input$y.l])
  ggplot(df, aes(d = y, m = "predictor", model = NULL)) + geom_roc(n.cuts = 0) +
    theme_minimal()
})

output$auc2 = renderPrint({
  mis = mean(pred.v() != newX.l()[, input$y.l])
  auc = performance(prediction(pred.l(), newX.l()[, input$y.l]), measure = "auc")
  list(Accuracy = 1 - mis, AUC = auc@y.values[[1]])
})