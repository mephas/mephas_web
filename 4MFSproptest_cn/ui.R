##----------#----------#----------#----------
##
## 4MFSproptest UI
##
## Language: CN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(

tagList(
#shinythemes::themeSelector(),
source("../0tabs/font_cn.R",local=TRUE, encoding="UTF-8")$value,
navbarPage(
 
  title = "率的检验",

##---------- 1. Panel 1 ----------
  tabPanel("单个样本的比例的检验",

    titlePanel("精确二项检验"),

#tags$b("Introduction"),

p("用来检验事件发生/不发生的概率是否为某一确定值。以抛硬币试验为例： "),
HTML("

      <b> 注 </b>

      <ul>
      <li> x 表示事件（例如，硬币的正面）发生的次数
      <li> n 总的试验（抛硬币）的总次数
      <li> p 得到正面事件的概率的
      <li> p&#8320 是指定的概率
      </ul>

    <b>前提假设 </b>

      <ul>
      <li> 观测值服从二项分布
      <li> 当样本量增加时，此二项分布趋近于正态分布
      </ul>
      " ),

    p(br()),

  sidebarLayout(

    sidebarPanel(

    h4("假设检验"),
    tags$b("零假设"), 
    HTML("<p>p = p&#8320: 事件发生的概率是 p&#8320 </p>"),
    
    radioButtons("alt", 
      label = "备择假设", 
      choiceNames = list(
        HTML("p &#8800 p&#8320: 事件发生的概率不是 p&#8320"),
        HTML("p < p&#8320: 事件发生的概率小于 p&#8320"),
        HTML("p > p&#8320: 事件发生的概率大于 p&#8320")),
      choiceValues = list("two.sided", "less", "greater")),

    hr(),

    h4("数据输入"),  
      numericInput("x", "事件发生的次数, x", value = 5, min = 0, max = 10000, step = 1),
      numericInput("n", "总的试验次数, n", value = 10, min = 1, max = 50000, step = 1),
      numericInput('p', HTML("指定的概率值, p&#8320"), value = 0.5, min = 0, max = 1, step = 0.1)
    ),

  mainPanel(
    h4("结果"), 
    p(br()), 
    tableOutput("b.test"),
  #tags$b("Interpretation"), wellPanel(p("When p-value is less than 0.05, it indicates that the underlying probability is far away from the specified value.")),
    hr(),
    h4('饼图'), 
    plotOutput("makeplot", width = "400px", height = "400px")
    )
  )
),

##----------  Panel 2 ----------
tabPanel("两独立样本的比例检验",

    titlePanel("卡方检验, Fisher精确检验"),

HTML("

<b> 前提假设 </b>
<ul>
  <li> 每一个格子里的期待值>5
  <li> 当期待值<5的时候，应该选择校正或者Fisher精确检验
</ul>

  "),


    sidebarLayout(

      sidebarPanel(
        h4("数据准备"),
        helpText("2 x 2 表"),
        tags$b("输入行列的名字"),
        splitLayout(
          verticalLayout(
            tags$b("组名（列）"),
            tags$textarea(id="cn", rows=4, cols = 20, "Group1\nGroup2")
            ),
          
          verticalLayout(
            tags$b("状态（行）"), 
            tags$textarea(id="rn", rows=4, cols = 20, "Case\nControl")
            )
          ),
        p(br()),

        tags$b("录入数据"), 

          splitLayout(
            verticalLayout(
              tags$b("第一列"), 
              tags$textarea(id="x1", rows=4, "10\n20")
              ),
            verticalLayout(
              tags$b("第二列"),
              tags$textarea(id="x2", rows=4, "30\n35")
              )
            )
        
        ),

  mainPanel(

  h4("数据的描述统计"),

      tabsetPanel(
    tabPanel("数据显示", p(br()),  
          tableOutput("t")
          ),

        tabPanel("期待值", 
          tableOutput("e.t")
          ),

        tabPanel("列的百分比", 
          tableOutput("p.t")
          ),
        tabPanel("饼图", 
          plotOutput("makeplot2", width = "800px", height = "400px") 
          ) )
        )
      ),


  h4("卡方检验"),

    sidebarLayout(
      sidebarPanel(
        
      h4("假设检验"),
      tags$b("零假设"),
      HTML("<p> p&#8321 = p&#8322: 事件在两组中发生的概率相同 </p>"),
      
      radioButtons("alt1", label = "备择假设", 
        choiceNames = list(
          HTML("p&#8321 &#8800 p&#8322: 事件在两组中发生的概率不同"),
          HTML("p&#8321 < p&#8322: 事件在第一组中发生的概率小于在第二组中发生的概率"),
          HTML("p&#8321 > p&#8322: 事件在第一组中发生的概率大于在第二组中发生的概率")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),

      radioButtons("cr", label = "Yates-校正", 
        choiceNames = list(
          HTML("No: 所有格子里的期待值都大于等于5"),
          HTML("Yes: 至少有一个格子里的期待值小于5")
          ),
        choiceValues = list(FALSE, TRUE)
        )
      ),

      mainPanel(
        h4("结果"), tableOutput("p.test")
        #tags$b("Interpretation"), p("Chi-square.test")
        )
      ),


      h4("Fisher 精确检验"),
    sidebarLayout(

      sidebarPanel(


      tags$b("假设检验"),
      HTML("
        <ul>
        <li> 二项分布的正态趋紧不适用</li>
        <li> 格子里的期待值<5</li>
        </ul>" )
      ),

      mainPanel(
        h4("结果"), 
        tableOutput("f.test")
      #tags$b("Interpretation"), p("Fisher's exact test")
        )
    )
    ),

# 3. Chi-square test for 2 paired-independent sample ---------------------------------------------------------------------------------
    tabPanel("两组配对数据的比例的检验",

    titlePanel("McNemar 检验"),

#tags$b("Introduction"),
#p("To test the difference between the sample proportions"),

    p(br()),

    sidebarLayout(
      sidebarPanel(

      h4("假设检验"),
      tags$b("零假设"), 
      HTML("<p> 某个事件被分到 [i,j]格子的概率和被分到 [j,i]格子的概率相同 </p>"),
      tags$b("备择假设"), 
      HTML("<p> 某个事件被分到 [i,j]格子的概率和被分到 [j,i]格子的概率不同</p>"),
      hr(),

      h4("数据准备"),
      helpText("2 x 2 表"),

      tags$b("输入行列的名字"),
      splitLayout(
        verticalLayout(
          tags$b("第一组的名字"),
          tags$textarea(id="ra", rows=4, cols = 20, "Result1.A\nResult2.A")
          ),
        
        verticalLayout(
          tags$b("第二组的名字"), 
          tags$textarea(id="cb", rows=4, cols = 20, "Result1.B\nResult2.B")
          )
        ),
      p(br()),
      tags$b("数据输入"),
      tabPanel("手动输入",
        splitLayout(
          verticalLayout(
            tags$b("列 1"), 
            tags$textarea(id="xn1", rows=4, "510\n15")
            ),
          verticalLayout(
            tags$b("列 2"),
            tags$textarea(id="xn2", rows=4, "16\n90")
            )
          )
        )
      ),

      mainPanel(
        h4("数据显示"), 
        tableOutput("n.t"),
        helpText(
          HTML(
            "<p> 不一致对（Discordant pair）的数目 < 20, 应对结果进行校正 </p>"
            )
          ),
        h4("结果"), 
        tableOutput("n.test")
  #tags$b("Interpretation"), p("bbb")
        )
      )
    )
    ,
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE)$value,
source("../0tabs/stop.R",local=TRUE)$value


  
  )))


