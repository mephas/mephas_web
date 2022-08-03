#****************************************************************************************************************************************************2.t2
sidebarLayout(

sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("1. 命名数据（必填）")),

tags$textarea(id = "cn2", rows = 2, "Age\nGroup"), p(br()),

p(tags$b("2. 数据输入")),

tabsetPanel(
##-------input data-------##
tabPanel("手动输入", p(br()),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这个例子里，雌激素受体 (ER) 阳性患者27人的年龄为（Group.1-Age.positive），ER 阴性患者117人的年龄为（Group.2-Age.negative）。"))
),

p(tags$b("请参考示例格式上传数据")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
p(tags$b("从CSV（一列）复制数据并粘贴到框中")), 
p(tags$b("组 1")),
tags$textarea(id = "x1",rows = 10,
"47\n45\n31\n38\n44\n49\n48\n44\n47\n45\n37\n43\n49\n32\n41\n38\n37\n44\n45\n46\n26\n49\n48\n45\n46"
),
p(tags$b("组 2")),
tags$textarea(id = "x2",rows = 10,
"50\n42\n50\n43\n47\n38\n41\n48\n47\n36\n42\n42\n45\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48"
),

p("缺失值处输入空格，保证2个组数据长度相等；否则会出错。")

),
tabPanel.upload.num(file ="file2", header="header2", col="col2", sep="sep2")

),

hr(),

h4(tags$b("选择假设")),

h4(tags$b("第2步 方差等价性")),
p("进行T检验前，需要检查方差的等价性，然后决定使用哪种T检验。"),
p(tags$b("零假设")),
HTML("<p> v1 = v2: 第1组和第2组总体方差相等 </p>"),

radioButtons("alt.t22", #p
label = "备择假设",
choiceNames = list(
HTML("v1 &#8800 v2: 第1组和第2组总体方差不等"),
HTML("v1 < v2: 第1组总体方差小于第2组"),
HTML("v1 > v2: 第1组总体方差大于第2组")
),
choiceValues = list("two.sided", "less", "greater")),
hr(),

h4(tags$b("第3步 T 检验")),

p(tags$b("零假设")),
HTML("<p> &#956&#8321 = &#956&#8322: 第1组和第2组的总体平均相等</p>"),

radioButtons("alt.t2", #p
label = "备择假设",
choiceNames = list(
HTML("&#956&#8321 &#8800 &#956&#8322: 第1组和第2组总体平均不等"),
HTML("&#956&#8321 < &#956&#8322: 第1组总体平均小于第2组"),
HTML("&#956&#8321 > &#956&#8322: 第1组总体平均大于第2组")
),
choiceValues = list("two.sided", "less", "greater")),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这里的初始设定为：我们想知道ER阳性患者和ER阴性患者的平均年龄是否存在统计学差异。"))
)


),

mainPanel(

h4(tags$b("Output 1. 描述性统计结果")),

tabsetPanel(

tabPanel("数据确认", p(br()), DT::DTOutput("table2")),

tabPanel("描述性统计量", p(br()), DT::DTOutput("bas2")),

##
tabPanel.boxplot("bp2"),

tabPanel.msdplot("meanp2"),

tabPanel.pdfplot("makeplot2", "makeplot2.3", "makeplot2.4")

),

hr(),

h4(tags$b("Output 2. 检验结果 1")), 
p(br()),

tags$b("两组方差等价性的确认"),
p(br()),

DT::DTOutput("var.test"),
p(br()),

HTML(
"
<b> 说明 </b>
<ul>
<li> 当P < 0.05时，请使用<b>韦尔奇t检验（Welch Two-Sample t-test）</b>的结果
<li> 当P >= 0.05时，请使用<b>两样本t检验（Two-Sample t-test）</b>的结果
</ul>
"
),
p(br()),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这个例子里，因为F检验的P値大约为0.15（> 0.05），数据的方差具有等价性，所以我们使用“独立双样本t检验”的结果"))
),

hr(),

h4(tags$b("Output 3. 检验结果 2")),
p(br()),

tags$b("选择 T 检验"),
p(br()),

DT::DTOutput("t.test2"),
p(br()),

HTML(
"<b> 说明 </b>
<ul>
<li> P值 < 0.05，则2组数据的总体均值有显著差异。（接受备择假设）
<li> P值 >= 0.05，则2组数据的总体均值无显著差异。（接受零假设）
</ul>"
),
p(br()),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这个例子里，我们可以得到ER阳性患者和阴性患者的总体年龄没有统计学差异（P = 0.55，“独立双样本t检验”的结果）"))
)
)
)
