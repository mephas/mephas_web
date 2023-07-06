#****************************************************************************************************************************************************model

type.bi <- reactive({
  #df <- DF3()
  #names <- apply(df,2,function(x) { length(levels(as.factor(x)))==2})
  #x <- colnames(DF3())[names]
  #return(x)
  colnames(DF3()[,var.type.list3()[,1] %in% "binary", drop=FALSE])
  })
## 
output$y = renderUI({
selectInput(
'y',
tags$b('1. 従属変数（Y、1つのバイナリ型）を選択する'),
selected = type.bi()[1],
choices = type.bi())
})

DF4 <- reactive({
  df <-DF3()[ ,-which(names(DF3()) %in% c(input$y))]
return(df)
  })

#output$x = renderUI({
#selectInput(
#'x',
#tags$b('2. 独立変数の追加/削除（X）'),
#selected = names(DF4()),
#choices = names(DF4()),
#multiple = TRUE
#)
#})

output$x = renderUI({
shinyWidgets::pickerInput(
'x',
tags$b('2. 独立変数の追加/削除（X）'),
selected = names(DF4()),
choices = names(DF4()),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})

type.fac4 <- reactive({
colnames(DF4()[unlist(lapply(DF4(), is.factor))])
})

output$conf = renderUI({
shinyWidgets::pickerInput(
'conf',
tags$b('3 （オプション） 2つのカテゴリ変数間に交互作用項を追加する'),
choices = type.fac4(),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      maxOptions=2,
      actionsBox=TRUE,
      size=5)
)
})

output$Xdata2 <- DT::renderDT(
head(DF3()),
options = list(scrollX = TRUE,dom = 't'))
### for summary
output$str <- renderPrint({str(DF3())})

##3. regression formula
formula = reactive({
validate(need(input$x, "Please choose some independent variable"))

f <- paste0(input$y,' ~ ',paste0(input$x, collapse = "+"), input$intercept)

if(length(input$conf)==2) {f <- paste0(f, "+",paste0(input$conf, collapse = ":"))}

return(f)

})

output$formula = renderPrint({
validate(need(input$x, "Please choose some independent variable"))
cat(formula())
})

## 4. output results
### 4.2. model
fit = eventReactive(input$B1, {
validate(need(input$x, "Please choose some independent variable"))
glm(as.formula(formula()),family = binomial(link = "logit"), data = DF3())
})


# output$plot_model<-renderPlot({
#   plot_model(fit(),vline.color="gray",show.values=TRUE,value.offset=.3,value.size=3)
# })

output$fit1 = renderPrint({ 
stargazer::stargazer(
fit(),
header=FALSE,
dep.var.caption="Logistic Regression",
dep.var.labels = paste0("Y = ",input$y),
type = "html",
style = "all",
align = TRUE,
ci = TRUE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE)
})

output$downloadfit1 <- downloadHandler(
    filename = function() {
      paste("logit-fit", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      coef <- summary(fit())$coefficients
      write.csv(coef, file)
    }
  )

output$downloadfit.latex1 <- downloadHandler(
    filename = function() {
      paste("logit-fit-", Sys.Date(), ".txt", sep="")
    },
    content = function(file) {
sink(file)
stargazer::stargazer(
fit(),
header=FALSE,
dep.var.caption="Logistic Regression",
dep.var.labels = paste0("Y = ",input$y),
type = "html",
style = "all",
align = TRUE,
ci = TRUE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE)
sink()
    }
  )

output$fit2 = renderPrint({
stargazer::stargazer(
fit(),
header=FALSE,
dep.var.caption="Logistic Regression in Odds Ratio",
dep.var.labels = paste("Y = ",input$y),
type = "html",
style = "default",
apply.coef = exp,
apply.ci = NULL,
align = TRUE,
ci = FALSE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE
)
})

output$downloadfit2 <- downloadHandler(
    filename = function() {
      paste("logit-fit2", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      coef <- summary(fit2())$coefficients
      write.csv(coef, file)
    }
  )

output$downloadfit.latex2 <- downloadHandler(
    filename = function() {
      paste("logit-fit2-", Sys.Date(), ".txt", sep="")
    },
    content = function(file) {
sink(file)
stargazer::stargazer(
fit(),
header=FALSE,
dep.var.caption="Logistic Regression in Odds Ratio",
dep.var.labels = paste("Y = ",input$y),
type = "html",
style = "default",
apply.coef = exp,
apply.ci = NULL,
align = TRUE,
ci = FALSE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE
)
sink()
    }
  )


#sp = reactive({step(fit())})
output$step = renderPrint({step(fit())})

# 
# # residual plot
 output$p.lm = plotly::renderPlotly({

  yhat <- predict(fit())
  y <- DF3()[,input$y]
  p<-plot_roc(yhat, y)

  plotly::ggplotly(p)
	})
# 
 fit.lm <- reactive({
 res <- data.frame(
  Y=DF3()[,input$y],
  nY=fit()$y,
 Fittings = round(fit()[["linear.predictors"]],6),
 Residuals = round(fit()[["fitted.values"]],6)
 )
 colnames(res) <- c("Dependent Variable = Y", "Numeric Y", "Linear Predictors = bX", "Predicted Y = 1/(1+exp(-bX))")
 return(res)
 	})
# 
 output$fitdt0 = DT::renderDT(fit.lm(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))
# 

sst <- reactive({
pred <- ROCR::prediction(fit()[["fitted.values"]], DF3()[,input$y])
perf <- ROCR::performance(pred,"sens","spec")
perf2 <- data.frame(
  sen=unlist(perf@y.values), 
  spec=unlist(perf@x.values), 
  spec2=1-unlist(perf@x.values), 
  cut=unlist(perf@alpha.values))
colnames(perf2) <- c("Sensitivity", "Specificity", "1-Specificity","Cut-off Point")
return(round(perf2,6))
  })

 output$sst = DT::renderDT(sst(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

