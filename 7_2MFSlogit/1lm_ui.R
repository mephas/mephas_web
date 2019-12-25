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

h4("Example data: Birth weight"),      

h4(tags$b("Step 1. Choose variables to build the model")),      

uiOutput('y'),    
uiOutput('x'),
#uiOutput('fx'),

radioButtons("intercept", "3. Add or remove intercept/constant term, if you need", ##> intercept or not
     choices = c("Remove intercept/constant" = "-1",
                 "Keep intercept/constant term" = ""),
     selected = ""),
h5("Add interaction term between categorical variables"), 
p('Please input: + var1:var2'), 
tags$textarea(id='conf', " " ), 
hr(),
#actionButton("F", "Create formula", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
h4(tags$b("Step 2. Check Linear Regression Model")),
tags$style(type='text/css', '#formula {background-color: rgba(0,0,255,0.10); color: blue;}'),
verbatimTextOutput("formula", placeholder = TRUE),
p("Note: '-1' in the formula indicates that intercept / constant term has been removed")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),

p(tags$b("1. First lines of data")),
p(" Please check full data in the 1st tab"),
DT::dataTableOutput("Xdata2"),

p(tags$b("2. Variables information")),
verbatimTextOutput("str"),

hr(),

#h4(tags$b("Output 2. Model Results")),
actionButton("B1", h4(tags$b("Output 2. Click to Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(

tabPanel("Model Estimation", 

    fluidRow(
    column(6, htmlOutput("fit")
      
    ),
    column(6, htmlOutput("fit2")
    )
  ),
HTML(
"
<b> Explanations  </b>
<ul>
<li> For each variable, estimated coefficients (95% confidence interval), T statistic for the significance of single variable, and P value are given.
<li> p < 0.05 indicates this variable is statistical significant to the model
<li> Observations: the number of samples
<li> Akaike Inf. Crit. = AIC = -2 (log likelihood) + 2k; k is the number of variables + constant
<li> Table in the right is the OR = exp(coefficients in the left)
</ul>
"
)
),
tabPanel("AIC-based Selection", p(br()),
    p(tags$b("3. Model selection process suggested by AIC")),
    verbatimTextOutput("step"),

            HTML(
    "<b> Explanations </b>
  <ul> 
    <li> The Akaike Information Criterion (AIC) is a way of selecting a model from a set of models. When model fits are ranked according to their AIC values, the model with the lowest AIC value is sometime considered the ‘best’. 
  </ul>"
  )
    ),

tabPanel("ROC Plot",  p(br()),
    plotOutput("p.lm", width = "500px", height = "400px")
    ),

tabPanel("Sensitivity and Specificity",  p(br()),
     DT::dataTableOutput("sst"),
    downloadButton("download111", "Download Results")

    ),

tabPanel("Fitting", p(br()),

    p(tags$b("Fitting values and residuals from the existed data")),
    DT::dataTableOutput("fitdt0"),
    downloadButton("download11", "Download Results")
)

)
)
)