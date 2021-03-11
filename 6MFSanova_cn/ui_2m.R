#****************************************************************************************************************************************************2.1. 2-2way

sidebarLayout(

sidebarPanel(

h4(tags$b("多重比较")), 

hr(),
  h4(tags$b("假设")),
  p(tags$b("虚假设")),
  p("各组的均值相等"),
  p(tags$b("备择假设")),
  p("至少两个因子群的均值间存在有意差"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("在这个例子中，我们想知道无转移的随访时间是否取因肿瘤的分级（三个有序的水平）而不同。"))
  ),
hr(),
  h4(tags$b("第2步 选择多重比较方法る")),
  radioButtons("methodm2", 
  "用哪种方法？见下面解释", 
  choiceNames = list(
    #HTML("Bonferroni"),
    #HTML("Bonferroni-Holm: 常用。"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    #HTML("False Discovery Rate-BH"),
    #HTML("False Discovery Rate-BY"),
    HTML("Scheffe法"),
    HTML("Tukey真实显著性差异(Tukey Honest Significant Difference)")
    #HTML("Dunnett")
    ),
  choiceValues = list("SF", "TH")
  ),
        p(br()),
      actionButton("M2", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
hr(),
      HTML(
  "<b> Explanations </b>

    <li> <b>Scheffe</b>法是一种测试，用于在每个组的所有对比中寻找重要的对比。</li>
    <li> 如果实验组和对照组的大小不相等，则建议使用<b>Tukey Honest Significant Difference</b>。</li>
  "
    )


),

mainPanel(

  h4(tags$b("Output 2. 多重比较的结果")), p(br()),

  p(tags$b("因子别成对P值表")),
  DT::DTOutput("multiple.t2"),p(br()),

        HTML(
  "<b> 说明 </b>
  <ul> 
    <li> 在矩阵中，P<0.05表示因子对具有统计学意义。</li>
    <li> 在矩阵中，P>=0.05表示在因子对无显著统计学差异。</li>
  </ul>"
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("在本示例中，在正常和LV，SV和LV，SV和正常以及男性和女性SBP的所有配对中均存在显著差异。"))#,
    )


 # downloadButton("download.m222", "Download Results")
  )
)