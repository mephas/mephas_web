#****************************************************************************************************************************************************2.prop2
sidebarLayout(
sidebarPanel(

h4(tags$b("第1步  准备数据")),
p(tags$b("命名样本组（必填）")),
tags$textarea(id = "gn",
rows = 5,
"~20\n20-24\n25-29\n30-34\n34~"
),

p(tags$b("命名成功/事件")),
tags$textarea(id = "ln3",
rows = 2,
"Cancer\nNo-Cancer"
),
p(br()), 

p(tags$b("各组的成功数/事件数，x")),
tags$textarea(id = "xx", rows = 5,
"320\n1206\n1011\n463\n220"        
),

p(tags$b("各组的实验数/样本数，n，要求n > x")),     
tags$textarea(id = "nn", rows = 5,
"1742\n5638\n3904\n1555\n626"
),

p("注意：不可以有缺失值"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在此示例中，我们有5个年龄段的人群，如n所示，我们在x中记录了罹患癌症的人数。"))
),

hr(),

h4(tags$b("选择假设")),

p(tags$b("零假设")), 

p("各组的概率/比例相等。"),

p(tags$b("备择假设")), 
p("概率/比例不等。"),          
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这个例子中，我们想知道不同年龄组患癌症的可能性是否不同。"))
)


),

mainPanel(

h4(tags$b("Output 1. 数据确认")), p(br()), 

tabsetPanel(
tabPanel("数据表",p(br()),

p(tags$b("数据表")),
p(br()), 

DT::DTOutput("n.t")

),
tabPanel("百分比图",p(br()),
plotly::plotlyOutput("makeplot3", width = 700)

)
),

hr(),

h4(tags$b("Output 2. 检验结果")), p(br()), 

DT::DTOutput("n.test"),


HTML(
"<b> 说明 </b> 
<ul> 
<li> P值 < 0.05， 则总比例/比率有统计学显著差异。（接受备择假设）
<li> P值 >= 0.05， 则总比例/比率无统计学显著差异。（接受零假设）
</ul>"
),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在此默认设置下，我们得出结论，不同年龄组患癌的可能性显着不同。(P值 < 0.001)"))
)

)
)
