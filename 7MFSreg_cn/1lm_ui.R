##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Linear Regression
##
## Language: CN
## 
## DT: 2019-01-16
##
##----------#----------#----------#----------

#tabPanel("Linear Regression (Continuous Outcomes)",

#titlePanel("Linear Regression"),

sidebarLayout(

sidebarPanel(

h4(("请在导入数据之后建立模型")),      
uiOutput('y'),    
uiOutput('x'),
uiOutput('fx'),

radioButtons("intercept", "常数项", ##> intercept or not
             choices = c("移除常数项" = "-1",
                         "保留常数项" = ""),
             selected = "-1"),
h5("附加部分 (混杂变量 or 交互作用)"), 
helpText('注: 添加附加项时请先输入 "+". 输入相互作用时，请输入 "+ as.factor(var1):var2"'), 
tags$textarea(id='conf', cols=40, " " ), 
p(br()),
actionButton("F", "产生公式", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

),

mainPanel(

h4(("公式结果")),

tags$style(type='text/css', '#formula {background-color: rgba(0,0,255,0.10); color: blue;}'),
verbatimTextOutput("formula", placeholder = TRUE),
helpText("注: 公式里的'-1' 表示常数项已经被移除"),
hr(),


h4(("模型的结果")),
actionButton("B1", "显示结果"),
p(br()),
tabsetPanel(
  
  tabPanel("参数估计",
    p(br()),
   #sliderInput("range", label = h3("choose subset"), min = 1, max = 100, value = c(1,10)),
    tags$b("1. 回归系数"),
    htmlOutput("fit"), p(br()),
    tags$b("2. ANOVA 表"), 
    tableOutput("anova"),p(br()),
    tags$b("3. 基于AIC方法的变量筛选"), 
    verbatimTextOutput("step")
    ),

  tabPanel("模型诊断", 
    p(br()),
    tags$b("诊断图"), 
    radioButtons("num", "图形选择",
                 choices = c("Residuals vs fitted plot" = 1,
                             "Normal Q-Q" = 2,
                             "Scale-Location" = 3,
                             "Cook's distance" = 4,
                             "Residuals vs Leverage" = 5),
                 selected = 1),
    plotOutput("p.lm", width = "800px", height = "400px")
    ),

  tabPanel("拟合结果的估计",
    p(br()),
    tags$b("拟合结果基于建模的数据"),
    dataTableOutput("fitdt0")),

    tabPanel("基于新数据的预测", p(br()),
    #prediction part
      ##-------csv file for prediction -------##   
    # Input: Select a file ----
    fileInput("newfile", "上传新的CSV文件",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
     # Input: Checkbox if file has header ----
    checkboxInput("newheader", "第一行为变量名", TRUE),

    fluidRow(
    column(3, 
       # Input: Select separator ----
    radioButtons("newsep", "分隔符",
                 choices = c(Comma = ",",
                             Semicolon = ";",
                             Tab = "\t"),
                 selected = ",")),

    column(3,
      # Input: Select quotes ----
    radioButtons("newquote", "引用符",
                 choices = c(None = "",
                             "Double Quote" = '"',
                             "Single Quote" = "'"),
                 selected = '"')),
    column(3,
     # prediction type
    radioButtons("interval", "选择估计区间 (0.95-level)",
                 choices = c(
                             "Confidence Interval" = "confidence",
                             "Prediction Interval" = "prediction"),
                 selected = 'confidence'))
              ), ##fluidRow(

    actionButton("B2", "参数估计结果出来之后提交"), 
    helpText("如果没有新数据上传，将使用例子里的数据的前10行作为测试数据"),
    
    p(br()),
    tags$b("数据和估计结果"), 
    p(br()),
    dataTableOutput("pred")
    
) 


)
)
)