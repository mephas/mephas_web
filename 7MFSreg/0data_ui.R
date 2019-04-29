##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >data
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

##----------example datasets----------
helpText(HTML("
<b> Datasets: </b>
<ul>
<li> insurance_linear_regression: the example data for linear regression
<li> advertisement_logistic_regression: the example data for logistic regression
<li> lung_cox_regression: the example data for cox regression
</ul>

")),

selectInput("edata", "Choose data", 
        choices =  c("insurance_linear_regression","advertisement_logistic_regression","lung_cox_regression"), 
        selected = "insurance_linear_regression"),


hr(),
##-------csv file-------##   
fileInput('file', "Upload CSV file",
accept = c("text/csv",
  "text/comma-separated-values,text/plain",
  ".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
checkboxInput("header", "Header", TRUE),

 
# Input: Select separator ----
radioButtons("sep", "Separator",
choices = c("Comma" = ',',
           "Semicolon" = ';',
           "Tab" = '\t'),
selected = ','),


# Input: Select quotes ----
radioButtons("quote", "Quote",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"')
),

#actionButton("choice", "Import dataset", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),


mainPanel(
h4("Data Display"),
tags$head(tags$style(".shiny-output-error{color: blue;}")),
dataTableOutput("Xdata2"),
hr(),		

h4("Re-generate variables"),
    uiOutput("factor2"),
		uiOutput("factor1"),
		uiOutput("lvl"),
		helpText("Type the reference"),
		tags$textarea(id='ref', column=40, ""), 
		
		helpText("Click the button the generate new data set, the old variables will become xxx.1"),
		actionButton("changevar", "Activate dataset",
      style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),

hr(),

h4("Basic Descriptives"),
tabsetPanel(
tabPanel("Continuous variables", p(br()),
helpText("The list"),
verbatimTextOutput("str.num"),

uiOutput('cv'),
actionButton("Bc", "Show descriptives"),
tableOutput("sum"),
helpText(
HTML(
"
Note:
<ul>
<li> nbr.: the number of 
</ul>
"
)),
downloadButton("download1", "Download Results")

),

tabPanel("Discrete / categorical variables", p(br()),
helpText("The list"),
verbatimTextOutput("str.fac"),
uiOutput('dv'),
actionButton("Bd", "Show descriptives"),
verbatimTextOutput("fsum"),
downloadButton("download2", "Download Results")
)
), 

hr(),

h4(("First Exploration of Variables")),  
tabsetPanel(
tabPanel("Scatter plot (with line) between two variables",
uiOutput('tx'),
uiOutput('ty'),
plotOutput("p1", width = "400px", height = "400px")
),
tabPanel("Histogram", p(br()),
uiOutput('hx'),
plotOutput("p2", width = "400px", height = "400px"),
sliderInput("bin", "The width of bins in the histogram", min = 0.01, max = 50, value = 1)),

tabPanel("Bar plot", p(br()),
uiOutput('hxd'),
plotOutput("p3", width = "400px", height = "400px")	)
)
)


)