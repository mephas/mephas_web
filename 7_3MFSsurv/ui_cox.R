#****************************************************************************************************************************************************cox-pred

sidebarLayout(

sidebarPanel(

tags$head(tags$style("#cox_form {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str4 {overflow-y:scroll; max-height:: 350px; background: white};")),
tags$head(tags$style("#fitcx {overflow-y:scroll; max-height:: 400px; background: white};")),
tags$head(tags$style("#fitcx2 {overflow-y:scroll; max-height:: 400px; background: white};")),
tags$head(tags$style("#zph {overflow-y:scroll; max-height:: 150px; background: white};")),


h4(tags$b("Prepare the Model")),
p("Prepare the data in the Data tab"),
hr(),       

h4(tags$b("Step 1. Choose variables to build the model")),      

p(tags$b("1. Check Surv(time, event), survival object, in the Data Tab")), 

tabsetPanel(
tabPanel("Basic Model", p(br()),
uiOutput('var.cx'),
p(br()),
p(tags$b("3 (Optional). Add interaction term between categorical variables")),

p('Please input: + var1:var2'), 
tags$textarea(id='conf.cx', " " ), 

p(tags$b("If you want to consider the heterogeneity in the sample, continue with Extending Model tab"))
  ),

tabPanel("Extending Model", p(br()),
radioButtons("tie", "4. (Optional) Choose Method for Ties Handling",selected="breslow",
  choiceNames = list(
    
    HTML("1. Efron method: more accurate if there are a large number of ties"),
    HTML("2. Breslow approximation: the easiest to program and the first option coded for almost all computer routines"),
    HTML("3. Exact partial likelihood method: the Cox partial likelihood is equivalent to that for matched logistic regression")
    ),
  choiceValues = list("efron","breslow","exact")
  ),

radioButtons("effect.cx", "5. (Optional) Add random effect term (the effect of heterogeneity)",
     choices = c(
      "None" = "",
      "Strata: identifies stratification variable (categorical, such as disease subtype and enrolling institutes)" = "Strata",
      "Cluster: identifies correlated groups of observations (such as multiple events per subject)" = "Cluster",
      "Gamma Frailty: allows one to add a simple gamma distributed random effects term " = "Gamma Frailty",
      "Gaussian Frailty: allows one to add a simple Gaussian distributed random effects term" = "Gaussian Frailty"
                 ),
     selected = ""),
uiOutput('fx.cx'),
p("Frailty: individuals have different frailties, and those who most frail will die earlier than others. 
  Frailty model estimates the relative risk within the random effect variable"),

p("Cluster model is also called marginal model. It estimates the population averaged relative risk due to the independent variable."),

tags$i("In the example of Diabetes data: 'eye' could be used as random effect of strata;
  'id' can be used as random effect variable of cluster. " )
  )
  ),

hr(),

h4(tags$b("Step 2. Check Cox Model")),
p(tags$b("Valid model example: Surv(time, status) ~ X1 + X2")),
p(tags$b("Or, Surv(time1, time2, status) ~ X1 + X2")),

verbatimTextOutput("cox_form", placeholder = TRUE),
hr(),

h4(tags$b("Step 3. If data and model are ready, click the blue button to generate model results.")),
actionButton("B2", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
 tabPanel("Variables information",p(br()),
 verbatimTextOutput("str4")
 ),
tabPanel("Part of Data", br(),
p("Check full data in Data tab"),
 DT::DTOutput("Xdata4")
 )

 ),
 hr(),
 
#actionButton("B2", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. Model Results")),

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
<li> The likelihood-ratio test, Wald test, and score log-rank statistics give global statistical significance of the model. These three methods are asymptotically equivalent. For large enough N, they will give similar results. For small N, they may differ somewhat. The Likelihood ratio test has better behavior for small sample sizes, so it is generally preferred.
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

<p>The residuals can be found in Data Fitting tab.<p>
<p>Red points are those who 'died soon'; black points are whose who “lived long”<p>
"
),

p(tags$b("1. Martingale residuals plot against continuous independent variable")), 

uiOutput('var.mr'),
plotly::plotlyOutput("diaplot1", width = "80%"),

#p(tags$b("2. Martingale residuals plot against observation id")), 
# plotOutput("diaplot1.2", width = "80%"),

 p(tags$b("2. Deviance residuals plot by observational id")),
 plotly::plotlyOutput("diaplot2", width = "80%"),

 p(tags$b("3. Cox-Snell residuals plot")),
 plotly::plotlyOutput("csplot.cx", width = "80%")
)

)
)
)