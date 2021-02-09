#****************************************************************************************************************************************************1.np1

sidebarLayout(

sidebarPanel(

  h4(tags$b("第1步  准备数据")),

  p(tags$b("1. 命名数据（必填）")),

  tags$textarea(id="cn", rows= 1, "Scale"), p(br()),

  p(tags$b("2. 数据输入")),

  tabsetPanel(
  ##-------input data-------##
  tabPanel("手动输入", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("这里的数据是一组9名患者的抑郁评定量表(DRS) 测量结果. "))
    ),

    p(tags$b("请参考示例格式上传数据")),
    p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
    p(tags$b("从CSV（一列）复制数据并粘贴到框中")),   
    tags$textarea(id="a",
      rows=5,
      "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
      ),

    p("缺失值输入NA")

    ),
  tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")

    ),

  hr(),
  h4(tags$b("第2步  指定参数")),
  numericInput("med", HTML("指定要与数据进行比较的中位数(m&#8320)"), 1),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("在初始设定里，我们想要知道这组患者是否被抑郁症所困扰(测量结果 > 1)。"))
    ),
  hr(),

  h4(tags$b("第3步  选择假设")),
  p(tags$b("虚假设")),

  HTML("<p> m = m&#8320: 总体中位数等于指定中位数( m&#8320) </p>
        <p>或，数据集的分布关于指定中位数对称</p>"),

  radioButtons("alt.wsr",
    label = "备择假设", selected = "greater",
    choiceNames = list(
    HTML("m &#8800 m&#8320: 总体中位数与指定中位数有显著差异"),
    HTML("m > m&#8320: 总体中位数大于指定中位数"),
    HTML("m < m&#8320: 总体中位数小于指定中位数")
    ),
  choiceValues = list("two.sided", "greater", "less")),
  hr(),
  conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("在初始设定里，我们想要知道这组患者是否被抑郁症所困扰(测量结果 > 1)。"))
    ),

  h4(tags$b("第4步  测定P值的方法")),
  radioButtons("alt.md",
    label = "数据是什么样的", selected = "c",
    choiceNames = list(
      HTML("近似正态分布P值：样本量大"),
      HTML("渐近正态分布P值：样本量大"),
      HTML("精确P值：样本量小 (<50)")
      ),
    choiceValues = list("a", "b", "c")),
      conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("在这个示例里，我们只有9名患者。因此，我们使用精确P值。"))
    )

  ),

mainPanel(

  h4(tags$b("Output 1. 描述性统计结果")),

  tabsetPanel(

    tabPanel("数据确认", p(br()),
      DT::DTOutput("table")
      ),

    tabPanel("描述性统计量", p(br()),

        DT::DTOutput("bas")
      ),

    tabPanel("箱形图", p(br()),

        plotly::plotlyOutput("bp"), #, click = "plot_click"

        #verbatimTextOutput("info"), hr(),

          HTML(
          "<b> 说明 </b>
          <ul>
            <li> 框内的条带为中位数</li>
            <li> 方框测量了第75和第25个百分位数之间的差值</li>
            <li> 如果存在离群值，将显示为红色</li>
          </ul>"

          )
      ),

    tabPanel("直方图", p(br()),
            HTML(
          "<b> 说明 </b>
          <ul>
            <li> 直方图：通过描述某一数值范围内出现的观察值频率，粗略评估给定变量的概率分布</li>
            <li> 密度图：估计数据的概率密度函数</li>
          </ul>"
            ),
      p(tags$b("直方图")),
      plotly::plotlyOutput("makeplot"),
      sliderInput("bin","直方图的分箱数",min = 0,max = 100,value = 0),
      p("当分箱数为0时，绘图将使用默认分箱数"),
      p(tags$b("密度图")),
      plotly::plotlyOutput("makeplot.1")

      )
    ),
hr(),
h4(tags$b("Output 2. 检验结果")),
    p(tags$b('威尔科克森符号秩检验结果')), p(br()),
    DT::DTOutput("ws.test.t"),

    HTML(
    "<b> 说明 </b>
    <ul>
    <li> P值 < 0.05，则总体中位数与指定中位数有统计学显著差异。（接受备择假设）</li>
    <li> P值 >= 0.05，则总体中位数与指定中位数无统计学显著差异。（接受虚假设）</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("根据初始设置, 我们可以得到测量结果显著大于1的结论 (P = 0.006)，表明患者处于抑郁症的困扰."))
  )#,
  )
)
