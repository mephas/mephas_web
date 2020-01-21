##'
##' MFSlr includes
##' (1) linear regression for continuous outcomes
##'
##' @title MEPHAS: Linear Regression Model (Advanced Method)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom stargazer stargazer
##' @importFrom stats anova as.formula lm predict residuals step relevel
##' @importFrom utils str write.table
##'
##' @examples
##' #mephas::MFSlr()
##' ## or,
##' # library(mephas)
##' # MFSlr()

##' @export
MFSlr <- function(){

requireNamespace("shiny")
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Linear Regression",

##########----------##########----------##########


tabPanel("Data",

headerPanel("Data Preparation"),

HTML(
"
<b>Linear regression</b> is a linear approach to modeling the relationship between a dependent variable and one or more independent variables. 
The case of one explanatory variable is called simple <b>linear regression</b>. 
For more than one explanatory variable, the process is called <b>multiple linear regression</b>.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input 
<li> To pre-process some variables (when necessary) for building the model
<li> To get the basic descriptive statistics and plots of the variables 
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> Your data need to include <b>one dependent variable (denoted as Y)</b> and <b> at least one independent variables (denoted as X)</b>
<li> Your data need to have more rows than columns
<li> Do not mix character and numbers in the same column 
<li> The data used to build model is called <b>training set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in one study, the doctors recorded the birth weight of 10 infants, together with age (month), age group (a: age < 4 month, b; other wise), and SBP.
We were interested (1) to predict the birth weight of a infants, 
and (2) find the relations between birth weight and the other variables, that is, to find out which variable contributes greatly to the dependent variable.

</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please build the model in the next tab.</h4>
"
),

hr(),
#source("0data_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$head(tags$style("#strnum {overflow-y:scroll; height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; height: 100px; background: white};")),

selectInput("edata", h4(tags$b("Use example data (training set)")), 
        choices =  c("Birth weight"), 
        selected = "Birth weight"),
hr(),

h4(tags$b("Use my own data (training set)")),
p("We suggested putting the dependent variable (Y) in the left side of all independent variables (X) "),

h4(tags$b("Step 1. Upload Data File")), 

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

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets"),

hr(),

h4(tags$b("(Optional) Change the types of some variable?")),

#p(tags$b("Choice 1. Change Real-valued Variables into Categorical Variable")), 

uiOutput("factor1"),

#p(tags$b("Choice 2. Change Categorical Variable (Numeric Factors) into Numeric Variables (Numbers)")),

uiOutput("factor2"),

h4(tags$b("(Optional) Change the referential level for categorical variable?")), 

uiOutput("lvl"),

p(tags$b("2. Input the referential level, each line for one variable")),

tags$textarea(id='ref',"")


),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")), 
p(br()),
DT::DTOutput("Xdata"),

p(tags$b("1. Numeric variable information list")),
verbatimTextOutput("strnum"),

p(tags$b("2. Categorical variable information list")),
verbatimTextOutput("strfac"),

hr(),   
h4(tags$b("Output 2. Basic Descriptives")),

tabsetPanel(

tabPanel("Basic Descriptives", p(br()),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variable)")

),

tabPanel("Linear fitting plot",p(br()),

HTML("<p><b>Linear fitting plot</b>: to roughly show the linear relation between any two numeric variable. Grey area is 95% confidence interval.</p>"),

uiOutput('tx'),
uiOutput('ty'),

plotOutput("p1", width = "80%")
),

tabPanel("Histogram", p(br()),

HTML("<p><b>Histogram</b>: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
uiOutput('hx'),
plotOutput("p2", width = "80%"),
sliderInput("bin", "The width of bins in the histogram", min = 0, max = 10, value = 1))

)

)

),
hr()


),

##########----------##########----------##########
tabPanel("Model",

headerPanel("Linear Regression"),

HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build a simple or multiple linear regression model
<li> To get the estimates of regressions, including (1) estimate of coefficients with t test, p value, and 95% CI, (2) R<sup>2</sup> and adjusted R<sup>2</sup>, and (3) F-Test for overall significance in Regression 
<li> To get additional information: (1) predicted dependent variable and residuals, (2) ANOVA table of model, (3) AIC-based variable selection, and (4) diagnostic plot based from the residuals and predicted dependent variable 
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> The dependent variable is real-valued and continuous with underlying normal distribution.
<li> Please prepare the training set data in the previous <b>Data</b> tab
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
),

