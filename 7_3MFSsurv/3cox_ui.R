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
tags$head(tags$style("#zph {overflow-y:scroll; height: 150px; background: white};")),


h4("Example data is upload in Data tab"),  


h4(tags$b("Step 1. Choose some variables to build the model")),      

p(tags$b("1. Check Surv(time, event), survival object, in the Data Tab")), 

uiOutput('var.cx'),
     
radioButtons("tie", "3. (Optional) Choose Method for Ties Handling",selected="breslow",
  choiceNames = list(
    
    HTML("1. Efron method: more accurate if there are a large number of ties"),
    HTML("2. Breslow approximation: the easiest to program and the first option coded for almost all computer routines"),
    HTML("3. Exact partial likelihood method: the Cox partial likelihood is equivalent to that for matched logistic regression")
    ),
  choiceValues = list("efron","breslow","exact")
  ),

radioButtons("effect.cx", "4. (Optional) Add random effect term",
     choices = c(
      "None" = "",
      "Strata: identifies stratification variable" = "Strata",
      "Cluster: identifies correlated groups of observations" = "Cluster",
      "Gamma Frailty: allows one to add a simple gamma distributed random effects term" = "Gamma Frailty",
      "Gaussian Frailty: allows one to add a simple Gaussian distributed random effects term" = "Gaussian Frailty"
                 ),
     selected = ""),

uiOutput('fx.cx'),


p(tags$b("5 (Optional). Add interaction term between categorical variables")),

p('Please input: + var1:var2'), 
tags$textarea(id='conf.cx', " " ), 
hr(),

h4(tags$b("Step 2. Check Cox Model")),
verbatimTextOutput("cox_form", placeholder = TRUE),
p("'-1' in the formula indicates that intercept / constant term has been removed")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
 tabPanel("Browse",p(br()),
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
HTML(
"
<b> Explanations  </b>
<ul>
<li> For each variable, estimated coefficients (coef), statistic for the significance of single variable, and P value are given.
<li> The column marked “z” gives the Wald statistic value. It corresponds to the ratio of each regression coefficient to its standard error (z = coef/se(coef)).The Wald statistic evaluates, whether the beta (β) coefficient of a given variable is statistically significantly different from 0.
<li> The coefficients relate to hazard; a positive coefficient indicates a worse prognosis and a negative coefficient indicates a protective effect of the variable with which it is associated.
<li> exp(coef) = hazard ratio (HR). HR = 1: No effect; HR < 1: Reduction in the hazard; HR > 1: Increase in Hazard
<li> The output also gives upper and lower 95% confidence intervals for the hazard ratio (exp(coef)), 
<li> The likelihood-ratio test, Wald test, and score logrank statistics give global statistical significance of the model. These three methods are asymptotically equivalent. For large enough N, they will give similar results. For small N, they may differ somewhat. The Likelihood ratio test has better behavior for small sample sizes, so it is generally preferred.
</ul>
"
),
verbatimTextOutput("fitcx")

),

tabPanel("Data Fitting", p(br()),
    p(tags$b("Fitting values and residuals from the existed data")),
    DT::DTOutput("fit.cox")
),

tabPanel("Survival Curve", p(br()),
  HTML(
     "
<b> Explanations  </b>
<ul>
<li> this plot is to present expected survival curves calculated based on Cox model separately for subpopulations / strata
<li> If there is no strata() component then only a single curve will be plotted - average for the whole population
</ul>
"
),
p(tags$b("The adjusted survival curves from Cox regression")),
 plotOutput("splot", width = "80%")

),

tabPanel("Proportional Hazards Test", br(),

HTML(
"
<b> Explanations  </b>
<ul>
<li> Schoenfeld residuals are used to check the proportional hazards assumption
<li> Schoenfeld residuals are independent of time. A plot that shows a non-random pattern against time is evidence of violation of the PH assumption
<li> If the test is not statistically significant (p>0.05) for each of the independent variable, we can assume the proportional hazards
</ul>
"
),
numericInput("num", HTML("Choose N'th variable"), value = 1, min = 1, step=1),

plotOutput("zphplot", width = "80%"),

DT::DTOutput("zph")



),



tabPanel("Diagnostic Plot", p(br()),
 
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

uiOutput('var.mr'),
plotOutput("diaplot1", width = "80%"),

#p(tags$b("2. Martingale residuals plot against observation id")), 
# plotOutput("diaplot1.2", width = "80%"),

 p(tags$b("2. Deviance residuals plot by observational id")),
 plotOutput("diaplot2", width = "80%"),

 p(tags$b("3. Cox-Snell residuals plot")),
 plotOutput("csplot.cx", width = "80%")
)

)
)
)