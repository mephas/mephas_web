#****************************************************************************************************************************************************pca

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; max-height: 150px; background: white};")),

h4(tags$b("模型构建")),
p("使用上一个页面（“数据”选项卡）准备数据。"),
p("变量数（列）应小于样本数（行）"),
p(tags$i("这里的示例数据是化学数据")),
hr(),       

h4(tags$b("第1步  选择参数建立模型")),    

uiOutput('x'), 

numericInput("nc", "2. 有多少成分（A < X维度）", 3, min = 1, max = NA),

hr(),

h4(tags$b("第2步  如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),
#actionButton("pca1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pca1", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),

mainPanel(

h4(tags$b("Output 1. 数据确认")),
#tabsetPanel(
#tabPanel("Parallel Analysis", p(br()),
#plotOutput("pc.plot", ),
#verbatimTextOutput("pcncomp")
#),
#tabPanel("Correlation Matrix", p(br()),
#plotOutput("cor.plot", ),p(br()),
#DT::DTOutput("cor")
#),

tags$b("数据（一部分）"),
 p("请在“数据”选项卡中编辑修改数据"),
DT::DTOutput("table.x"),
#)

#  ),

hr(),
h4(tags$b("Output 2. 模型的结果")),
#actionButton("pca1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 #p(br()),

tabsetPanel(

tabPanel("主成分分析结果", p(br()),
  HTML("
<b>说明</b>
<ul>
<li>此图描绘了两个成分的成分关系，可使用得分图来评估数据结构并检测群集、离群值和趋势。</li>
<li>图上的数据分组可表示数据中的两个或多个单独分布。</li>
<li>如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
</ul>
  "),
  hr(),

uiOutput('g'), 
uiOutput('type'),

p(tags$b("2. 当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c1", "2.1. x轴成分", 1, min = 1, max = NA),
numericInput("c2", "2.2. y轴成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("在PC1和PC2（无组圈）图中，我们能够找到一些离群值，例如11和23。
如果选择饮食，并在欧几里得距离上添加一个组圆，则将看到饮食类型的圆与其他圆分开。")
),
plotly::plotlyOutput("pca.ind", ),
DT::DTOutput("comp")
  ),

tabPanel("负载量", p(br()),
    HTML("
<b>说明</b>
<ul>
<li> 此图显示变量对主成分的影响（选择左面板中的主成分）。</li>
<li> 红色表示负面影响，蓝色表示正面影响。</li>
<li> 使用方差累积比例（在方差表中）测定因子解释的方差量。</li>
<li> 出于描述的目的，可能只需要解释80%（0.8）的差异。</li>
<li> 如果想对数据执行其他分析，可能至少要有90%的方差通过因子解释。</li>
</ul>
  "),
    hr(),
  plotly::plotlyOutput("pca.ind2", ),
  p(tags$b("Loadings")),
  DT::DTOutput("load"),
  p(tags$b("Variance table")),
  DT::DTOutput("var")
  ),
tabPanel("主成分和载荷的2D图" ,p(br()),
    HTML("
<b>说明</b>
<ul>
<li> 此图叠加了主成分和载荷量（选择左面板中的主成分）。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布.</li>
<li> 载荷测定哪些成分对每个成分的影响最大。</li>
<li> 载荷范围从-1到1。接近-1或1的载荷表示变量对成分的影响很大。接近0的载荷表示变量对成分的影响很小。</li>
</ul>

  "),
    hr(),
p(tags$b("•	当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c11", "2.1. x轴成分", 1, min = 1, max = NA),
numericInput("c22", "2.2. y轴成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("PC1和PC2图显示，ACAT2对PC1具有相对较强的负面影响，而PKD4对PC1具有较强的正面影响。 对于PC2，THIOL具有很强的积极作用，而VDR具有很强的消极作用。
结果与载荷图相对应。")
),

plotly::plotlyOutput("pca.bp", )

),

tabPanel("主成分和载荷的3D图" ,p(br()),
HTML("
  <b>说明</b>
<ul>
<li> 这是2D图的扩展。此图覆盖了3个主成分和载荷（在左面板中选择主成分和线段长度）。</li>
<li> 可找到图中的离群值。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
<li> 载荷测定哪些成分对每个成分的影响最大。</li>
<li> 载荷范围从-1到1。接近-1或1的载荷表示变量对成分的影响很大。接近0的载荷表示变量对成分的影响很小。</li>
</ul>

  "),
hr(),
p(tags$b("本图首次加载需要一些时间")),
p(tags$b("当A >= 3时，选择3个成分显示成分和载荷3D图")),
p(tags$i("默认情况下，在3D绘图中显示前3个PC")),
numericInput("td1", "1. x轴成分", 1, min = 1, max = NA),
numericInput("td2", "2. y轴成分", 2, min = 1, max = NA),
numericInput("td3", "3. z轴成分", 3, min = 1, max = NA),

numericInput("lines", "4. （可选） 变更线段（line scale）长度", 10, min = 1, max = NA),
plotly::plotlyOutput("tdplot"),
p(tags$b("跟踪图例")),
verbatimTextOutput("tdtrace")
)
)

)

)