hr(),
#source("1lm_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************model
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#formula {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; height: 350px; background: white};")),
tags$head(tags$style("#fit {overflow-y:scroll; height: 400px; background: white};")),
tags$head(tags$style("#step {overflow-y:scroll;height: 400px; background: white};")),


h4("Example data is upload in Data tab"),      

h4(tags$b("Step 1. Choose variables to build the model")),      

uiOutput('y'),    
uiOutput('x'),
#uiOutput('fx'),

radioButtons("intercept", "3. (Optional) Keep or remove intercept / constant term", ##> intercept or not
     choices = c("Remove intercept / constant term" = "-1",
                 "Keep intercept / constant term" = ""),
     selected = ""),
p(tags$b("4. (Optional) Add interaction term between categorical variables")), 
p('Please input: + var1:var2'), 
tags$textarea(id='conf', " " ), 
hr(),
h4(tags$b("Step 2. Check the model")),
verbatimTextOutput("formula"),
p("'-1' in the formula indicates that intercept / constant term has been removed")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
tabsetPanel(
tabPanel("Browse", br(),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("Xdata2")
),
tabPanel("Variables information", br(),
verbatimTextOutput("str")

)
),
hr(),

#h4(tags$b("Output 2. Model Results")),
actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),
tabsetPanel(

tabPanel("Model Estimation",  br(),
    
HTML(
"
<b> Explanations  </b>
<ul>
<li> For each variable, estimated coefficients (95% confidence interval), T statistic (t = ) for the significance of single variable, and P value (p = ) are given
<li> T test of each variable and P < 0.05 indicates this variable is statistical significant to the model
<li> Observations means the number of samples
<li> R2 (R<sup>2</sup>) is a goodness-of-fit measure for linear regression models, and indicates the percentage of the variance in the dependent variable that the independent variables explain collectively.
Suppose R2 = 0.49. This implies that 49% of the variability of the dependent variable has been accounted for, and the remaining 51% of the variability is still unaccounted for.
<li> Adjusted R2 (adjusted R<sup>2</sup>) is used to compare the goodness-of-fit for regression models that contain differing numbers of independent variables.
<li> F statistic (F-Test for overall significance in regression) judges on multiple coefficients taken together at the same time. 
     F=(R^2/(k-1))/(1-R^2)/(n-k); n is sample size; k is number of variable + constant term
</ul>
"
),
verbatimTextOutput("fit")

    ),

tabPanel("Data Fitting",  br(),

    DT::DTOutput("fitdt0")
),

tabPanel("ANOVA",  br(),

HTML(
"<b> Explanations </b>
<ul> 
<li> DF<sub>variable</sub> = 1
<li> DF<sub>residual</sub> = [number of sample values] - [number of variables] -1
<li> MS = SS/DF
<li> F = MS<sub>variable</sub> / MS<sub>residual</sub> 
<li> P Value < 0.05:  the variable is significant to the model.
</ul>"
    ),
    p(tags$b("ANOVA Table")),  
    DT::DTOutput("anova")),

tabPanel("AIC-based Selection",  br(),
    HTML(
    "<b> Explanations </b>
  <ul> 
    <li> The Akaike Information Criterion (AIC) is a way of selecting a model from a set of models. 
    <li> Model fits are ranked according to their AIC values, and the model with the lowest AIC value is sometime considered the 'best' 
    <li> This selection is just for your reference.
  </ul>"
    ),

    p(tags$b("Model selection suggested by AIC")),
    verbatimTextOutput("step")

    ),

tabPanel("Diagnostics Plot",   br(),
HTML(
"<b> Explanations </b>
<ul> 
<li> QQ normal plot of residuals checks the normality of residuals. The linearity of the points suggests that the data are normally distributed.
<li> Residuals vs fitting plot finds the outliers
</ul>"
),
p(tags$b("1. QQ normal plot of residuals")),
plotOutput("p.lm1", width = "80%"),
p(tags$b("2. Residuals vs Fitting plot")),
plotOutput("p.lm2", width = "80%")

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

Suppose in the same study, the doctors got another 6 infants data, and wanted to predict their birth weights based on the model we build.

</h4></i>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
),

hr(),
#source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Use example data (test set)")),
h4("Click the Output"),

hr(),

h4(tags$b("Use my own data (test set)")),
p("New data should include all the variables in the model"),
p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),

h4(tags$b("Step 1. Upload New Data File")),      

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
),


