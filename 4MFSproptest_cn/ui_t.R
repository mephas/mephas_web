#****************************************************************************************************************************************************4.prop.t

 sidebarLayout(
      sidebarPanel(

    h4(tags$b("第1步  准备数据")),
    # p(tags$b("Please follow the example to input your data")),

      p(tags$b("1. 命名样本组（必填）")), 
        tags$textarea(id = "cn4",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

    p(tags$b("2. 命名成功/事件")), 
        tags$textarea(id = "rn4",rows = 2,
        "Cancer\nNo-Cancer"
      ),
    p(br()),

    p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
    p(tags$b("3. 各组的成功数/事件数 (x)")),
    tags$textarea(id = "x4", rows = 5,
    "320\n1206\n1011\n463\n220"        
    ),

    p(tags$b("4. 各组的实验数/样本数（n > x）")),     
    tags$textarea(id = "x44", rows = 5,
    "1742\n5638\n3904\n1555\n626"
    ),

    p("注意：不可以有缺失值"),
    conditionalPanel(
    condition = "input.explain_on_off",

    p(tags$i("在此示例中，我们有5个年龄段的人群，如n所示，我们在x中记录了罹患癌症的人数。"))
    ),

        hr(),

   h4(tags$b("第2步 要检验样本的顺序是什么")),

    p(tags$b("列顺序（与示例长度相同）")),
    tags$textarea(id = "xs", rows = 5,
        "1\n2\n3\n4\n5"        
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("在这个示例里，年龄段的顺序是递增的。"))
    ),

    hr(),

    h4(tags$b("选择假设")),

   p(tags$b("零假设")), 
   p("样本比例没有变化"),
    
   p(tags$b("备择假设")), 
   p("比例/比率/概率随评分而异")   

    ),

    mainPanel(

    h4(tags$b("Output 1. 数据确认")), p(br()), 

    tabsetPanel(

    tabPanel("数据表", p(br()),

        p(tags$b("数据表")),
        DT::DTOutput("dt4"),

        p(tags$b("单元格/列和百分比")),
        DT::DTOutput("dt4.2")
        ),

    tabPanel("百分比图", p(br()),

      plotly::plotlyOutput("makeplot4")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 检验结果")), p(br()), 

    DT::DTOutput("c.test4"),

     HTML(
    "<b> 说明 </b> 
    <ul> 
    <li> P 值 < 0.05， 则病例对照（行）与因素分组（列）显著相关。（接受备择假设）</li>
    <li> P 值 >= 0.05， 则病例控制（行）与分组的因子（列）不关联。（接受零假设）</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("在此默认设置下，我们得出的结论是癌症的比例在不同年龄之间有所不同。（P值 = 0.01）"))
     )

        )
      )
    