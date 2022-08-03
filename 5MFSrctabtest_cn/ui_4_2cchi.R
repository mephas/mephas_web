#****************************************************************************************************************************************************4. 2 c chi
sidebarLayout(
sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("1. 命名所有分组因子（列名）")),
tags$textarea(id = "cn3",rows = 5,
"~20\n20-24\n25-29\n30-34\n34~"
),
p(tags$b("2. 命名2病例对照（行名）")), 
tags$textarea(id = "rn3",rows = 2,
"Cancer\nNo-Cancer"
),

p(br()), 

p(tags$b("3. 各组的病例数")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
tags$textarea(id = "x3", rows = 5,
"320\n1206\n1011\n463\n220"        
),

p(tags$b("4. 各组的对照数")), 
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
tags$textarea(id = "x33", rows = 5,
"1422\n4432\n2893\n1092\n406"
),

p("不可有缺失值"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在此示例中，有不同年龄的患者。我们根据五个年龄组，记录了有无癌症的人数。"))
),

hr(),

h4(tags$b("假设")),

p(tags$b("零假设")), 
p("病例对照（行）与分组因子（列）无显著相关"),

p(tags$b("备择假设")), 
p("病例对照（行）与分组因子（列）显著相关"),     
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这里，我们想知道癌和年龄渐是否有关系。"))
)


),


mainPanel(

h4(tags$b("Output 1. 描述性统计结果")), p(br()), 

tabsetPanel(

tabPanel.checktab("含有合计的2xC列联表", "dt3", "dt3.0"),
tabPanel.perctab("dt3.1","dt3.2","dt3.3"),
tabPanel.countplot1("makeplot3")
),

h4(tags$b("Output 2. 检验结果")), p(br()), 

DT::DTOutput("c.test3"),p(br()), 

HTML(
"
<b> 说明 </b> 
<ul> 
<li> P值 < 0.05，则病例/对照（行）与分组因素（列）显着相关。（接受备择假设）
<li> P值 >= 0.05，则病例/对照（行）与分组因素（列）间没有统计学相关性。 （接受零假设）
</ul>
"
),
p(br()), 

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("此默认设置得出结论:癌症与年龄之间存在显着关系。（P值 < 0.001）"))
)

)
)