mainPanel(

actionButton("B2", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Prediction",p(br()),
p("Predicted dependent variable is shown in the 1st column"),
DT::DTOutput("pred")
),

tabPanel("Evaluation Plot",p(br()),
p(tags$b("Prediction vs True Dependent Variable Plot")),
p("This plot is shown when new dependent variable is provided in the test data."),
p("This plot shows the relation between predicted dependent variable and new dependent variable, using linear smooth. Grey area is confidence interval."),
plotOutput("p.s", width = "80%")
)
) 
) 
),
hr()
),


##########----------##########----------##########
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

#source("0data_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

load("LR.RData")

data <- reactive({
                switch(input$edata,
               "Birth weight" = LR)  
                })


DF0 = reactive({
  inFile = input$file
  if (is.null(inFile)){
    x<-data()
    }
  else{
if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1)
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
     selected=type.num3()[2],
     choices = type.num3())
   })
 
 output$ty = renderUI({
   selectInput(
     'ty',
     tags$b('2. Choose a numeric variable for the y-axis'),
     selected = type.num3()[1],
     choices = type.num3())
   
 })
 
 ## scatter plot
 output$p1 = renderPlot({

   ggplot(DF3(), aes(x = DF3()[, input$tx], y = DF3()[, input$ty])) + geom_point(shape = 1) + 
     geom_smooth(method = "lm") + xlab(input$tx) + ylab(input$ty) + theme_minimal()
   })
 
## histogram
 output$hx = renderUI({
   selectInput(
     'hx',
     tags$b('Choose a numeric variable'),
     selected = type.num3()[1], 
     choices = type.num3())
 })
 
output$p2 = renderPlot({
   ggplot(DF3(), aes(x = DF3()[, input$hx])) + 
     geom_histogram(aes(y=..density..),binwidth = input$bin, colour = "black",fill = "white") + 
     geom_density()+
     xlab("") + theme_minimal() + theme(legend.title = element_blank())
   })
 

#source("1lm_server.R", local=TRUE)$value
#****************************************************************************************************************************************************model

output$y = renderUI({
selectInput(
'y',
tags$b('1. Choose one dependent variable (Y), real-valued numeric'),
selected = type.num3()[1],
choices = type.num3()
)
})

DF4 <- reactive({
  df <-DF3()[ ,-which(names(DF3()) %in% c(input$y))]
return(df)
  })

output$x = renderUI({
selectInput(
'x',
tags$b('2. Choose some independent variables (X)'),
selected = names(DF4()),
choices = names(DF4()),
multiple = TRUE
)
})

output$Xdata2 <- DT::renderDT(
head(DF3()), 
options = list(scrollX = TRUE, dom = 't'))
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
validate(need(input$x, "Please choose some independent variable"))
cat(paste0(input$y,' ~ ',paste0(input$x, collapse = " + "), 
  input$conf, 
  input$intercept))
  })

## 4. output results
### 4.2. model
fit = eventReactive(input$B1, {
#validate(need(input$x, "Please choose some independent variable"))
lm(formula(), data = DF3())
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
output$p.lm1 = renderPlot({

x <-data.frame(res=fit()$residuals)
ggplot(x, aes(sample = res)) + 
stat_qq() + 
ggtitle("") + 
xlab("") + 
theme_minimal()  ## add line,
    })

output$p.lm2 = renderPlot({
x <- data.frame(fit=fit()$fitted.values, res=fit()$residuals)
ggplot(x, aes(fit, res))+
geom_point()+
stat_smooth(method="loess")+
geom_hline(yintercept=0, col="red", linetype="dashed")+
xlab("Fitted values")+ylab("Residuals")+
ggtitle("")+theme_minimal()
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

#source("2pr_server.R", local=TRUE)$value
#****************************************************************************************************************************************************pred

newX = reactive({
  inFile = input$newfile
  if (is.null(inFile)){
    x<-LR.new
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
{predict(fit(), newdata = newX())
})

pred.lm <- reactive({
    cbind.data.frame("Predicted Y"=(pred()),newX())
    })

output$pred = DT::renderDT({
pred.lm()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

 output$p.s = renderPlot({
  validate(need((pred.lm()[, input$y]), "This evaluation plot will not show unless dependent variable Y is given in the new data"))
  min = min(c(pred.lm()[, input$y], pred.lm()[, 1]))
  max = max(c(pred.lm()[, input$y], pred.lm()[, 1]))
  ggplot(pred.lm(), aes(x = pred.lm()[, input$y], y = pred.lm()[, 1])) + geom_point(shape = 1) + 
     geom_smooth(method = "lm") + xlab(input$y) + ylab("Prediction") + xlim(min, max)+ ylim(min, max)+ theme_minimal()
   })



observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}