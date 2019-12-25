##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >data
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

##----------example datasets----------

selectInput("edata", "Choose data", 
        choices =  c("insurance_linear_regression","advertisement_logistic_regression","lung_cox_regression"), 
        selected = "insurance_linear_regression"),


helpText(HTML("
<b> Datasets: </b>
<ul>
<li> insurance: the example data for linear regression
<li> advertisement: the example data for logistic regression
<li> lung: the example data for cox regression
</ul>

")),

hr(),
##-------csv file-------##   
fileInput('file', "CSV ファイルを指定",
accept = c("text/csv",
  "text/comma-separated-values,text/plain",
  ".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
checkboxInput("header", "ヘッダー", TRUE),

# Input: Select separator ----
radioButtons("sep", "区切り",
choices = c("Comma" = ',',
           "Semicolon" = ';',
           "Tab" = '\t'),
selected = ','),


# Input: Select quotes ----
radioButtons("quote", "クオート",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"')
),

#actionButton("choice", "Import dataset", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),


mainPanel(

h4("データ表示"),

tags$br(),

tags$b("データセットの最初の6行の概要"), 

# tags$head(tags$style(".shiny-output-error{color: blue;}")),

dataTableOutput("data"),


#selectInput("columns", "Select variables to display the details", choices = NULL, multiple = TRUE), # no choices before uploading 

#dataTableOutput("data_var"),
hr(),

h4("記述統計"), 
tabsetPanel(
tabPanel("Continuous variables", p(br()),
uiOutput('cv'),
actionButton("Bc", "Show descriptives"),
tableOutput("sum"),
helpText(
HTML(
"
注:
<ul>
<li> nbr.: the number of 
</ul>
"
))
),

tabPanel("Discrete / categorical variables", p(br()),
uiOutput('dv'),
actionButton("Bd", "Show descriptives"),
verbatimTextOutput("fsum"))
), 

hr(),

h4(("変数の最初の探査")),  
tabsetPanel(
tabPanel("2つの変数間の散布図（線付き）",
uiOutput('tx'),
uiOutput('ty'),
plotOutput("p1", width = "400px", height = "400px")
),
tabPanel("ヒストグラム", p(br()),
uiOutput('hx'),
plotOutput("p2", width = "400px", height = "400px"),
sliderInput("bin", "ヒストグラムの棒幅", min = 0.01, max = 50, value = 1)),

tabPanel("Bar plot", p(br()),
uiOutput('hxd'),
plotOutput("p3", width = "400px", height = "400px")	)
)
)


)