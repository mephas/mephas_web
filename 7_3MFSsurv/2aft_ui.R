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


h4("Example data is upload in Data tab"),      


h4(tags$b("Step 1. Choose independent variables to build the model")),    

p(tags$b("1. Check Surv(time, event), survival object, in the Data Tab")), 

uiOutput('var'),

radioButtons("dist", "3. Choose AFT Model",
  choiceNames = list(
    HTML("1. Log-normal regression model"),
   # HTML("2. Extreme regression model"),
    HTML("2. Weibull regression model"),
    HTML("3. Exponential regression model"),  
    HTML("4. Log-logistic regression model")
    ),
  choiceValues = list("lognormal","weibull", "exponential","loglogistic")
  ),

radioButtons("intercept", "4. (Optional) Keep or remove intercept / constant term", ##> intercept or not
     choices = c("Remove intercept / constant" = "-1",
                 "Keep intercept / constant term" = ""),
     selected = ""),

radioButtons("effect", "5. (Optional) Add random effect term",
     choices = c(
      "None" = "",
      "Strata: identifies stratification variable" = "Strata",
      "Cluster: identifies correlated groups of observations" = "Cluster",
      "Gamma Frailty: allows one to add a simple gamma distributed random effects term" = "Gamma Frailty",
      "Gaussian Frailty: allows one to add a simple Gaussian distributed random effects term" = "Gaussian Frailty"
                 ),
     selected = ""),

uiOutput('fx.c'),


p(tags$b("6. (Optional) Add interaction term between categorical variables")),

p('Please input: + var1:var2'), 
tags$textarea(id='conf', " " ), 
hr(),

h4(tags$b("Step 2. Check AFT Model")),
verbatimTextOutput("aft_form", placeholder = TRUE),
p("'-1' in the formula indicates that intercept / constant term has been removed")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
 tabPanel("Browse",p(br()),
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

tabPanel("Model Estimation", br(),
HTML(
"
<b> Explanations  </b>
<ul>
<li>
</ul>
"
),
verbatimTextOutput("fit")

),

tabPanel("Data Fitting", p(br()),

    p(tags$b("Fitting values and residuals from the existed data")),
    DT::DTOutput("fit.aft")
),

tabPanel("Diagnostics Plot", p(br()),

HTML(
     "
<p><b> Explanations  </b></p>
<b>Martingale residuals</b> against continuous independent variable is a common approach used to detect nonlinearity. For a given continuous covariate, patterns in the plot may suggest that the variable is not properly fit.
Martingale residuals may present any value in the range (-INF, +1):
<ul>
<li>A value of martingale residuals near 1 represents individuals that “died too soon”,
<li>Large negative values correspond to individuals that “lived too long”.
</ul>

<b>Deviance residual</b> is a normalized transform of the martingale residual. These residuals should be roughly symmetrically distributed about zero with a standard deviation of 1.
<ul>
<li>Positive values correspond to individuals that “died too soon” compared to expected survival times.
<li>Negative values correspond to individual that “lived too long”.
<li>Very large or small values are outliers, which are poorly predicted by the model.
</ul>

<b>Cox-Snell residuals</b> are used to check for overall goodness of fit in survival models.
<ul>
<li> Cox-Snell residuals are equal to the -log(survival probability) for each observation
<li> If the model fits the data well, Cox-Snell residuals should behave like a sample from an exponential distribution with a mean of 1
<li> If the residuals act like a sample from a unit exponential distribution, they should lie along the 45-degree diagonal line.
</ul>

The residuals can be found in Data Fitting tab.
"
),

p(tags$b("1. Martingale residuals plot against continuous independent variable")), 
uiOutput('var.mr2'),
plotOutput("mrplot", width = "500px", height = "400px"),

p(tags$b("2. Deviance residuals plot by observational id")),
plotOutput("deplot", width = "500px", height = "400px"),

p(tags$b("3. Cox-Snell residuals plot")),
plotOutput("csplot", width = "500px", height = "400px")

)

)
)
)