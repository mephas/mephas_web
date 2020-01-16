##' See https://alain003.phs.osaka-u.ac.jp/mephas_web/7MFSreg/
##'
##' MFSreg includes
##' (1) linear regression for continuous outcomes,
##' (2) logistic regression for binary outcomes,
##' and (3) Cox regression for time-event outcomes.
##'
##' Help file: https://alain003.phs.osaka-u.ac.jp/mephas/help7.html
##'
##' @title MEPHAS: Regression Model (Advanced Method)
##'
##' @return The web-based GUI and interactive interfaces
##'
##' @import shiny
##' @import ggplot2
##' @import survival
##' @import survminer
##' @import ggfortify
##' @import dplyr
##'
##' @importFrom xtable xtable
##' @importFrom stargazer stargazer
##' @importFrom ROCR performance prediction
##' @importFrom plotROC geom_roc
##' @importFrom stats anova as.formula binomial glm lm predict residuals step biplot relevel
##' @importFrom utils str write.table
##'
##' @examples
##' #mephas::MFSreg()
##' ## or,
##' # library(mephas)
##' # MFSreg()

##' @export
MFSreg <- function(){

##Yi
##20190504

##########----------##########----------##########

ui <- tagList(

##########----------##########----------##########

navbarPage(
title = "Regression Model",

#----------0. dataset panel----------

tabPanel("Dataset",

titlePanel("Data Preparation"),

#source("0data_ui.R", local=TRUE)
ui.reg.data()

    ),

#----------1. LM regression panel----------
tabPanel("Linear Regression (Continuous Outcomes)",

titlePanel("Linear Regression"),

#source("1lm_ui.R", local=TRUE)
ui.reg.lm()

), ## tabPanel

#---------- 2. logistic regression----------
tabPanel("Logistic Regression (1-0 Outcomes)",

titlePanel("Logistic Regression"),

#source("2lr_ui.R", local=TRUE)
ui.reg.lr()

), ## tabPanel(

#---------- 3. cox regression----------

tabPanel("Cox Regression (Time-Event Outcomes)",

titlePanel("Cox Regression"),

#source("3cr_ui.R", local=TRUE)
ui.reg.cr()

),

##########----------##########----------##########

tabPanel((a("Help",
            #target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas/","help7.html"))))

))

##########----------##########----------##########
##########----------##########----------##########

server <- function(input, output, session) {

##########----------##########----------##########
#----------0. dataset input----------

##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >data
##
## Language: EN
##
## DT: 2019-04-07
##
##----------#----------#----------#----------

data <- reactive({
                switch(input$edata,
               "insurance_linear_regression" = insurance_linear_regression,
               "advertisement_logistic_regression" = advertisement_logistic_regression,
               "lung_cox_regression" = lung_cox_regression)  
                })



XR = reactive({
  inFile = input$file
  if (is.null(inFile)){
      df <- data() ##>  example data
    }
  else{
    df <- read.csv(inFile$datapath,
        header = input$header,
        sep = input$sep,
        quote = input$quote)
  }
  
  #fac <- as.data.frame(lapply(df[,input$factor], factor))
  #df2 <- cbind.data.frame(df, fac)
  return(df)
  })


#output$data <- renderDataTable(
#    XR(), options = list(pageLength = 5, scrollX = TRUE))

output$factor1 = renderUI({
selectInput(
  'factor1',
  h5('Continuous/numeric -> Factor/categorical'),
  selected = NULL,
  choices = names(XR()),
  multiple = TRUE
)
})

output$lvl = renderUI({
selectInput(
'lvl',
h5('Re-set the referential level'),
selected = "NULL",
choices = c("NULL", names(XR()))
)
})

output$factor2 = renderUI({
selectInput(
  'factor2',
  h5('Factor/categorical -> Continuous/numeric'),
  selected = NULL,
  choices = names(XR()),
  multiple = TRUE
)
})

X <- reactive({
  df2 <- XR()

  F <- N <- data.frame(NULL)
  F <- as.data.frame(lapply(XR()[input$factor1], as.factor))
  N <- as.data.frame(lapply(XR()[input$factor2], as.numeric))

  if (!is.null(input$factor1) & !is.null(input$factor2)) {df2 <- data.frame(F,N, XR())}
  if (!is.null(input$factor1) &  is.null(input$factor2)) {df2 <- data.frame(F, XR())}
  if ( is.null(input$factor1) & !is.null(input$factor2)) {df2 <- data.frame(N, XR())}
  if ( is.null(input$factor1) &  is.null(input$factor2)) {df2 <- XR()}

  if (input$lvl!="NULL") {df2[,input$lvl] <- relevel(df2[,input$lvl], input$ref)}

  return(df2)
  })

output$Xraw <- renderDataTable(
    XR(), options = list(pageLength = 5,scrollX = TRUE))


Xdata <- eventReactive(input$changevar,{
    X()})


output$Xdata2 <- renderDataTable(
    Xdata(), options = list(pageLength = 5,scrollX = TRUE))

## variable type
type.num <- reactive({
con.names = X() %>% select_if(is.numeric) %>% colnames()
return(con.names)
})

type.fac <- reactive({
cat.names = X() %>% select_if(is.factor) %>% colnames()
return(cat.names)
})

output$str.num <- renderPrint({type.num()})
output$str.fac <- renderPrint({str(X()[,type.fac()])})


  output$data.h1 <- renderDataTable(
    head(X()), options = list(scrollX = TRUE))
  output$data.h2 <- renderDataTable(
    head(X()), options = list(scrollX = TRUE))
  output$data.h3 <- renderDataTable(
    head(X()), options = list(scrollX = TRUE))

  output$str0 <- renderPrint({str(head(XR()))})
  output$str00 <- renderPrint({str(head(X()))})
  output$str1 <- renderPrint({str(head(X()))})
  output$str2 <- renderPrint({str(head(X()))})
  output$str3 <- renderPrint({str(head(X()))})


# Basic Descriptives

output$cv = renderUI({
  selectInput(
    'cv', h5('Select continuous variables'),
    selected = NULL, 
    choices = type.num(), 
    multiple = TRUE)
})

output$dv = renderUI({
  selectInput(
    'dv', h5('Select discrete / categorical variables'), 
    selected = NULL, 
    choices = type.fac(), 
    multiple = TRUE)
})

sum = eventReactive(input$Bc,  ##> cont var
        {
          pastecs::stat.desc(X()[, input$cv], desc = TRUE, norm=TRUE)
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

output$download1 <- downloadHandler(
    filename = function() {
      "reg1.csv"
    },
    content = function(file) {
      write.csv(sum(), file, row.names = TRUE)
    }
  )

output$download2 <- downloadHandler(
    filename = function() {
      "reg2.txt"
    },
    content = function(file) {
      write.table(fsum(), file)
    }
  )

# First Exploration of Variables

output$tx = renderUI({
  selectInput(
    'tx', h5('Variable at the x-axis'),
    selected = "NULL", 
    choices = c("NULL",names(X())))
  
  })

output$ty = renderUI({
  selectInput(
    'ty',
    h5('Variable at the y-axis'),
    selected = "NULL", 
    choices = c("NULL",names(X())))
  
})

## scatter plot
output$p1 = renderPlot({
   validate(
      need(input$tx != "NULL", "Please select one continuous variable")
   )
  validate(
      need(input$ty != "NULL", "Please select one continuous variable")
    )
  ggplot(X(), aes(x = X()[, input$tx], y = X()[, input$ty])) + geom_point(shape = 1) + 
    geom_smooth(method = lm) + xlab(input$tx) + ylab(input$ty) + theme_minimal()
  })

## histogram
output$hx = renderUI({
  selectInput(
    'hx',
    h5('Histogram of the continuous variable'),
    selected = "NULL", 
    choices = c("NULL",names(X())))
})

output$hxd = renderUI({
  selectInput(
    'hxd',
    h5('Histogram of the categorical/discrete variable'),
    selected = "NULL", 
    choices = c("NULL",names(X())))
})

output$p2 = renderPlot({
  validate(
      need(input$hx != "NULL", "Please select one continuous variable")
    )
  ggplot(X(), aes(x = X()[, input$hx])) + 
    geom_histogram(binwidth = input$bin, colour = "black",fill = "white") + 
    geom_density()+
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })

output$p3 = renderPlot({
  validate(
      need(input$hxd != "NULL", "Please select one categorical/discrete variable")
    )
  ggplot(X(), aes(x = X()[, input$hxd])) + 
    geom_histogram(colour = "black",fill = "white",  stat="count") + 
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })


#----------1. Linear regression----------
#source("MFSreg.lm.server.R", local=TRUE)
#MFSreg.lm.server()
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

fit.lm <- reactive({
data.frame(Y=X()[,input$y],
Linear.predictors = round(predict(fit()), 4),
Residuals = round(fit()$residuals, 4)
)
  })

output$fitdt0 = renderDataTable({
fit.lm()
}, 
options = list(pageLength = 5, scrollX = TRUE))

output$download11 <- downloadHandler(
    filename = function() {
      "lm.fitting.csv"
    },
    content = function(file) {
      write.csv(fit.lm(), file, row.names = TRUE)
    }
  )

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

pred.lm <- reactive({
  cbind(newX(), round(pred(), 4))
  })

output$pred = renderDataTable({
pred.lm()
}, 
options = list(pageLength = 5, scrollX = TRUE))

output$download12 <- downloadHandler(
    filename = function() {
      "lm.pred.csv"
    },
    content = function(file) {
      write.csv(pred.lm(), file, row.names = TRUE)
    }
  )

output$px = renderUI({
selectInput(
'px',
h5('Choose one independent Variable (X)'),
selected = "NULL",
choices = c("NULL", names(newX()))
)
})

#----------2. Logistic regression----------
#source("MFSreg.lr.server.R", local=TRUE)
#MFSreg.lr.server()
##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >Logistic regression
##
## Language: EN
##
## DT: 2019-04-07
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
#out="logistic.exp.txt",
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


#----------3. Cox regression----------
#source("MFSreg.cr.server.R", local=TRUE)
#MFSreg.cr.server()
##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >Cox regression
##
## Language: EN
##
## DT: 2019-04-07
##
##----------#----------#----------#----------

### testing data
newX.c = reactive({
inFile = input$newfile.c
if (is.null(inFile))
{
  df = X()[1:10, ]
  
}
else{
  df = read.csv(
    # user data
    inFile$datapath,
    header = input$newheader.c,
    sep = input$newsep.c,
    quote = input$newquote.c
  )
}
return(df)
})

## 2. choose variable to put in the model
output$t1.c = renderUI({
selectInput(
  't1.c',
  h5('Continuous follow-up time (or start-up time-point)'),
  selected = "NULL",
  choices = c("NULL", names(X()))
)
})

output$t2.c = renderUI({
selectInput(
  't2.c',
  h5('NULL (or end-up time-point)'),
  selected = "NULL",
  choices = c("NULL", names(X()))
)
})

output$c.c = renderUI({
selectInput('c.c',
            h5('Status variable (0=censor, 1=event)'),
            selected = "NULL",
            choices = c("NULL", names(X()))
            )
})

output$x.c = renderUI({
selectInput(
  'x.c',
  h5('Independent variable'),
  selected = NULL,
  choices = names(X()),
  multiple = TRUE
)
})

output$fx.c = renderUI({
selectInput(
  'fx.c',
  h5('Factor variable as additional effect'),
  selected = "NULL",
  choices = c("NULL", names(X()))
)
})

# 3. regression formula
y = reactive({
if (input$t2.c == "NULL") {
  y = paste0("Surv(", input$t1.c, ",", input$c.c, ")")
}
else{
  y = paste0("Surv(", input$t1.c, ",", input$t2.c, ",", input$c.c, ")")
}
return(y)
})

formula_c = eventReactive(input$F.c, {

if (input$effect=="") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), input$conf.c)}
if (input$effect=="Strata") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), "+strata(", input$fx.c, ")",input$conf.c)}
if (input$effect=="Cluster") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), "+cluster(", input$fx.c, ")", input$conf.c)}
if (input$effect=="Gamma Frailty") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), "+frailty(", input$fx.c, ")", input$conf.c)}
if (input$effect=="Gaussian Frailty") {f = paste0(y(), '~', paste0(input$x.c, collapse = "+"), "+frailty.gaussian(", input$fx.c, ")", input$conf.c)}

