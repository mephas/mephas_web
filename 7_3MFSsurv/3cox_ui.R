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

tags$head(tags$style("#cox_form {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str4 {overflow-y:scroll; height: 350px; background: white};")),
tags$head(tags$style("#fitcx {overflow-y:scroll; height: 400px; background: white};")),
tags$head(tags$style("#fitcx2 {overflow-y:scroll; height: 400px; background: white};")),
#tags$head(tags$style("#step {overflow-y:scroll;height: 400px; background: white};")),


("Example data: NKI70"),      

h4(tags$b("Step 1. Build the Cox model")),      
p("The Survival Object has been decided in the Data Tab"), 

uiOutput('var.cx'),

#radioButtons("intercept.cx", "2. Add or remove intercept/constant term, if you need", ##> intercept or not
#     choices = c("Remove intercept/constant" = "-1",
#                 "Keep intercept/constant term" = ""),
#     selected = ""),

h4(tags$b("Step 2 (Optional). Choose Method for Ties Handling")),      

radioButtons("tie", "Which method do you want to handle ties",
  choiceNames = list(
    
    HTML("1. Efron method: more accurate if there are a large number of ties"),
    HTML("2. Breslow approximation:  the easiest to program and the first option coded for almost all computer routines"),
    HTML("3. Exact partial likelihood method: the Cox partial likelihood is equivalent to that for matched logistic regression")
    ),
  choiceValues = list("efron","breslow","exact")
  ),

h4(tags$b("Step 3 (Optional). Add random effect term")),

radioButtons("effect.cx", "3.1. Choose random effect term type",
     choices = c(
      "None" = "",
      "Strata" = "Strata",
      "Cluster" = "Cluster",
      "Gamma Frailty" = "Gamma Frailty",
      "Gaussian Frailty" = "Gaussian Frailty"
                 ),
     selected = ""),

uiOutput('fx.cx'),


h4(tags$b("Step 4 (Optional). Add interaction term between categorical variables")),

p('Please input: + var1:var2'), 
tags$textarea(id='conf.cx', " " ), 
hr(),

h4(tags$b("Step 5. Check Cox Model")),
verbatimTextOutput("cox_form", placeholder = TRUE),
p("Note: '-1' in the formula indicates that intercept / constant term has been removed")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
 tabPanel("Browse Data",p(br()),
 p("This only shows the first several lines, please check full data in the 1st tab"),
 DT::DTOutput("Xdata4")
 ),
 tabPanel("Variables information",p(br()),
 verbatimTextOutput("str4")
 )
 ),
 hr(),
 
actionButton("B2", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(

tabPanel("Model Estimation", br(),
verbatimTextOutput("fitcx"),
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
    DT::DTOutput("fit.cox")
),

tabPanel("Cox-Snell Plot", p(br()),
    
 plotOutput("csplot.cx", width = "500px", height = "400px")
)

)
)
)