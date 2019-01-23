##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Cox regression
##
## Language: CN
## 
## DT: 2019-01-16
##
##----------#----------#----------#----------

#tabPanel("Cox Regression (Time-Event Outcomes)",

#titlePanel("Cox Regression"),

sidebarLayout(

sidebarPanel(


##<<-----------------------------<<

##>>---------cox formula---------->>
h4(("请在导入数据之后建立模型")),      
uiOutput('t1.c'),
uiOutput('t2.c'),
uiOutput('c.c'),    
uiOutput('x.c'),
uiOutput('fx.c'),
uiOutput('sx.c'),
uiOutput('clx.c'),

h5("附加部分 (混杂变量 or 交互作用)"), 
helpText('注: 添加附加项时请先输入 "+". 输入相互作用时，请输入 "+ as.factor(var1):var2"'), 
tags$textarea(id='conf.c', cols=40, " " ), 
p(br()),
actionButton("F.c", "产生公式", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

), ## sidebarPanel(

mainPanel( 

h4(("公式结果")),
tags$style(type='text/css', '#formula_c {background-color: rgba(0,0,255,0.10); color: blue;}'),
verbatimTextOutput("formula_c", placeholder = TRUE),
hr(),

h4(("模型的结果")),
actionButton("B1.c", "显示结果"),
p(br()),

tabsetPanel(
tabPanel("变量的探索",
p(br()),
actionButton("Y.c", "产生公式之后做图"),
p(br()),
tags$b("1. K-M 生存图（不分组）"), 
helpText("公式: Surv(time, status)~1 "),
plotOutput("p0.c", width = "400px", height = "400px"),

tags$b("2. K-M 生存图 (分组)"), 
helpText("公式: Surv(time, status) ~ group"),
uiOutput('tx.c'),
plotOutput("p1.c", width = "400px", height = "400px")
),
tabPanel("参数估计",
p(br()),

tags$b("1. 回归系数"),
htmlOutput("fit.c"), p(br()),
tags$b("2. ANOVA 表"), 
tableOutput("anova.c"),p(br()),
tags$b("3. 基于AIC方法的变量筛选"), 
verbatimTextOutput("step.c")
),
tabPanel("模型诊断", 
p(br()),
tags$b("1. 危险率不随时间变化"),
tableOutput("zph.c"), 
plotOutput("p2.c",width = "400px", height = "400px"),
tags$b("2. 诊断图"), 
radioButtons("res.c", "Residual type",
   choices = c("Martingale" = "martingale",
               "Deviance" = "deviance",
               "Cox-Snell" = "Cox-Snell"),
   selected = "martingale") ,
plotOutput("p4.c", width = "700px", height = "500px")),

tabPanel("拟合结果的估计",
p(br()),
tags$b("拟合结果基于建模的数据"),
dataTableOutput("fitdt.c")),

tabPanel("基于新数据的预测", p(br()),

#prediction part
##-------csv file for prediction -------##   
# Input: Select a file ----
fileInput("newfile.c", "上传新的CSV文件",
    multiple = TRUE,
    accept = c("text/csv",
             "text/comma-separated-values,text/plain",
             ".csv")),

# Input: Checkbox if file has header ----
checkboxInput("newheader.c", "第一行为变量名", TRUE),

fluidRow(
column(3, 
# Input: Select separator ----
radioButtons("newsep.c", "分隔符",
       choices = c(Comma = ",",
                   Semicolon = ";",
                   Tab = "\t"),
       selected = ",")),

column(3,
# Input: Select quotes ----
radioButtons("newquote.c", "引用符",
       choices = c(None = "",
                   "Double Quote" = '"',
                   "Single Quote" = "'"),
       selected = '"'))

),
actionButton("B2.c", "参数估计结果出来之后提交"), 
helpText("如果没有新数据上传，将使用例子里的数据的前10行作为测试数据"),

p(br()),
tags$b("数据和估计结果"), 
p(br()),
dataTableOutput("pred.c")
)
) ##tabsetPanel(
) ## mainPanel(

) ## sidebarLayout(