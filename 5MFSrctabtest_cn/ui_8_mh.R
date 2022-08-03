#****************************************************************************************************************************************************8. mh

sidebarLayout(
sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("1. 为列名所示的每一类因子指定2个名称")),
tags$textarea(id = "cn8",rows = 2,
"Passive Smoker\nNon-Passive-Smoker"
),
p(tags$b("2. 为行名病例对照指定2个名称")), 
tags$textarea(id = "rn8",rows = 2,
"Cancer (Case)\nNo Cancer (Control)"
),
p(tags$b("3. 为每类混杂因素命名，显示为行名")),
tags$textarea(id = "kn8",rows = 4,
"No-Active Smoker\nActive Smoker"
),
p(br()), 

p(tags$b("3. 按行顺序输入2*2*K值")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
tags$textarea(id="x8", rows=10, 
"120\n111\n80\n115\n161\n117\n130\n124"),
p("不可有缺失值。"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这个示例是两组2x2表。 一个是活跃吸烟者的病例对照表。 另一个是不活跃吸烟者的病例对照表。"))
),

hr(),

h4(tags$b("第2步 选择假设")),

p(tags$b("零假设")), 
p("各分层/混杂组中病例对照（行）与分组因子（列）无显著关联"),

radioButtons("alt8", label = "备择假设", 
choiceNames = list(
HTML("病例对照（行）与分组因子（列）显著相关；各分层的让步比有显著差异"),
HTML("第1层的让步比高于第2层"),
HTML("第2层的让步比高于第1层")
),
choiceValues = list("two.sided", "greater", "less")
),
hr(),

h4(tags$b("第3步 测定P值的方法")),
radioButtons("md8", 
label = "数据的形态", 
choiceNames = list(
HTML("渐近正态P值：样本量不大 (>=15)"),
HTML("近似正态分布：样本量较大（可能>40）"),
HTML("精确P值：样本量小 (<15)")
), 
choiceValues = list("a", "b", "c")),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这个示例我们想确认二手吸烟者与非被动吸烟者肺癌（病例）的比值比是否不同，并能控制个体中的主动吸烟。"))
)

),


mainPanel(

h4(tags$b("Output 1. 描述性统计结果")), p(br()), 

p(tags$b("K层2x2列联表")),
p("前两行显示第一层的2x2列联表，然后显示第二层的2x2列联表。"),p(br()), 

DT::DTOutput("dt8"),

hr(),

h4(tags$b("Output 2. 检验结果")), p(br()), 

DT::DTOutput("c.test8"),
p(br()), 
HTML(
"
<b> 说明 </b> 
<ul> 
<li> P值 < 0.05，则在个人吸烟得到控制的情况下，二手烟与患癌症的风险之间存在显着的关系，让步比有显著不同。（接受备择假设）
<li> P值 > = 0.05，则在控制个人吸烟的情况下，二手烟与癌症风险之间没有显着关系。（接受零假设）
</ul>
"
),
p(br()), 

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("此默认设置的结论是：在控制个人主动吸烟的情况下，癌症风险与二手烟之间存在显着的关系。（P值 < 0.001）"))
)
)
)
