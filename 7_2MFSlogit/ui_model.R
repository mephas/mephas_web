#****************************************************************************************************************************************************model

sidebarLayout(


sidebarPanel(

tags$head(tags$style("#formula {height: 50px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; max-height: 200px; background: white};")),
tags$head(tags$style("#fit1 {overflow-y:scroll; max-height: 500px; background: lavender; color: black;};")),
tags$head(tags$style("#fit2 {overflow-y:scroll; max-height: 500px; background: lavender; color: black;};")),
tags$head(tags$style("#step {overflow-y:scroll; max-height: 500px; background: lavender};")),


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
#p(tags$b("4. (Optional) Add interaction term between categorical variables")), 
#p('Please input: + var1:var2'), 
#tags$textarea(id='conf', " " ), 
uiOutput('conf'),
hr(),
h4(tags$b("Step 2. Check the model")),
tags$b("Valid model example: Y ~ X1 + X2"),
verbatimTextOutput("formula"),
p("'-1' in the formula indicates that intercept / constant term has been removed"),
hr(),

h4(tags$b("Step 3. If data and model are ready, click the blue button to generate model results.")),
p(br()),
actionButton("B1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
tabsetPanel(
	tabPanel("Variables Information", br(),
verbatimTextOutput("str")
),
tabPanel("Part of Data", br(),
p("Check full data in Data tab"),
DT::DTOutput("Xdata2")
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
<li> Output in the left shows estimated coefficients (95% confidence interval), T statistic (t = ) for the significance of single variable, and P value (p = ) are given</li>
<li> Output in the right shows odds ratio = exp(b) and standard error of the original coefficients</li>
<li> T test of each variable and P < 0.05 indicates this variable is statistically significant to the model</li>
<li> Observations mean the number of samples</li>
<li> Akaike Inf. Crit. = AIC = -2 (log likelihood) + 2k; k is the number of variables + constant</li>
<li> If you want the estimates of Odds Ratio, please take exp() on the estimated coefficients (95% confidence interval), and T statistic and P values are the same.</li>
</ul>
"
),

fluidRow(
column(6, htmlOutput("fit1"), br(),
    downloadButton("downloadfit1", "Save into CSV"),
    downloadButton("downloadfit.latex1", "Save LaTex codes")
),
column(6, htmlOutput("fit2"), br(),
    downloadButton("downloadfit2", "Save into CSV"),
    downloadButton("downloadfit.latex2", "Save LaTex codes")
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
    <li> The Akaike Information Criterion (AIC) is used to performs stepwise model selection. </li>
    <li> Model fits are ranked according to their AIC values, and the model with the lowest AIC value is sometime considered the 'best'. </li>
  </ul>
</ul>"
),
    p(tags$b("Model selection suggested by AIC")),
    verbatimTextOutput("step")


    ),

tabPanel("ROC Plot",   br(),

HTML(
"<b> Explanations </b>
<ul> 
<li> ROC curve: receiver operating characteristic curve, is a graphical plot that illustrates the diagnostic ability of a binary classifier system as its discrimination threshold is varied</li>
<li> ROC curve is created by plotting the true positive rate (TPR) against the false positive rate (FPR) at various threshold settings</li>
<li> Sensitivity (also called the true positive rate) measures the proportion of actual positives that are correctly identified as such</li>
<li> Specificity (also called the true negative rate) measures the proportion of actual negatives that are correctly identified as such</li>

</ul>"
),
plotly::plotlyOutput("p.lm"),
DT::DTOutput("sst")
    )

)
)
)