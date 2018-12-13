# Linear regression

## 1. input data
### training data
X = reactive({
  inFile = input$file
  if (is.null(inFile))
  {
    df = mtcars[-(1:10), ] ##>  example data
    }
  else{
    df = read.csv(
      ##> user data
      input$file$datapath,
      header = input$header,
      sep = input$sep,
      quote = input$quote
      )
    }
  return(df)
  })

### testing data
newX = reactive({
  inFile = input$newfile
  if (is.null(inFile))
  {
    df = mtcars[1:10, ] ##>  example data
    }
  else{
    df = read.csv(
      ##> user data
      input$newfile$datapath,
      header = input$newheader,
      sep = input$newsep,
      quote = input$newquote
      )
    }
  return(df)
  })

output$table = renderDataTable(## > shiny
  X(),
  options = list(pageLength = 5))

## 2. choose variable to put in the model/ and summary
output$y = renderUI({
  selectInput(
    'y',
    h5('連続従属変数 (Y)'),
    selected = NULL,
    choices = names(X())
    )
  })

output$x = renderUI({
  selectInput(
    'x',
    h5('連続独立変数　(X)'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
    )
  })

output$fx = renderUI({
  selectInput(
    'fx',
    h5('カテゴリ独立変数 (X)'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

### for summary
output$cv = renderUI({
  selectInput(
    'cv',
    h5('連続変数'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

output$dv = renderUI({
  selectInput(
    'dv',
    h5('カテゴリ変数'),
    selected = NULL,
    choices = names(X()),
    multiple = TRUE
  )
})

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
      paste0(input$x, collapse = "+"),
      paste0("+ as.factor(", input$fx, ")", collapse = ""),
      input$conf,
      input$intercept
    ))
  }
  return(fm)
})

output$formula = renderPrint({formula()})

## 4. output results
### 4.1. variables' summary
sum = eventReactive(input$Bc,  ##> cont var
        {
          pastecs::stat.desc(X()[, input$cv], desc = FALSE)
          #Hmisc::describe(X()[,input$cv])
        })
fsum = eventReactive(input$Bd, ##> dis var
       {
         data = as.data.frame(X()[, input$dv])
         colnames(data) = input$dv
         lapply(data, table)
       })

output$sum = renderTable({sum()}, rownames = TRUE)

output$fsum = renderPrint({fsum()})

### 4.2. model
fit = eventReactive(input$B1, {
  lm(formula(), data = X())
  })
#gfit = eventReactive(input$B1, {
#  glm(formula(), data = X())
#})
afit = eventReactive(input$B1, {anova(lm(formula(), data = X()))})

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

# independent variable
output$tx = renderUI({
  selectInput(
    'tx',
    h5('独立変数 (X)'),
    selected = names(X())[3],
    choices = names(X())
    )
  })

output$ty = renderUI({
  selectInput(
    'ty',
    h5('従属変数 (Y)'),
    selected = names(X())[1],
    choices = names(X())
  )
})
# scatter plot
output$p1 = renderPlot({
  ggplot(X(), aes(x = X()[, input$tx], y = X()[, input$ty])) + geom_point(shape = 1) + 
    geom_smooth(method = lm) + xlab(input$tx) + ylab(input$ty) + theme_minimal()
  })

# residual plot
output$p2 = renderPlot({autoplot(fit(), which = as.numeric(input$num)) + theme_minimal()})

# histogram
output$hx = renderUI({
  selectInput(
    'hx',
    h5('変数を選ぶ'),
    selected = names(X())[1],
    choices = names(X()))
})

output$p3 = renderPlot({
  ggplot(X(), aes(x = X()[, input$hx])) + 
    geom_histogram(colour = "black",fill = "grey",binwidth = input$bin,position = "identity") + 
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })

output$fitdt0 = renderDataTable({
  data.frame(
    residuals = round(fit()$residuals, 4),
    linear.predictors = round(predict(fit()), 4)
    )
  }, 
  options = list(pageLength = 5))

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
  options = list(pageLength = 10, digits = 4))

output$px = renderUI({
  selectInput(
    'px',
    h5('独立変数を一つ選ぶ (X)'),
    selected = names(newX())[2],
    choices = names(newX())
  )
  })

output$p4 = renderPlot({
  prediction = as.data.frame(pred())
  df = cbind(newX(), prediction)
  ggplot(df, aes(x = newX()[, input$px], y = fit)) +
    geom_point() +
    geom_line(aes(y = "lwr"), color = "red", linetype = "dashed") + xlab(input$px) +
    geom_line(aes(y = "upr"), color = "red", linetype = "dashed") +
    geom_smooth(method = lm, se = TRUE) + theme_minimal()
})
