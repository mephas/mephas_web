#****************************************************************************************************************************************************9. cmh

sidebarLayout(
sidebarPanel(

h4(tags$b("第1步 准备数据")),


p(tags$b("1. 为列名所示的每一类因子指定名称")),
tags$textarea(id = "cn7",rows = 4,
"Snoring\nNon-Snoring"
),
p(tags$b("2. 为行名病例对照指定名称")), 
tags$textarea(id = "rn7",rows = 4,
"30-39\n40-49\n50-60"
),
p(tags$b("3. 为每类混杂因素命名，显示为行名")), 
tags$textarea(id = "kn7",rows = 4,
"Women\nMen"
),
p(br()), 

p(tags$b("3. 按行顺序输入 RxCxK 的值")),
p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
tags$textarea(id="x7", rows=10, 
"196\n603\n223\n486\n103\n232\n118\n348\n313\n383\n232\n206"),
p("不可有缺失值。"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("此处的示例为习惯性打鼾的年龄和性别组的患病率。"))
),

hr(),

h4(tags$b("选择假设")),

p(tags$b("零假设")), 
p("各分层/混杂组中病例对照（行）与分组因子（列）无显著关联"),

p(tags$b("备择假设")), 
p("病例对照（行）与分组因子（列）显著相关；各分层的优势比（OR值）有显著差异"),     
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("这个示例我们想确认在控制性别的情况下，习惯性打鼾的发生率是否与年龄有关。"))
)


),


mainPanel(

h4(tags$b("Output 1. 描述性统计结果")), p(br()), 

p(tags$b("K层RxC列联表")),
p("前R行显示第一层的RxC列联表，然后显示第二层的RxC列联表。"),

DT::DTOutput("dt7"),

hr(),

h4(tags$b("Output 2. 检验结果")), p(br()), 

DT::DTOutput("c.test7"),p(br()), 

HTML(
"
<b> 説明 </b> 
<ul> 
<li> P值 < 0.05，则在控制性别的情况下，习惯性打鼾的患病率与年龄显著相关，优势比（OR值）也存在显著差异。（接受备择假设）
<li> P值 > = 0.05，则在控制性别的情况下，习惯性打鼾的患病率与年龄没有显著关系。（接受零假设）
</ul>
"
),
p(br()), 
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("此默认设置的结论是：在控制性别的情况下，习惯性打鼾的患病率与年龄显著相关.（P值 < 0.001）"))
)
)
)
