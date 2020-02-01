#****************************************************************************************************************************************************aft


sidebarLayout(

sidebarPanel(

tags$head(tags$style("#aft_form {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str3 {overflow-y:scroll; max-height:: 350px; background: white};")),
tags$head(tags$style("#fit {overflow-y:scroll; max-height:: 400px; background: white};")),
#tags$head(tags$style("#fit2 {overflow-y:scroll; height: 400px; background: white};")),
#tags$head(tags$style("#step {overflow-y:scroll;height: 400px; background: white};")),


h4(tags$b("Prepare the Model")),
p("Prepare the data in the previous tab"),
hr(), 

h4(tags$b("Step 1. Choose variables to build the model")),    

p(tags$b("1. Check survival object, Surv(time, event), in the Data Tab")), 

tabsetPanel(
tabPanel("Basic Model", p(br()),
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

p(tags$b("4. (Optional) Add interaction term between categorical variables")),

p('Please input: + var1:var2'), 
tags$textarea(id='conf', " " ), 

radioButtons("intercept", "5. (Optional) Keep or remove intercept / constant term", ##> intercept or not
     choices = c("Remove intercept / constant" = "-1",
                 "Keep intercept / constant term" = ""),
     selected = ""),

p(tags$b("If you want to consider the heterogeneity in the sample, continue with Extending Model tab"))

),

tabPanel("Extending Model", p(br()),

radioButtons("effect", "6. (Optional) Add random effect term (the effect of heterogeneity)",
     choices = c(
      "None" = "",
      "Strata: identifies stratification variable (categorical, such as disease subtype and enrolling institutes)" = "Strata",
      "Cluster: identifies correlated groups of observations (such as multiple events per subject)" = "Cluster"
      #"Gamma Frailty: allows one to add a simple gamma distributed random effects term" = "Gamma Frailty",
      #"Gaussian Frailty: allows one to add a simple Gaussian distributed random effects term" = "Gaussian Frailty"
                 ),
     selected = ""),

uiOutput('fx.c'),
tags$i("In the example of Diabetes data: 'eye' could be used as random effect of strata;
  'id' can be used as random effect variable of cluster. " )
)
),
hr(),

h4(tags$b("Step 2. Check AFT Model")),
p(tags$b("Valid model example: Surv(time, status) ~ X1 + X2")),
p(tags$b("Or, Surv(time1, time2, status) ~ X1 + X2")),
verbatimTextOutput("aft_form", placeholder = TRUE),
p("'-1' in the formula indicates that intercept / constant term has been removed"),
hr(),

h4(tags$b("Step 3. If data and model are ready, click the blue button to generate model results.")),
actionButton("B1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
   tabPanel("Variables information",p(br()),
 verbatimTextOutput("str3")
 ),
tabPanel("First Part of Data", br(),
p("Check full data in Data tab"),
 DT::DTOutput("Xdata3")
 )

 ),
 hr(),
 
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. Model Results")),
p(br()),
tabsetPanel(

tabPanel("Model Estimation", br(),
HTML(
"
<b> Explanations  </b>
<ul>
<li> For each variable, estimated coefficients (Value), statistic for the significance of single variable, and p value are given.
<li> The column marked “z” gives the Wald statistic value. It corresponds to the ratio of each regression coefficient to its standard error (z = coef/se(coef)).The Wald statistic evaluates, whether the beta (β) coefficient of a given variable is statistically significantly different from 0.
<li> The coefficients relate to hazard; a positive coefficient indicates a worse prognosis and a negative coefficient indicates a protective effect of the variable with which it is associated.
<li> exp(Value) = hazard ratio (HR). HR = 1: No effect; HR < 1: Reduction in the hazard; HR > 1: Increase in Hazard
<li> Scale and Log(scale) are the estimated parameters in the error term of AFT model
<li> The log-likelihood is given in the model. When maximum likelihood estimation is used to generate the log-likelihoods, then the closer that the log-likelihood(LL) is to zero, the better is the model fit.
<li> For left-truncated data, the time here is the differences of end-time and start-time
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

<p>The residuals can be found in Data Fitting tab.<p>
<p>Red points are those who 'died soon'; black points are whose who “lived long”<p>

"
),

p(tags$b("1. Martingale residuals plot against continuous independent variable")), 
uiOutput('var.mr2'),
plotly::plotlyOutput("mrplot", width = "80%"),

p(tags$b("2. Deviance residuals plot by observational id")),
plotly::plotlyOutput("deplot", width = "80%"),

p(tags$b("3. Cox-Snell residuals plot")),
plotly::plotlyOutput("csplot", width = "80%")

)

)
)
)