return(as.formula(f))
})


output$formula_c = renderPrint({
formula_c()
})

## 4. output results
### 4.1. variables' summary

### 4.2. model
fit.c = eventReactive(input$B1.c,
{
coxph(formula_c(), data = X())
})

output$fit.c = renderPrint({
 if (input$effect=="Gamma Frailty" || input$effect=="Gaussian Frailty") {print(fit.c())}
 else
 {

  stargazer::stargazer(
    fit.c(),
    #out="cox.txt",
    header=FALSE,
    dep.var.caption="Cox Regression",
    dep.var.labels = "Estimate with 95% CI, t, p",
    type = "text",
    style = "all",
    align = TRUE,
    ci = TRUE,
    single.row = FALSE,
    title=paste("Cox Regression", Sys.time()),
    model.names = FALSE
)
}
})

output$fit.ce = renderPrint({
 if (input$effect=="Gamma Frailty" || input$effect=="Gaussian Frailty") {summary(fit.c())}
 else
 {
  stargazer::stargazer(
    fit.c(),
    #out="cox.txt",
    header=FALSE,
    dep.var.caption="Cox Regression with HR",
    dep.var.labels = "(HR=Exp(estimate) with 95% CI, t, p)",
    type = "text",
    style = "all",
    apply.coef = exp,
    apply.ci = exp,
    align = TRUE,
    ci = TRUE,
    single.row = FALSE,
    title=paste("Cox Regression with HR", Sys.time()),
    model.names = FALSE
  )
}
})


