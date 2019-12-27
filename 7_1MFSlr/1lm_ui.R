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

tags$head(tags$style("#formula {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#fit {overflow-y:scroll; max-height: 400px; background: white};")),
tags$head(tags$style("#step {overflow-y:scroll; max-height: 400px; background: white};")),


h4("Example data: Birth weight"),      

h4(tags$b("Step 1. Choose variables to build the model")),      

uiOutput('y'),    
uiOutput('x'),
#uiOutput('fx'),

radioButtons("intercept", "3. Add or remove intercept/constant term, if you need", ##> intercept or not
     choices = c("Remove intercept/constant" = "-1",
                 "Keep intercept/constant term" = ""),
     selected = ""),
p(tags$b("4. Add interaction term between categorical variables")), 
p('Please input: + var1:var2'), 
tags$textarea(id='conf', " " ), 
hr(),
h4(tags$b("Step 2. Check Linear Regression Model")),
verbatimTextOutput("formula"),
p("Note: '-1' in the formula indicates that intercept / constant term has been removed")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
tabsetPanel(
tabPanel("Browse Data",p(br()),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::dataTableOutput("Xdata2")
),
tabPanel("Variables information",p(br()),
verbatimTextOutput("str")

)
),
hr(),

#h4(tags$b("Output 2. Model Results")),
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
<li> P < 0.05 indicates this variable is statistical significant to the model
<li> Observations: the number of samples
<li> R-squared is a goodness-of-fit measure for linear regression models, and indicates the percentage of the variance in the dependent variable that the independent variables explain collectively.
<li> Adjusted R-squared is used to compare the goodness-of-fit for regression models that contain differing numbers of independent variables.
<li> F statistic ( F- Test for overall significance in Regression ) judges on multiple coefficients taken together at the same time. F=(R^2/(k-1))/(1-R^2)/(n-k); n is sample size; k is number of variable + constant term
</ul>
"
)

    ),

tabPanel("ANOVA", p(br()),
    p(tags$b("ANOVA Table")),  
    DT::dataTableOutput("anova", width="600px"),
    HTML(
    "<b> Explanations </b>
  <ul> 
    <li> DF<sub>Factor</sub> = [number of factor group categories] -1
    <li> DF<sub>Residuals</sub> = [number of sample values] - [number of factor group categories]
    <li> MS = SS/DF
    <li> F = MS<sub>Factor</sub> / MS<sub>Residuals</sub> 
    <li> P Value < 0.05, then the variable is significant to the model. (Accept alternative hypothesis)
  </ul>"
    )),

tabPanel("AIC-based Selection", p(br()),
    p(tags$b("Model selection suggested by AIC")),
    verbatimTextOutput("step"),

        HTML(
    "<b> Explanations </b>
  <ul> 
    <li> The Akaike Information Criterion (AIC) is a way of selecting a model from a set of models. When model fits are ranked according to their AIC values, the model with the lowest AIC value is sometime considered the ‘best’. 
  </ul>"
    )
    ),

tabPanel("Diagnostics Plot",  p(br()),

plotly::plotlyOutput("p.lm1", width = "500px", height = "300px"),
plotly::plotlyOutput("p.lm2", width = "500px", height = "300px"),

   HTML(
    "<b> Explanations </b>
  <ul> 
    <li> Residuals vs Fitting plot finds the outliers
    <li> QQ Plot of the Residuals checks the normality of residuals

    </ul>"
    )
    ),

tabPanel("Fitting", p(br()),

    p(tags$b("Fitting values and residuals from the existed data")),
    DT::dataTableOutput("fitdt0")
)

)
)
)