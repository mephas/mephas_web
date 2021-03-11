#****************************************************************************************************************************************************km

sidebarLayout(


sidebarPanel(

tags$head(tags$style("#str {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmt {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmt1 {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmlr {overflow-y:scroll; max-height: 350px; background: white};")),

h4(tags$b("选择分组变量建模")),

p("使用上一个页面（“数据”选项卡）准备数据。"),
hr(),          

p(tags$b("1. 在“数据”选项卡中选中生存对象，Surv(time, event)")), 

uiOutput('g'),
tags$i("在糖尿病数据的示例中，选择“激光”作为分类组变量。即探讨两个激光治疗组的存活曲线是否存在差异。"),

hr(),

h4(tags$b("对数秩(Log-rank Test)检验")),      

p(tags$b("虚假设")),
p("两组的危险函数相同"),

radioButtons("rho", "选择对数秩检验方法", selected=0,
  choiceNames = list(
    HTML("对数秩检验"),
    HTML("Gehan-Wilcoxon检验的Peto&Peto修正")
    ),
  choiceValues = list(0, 1)
  ),
p("参见Output 2中对数秩检验项的方法说明。"),
hr(),

h4(tags$b("成对对数秩检验(Pairwise Log-rank Test)")),      

p(tags$b("虚假设")),
p("两组的危险函数相同"),

radioButtons("rho2", "1. 选择对数秩检验方法", selected=0,
  choiceNames = list(
    HTML("对数秩检验"),
    HTML("Gehan-Wilcoxon检验的Peto&Peto修正")
    ),
  choiceValues = list(0, 1)
  ),
radioButtons("pm", 
  "2. 选择调整P值的方法", selected="BH",
  choiceNames = list(
    HTML("Bonferroni"),
    HTML("Bonferroni-Holm：常用"),
    #HTML("Bonferroni-Hochberg法"),
    #HTML("Bonferroni-Hommel法"),
    HTML("错误发现率-BH(False Discovery Rate-BH)"),
    HTML("错误发现率-BY(False Discovery Rate-BY)")
    ),
  choiceValues = list("B", "BH", "FDR", "BY")
  ),
p("参见Output 2中对数秩检验项的方法说明。")

#tags$style(type='text/css', '#km {background-color: rgba(0,0,255,0.10); color: blue;}'),
#verbatimTextOutput("km", placeholder = TRUE),

),

mainPanel(

h4(tags$b("Output 1. 数据确认")),
 tabsetPanel(
   tabPanel("变量情报",p(br()),
 verbatimTextOutput("str")
 
 ),
tabPanel("数据（一部分）", br(),
p("请在“数据”选项卡中编辑修改数据"),
 DT::DTOutput("Xdata2")
 )

 ),
 hr(),
 
# #h4(tags$b("Output 2. Model Results")),
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. 拟合和预测结果")),
p(br()),
tabsetPanel(
tabPanel("Kaplan-Meier生存概率",  p(br()),
  p(tags$b("组别Kaplan-Meier生存概率")),
    verbatimTextOutput("kmt")
     ),
tabPanel("组别Kaplan-Meier图",  p(br()),
    radioButtons("fun2", "请选择一个图", 
  choiceNames = list(
    HTML("1. 生存概率(存活率)"),
    HTML("2. 累积事件"),
    HTML("3. 累积危险")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
    plotOutput("km.p", width = "80%"),
     verbatimTextOutput("kmt1")
     ),
tabPanel("对数秩检验",  p(br()),
       HTML("
<b> 说明 </b>
<p>在这里，用每次死亡对S(t)<sup>rho</sup>进行加权。 Harrington和Fleming（1982）开发了G-rho家族。其中S是Kaplan-Meier生存估计。</p>
<ul>
<li>rho = 0：对数秩或Mantel-Haenszel检验</li>
<li>rho = 1：Gehan-Wilcoxon检验的Peto&Peto修正</li>
<li>p < 0.05表示存活率曲线有显著性差异</li>
<li>p >= 0.05表示存活率曲线无显著性差异</li>

</ul>"),

p(tags$b("对数秩检验结果")),
    verbatimTextOutput("kmlr"),
    p(tags$i("在本示例中，没有发现2个激光组之间的统计学差异（P=0.8）。Kaplan-Meier曲线显示，2个激光组的存活曲线相互交叉。"))
     ),

tabPanel("成对对数秩检验",  p(br()),


     HTML(
  "<b> 説明 </b>
  <p>在这里，用每次死亡对S(t)<sup>rho</sup>进行加权。 Harrington和Fleming（1982）开发了G-rho家族。其中S是Kaplan-Meier生存估计。</p>
  <ul> 
    <li><b>rho = 0:</b> 对数秩或Mantel-Haenszel检验</li>
    <li><b>rho = 1:</b> Gehan-Wilcoxon检验的Peto&Peto修正</li>
    <li> <b>Bonferroni</b>校正是一种通用但非常保守的方法</li>
    <li> <b>Bonferroni-Holm</b>校正没有Bonferroni保守，比Bonferroni更强大</li>
    <li> <b>错误发现率-BH(False Discovery Rate-BH)</b>由Benjamini和Hochberg开发，比其他方法更强大</li>
	<li> <b>错误发现率-BY(False Discovery Rate-BH)</b>由Benjamini和Yekutieli开发，比其他方法更强大</li>
    <li> p < 0.05表示存活率曲线有显著性差异</li>
    <li> p >= 0.05表示存活率曲线无显著性差异</li>
  </ul>"
    ),
     p(tags$b("成对对数秩检验P值表")),

    DT::DTOutput("PLR")
     )
)

)
)