output$anova.c = renderTable({
  if (input$effect=="Cluster") {xtable::xtable(matrix(NA,1,3))}
  else {
xtable::xtable(anova(fit.c()))
}
}, rownames = TRUE)

output$step.c = renderPrint({
step(fit.c()) })


# K-M plot
y.c = eventReactive(input$Y.c,
{
y=y()
})
output$p0.c = renderPlot({
f = as.formula(paste0(y.c(), "~1"))
fit = surv_fit(f, data = X())
ggsurvplot(fit, data = X(), risk.table = TRUE)
#plot(fit)
})
output$tx.c = renderUI({
selectInput(
  'tx.c',
  h5('Categorical variable as group'),
  selected = "NULL",
  choices = c("NULL",names(X()))
)
})
output$p1.c = renderPlot({
validate(
  need(input$tx.c != "NULL", "Please select one group variable")
)
f = as.formula(paste0(y.c(), "~",input$tx.c))
fit = surv_fit(f, data = X())

ggsurvplot(fit,
           data = X(),
           risk.table = TRUE,
           pval = TRUE)
#plot(fit)
})

# coxzph plot
zph = eventReactive(input$B1.c, {
cox.zph(fit.c())
})
output$zph.c = renderTable({
as.data.frame(zph()$table)
}, rownames=TRUE)

