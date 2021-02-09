#****************************************************************************************************************************************************2.prop2

sidebarLayout(

  sidebarPanel(
    h4(tags$b("第1步  准备数据")),

    p(tags$b("命名样本组（必填）")),
    tags$textarea(id = "cn.2", rows = 2,
        "Birth>30\nBirth<30"
      ),
    p(tags$b("命名成功/事件")),
    tags$textarea(id = "rn.2", rows = 2,
        "Cancer (Case)\nNo-Cancer (Control)"
      ),
    p(br()),

    p(tags$b("请参考示例格式输入数据")),

    p(tags$b("组 1 (病例)")),
      numericInput("x1", "成功数/事件数 (病例组), x1", value =683, min = 0, max = 10000000, step = 1),
      numericInput("n1", "实验数/样本数, n1 > x1", value = 3220, min = 1, max = 10000000, step = 1),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("第一组的样本是3220名乳腺癌女性。 其中，有683人在30岁之后至少有一胎。"))
    ),
    
    p(tags$b("Group 2 (控制)")),  
      numericInput("x2", "成功数/事件数 (控制组), x2", value = 1498, min = 0, max = 10000000, step = 1),
      numericInput("n2", "实验数/样本数 (总数), n2 > x2", value = 10245, min = 1, max = 10000000, step = 1),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("第2组的样本为10245名无乳腺癌女性。 其中，有1498人在30岁之后至少有一胎。"))
    ),

      hr(),

    h4(tags$b("第2步  选择假设")),

     tags$b("虚假设"), 

      HTML("<p> p<sub>1</sub> = p<sub>2</sub>: 第1组和第2组病例的概率/比例相等。 </p>"),
      
      radioButtons("alt1", label = "备择假设", 
        choiceNames = list(
          HTML("p<sub>1</sub> &#8800 p<sub>2</sub>: 病例的概率/比例不相等"),
          HTML("p<sub>1</sub> < p<sub>2</sub>: 第1组病例的概率/比例小于第2组"),
          HTML("p<sub>1</sub> > p<sub>2</sub>: 第1组病例的概率/比例大于第2组")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("在此示例中，我们想知道30岁以上的第一胎的潜在概率在两组中是否不同。"))
    ),
    hr(),
     
    h4(tags$b("第3步  是否进行耶茨校正（Yates-correction）")),
    radioButtons("cr", label = "P值的耶茨校正", 
        choiceNames = list(
          HTML("校正：样本足够大：n1*p*(1-p)>=5 and n2*p*(1-p)>=5, p=(x1+x2)/(n1+n2)"),
          HTML("不校正：n1*p*(1-p)<5 or n2*p*(1-p)<5, p=(x1+x2)/(n1+n2)")
          ),
        choiceValues = list(TRUE, FALSE)
        )

      ),

  mainPanel(

    h4(tags$b("Output 1. 数据确认")), p(br()), 

    p(tags$b("数据表")),
    DT::DTOutput("n.t2"),

    p(tags$b("百分比图")),
    p(tags$b("1. 病例组")),
    plotly::plotlyOutput("makeplot2"),
    p(tags$b("2. 控制组")),
    plotly::plotlyOutput("makeplot2.1"),

    hr(),

    h4(tags$b("Output 2. 检验结果")), p(br()), 

    DT::DTOutput("p.test"),

     HTML(
    "<b> 说明 </b> 
    <ul> 
    <li> P 值 < 0.05， 则两组的总比例/比率有统计学显著差异。（接受备择假设）</li>
    <li> P 值 >= 0.05， 则两组的总比例/比率无统计学显著差异。（接受虚假设）</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
  HTML("<i> 根据默认设置，我们得出结论，与没有乳腺癌的女性相比，患有乳腺癌的女性在30岁以后生下第一个孩子的可能性要大得多。有统计学差异。(P<0.001) </i>")
  )
          ) 

    )
    