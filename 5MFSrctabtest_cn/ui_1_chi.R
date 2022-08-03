#****************************************************************************************************************************************************1.chi
sidebarLayout(
sidebarPanel(

h4(tags$b("第1步 准备数据")),

p(tags$b("1. 命名2个因素（列名）")),
tags$textarea(id="cn1", rows=2, "Developed-MI\nNo MI"),

p(tags$b("2. 命名2病例对照（行名）")), 
tags$textarea(id="rn1", rows=2, "OC user\nNever OC user"), p(br()),

p(tags$b("3. 请根据行的顺序输入4个值")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
tags$textarea(id="x1", rows=4, 
"13\n4987\n7\n9993"),

p("不可有缺失值"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("病例对照是口服避孕药使用者和非使用者，因素区分是是否发生心肌梗塞。")),
p(tags$i("口服避孕药使用者5000例中心肌梗塞的发生人为13例、口服避孕药非使用者中是7例。"))
),

hr(),

h4(tags$b("假设")),

p(tags$b("零假设")), 
p("病例对照（行）与分组因子（列）无显著相关"),

p(tags$b("备择假设")), 
p("病例对照（行）与分组因子（列）显著相关"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这个示例我们想确认口服避孕药和心肌梗塞发生率的上升是否有关联。"))
),

hr(),

h4(tags$b("第2步 测定P值的方法")),
radioButtons("yt1", label = "P值的耶茨校正", 
choiceNames = list(
HTML("使用：期望值全部>=5，但期望值不是那么大"),
HTML("不使用：有相当大的样本")
),
choiceValues = list(TRUE, FALSE)
)
),

mainPanel(

h4(tags$b("Output 1. 描述性统计结果")), p(br()), 

tabsetPanel(

tabPanel.checktab("含有合计的2x2列联表", "dt1", "dt1.0"),
tabPanel.perctab("dt1.1", "dt1.2", "dt1.3"),
tabPanel.countplot2("makeplot1", "makeplot1.1")

),

hr(),

h4(tags$b("Output 2. 检验结果")), p(br()), 

DT::DTOutput("c.test1"),p(br()), 

HTML(
"
<b> 说明 </b> 
<ul> 
<li> P值 < 0.05，则病例对照（行）与分组因子（列）有统计学相关性。 （接受备择假设）
<li> P值 > = 0.05，则病例对照（行）与分组因子（列）没有统计学相关性。 （接受零假设）
</ul>
"
),
p(br()), 

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("根据初始设置, 我们可以得到心肌梗塞发生率和口服避孕药的使用是有统计学的关联的结论 （P值 = 0.01）。
  这里最小期望值为6.67，我们使用了耶茨校正。" ))
)
)
)
