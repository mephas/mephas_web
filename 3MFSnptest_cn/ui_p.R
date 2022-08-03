#****************************************************************************************************************************************************3.npp

sidebarLayout(

sidebarPanel(

h4(tags$b("第1步 准备数据")),
p(tags$b("1. 命名数据（必填）")),

tags$textarea(id="cn3", rows=3, "Before\nAfter\nAfter-Before"), p(br()),


p(tags$b("2. 数据输入")),

tabsetPanel(

tabPanel("手动输入", p(br()),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这里的数据是9名患者在治疗前后的抑郁评定量表(DRS) 测量结果。"))
),

p(tags$b("请参考示例格式上传数据")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
p(tags$b("从CSV（一列）复制数据并粘贴到框中")), 

p(tags$b("前")),
tags$textarea(id="y1",
rows=10,
"1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
),

p(tags$b("后")),
tags$textarea(id="y2",
rows=10,
"0.88\n0.65\n0.59\n2.05\n1.06\n1.29\n1.06\n3.14\n1.29"
),

p("缺失值输入NA，保证2个集长度相等；否则会出错")

),

tabPanel.upload.num(file ="file3", header="header3", col="col3", sep="sep3")

),

hr(),

h4(tags$b("第2步 选择假设")),

p(tags$b("零假设")),
HTML("<p>  m = 0: X和Y之间的中位数差为零</p>
<p>  或者，配对值之差的分布在零附近对称</p> "),

radioButtons("alt.wsr3", label = "备择假设",
choiceNames = list(
HTML("m &#8800 0: X与Y的中位数之差不为零；配对值之差的分布在零附近不对称"),
HTML("m < 0: Y的总体中位数较大"),
HTML("m > 0: X的总体中位数较大")),
choiceValues = list("two.sided", "less", "greater")),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这个示例里，我们想要知道治疗后，DRS的测量结果是不是有显著性差异。"))
),
hr(),

h4(tags$b("第3步 选择P值的计算方法")),
radioButtons("alt.md3",
label = "数据是什么样的", selected = "c",
choiceNames = list(
HTML("近似正态分布P值：样本量大"),
HTML("渐近正态分布P值：样本量大"),
HTML("精确P值：样本量小 (<50)")
),
choiceValues = list("a", "b", "c")),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这个示例里，我们只有9位患者。 因此，我们选择精确P值。"))
)

),

mainPanel(

h4(tags$b("Output 1. 描述性统计结果")),

tabsetPanel(

tabPanel("数据确认",    p(br()),  DT::DTOutput("table3")),

tabPanel("描述性统计量", p(br()),  DT::DTOutput("bas3")),

tabPanel.boxplot("bp3"),
tabPanel.histplot("makeplot3", "makeplot3.1", "bin3")

),

hr(),

h4(tags$b("Output 2. 检验结果")),
p(br()),

tags$b('威尔科克森符号秩检验(Wilcoxon Signed-Rank Test)的结果'),
p(br()),
DT::DTOutput("psr.test.t"),
p(br()),

HTML(
"<b> 说明 </b>
<ul>
<li> P值 < 0.05，则第1组（治疗前）和第二组（治疗后）存在统计学差异。（接受备择假设）
<li> P值 >= 0.05，则2组数据没有统计学差异。(接受零假设)
</ul>"
),
p(br()),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("根据初始设定， 我们得到治疗前后没有统计学差异的结论(P = 0.46)。"))
)


)
)
