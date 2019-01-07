##----------------------------------------------------------------
##
## Chi-square test  ui CN
##
## 2018-11-30
## 
##----------------------------------------------------------------

shinyUI(
tagList(
#shinythemes::themeSelector(),
navbarPage(
 
  title = "计数列联表",

## 1. Chi-square test for 2 by 2 table ---------------------------------------------------------------------------------
tabPanel("卡方检验（R×C表）",

titlePanel("卡方检验"),

tags$b("介绍"),

p("RXC列联表是具有R行（R类）和C列（C类）的表."),
p("用来确定两个离散变量之间是否存在显著关系，其中一个变量具有R类别，另一个变量具有C类别. "),

tags$b("前提假设"),
tags$ul(
  tags$li("不超过1/5的单元的期望值＜5."),
  tags$li("没有单元的期望值＜1.")
  ),

p(br()),
sidebarLayout(

sidebarPanel(

  helpText("表格设置"),
  numericInput("r", "行数, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("行名称"), 
  tags$textarea(id="rn", rows=4, cols = 30, "R1\nR2"),
  helpText("行名的个数必须对应行数.")),
  numericInput("c", "列数, C", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("列名称"),
  tags$textarea(id="cn", rows=4, cols = 30, "C1\nC2"),
  helpText("列名的个数必须对应行数."))
  
  ),

mainPanel(
  wellPanel(
  h4(tags$b("数据输入")),
  helpText("按列输入值，例如，第二列跟随第一列."),
  tabPanel("Manually input values",
  tags$textarea(id="x", rows=10, "10\n20\n30\n35"))),
  hr(),
  h4("显示列联表"), dataTableOutput("ct"),
  hr(),
  h3(tags$b("卡方检验的结果")), tableOutput("c.test"),
  tags$b("每个单元的期望值"),
  tableOutput("c.e"),
  #tags$b("Interpretation"), p("The meaning"),
  hr(),
  h3(tags$b("百分比")),
  h4("行的百分比"), tableOutput("prt"),
  h4("列的百分比"), tableOutput("pct"),
  h4("总体的百分比"), tableOutput("pt"),
  hr(),
  h3(tags$b('频率条形图（计数）')), plotOutput("makeplot", width = "600px", height = "300px")))),

## 2. Chi-square test for Test for Trend ---------------------------------------------------------------------------------
tabPanel("趋势检验（2×K表）",

titlePanel("趋势检验"),

tags$b("介绍"),

p("用来确定比例的增加或减少趋势."),

p(br()),
sidebarLayout(

sidebarPanel(
helpText("两种方法导入您的数据"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手动输入", p(br()),
    helpText("如有缺失值，请输入NA"),
    tags$textarea(id="suc", rows=10, "320\n1206\n1011\n463\n220"),
    tags$textarea(id="fail", rows=10, "1422\n4432\n2893\n1092\n406")), 
    helpText("案例数据（case）请输入到左边，而对比数据（control）输入到右边."),

  ##-------csv file-------##   
  tabPanel("上传 .csv 格式文件", p(br()),
    fileInput('file2', '选择 .csv 格式文件', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    #checkboxInput('header', '标题行', TRUE),
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')))),

  mainPanel(
  h4("显示列联表"), dataTableOutput("ct.tr"),
  helpText("注：百分比为案例/总数"),
  hr(),
  h3(tags$b("趋势测试的结果，案例百分比")), tableOutput("tr.test"),
  #tags$b("Interpretation"), p("The meaning"),
  hr(),
  h3(tags$b('案例百分比条形图')), plotOutput("makeplot.tr", width = "600px", height = "300px"))
  )),

## 3. Goodness-of-Fit Test, kappa ---------------------------------------------------------------------------------
tabPanel("Kappa统计量（K × K 表）",

titlePanel("Kappa统计量"),

tags$b("介绍"),

p("这是自由度相关的定量研究，特别适用于研究人员希望对同一变量的重现性进行多次测量时的可靠性分析"),

sidebarLayout(
sidebarPanel(

helpText("表格设置"),
  numericInput("r.k", "两个调查的共通评价数, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("评价名称"), 
  tags$textarea(id="rater", rows=4, cols = 30, "Yes\nNo"))),

mainPanel(
  h4(tags$b("数据导入")),
  helpText("按列输入计数，例如，第二列跟随第一列"),
  tabPanel("手动输入",
  tags$textarea(id="k", rows=10, "136\n69\n92\n240")),
  hr(),
  h4("显示列联表"), dataTableOutput("kt"),
  helpText("行是度量A，而列是度B."),
  hr(),
  h3(tags$b("统计量的结果, k")), tableOutput("k.test"),
  tags$b("Notes"),
  HTML("
  <ul>
  <li> k > 0.75 表示优良的重现性. </li>
  <li> 0.4 < k < 0.75 表示良好的再现性.</li>
  <li> 0 < k < 0.4 表示微弱的再现性.</li>
  </ul>" )

  #tags$b("Interpretation"), p("The meaning")
  )

))
,
  tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止")
),
tabPanel(
     tags$button(
     id = 'close',
     type = "button",
     class = "btn action-button",
     onclick ="window.open('https://pharmacometrics.info/mephas/index_jp.html')","主页"))

))
)

