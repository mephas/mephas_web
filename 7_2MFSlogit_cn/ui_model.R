#****************************************************************************************************************************************************model

sidebarLayout(


sidebarPanel(

tags$head(tags$style("#formula {height: 50px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; max-height: 200px; background: white};")),
tags$head(tags$style("#fit1 {overflow-y:scroll; max-height: 500px; background: lavender; color: black;};")),
tags$head(tags$style("#fit2 {overflow-y:scroll; max-height: 500px; background: lavender; color: black;};")),
tags$head(tags$style("#step {overflow-y:scroll; max-height: 500px; background: lavender};")),


h4(tags$b("模型构建")),
p("使用上一个页面（“数据”）准备数据。"),
hr(),       

h4(tags$b("第1步 选择建模使用变量")),      

uiOutput('y'), 
p(br()),
uiOutput('x'),
p(br()),

radioButtons("intercept", "3.  根据需要，保留或删除常数项（截距）", ##> intercept or not
     choices = c("删除截距/常数项" = "-1",
                 "保留截距/常数项" = ""),
     selected = ""),
p(br()),
#p(tags$b("4. （可选）添加变量交互项")), 
#p('Please input: + var1:var2'), 
#tags$textarea(id='conf', " " ), 
uiOutput('conf'),
p("交互项变量需要是分类变量，如果无可选项，说明没有分类型变量"),


hr(),


h4(tags$b("第2步 检查模型")),
p(br()),
tags$b("有效模型示例：Y ~ X1 + X2"),
p(br()),
verbatimTextOutput("formula"),
p("公式中的'-1'表示截距/常数项已被删除"),

hr(),

h4(tags$b("第3步 如果数据和模型准备就绪，单击蓝色按钮生成模型结果。")),
p(br()),
actionButton("B1", (tags$b("显示模型结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),

hr()
),

mainPanel(

h4(tags$b("Output 1. 数据确认")),
tabsetPanel(
	tabPanel("变量情报", p(br()),
verbatimTextOutput("str")
),
tabPanel("数据（一部分）", p(br()),
p("请在“数据”页面中编辑修改数据"),
DT::DTOutput("Xdata2")
)

),
hr(),

h4(tags$b("Output 2. 模型的结果")),
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  class = "btn-warning"),
 p(br()),
tabsetPanel(

tabPanel("模型估计",  p(br()),

HTML(
"
<b> 说明  </b>
<ul>
<li> 左边的输出所示为估计系数（95%置信区间），给出了单个变量显著性的T统计量（t =）和P值（p =）
<li> 右边的输出所示为优势比（OR值） = exp(b)和原始系数的标准误差
<li> 对各变量进行T检验，P<0.05，表明该变量对模型有统计学意义
<li> 观测值是指样本的数量。
<li> Akaike Inf. Crit. = AIC = -2 (log likelihood) + 2k; k为（变量+常数）的个数 ; loglikelihood:对数似然值 
</ul>
"
),
p(br()),

fluidRow(
column(12, htmlOutput("fit1"),p(br()),
    downloadButton("downloadfit1", "保存到CSV中"),p(br()),
    downloadButton("downloadfit.latex1", "保存LaTex代码")
)
# column(6, htmlOutput("fit2"),p(br()),
#     downloadButton("downloadfit2", "保存到CSV中"),p(br()),
#     downloadButton("downloadfit.latex2", "保存LaTex代码")
# )
)


),

tabPanel("数据拟合",  p(br()),

    DT::DTOutput("fitdt0")
    ),

tabPanel("AIC变量选择",  p(br()),
HTML(
"<b> 说明 </b>
  <ul> 
    <li> 采用Akaike信息准则（AIC）进行逐步（Stepwise）模型选择
    <li> 模型拟合根据其AIC值秩和，AIC值最低的模型有时被认为是“最佳”模型
  </ul>
</ul>"
),
    p(tags$b("采用Akaike信息准则的模型选择")),
    verbatimTextOutput("step")


    ),

tabPanel("ROC图",   p(br()),

HTML(
"<b> 说明 </b>
<ul> 
<li> ROC曲线：受试者工作特性曲线，是一个图表，阐明二进制分类器系统在其识别阈值变化时的诊断能力
<li> ROC曲线通过绘制各种阈值设置下的真阳性率（TPR）与假阳性率（FPR）的关系进行创建
<li> 敏感度（Sensitivity, 也称为真阳性率）测量被正确识别的实际阳性比例
<li> 特异性（Specificity, 也称为真阴性率）测量被正确识别的实际阴性比例

</ul>"
),
plotly::plotlyOutput("p.lm", width = 700),
DT::DTOutput("sst")
    )

)
)
)