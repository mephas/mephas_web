#****************************************************************************************************************************************************1.prop1
  sidebarLayout(

    sidebarPanel(

    h4(tags$b("第1步  准备数据")),

    p(tags$b("命名数据（必填）")),
    tags$textarea(id = "ln", rows = 2, "Infertility\nfertility "), p(br()),
    
    p(tags$b("请参考示例格式输入数据")),

      numericInput("x", "成功数/事件数, x", value = 10, min = 0, max = 100000, step = 1),
      numericInput("n", "实验数/样本数, n > x", value = 40, min = 1, max = 100000, step = 1),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("本示例数据的事件数为10，总样本数为40."))
    ),
    hr(),

    h4(tags$b("第2步  指定参数")),

      numericInput('p', HTML("要与之比较的指定比率/比例/概率(0 < p<sub>0</sub> < 1)"), value = 0.2, min = 0, max = 1, step = 0.1),
        conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("我们要比较的是一般不孕率（20％）。"))
      ),

      hr(),

    h4(tags$b("第3步  选择假设")),

    p(tags$b("虚假设")), 
    HTML("<p>p = p<sub>0</sub>: 概率/比例为p<sub>0</sub></p>"),
    
    radioButtons("alt", 
      label = "备择假设", 
      choiceNames = list(
        HTML("p &#8800 p<sub>0</sub>: 概率/比例不是p<sub>0</sub>"),
        HTML("p < p<sub>0</sub>: 概率/比例小于p<sub>0</sub>"),
        HTML("p > p<sub>0</sub>: 概率/比例大于p<sub>0</sub>")),
      choiceValues = list("two.sided", "less", "greater")
      ),
    conditionalPanel(
    condition = "input.explain_on_off",
   p(tags$i("在示例里，我们想要检验治疗女性的不孕率和一般的20%相比是否存在统计学差异,所以我们选择第一种备择假说。"))
   )

      ),

  mainPanel(

    h4(tags$b("Output 1. 比率图")), p(br()), 

    plotly::plotlyOutput("makeplot"),

    hr(),

    h4(tags$b("Output 2. 检验结果")), p(br()), 

    HTML("<b>1. np<sub>0</sub>(1-p<sub>0</sub>) >= 5时，使用耶茨连续性校正（Yates' Continuity Correction）的正态理论方法</b>"), p(br()), 

    DT::DTOutput("b.test1"),

    HTML("<b>2. np<sub>0</sub>(1-p<sub>0</sub>) < 5时，使用精确二项方法(Exact Binomial Method)</b>"),  
    p(br()), 

    DT::DTOutput("b.test"),

     HTML(
    "<b> 说明 </b> 
    <ul> 
    <li> P 值 < 0.05， 则全体比例/比率和指定比例/比率相比有统计学差异。（接受备择假设）</li>
    <li> P 值 >= 0.05， 则全体比例/比率和指定比例/比率相比无统计学差异。（接受虚假设）</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
  HTML("<i> 根据初始设置, 我们可以得到治疗女性的不孕率和一般的20%相比是没有统计学差异的(P = 0.55). 在这个示例里， np<sub>0</sub>(1-p<sub>0</sub>)=40*0.2*0.8 > 5, 因此，适用 <b>正态理论方法（Normal Theory Method）</b> 。 </i>")
  )


    )
  )
