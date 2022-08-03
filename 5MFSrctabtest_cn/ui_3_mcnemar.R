#****************************************************************************************************************************************************3. mcnemar

sidebarLayout(
sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("1. 在列名和行名中为每个共通结果类别指定2个名称")),
tags$textarea(id="cn2", rows=2, "Better\nNo-change"), 

p(tags$b("2. 在行名和列名中为因子/治疗指定2个名称")), 
tags$textarea(id="rn2", rows=2, "Treatment-A\nTreatment-B"),p(br()),


p(tags$b("3. 请根据行的顺序输入4个值")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
tags$textarea(id="x2", rows=4, 
"510\n16\n5\n90"),
p("不可有缺失值"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("此处显示的示例是621对患者，一组接受治疗A，另一组接受治疗B。 患者的年龄和临床状况处于配对状态。")),
p(tags$i("在621对患者中，治疗A和治疗B均优于510对，90对未发生变化。（一致组）")),
p(tags$i("16对只有在治疗A后才更好。 5对只有在治疗B后才更好。 （不一致组）"))
),

hr(),

h4(tags$b("假设")),

p(tags$b("零假设")), 
p("因子间无显著差异"),

p(tags$b("备择假设")), 
p("因子在配对样本中存在显著差异"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这个示例我们想确认匹配对组成的处置（治疗）间是否有有意差。 "))
),

hr(),

h4(tags$b("第2步 测定P值的方法")),
radioButtons("yt2", label = "P值的耶茨校正", 
choiceNames = list(
HTML("使用：期望值都>=5，但期望值不是那么大"),
HTML("不使用：有相当大的样本")
),
choiceValues = list(TRUE, FALSE)
)

),

mainPanel(

h4(tags$b("Output 1. 描述性统计结果")), p(br()), 

tabsetPanel(


tabPanel.checktab("含有合计的2x2列联表", "dt2", "dt2.0"),
tabPanel.perctab("dt2.1","dt2.2","dt2.3"),
tabPanel.countplot1("makeplot2")

),

hr(),

h4(tags$b("Output 2. 检验结果")), p(br()), 

DT::DTOutput("c.test2"),p(br()), 

HTML(
"
<b> 说明 </b> 
<ul> 
<li> P值 < 0.05，则因子在配对样本间存在有意差。 （接受备择假设）
<li> P值 >= 0.05，则因子没有统计学相关性。 （接受零假设）
</ul>
"
),
p(br()), 

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("根据初始设置, 我们得出两个治疗会导致配对患者间有统计学意义的不同效果的结论。（P值 = 0.03）"))
)
)
)
