##----------------------------------------------------------------
##
## The univariate regression models: lm, logistic model, cox model, ui CN
## 
## DT: 2018-11-30
##
##----------------------------------------------------------------

shinyUI(
tagList(
#shinythemes::themeSelector(),
    ##model
navbarPage(
  title = "回归模型（n行＞n列）",

# 1. LM regression
tabPanel("线性回归（连续结果）",

titlePanel("线性回归"),

sidebarLayout(

sidebarPanel(

## 1. input data
h4(tags$b("数据导入")),

##>>----------csv file--------->> 
# Input: Select a file ----
fileInput("file", "上传 .csv 格式的数据集",
          multiple = TRUE,
          accept = c("text/csv",
                   "text/comma-separated-values,text/plain",
                   ".csv")),
helpText("如果没有上传数据，则显示示例数据(mtcars)."),
 # Input: Checkbox if file has header ----
checkboxInput("header", "标题行", TRUE),

fluidRow(

column(4, 
   # Input: Select separator ----
radioButtons("sep", "分隔符",
             choices = c(Comma = ",",
                         Semicolon = ";",
                         Tab = "\t"),
             selected = ",")),

column(4,
  # Input: Select quotes ----
radioButtons("quote", "引号",
             choices = c(None = "",
                         "Double Quote" = '"',
                         "Single Quote" = "'"),
             selected = '"'))
),
hr(),
##<<-----------------------------<<

##>>---------lm formula---------->>
h4(tags$b("选择变量来建立模型")),      
uiOutput('y'),    
uiOutput('x'),
uiOutput('fx'),
radioButtons("intercept", "截距", ##> intercept or not
             choices = c("删除截距" = "-1",
                         "保持截距" = ""),
             selected = "-1"),
h5("附加条件（混淆或相互作用）"), 
helpText("以“+”开始. 关于交互项，请键入+as.factor（cyl）*wt"), 
tags$textarea(id='conf', cols=40, " " ), 
p(br()),
actionButton("F", "首先：创建公式"),
verbatimTextOutput("formula"),
helpText("'-1' 表示删除截距"),
hr(),

##-------Basic Plot -------## 

h4(tags$b("变量探索")),  
tags$b("1. X和Y之间的散点图"),     
fluidRow(
  column(6, uiOutput('ty')),
  column(6, uiOutput('tx'))),
plotOutput("p1", width = "400px", height = "400px"),

p(br()), 
tags$b("2. 直方图"),
uiOutput('hx'),
plotOutput("p3", width = "400px", height = "400px"),
sliderInput("bin", "直方图中桶的宽度", min = 0.01, max = 50, value = 0.7)
),

mainPanel(
  h4(tags$b("结果")),
  tags$b("1. 显示数据"), 
  dataTableOutput("table"), 
  tags$b("2. 基本记述"), 
      helpText("选择描述的变量"),

      tabsetPanel(
        tabPanel("连续变量",
          uiOutput('cv'),
          actionButton("Bc", "Submit"),
          tableOutput("sum")
          ),
        tabPanel("离散变量",
          uiOutput('dv'),
          actionButton("Bd", "Submit"),
          verbatimTextOutput("fsum")
          )
        ),

  hr(),
  h4(tags$b("模型")),
  tabsetPanel(
    tabPanel("估计", p(br()),
      actionButton("B1", "请在公式显示后提交"),
      p(br()),
      tags$b("1. 回归拟合"),htmlOutput("fit"), p(br()),
      tags$b("2. 方差分析ANOVA表"), tableOutput("anova")
      ),
    tabPanel("诊断", 
      p(br()),
      tags$b("1. 诊断图"), 
      radioButtons("num", "选择作图",
                   choices = c("残差与拟合曲线" = 1,
                               "正态概率单位分布图" = 2,
                               "尺度定位" = 3,
                               "Cook距离" = 4,
                               "残差与影响" = 5),
                   selected = 1),
      plotOutput("p2", width = "400px", height = "400px"),
      tags$b("2. 估计拟合值"), dataTableOutput("fitdt0")
      ),
    tabPanel("预测", p(br()),
      #prediction part
        ##-------csv file for prediction -------##   
      # Input: Select a file ----
      fileInput("newfile", "上传 .csv 格式的新数据集",
                multiple = TRUE,
                accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
      helpText("如果没有上传数据，则显示示例测试数据(mtcars)."),
       # Input: Checkbox if file has header ----
      checkboxInput("newheader", "标题行", TRUE),

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
      radioButtons("newquote", "引号",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"')),
      column(3,
       # prediction type
      radioButtons("interval", "选择预测区间（0.95级）",
                   choices = c(
                               "置信区间" = "confidence",
                               "选择预测区间" = "prediction"),
                   selected = 'confidence'))
                ), ##fluidRow(
actionButton("B2", "请在模型估计后提交"), 
p(br()),
tags$b("1. 数据和预测结果一同显示"), 
p(br()),
dataTableOutput("pred"),
p(br()),
tags$b("2. 预测结果的散点图"), 
helpText("红划线是预测区间；灰色区域是置信区间."), 
plotOutput("p4", width = "400px", height = "400px"),
uiOutput('px')
) ##tabPanel("Prediction",
    )

) ## mainPanel
) ## siderbarlayout,
), ## tabPanel

##-----------------------------------------------------------------------
## 2. logistic regression---------------------------------------------------------------------------------
tabPanel("逻辑回归（1-0结果）",

titlePanel("逻辑回归"),

sidebarLayout(
sidebarPanel(

h4(tags$b("数据导入")),

##-------csv file-------##   
# Input: Select a file ----
fileInput("file.l", "上传 .csv 格式的数据集",
          multiple = TRUE,
          accept = c("text/csv",
                   "text/comma-separated-values,text/plain",
                   ".csv")),
helpText("如果没有上传数据，则显示示例数据(mtcars)."),
 # Input: Checkbox if file has header ----
checkboxInput("header.l", "标题行", TRUE),

fluidRow(

column(4, 
   # Input: Select separator ----
radioButtons("sep.l", "分隔符",
             choices = c(Comma = ",",
                         Semicolon = ";",
                         Tab = "\t"),
             selected = ",")),

column(4,
  # Input: Select quotes ----
radioButtons("quote.l", "引号",
             choices = c(None = "",
                         "Double Quote" = '"',
                         "Single Quote" = "'"),
             selected = '"'))
),
hr(),

##-------lr formula-------## 
h4(tags$b("回归式")),       
uiOutput('y.l'),    
uiOutput('x.l'),
uiOutput('fx.l'),
# select intercept
radioButtons("intercept.l", "截距",
             choices = c("删除截距" = "-1",
                         "保持截距" = ""),
             selected = "-1"),
h5("附加条件（混淆或相互作用）"), 
helpText("以“+”开始. 关于交互项，请键入+as.factor（cyl）*wt"), 
tags$textarea(id='conf.l', column=40, ""), 
p(br()),
actionButton("F.l", "首先：显示回归式"),
verbatimTextOutput("formula.l"),
helpText("'-1' 表示删除截距"),
hr(),

##-------Basic Plot -------## 
h4(tags$b("变量探索")),  
tags$b("1. 箱形图（逐组）"),   
fluidRow(
  column(6, uiOutput('ty.l')),
  column(6, uiOutput('tx.l'))),

h4(tags$b("")), 
plotOutput("p1.l", width = "400px", height = "400px"),
p(br()),

h4(tags$b("2. 直方图")), 
uiOutput('hx.l'),
plotOutput("p3.l", width = "400px", height = "400px"),
sliderInput("bin.l", "直方图中桶的宽度", min = 0.01, max = 5, value = 0.7)

), ## sidebarPanel(

mainPanel(

  h4(tags$b("结果")),
  tags$b("1. 显示数据"), 
  dataTableOutput("table.l"), 
  tags$b("2.  基本记述"), 
      helpText("选择描述的变量"),

      tabsetPanel(
        tabPanel("连续变量",
          uiOutput('cv.l'),
          actionButton("Bc.l", "Submit"),
          tableOutput("sum.l")
          ),
        tabPanel("离散变量",
          uiOutput('dv.l'),
          actionButton("Bd.l", "Submit"),
          verbatimTextOutput("fsum.l")
          )
        ),

  hr(),
  h4(tags$b("模型")),
  tabsetPanel(
    tabPanel("估计", 
      p(br()),
      actionButton("B1.l", "请在公式显示后提交"), 
      p(br()),
      tags$b("1. 回归拟合"), 
      htmlOutput("fit.l"),
      p(br()),
      tags$b("2. 方差分析ANOVA表"),
      tableOutput("anova.l")
      ),

    tabPanel("诊断",
      p(br()),
      tags$b("1. ROC图"),
      fluidRow(
      column(6, plotOutput("p2.l", width = "400px", height = "400px")),
      column(6, verbatimTextOutput("auc"))
      ),
      p(br()),
      tags$b("2. 估计拟合值"), 
      dataTableOutput("fitdt")
      ),

    tabPanel("预测", 
      p(br()),
      #prediction part
        ##-------csv file for prediction -------##   
      # Input: Select a file ----
      fileInput("newfile.l", "上传 .csv 格式的新数据集",
                multiple = TRUE,
                accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),

       # Input: Checkbox if file has header ----
      checkboxInput("newheader.l", "标题行", TRUE),

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
      radioButtons("newquote.l", "引号",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'))

      ),
      actionButton("B2.l", "请在模型评估后提交"), 
      p(br()),
      tags$b("1. 数据和预测结果一同显示"), 
      p(br()),
      dataTableOutput("preddt.l"),
      p(br()),
      tags$b("2. 预测结果的ROC图"),
      uiOutput('px.l'),
      fluidRow(
        column(6, plotOutput("p4.l", width = "400px", height = "400px")),
        column(6, verbatimTextOutput("auc2")))
      ) ##  tabPanel("Prediction"
    ) ## tabsetPanel(
) ## mainPanel(
) ## sidebarLayout(
), ## tabPanel(

##----------------------------------------------------------------------
## 3. cox regression---------------------------------------------------------------------------------
tabPanel("Cox回归（时间-事件结果）",

titlePanel("Cox回归"),

sidebarLayout(

sidebarPanel(

  h4(tags$b("数据导入")),

  ##-------csv file-------##   
  # Input: Select a file ----
  fileInput("file.c", "上传 .csv 格式的数据集",
            multiple = TRUE,
            accept = c("text/csv",
                     "text/comma-separated-values,text/plain",
                     ".csv")),
  helpText("如果没有上传数据，则显示示例数据(mtcars)."),
   # Input: Checkbox if file has header ----
  checkboxInput("header.c", "标题行", TRUE),

  fluidRow(

  column(4, 
     # Input: Select separator ----
  radioButtons("sep.c", "分隔符",
               choices = c(Comma = ",",
                           Semicolon = ";",
                           Tab = "\t"),
               selected = ",")),

  column(4,
    # Input: Select quotes ----
  radioButtons("quote.c", "引号",
               choices = c(None = "",
                           "Double Quote" = '"',
                           "Single Quote" = "'"),
               selected = '"'))
  ), 
  hr(),
  ##<<-----------------------------<<

  ##>>---------cox formula---------->>
  uiOutput('t1.c'),
  uiOutput('t2.c'),
  uiOutput('c.c'),    
  uiOutput('x.c'),
  uiOutput('fx.c'),
  uiOutput('sx.c'),
  uiOutput('clx.c'),

  h5("附加条件（混淆或相互作用）"), 
  helpText("以“+”开始. 关于交互项，请键入+as.factor（cyl）*wt"), 
  tags$textarea(id='conf.c', cols=40, " " ), 
  p(br()),
  actionButton("F.c", "首先：创建回归式"),
  verbatimTextOutput("formula.c"),
  hr(),

  # K-M plot##-------Basic Plot -------## 
  h4(tags$b("变量探索")),  
  actionButton("Y.c", "请在回归式生成后作图"),
  p(br()),
  tags$b("1. K-M生存图（空模型）"), 
  helpText("式: Surv(time, status)~1 "),
  plotOutput("p0.c", width = "400px", height = "400px"),

  tags$b("2. K-M生存图（逐组）"), 
  helpText("式: Surv(time, status) ~ group"),
  uiOutput('tx.c'),
  plotOutput("p1.c", width = "400px", height = "400px"),

  tags$b("3. 直方图"), 
  uiOutput('hx.c'),
  plotOutput("p3.c", width = "400px", height = "400px"),
  sliderInput("bin.c", "直方图中桶的宽度", min = 0.01, max = 5, value = 0.7)

), ## sidebarPanel(

mainPanel( 
  h4(tags$b("结果")),
  tags$b("1. 显示数据"), 
  dataTableOutput("table.c"), 
  tags$b("2. 基本记述"), 
      helpText("选择描述的变量"),
      tabsetPanel(
        tabPanel(
          "连续变量",
          uiOutput('cv.c'),
          actionButton("Bc.c", "Submit"),
          tableOutput("sum.c")
          ),
        tabPanel(
          "离散变量",
          uiOutput('dv.c'),
          actionButton("Bd.c", "Submit"),
          verbatimTextOutput("fsum.c")
          )
        ),
  hr(),
  h4(tags$b("模型")),
  tabsetPanel(

    tabPanel("估计", 
      p(br()),
      actionButton("B1.c", "请在回归式显示后提交"),
      p(br()),
      tags$b("1. 回归拟合"), htmlOutput("fit.c"),
      p(br()),
      tags$b("2. 方差分析ANOVA表"), tableOutput("anova.c")
      ),
    tabPanel("诊断", 
      p(br()),
      tags$b("1. 检查持续危险比随时间的变化"),
      tableOutput("zph.c"), 
      plotOutput("p2.c",width = "500px", height = "500px"),
      tags$b("2. 诊断图"), 
      radioButtons("res.c", "Residual type",
               choices = c("Martingale" = "martingale",
                           "Deviance" = "deviance",
                           "Cox-Snell" = "Cox-Snell"),
               selected = "martingale") ,
      plotOutput("p4.c", width = "400px", height = "400px"),
      tags$b("3. 估计拟合值"), 
      dataTableOutput("fitdt.c")
     ),
    tabPanel("预测", 
      p(br()),
      #prediction part
      ##-------csv file for prediction -------##   
      # Input: Select a file ----
      fileInput("newfile.c", "上传 .csv 格式的新数据集",
                multiple = TRUE,
                accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),

       # Input: Checkbox if file has header ----
      checkboxInput("newheader.c", "标题行", TRUE),

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
      radioButtons("newquote.c", "引号",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'))

      ),
      actionButton("B2.c", "请在模型评估后提交"), 
      p(br()),
      tags$b("1. 数据和预测结果一同显示"), 
      p(br()),
      dataTableOutput("pred.c"),
      tags$b("2. 预测结果的诊断图"), 
      plotOutput("p6.c", width = "400px", height = "400px")
      )
    ) ##tabsetPanel(
) ## mainPanel(

) ## sidebarLayout(

) ## tabPanel(

,
  tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止")
)


)
##-----------------------over
)
)


