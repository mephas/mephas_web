##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Linear regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(

sidebarPanel(

tags$head(tags$style("#aft_form {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str3 {overflow-y:scroll; height: 350px; background: white};")),
tags$head(tags$style("#fit {overflow-y:scroll; height: 400px; background: white};")),
#tags$head(tags$style("#fit2 {overflow-y:scroll; height: 400px; background: white};")),
#tags$head(tags$style("#step {overflow-y:scroll;height: 400px; background: white};")),


("Example data: NKI70"),      

h4(tags$b("Step 1. Build the AFT model")),      
p("The Survival Object has been decided in the Data Tab"), 

uiOutput('var'),

radioButtons("intercept", "2. Add or remove intercept/constant term, if you need", ##> intercept or not
     choices = c("Remove intercept/constant" = "-1",
                 "Keep intercept/constant term" = ""),
     selected = ""),

h4(tags$b("Step 2. Choose AFT Model")),      

radioButtons("dist", "Which distribution do you want to fit the survival curves",
  choiceNames = list(
    
    HTML("1. Weibull regression model"),
    HTML("2. Exponential regression model"),
    HTML("3. Log-normal regression model"),
    HTML("4. Log-logistic regression model")
    ),
  choiceValues = list("weibull", "exponential", "lognormal", "loglogistic")
  ),

h4(tags$b("Step 3 (Optional). Add random effect term")),

radioButtons("effect", "3.1. Choose random effect term type",
     choices = c(
      "None" = "",
      "Strata" = "Strata",
      "Cluster" = "Cluster",
      "Gamma Frailty" = "Gamma Frailty",
      "Gaussian Frailty" = "Gaussian Frailty"
                 ),
     selected = ""),

uiOutput('fx.c'),


h4(tags$b("Step 4 (Optional). Add interaction term between categorical variables")),

p('Please input: + var1:var2'), 
tags$textarea(id='conf', " " ), 
hr(),

h4(tags$b("Step 5. Check AFT Model")),
verbatimTextOutput("aft_form", placeholder = TRUE),
p("Note: '-1' in the formula indicates that intercept / constant term has been removed")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
 tabPanel("Browse Data",p(br()),
 p("This only shows the first several lines, please check full data in the 1st tab"),
 DT::DTOutput("Xdata3")
 ),
 tabPanel("Variables information",p(br()),
 verbatimTextOutput("str3")
 )
 ),
 hr(),
 
actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(

tabPanel("Model Estimation", 
verbatimTextOutput("fit"),
HTML(
"
<b> Explanations  </b>
<ul>
<li> For each variable, estimated coefficients (95% confidence interval), T statistic for the significance of single variable, and P value are given.
<li> p < 0.05 indicates this variable is statistical significant to the model
<li> Observations: the number of samples
<li> Akaike Inf. Crit. = AIC = -2 (log likelihood) + 2k; k is the number of variables + constant
<li> Table in the right shows OR; OR= exp(coefficients in the left)
</ul>
"
)
),

tabPanel("Fitting", p(br()),
    p(tags$b("Fitting values and residuals from the existed data")),
    DT::DTOutput("fit.aft")
),

tabPanel("Cox-Snell Plot", p(br()),
    
 plotOutput("csplot", width = "500px", height = "400px")
)

)
)
)