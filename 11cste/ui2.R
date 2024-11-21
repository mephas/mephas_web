#****************************************************************************************************************************************************

sidebarLayout(

##########----------##########----------##########

sidebarPanel(

h3("Data Preparation"),
HTML("Data structure: 
   <ul>
<li>Outcome: a continuous variable of time</li>
<li>Censoring indicator: a binary variable valued 1/0 to indicate event/censoring</li>
<li>Treatments: single or multiple dummy binary variables</li>
<li>Covariate: single variable of biomarker</li>
</ul>"),

h3("Model Estimation"),
radioGroupButtons(
   inputId = "upload_sv",
   label = h4("Use example data or upload user data"),
   choices = list("Example data"="A","Upload new data"="B"),
   justified = TRUE,
   status="primary",
   checkIcon = list(
      yes = icon("ok", 
    lib = "glyphicon"))
),
wellPanel(
conditionalPanel(condition="input.upload_sv=='A'",   
prettyRadioButtons(
   inputId = "edata2",
   label =  NULL,
   choices =  list(
    "Data2: time-to-event outcome " = "data2"),
   selected = "data2",
    icon = icon("database"),
    status = "primary"
)),

# materialSwitch(
#    inputId = "upload_sv",
#    label = h4("I need to upload user data"),
#    value = FALSE,
#    status = "primary"
#    ),
conditionalPanel(condition="input.upload_sv=='B'",      
# h4("Upload new data"),  
   p(("The new data will cover the example data.")),
   p(("Please refer to the example data's format.")),
   uiOutput("file2"),
   p(tags$b("Show 1st row as column names?")), 
   uiOutput("header2"),
   p(tags$b("Use 1st column as row names? (No duplicates)")), 
   uiOutput("col2"),
   uiOutput("sep2"),
   uiOutput("quote2"),
   awesomeCheckbox(
      inputId = "rmdt_sv",
      label = tags$b("Remove upload data"), 
      value = FALSE,
      status = "primary")    
)),
hr(),

   h4("Select variables"),  
   tags$b("Single treatment variable or multiple treatment variables"),
   # uiOutput("ztype"),
   radioGroupButtons(
   inputId = "ztype",
   label = NULL,
   choices = list("Single treatment variable"="FALSE", "Multiple treatment variables"="TRUE"),
   selected="TRUE",
   status = "primary",
   justified = TRUE,
    checkIcon = list(
      yes = icon("ok", 
    lib = "glyphicon"))
),         
   tags$b("Treatments (choose one or more binary variables)"),
   uiOutput("z2"),
   tags$b("Censoring indicator (choose one binary variable)"),
   uiOutput("d2"),
   tags$b("Time (choose one continuous variable)"),
   uiOutput("t2"),
   tags$b("Covariates (choose one or more numerical variables)"),
   uiOutput("x2"),
   conditionalPanel(condition="input.ztype=='TRUE'",
   tags$b("Contrast vector: input the values of vector in the linear combination of beta(x) for each treatment, e.g, c1*beta1(x)+c2*beta2(x)+..."),
   uiOutput("c2")),
   materialSwitch(
   inputId = "advance_sv",
   label = h4("Advanced settings"),
   value = FALSE,
   status = "primary"
   ),
   conditionalPanel(condition="input.advance_sv",
   tags$b("Significant level for confidence interval"),
   uiOutput("alpha2"),
   tags$b("Resampling times for confidence interval"),
   uiOutput("m2"),
   tags$b("Kernel bands in estimation (influence the smoothness of the curve)"),
   uiOutput("kh2")),
   
hr(),
actionButton("B2", HTML('Step 1. Estimate the CSTE Curve'), 
             class =  "btn-primary",
             icon  = icon("chart-column"))

),

##########----------##########----------##########
mainPanel(

h3("Data preview"),
materialSwitch(
   inputId = "pview_sv",
   label = h5("Show/Hide data preview"),
   value = TRUE,
   status = "primary"
   ),
conditionalPanel(condition="input.pview_sv",
DTOutput("data.pre2")
),    

hr(),
h3("Results"),
HTML(" 
<ul>
<li>CSTE Curve: the estimated CSTE curve</li>
<li>Estimates: the estimated CSTE with confidence bands</li>
</ul>
"),
tabsetPanel(

  tabPanel("CSTE Curve with Estimates", br(), 
   h4("CSTE Estimates"),
   wellPanel(
      p("The rownames correspond to subject ID."),
      withSpinner(DTOutput("res.table2"),type = 4, color = "#3498db", size = 1, caption = "Estimating, please wait..."),
      ),

   h4("CSTE curve"),
   conditionalPanel("input.B2",
   uiOutput("actionButtonBplot1_sv"),
   wellPanel(

   tabsetPanel(
    tabPanel("Static curve",
      materialSwitch(
         inputId = "figop_sv",
         label = h5("Figure options (optional settings)"),
         value = FALSE,
         status = "primary"
         ),
      conditionalPanel(condition="input.figop_sv",
      tags$b("Reset the range for y-axis"),
      uiOutput("ylim1_sv"),
      tags$b("Reset the range for x-axis"),
      uiOutput("xlim1_sv")),

         # actionButton("Bplot1_sv", HTML('Step 2. Show/Update the estimated CSTE curve'), 
         #        class =  "btn-primary",
         #        icon  = icon("chart-column")),
      plotOutput("res.plot2", click = "plot_click_sv"),
      downloadButton("downloadPlot1_sv", "Download Plot as PNG"),
      textOutput("click_info_sv"),
      textOutput("c2text")),

    tabPanel("Dynamic curve",
      plotlyOutput("makeplot2"))
   
   )
   # h4("CSTE Estimates"),
   # wellPanel(
   #    withSpinner(DTOutput("res.table2"),type=4)
   #    )       
   )
  # tabPanel(
  #  "CSTE Dynamic Plot", br(), 
  #  wellPanel(plotlyOutput("makeplot2")) 
  #          ),
  # tabPanel("Estimates", br(), )
  )


)
##########----------##########----------##########

)
)
)