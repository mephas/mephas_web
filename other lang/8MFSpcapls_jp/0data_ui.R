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
helpText("If no data set is uploaded, the example data is shown in the Data Display."),

selectInput("edata.x", "Choose data as X matrix", 
        choices =  c("Gene sample1","Gene sample2"), 
        selected = "Gene sample1"),

fileInput('file.x', "CSV ファイルを指定してください（説明変数X）",
  multiple = TRUE,
  accept = c("text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
checkboxInput("header.x", "ヘッダー", TRUE),

#fluidRow(

#column(4, 
# Input: Select separator ----
radioButtons("sep.x", "区切り",
     choices = c(Comma = ',',
                 Semicolon = ';',
                 Tab = '\t'),
     selected = ','),

#column(4,
# Input: Select quotes ----
radioButtons("quote.x", "クオート",
     choices = c(None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"'),

hr(),
# Input: Select a file as response----
checkboxInput("add.y", "Add Y data (necessary in PLS and SPLS)", FALSE), 
selectInput("edata.y", "Choose data as Y matrix", 
        choices =  c("Y_group_pca","Y_array_s_pls", "Y_matrix_s_pls"), 
        selected = "Y_group_pca"),

fileInput('file.y', "CSV ファイルを指定してください　(目的変数Y)",
  multiple = TRUE,
  accept = c("text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")),
helpText("Yの列は一つ以上にできる"),
# Input: Checkbox if file has header ----
checkboxInput("header.y", "ヘッダー", TRUE),

# Input: Select separator ----
radioButtons("sep.y", "区切り",
     choices = c(Comma = ',',
                 Semicolon = ';',
                 Tab = '\t'),
     selected = ','),

# Input: Select quotes ----
radioButtons("quote.y", "クオート",
     choices = c(None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"')

),


mainPanel(
h4(("データ表示")), 
tags$head(tags$style(".shiny-output-error{color: blue;}")),
tabsetPanel(
  tabPanel("X matrix", p(br()),
    dataTableOutput("table.x")),

  tabPanel("Y matrix", p(br()),
    dataTableOutput("table.y"))
  ),

hr(),  
h4(("記述統計")),

tabsetPanel(

tabPanel("Continuous variables", p(br()),

uiOutput('cv'), 
actionButton("Bc", "記述統計を表示"),
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
actionButton("Bd", "記述統計を表示"),p(br()),
verbatimTextOutput("fsum")
  )
),

h4(("変数の最初の探査")),  

tabsetPanel(
tabPanel("2つの変数間の散布図（線付き）",
uiOutput('tx'),
uiOutput('ty'),
plotOutput("p1", width = "400px", height = "400px")
),
tabPanel("Bar plots",
fluidRow(
column(6,
uiOutput('hx'),
plotOutput("p2", width = "400px", height = "400px"),
sliderInput("bin", "ヒストグラムの棒幅", min = 10, max = 150, value = 1)),
column(6,
uiOutput('hxd'),
plotOutput("p3", width = "400px", height = "400px"))))
)
)

)