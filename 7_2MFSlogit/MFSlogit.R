
##'
##' MFSlogit includes
##' (1) logistic regression for binary outcomes,
##'
##' @title MEPHAS: Logistic Regression Model (Advanced Method)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom ROCR performance prediction
##' @importFrom stats anova as.formula binomial glm predict residuals step relevel
##' @importFrom utils str write.table
##'
##' @examples
##' # library(mephas)
##' # MFSlogit()
##' # or,
##' # mephas::MFSlogit()
##' # or,
##' # mephasOpen("logisreg")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFSlogit <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Logistic Regression",

##########----------##########----------##########

tabPanel("Data",

headerPanel("Data Preparation"),

HTML(
"
<b>Logistic regression</b> is used to model the probability of a certain class or event existing such as pass/fail, win/lose, alive/dead or healthy/sick. 
Logistic regression uses a logistic function to model a binary dependent variable.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input 
<li> To pre-process some variables (when necessary) for building the model
<li> To get the basic descriptive statistics and plots of the variables 
</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> Your data need to include <b>one binary dependent variable (denoted as Y)</b> and <b> at least one independent variables (denoted as X)</b>
<li> Your data need to have more rows than columns
<li> Do not mix character and numbers in the same column 
<li> The data used to build model is called <b>training set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose we wanted to explore the Breast Cancer dataset and develop a model to try classifying suspected cells to Benign (B) or Malignant (M). 
The dependent variable is binary outcome (B/M). We were interested (1) to build a model which calculates the probability of benign or malignant and then help us to determine whether the patient is benign or malignant, 
and (2) find the relations between binary dependent variable and the other variables, that is find out which variable contributes greatly to the dependent variable.


</h4></i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
#source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,
#****************************************************************************************************************************************************
sidebarLayout(

sidebarPanel(
  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("Training Set Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),

  selectInput("edata", tags$b("Use example data"), 
        choices =  c("Breast Cancer"), 
        selected = "Breast Cancer")
  ),

tabPanel("Upload Data", p(br()),

p("We suggested putting the dependent variable (Y) in the left side of all independent variables (X) "),

fileInput('file', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")), 
checkboxInput("header", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")), 
checkboxInput("col", "Yes", TRUE),

radioButtons("sep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often uses this"),
    HTML("One Tab (->|): TXT often uses this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("quote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
  )
  ),

hr(),

h4(tags$b("(Optional) Change the types of some variable?")),
uiOutput("factor1"),
uiOutput("factor2"),

h4(tags$b("(Optional) Change the referential level for categorical variable?")), 

uiOutput("lvl"),

p(tags$b("2. Input the referential level, each line for one variable")),

tags$textarea(id='ref',""),
hr(),

h4(tags$b("Build Model in the Next Tab"))


),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")), 
DT::DTOutput("Xdata"),

p(tags$b("1. Numeric variable information list")),
verbatimTextOutput("strnum"),

p(tags$b("2. Categorical variable information list")),
verbatimTextOutput("strfac"),


hr(),   
h4(tags$b("Output 2. Basic Descriptives")),

tabsetPanel(

tabPanel("Basic Descriptives", br(),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variables)")
),

tabPanel("Logit Plot",br(),

uiOutput('tx'),
uiOutput('ty'),

plotOutput("p1", width = "80%")
),

tabPanel("Histogram", br(),

HTML("<p><b>Histogram</b>: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
uiOutput('hx'),
p(tags$b("Histogram")),
plotOutput("p2", width = "80%"),
sliderInput("bin", "The number of bins in the histogram", min = 0, max = 100, value = 0),
p("When the number of bins is 0, plot will use the default number of bins "),
p(tags$b("Density plot")),
plotOutput("p21", width = "80%"))

))),
hr()


),

##########----------##########----------##########
tabPanel("Model",

headerPanel("Logistic Regression"),
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build simple or multiple logistic regression model
<li> To get the estimates of regressions, including (1) estimate of coefficients with t test, p value, and 95% CI, (2) R<sup>2</sup> and adjusted R<sup>2</sup>, and (3) F-Test for overall significance in Regression 
<li> To get additional information: (1) predicted dependent variable and residuals, (2) AIC-based variable selection, (3) ROC plot, and (4) sensitivity and specificity table for ROC plot
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> The dependent variable is binary
<li> Please prepare the training set data in the previous <b>Data</b> tab</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
),

hr(),
#source("1lm_ui.R", local=TRUE, encoding="UTF-8")$value,
#****************************************************************************************************************************************************model

sidebarLayout(


sidebarPanel(

tags$head(tags$style("#formula {height: 50px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#fit {overflow-y:scroll; max-height: 400px; background: white};")),
tags$head(tags$style("#fit2 {overflow-y:scroll; max-height: 400px; background: white};")),
tags$head(tags$style("#step {overflow-y:scroll; max-height: 400px; background: white};")),


h4(tags$b("Prepare the Model")),
p("Prepare the data in the previous tab"),
hr(),       

h4(tags$b("Step 1. Choose variables to build the model")),      

uiOutput('y'), 
uiOutput('x'),

radioButtons("intercept", "3. (Optional) Keep or remove intercept / constant term", ##> intercept or not
     choices = c("Remove intercept / constant term" = "-1",
                 "Keep intercept / constant term" = ""),
     selected = ""),
p(tags$b("4. (Optional) Add interaction term between categorical variables")), 
p('Please input: + var1:var2'), 
tags$textarea(id='conf', " " ), 
hr(),
h4(tags$b("Step 2. Check the model")),
tags$b("Valid model example: Y ~ X1 + X2"),
verbatimTextOutput("formula"),
p("'-1' in the formula indicates that intercept / constant term has been removed"),
hr(),

h4(tags$b("Step 3. If data and model are ready, click the blue button to generate model results.")),
actionButton("B1", h4(tags$b("Show Results >>")), class = "btn btn-primary")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
tabsetPanel(
    tabPanel("Variables Information", br(),
verbatimTextOutput("str")
),
tabPanel("First Part of Data", br(),
p("Check full data in Data tab"),
DT::DTOutput("Xdata2")
)

),
hr(),

h4(tags$b("Output 2. Model Results")),
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  class = "btn-warning"),
 p(br()),
tabsetPanel(

tabPanel("Model Estimation",  br(),

HTML(
"
<b> Explanations  </b>
<ul>
<li> Output in the left shows estimated coefficients (95% confidence interval), T statistic (t = ) for the significance of single variable, and P value (p = ) are given
<li> Output in the right shows odds ratio = exp(b) and standard error of the original coefficients
<li> T test of each variable and P < 0.05 indicates this variable is statistical significant to the model
<li> Observations means the number of samples
<li> Akaike Inf. Crit. = AIC = -2 (log likelihood) + 2k; k is the number of variables + constant
</ul>
"
),

fluidRow(
column(6, verbatimTextOutput("fit")
),
column(6, verbatimTextOutput("fit2")
)
)
),

tabPanel("Data Fitting",  br(),

    DT::DTOutput("fitdt0")
    ),

tabPanel("AIC-based Selection",  br(),
HTML(
"<b> Explanations </b>
<ul> 
<li> The Akaike Information Criterion (AIC) is a way of selecting a model from a set of models. 
<li> Model fits are ranked according to their AIC values, and the model with the lowest AIC value is sometime considered the 'best'. 
<li> This selection is just for your reference.
</ul>"
),
    p(tags$b("Model selection suggested by AIC")),
    verbatimTextOutput("step")


    ),

tabPanel("ROC Plot",   br(),

HTML(
"<b> Explanations </b>
<ul> 
<li> ROC curve: receiver operating characteristic curve, is a graphical plot that illustrates the diagnostic ability of a binary classifier system as its discrimination threshold is varied
<li> ROC curve is created by plotting the true positive rate (TPR) against the false positive rate (FPR) at various threshold settings
<li> Sensitivity (also called the true positive rate) measures the proportion of actual positives that are correctly identified as such
<li> Specificity (also called the true negative rate) measures the proportion of actual negatives that are correctly identified as such

</ul>"
),
plotOutput("p.lm", width = "80%"),
DT::DTOutput("sst")
    )

)
)
),
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("Prediction",

headerPanel("Prediction from Model"),
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload new data and get the prediction
<li> To get the evaluation if new data contains new dependent variable
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data cover all the independent variables used in the model.
<li> New data not used to build the model is called <b>test set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in the same study, we got the new data, and wanted to classify the patients based on the model we build.

</h4></i>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
),

hr(),
#source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value,
#****************************************************************************************************************************************************pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Test Set Preparation")),
p("Prepare model in the previous Model tab"),

tabsetPanel(

tabPanel("Example data", p(br()),

 h4(tags$b("Data: Birth Weight"))

  ),

tabPanel("Upload Data", p(br()),

p("New data should include all the variables in the model"),
p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),

fileInput('newfile', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
p(tags$b("2. Show 1st row as column names?")),
checkboxInput("newheader", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("newcol", "Yes", TRUE),

     # Input: Select separator ----
radioButtons("newsep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("newquote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input")

)
),

hr(),

h4(tags$b("If the model and new data are ready, click the blue button to generate prediction results.")),

actionButton("B2", h4(tags$b("Show Prediction >>")), class = "btn btn-primary")


),


mainPanel(

h4(tags$b("Output. Prediction Results")),
#actionButton("B2", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Prediction",p(br()),
p("Predicted dependent variable is shown in the 1st column"),
DT::DTOutput("pred")
),

tabPanel("ROC Evaluation",p(br()),
p("This plot is shown when new dependent variable is provided in the test data."),
p("This plot shows the ROC plot between predicted values and true values, based on the new data not used in the model."),
plotOutput("p.s", width = "80%"),
p(tags$b("Sensitivity and specificity table")),
DT::DTOutput("sst.s")
)
)

) 
),
hr()
),


