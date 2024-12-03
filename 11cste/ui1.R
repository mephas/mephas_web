#****************************************************************************************************************************************************

sidebarLayout(

##########----------##########----------##########

sidebarPanel(

h3("Data Preparation"),
HTML("Data structure: 
   <ul>
<li>Outcome: a binary variable valued 1/0</li>
<li>Treatment: a binary variable valued 1/0 to indicate treatment/control</li>
<li>Covariate: single or multiple variables</li>
</ul>"),

h3("Model Estimation"),

radioGroupButtons(
   inputId = "upload",
   label = h4("Use example data or upload user data"),
   choices = list("Example data"="A","Upload new data"="B"),
   justified = TRUE,
   status="primary",
   checkIcon = list(
      yes = icon("ok", 
    lib = "glyphicon"))
),
wellPanel(
# prettySwitch(
#    inputId = "upload",
#    label = h4("I need to upload user data"),
#    value = FALSE,
#    status = "primary",
#    fill=TRUE
#    ),
conditionalPanel(condition="input.upload=='A'",   
prettyRadioButtons(
   inputId = "edata",
   label =  NULL,
   choices =  list(
    "Data1: binary outcome" = "data1"),
   selected = "data1",
    icon = icon("database"),
    status = "primary"
)),
conditionalPanel(condition="input.upload=='B'", 
# h4("Upload new data"),        
   p("The new data will cover the example data."),
   p("Please refer to the format of example data."),
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
)),
hr(),

h4("Select variables"),              
tags$b("Whether to do variable selection"),
   # uiOutput("ztype"),
   radioGroupButtons(
   inputId = "clamb",
   label = NULL,
   choices = list("Without selection"="FALSE", "Variable selection"="TRUE"),
   selected="FALSE",
   status = "primary",
   justified = TRUE,
    checkIcon = list(
      yes = icon("ok", 
    lib = "glyphicon"))
),
tags$b("Treatment (choose one binary variable)"),
uiOutput("z1"),
tags$b("Outcome (choose one binary variable)"),
uiOutput("y1"),
tags$b("Covariates (choose one or more numerical variables)"),
uiOutput("x1"),
awesomeCheckbox(
   inputId = "scale",
   label = tags$b("I need standardization of covariates (standard scaling)"), 
   value = FALSE,
   status = "primary"),
conditionalPanel("input.clamb=='TRUE'",
   tags$b("Set the maximum value of tuning parameters"),
   uiOutput("maxtune"),
   tags$b("Set the increment of sequence for the tuning parameters"),
   uiOutput("seqtune"),
# actionButton("B4", HTML('Estimate the optimal model'), 
#           class =  "btn-primary",
#           icon  = icon("chart-column"))
# uiOutput("kh")
),
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


# materialSwitch(
# inputId = "clamb",
# label = h4("I need variable selection"), 
# value = FALSE,
# status = "primary"),
# uiOutput("scale"),

actionButton("B", HTML('Step 1. Model estimation'), 
             class =  "btn-primary",
             icon  = icon("chart-column")),
hr(),

conditionalPanel(condition="input.BB",
h3("Model Prediction"),
radioGroupButtons(
   inputId = "uploadprd",
   label = h4("Use example data or upload user data"),
   choices = list("Example data"="A","Upload new data"="B"),
   justified = TRUE,
   status="primary",
   checkIcon = list(
      yes = icon("ok", 
    lib = "glyphicon"))
),
# conditionalPanel(condition="input.prdct=='A'",
# materialSwitch(
#    inputId = "prdct",
#    label = h4("I have new subjects' data"),
#    value = FALSE,
#    status = "primary"
#    )),
wellPanel(
conditionalPanel(condition="input.uploadprd=='A'",
prettyRadioButtons(
inputId = "edata3",
label =  h4("Example of predictive covariates"),
choices =  list(
 "Data3: 20 covariates" = "data3"),
selected = "data3",
 icon = icon("database"),
 status = "primary"
)),

# materialSwitch(
#    inputId = "uploadprd",
#    label = h4("Upload predictive covariates data"),
#    value = FALSE,
#    status = "primary"
#    ),
conditionalPanel(condition="input.uploadprd=='B'", 
   h4("Upload user predictive covariates"),
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
)),
actionButton("B3", HTML('Step 3. Predict CSTE for New data'), 
             class =  "btn-primary",
             icon  = icon("chart-column")),
p("Results are shown in the second panel")
)
),

##########----------##########----------##########
mainPanel(
h3("Data preview"),
materialSwitch(
   inputId = "pview",
   label = h5("Show/Hide data preview"),
   value = TRUE,
   status = "primary"
   ),
conditionalPanel(condition="input.pview",
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
   h4("Estimated coefficients for variables"),
   wellPanel(
      withSpinner(DTOutput("res.table"), type = 4, color = "#3498db", size = 1, caption = "Estimating, please wait..."),
      conditionalPanel("input.clamb",
      DTOutput("res.bic"),
      p("If no results, you may need to decrease the tuning parameter.")
      )),

   # actionButton("BB", HTML('Step 2. Estimate the CSTE curve'), 
   #           class =  "btn-primary",
   #           icon  = icon("chart-column")), 
   
   h4("Estimated CSTE with confidence bounds"),
   conditionalPanel("input.B",
   uiOutput("actionButtonBplot2"),
   wellPanel(
      materialSwitch(
      inputId = "tabop",
      label = h5("Advanced options for bounds (optional settings)"),
      value = FALSE,
      status = "primary"
      ),
      conditionalPanel(condition="input.tabop",
      tags$b("Kernel bandwidth for B-spline method in the confidence intervals, which controls the smoothness of the curve)"),
      # helpText(HTML("0 indicates to use the estimated kernel bandwidth")),
      uiOutput("kh"),
      tags$b("Significant level for confidence interval"),
      uiOutput("alpha"),
      p("After setting, please re-click the button of Step 2")),
      DTOutput("res.table12")),
 
   h4("CSTE curve"),
   conditionalPanel("input.BB",
   
   wellPanel(
    
    tabsetPanel(
    tabPanel("Static curve",
      
      materialSwitch(
      inputId = "figop",
      label = h5("Figure options for the axes of coordinates (optional settings)"),
      value = FALSE,
      status = "primary"
      ),
      uiOutput("actionButtonBplot1"),
      conditionalPanel(condition="input.figop",
      tags$b("Reset the range for y-axis"),
      uiOutput("ylim1"),
      tags$b("Reset the range for x-axis (if same values are taken, the default range is used)"),
      uiOutput("xlim1")),
      # p("Click the button to create plot after model is built."),
      # actionButton("Bplot1", HTML('Step 2. Show/Update the estimated CSTE curve'), 
      #           class =  "btn-primary",
      #           icon  = icon("chart-column")),
      plotOutput("res.plot", click = "plot_click"),
      downloadButton("downloadPlot1", "Download Plot as PNG"),
      textOutput("click_info")),
    tabPanel("Dynamic curve",
      plotlyOutput("makeplot"))
      )
      ))
   )

   ),
#   tabPanel(
#    "CSTE Curve for a single variable", br(),
#    h4("CSTE curve for a single variable"),
#    conditionalPanel("input.Bplot1",
#    tags$b("Choose a single variable"),
#    uiOutput("x1a"),
#    tags$b("Set the range for y-axis"),
#    uiOutput("ylim1a"),
#    tags$b("Set the range for x-axis"),
#    uiOutput("xlim1a"),
#    actionButton("Bplot1a", HTML('Step 2. Show/Update the estimated CSTE curve'), 
#              class =  "btn-primary",
#              icon  = icon("chart-column")),
#    wellPanel(
#       plotOutput("res.plota", click = "plot_clicka"),
#       textOutput("click_infoa"),
#       DTOutput("res.table12a")
#       )
# )),

  tabPanel(
   "Predicted CSTE Curve and Results", br(),
   p("Click 'Step 3.' to start prediction "),
   conditionalPanel(condition="input.B3",
   h4("Predicted CSTE curve"),
    
   wellPanel(

   tabsetPanel(
    tabPanel("Static curve",
      materialSwitch(
      inputId = "figop_pred",
      label = h5("Figure options (optional settings)"),
      value = FALSE,
      status = "primary"
      ),
      actionButton("Bplot1p", HTML('Show/Update Predicted CSTE curve'), 
             class =  "btn-secondary",
             icon  = icon("chart-column")),
      conditionalPanel(condition="input.figop_pred",
      tags$b("Reset the range for y-axis"),
      uiOutput("ylim12"),
      tags$b("Reset the range for x-axis"),
      uiOutput("xlim12")),
      
      plotOutput("res.plotp",click = "plot_click2"),
      downloadButton("downloadPlot2", "Download Plot as PNG"),
      textOutput("click_info2")),
    tabPanel("Dynamic curve",
      plotlyOutput("makeplotp"))
    ),

      h4("The predicted location of x-axis for new subject"),
      DTOutput("res.tablep")
      )
)
)
##########----------##########----------##########

)
)
)
