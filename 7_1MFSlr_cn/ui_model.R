#****************************************************************************************************************************************************model
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#formula {height: 50px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; max-height: 200px; background: lavender}")),
tags$head(tags$style("#fit {overflow-y:scroll; max-height: 500px; background: lavender;color: black;}")),
tags$head(tags$style("#step {overflow-y:scroll;max-height: 500px; background: lavender};")),


h4(tags$b("模型构建")),
p("使用上一个页面（“数据”选项卡）准备数据。"),
hr(),      

h4(tags$b("第1步 选择建模使用变量")),      

uiOutput('y'),    
uiOutput('x'),
#uiOutput('fx'),

radioButtons("intercept", "3. （可选）保留或删除截距/常数项", ##> intercept or not
     choices = c("删除截距/常数项" = "-1",
                 "保留截距/常数项" = ""),
     selected = ""),

uiOutput('conf'), 
hr(),
h4(tags$b("第2步 检查模型并生成结果")),
tags$b("有效模型示例： Y ~ X1 + X2"),
verbatimTextOutput("formula"),
p("公式中的'-1'表示截距/常数项已被删除"),
hr(),

h4(tags$b("第3步 如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),
p(br()),
actionButton("B1", (tags$b("显示拟合结果>>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()


),

mainPanel(

h4(tags$b("Output 1. 数据确认")),
tabsetPanel(
  tabPanel("变量情报", br(),
verbatimTextOutput("str")
),
tabPanel("数据（一部分）", br(),
 p("请在“数据”选项卡中编辑修改数据"),
DT::DTOutput("Xdata2")
)
),
hr(),

h4(tags$b("Output 2. 模型的结果")),
#actionButton("B1", h4(tags$b("1：出力2.モデルの結果を表示/更新をクリックしてください")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),

tabsetPanel(

tabPanel("模型估计",  br(),
    
HTML(
"
<b> 说明 </b>
<ul>
<li> 每个变量的值为：估计系数（95%置信区间），T统计量（t=）和每个变量显著性的P值（P=）
<li> 对各变量进行T检验，P<0.05，表明该变量对模型有统计学意义。
<li> 观察值表示样本数量
<li> R<sup>2</sup>是线性回归模型的拟合优度度量，表示自变量共同解释的因变量方差的百分比。假设R2=0.49。这一结果暗示对49%的因变量方差已证明，剩下的51%仍未证明。
<li> 经调整的R<sup>2</sup>用于比较包含不同自变量数的回归模型拟合优度。
<li> F统计量（回归中总体显著性的F检验）对多个系数同时进行判断。
     F=(R^2/(k-1))/(1-R^2)/(n-k)；n为样本量；k为变量+常数项的数量
</ul>
"
),
#verbatimTextOutput("フィット（Fit）")
p(tags$b("结果")),
htmlOutput("fit"),
downloadButton("downloadfit", "保存到CSV中"),
downloadButton("downloadfit.latex", "保存LaTex代码")

    ),

tabPanel("数据拟合",  br(),

    DT::DTOutput("fitdt0")
),

tabPanel("ANOVA",  br(),

HTML(
"<b> 说明 </b>
<ul> 
<li> DF<sub>变量</sub> = 1
<li> DF<sub>残留误差</sub> = [样本值的个数] - [变量数] -1
<li> MS = SS/DF
<li> F = MS<sub>变量</sub> / MS<sub>残留误差</sub> 
<li> P值 < 0.05，则变量对于模型是有统计学意义的。
</ul>"
    ),
    p(tags$b("ANOVA表")),  
    DT::DTOutput("anova")),

tabPanel("AIC变量选择",  br(),
    HTML(
    "<b> 说明 </b>
  <ul> 
    <li> 采用Akaike信息准则（AIC）进行逐步（Stepwise）模型选择。
    <li> 模型拟合根据其AIC值秩和，AIC值最低的模型有时被认为是“最佳”模型。
  </ul>"
    ),

    p(tags$b("采用Akaike信息准则的模型选择")),
    verbatimTextOutput("step"),
    downloadButton("downloadsp", "保存TXT文件")

    ),

tabPanel("诊断图",   br(),
HTML(
"<b> 说明 </b>
<ul> 
<li> 残差的Q-Q正态图检查残差的正态性。 点的线性表示数据是正态分布的。
<li> 用残差vs拟合图发现异常值
</ul>"
),
p(tags$b("1. 残差的Q-Q正态图")),
plotly::plotlyOutput("p.lm1", width = 500),
p(tags$b("2. 残差vs拟合图")),
plotly::plotlyOutput("p.lm2", width = 500)

    ),
tabPanel("3D散点图", p(br()),
HTML(
"<b> 说明 </b>
<ul> 
<li> 3D散点图显示了因变量（Y）与两个自变量（X1，X2）之间的关系。
<li> 分组变量将点划分为组。
</ul>"
),

uiOutput("vx1"),
uiOutput("vx2"),
uiOutput("vgroup"),
plotly::plotlyOutput("p.3dl", width = 700)
)

)
)
)