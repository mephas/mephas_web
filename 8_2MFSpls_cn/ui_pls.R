#****************************************************************************************************************************************************plsr
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#pls {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_r {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_rmsep {overflow-y:scroll;max-height: 300px; background: white};")),
tags$head(tags$style("#pls_msep {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_tdtrace {overflow-y:scroll; max-height: 200px; background: white};")),


h4(tags$b("模型构建")),
p("使用上一个页面（“数据”选项卡）准备数据。"),
hr(), 
h4(tags$b("第1步 选择参数建立模型")),    

uiOutput('y.r'), 
uiOutput('x.r'), 


numericInput("nc.r", "3. 有多少新成分？（A<=X的维度）", 4, min = 1, max = NA),

radioButtons("val.r", "4. 做交叉验证？",
choices = c("不，使用完整数据" = 'none',
           "10倍交叉验证" = "CV",
           "留一交叉验证" = "LOO"),
selected = 'CV'),

radioButtons("method.r", "5. 哪种PLS算法？",
  choices = c("SIMPLS：简单快捷" = 'simpls',
           "核算法(kernel)" = "kernelpls",
           "宽核算法(wide kernel)" = "widekernelpls",
           "传统正交分数算法" = "oscorespls"),
selected = 'simpls'),
p("这些算法的结果差别不大。"),

shinyWidgets::prettySwitch(
   inputId = "scale.r",
   label = tags$b("数据scaling?"), 
   value=TRUE,
   status = "info",
   fill = TRUE
  ),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("PLSR可以使用多个因变量来查找Y和X矩阵之间的线性关系。
  因此，在此示例中，时间(time)，直径(Diam)和年龄(Age)用作因变量，而其他变量是自变量。")),
p(tags$i("我们想找到具有较高预测能力的成分。")),
p(tags$i("在数据选项卡中，我们发现X是20x25的矩阵，因此a的最大值是19。 如果A=20，将发生错误。")),
p(tags$i("在此示例中，我们决定根据MSEP和RMSEP选择三个成分（A=3）。我使用了10倍CV和一个简单而高速的算法。"))
),

hr(),

h4(tags$b("第2步 如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),
#actionButton("pls1", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pls1", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. 数据确认")),
p(tags$b("数据（一部分）")),
 p("请在“数据”选项卡中编辑修改数据"),
DT::DTOutput("pls.x"),

hr(),
#actionButton("pls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. 模型的结果")),

tabsetPanel(
tabPanel("PLSR的结果",p(br()),

HTML(
"
<b>説明</b>

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
verbatimTextOutput("pls"),
p(tags$b("R^2")),
verbatimTextOutput("pls_r"),
p(tags$b("预测的均方误差 (MSEP)")),
verbatimTextOutput("pls_msep"),
p(tags$b("预测的均方根误差 (RMSEP)")),
verbatimTextOutput("pls_rmsep"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("因为我们选择了多个因变量（Y），每个Y的结果分别表示。")),
p(tags$i("R^2优于PCR，因为PLSR从Y和X生成新变量。 Y描述的方差（％）也高于PCR。"))
)

),

tabPanel("数据拟合",p(br()),

p(tags$b("Y的预测值")),
DT::DTOutput("pls.pres"),br(),
p(tags$b("残差（Y-预测的Y）")),
DT::DTOutput("pls.resi"),br(),
p(tags$b("系数")),
DT::DTOutput("pls.coef")

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
uiOutput("g.pls"),
uiOutput("type.pls"),
p(tags$b("当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c1.r", "1. x轴成分", 1, min = 1, max = NA),
numericInput("c2.r", "2. y轴成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在此图中，我绘制了component1和component2的散点图，发现327和332是离群值。"))
),
  plotly::plotlyOutput("pls.s.plot"),
  DT::DTOutput("pls.s")
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
  plotly::plotlyOutput("pls.l.plot"),
  DT::DTOutput("pls.l")
  ),

tabPanel("成分和载荷的2D图", p(br()),
  HTML("
<b>说明</b>
<ul>
<li> 此图叠加了成分和载荷量（选择左面板中的主成分）。</li>
<li> 如果数据遵循正态分布并且不存在离群值，则点在零附近随机分布。</li>
<li> 载荷测定哪些成分对每个成分的影响最大。</li>
<li> 载荷范围从-1到1。接近-1或1的载荷表示变量对成分的影响很大。接近0的载荷表示变量对成分的影响很小。</li>
</ul>

  "),
    hr(),

p(tags$b("当A >= 2时，选择2个成分显示成分和载荷2D图")),
numericInput("c11.r", "1. x轴成分", 1, min = 1, max = NA),
numericInput("c22.r", "2. y轴成分", 2, min = 1, max = NA),
  plotly::plotlyOutput("pls.bp")
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
numericInput("td1.r", "1. x轴成分", 1, min = 1, max = NA),
numericInput("td2.r", "2. y轴成分", 2, min = 1, max = NA),
numericInput("td3.r", "3. z轴成分", 3, min = 1, max = NA),

numericInput("lines.r", "4. （可选） 变更线段（line scale）长度", 0.1, min = 1, max = NA),
plotly::plotlyOutput("pls.tdplot"),
p(tags$b("跟踪图例")),
verbatimTextOutput("pls_tdtrace")
)
)

)

)