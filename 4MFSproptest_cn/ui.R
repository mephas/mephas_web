##------------------------------------------------------
##
## Binary outcome test ui CN
##
## Date: 2018-11-30
##
##------------------------------------------------------

shinyUI(

tagList(
#shinythemes::themeSelector(),
navbarPage(
 
  title = "二项式比例检验",

# 1. Chi-square test for single sample 
  tabPanel("单一比例",

    titlePanel("精确二项检验(Exact binomial test)"),

#tags$b("Introduction"),

#p("To test the probability of events (success) in a series of Bernoulli experiments. "),

    tags$b("前提假设"),
    HTML("
      <ul>
      <li> 观测值来自二项分布 </li>
      <li> 二项分布的正态近似是有效的 </li>
      </ul>" 
      ),

    tags$b("注释"),
    HTML("
      <ul>
      <li> x 是事件的数量</li>
      <li> n 是总的检验次数</li>
      <li> p 是事件发生的的潜在概率</li>
      <li> p&#8320 是特定概率</li>
      </ul>" ),

    p(br()),

  sidebarLayout(

    sidebarPanel(

    helpText("假设检验"),
    tags$b("零假设"), 
    HTML("<p>p = p&#8320: 事件的概率是 p&#8320 </p>"),
    
    radioButtons("alt", 
      label = "对立假设", 
      choiceNames = list(
        HTML("p &#8800 p&#8320: 事件的概率不是 p&#8320"),
        HTML("p < p&#8320: 事件的概率小于 p&#8320"),
        HTML("p > p&#8320: 事件的概率大于 p&#8320")),
      choiceValues = list("two.sided", "less", "greater")),

    hr(),

    tabsetPanel(
      ##-------input data-------## 
      tabPanel("手动输入", 
      p(br()),    
      numericInput("x", "事件数, x", value = 5, min = 0, max = 10000, step = 1),
      numericInput("n", "检验次数, n", value = 10, min = 1, max = 50000, step = 1),
      numericInput('p', HTML("特定概率, p&#8320"), value = 0.5, min = 0, max = 1, step = 0.1))
      )
    ),

  mainPanel(
    h4(tags$b("检验结果")), 
    p(br()), 
    tableOutput("b.test"),
  #tags$b("Interpretation"), wellPanel(p("When p-value is less than 0.05, it indicates that the underlying probability is far away from the specified value.")),
    hr(),
    h4(tags$b('比例饼图')), 
    plotOutput("makeplot", width = "400px", height = "400px")
    )
  )
),

# 2. Chi-square test for 2 independent sample
  tabPanel("独立组的两个比例",

    titlePanel("卡方检验(Chi-square Test), 费希尔精确检验(Fisher's Exact Test)"),

#tags$b("Introduction"),
#p("To test the difference between the sample proportions"),

    sidebarLayout(
      sidebarPanel(
        helpText("2 x 2 表"),
        
        splitLayout(
          verticalLayout(
            tags$b("组名"),
            tags$textarea(id="cn", label = "Group names", rows=4, cols = 20, "Group1\nGroup2")
            ),
          
          verticalLayout(
            tags$b("状态"), 
            tags$textarea(id="rn", label = "Status", rows=4, cols = 20, "Case\nControl")
            )
          ),

        h4(tags$b("数据输入")),
        tabPanel("Manually input values into Group 1 and Group 2",
        
          splitLayout(
            verticalLayout(
              tags$b("第一列"), 
              tags$textarea(id="x1", rows=4, "10\n20")
              ),
            verticalLayout(
              tags$b("第二列"),
              tags$textarea(id="x2", rows=4, "30\n35")
              )
            ),
          h4("显示数据表"), 
          tableOutput("t")
          )
        ),

      mainPanel(
        h4(tags$b("期望值")), 
        tableOutput("e.t"),
        helpText("当每个单元格中的期望值小于5时，应该进行校正或Fisher精确检验."),
        h4(tags$b("列的百分比")), 
        tableOutput("p.t"),
        h4(tags$b('比例饼图')), 
        plotOutput("makeplot2", width = "600px", height = "300px") 
        )
      ),

    sidebarLayout(
      sidebarPanel(
  
      h4(tags$b("卡方检验(Chi-square Test)")),

      tags$b("前提假设"),
      p("每个单元格中的期望值大于5."),

      helpText("假设检验"),
      tags$b("零假设"), 
      HTML("<p> p&#8321 = p&#8322: 两组数据的概率相等. </p>"),
      
      radioButtons("alt1", label = "对立假设", 
        choiceNames = list(
          HTML("p&#8321 &#8800 p&#8322: 两组数据的概率不相等."),
          HTML("p&#8321 < p&#8322: 第一组的数据的概率小于第二组."),
          HTML("p&#8321 > p&#8322: 第一组的数据的概率大于第二组.")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),

      radioButtons("cr", label = "雅茨校正(Yates-correction)", 
        choiceNames = list(
          HTML("No: 所有单元格的期望值都不小于5."),
          HTML("Yes: 至少有一个单元格的期望值小于5.")
          ),
        choiceValues = list(FALSE, TRUE)
        )
      ),

      mainPanel(
        h4(tags$b("结果")), tableOutput("p.test")
        #tags$b("Interpretation"), p("Chi-square.test")
        )
      ),

    sidebarLayout(

      sidebarPanel(

      h4(tags$b("费希尔精确检验(Fisher's Exact Test)")),

      tags$b("前提假设"),
      HTML("
        <ul>
        <li> 二项分布的正态近似是无效的.</li>
        <li> 所有单元格的期望值都小于5.</li>
        </ul>" )
      ),

      mainPanel(
        h4(tags$b("结果")), 
        tableOutput("f.test")
      #tags$b("Interpretation"), p("Fisher's exact test")
        )
    )
    ),

# 3. Chi-square test for 2 paired-independent sample ---------------------------------------------------------------------------------
    tabPanel("配对数据的两个比例",

    titlePanel("麦克尼马尔检验(McNemar's Test)"),

#tags$b("Introduction"),
#p("To test the difference between the sample proportions"),

    p(br()),

    sidebarLayout(
      sidebarPanel(

      helpText("假设检验"),
      tags$b("零假设"), 
      HTML("<p> 被分类为单元格[i，j]和[j，i]的概率是相同的.</p>"),
      tags$b("对立假设"), 
      HTML("<p> 被分类为单元格[i，j]和[j，i]的概率是不同的.</p>"),
      hr(),

      helpText("2 x 2 表"),
      splitLayout(
        verticalLayout(
          tags$b("A处理的结果"),
          tags$textarea(id="ra", rows=4, cols = 20, "Result1.A\nResult2.A")
          ),
        
        verticalLayout(
          tags$b("B处理的结果"), 
          tags$textarea(id="cb", rows=4, cols = 20, "Result1.B\nResult2.B")
          )
        ),

      h4(tags$b("数据输入")),
      tabPanel("手动录入Group 1和Group 2的数据",
        splitLayout(
          verticalLayout(
            tags$b("第一列"), 
            tags$textarea(id="xn1", rows=4, "510\n15")
            ),
          verticalLayout(
            tags$b("第二列"),
            tags$textarea(id="xn2", rows=4, "16\n90")
            )
          )
        )
      ),

      mainPanel(
        h4("显示数据表"), 
        tableOutput("n.t"),
        helpText(
          HTML(
            "<p> 当不一致对数＜20时，应参考校正结果.</p>
            <ul>
            <li> 不一致对是各个组成成分的结果(outcome)不同的配对. </li>
            </ul>"
            )
          ),
        h4(tags$b("结果")), 
        tableOutput("n.test")
  #tags$b("Interpretation"), p("bbb")
        )
      )
    )
    ,
  tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止")
)
  
  )))


