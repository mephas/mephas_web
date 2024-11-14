#****************************************************************************************************************************************************

sidebarLayout(

##########----------##########----------##########

sidebarPanel(

h3("Data Preparation"),
HTML("Data requirements: 
   <ul>
<li>Outcome: single continuous variable as time</li>
<li>Censoring indicator: single binary variable
<li>Multi-arm treatments: multiple binary dummy variables</li>
<li>Covariate: single variable</li>
</ul>"),

h3("Model Estimation"),
prettyRadioButtons(
   inputId = "edata2",
   label =  "Example datasets",
   choices =  list(
    "Data2: time-to-event outcome " = "data2"),
   selected = "data2",
    icon = icon("database"),
    status = "primary"
),

materialSwitch(
   inputId = "upload_sv",
   label = h4("I need to upload user data"),
   value = FALSE,
   status = "primary"
   ),
conditionalPanel(condition="input.upload_sv",   
   wellPanel(      
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
   tags$b("Treatments (choose one or more binary variables)"),
   uiOutput("z2"),
   tags$b("Censoring indicator (choose one binary variable)"),
   uiOutput("d2"),
   tags$b("Time (choose one continuous variable)"),
   uiOutput("t2"),
   tags$b("Covariates (choose one or more numerical variables)"),
   uiOutput("x2"),
   tags$b("Contrast vector: input the values of vector in the linear combination of beta(x), e.g, c1*beta1(x)+c2*beta2(x)"),
   uiOutput("c2"),
   materialSwitch(
   inputId = "advance_sv",
   label = h4("Advanced settings"),
   value = TRUE,
   status = "primary"
   ),
   conditionalPanel(condition="input.advance_sv",
   tags$b("Significant level for confidence interval"),
   uiOutput("alpha2"),
   tags$b("Resampling times for confidence interval"),
   uiOutput("m2"),
   tags$b("Kernel bands in estimation"),
   uiOutput("kh2")
   ),
   
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
h4("Results"),
HTML(" 
<ul>
<li>CSTE Curve: the estimated CSTE curve</li>
<li>Estimates: the estimated CSTE with confidence bands</li>
</ul>
"),
tabsetPanel(
  tabPanel("CSTE Curve with Estimates", br(), 
   h4("CSTE curve"),
   wellPanel(withSpinner(plotOutput("res.plot2"),type=4)),
   h4("CSTE Estimates"),
   wellPanel(withSpinner(DTOutput("res.table2"), type=4))       
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
