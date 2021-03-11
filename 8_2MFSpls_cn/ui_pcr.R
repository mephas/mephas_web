#****************************************************************************************************************************************************pcr
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#pcr {overflow-y:scroll; background: white};")),
tags$head(tags$style("#pcr_r {overflow-y:scroll; background: white};")),
tags$head(tags$style("#pcr_rmsep {overflow-y:scroll;background: white};")),
tags$head(tags$style("#pcr_msep {overflow-y:scroll; background: white};")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; height: 200px; background: white};")),

h4(tags$b("模型构建")),
p("使用上一个页面（“数据”选项卡）准备数据。"),
hr(),    

h4(tags$b("第1步 选择参数建立模型")),    

uiOutput('y'), 
uiOutput('x'), 

numericInput("nc", "3. 有多少新成分？（A<=X的维度）", 3, min = 1, max = NA),
#p("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),
radioButtons("val", "4. 做交叉验证？",
choices = c("不，使用完整数据" = 'none',
           "10倍交叉验证" = "CV",
           "留一交叉验证" = "LOO"),
selected = 'CV'),

shinyWidgets::prettySwitch(
   inputId = "scale",
   label = tags$b("数据scaling?"), 
   value=TRUE,
   status = "info",
   fill = TRUE
  ),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在NKI数据示例中，时间用作因变量（Y），而TSPYL5 ...等变量都用作自变量。
  默认情况下，除Y以外的所有变量都放在X中。 因此，这里需要删除变量Diam和Age。")),
p(tags$i("数据选项卡显示X是20x25矩阵，因此a的最大值是19。如果A = 20，则会发生错误。")),
p(tags$i("这里使用10倍交叉验证来查看训练集和CV/验证集的结果。"))
),

hr(),

h4(tags$b("第2步 如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),
#actionButton("pcr1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pcr1", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. 数据确认")),
p(tags$b("数据（一部分）")),
 p("请在“数据”选项卡中编辑修改数据"),
DT::DTOutput("pcr.x"),

hr(),
#p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
#sactionButton("pcr1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. 模型的结果")),

tabsetPanel(

tabPanel("主成分回归的结果",p(br()),
HTML(
"
<b>说明</b>

<ul>
<li> 给出1成分、2成分、...、n成分的计算结果。</li>
<li> “CV”是交叉验证估计值。</li>
<li> “adjCV”（对于RMSEP和MSEP）是经偏差校正的交叉验证估计值。</li>
<li> R^2等同于拟合值与响应之间的平方相关。训练中所示的R^2为未调整的R^2，而CV中所示的R^2为调整后的R^2。</li>
<li> 建议使用高R^2和低MSEP/RSMEP的成分数量。</li>
</ul>
"
),
p("10倍交叉验证每次都将数据随机拆分成10倍，所以一次刷新后结果不会完全一样。"),
hr(),
verbatimTextOutput("pcr"),
p(tags$b("R^2")),
verbatimTextOutput("pcr_r"),
p(tags$b("预测的均方误差 (MSEP)")),
verbatimTextOutput("pcr_msep"),
p(tags$b("预测的均方根误差 (RMSEP)")),
verbatimTextOutput("pcr_rmsep"),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("结果表明，随着A的增加，训练效果更好（R ^ 2较高，MSEP和RMSEP较低）。")),
p(tags$i("然而，CV结果是不同的。 训练集的效果很好，CV很差，可能发生过拟合并且预测性较差。")),
p(tags$i("在此示例中，我们决定根据MSEP和RMSEP选择三个成分（A = 3）。"))
)

),

tabPanel("数据拟合",p(br()),

p(tags$b("1. 预测的Y和残差（Y-预测的Y）")),
DT::DTOutput("pcr.pres"),br(),
p(tags$b("系数")),
DT::DTOutput("pcr.coef")
#  p(tags$b("Residuals table (= predicted dependent variable - dependent variable)")),
#DT::DTOutput("pcr.resi")
),

tabPanel("成分", p(br()),
HTML("
<b>说明</b>
<ul>
<li> 此图描绘了两个得分的成分关系，可使用得分图来评估数据结构并检测群集、离群值和趋势。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
</ul>
  "),
hr(),
uiOutput("g"),
uiOutput("type"),
p(tags$b("当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c1", "1. x轴成分", 1, min = 1, max = NA),
numericInput("c2", "2. y轴成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在此图中，我绘制了component1和component2的散点图，发现327和332是离群值。"))
),

plotly::plotlyOutput("pcr.s.plot"),
DT::DTOutput("pcr.s")
  ),

tabPanel("负载量", p(br()),
HTML("
<b>说明</b>
<ul>
<li> 此图显示变量对成分的影响（选择左面板中的成分）。</li>
<li> 红色表示负面影响，蓝色表示正面影响。</li>
<li> 使用方差累积比例（在方差表中）测定因子解释的方差量。</li>
<li> 出于描述的目的，可能只需要解释80%（0.8）的差异。</li>
<li> 如果想对数据执行其他分析，可能至少要有90%的方差通过因子解释。</li>
</ul>
  "),
hr(),
  plotly::plotlyOutput("pcr.l.plot"),
  DT::DTOutput("pcr.l")
  ),

tabPanel("成分和载荷的2D图", p(br()),
HTML("
<b>说明</b>
<ul>
<li> 此图叠加了主成分和载荷量（选择左面板中的主成分）。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
<li> 载荷测定哪些成分对每个成分的影响最大。</li>
<li>载荷范围从-1到1。接近-1或1的载荷表示变量对成分的影响很大。接近0的载荷表示变量对成分的影响很小。</li>
</ul>

  "),
hr(),
p(tags$b("当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c11", "1. x轴成分", 1, min = 1, max = NA),
numericInput("c22", "2. y轴成分", 2, min = 1, max = NA),
plotly::plotlyOutput("pcr.bp")
  ),

tabPanel("成分和载荷的3D图" ,p(br()),
HTML("
<b>说明</b>
<ul>
<li> 这是2D图的扩展。此图覆盖了3个成分和载荷（在左面板中选择主成分和线段长度）。</li>
<li> 该图与2D图具有相同的功能。 跟踪是可以通过单击隐藏的变量。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
<li> 载荷测定哪些成分对每个成分的影响最大。</li>
<li> 载荷范围从-1到1。接近-1或1的载荷表示变量对成分的影响很大。接近0的载荷表示变量对成分的影响很小。</li>
</ul>
  "),
hr(),

p(tags$b("本图首次加载需要一些时间。")),
p(tags$b("当A >= 3时，选择3个成分显示成分和载荷3D图")),
numericInput("td1", "1. x轴成分", 1, min = 1, max = NA),
numericInput("td2", "2. y轴成分", 2, min = 1, max = NA),
numericInput("td3", "3. z轴成分", 3, min = 1, max = NA),

numericInput("lines", "4. （可选） 变更线段（line scale）长度", 20, min = 1, max = NA),
plotly::plotlyOutput("tdplot"),
p(tags$b("跟踪图例")),
verbatimTextOutput("tdtrace")
)
)

)

)