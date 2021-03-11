#****************************************************************************************************************************************************model

output$y = renderUI({
selectInput(
'y',
tags$b('1. 选择因变量（Y，一种数值变量）'),
selected = type.num3()[1],
choices = type.num3()
)
})

DF4 <- reactive({
  #df <-DF3()[ ,!which(names(DF3()) %in% c(input$y))]
  df <- names(DF3())[-which(names(DF3()) %in% c(input$y))]
return(df)
  })

#output$x = renderUI({
#selectInput(
#'x',
#tags$b('2. 添加/删除自变量（X）'),
#selected = names(DF4()),
#choices = names(DF4()),
#multiple = TRUE
#)
#})

output$x = renderUI({
shinyWidgets::pickerInput(
'x',
tags$b('2. 添加/删除自变量（X）'),
selected = DF4(), #names(DF4()),
choices = DF4(),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})

type.fac4 <- reactive({
#colnames(DF4()[unlist(lapply(DF4(), is.factor))])
  colnames(DF3()[,var.type.list3()[,1] %in% c("factor", "binary"),drop=FALSE])
})

output$conf = renderUI({
shinyWidgets::pickerInput(
'conf',
tags$b('4 （可选）添加变量交互项'),
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

## LM formula
formula = reactive({
validate(need(input$x, "请选择自变量"))

f <- paste0(input$y,' ~ ',paste0(input$x, collapse = "+"), input$intercept)

if(length(input$conf)==2) {f <- paste0(f, "+",paste0(input$conf, collapse = ":"))}

return(f)
})

output$formula = renderPrint({
validate(need(input$x, "请选择自变量"))
cat(formula())
  })

 

## 4. output results
### 4.2. model
fit = eventReactive(input$B1, {
lm(as.formula(formula()), data = DF3())
})

output$fit = renderPrint({
stargazer::stargazer(
fit(),
header=FALSE,
dep.var.caption = "Linear Regression",
dep.var.labels = paste0("Y = ",input$y),
type = "html",
style = "all",
align = TRUE,
ci = TRUE,
single.row = TRUE,
title=paste("Produced at ",Sys.time()),
model.names =FALSE)

})

output$downloadfit <- downloadHandler(
    filename = function() {
      paste("lm-fit", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      coef <- summary(fit())$coefficients
      write.csv(coef, file)
    }
  )

output$downloadfit.latex <- downloadHandler(
    filename = function() {
      paste("lm-fit-", Sys.Date(), ".txt", sep="")
    },
    content = function(file) {
sink(file)
stargazer::stargazer(
 fit(),
 header=FALSE,
 dep.var.caption = "Linear Regression",
 dep.var.labels = paste0("Y = ",input$y),
 type = "latex",
 style = "all",
 align = TRUE,
 ci = TRUE,
 single.row = TRUE,
 title=paste("Produced at ",Sys.time()),
 model.names =FALSE)
sink()
    }
  )

#### anova
afit = reactive({
  res.table <- anova(fit())
  colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
  return(round(res.table,6))
  })

output$anova = DT::renderDT({(afit())},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$step = renderPrint({step(fit())})

output$downloadsp <- downloadHandler(
    filename = function() {
      paste("lm-step", Sys.Date(), ".txt", sep="")
    },
    content = function(file) {
      sink(file)
      step(fit())
      sink()
    }
  )
# 
# # residual plot
output$p.lm1 = plotly::renderPlotly({
x <-data.frame(residuals=fit()$residuals)
p <- plot_qq1(data=x, varx="residuals")
plotly::ggplotly(p)
	})

output$p.lm2 = plotly::renderPlotly({
x <- data.frame(fit=fit()$fitted.values, res=fit()$residuals)
p <- plot_res(x, "fit", "res")
plotly::ggplotly(p)
  })
# 
 fit.lm <- reactive({
 res <- data.frame(Y=DF3()[,input$y],
 Fittings = fit()[["fitted.values"]],
 Residuals = fit()[["residuals"]]
 )
 colnames(res) <- c("Dependent Variable = Y", "Fittings = Predicted Y", "Residuals = Y - Predicted Y")
 return(round(res,6))
 	})
# 
output$fitdt0 = DT::renderDT(fit.lm(),
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))


output$vx1 = renderUI({
selectInput(
'vx1',
tags$b('1. 选择一个自变量（X1，数值型）'),
selected = names(DF3())[1],
choices = names(DF3())
)
})

output$vx2 = renderUI({
selectInput(
'vx2',
tags$b('2. 选择一个自变量（X2，数值型）'),
selected = names(DF3())[2],
choices = names(DF3())
)
})

output$vgroup = renderUI({
selectInput(
'vgroup',
tags$b('3. 选择一个分组变量、类别类型'),
selected = "NULL",
choices = c("NULL",type.fac4())
)
})

output$p.3dl = plotly::renderPlotly({
  if(input$vgroup == "NULL")
  {plot_linely(DF3(), input$y, input$vx1, input$vx2)}
  else{
   plot_linely.grp(DF3(), input$y, input$vx1, input$vx2, input$vgroup)
  }
  
})
