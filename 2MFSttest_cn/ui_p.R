#****************************************************************************************************************************************************3.tp

sidebarLayout(

sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("1. 命名数据（必填）")),

tags$textarea(id = "cn.p", rows = 3, "Before\nAfter\nAfter-Before"), p(br()),

p(tags$b("2. 数据输入")),

tabsetPanel(
##-------input data-------##
tabPanel("手动输入", p(br()),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这个例子里，我们研究某种药物是否影响睡眠时间。 这里输入的是药物服用前后的睡眠时间的记录。"))
),

p(tags$b("请参考示例格式上传数据")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
p(tags$b("从CSV（一列）复制数据并粘贴到框中")),   
p(tags$b("组 1 (服用前)")),
tags$textarea(id = "x1.p",rows = 10,
"0.6\n3\n4.7\n5.5\n6.2\n3.2\n2.5\n2.8\n1.1\n2.9"
),
p(tags$b("组 2 (服用后)")),
tags$textarea(id = "x2.p",rows = 10,
"1.3\n1.4\n4.5\n4.3\n6.1\n6.6\n6.2\n3.6\n1.1\n4.9"
),
p("缺失值输入NA，保证2个集长度相等；否则会出错")

),

tabPanel.upload.num(file ="file.p", header="header.p", col="col.p", sep="sep.p")

),

hr(),

h4(tags$b("第2步 选择假设")),

tags$b("零假设"),
HTML("<p> &#916 = 0: 第1组（前）和第2组（后）等效 </p>"),

radioButtons(
"alt.pt",
label = "备择假设",
choiceNames = list(
HTML("&#916 &#8800 0: 第1组（前）和第2组（后）不等效"),
HTML("&#916 < 0: 第2组（后）比第1组（前）的睡眠时间短"),
HTML("&#916 > 0: 第2组（后）比第1组（前）的睡眠时间长")
),
choiceValues = list("two.sided", "less", "greater")
),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这里的初期设定为我们想知道药物是否有效果。也就是说，我们想要检验药物服用后，睡眠时间是否会有变化。"))
)

),

mainPanel(

h4(tags$b("Output 1. 描述性统计结果")),

tabsetPanel(

tabPanel("数据确认", 		p(br()),	DT::DTOutput("table.p")),

tabPanel("描述性统计量", 	p(br()),	tags$b("差的描述性统计"),	p(br()),	DT::DTOutput("bas.p")),

tabPanel.boxplot("bp.p"),

tabPanel.msdplot("meanp.p"),

tabPanel.pdfplot("makeplot.p", "makeplot.p2", "makeplot.p3", "bin.p")

),

hr(),

h4(tags$b("Output 2. 检验结果")),
p(br()),

DT::DTOutput("t.test.p"),
p(br()),

HTML(
"<b> 说明 </b>
<ul>
<li> P值 < 0.05，则第1组（服用前）和第2组（服用后）存在统计学差异。（接受备择假设）
<li> P值 >= 0.05，则2组数据没有统计学差异。(接受零假设)
</ul>"
),
p(br()),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("根据初始设定，结果为该药物对睡眠时间不具有影响。（P值= 0.2）"))
)
)
)
