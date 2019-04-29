##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >Logistic regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------



## 2. choose variable to put in the model
output$y.l = renderUI({
selectInput(
'y.l',
h5('Binary dependent Variable (Y)'),
selected = "NULL",
choices = c("NULL", names(X()))
)
})

output$x.l = renderUI({
selectInput(
'x.l',
h5('Independent variable (X)'),
selected = NULL,
choices = names(X()),
multiple = TRUE
)
})


# 3. regression formula
formula_l = eventReactive(input$F.l, {
fm = as.formula(paste0(input$y.l, '~', paste0(input$x.l, collapse = "+"), 
  input$conf.l, input$intercept.l)
)
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
#out="logistic.txt",
header=FALSE,
dep.var.caption="Logistic Regression",
dep.var.labels = paste(input$y.l, "(estimate with 95% CI, t, p)"),
type = "html",
style = "all",
align = TRUE,
ci = TRUE,
single.row = FALSE,
title=paste("Logistic Regression", Sys.time()),
model.names = FALSE
)
)
})

output$fit.le = renderUI({
HTML(
stargazer::stargazer(
fit.l(),
out="logistic.exp.txt",
header=FALSE,
dep.var.caption="Logistic Regression with OR",
dep.var.labels = paste(input$y.l, "(OR=Exp(estimate) with 95% CI, t, p)"),
type = "html",
style = "all",
apply.coef = exp,
apply.ci = exp,
align = TRUE,
ci = TRUE,
single.row = FALSE,
title=paste("Logistic Regression with OR", Sys.time()),
model.names = FALSE
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
fit.value = ifelse(fit.l()$fitted.values > 0.5, 1, 0),
Y = X()[, input$y.l]
)
return(df)
})
output$fitdt = renderDataTable({
fitdf()
}, options = list(pageLength = 5, scrollX = TRUE))

output$download21 <- downloadHandler(
    filename = function() {
      "lr.fitting.csv"
    },
    content = function(file) {
      write.csv(fitdf(), file, row.names = TRUE)
    }
  )

output$p2.l = renderPlot({
df = data.frame(predictor = fit.l()$fitted.values,
      y = X()[, input$y.l])
ggplot(df, aes(d = df[,"y"], m = df[,"predictor"], model = NULL)) + geom_roc(n.cuts = 0) + theme_minimal()
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

pred.lr <- reactive({
  data.frame(newX.l(), fit.prob = round(pred.l(), 4), fit = pred.v())
  })
output$preddt.l = renderDataTable({
pred.lr()
}, options = list(pageLength = 5, scrollX = TRUE))

output$download22 <- downloadHandler(
    filename = function() {
      "lr.pred.csv"
    },
    content = function(file) {
      write.csv(pred.lr(), file, row.names = TRUE)
    }
  )
