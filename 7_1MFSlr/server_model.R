#****************************************************************************************************************************************************model

output$y = renderUI({
selectInput(
'y',
tags$b('1. Choose one dependent variable (Y), real-valued numeric type'),
selected = type.num3()[1],
choices = type.num3()
)
})

DF4 <- reactive({
  df <-DF3()[ ,-which(names(DF3()) %in% c(input$y))]
return(df)
  })

#output$x = renderUI({
#selectInput(
#'x',
#tags$b('2. Add / Remove independent variables (X)'),
#selected = names(DF4()),
#choices = names(DF4()),
#multiple = TRUE
#)
#})

output$x = renderUI({
shinyWidgets::pickerInput(
'x',
tags$b('2. Add / Remove independent variables (X)'),
selected = names(DF4()),
choices = names(DF4()),
multiple = TRUE,
options = pickerOptions(
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
tags$b('4 (Optional). Add interaction term between 2 categorical variables'),
choices = type.fac4(),
multiple = TRUE,
options = pickerOptions(
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
#validate(need(input$x, "Please choose some independent variable"))
lm(as.formula(formula()), data = DF3())
})

 output$fit = renderPrint({
 stargazer::stargazer(
 fit(),
 #out="linear.txt",
 header=FALSE,
 dep.var.caption = "Linear Regression",
 dep.var.labels = paste0("Y = ",input$y),
 type = "text",
 style = "all",
 align = TRUE,
 ci = TRUE,
 single.row = TRUE,
 #no.space=TRUE,
 title=paste(Sys.time()),
 model.names =FALSE)
 
 })

afit = reactive( {
  res.table <- anova(fit())
  colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
  return(res.table)
  })

output$anova = DT::renderDT({(afit())},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#sp = reactive({step(fit())})
output$step = renderPrint({step(fit())})

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
 return(res)
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
tags$b('1. Choose one independent variable (X1), real-valued numeric type'),
selected = names(DF4())[1],
choices = names(DF4())
)
})

output$vx2 = renderUI({
selectInput(
'vx2',
tags$b('2. Choose one independent variable (X2), real-valued numeric type'),
selected = names(DF4())[2],
choices = names(DF4())
)
})

output$vgroup = renderUI({
selectInput(
'vgroup',
tags$b('3. Choose one group variable, categorical type'),
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
