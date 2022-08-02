#****************************************************************************************************************************************************3.1. 2-np-way

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
  p(tags$i("这个示例想知道6对吸烟组的FEF值是否不同。"))
  ),
  hr(),
  h4(tags$b("第2步 选择多重比较方法")),
  radioButtons("methodnp2", 
  "用哪种方法？见下面解释",
  choiceNames = list(
    HTML("Bonferroni's"),
    HTML("Sidak's"),
    HTML("Holm's"),
    HTML("Holm-Sidak"),
    HTML("Hochberg's "),
    HTML("Benjamini-Hochberg"),
    HTML("Benjamini-Yekutieli")
    ),
  choiceValues = list("bonferroni", "sidak", "holm", "hs", "hochberg", "bh", "by")
  ),
   p(br()),
      actionButton("M3", (tags$b("显示結果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
      hr(),
  HTML(
  "<b> 说明 </b>

    <li> <b>Bonferroni</b>调整后的p值 = 最大值(1, pm); m= k(k-1)/2 个对的多重比较。</li>
    <li> <b>Sidak</b>调整后的p值 = 最大值(1, 1 - (1 - p)^m)。</li>
    <li> <b>Holm</b>法调整后的p值 = 最大值[1, p(m+1-i)]；i是排序索引。</li>
    <li> <b>Holm-Sidak</b>调整后的p值 = 最大值[1, 1 - (1 - p)^(m+1-i)]。</li>
    <li> <b>Hochberg</b>法调整后的p值 = 最大值[1, p*i]。</li>
    <li> <b>Benjamini-Hochberg</b>调整后的p值 = 最大值[1, pm/(m+1-i)]。</li>
    <li> <b>Benjamini-Yekutieli</b>调整后的p值 = 最大值[1, pmC/(m+1-i)]; C = 1 + 1/2 + ...+ 1/m。</li>

  "
    )
),

mainPanel(

  h4(tags$b("Output 2. 检验结果")), p(br()),

  p(tags$b("如果P值 <= 0.025，则拒绝零假设。")),

  DT::DTOutput("dunntest.t"),p(br()),
      conditionalPanel(
    condition = "input.explain_on_off",
  
    p(tags$i("在此示例中，吸烟组统计学有意，因此我们可以得出结论，在LS-NI，LS-PS和NI-PS组中，FEF没有显着差异。 对于其他组，P值 <0.025。"))#,
    )

  #downloadButton("downloadnp2.2", "Download Results")


  )
)