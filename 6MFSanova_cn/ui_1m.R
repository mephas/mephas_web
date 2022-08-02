#****************************************************************************************************************************************************1.1. 2-1way

sidebarLayout(

sidebarPanel(

h4(tags$b("多重比较")), 

hr(),
  h4(tags$b("假设")),
  p(tags$b("零假设")),
  p("在一对因子中，每对均值相等。"),
  p(tags$b("备择假设")),
  p("在一对因子中，每对均值显著不同。"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("在此示例中，想知道六个吸烟组中的哪个组间具有不同的FEF值。"))
  ),
hr(),
  h4(tags$b("第2步 选择多重比较方法")),
  radioButtons("method", 
  "用哪种方法？见下面解释，并点击显示结果。", selected="BH",
  choiceNames = list(
    HTML("Bonferroni法"),
    HTML("Bonferroni-Holm法：常用。"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    HTML("FDR-BH(False Discovery Rate-BH)"),
    HTML("FDR-BY(False Discovery Rate-BY)"),
    HTML("Scheffe法"),
    HTML("Tukey真实显著性差异(Tukey Honest Significant Difference)"),
    HTML("Dunnett法")
    ),
  choiceValues = list("B", "BH", "FDR", "BY", "SF", "TH", "DT")
  ),
  uiOutput("dt.ref"),
      p(br()),
      actionButton("M1", (tags$b("显示结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
hr(),
      HTML(
  "<b> 说明 </b>
  
    <li> <b>Bonferroni</b>校正是一种常见但非常保守的方法。</li>
    <li> <b>Bonferroni-Holm</b>校正不如Bonferroni方法保守，比Bonferroni校正更强。</li>
    <li> Benjamini和Hochberg发表的<b>FDR-BH</b>法可以控制伪发现率。</li>
    <li> Benjamini和Yekutieli发表的<b>FDR-BY</b>法可以控制伪发现率。</li>
    <li> <b>Scheffe</b>法是一种测试，用于在每个组的所有对比中寻找重要的对比。</li>
    <li> 如果实验组和对照组的大小不相等，则建议使用<b>Tukey Honest Significant Difference</b>。</li>
    <li> <b>Dunnett</b>将所有组与对照组进行比较。</li>
  "
    )

),

mainPanel(

  h4(tags$b("Output 3. 多重比较的结果")), p(br()),

  #numericInput("control", HTML("* 针对Dunnett方法，可以从上面的因子群中更改控制因子。"), 
  #  value = 1, min = 1, max = 20, step=1),

  p(tags$b("成对P值表")),
  DT::DTOutput("multiple.t"),p(br()),

      HTML(
  "<b> 説明 </b>
  <ul> 
    <li> 在矩阵中，P值<0.05表示因子对具有统计学意义。</li>
    <li> 在矩阵中，P值>=0.05表示在因子对无显著统计学差异。</li>
  </ul>"
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("在本示例中，我们使用Bonferroni-Holm方法研究了P <0.05的可能因子对。 
      HS与其他组有统计学上的明显差异。
	  LS与MS和NS有统计学上的差异。
      MS与NI和PS有统计学上的差异。
      NI与NS有统计学上的差异。"))#,
    )

  #downloadButton("download.m1", "結果をダウンロードする")
  )
)