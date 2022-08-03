#****************************************************************************************************************************************************6. 2k kappa

sidebarLayout(
sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("1. 在列名中为2个相关评分器/排名命名")), 
tags$textarea(id="cn9", rows=2, "Survey1\nSurvey2"),p(br()),


p(tags$b("2. 输入第1评分器的K个值")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
tags$textarea(id="x9", rows=10, 
"1\n2\n3\n4\n5\n6\n7\n8\n9"),
p(br()),

p(tags$b("3. 输入第2评分器的K个值")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
tags$textarea(id="x99", rows=10, 
"1\n3\n1\n6\n1\n5\n5\n6\n7"),

p("不可有缺失值。两组数据需要同样长度。"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("此处的示例为Survey1和Survey2。使用此设置，我们想知道两个排名是否一致。"))
)


),


mainPanel(

h4(tags$b("Output 1. 描述性统计结果")), p(br()), 

tabsetPanel.kappa("含有合计的2xK列联表", "dt9", "dt9.0", "dt9.1"),

# tabsetPanel(


# tabPanel("数据确认", p(br()),
# p(tags$b("含有合计的2xK列联表")),p(br()),
# DT::DTOutput("dt9")
# ),

# tabPanel("一致性表", p(br()),
# DT::DTOutput("dt9.0")
# ),
# tabPanel("权重表", p(br()),
# DT::DTOutput("dt9.1")
# )
# ),

hr(),

h4(tags$b("Output 2. 检验结果")), p(br()), 

DT::DTOutput("c.test9"),p(br()), 

kappa.info(),
p(br()), 
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("此默认设置得出结论；调查1和调查2的答复的可重复性不是很高。"))
)
)
)
