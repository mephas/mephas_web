##------------------------------------------------------
##
## Binary outcome test ui JP
##
## Date: 2018-11-30
##
##------------------------------------------------------

shinyUI(
  
tagList(
#shinythemes::themeSelector(),
navbarPage(
 
  title = "二項検定",

# 1. Chi-square test for single sample 
  tabPanel("一つのデータに対する検定",

    titlePanel("二項検定"),

#tags$b("Introduction"),

#p("To test the probability of events (success) in a series of Bernoulli experiments. "),

    tags$b("前提として"),
    HTML("
      <ul>
      <li>標本は二項分布に基づいている</li>
      <li>二項分布に対する正規近似は有効とする</li>
      </ul>" 
      ),

    tags$b("注"),
    HTML("
      <ul>
      <li> xはある結果の回数</li>
      <li>nは試行回数</li>
      <li>Pはある結果の起こる確率</li>
      <li> p&#8320 は特定の確率 </li>
      </ul>" ),

    p(br()),

  sidebarLayout(

    sidebarPanel(

    helpText("仮説"),
    tags$b("帰無仮説"), 
    HTML("<p>p = p&#8320: ある結果の確率は p&#8320 </p>"),
    
    radioButtons("alt", 
      label = "代替仮説", 
      choiceNames = list(
        HTML("p &#8800 p&#8320: ある結果の起こる確率は p&#8320ではない"),
        HTML("p < p&#8320: ある結果の起こる確率はp&#8320より小さい"),
        HTML("p > p&#8320: ある結果の起こる確率はp&#8320より大きい")),
      choiceValues = list("two.sided", "less", "greater")),

    hr(),

    tabsetPanel(
      ##-------input data-------## 
      tabPanel("手入力", 
      p(br()),    
      numericInput("x", "出来事の数, x", value = 5, min = 0, max = 10000, step = 1),
      numericInput("n", "試行回数, n", value = 10, min = 1, max = 50000, step = 1),
      numericInput('p', HTML("確率, p&#8320"), value = 0.5, min = 0, max = 1, step = 0.1))
      )
    ),

  mainPanel(
    h4(tags$b("結果")), 
    p(br()), 
    tableOutput("b.test"),
  #tags$b("Interpretation"), wellPanel(p("When p-value is less than 0.05, it indicates that the underlying probability is far away from the specified value.")),
    hr(),
    h4(tags$b('円グラフ')), 
    plotOutput("makeplot", width = "400px", height = "400px")
    )
  )
),

# 2. Chi-square test for 2 independent sample
  tabPanel("二つの独立した群に対する検定",

    titlePanel("カイ二乗検定, フィッシャーの正確確率検定"),

#tags$b("Introduction"),
#p("To test the difference between the sample proportions"),

    sidebarLayout(
      sidebarPanel(
        helpText("2 x 2 Table"),
        
        splitLayout(
          verticalLayout(
            tags$b("グループ名"),
            tags$textarea(id="cn", label = "Group names", rows=4, cols = 20, "Group1\nGroup2")
            ),
          
          verticalLayout(
            tags$b("状態"), 
            tags$textarea(id="rn", label = "Status", rows=4, cols = 20, "Case\nControl")
            )
          ),

        h4(tags$b("データの入力")),
        tabPanel("手入力",
        
          splitLayout(
            verticalLayout(
              tags$b("最初のグループ"), 
              tags$textarea(id="x1", rows=4, "10\n20")
              ),
            verticalLayout(
              tags$b("二個目のグループ"),
              tags$textarea(id="x2", rows=4, "30\n35")
              )
            ),
          h4("データ"), 
          tableOutput("t")
          )
        ),

      mainPanel(
        h4(tags$b("予測できる値")), 
        tableOutput("e.t"),
        helpText("When the expected value in each cell is less than 5, one should do correction or Fisher's exact test"),
        h4(tags$b("Percentages for columns")), 
        tableOutput("p.t"),
        h4(tags$b('Pie Plot of Proportions')), 
        plotOutput("makeplot2", width = "600px", height = "300px") 
        )
      ),

    sidebarLayout(
      sidebarPanel(
  
      h4(tags$b("カイ二乗検定")),

      tags$b("前提として"),
      p("The expected value in each cell is greater than 5"),

      helpText("仮説"),
      tags$b("帰無仮説"), 
      HTML("<p> p&#8321 = p&#8322: the probabilities of cases are equal in both group. </p>"),
      
      radioButtons("alt1", label = "代替仮説", 
        choiceNames = list(
          HTML("p&#8321 &#8800 p&#8322: the probabilities of cases are not equal"),
          HTML("p&#8321 < p&#8322: the probability of case in the first group is less than the second group"),
          HTML("p&#8321 > p&#8322: the probability of case in the first group is greater than the second group")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),

      radioButtons("cr", label = "Yates-correction", 
        choiceNames = list(
          HTML("No: no cell has an expected value less than 5"),
          HTML("Yes: at least one cell has an expected value less than 5")
          ),
        choiceValues = list(FALSE, TRUE)
        )
      ),

      mainPanel(
        h4(tags$b("結果")), tableOutput("p.test")
        #tags$b("Interpretation"), p("Chi-square.test")
        )
      ),

    sidebarLayout(

      sidebarPanel(

      h4(tags$b("Fisher's Exact Test")),

      tags$b("前提として"),
      HTML("
        <ul>
        <li> The normal approximation to the binomial distribution is not valid</li>
        <li> The expected value in each cell is less than 5</li>
        </ul>" )
      ),

      mainPanel(
        h4(tags$b("結果")), 
        tableOutput("f.test")
      #tags$b("Interpretation"), p("Fisher's exact test")
        )
    )
    ),

# 3. Chi-square test for 2 paired-independent sample ---------------------------------------------------------------------------------
    tabPanel("Two Proportions for Matched-Pair Data",

    titlePanel("マクネマー検定"),

#tags$b("Introduction"),
#p("To test the difference between the sample proportions"),

    p(br()),

    sidebarLayout(
      sidebarPanel(

      helpText("仮説"),
      tags$b("帰無仮説"), 
      HTML("<p> The probabilities of being classified into cells [i,j] and [j,i] are the same</p>"),
      tags$b("代替仮説"), 
      HTML("<p> The probabilities of being classified into cells [i,j] and [j,i] are not same</p>"),
      hr(),

      helpText("2 x 2 Table"),
      splitLayout(
        verticalLayout(
          tags$b("Results of Treatment A"),
          tags$textarea(id="ra", rows=4, cols = 20, "Result1.A\nResult2.A")
          ),
        
        verticalLayout(
          tags$b("Results of Treatment B"), 
          tags$textarea(id="cb", rows=4, cols = 20, "Result1.B\nResult2.B")
          )
        ),

      h4(tags$b("データ挿入")),
      tabPanel("手入力",
        splitLayout(
          verticalLayout(
            tags$b("Column 1"), 
            tags$textarea(id="xn1", rows=4, "510\n15")
            ),
          verticalLayout(
            tags$b("Column 2"),
            tags$textarea(id="xn2", rows=4, "16\n90")
            )
          )
        )
      ),

      mainPanel(
        h4("データ"), 
        tableOutput("n.t"),
        helpText(
          HTML(
            "<p> When the number of discordant pairs < 20, one should refer to results with correction </p>
            <ul>
            <li> Discordant pair is a matched pair in which the outcome differ for the members of the pair. </li>
            </ul>"
            )
          ),
        h4(tags$b("結果")), 
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
