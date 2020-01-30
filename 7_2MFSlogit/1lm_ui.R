#****************************************************************************************************************************************************model

sidebarLayout(


sidebarPanel(

tags$head(tags$style("#formula {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; height: 350px; background: white};")),
tags$head(tags$style("#fit {overflow-y:scroll; height: 400px; background: white};")),
tags$head(tags$style("#fit2 {overflow-y:scroll; height: 400px; background: white};")),
tags$head(tags$style("#step {overflow-y:scroll; height: 400px; background: white};")),


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
verbatimTextOutput("formula"),
p("'-1' in the formula indicates that intercept / constant term has been removed"),
hr(),

h4(tags$b("Step 3. If data and model are ready, click the blue button to generate model results.")),
actionButton("B1", h4(tags$b("Run model >>")), class = "btn btn-primary")
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
<li> Model fits are ranked according to their AIC values, and the model with the lowest AIC value is sometime considered the ‘best’. 
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
plotly::plotlyOutput("p.lm", width = "80%"),
DT::DTOutput("sst")
    )

)
)
)