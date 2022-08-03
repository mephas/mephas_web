#****************************************************************************************************************************************************2.1. 2-2way

sidebarLayout(

sidebarPanel(

h4(tags$b("多重比较")), 

hr(),
h4(tags$b("假设")),
p(tags$b("零假设")),
p("各组的均值相等"),
p(tags$b("备择假设")),
p("至少两个因子群的均值间存在有意差"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在这个例子中，我们想知道无转移的随访时间是否取因肿瘤的分级（三个有序的水平）而不同。"))
),
hr(),
h4(tags$b("第2步 选择多重比较方法")),
p(br()),

radioGroupButtons(
inputId = "methodm2", 
selected="SF",
label = "用哪种方法？见下面解释", 
choiceNames = list(
("Scheffe法"),
("Tukey法")
),
choiceValues = list("SF", "TH"),
direction = "vertical",
justified = TRUE,
individual = FALSE,
checkIcon = list(
yes = tags$i(class = "fa fa-circle", 
style = "color: steelblue"),
no = tags$i(class = "fa fa-circle-o", 
style = "color: steelblue"))
),
p(br()),

actionButton("M2", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
hr(),
HTML(
"
<b> 解释 </b>

<li> <b>Scheffe</b>法是一种测试，用于在每个组的所有对比中寻找重要的对比
<li> 如果实验组和对照组的大小不相等，则建议使用<b>Tukey法（Tukey Honest Significant Difference）</b>
"
)

),

mainPanel(

h4(tags$b("Output 2. 多重比较的结果")), 
p(br()),

p(tags$b("因子别成对P值表")),
p(br()),

DT::DTOutput("multiple.t2"),
p(br()),

HTML(
"<b> 说明 </b>
<ul> 
<li> 在矩阵中，P值<0.05表示因子对具有统计学意义
<li> 在矩阵中，P值>=0.05表示在因子对无显著统计学差异
</ul>"
),
p(br()),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("在本示例中，在正常和LV，SV和LV，SV和正常以及男性和女性SBP的所有配对中均存在显著差异。"))#,
)


# downloadButton("download.m222", "Download Results")
)
)