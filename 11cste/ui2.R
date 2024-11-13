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

tabsetPanel(

tabPanel("Example data", br(),

prettyRadioButtons(
   inputId = "edata2",
   label =  "Example datasets",
   choices =  list(
    "Data2: time-to-event outcome " = "data2"),
   selected = "data2",
    icon = icon("database"),
    status = "primary"
)),

tabPanel("Upload Data",
         
   h5(tags$b("Upload user data")),
   p(("The new data will cover the example data.")),
   p(("Please refer to the example data's format.")),
   uiOutput("file2"),
   p(tags$b("Show 1st row as column names?")), 
   uiOutput("header2"),
   p(tags$b("Use 1st column as row names? (No duplicates)")), 
   uiOutput("col2"),
   uiOutput("sep2"),
   uiOutput("quote2")      
)

),
   h5(tags$b("Select variables")),               
   HTML("Treatments: choose one or more binary variables"),
   uiOutput("z2"),
   HTML("Censoring indicator: choose one binary variable"),
   uiOutput("d2"),
   HTML("Time: choose one continuous variable"),
   uiOutput("t2"),
   HTML("Covariates: choose one or more numerical variables"),
   uiOutput("x2"),
   HTML("Contrast vector: input the values of vector in the linear combination of beta(x), e.g, c1*beta1(x)+c2*beta2(x)"),
   uiOutput("c2"),
   HTML("Significant level for confidence interval"),
   uiOutput("alpha2"),
   HTML("Resampling times for confidence interval"),
   uiOutput("m2"),
   HTML("Kernel bands in estimation"),
   uiOutput("kh2"),
   
hr(),
actionButton("B2", HTML('Calculate'), 
             class =  "btn-primary",
             icon  = icon("chart-column")),
hr()
# ),
),

##########----------##########----------##########
mainPanel(

h4(("Data preview")),
DTOutput("data.pre2"),    
hr(),
h4("Results"),
HTML(" 
<ul>
<li>CSTE Curve: the estimated CSTE curve</li>
<li>CSTE Dynamic Curve: the estimated CSTE curve shown in dynamic plot</li>
<li>Estimates: the estimated CSTE with confidence bands</li>
</ul>
"),
tabsetPanel(
  tabPanel("CSTE Plot", br(), 
           wellPanel(plotOutput("res.plot2"))
           ),
  tabPanel(
   "CSTE Dynamic Plot", br(), 
   wellPanel(plotlyOutput("makeplot2")) 
           ),
  tabPanel("Estimates", br(), wellPanel(DTOutput("res.table2")))
  )


)
##########----------##########----------##########

)
