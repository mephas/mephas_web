#****************************************************************************************************************************************************cox-pred

sidebarLayout(

sidebarPanel(

tags$head(tags$style("#cox_form {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str4 {overflow-y:scroll; max-height:: 350px; background: white};")),
tags$head(tags$style("#fitcx {overflow-y:scroll; max-height:: 400px; background: white};")),
tags$head(tags$style("#fitcx2 {overflow-y:scroll; max-height:: 400px; background: white};")),
tags$head(tags$style("#zph {overflow-y:scroll; max-height:: 150px; background: white};")),
tags$head(tags$style("#step {overflow-y:scroll; max-height:: 400px; background: white};")),



h4(tags$b("模型构建")),
p("使用上一个页面（“数据”选项卡）准备数据。"),
hr(),       

h4(tags$b("第1步 选择建模使用变量")),      

p(tags$b("1. 在“数据”选项卡中选中生存对象，Surv(time, event)")), 

tabsetPanel(
tabPanel("基本模型", p(br()),

uiOutput('var.cx'),

p(br()),

uiOutput('conf.cx'),

p(tags$b("如果要考虑样本中的异质性，请继续扩展模型选项卡。"))
  ),

tabPanel("扩展模型", p(br()),
radioButtons("tie", "4. （可选）选择如何处理同值",selected="breslow",
  choiceNames = list(
    
    HTML("1. Efron法： 同值多时更为准确"),
    HTML("2. Breslow近似：最容易编程，基本所有的计算机程序都采用的第一选项"),
    HTML("3. 精准部分似然(Exact partial likelihood)方法： Cox的部分似然等效于匹配的逻辑回归。")
    ),
  choiceValues = list("efron","breslow","exact")
  ),

radioButtons("effect.cx", "5. （可选）添加随机效应项（异质效应）",
     choices = c(
      "非选择" = "",
      "Strata（Cluster）：识别分层变量（疾病亚型和登录医院之类的类别）" = "Strata",
      "聚类（Cluster）：标识相关的观察组（例如，每个患者有多个事件）" = "Cluster",
      "Gamma脆弱：添加一个简单的Gamma分布随机效应项" = "Gamma Frailty",
      "高斯脆弱：添加一个简单的高斯随机效应项" = "Gaussian Frailty"
                 ),
     selected = ""),
uiOutput('fx.cx'),
p("Gamma脆弱：个体有各种脆弱性，最脆弱的人比其他人更快地死去。
   脆弱模型估计随机效应变量中的相对风险"),

p("聚类模型（Cluster model也称为边际模型（marginal model）。 通过自变量估算总体平均的相对风险。"),

p(tags$i("在糖尿病数据的示例中，“眼睛”可用作分层随机效应，并为每组眼睛显示结果。
    “id”可以用作聚类的随机效应变量，并且结果被认为在聚类内是独立的。
    “id”也可以用作Frail的随机效果变量，并且通过“ id”的模拟分布来调整结果。"))
)
  ),

hr(),

h4(tags$b("第2步  检查Cox模型")),
p(tags$b("有效模型示例：Surv(time, status) ~ X1 + X2")),
p(tags$b("或，Surv(time1, time2, status) ~ X1 + X2")),

verbatimTextOutput("cox_form", placeholder = TRUE),
hr(),

h4(tags$b("第3步  如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),
p(br()),
actionButton("B2", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. 数据确认")),
 tabsetPanel(
 tabPanel("变量情报",p(br()),
 verbatimTextOutput("str4")
 ),
tabPanel("数据（一部分）", br(),
p("请在“数据”选项卡中编辑修改数据"),
 DT::DTOutput("Xdata4")
 )

 ),
 hr(),
 
#actionButton("B2", h4(tags$b("Click 1: Output 2. モデル結果の表示/更新")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. 模型的结果")),

tabsetPanel(

tabPanel("模型估计", br(),
HTML(
"
<b> 说明  </b>
<ul>
<li> 对于每个变量，给出了估计系数（coef）、单个变量的显著性统计量和P值。</li>
<li> 标记为“z”的列给出Wald统计值。与各回归系数与其标准误差的比值相对应（z = coef/ se (coef)）。Wald统计量评价给定变量的贝塔系数在统计上是否与0有显著差异。</li>
<li> 系数与危险有关；正系数表示预后较差，负系数表示与之相关的变量的保护作用。</li>
<li> exp(coef) = 危险比（HR）。HR = 1：没有效果；HR<1：危险降低；HR>1：危险增加。</li>
<li> 输出还给出了危险比（exp(coef)）的上、下95%置信区间。</li>
<li> 似然比检验，Wald检验和分数对数秩统计给出了模型的全局统计显著性。这三种方法渐近等价。对于足够大的N，结果会类似。对于小N，可能会有些不同。似然比检验对于小样本量具有更好的行为，因此一般首选。</li>
</ul>
"
),
verbatimTextOutput("fitcx")

),

tabPanel("数据拟合", p(br()),
    p(tags$b("已知数据的拟合值和残差")),
    DT::DTOutput("fit.cox")
),

tabPanel("AIC变量选择",  br(),
HTML(
"<b> 说明 </b>
  <ul> 
    <li> 采用Akaike信息准则（AIC）进行逐步（Stepwise）模型选择。</li>
    <li> 模型拟合根据其AIC值秩和，AIC值最低的模型有时被认为是“最佳”模型。 </li>
  </ul>
</ul>"
),
    p(tags$b("采用Akaike信息准则的模型选择")),
    verbatimTextOutput("step")


    ),

tabPanel("生存曲线", p(br()),
  HTML(
     "
<b> 说明  </b>
<ul>
<li> 该图分别给出基于Cox模型计算的亚群/层的期望生存曲线。</li>
<li> 如果没有strata()成分，则只绘制一条整个总体均值的曲线。</li>
</ul>
"
),
p(tags$b("Cox回归的调整后生存曲线")),
 plotOutput("splot")

),

tabPanel("比例危害检验", br(),

HTML(
"
<b> 说明  </b>
<ul>
<li> Schoenfeld残差用于检验比例风险假设。</li>
<li> Schoenfeld残差与时间无关。一个显示与时间有关的非随机模式的图是违反PH假设的证据。</li>
<li> 若各自变量检验不具有统计学意义（P>0.05），则可以假设成比例的危险。</li>
</ul>
"
),
numericInput("num", HTML("选择第N个变量"), value = 1, min = 1, step=1),

plotOutput("zphplot"),

DT::DTOutput("zph")



),



tabPanel("诊断图", p(br()),
 
HTML(
     "
<p><b> 说明  </b></p>
<b>鞅残差(Martingale)</b>是针对连续自变量的检测非线性的常用方法。对于一个给定的连续协变量，图中的模式可能表示该变量不是正确拟合的。鞅残差可以表示（-INF, +1）范围内的任何值：
<ul>
<li>鞅残差值在1附近表示“死得太快”的个体，</li>
<li>较大的负值对应于“活得太久”的个体。</li>
</ul>

<b>异常残差(Deviance residual)</b>是鞅残差的归一化变换。这些残差应大致对称地分布在零左右，标准偏差为1。
<ul>
<li>与预期存活时间相比，正值对应“死得太快”的个体。</li>
<li>负值对应“活得太久”的个体。</li>
<li>很大或很小的值都是离群值，模型预测很差。</li>
</ul>

<b>Cox-Snell残差</b>用于检验生存模型的总体拟合优度。
<ul>
<li> Cox-Snell残差等于每个观察的-读数（存活率）。</li>
<li> 如果模型能很好地拟合数据，Cox-Snell残差应像一个均值为1的指数分布样本。</li>
<li> 如果残差的作用类似于单位指数分布的样本，则它们应位于45度对角线上。</li>
</ul>

<p>残差可以在“数据拟合”选项卡中找到。<p>
<p>红点是那些“不久死亡”的个体；黑点是“长寿”个体。<p>
"
),

p(tags$b("1. 连续自变量的鞅残差图")), 

uiOutput('var.mr'),
plotly::plotlyOutput("diaplot1"),

#p(tags$b("2. 観測IDに対するマルチンゲール残差プロット")), 
# plotOutput("diaplot1.2"),

 p(tags$b("2. 观察ID和异常残差图")),
 plotly::plotlyOutput("diaplot2"),

 p(tags$b("3. Cox-Snell残差图")),
 plotly::plotlyOutput("csplot.cx")
)

)
)
)