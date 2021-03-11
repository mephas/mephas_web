#****************************************************************************************************************************************************fa

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x_fa {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#fa {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#tdtrace.fa {overflow-y:scroll; height: 150px; background: white};")),

h4(tags$b("模型构建")),
p("使用上一个页面（“数据”选项卡）准备数据。"),
p("变量数（列）应小于样本数（行）。"),
p(tags$i("这里的示例数据是小鼠。")),


hr(),     

h4(tags$b("第1步 选择参数建立模型")),    

uiOutput('x.fa'), 

numericInput("ncfa", "2. 因子数（A < X维度）", 3, min = 1, max = NA),
p(tags$i("根据平行分析的建议结果，我们从数据中生成3个因子。")),
hr(),
h4(tags$b("第2步 如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),

#actionButton("pca1.fa", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pca1.fa", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. 数据确认")),

tags$b("数据（一部分）"),
p("请在“数据”选项卡中编辑修改数据"),
DT::DTOutput("table.x.fa"),

hr(),

h4(tags$b("Output 2. 模型的结果")),
#actionButton("pca1.fa", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
# p(br()),

tabsetPanel(
tabPanel("因子分析结果",p(br()),
    HTML("
<b>说明</b>
<ul>
<li> 该图显示了因子与变量之间的关系。</li>
<li> 窗口中的结果显示对因子充分性的统计检验。</li>
</ul>

  "),
    hr(),
  plotOutput("pca.ind.fa"),
  verbatimTextOutput("fa")),

tabPanel("因子", p(br()),
HTML("
<b>说明</b>
<ul>
<li>该图描绘了两个因子之间的关系，可使用得分图评估数据结构并检测群集、离群值和趋势。</li>
<li>图上的数据分组可表示数据中的两个或多个单独分布。</li>
<li>如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
</ul>
"),
hr(),

uiOutput('g.fa'), 
uiOutput('type.fa'),
p(tags$b("2. 当A >= 2时，选择2个因子显示成分和载荷2D图")),
numericInput("c1.fa", "2.1. x轴因子", 1, min = 1, max = NA),
numericInput("c2.fa", "2.2. y轴因子", 2, min = 1, max = NA),
conditionalPanel(
condition = "input.explain_on_off",
tags$i("在ML1和ML2图中，我们可以找到169和208等异常值。 这些点可以在“数据”选项卡上删除。
当我选择类型并在欧几里得距离上加上一个圆组时，我发现B组稍有不同。 并非所有组都有圈子，因为积分太少。")
),
plotly::plotlyOutput("fa.ind", ),

DT::DTOutput("comp.fa")
  ),

tabPanel("负载量", p(br()),
	    HTML("
<b>说明</b>
<ul>
<li> 此图显示变量对因子的影响（选择左面板中的因子）。</li>
<li> 红色表示负面影响，蓝色表示正面影响。</li>
<li> 使用方差比例（在方差表中）测定因子解释的方差量。</li>
<li> 出于描述的目的，可能只需要解释80%（0.8）的差异。</li>
<li> 如果想对数据执行其他分析，可能至少要有90%的方差通过因子解释。</li>
</ul>

  "),
      hr(),
	plotly::plotlyOutput("pca.ind.fa2"),
	p(tags$b("Loadings")),
  DT::DTOutput("load.fa"),
  p(tags$b("Variance table")),
  DT::DTOutput("var.fa")  ),

tabPanel("因子和载荷的2D图" ,p(br()),
    HTML("
<b>说明</b>
<ul>
<li> 此图（双线图）覆盖因子和载荷（选择左面板中的因子）。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
<li> 载荷测定哪些成分对每个成分的影响最大。。</li>
<li> 载荷范围从-1到1。接近-1或1的载荷表示变量对成分的影响很大。接近0的载荷表示变量对成分的影响很小。</li>
</ul>
  "),
    hr(),
p(tags$b("当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c1.fa", "1. x轴因子", 1, min = 1, max = NA),
numericInput("c2.fa", "2. y轴因子", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("在删除点169和208之后，发现chem2与ML2有着相对较强的关系。")
),

plotly::plotlyOutput("fa.bp")

),

tabPanel("因子和载荷的3D图" ,p(br()),
HTML("
  <b>説明</b>
<ul>
<li> 这是2D图的扩展。此图覆盖了3个因子和载荷（在左面板中选择因子和线段长度）。</li>
<li> 可找到图中的离群值。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
<li> 载荷测定哪些成分对每个成分的影响最大。</li>
<li> 载荷范围从-1到1。接近-1或1的载荷表示变量对成分的影响很大。接近0的载荷表示变量对成分的影响很小。</li>
</ul>

  "),
hr(),
p(tags$b("本图首次加载需要一些时间。")),
p(tags$b("当A >= 3时，选择3个成分显示成分和载荷3D图")),
p(tags$i("默认情况下，在3D绘图中显示前3个因子。")),
numericInput("td1.fa", "1. x轴因子", 1, min = 1, max = NA),
numericInput("td2.fa", "2. y轴因子", 2, min = 1, max = NA),
numericInput("td3.fa", "3. z轴因子", 3, min = 1, max = NA),

numericInput("lines.fa", "4. （可选） 变更线段（line scale）长度", 10, min = 1, max = NA),
plotly::plotlyOutput("tdplot.fa"),
p(tags$b("跟踪图例")),
verbatimTextOutput("tdtrace.fa")
)

)

)
)