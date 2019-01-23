##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >data
##
## Language: CN
## 
## DT: 2019-01-16
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

##----------example datasets----------

selectInput("edata", "选择数据:", 
          choices =  c("insurance","advertisement","lung"), 
          selected = "insurance"),
## render dynamic checkboxes
helpText(HTML("
<b> Datasets: </b>
<ul>
<li> insurance: 线性回归的数据集例子
<li> advertisement: 逻辑回归的数据集例子
<li> lung: Cox回归的数据集例子
</ul>

")),


##-------csv file-------##   
fileInput('file', "上传CSV文件",
accept = c("text/csv",
    "text/comma-separated-values,text/plain",
    ".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
checkboxInput("header", "第一行为变量名", TRUE),

fluidRow(

column(4, 
# Input: Select separator ----
radioButtons("sep", "分隔符",
 choices = c(Comma = ',',
             Semicolon = ';',
             Tab = '\t'),
 selected = ',')),

column(4,
# Input: Select quotes ----
radioButtons("quote", "引用符",
 choices = c(None = "",
             "Double Quote" = '"',
             "Single Quote" = "'"),
 selected = '"'))
),

actionButton("choice", "导入数据", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),


mainPanel(

h4(("数据显示")),

tags$br(),

tags$b("暂时只显示前5行和前2列"), 

dataTableOutput("data"),


selectInput("columns", "请选择更多变量来观察数据", choices = NULL, multiple = TRUE), # no choices before uploading 

dataTableOutput("data_var"),
hr(),

h4(("基本统计量")), 
tags$b("选择变量"),

fluidRow(
column(6,
uiOutput('cv'),
actionButton("Bc", "计算统计量"),
tableOutput("sum"),
helpText(HTML(
"
Note:
<ul>
<li> nbr.: 表示个数 the number of 的缩写 </li>
</ul>
"
))
),

column(6,
uiOutput('dv'),
actionButton("Bd", "计算统计量"),
verbatimTextOutput("fsum")
)),

h4(("变量的初步探索")),  
tabsetPanel(
tabPanel("两个变量关系的散点图",
uiOutput('ty'),
uiOutput('tx'),
plotOutput("p1", width = "400px", height = "400px")
),
tabPanel("直方图",
fluidRow(
column(6,
uiOutput('hx'),
plotOutput("p2", width = "400px", height = "400px"),
sliderInput("bin", "直方图柱子的宽度", min = 0.01, max = 50, value = 1)),
column(6,
uiOutput('hxd'),
plotOutput("p3", width = "400px", height = "400px"))))
)


))