#****************************************************************************************************************************************************spls
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#spls {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#spls_cv {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; max-height: 200px; background: white};")),

h4(tags$b("模型构建")),
p("使用上一个页面（“数据”选项卡）准备数据。"),
hr(),      

h4(tags$b("第1步 选择参数建立模型")),    

uiOutput('y.s'), 
uiOutput('x.s'), 


numericInput("nc.s", "3.  有多少新成分？（A，选择的数值越大，变量越多）", 3, min = 1, max = NA),
numericInput("nc.eta", "4. 选择范围的参数（选择的数值越大，变量越少）", 0.5, min = 0, max = 1, step=0.1),

radioButtons("method.s", "5. 哪种PLS算法？",
  choices = c("SIMPLS：简单快捷" = 'simpls',
           "核算法(kernel)" = "kernelpls",
           "宽核算法(wide kernel)" = "widekernelpls",
           "传统正交分数算法" = "oscorespls"),
selected = 'simpls'),

shinyWidgets::prettySwitch(
   inputId = "scale.s",
   label = tags$b("数据scaling?"), 
   value=TRUE,
   status = "info",
   fill = TRUE
  ),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("稀疏偏最小二乘回归添加了惩罚项，可以进行变量选择。 惩罚项可以选择适合用于预测的变量。 成分基于所选变量而生成。")),
p(tags$i("在NKI数据示例中，时间用作因变量（Y），而TSPYL5 ...等变量都用作自变量。
默认情况下，除Y以外的所有变量都放在X中。 因此，这里需要删除变量Diam和Age。")),
p(tags$i("数据选项卡显示X是20x25矩阵，因此a的最大值是19。如果A = 20，则会发生错误。"))
),

hr(),

h4(tags$b("第2步 如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),
#actionButton("spls1", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("spls1", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. 数据确认")),

tabsetPanel(

tabPanel("SPLS　交叉验证", p(br()),
p("从以下范围中选择最佳参数。"),
numericInput("cv.s", "最大新成分（默认值：1至10）", 10, min = 1, max = NA),
numericInput("cv.eta", "选择范围的参数（数值越大，选择的变量越少，默认值：0.1至0.9)", 0.9, min = 0, max = 1, step=0.1),
#p("This result chooses optimal parameters using 10-fold cross-validation which split data randomly, so the result will not be exactly the same every time."),
p("交叉验证将根据最小误差选择参数，给出参数选择的建议。"),
actionButton("splscv", (tags$b("查看交叉验证的结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
verbatimTextOutput("spls_cv")
  ),
tabPanel("数据（一部分）", br(),
 p("请在“数据”选项卡中编辑修改数据"),
DT::DTOutput("spls.x")
)
),

hr(),
#actionButton("spls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 1. 模型的结果")),

tabsetPanel(
tabPanel("选择",p(br()),
verbatimTextOutput("spls"),
p(br()),
p(tags$b("选择的变量")),
DT::DTOutput("spls.sv")
),

tabPanel("数据拟合",p(br()),
p(tags$b("Y的预测值")),
DT::DTOutput("spls.pres"),
p(br()),
p(tags$b("该图显示了由于选择变量而导致的系数变化。")),
numericInput("spls.y", "绘图的因变量（第N个因变量）", 1, min = 1, step=1),
plotOutput("spls.bp"),
p(tags$b("系数")),
DT::DTOutput("spls.coef")

),

tabPanel("成分", p(br()),
	p("这是根据所选变量派生的成分"),
	  HTML("
<b>说明</b>
<ul>
<li> 此图描绘了两个得分的成分关系，可使用得分图来评估数据结构并检测群集、离群值和趋势。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
</ul>
  "),
    hr(),
uiOutput("g.s"),
uiOutput("type.s"),
p(tags$b("当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c1.s", "1. x轴成分", 1, min = 1, max = NA),
numericInput("c2.s", "2. y轴成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在此图中，我绘制了component1和component2的散点图，发现378是离群值。"))
),

	plotly::plotlyOutput("spls.s.plot"),
  DT::DTOutput("spls.s")
  ),

tabPanel("负载量", p(br()),
  p(tags$b("是根据所选变量得出的负载")),
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
	plotly::plotlyOutput("spls.l.plot"),
  DT::DTOutput("spls.l")
  ),

tabPanel("成分和载荷的2D图", p(br()),
  p(tags$b("这是根据所选变量得出的负载")),
    HTML("
<b>说明</b>
<ul>
<li> 此图叠加了主成分和载荷量（选择左面板中的主成分）。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
<li> 载荷测定哪些成分对每个成分的影响最大。</li>
<li> 载荷范围从-1到1。接近-1或1的载荷表示变量对成分的影响很大。接近0的载荷表示变量对成分的影响很小。</li>
</ul>
  "),
    hr(),
p(tags$b("当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c11.s", "1. x轴成分", 1, min = 1, max = NA),
numericInput("c22.s", "2. y轴成分", 2, min = 1, max = NA),
  plotly::plotlyOutput("spls.biplot")
  ),

tabPanel("成分和载荷的3D图" ,p(br()),
  HTML("
<b>説说明</b>
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
numericInput("td1.s", "1. x轴成分", 1, min = 1, max = NA),
numericInput("td2.s", "2. y轴成分", 2, min = 1, max = NA),
numericInput("td3.s", "3. z轴成分", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines.s", "4. （可选） 变更线段（line scale）长度", 2, min = 1, max = NA),
plotly::plotlyOutput("tdplot.s"),
p(tags$b("跟踪图例")),
verbatimTextOutput("tdtrace.s")
)
)

)

)