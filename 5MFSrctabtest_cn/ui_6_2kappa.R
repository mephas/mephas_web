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

    tabsetPanel(

    tabPanel("数据确认", p(br()),
    p(tags$b("含有合计的2xK列联表")),
    DT::DTOutput("dt9")
    ),

    tabPanel("一致性表", p(br()),
    DT::DTOutput("dt9.0")
    ),
    tabPanel("权重表", p(br()),
    DT::DTOutput("dt9.1")
    )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test9"),

     HTML(
    "<b> Kappa评价说明和指南 </b> 
    <ul>
      <li> <b>Cohen's Kappa 统计系数>0.75</b>： <b>出色的</b> 可重复性 </li>
      <li> <b>0.4<=Cohen's Kappa 统计系数<=0.75</b>： <b>良好的</b> 可重复性</li>
      <li> <b>0<=Cohen's Kappa 统计系数<0.4</b>： <b>较低的</b> 可重复性 </li>
      <li> Cohen’s kappa 考虑了两个评分器之间的偏差，但没有考虑偏差度。</li>
      <li> 加权 kappa 通过预定义权重表进行计算，该权重表权衡两个评分器之间的偏差度。偏差越大，加权越高。</li>
    </ul>

  "
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("此默认设置得出结论:调查1和调查2的答复的可重复性不是很高。"))
  )
        )
      )
    