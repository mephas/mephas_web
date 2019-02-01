##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >data
##
## Language: CN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

##----------example datasets----------

selectInput("edata", "选择数据", 
        choices =  c("insurance_linear_regression","advertisement_logistic_regression","lung_cox_regression"), 
        selected = "insurance_linear_regression"),


helpText(HTML("
<b> 数据集解释: </b>
<ul>
<li> insurance: 线性回归的数据集例子
<li> advertisement: 逻辑回归的数据集例子
<li> lung: Cox回归的数据集例子
</ul>

")),

hr(),
##-------csv file-------##   
fileInput('file', "上传CSV文件",
accept = c("text/csv",
  "text/comma-separated-values,text/plain",
  ".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
checkboxInput("header", "第一行为变量名", TRUE),

 
# Input: Select separator ----
radioButtons("sep", "分隔符",
choices = c("Comma" = ',',
           "Semicolon" = ';',
           "Tab" = '\t'),
selected = ','),


# Input: Select quotes ----
radioButtons("quote", "引用符",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"')
),

#actionButton("choice", "Import dataset", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),


mainPanel(

h4(("数据显示")),

tags$br(),

helpText("暂时只显示前6行"), 

# tags$head(tags$style(".shiny-output-error{color: blue;}")),

dataTableOutput("data"),


#selectInput("columns", "Select variables to display the details", choices = NULL, multiple = TRUE), # no choices before uploading 

#dataTableOutput("data_var"),
hr(),

h4("基本统计量"),
tabsetPanel(
tabPanel("连续型变量", p(br()),
uiOutput('cv'),
actionButton("Bc", "计算统计量"),
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

tabPanel("离散型变量", p(br()),
uiOutput('dv'),
actionButton("Bd", "计算统计量"),
verbatimTextOutput("fsum"))
), 

hr(),

h4(("变量的初步探索")),  
tabsetPanel(
tabPanel("两个变量关系的散点图", p(br()),
uiOutput('tx'),
uiOutput('ty'),
plotOutput("p1", width = "400px", height = "400px")
),
tabPanel("直方图", p(br()),
uiOutput('hx'),
plotOutput("p2", width = "400px", height = "400px"),
sliderInput("bin", "直方图柱子的宽度", min = 0.01, max = 50, value = 1)),

tabPanel("条形图", p(br()),
uiOutput('hxd'),
plotOutput("p3", width = "400px", height = "400px")	)
)
)


)