#****************************************************************************************************************************************************5. r c chi

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("第1步 准备数据")),

  p(tags$b("1. 命名第一因子的所有分组（列名）")),
        tags$textarea(id = "cn5",rows = 5,
        "Smear+\nSmear-Culture+\nSmear-Culture-"
      ),
    p(tags$b("2. 命名第二因子的所有分组（列名）")), 
        tags$textarea(id = "rn5",rows = 5,
        "Penicillin\nSpectinomycin-low\nSpectinomycin-high"
      ),
        p(br()), 

    p(tags$b("3. 请根据行的顺序输入 R*C 个值")),
      p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
      tags$textarea(id="x5", rows=10, 
      "40\n30\n130\n10\n20\n70\n15\n40\n45"),
      p("不可有缺失值"),
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("行是不同的药物，列是不同的反应.")),
  p(tags$i("在200名青霉素使用者中，有40名是涂片+，30名是涂片-培养+，其他是涂片-培养-。")),
  p(tags$i("在100名大观霉素（低剂量）使用者中，有10名是涂片+，20名是涂片-培养+，其他是涂片-培养-。")),
  p(tags$i("在100名大观霉素（高剂量）使用者中，有15名是涂片+，40名是涂片-培养+，其他是涂片-培养-。"))
  ),

        hr(),

    h4(tags$b("假设")),

   p(tags$b("虚假设")), 
   p("病例对照（行）与分组因子（列）无显著相关"),
    
   p(tags$b("备择假设")), 
   p("病例对照（行）与分组因子（列）显著相关"),     
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("这个示例我们想确认药物和反应之间是否存在关系。"))
    )
   

    ),


    mainPanel(

    h4(tags$b("Output 1. 描述性统计结果")), p(br()), 

    tabsetPanel(

    tabPanel("数据确认", p(br()),
    

        p(tags$b("含有合计的RxC列联表")),
        DT::DTOutput("dt5"),

        p(tags$b("期望值")),
        DT::DTOutput("dt5.0")
        ),
    tabPanel("百分比表", p(br()),

        p(tags$b("单元格/合计 %")),
        DT::DTOutput("dt5.3"),

        p(tags$b("单元格/行的合计 %")),
        DT::DTOutput("dt5.1"),

        p(tags$b("单元格/列的合计 %")),
        DT::DTOutput("dt5.2")
        ),

    tabPanel("比例图", p(br()),

      plotly::plotlyOutput("makeplot5")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 检验结果")), p(br()), 

    DT::DTOutput("c.test5"),

     HTML(
    "<b> 说明 </b> 
    <ul> 
    <li> P < 0.05，则病例/对照（行）与分组因素（列）显着相关。（接受备择假设）</li>
    <li> P > = 0.05，则病例/对照（行）与分组因素（列）间没有统计学相关性。 （接受虚假设）</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("此默认设置得出结论:药物治疗和反应之间存在统计学显著的关系。（P <0.001）"))
     )

        )
      )
    