##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyUI(
tagList(
#shinythemes::themeSelector(),
source("../0tabs/font_cn.R",local=TRUE, encoding="UTF-8")$value,
navbarPage(
 
  title = "计数列联表",

##---------- Panel 1 ----------
tabPanel("卡方检验（R × C 表）",

titlePanel("卡方检验"),

HTML("
<b> 注 </b>

<ul>

<li> RXC列联表是具有R行（R类）和C列（C类）的表
<li> 用来确定两个离散变量之间是否存在显著关系，其中一个变量具有R类别，另一个变量具有C类别

</ul>

<b> 前提假设 </b>

<ul>

<li> 不超过行列单元格子总数的1/5格子的期望值小于5
<li> 不存在单元的期望值＜1的格子

</ul>

  "),

p(br()),
sidebarLayout(

sidebarPanel(

  h4("参数设置"),
  numericInput("r", "行数, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("行名称"), 
  tags$textarea(id="rn", rows=4, cols = 30, "R1\nR2"),
  helpText("行名的个数必须对应行数")),
  numericInput("c", "列数, C", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("列名称"),
  tags$textarea(id="cn", rows=4, cols = 30, "C1\nC2"),
  helpText("行名的个数必须对应行数")),
  hr(),

  h4("数据输入"),
  helpText("按列输入值，例如，第二列跟随第一列."),
  tags$textarea(id="x", rows=10, "10\n20\n30\n35")
    ),

mainPanel(

h4("卡方检验的结果"), 
tableOutput("c.test"),
hr(),

h4("列联表的描述统计"),
tabsetPanel(

tabPanel("列联表", p(br()),
  dataTableOutput("ct")
  ),

tabPanel("百分比", p(br()),
  h4("行的百分比"), tableOutput("prt"),
  h4("列的百分比"), tableOutput("pct"),
  h4("总体的百分比"), tableOutput("pt")
  ),

tabPanel("期望值", p(br()),
  tableOutput("c.e")
  ),

tabPanel("频数的条形图", p(br()),
  plotOutput("makeplot", width = "800px", height = "400px")
  )
  )
  )
)
),


##---------- Panel 2 ----------

tabPanel("趋势检验 (2 x K 表)",

titlePanel("趋势检验"),


p("用来检验比例的增加或减少趋势"),

p(br()),
sidebarLayout(

sidebarPanel(

h4("数据准备"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手动输入", p(br()),
    helpText("如有缺失值，请输入NA"),
    tags$textarea(id="suc", rows=10, "320\n1206\n1011\n463\n220"),
    tags$textarea(id="fail", rows=10, "1422\n4432\n2893\n1092\n406")), 
    helpText("案例数据（case）请输入到左边，而对比数据（control）输入到右边"),

  ##-------csv file-------##   
  tabPanel("上传CSV文件", p(br()),
    fileInput('file2', '选择CSV文件', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', '第一行为变量名', TRUE),
    radioButtons('sep', '分隔符', c(Comma=',', Semicolon=';', Tab='\t'), ',')))),

  mainPanel(

h4("结果"), 
tableOutput("tr.test"),
hr(),

  h4("列联表的描述统计"),
  tabsetPanel(
    tabPanel("列联表", p(br()),
      dataTableOutput("ct.tr"),
      helpText("注: 百分比 = 事件数/总数")
      ),

    tabPanel("百分比趋势的条形图",
    plotOutput("makeplot.tr", width = "800px", height = "400px")
      )
    )
  )
  )
),

##---------- Panel 3 ----------

tabPanel("Kappa 统计量 (K x K 表)",

titlePanel("Kappa Statistic"),

p("这是自由度相关的定量研究，特别适用于研究人员希望对同一变量的重现性进行多次测量时的可靠性分析"),

sidebarLayout(
sidebarPanel(

h4("参数设置"),
  numericInput("r.k", "两个调查的共通评价数, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("评价名称"), 
  tags$textarea(id="rater", rows=4, cols = 30, "Yes\nNo")),

h4("数据输入"),
  tabPanel("手动输入",
  tags$textarea(id="k", rows=10, "136\n69\n92\n240")),
  helpText("按列输入计数，例如，第二列跟随第一列")

  ),

mainPanel(

  h4("结果"), tableOutput("k.test"),
  tags$b("Notes"),
  HTML("
  <ul>
  <li> k > 0.75 表示优良的重现性. </li>
  <li> 0.4 < k < 0.75 表示良好的再现性.</li>
  <li> 0 < k < 0.4 表示微弱的再现性.</li>
  </ul>" ),

  hr(),
  h4("列联表"), dataTableOutput("kt"),
  HTML("
    <b> 注</b>
    <ul>
    <li> 行是度量A，而列是度量B
    <li> 最后一行是总数
    </ul>
    ")
  )

)),
##---------- other panels ----------

source("../0tabs/home_cn.R",local=TRUE)$value,
source("../0tabs/stop_cn.R",local=TRUE)$value


))
)

