#****************************************************************************************************************************************************aft


sidebarLayout(

sidebarPanel(

tags$head(tags$style("#aft_form {height: 50px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str3 {overflow-y:scroll; max-height:: 200px; background: white};")),
tags$head(tags$style("#fit {overflow-y:scroll; max-height:: 400px; background: white};")),
tags$head(tags$style("#step2 {overflow-y:scroll; max-height:: 400px; background: white};")),

h4(tags$b("模型构建")),
p("使用上一个页面（“数据”选项卡）准备数据。"),
hr(), 

h4(tags$b("第1步 选择建模使用变量")),    

p(tags$b("1.  在“数据”选项卡中选中生存对象，Surv(time, event)")), 



tabsetPanel(

tabPanel("基本模型", p(br()),

uiOutput('var.x'),

radioButtons("dist", "3. 选择AFT模型",
  choiceNames = list(
    HTML("1. 对数正态回归模型"),
   # HTML("2. Extreme regression model"),
    HTML("2. Weibull回归模型"),
    HTML("3. 指数回归模型"),  
    HTML("4. 对数逻辑回归模型")
    ),
  choiceValues = list("lognormal","weibull", "exponential","loglogistic")
  ),


uiOutput('conf'),

radioButtons("intercept", "5. （可选）保留或删除截距/常数项", ##> intercept or not
     choices = c("删除截距/常数项" = "-1",
                 "保留截距/常数项" = ""),
     selected = ""),

p(tags$b("如果要考虑样本中的异质性，请继续扩展模型选项卡。"))

),

tabPanel("扩展模型", p(br()),

radioButtons("effect", "6. （可选）添加随机效应项（异质效应）",
     choices = c(
      "非选择" = "",
      "Strata（Cluster）：识别分层变量（疾病亚型和登录医院之类的类别）" = "Strata",
      "聚类（Cluster）：标识相关的观察组（例如，每个患者有多个事件）" = "Cluster"
      #"Gamma Frailty: allows one to add a simple gamma distributed random effects term" = "Gamma Frailty",
      #"Gaussian Frailty: allows one to add a simple Gaussian distributed random effects term" = "Gaussian Frailty"
                 ),
     selected = ""),

uiOutput('fx.c'),
tags$i("在糖尿病数据的示例中，“眼睛”可用作分层随机效应， “id”可以用作聚类的随机效应变量。" )
)
),
hr(),

h4(tags$b("第2步 检查AFT模型")),
p(tags$b("有效模型示例：Surv(time, status) ~ X1 + X2")),
p(tags$b("或，Surv(time1, time2, status) ~ X1 + X2")),
verbatimTextOutput("aft_form", placeholder = TRUE),
p("「-1」表示删除截距/常数项。"),
hr(),

h4(tags$b("第3步 如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),
p(br()),
actionButton("B1", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. 数据确认")),
 tabsetPanel(
   tabPanel("变量情报",p(br()),
 verbatimTextOutput("str3")
 ),
tabPanel("数据（一部分）", br(),
p("请在“数据”选项卡中编辑修改数据"),
 DT::DTOutput("Xdata3")
 )

 ),
 hr(),
 
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. 模型的结果")),
p(br()),
tabsetPanel(

tabPanel("模型估计", br(),
HTML(
"
<b> 说明  </b>
<ul>
<li> 对于每个变量，给出了估计系数（值）、单个变量的显著性统计量和P值。</li>
<li> 标记为“z”的列给出Wald统计值。与各回归系数与其标准误差的比值相对应（z = coef/ se (coef)）。Wald统计量评价给定变量的贝塔系数在统计上是否与0有显著差异。</li>
<li> 系数与危险有关；正系数表示预后较差，负系数表示与之相关的变量的保护作用。</li>
<li> exp（值） = 危险比（HR）。HR = 1：没有效果；HR<1：危险降低；HR>1：危险增加</li>
<li> 尺度和对数（尺度）是AFT模型误差项中的估计参数。</li>
<li>　模型中给出了对数似然。当使用最大似然估生成对数似然时，对数似然估计（LL）越接近于零，模型拟合越好。</li>
<li> 对于左截断数据，这里的时间是结束时间和开始时间的差值。</li>
</ul>
"
),
verbatimTextOutput("fit")

),

tabPanel("数据拟合", p(br()),

    p(tags$b("已知数据的拟合值和残差")),
    DT::DTOutput("fit.aft")
),

tabPanel("AIC变量选择",  br(),
HTML(
"<b> 说明 </b>
  <ul> 
    <li> 采用Akaike信息准则（AIC）进行逐步（Stepwise）模型选择。 </li>
    <li> 模型拟合根据其AIC值秩和，AIC值最低的模型有时被认为是“最佳”模型。 </li>
  </ul>
</ul>"
),
    p(tags$b("采用Akaike信息准则的模型选择")),
    verbatimTextOutput("step2")


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
uiOutput('var.mr2'),
plotly::plotlyOutput("mrplot"),

p(tags$b("2. 观察ID和异常残差图")),
plotly::plotlyOutput("deplot"),

p(tags$b("3. Cox-Snell残差图")),
plotly::plotlyOutput("csplot")

)

)
)
)