##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Logistic regression
##
## Language: CN
## 
## DT: 2019-01-16
##
##----------#----------#----------#----------

#tabPanel("Logistic Regression (1-0 Outcomes)",

#titlePanel("Logistic Regression"),

sidebarLayout(
sidebarPanel(

h4(("请在导入数据（advertisement数据）之后建立模型")),      
uiOutput('y.l'),    
uiOutput('x.l'),
uiOutput('fx.l'),
# select intercept
radioButtons("intercept.l", "常数项",
 choices = c("移除常数项" = "-1",
             "保留常数项" = ""),
 selected = "-1"),
h5("附加部分 (混杂变量 or 交互作用)"), 
helpText('注: 添加附加项时请先输入 "+". 输入相互作用时，请输入 "+ as.factor(var1):var2"'), 
tags$textarea(id='conf.l', column=40, ""), 
p(br()),
actionButton("F.l", "产生公式", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

), ## sidebarPanel(

mainPanel(

h4(("公式结果")),

tags$style(type='text/css', '#formula_l {background-color: rgba(0,0,255,0.10); color: blue;}'),
verbatimTextOutput("formula_l", placeholder = TRUE),
helpText("注: 公式里的'-1' 表示常数项已经被移除"),
hr(),

h4(tags$b("模型的结果")),
actionButton("B1.l", "显示结果"), 
p(br()),
tabsetPanel(
tabPanel("参数估计",
p(br()),

p(br()),
tags$b("1. 回归系数"),
htmlOutput("fit.l"), p(br()),
tags$b("2. ANOVA 表"), 
tableOutput("anova.l"), p(br()),
tags$b("3. 基于AIC方法的变量筛选"), 
verbatimTextOutput("step.l")
),

tabPanel("模型诊断", 
p(br()),
tags$b("ROC 图"),

plotOutput("p2.l", width = "400px", height = "400px"),
verbatimTextOutput("auc")
),

tabPanel("拟合结果的估计",
p(br()),
tags$b("拟合结果基于建模的数据"),
dataTableOutput("fitdt")
),

tabPanel("基于新数据的预测", p(br()),
#prediction part
##-------csv file for prediction -------##   
# Input: Select a file ----
fileInput("newfile.l", "上传新的CSV文件",
    multiple = TRUE,
    accept = c("text/csv",
             "text/comma-separated-values,text/plain",
             ".csv")),

# Input: Checkbox if file has header ----
checkboxInput("newheader.l", "第一行为变量名", TRUE),

fluidRow(
column(3, 
# Input: Select separator ----
radioButtons("newsep.l", "分隔符",
       choices = c(Comma = ",",
                   Semicolon = ";",
                   Tab = "\t"),
       selected = ",")),

column(3,
# Input: Select quotes ----
radioButtons("newquote.l", "引用符",
       choices = c(None = "",
                   "Double Quote" = '"',
                   "Single Quote" = "'"),
       selected = '"'))

),
actionButton("B2.l", "参数估计结果出来之后提交"),
helpText("如果没有新数据上传，将使用例子里的数据的前10行作为测试数据"),

p(br()),
tags$b("数据和估计结果"), 
p(br()),
dataTableOutput("preddt.l")
) ##  tabPanel("Prediction"
) ## tabsetPanel(
) ## mainPanel(
) ## sidebarLayout(