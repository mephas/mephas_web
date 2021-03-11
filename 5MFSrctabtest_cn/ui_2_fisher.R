#****************************************************************************************************************************************************2. fisher
sidebarLayout(
sidebarPanel(

  h4(tags$b("第1步 准备数据")),

  p(tags$b("1. 命名2个因素（列名）")),
  tags$textarea(id="cn4", rows=2, "High salt\nLow salt"),

  p(tags$b("2. 命名2病例对照（行名）")), 
  tags$textarea(id="rn4", rows=2, "CVD\nNon CVD"), p(br()),

  p(tags$b("3. 请根据行的顺序输入4个值")),
  p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
  tags$textarea(id="x4", rows=4, 
    "5\n30\n2\n23"),

  p("不可有缺失值"),
conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("病例对照是是否为心血管疾病（CVD）患者， 因素区分是是否摄取高盐分饮食。")),
  p(tags$i("因CVD而死亡的35人中，5人在死亡前摄取高盐分饮食。 其他原因死亡的25人中，2人摄取高盐分饮食。"))
  ),

  hr(),

   h4(tags$b("Step 2. 选择假设")),

   p(tags$b("虚假设")), 
   p("病例对照（行）与分组因子（列）无显著相关"),

    radioButtons("yt4", label = "备择假设", 
        choiceNames = list(
          HTML("病例对照（行）与分组因子（列）显著相关；第1组与第2组的让步比有显著差异"),
          HTML("第1组的让步比高于第2组"),
          HTML("第2组的让步比高于第1组")
          ),
        choiceValues = list("two.sided", "greater", "less")
        ),
    conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("在这个例子中，我们要确定死亡原因和高盐饮食之间是否存在联系。"))
      )

    ),

    mainPanel(

    h4(tags$b("Output 1.  描述性统计结果")), p(br()), 

    tabsetPanel(

    tabPanel("数据确认", p(br()),

        p(tags$b("含有合计的2x2列联表")),
        DT::DTOutput("dt4"),

        p(tags$b("期望值")),
        DT::DTOutput("dt4.0")
        ),

    tabPanel("百分比表", p(br()),

        p(tags$b("单元格/合计 %")),
        DT::DTOutput("dt4.3"),

        p(tags$b("单元格/行的合计 %")),
        DT::DTOutput("dt4.1"),

        p(tags$b("单元格/列的合计 %")),
        DT::DTOutput("dt4.2")
        ),

    tabPanel("比例图", p(br()),
      p(tags$b("以行为单位的百分比")),
      plotly::plotlyOutput("makeplot4"),
      p(tags$b("以列为单位的百分比")),
      plotly::plotlyOutput("makeplot4.1")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 检验结果")), p(br()), 

    DT::DTOutput("c.test4"),

     HTML(
    "<b> 说明 </b> 
    <ul> 
    <li> P < 0.05，则病例对照（行）与分组因子（列）有统计学相关性。 （接受备择假设）</li>
    <li> P > = 0.05，则病例对照（行）与分组因子（列）没有统计学相关性。 （接受虚假设）</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("根据初始设置, 我们使用费雪(Fisher)精确检验，因为我们有两个期望值<5。 根据测试结果，我们得出结论，死亡原因与高盐饮食之间没有显着关联。" ))
)
        )
      )
    