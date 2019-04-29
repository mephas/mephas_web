##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
##    > data
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

sidebarLayout(
sidebarPanel(##-------csv file-------##   
# Input: Select a file as variable----
helpText("If no dataset is uploaded, the example data is shown in the Data Display."),

helpText(HTML("
<b> X data: </b>
<ul>
<li> Gene sample 1 has fewer variables than Gene sample 2
</ul>

")),

selectInput("edata.x", "Choose X matrix", 
        choices =  c("Gene sample1","Gene sample2"), 
        selected = "Gene sample1"),

fileInput('file.x', "Upload .csv data set of X matrix (numeric predictors)",
  multiple = TRUE,
  accept = c("text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
checkboxInput("header.x", "Header", TRUE),

#fluidRow(

#column(4, 
# Input: Select separator ----
radioButtons("sep.x", "Separator",
     choices = c(Comma = ',',
                 Semicolon = ';',
                 Tab = '\t'),
     selected = ','),

#column(4,
# Input: Select quotes ----
radioButtons("quote.x", "Quote",
     choices = c(None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"'),

hr(),
# Input: Select a file as response----
#p(br("Necessary step in PLS and SPLS")),

helpText(HTML("
<b> Y data: </b>
<ul>
<li> Y_group_pca: the group variable for PCA 
<li> Y_array_s_pls: the univariate Y for PLS and SPLS
<li> Y_matrix_s_pls: the matrix/multivariate Y for PLS and SPLS
</ul>

")),

selectInput("edata.y", "Choose Y matrix (necessary in PLS and SPLS)", 
        choices =  c("Y_group_pca","Y_array_s_pls", "Y_matrix_s_pls"), 
        selected = "Y_group_pca"),

checkboxInput("add.y", "Add Y data in PLS and SPLS", FALSE), 

fileInput('file.y', "Upload .csv data set of Y matrix (Group variable or numeric responder matrix)",
  multiple = TRUE,
  accept = c("text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")),
helpText("The columns of Y can be one or more than one"),
# Input: Checkbox if file has header ----
checkboxInput("header.y", "Header", TRUE),

# Input: Select separator ----
radioButtons("sep.y", "Separator",
     choices = c(Comma = ',',
                 Semicolon = ';',
                 Tab = '\t'),
     selected = ','),

# Input: Select quotes ----
radioButtons("quote.y", "Quote",
     choices = c(None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"')

),


mainPanel(
h4(("Data Display")), 
tags$head(tags$style(".shiny-output-error{color: blue;}")),
tabsetPanel(
  tabPanel("X matrix", p(br()),
    dataTableOutput("table.x")),

  tabPanel("Y matrix", p(br()),
    dataTableOutput("table.y"))
  ),

hr(),  
h4(("Basic Descriptives")),

tabsetPanel(

tabPanel("Continuous variables", p(br()),

uiOutput('cv'), 
actionButton("Bc", "Show descriptives"),p(br()),
tableOutput("sum"),
helpText(HTML(
"
Note:
<ul>
<li> nbr.: the number of </li>
</ul>
"
))),

tabPanel("Discrete variables", p(br()),

  uiOutput('dv'),
actionButton("Bd", "Show descriptives"),p(br()),
verbatimTextOutput("fsum")
  )
),

h4(("First Exploration of Variables")),  

tabsetPanel(
tabPanel("Scatter plot (with line) between two variables",
uiOutput('tx'),
uiOutput('ty'),
plotOutput("p1", width = "400px", height = "400px")
),
tabPanel("Bar plots",
fluidRow(
column(6,
uiOutput('hx'),
plotOutput("p2", width = "400px", height = "400px"),
sliderInput("bin", "The width of bins in the histogram", min = 10, max = 150, value = 1)),
column(6,
uiOutput('hxd'),
plotOutput("p3", width = "400px", height = "400px"))))
)
)

)