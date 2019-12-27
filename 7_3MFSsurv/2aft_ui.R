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

("Example data: NKI70"),      

h4(tags$b("Step 1. Build the model")),      
p("The Survival Object has been decided in the Data Tab"),  
uiOutput('var'),

radioButtons("intercept", "2. Add or remove intercept/constant term, if you need", ##> intercept or not
     choices = c("Remove intercept/constant" = "-1",
                 "Keep intercept/constant term" = ""),
     selected = ""),
h5("Add interaction term between categorical variables"), 
p('Please input: + var1:var2'), 
tags$textarea(id='conf', " " ), 
hr(),

h4(tags$b("Step 2. Choose Test Method")),      

radioButtons("dist", "Which distribution do you want to fit the survival curves", select=1,
  choiceNames = list(
    HTML("1. Exponential regression model"),
    HTML("2. Weibull regression model"),
    HTML("3. Log-logistic regression model")
    ),
  choiceValues = list("exponential", "weibull", "loglogistic")
  ),


h4(tags$b("Step 3. Check Linear Regression Model")),
tags$style(type='text/css', '#regfit {background-color: rgba(0,0,255,0.10); color: blue;}'),
verbatimTextOutput("regfit", placeholder = TRUE),
p("Note: '-1' in the formula indicates that intercept / constant term has been removed")
),
#tags$style(type='text/css', '#km {background-color: rgba(0,0,255,0.10); color: blue;}'),
#verbatimTextOutput("km", placeholder = TRUE),

),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
 tabPanel("Browse Data",p(br()),
 p("This only shows the first several lines, please check full data in the 1st tab"),
 DT::dataTableOutput("Xdata3")
 ),
 tabPanel("Variables information",p(br()),
 verbatimTextOutput("str3"),
 tags$head(tags$style("#str3 {overflow-y:scroll; max-height: 350px; background: white};"))
 
 )
 ),
 hr(),
 
# #h4(tags$b("Output 2. Model Results")),
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. Estimate and Test Results")),
p(br()),
tabsetPanel(
tabPanel("Life Table",  p(br()),
    verbatimTextOutput("kmt"),
     tags$head(tags$style("#kmt {overflow-y:scroll; max-height: 350px; background: white};"))
     ),
tabPanel("Kaplan-Meier Plot by Group",  p(br()),
    radioButtons("fun2", "Which plot do you want to see?", 
  choiceNames = list(
    HTML("1. Survival Probability"),
    HTML("2. Cumulative Events"),
    HTML("3. Cumulative Hazard")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
    plotOutput("km.p", width = "800px", height = "600px"),
     verbatimTextOutput("kmt1"),
     tags$head(tags$style("#kmt1 {overflow-y:scroll; max-height: 350px; background: white};"))
     ),
tabPanel("Log-Rank Test",  p(br()),
p(tags$b("Log-rank Test Result")),
    verbatimTextOutput("kmlr"),
     tags$head(tags$style("#kmlr {overflow-y:scroll; max-height: 350px; background: white};")),
       HTML("
<b> Explanations </b>
<p>This implements the G-rho family of Harrington and Fleming (1982), with weights on each death of S(t)<sup>rho</sup>, where S is the Kaplan-Meier estimate of survival.</p>
<ul>
<li><b>rho = 0:</b> log-rank or Mantel-Haenszel test
<li><b>rho = 1:</b> Peto & Peto modification of the Gehan-Wilcoxon test.
<li> p < 0.05 indicates the curves are significantly different in the survival probabilities
<li> p >= 0.05 indicates the curves are NOT significantly different in the survival probabilities

</ul>")
     ),

tabPanel("Pairwise Log-Rank Test",  p(br()),

p(tags$b("Pairwise Log-rank Test Result")),
    DT::dataTableOutput("PLR",width = "800px"),
     tags$head(tags$style("#kmlr {overflow-y:scroll; max-height: 350px; background: white};")),
     HTML(
  "<b> Explanations </b>
  <p>This implements the G-rho family of Harrington and Fleming (1982), with weights on each death of S(t)<sup>rho</sup>, where S is the Kaplan-Meier estimate of survival.</p>
  <ul> 
    <li><b>rho = 0:</b> log-rank or Mantel-Haenszel test
    <li><b>rho = 1:</b> Peto & Peto modification of the Gehan-Wilcoxon test.
    <li> <b>Bonferroni</b> correction is a generic but very conservative approach
    <li> <b>Bonferroni-Holm</b> is less conservative and uniformly more powerful than Bonferroni
    <li> <b>False Discovery Rate-BH</b> is more powerful than the others, developed by Benjamini and Hochberg
    <li> <b>False Discovery Rate-BY</b> is more powerful than the others, developed by Benjamini and Yekutieli
    <li> p < 0.05 indicates the curves are significantly different in the survival probabilities
    <li> p >= 0.05 indicates the curves are NOT significantly different in the survival probabilities
  </ul>"
    )
     )
)

)
)