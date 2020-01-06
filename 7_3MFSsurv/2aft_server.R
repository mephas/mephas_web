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

#DF4 <- reactive({
#  df <-dplyr::select(DF3(), subset=c(-input$c))
#return(df)
#  })
#type.fac4 <- reactive({
#DF3() %>% select_if(is.factor) %>% colnames()
#})

output$var = renderUI({
selectInput(
'var',
tags$b('1. Choose one or more independent variables'),
selected = names(DF4())[3],
choices = names(DF4()),
multiple=TRUE)
})


output$fx.c = renderUI({
selectInput(
  'fx.c',
  tags$b('3.2. Choose random effect variable as additional effect, categorical'),
  selected = "NULL",
  choices = c("NULL", names(DF4()))
)
})

output$Xdata3 <- DT::renderDT(
head(DF3()), options = list(scrollX = TRUE))
### for summary
output$str3 <- renderPrint({str(DF3())})


aft = reactive({

if (input$effect=="") {f = paste0(surv(), '~', paste0(input$var, collapse = "+"), input$conf,input$intercept)}
if (input$effect=="Strata") {f = paste0(surv(), '~', paste0(input$var, collapse = "+"), "+strata(", input$fx.c, ")",input$conf,input$intercept)}
if (input$effect=="Cluster") {f = paste0(surv(), '~', paste0(input$var, collapse = "+"), "+cluster(", input$fx.c, ")", input$conf,input$intercept)}
if (input$effect=="Gamma Frailty") {f = paste0(surv(), '~', paste0(input$var, collapse = "+"), "+frailty(", input$fx.c, ")", input$conf,input$intercept)}
if (input$effect=="Gaussian Frailty") {f = paste0(surv(), '~', paste0(input$var, collapse = "+"), "+frailty.gaussian(", input$fx.c, ")", input$conf,input$intercept)}

  #fit <- survreg(as.formula(f), data = DF3(), dist=input$dist)
 
  return(f)
})

output$aft_form = renderPrint({cat(aft()) })

aftfit = eventReactive(input$B1, {
  survreg(as.formula(aft()), data = DF3(), dist=input$dist)
  })


#gfit = eventReactive(input$B1, {
#  glm(formula(), data = DF3())
#})
# 
output$fit = renderPrint({ 
res <- summary(aftfit())
res$call <- "AFT Model Result"
return(res)
})

fit.aft <- reactive({
 res <- data.frame(
  Y = DF3()[,input$t],
  lp = aftfit()$linear.predictors,
  fit = predict(aftfit(), type="response"),
  Residuals = resid(aftfit(),  type="response")
 )
 std <- (log(res[,1])-res[,2])/aftfit()$scale
  
  if (input$dist=="weibull") {res$csr <- -log(exp(-exp(std)))}
  if (input$dist=="exponential") {res$csr <- -log(exp(-exp(std)))}
  if (input$dist=="lognormal") {res$csr <- -log(1-pnorm(std))}
  if (input$dist=="loglogistic") {res$csr <- -log(1-plogis(std))}

 colnames(res) <- c("Time", "Linear Part = bX", "Predicted Time","Residuals = Time - Predicted Time", "Cox-snell Residuals")
 return(res)
  })
# 
 output$fit.aft = DT::renderDT(fit.aft(),
 class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$csplot = renderPlot({

fit = survfit(Surv(fit.aft()[,5], DF3()[, input$c]) ~ 1)
Htilde=cumsum(fit$n.event/fit$n.risk)

d = data.frame(time = fit$time, H = Htilde)
ggplot() + geom_step(data = d, mapping = aes(x = d[,"time"], y = d[,"H"])) + 
  geom_abline(intercept =0,slope = 1, color = "red") +
  theme_minimal() + xlab("Cox-Snell residuals") + ylab("Estimated Cumulative Hazard Function")
  })


