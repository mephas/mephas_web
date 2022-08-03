#****************************************************************************************************************************************************5.np-1way

sidebarLayout(

sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("11. 对数值样本和因子组命名")),

tags$textarea(id = "cnnp1", rows = 2, "FEF\nSmoke"),p(br()),

p(tags$b("2. 输入数据")),

tabsetPanel(
##-------input data-------##
tabPanel("手动输入", p(br()),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这个例子是吸烟者和吸烟群体的FEF数据。可以在Output 1.中找到更多信息。"))
),

p(tags$b("请参阅示例输入数据。")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
p(tags$b("从CSV复制数据（1列）并将其粘贴到框中")),

p(tags$b("样本值")),
tags$textarea(id = "xnp1",rows = 10,
"3.53\n3.55\n3.50\n5.40\n3.43\n3.22\n2.94\n3.85\n2.91\n3.94\n3.50\n3.38\n4.15\n4.26\n3.71\n1.77\n2.11\n1.92\n3.65\n2.35\n3.26\n3.73\n2.36\n3.75\n3.21\n2.78\n2.95\n4.52\n3.41\n3.56\n2.48\n3.16\n2.11\n3.89\n2.10\n2.87\n2.77\n4.59\n3.66\n3.55\n2.49\n3.48\n3.28\n3.04\n3.49\n2.13\n3.56\n2.88\n2.30\n4.38"
),
p(tags$b("因子组")),
tags$textarea(id = "fnp1",rows = 10,

"NS\nLS\nLS\nPS\nLS\nHS\nMS\nNS\nPS\nNI\nMS\nLS\nNI\nNS\nMS\nPS\nMS\nLS\nPS\nHS\nMS\nMS\nHS\nLS\nHS\nMS\nHS\nNS\nLS\nNS\nHS\nMS\nHS\nNS\nLS\nNI\nMS\nPS\nLS\nPS\nNI\nLS\nLS\nHS\nLS\nHS\nLS\nMS\nHS\nNS"
),

p("缺失值请输入NA。两组数据应有相同的长度，否则会报错。")

),
tabPanel.upload(file ="filenp1", header="headernp1", col="colnp1", sep="sepnp1", quote = "quotenp1")

),
hr(),
uiOutput("value3"),
hr(),
h4(tags$b("假设")),
p(tags$b("零假设")),
p("各组的均值相等"),
p(tags$b("备择假设")),
p("至少两个因子群的均值间存在有意差"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这个示例想知道6对吸烟组中的FEF值是否不同。"))
)

),

mainPanel(

h4(tags$b("Output 1. 描述性统计结果")),

tabsetPanel(

tabPanel("数据确认", p(br()),
DT::DTOutput("tablenp1"),
p(br()),
p(tags$b("因子组类别")),
p(br()),
DT::DTOutput("level.tnp1")
),

tabPanel("描述性统计", p(br()),
p(tags$b("组别描述统计量")),
p(br()),
DT::DTOutput("basnp1.t")
),

tabPanel.boxplot("mmeannp1")

),

hr(),

h4(tags$b("Output 2. 检验结果")), p(br()),

DT::DTOutput("kwtest"),p(br()),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在此示例中，有统计学差异，因此我们可以得出结论，六组之间的FEF的Kruskal-Wallis秩有显着不同。"))
),

hr(),
HTML("<p><b>P值 < 0.05</b>时， 如果想知道哪些成对因素组明显不同，请使用<b>多重比较</b>。</p>")



)
)