##########----------##########----------##########
tabPanel((a("Help Pages Online",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/")))),
tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "Stop and Quit"))

))

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {

##source("0data_server.R", local=TRUE)$value
#****************************************************************************************************************************************************
#load("LGT.RData")

data <- reactive({
                switch(input$edata,
               "Breast Cancer" = LGT)  
                })


DF0 = reactive({
  inFile = input$file
  if (is.null(inFile)){
    x<-data()
    }
  else{
if(input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})

## variable type
type.num0 <- reactive({
colnames(DF0()[unlist(lapply(DF0(), is.numeric))])
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  HTML('1. Convert real-valued numeric variable into categorical variable'),
  selected = NULL,
  #choices = names(DF()),
  choices = type.num0(),
  multiple = TRUE
)
})

DF1 <- reactive({
df <-DF0() 
df[input$factor1] <- as.data.frame(lapply(df[input$factor1], factor))
return(df)
  })

type.fac1 <- reactive({
colnames(DF1()[unlist(lapply(DF1(), is.factor))])
})

output$factor2 = renderUI({
selectInput(
  'factor2',
  HTML('2. Convert categorical variable into real-valued numeric variable'),
  selected = NULL,
  #choices = names(DF()),
  choices = type.fac1(),
  multiple = TRUE
)
})



DF2 <- reactive({
  df <-DF1() 
df[input$factor2] <- as.data.frame(lapply(df[input$factor2], as.numeric))
return(df)
  })

type.fac2 <- reactive({
colnames(DF2()[unlist(lapply(DF2(), is.factor))])
})

output$lvl = renderUI({
selectInput(
'lvl',
HTML('1. Choose categorical variable'),
selected = NULL,
choices = type.fac2(),
multiple = TRUE
)
})

DF3 <- reactive({

if (length(input$lvl)==0 || length(unlist(strsplit(input$ref, "[\n]")))==0 ||length(input$lvl)!=length(unlist(strsplit(input$ref, "[\n]")))){
df <- DF2()
}

else{
df <- DF2()
x <- input$lvl
y <- unlist(strsplit(input$ref, "[\n]"))
for (i in 1:length(x)){
#df[,x[i]] <- as.factor(as.numeric(df[,x[i]]))
df[,x[i]] <- relevel(df[,x[i]], ref= y[i])
}

}
return(df)

})


output$Xdata <- DT::renderDT(DF3(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

type.num3 <- reactive({
colnames(DF3()[unlist(lapply(DF3(), is.numeric))])
})

type.fac3 <- reactive({
colnames(DF3()[unlist(lapply(DF3(), is.factor))])
})

output$strnum <- renderPrint({str(DF3()[,type.num3()])})

output$strfac <- renderPrint({Filter(Negate(is.null), lapply(DF3(),levels))})


sum <- reactive({
  x <- DF3()[,type.num3()]
  res <- as.data.frame(psych::describe(x))[,-c(1,6,7)]
  rownames(res) = names(x)
  colnames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$sum <- DT::renderDT({sum()},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

fsum = reactive({
  x <- DF3()[,type.fac3()]
  summary(x)
  })

output$fsum = renderPrint({fsum()})
 
output$download2 <- downloadHandler(
filename = function() {
"lr.des2.txt"
},
content = function(file) {
write.table(fsum(), file, row.names = TRUE)
}
)
# 
# # First Exploration of Variables
# 
output$tx = renderUI({
selectInput(
'tx',
tags$b('1. Choose a numeric variable for the x-axis'),
selected=type.num3()[1],
choices = type.num3())
})

output$ty = renderUI({
selectInput(
'ty',
tags$b('2. Choose a binary variable for the y-axis'),
selected = type.bi()[1],
choices = type.bi())
})
 
 ## scatter plot
output$p1 = renderPlot({
x<-DF3()
plot_slgt(x, input$tx, input$ty)
})
 
## histogram
 output$hx = renderUI({
   selectInput(
     'hx',
     tags$b('Choose a numeric variable to see the distribution'),
     selected = type.num3()[1], 
     choices = type.num3())
 })
 
output$p2 = renderPlot({
   plot_hist1(DF3(), input$hx, input$bin)
   })

output$p21 = renderPlot({
     plot_density1(DF3(), input$hx)
   
   })
 




##source("1lm_server.R", local=TRUE)$value
#****************************************************************************************************************************************************model

type.bi <- reactive({
  df <- DF3()
  names <- apply(df,2,function(x) { length(levels(as.factor(x)))==2})
  x <- colnames(DF3())[names]
  return(x)
  })
## 
output$y = renderUI({
selectInput(
'y',
tags$b('1. Choose one dependent variable (Y), binary type'),
selected = type.bi()[1],
choices = type.bi())
})

DF4 <- reactive({
  df <-DF3()[ ,-which(names(DF3()) %in% c(input$y))]
return(df)
  })

output$x = renderUI({
selectInput(
'x',
tags$b('2. Add / Remove the independent variables (X)'),
selected = names(DF4()),
choices = names(DF4()),
multiple = TRUE
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
as.formula(paste0(input$y,' ~ ',paste0(input$x, collapse = "+"), 
    input$conf, 
  input$intercept)
)

})

output$formula = renderPrint({
#validate(need(length(levels(as.factor(DF3()[, input$y])))==2, "Please choose a binary variable as Y")) 
validate(need(input$x, "Please choose some independent variable"))
#formula()
cat(paste0(input$y,' ~ ',paste0(input$x, collapse = " + "), 
  input$conf, 
  input$intercept))
})

## 4. output results
### 4.2. model
fit = eventReactive(input$B1, {
validate(need(input$x, "Please choose some independent variable"))
glm(formula(),family = binomial(link = "logit"), data = DF3())
          })


#gfit = eventReactive(input$B1, {
#  glm(formula(), data = DF3())
#})
# 
output$fit = renderPrint({ 
stargazer(
fit(),
#out="logistic.txt",
header=FALSE,
dep.var.caption="Logistic Regression",
dep.var.labels = paste0("Y = ",input$y),
type = "text",
style = "all",
align = TRUE,
ci = TRUE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE)
})

output$fit2 = renderPrint({
stargazer(
fit(),
#out="logistic.exp.txt",
header=FALSE,
dep.var.caption="Logistic Regression in Odds Ratio",
dep.var.labels = paste("Y = ",input$y),
type = "text",
style = "all2",
apply.coef = exp,
apply.ci = NULL,
align = TRUE,
ci = FALSE,
single.row = TRUE,
title=paste(Sys.time()),
model.names = FALSE
)
})

#sp = reactive({step(fit())})
output$step = renderPrint({step(fit())})

# 
# # residual plot
 output$p.lm = renderPlot({

  yhat <- predict(fit())
  y <- DF3()[,input$y]
  plot_roc(yhat, y)
  #p <- ROCR::prediction(predict(fit()), DF3()[,input$y])
  #ps <- ROCR::performance(p, "tpr", "fpr")
  #pf <- ROCR::performance(p, "auc")

  #df <- data.frame(tpr=unlist(ps@y.values), 
  #  fpr=unlist(ps@x.values))

#p<- ggplot(df, aes(fpr,tpr)) + 
#  geom_step() +
#  coord_cartesian(xlim=c(0,1), ylim=c(0,1)) +
#  theme_minimal()+ ggtitle("") +
#  xlab("False positive rate (1-specificity)")+
#  ylab("True positive rate (sensitivity)")+
#  annotate("text", x = .75, y = .25, label = paste("AUC =",pf@y.values))
    })
# 
 fit.lm <- reactive({
 res <- data.frame(
  Y=DF3()[,input$y],
  nY=fit()$y,
 Fittings = (fit()[["linear.predictors"]]),
 Residuals = (fit()[["fitted.values"]])
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
return(perf2)
  })

 output$sst = DT::renderDT(sst(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))




##source("2pr_server.R", local=TRUE)$value
#****************************************************************************************************************************************************pred

newX = reactive({
  inFile = input$newfile
  if (is.null(inFile)){
    x<-LGT.new
    }
  else{
if(!input$newcol){
    csv <- read.csv(inFile$datapath, header = input$newheader, sep = input$newsep, quote=input$newquote)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$newheader, sep = input$newsep, quote=input$newquote, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})
#prediction plot
# prediction
pred = eventReactive(input$B2,
{
  res <- data.frame(lp = predict(fit(), newdata = newX(), type="link"),
  predict= predict(fit(), newdata = newX(), type="response"))
  colnames(res) <- c("Linear Predictors", "Predicted Y")
  return(res)
})

pred.lm <- reactive({
    cbind.data.frame((pred()), newX())
    })

output$pred = DT::renderDT(pred.lm(),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

 output$p.s = renderPlot({
  validate(need((pred.lm()[, input$y]), "This evaluation plot will not show unless dependent variable Y is given in the new data"))

  yhat <- pred.lm()[,2]
  y <- pred.lm()[,input$y]
  plot_roc(yhat, y)

  })

sst.s <- reactive({
validate(need((pred.lm()[, input$y]), "This evaluation plot will not show unless dependent variable Y is given in the new data"))

pred <- ROCR::prediction(pred.lm()[,2], pred.lm()[,input$y])
perf <- ROCR::performance(pred,"sens","spec")
perf2 <- data.frame(
  sen=unlist(perf@y.values), 
  spec=unlist(perf@x.values), 
  spec2=1-unlist(perf@x.values), 
  cut=unlist(perf@alpha.values))
colnames(perf2) <- c("Sensitivity", "Specificity", "1-Specificity","Cut-off Point")
return(perf2)
  })

 output$sst.s = DT::renderDT((sst.s()),
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
