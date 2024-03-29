#****************************************************************************************************************************************************1.t1
sidebarLayout(

sidebarPanel(

h4(tags$b("第1步  准备数据")),

p(tags$b("1. 命名数据（必填）")),

tags$textarea(id = "cn", rows = 1, "Age"),p(br()),

p(tags$b("2. 数据输入")),

tabsetPanel(

tabPanel("手动输入", p(br()),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("144例淋巴结阳性患者的年龄"))
),

p(tags$b("请参考示例格式上传数据")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
p(tags$b("从CSV（一列）复制数据并粘贴到框中")),   
tags$textarea(
id = "x", #p
rows = 10,
"50\n42\n50\n43\n47\n47\n38\n45\n31\n41\n48\n47\n38\n44\n36\n42\n42\n45\n49\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48\n48\n36\n43\n44\n47\n40\n41\n48\n41\n45\n45\n47\n37\n43\n43\n49\n45\n41\n50"
),

p("缺失值输入NA")
),
tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")


),

hr(),

h4(tags$b("第2步  指定参数")),

numericInput('mu', HTML("想要与数据进行比较的均值 (&#956&#8320)"), 50), #p
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("指定的参数为一般年龄50岁"))
),

hr(),

h4(tags$b("第3步  选择假设")),

p(tags$b("零假设")),
HTML("&#956 = &#956&#8320: 数据的总体均值 (&#956) 为 &#956&#8320"),

radioButtons(
"alt",
label = "备择假设",
choiceNames = list(
HTML("&#956 &#8800 &#956&#8320: 数据的总体均值 (&#956) 不是 &#956&#8320"),
HTML("&#956 < &#956&#8320: 数据的总体均值 (&#956) 小于 &#956&#8320"),
HTML("&#956 > &#956&#8320: 数据的总体均值 (&#956) 大于 &#956&#8320")
),
choiceValues = list("two.sided", "less", "greater")),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("想知道年龄是不是50岁，所以选择第一个备择假设"))
)

),


mainPanel(

h4(tags$b("Output 1. 描述性统计结果")),

tabsetPanel(

tabPanel("数据确认",		p(br()), DT::DTOutput("table")),

tabPanel("描述性统计量", 	p(br()), DT::DTOutput("bas")),

tabPanel.boxplot("bp"),

tabPanel.msdplot("meanp"),

tabPanel.pdfplot("makeplot1", "makeplot1.2", "makeplot1.3", "bin")

),

hr(),

h4(tags$b("Output 2. 检验结果")),
p(br()),

DT::DTOutput("t.test"),
p(br()),

HTML(
"<b> 说明 </b>
<ul>
<li> P值 < 0.05，则数据总体与指定均值有显著差异。（接受备择假设）
<li> P值 >= 0.05，则数据总体与指定均值无显著差异。（接受零假设）
</ul>"
),
p(br()),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("因为P值 < 0.05，我们可以得到患有淋巴结阳性患者的年龄和50岁有显著性不同的结论。 
也就是说，一般的淋巴结阳性患者群体的年龄不是50岁。如果指定平均设定为44岁的话，我们可以得到 P > 0.05。"))
)
)

)
