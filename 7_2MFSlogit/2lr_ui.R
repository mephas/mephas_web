##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Logistic regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(
sidebarPanel(

h4(("Example data: advertisement_logistic _regression")),       
uiOutput('y.l'),    
uiOutput('x.l'),

# select intercept
radioButtons("intercept.l", "Intercept/constant",
     choices = c("Remove intercept/constant" = "-1",
                 "Keep intercept/constant" = ""),
     selected = ""),
h5("Interaction between categorical variables"), 
helpText('Note: + var1:var2'), 
tags$textarea(id='conf.l', column=40, ""), 
p(br()),
actionButton("F.l", "Create formula", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

), ## sidebarPanel(

mainPanel(
h4("Browse Data"),
dataTableOutput("data.h2"),
verbatimTextOutput("str2"),
hr(),

h4(("Logistics Regression Model")),

tags$style(type='text/css', '#formula_l {background-color: rgba(0,0,255,0.10); color: blue;}'),
verbatimTextOutput("formula_l", placeholder = TRUE),
helpText("Note: '-1' in the formula indicates that intercept has been removed"),
hr(),

h4(("Results of the logistic regression")),
actionButton("B1.l", "Show the results", style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Parameters' estimation", 
p(br()),

p(br()),
tags$b("1. Regression's coefficients"), 
#helpText("TXT file will be created on local device"),

 fluidRow(
    column(6, htmlOutput("fit.l")
      
    ),
    column(6, htmlOutput("fit.le")
    )
  ),


p(br()),
tags$b("2. ANOVA Table"), tableOutput("anova.l"), p(br()),
tags$b("3. Select a formula-based model by AIC"), verbatimTextOutput("step.l")
),

tabPanel("Model's diagnostics",
p(br()),
tags$b("ROC Plot"),

plotOutput("p2.l", width = "400px", height = "400px"),
verbatimTextOutput("auc")
),

tabPanel("Estimated fitting values",
tags$b("Estimation is based on import dataset"), 
dataTableOutput("fitdt"),
downloadButton("download21", "Download Results")
),

tabPanel("Prediction on new data", 
p(br()),
#prediction part
##-------csv file for prediction -------##   
# Input: Select a file ----
fileInput("newfile.l", "Upload new .csv data set",
        multiple = TRUE,
        accept = c("text/csv",
                 "text/comma-separated-values,text/plain",
                 ".csv")),

# Input: Checkbox if file has header ----
checkboxInput("newheader.l", "Header", TRUE),

fluidRow(
column(3, 
 # Input: Select separator ----
radioButtons("newsep.l", "Separator",
           choices = c(Comma = ",",
                       Semicolon = ";",
                       Tab = "\t"),
           selected = ",")),

column(3,
# Input: Select quotes ----
radioButtons("newquote.l", "Quote",
           choices = c(None = "",
                       "Double Quote" = '"',
                       "Single Quote" = "'"),
           selected = '"'))

),
actionButton("B2.l", "Submit after the estimation of model", style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
helpText("If no data is uploaded, the example testing data (the first 10 rows of import dataset) will be shown."),

p(br()),
tags$b("Data display with prediction results"), 
p(br()),
dataTableOutput("preddt.l"),
downloadButton("download22", "Download Results")
) ##  tabPanel("Prediction"
) ## tabsetPanel(
) ## mainPanel(
) ## sidebarLayout(