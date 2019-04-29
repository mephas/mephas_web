##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >Linear regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

## 2. choose variable to put in the model/ and summary
output$y = renderUI({
selectInput(
'y',
h5('Continuous dependent variable (Y)'),
selected = "NULL",
choices = c("NULL", names(X()))
)
})

output$x = renderUI({
selectInput(
'x',
h5('Independent variable (X)'),
selected = NULL,
choices = names(X()),
multiple = TRUE
)
})


### for summary


##3. regression formula
formula = eventReactive(input$F, {

fm = as.formula(paste0(input$y, '~', paste0(input$x, collapse = "+"), 
	input$conf, input$intercept)
)
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

HTML(
stargazer::stargazer(
fit(),
#out="linear.txt",
header=FALSE,
dep.var.caption = "Linear Regression",
dep.var.labels = paste("Y = ",input$y, "(estimate with 95% CI, t, p)"),
type = "html",
style = "all",
align = TRUE,
ci = TRUE,
single.row = FALSE,
no.space=FALSE,
title=paste("Linear Regression", Sys.time()),
model.names =FALSE)

)

})

output$anova = renderTable({xtable::xtable(afit())}, rownames = TRUE)
output$step = renderPrint({sp()})

# residual plot
output$p.lm = renderPlot({autoplot(fit(), which = as.numeric(input$num)) + theme_minimal()})



output$fitdt0 = renderDataTable({
data.frame(Y=X()[,input$y],
Linear.predictors = round(predict(fit()), 4),
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
h5('Choose one independent Variable (X)'),
selected = "NULL",
choices = c("NULL", names(newX()))
)
})