output$p2.c = renderPlot({
#ggcoxzph(zph())+ggtitle("")
#p1= ggcoxdiagnostics(fit.c(), type = "schoenfeld") + theme_minimal()
ggcoxdiagnostics(fit.c(), type = "schoenfeld", ox.scale = "time") + theme_minimal()
#grid.arrange( p1,p2, ncol=2)
})

# Residual output

output$p4.c = renderPlot({
if (input$res.c=="martingale")
{ggcoxdiagnostics(fit.c(), type = "martingale") + theme_minimal()}
else if (input$res.c=="deviance")
{ggcoxdiagnostics(fit.c(), type = "deviance") + theme_minimal()}
else
{
cox.snell = (as.numeric(X()[, input$c.c])) - residuals(fit.c(), type = "martingale")
coxph.res = survfit(coxph(Surv(cox.snell, X()[, input$c.c]) ~ 1, method = 'breslow'), type = 'aalen')
d = data.frame(x = as.numeric(coxph.res$time), y = -log(coxph.res$surv))
ggplot() + geom_step(data = d, mapping = aes(x = d[,"x"], y = d[,"y"])) + 
  geom_abline(intercept =0,slope = 1, color = "red") +
  theme_minimal() + xlab("Modified Cox-Snell residuals") + ylab("Cumulative hazard")
}
})

fit.cox <- reactive({
  data.frame(
  Residual = round(fit.c()$residuals, 4),
  Linear.predictors = round(fit.c()$linear.predictors, 4)
)
  })

output$fitdt.c = renderDataTable({
fit.cox()
}, options = list(pageLength = 5, scrollX = TRUE))

output$download31 <- downloadHandler(
    filename = function() {
      "cox.fitting.csv"
    },
    content = function(file) {
      write.csv(fit.cox(), file, row.names = TRUE)
    }
  )
#prediction plot
# prediction
pfit.c = eventReactive(input$B2.c, 
{coxph(formula_c(), data = X())}
)

pred.cox <- reactive({
df = data.frame(
  risk = predict(pfit.c(), newdata = newX.c(), type = "risk"),
  #survival=predict(fit.c(), newdata=newX.c(), type="survival"),
  #expected=predict(fit.c(), newdata=newX.c(), type="expected"),
  linear.predictors = predict(pfit.c(), newdata = newX.c(), type = "lp")
)
cbind(newX.c(), round(df, 4))
  })
output$pred.c = renderDataTable({
pred.cox()
}, options = list(pageLength = 5, scrollX = TRUE))

output$download32 <- downloadHandler(
    filename = function() {
      "cox.pred.csv"
    },
    content = function(file) {
      write.csv(pred.cox(), file, row.names = TRUE)
    }
  )

##########----------##########----------##########
}

##########----------##########----------##########
##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}

