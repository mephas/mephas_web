#****************************************************************************************************************************************************2. 2-way

sidebarLayout(

sidebarPanel(

  h4(tags$b("第1步 准备数据")),

  p(tags$b("1. 对数值样本和2个因子组命名")),

  tags$textarea(id = "cn", rows = 3, "SBP\nDiet\nSex"),p(br()),

  p(tags$b("2. 输入数据")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("手动输入", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("这个例子是对（3种不同等级的肿瘤和2中不同ER的）100名淋巴结阳性的患者进行的完全无转移随访（月）。"))
    ),

    p(tags$b("请参阅示例输入数据。")),
	p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
	p(tags$b("从CSV复制数据（1列）并将其粘贴到框中")), 
    
    p(tags$b("样本值")),
      tags$textarea(id = "x",rows = 10,
"128.97\n118.76\n128.41\n115.33\n128.07\n110.71\n109.42\n102.20\n110.80\n106.10\n110.20\n116.58\n102.89\n129.92\n129.07\n116.16\n115.71\n102.19\n130.18\n102.73\n109.67\n120.10\n120.20\n110.42\n103.99\n110.05\n109.12\n115.27\n115.30\n119.16\n110.84\n109.47\n104.92\n120.21\n103.11\n119.42\n110.78\n119.56\n120.13\n129.86\n109.74\n116.69\n105.31\n129.51\n127.07\n104.69\n109.99\n119.74\n115.49\n129.63"
),
    p(tags$b("因子组1")),
      tags$textarea(id = "f1",rows = 10,
"NORM\nNORM\nNORM\nLV\nNORM\nSV\nSV\nSV\nSV\nLV\nSV\nLV\nSV\nNORM\nNORM\nLV\nLV\nSV\nNORM\nSV\nSV\nNORM\nNORM\nSV\nSV\nSV\nSV\nLV\nLV\nNORM\nSV\nSV\nLV\nNORM\nSV\nNORM\nSV\nNORM\nNORM\nNORM\nSV\nLV\nLV\nNORM\nNORM\nLV\nSV\nNORM\nLV\nNORM"
),
      p(tags$b("因子组2")),
      tags$textarea(id = "f2",rows = 10,
"Male\nFemale\nMale\nMale\nMale\nMale\nMale\nFemale\nMale\nFemale\nMale\nMale\nFemale\nMale\nMale\nMale\nMale\nFemale\nMale\nFemale\nMale\nFemale\nFemale\nMale\nFemale\nMale\nMale\nMale\nMale\nFemale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nMale\nFemale\nFemale\nMale\nMale\nMale\nFemale\nMale\nMale\nFemale\nMale\nFemale\nMale\nMale"
        ),

    p("缺失值请输入NA。三组数据应有相同的长度，否则会报错。")

        ),
tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote = "quote")

),
hr(),
uiOutput("value2"),
hr(),
  h4(tags$b("假设")),
  p(tags$b("零假设")),
  p("1. 控制第一个因子时的总体均值相等。"),
  p("2. 控制第二个因子时的总体均值相等。"),
  p("3. 这两个因子间没有相互作用"),
  p(tags$b("备择假设")),
  p("1. 第一个因子影响。"),
  p("2. 第二个因子影响。"),
  p("3. 这两个因子之间存在相互作用。"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("个示例想知道在控制ER下，无转移的随访时间是否会因肿瘤等级而有所不同。"))
  )
),

mainPanel(

  h4(tags$b("Output 1. 描述性统计结果")),

    tabsetPanel(

    tabPanel("数据确认", p(br()),
  DT::DTOutput("table"),
  p(tags$b("第一组因子的类别")),
  DT::DTOutput("level.t21"),
  p(tags$b("第二组因子的类别")),
  DT::DTOutput("level.t22")
        ),

    tabPanel("描述性统计", p(br()),
      radioButtons("bas.choice",
      "组别描述统计量:",
      choiceNames = list(
        HTML("1. 第一组因子别"),
        HTML("2. 第二组因子别"),
        HTML("3. 第一和第二组因子别")
        ),
      choiceValues = list("A", "B", "C")
      ),

      DT::DTOutput("bas.t")
      ),

      tabPanel("均值图",p(br()),
      #checkboxInput('tick', 'Tick to change the factor group', FALSE), #p
  shinyWidgets::prettySwitch(
   inputId = "tick",
   label = "变换因子组", 
   status = "info",
   fill = TRUE
),
      plotly::plotlyOutput("meanp.a")
    ),

      tabPanel("周边平均图",p(br()),
      #checkboxInput('tick2', 'Tick to change the factor group', FALSE), #p
  shinyWidgets::prettySwitch(
   inputId = "tick2",
   label = "变换因子组", 
   status = "info",
   fill = TRUE
),
      plotly::plotlyOutput("mmean.a")
      )
    ),

    hr(),

  h4(tags$b("Output 2. 方差分析表")), p(br()),

  #checkboxInput('inter', 'Interaction', TRUE),
  shinyWidgets::prettySwitch(
   inputId = "inter",
   label = "添加相互作用", 
   value = TRUE,
   status = "info",
   fill = TRUE
),
  DT::DTOutput("anova"),p(br()),
  HTML(
  "<b> 说明 </b>
  <ul>
    <li> DF<sub>因子</sub> = 因子组的类别数 -1。</li>
    <li> DF<sub>相互作用</sub> = DF<sub>因子1</sub> x DF<sub>因子2</sub>。</li>
    <li> DF<sub>残差</sub> = 样本值的个数 - 因子组1的类别数 x 因子组2的类别数。</li>
    <li> MS = SS/DF</li>
    <li> F = MS<sub>因子</sub> / MS<sub>残留误差</sub></li>
    <li> P值 < 0.05，则因子的总体均值间存在有意差。（接受备择假设）</li>
    <li> P值 >= 0.05，则因子的总体均值间内没有意差。（接受零假设）</li>
  </ul>"
    ),

    conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("在本例中，饮食类型和性别都会影响SBP（P值<0.001），饮食类型也与性别有显著的相关（P值<0.001）。"))#,
  ),

      hr(),
    HTML("<p><b>P值 < 0.05</b>时、 如果想知道哪些成对因素组明显不同，请使用<b>多重比较</b>。</p>")

  )
)
