##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
##    > data
##
## Language: CN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

sidebarLayout(
sidebarPanel(##-------csv file-------##   
# Input: Select a file as variable----
helpText("如果没有数据上传，将使用测试数据"),

selectInput("edata.x", "选择 X 矩阵（预测集）", 
        choices =  c("Gene sample1","Gene sample2"), 
        selected = "Gene sample1"),

fileInput('file.x', "上传 X 矩阵（预测集）",
  multiple = TRUE,
  accept = c("text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
checkboxInput("header.x", "标题行", TRUE),

#fluidRow(

#column(4, 
# Input: Select separator ----
radioButtons("sep.x", "分隔符",
     choices = c(Comma = ',',
                 Semicolon = ';',
                 Tab = '\t'),
     selected = ','),

#column(4,
# Input: Select quotes ----
radioButtons("quote.x", "引号",
     choices = c(None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"'),

hr(),
# Input: Select a file as response----
checkboxInput("add.y", "添加 Y 反应集 (用于PLS 和 SPLS)", FALSE), 
selectInput("edata.y", "选择 Y 反应集", 
        choices =  c("Y_group_pca","Y_array_s_pls", "Y_matrix_s_pls"), 
        selected = "Y_group_pca"),

fileInput('file.y', "上传 CSV 格式的反应数据集（Y） (分组变量或者矩阵)",
  multiple = TRUE,
  accept = c("text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")),
helpText("Y的列可以不止一个"),
# Input: Checkbox if file has header ----
checkboxInput("header.y", "标题行", TRUE),

# Input: Select separator ----
radioButtons("sep.y", "分隔符",
     choices = c(Comma = ',',
                 Semicolon = ';',
                 Tab = '\t'),
     selected = ','),

# Input: Select quotes ----
radioButtons("quote.y", "引号",
     choices = c(None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"')

),


mainPanel(
h4(("数据显示")), 
tags$head(tags$style(".shiny-output-error{color: blue;}")),
tabsetPanel(
  tabPanel("X 矩阵（预测集）", p(br()),
    dataTableOutput("table.x")),

  tabPanel("Y 矩阵（反应集）", p(br()),
    dataTableOutput("table.y"))
  ),

hr(),  
h4(("基础统计量")),

tabsetPanel(

tabPanel("连续型变量", p(br()),

uiOutput('cv'), 
actionButton("Bc", "计算"),p(br()),
tableOutput("sum"),
helpText(HTML(
"
注:
<ul>
<li> nbr.: the number of </li>
</ul>
"
))),

tabPanel("离散型变量", p(br()),

  uiOutput('dv'),
actionButton("Bd", "计算"),p(br()),
verbatimTextOutput("fsum")
  )
),

h4(("变量的初步探索")),  

tabsetPanel(
tabPanel("两个变量之间的散点图", p(br()),
uiOutput('tx'),
uiOutput('ty'),
plotOutput("p1", width = "400px", height = "400px")
),
tabPanel("直方图", p(br()),
fluidRow(
column(6,
uiOutput('hx'),
plotOutput("p2", width = "400px", height = "400px"),
sliderInput("bin", "直方图柱子的宽度", min = 10, max = 150, value = 1)),
column(6,
uiOutput('hxd'),
plotOutput("p3", width = "400px", height = "400px"))))
)
)

)