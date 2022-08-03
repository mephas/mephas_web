#****************************************************************************************************************************************************2.np2

sidebarLayout(

sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("1. 命名数据（必填）")),

tags$textarea(id="cn2", rows=2, "Group1\nGroup2"), p(br()),

p(tags$b("2. 数据输入")),

tabsetPanel(
##-------input data-------##
tabPanel("手动输入", p(br()),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这里的数据是两组19名患者的抑郁评定量表(DRS) 测量结果。"))
),

p(tags$b("请参考示例格式上传数据")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
p(tags$b("从CSV（一列）复制数据并粘贴到框中")),   
p(tags$b("组 1")),
tags$textarea(id="x1",
rows=10,
"1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30\nNA"
),

p(tags$b("组 2")),## disable on chrome
tags$textarea(id="x2",
rows=10,
"0.80\n0.83\n1.89\n1.04\n1.45\n1.38\n1.91\n1.64\n0.73\n1.46"
),

p("缺失值处输入空格，保证2个组的数据长度相等；否则会出错。")
),

tabPanel.upload.num(file ="file2", header="header2", col="col2", sep="sep2")

),

hr(),

h4(tags$b("第2步 选择假设")),

p(tags$b("零假设")),

HTML("<p> m&#8321 = m&#8322: 两组中位数相等</p>
<p> 或，每组值分布相等</p>"),

radioButtons("alt.wsr2", label = "备择假设",
choiceNames = list(
HTML("m&#8321 &#8800 m&#8322: 各组总体中位数不相等"),
HTML("m&#8321 < m&#8322: 第2组的总体中位数较大"),
HTML("m&#8321 > m&#8322: 第1组的总体中位数较大")),
choiceValues = list("two.sided", "less", "greater")),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在初始条件下，我们想知道两组患者的抑郁评定量表(DRS)测量结果是否不同。"))
),
hr(),


h4(tags$b("第3步  选择P值的计算方法")),
radioButtons("alt.md2",
label = "数据是什么样的", selected = "c",
choiceNames = list(
HTML("近似正态分布P值：样本量大"),
HTML("渐近正态分布P值：样本量大"),
HTML("精确P值：样本量小 (<50)")
),
choiceValues = list("a", "b", "c")),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("两组的样本量分别为9和10，所以我们使用精确P值法。"))
)

),

mainPanel(

h4(tags$b("Output 1. 描述性统计结果")),

tabsetPanel(

tabPanel("数据确认",    p(br()),    DT::DTOutput("table2")),

tabPanel("描述性统计量", p(br()),   DT::DTOutput("bas2")),

tabPanel.boxplot("bp2"),
tabPanel.histplot("makeplot2", "makeplot2.1", "bin2")

),

hr(),

h4(tags$b("Output 2. 检验结果")),
tags$b('威尔科克森秩和检验(Wilcoxon Rank-Sum Test)的结果'), p(br()),

DT::DTOutput("mwu.test.t"), p(br()),

HTML(
"<b> 说明 </b>
<ul>
<li> P值 < 0.05，则2组总体中位数有显著差异。（接受备择假设）
<li> P值 >= 0.05，则2组中位数无显著差异。（接受零假设）
</ul>"
),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在初始条件下，我们可以得到这两组患者的DRS测量结果没有显著的不同(P = 0.44)。"))
)#,


# downloadButton("download2.1", "Download Results")

)
)
