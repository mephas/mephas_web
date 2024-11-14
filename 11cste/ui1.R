#****************************************************************************************************************************************************

sidebarLayout(

##########----------##########----------##########

sidebarPanel(

h3("Data Preparation"),
HTML("Data requirements: 
   <ul>
<li>Outcome: single binary variable</li>
<li>2-arm treatment: single binary variable</li>
<li>Covariate: single or multiple variables</li>
</ul>"),

h3("Model Estimation"),

prettyRadioButtons(
   inputId = "edata",
   label =  h4("Example data"),
   choices =  list(
    "Data1: binary outcome" = "data1"),
   selected = "data1",
    icon = icon("database"),
    status = "primary"
),

# tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote="quote")
materialSwitch(
   inputId = "upload",
   label = h4("I need to upload user data"),
   value = FALSE,
   status = "primary"
   ),
conditionalPanel(condition="input.upload",         
   tags$b("Upload user data"),
   p("The new data will cover the example data."),
   p("Please refer to the example data's format."),
   uiOutput("file"),
   
   p(tags$b("Show 1st row as column names?")), 
   uiOutput("header"),
   p(tags$b("Use 1st column as row names? (No duplicates)")), 
   uiOutput("col"),
   uiOutput("sep"),
   uiOutput("quote"),
   awesomeCheckbox(
      inputId = "rmdt",
      label = tags$b("Remove upload data"), 
      value = FALSE,
      status = "primary")
   # p("Correct separator and quote ensure the successful data input")
),
hr(),

h4("Select variables"),              
tags$b("Treatment (choose one binary variable)"),
uiOutput("z1"),
tags$b("Outcome (choose one binary variable)"),
uiOutput("y1"),
tags$b("Covariates (choose one or more numerical variables)"),
uiOutput("x1"),
awesomeCheckbox(
   inputId = "scale",
   label = tags$b("I need to standardize covariates"), 
   value = FALSE,
   status = "primary"),


materialSwitch(
   inputId = "advance",
   label = h4("Advanced settings"),
   value = FALSE,
   status = "primary"
   ),
conditionalPanel(condition="input.advance",
# tags$b("Significant level for confidence interval"),
# tags$b("Tuning parameter for variable selection"),
# helpText(HTML("0 indicates no variable selection; finding the optimal tuning parameter is allowed in the bottom.")),
# uiOutput("lambda"),
tags$b("Number of knots for B-spline method"),
uiOutput("knot")
),
   # uiOutput("scale"),
   # conditionalPanel("input.knot!==1",
   #                HTML("Set kernel bands"),
   # uiOutput("kh")),


materialSwitch(
inputId = "clamb",
label = h4("I need variable selection"), 
value = FALSE,
status = "primary"),
# uiOutput("scale"),
conditionalPanel("input.clamb",
   tags$b("Set the maximum value of tuning parameters"),
   uiOutput("maxtune"),
   tags$b("Set the increment of sequence for the tuning parameters"),
   uiOutput("seqtune"),
# actionButton("B4", HTML('Estimate the optimal model'), 
#           class =  "btn-primary",
#           icon  = icon("chart-column"))
# uiOutput("kh")
),
actionButton("B", HTML('Step 1. Model estimation'), 
             class =  "btn-primary",
             icon  = icon("chart-column")),
hr(),

conditionalPanel(condition="input.Bplot1",
h3("Model Prediction"),
materialSwitch(
   inputId = "prdct",
   label = h4("Model prediction after model estimation"),
   value = FALSE,
   status = "primary"
   ),
conditionalPanel(condition="input.prdct",
prettyRadioButtons(
inputId = "edata3",
label =  h4("Example predictive covariates"),
choices =  list(
 "Data3: 20 covariates" = "data3"),
selected = "data3",
 icon = icon("database"),
 status = "primary"
),

materialSwitch(
   inputId = "uploadprd",
   label = h4("Upload predictive covariates data"),
   value = FALSE,
   status = "primary"
   ),
conditionalPanel(condition="input.uploadprd", 
   p(("The new data will cover the example data.")),
   p(("Please refer to the analytical data's format.")),
   uiOutput("filep"),
   p(tags$b("Show 1st row as column names?")), 
   uiOutput("headerp"),
   p(tags$b("Use 1st column as row names? (No duplicates)")), 
   uiOutput("colp"),
   uiOutput("sepp"),
   uiOutput("quotep"),     
   awesomeCheckbox(
      inputId = "prmdt",
      label = tags$b("Remove upload data"), 
      value = FALSE,
      status = "primary")
   # p("Correct separator and quote ensure the successful data input")
),
actionButton("B3", HTML('Step 3. Predict CSTE for New data'), 
             class =  "btn-primary",
             icon  = icon("chart-column"))
))
),

##########----------##########----------##########
mainPanel(
conditionalPanel(condition="input.pview",
h3("Data preview"),
materialSwitch(
   inputId = "pview",
   label = h4("Show/Hide data preview"),
   value = TRUE,
   status = "primary"
   ),
tabsetPanel(
   tabPanel(
   "Analytical data", br(), DTOutput("data.pre")
   ),
   tabPanel(
   "Predictive covariates", br(), DTOutput("data.prep")
   )
)),    

hr(),
h3("Results"),
HTML(" 
<ul>
<li>CSTE Curve: the estimated CSTE curve</li>
<li>Predicted CSTE Curve: the CSTE curve predicted based on the new patients' data</li>
</ul>
"),

tabsetPanel(
   tabPanel(
   "CSTE Curve with Estimates", br(), 
   wellPanel(
      h4("CSTE Estimates"),
      withSpinner(DTOutput("res.table"), type=4),
      conditionalPanel("input.clamb",
      DTOutput("res.bic")
      ),

   h4("CSTE curve"),
   conditionalPanel("input.B",
   
   tags$b("Kernel bandwidth for B-spline method in the confidence intervals"),
   # helpText(HTML("0 indicates to use the estimated kernel bandwidth")),
   uiOutput("kh"),
   tags$b("Significant level for confidence interval"),
   uiOutput("alpha"),
   tags$b("Set the range for y-axis"),
   uiOutput("ylim1"),
   tags$b("Set the range for x-axis"),
   uiOutput("xlim1"),
   actionButton("Bplot1", HTML('Step 2. Show/Update the estimated CSTE curve'), 
             class =  "btn-primary",
             icon  = icon("chart-column")),
   wellPanel(
      plotOutput("res.plot", click = "plot_click"),
      textOutput("click_info"),
      DTOutput("res.table12"))

   ))),
  tabPanel(
   "CSTE Curve for a single variable", br(),
   h4("CSTE curve for a single variable"),
   conditionalPanel("input.Bplot1",
   tags$b("Choose a single variable"),
   uiOutput("x1a"),
   tags$b("Set the range for y-axis"),
   uiOutput("ylim1a"),
   tags$b("Set the range for x-axis"),
   uiOutput("xlim1a"),
   actionButton("Bplot1a", HTML('Step 2. Show/Update the estimated CSTE curve'), 
             class =  "btn-primary",
             icon  = icon("chart-column")),
   wellPanel(
      plotOutput("res.plota", click = "plot_clicka"),
      textOutput("click_infoa"),
      DTOutput("res.table12a")
      )
)),

  tabPanel(
   "Predicted CSTE Curve and Results", br(),

   conditionalPanel(condition="input.B3",
   h4("Predicted CSTE curve"),
   tags$b("Set the range for y-axis"),
   uiOutput("ylim12"),
   tags$b("Set the range for x-axis"),
   uiOutput("xlim12"),
   actionButton("B32", HTML('Step 4. Show/Update Predicted CSTE curve'), 
             class =  "btn-primary",
             icon  = icon("chart-column")), 
   wellPanel(
      plotOutput("res.plotp",click = "plot_click2"),
      textOutput("click_info2") 
           ),
   wellPanel(
      h4("The predicted location of x-axis for new subject"),
      DTOutput("res.tablep")
      )
)
)
##########----------##########----------##########

)
)
)
