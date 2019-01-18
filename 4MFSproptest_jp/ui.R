##----------#----------#----------#----------
##
## 4MFSproptest UI
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyUI(

tagList(
  source("../0tabs/font_jp.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(
 
  title = "二項検定",

##---------- 1. Panel 1 ----------
  tabPanel("一つのデータに対する検定",

    titlePanel("二項検定　Exact Binomial Test"),

#tags$b("Introduction"),

#p("To test the probability of events (success) in a series of Bernoulli experiments. "),
HTML("

      <b> 注 </b>

      <ul>
      <li> xはある結果の回数
      <li> nは試行回数
      <li> Pはある結果の起こる確率
      <li> p&#8320 は特定の確率 
      </ul> 

    <b> 前提として </b>

      <ul>
      <li> 標本は二項分布に基づいている　
      <li> 二項分布に対する正規近似は有効とする　
      </ul>
      " ),

    p(br()),

  sidebarLayout(

    sidebarPanel(

    h4("仮説"),
    tags$b("帰無仮説"), 
    HTML("<p>p = p&#8320: ある結果の確率は p&#8320 </p>"),

    radioButtons("alt", 
      label = "対立仮説", 
      choiceNames = list(
        HTML("p &#8800 p&#8320: ある結果の起こる確率は p&#8320ではない"),
        HTML("p < p&#8320: ある結果の起こる確率はp&#8320より小さい"),
        HTML("p > p&#8320: ある結果の起こる確率はp&#8320より大きい")),
        choiceValues = list("two.sided", "less", "greater")),

    hr(),

    h4("データ準備"),  
      numericInput("x", "出来事の数 x", value = 5, min = 0, max = 10000, step = 1),
      numericInput("n", "試行回数 n", value = 10, min = 1, max = 50000, step = 1),
      numericInput('p', HTML("確率 p&#8320"), value = 0.5, min = 0, max = 1, step = 0.1)
    ),

  mainPanel(
    h4("検定結果"), 
    p(br()), 
    tableOutput("b.test"),
  #tags$b("Interpretation"), wellPanel(p("When p-value is less than 0.05, it indicates that the underlying probability is far away from the specified value.")),
    hr(),
    h4('円グラフ'), 
    plotOutput("makeplot", width = "400px", height = "400px")
    )
  )
),

##----------  Panel 2 ----------
tabPanel("二つの独立した群に対する検定",

    titlePanel("カイ二乗検定、フィッシャーの正確確率検定(Chi-square Test, Fisher's Exact Test)"),

HTML("

<b> 前提として </b>
<ul>
  <li> 各セルの期待値は5より大きい
  <li> 各セルの期待値が5未満の場合は、修正またはフィッシャーの正確なテスト（Fisher's Exact Test）を行う必要がある
</ul>

  "),


    sidebarLayout(

      sidebarPanel(
        h4("データ準備"),
        helpText("2 x 2 Table"),
        tags$b("入力するグループ名"),
        splitLayout(
          verticalLayout(
            tags$b("グループ名"),
            tags$textarea(id="cn", label = "グループ名", rows=4, cols = 20, "Group1\nGroup2")
            ),
          
          verticalLayout(
            tags$b("状態"), 
            tags$textarea(id="rn", label = "状態", rows=4, cols = 20, "Case\nControl")
            )
          ),
        p(br()),

        tags$b("手入力"), 

          splitLayout(
            verticalLayout(
              tags$b("グループ 1"), 
              tags$textarea(id="x1", rows=4, "10\n20")
              ),
            verticalLayout(
              tags$b("グループ 2"),
              tags$textarea(id="x2", rows=4, "30\n35")
              )
            )
        ),

  mainPanel(

    h4("データの記述統計"),

      tabsetPanel(
        tabPanel("データ", p(br()),
          tableOutput("t")
          ),

        tabPanel("予測できる値", p(br()),
          tableOutput("e.t")
          ),

        tabPanel("列の割合", p(br()),
          tableOutput("p.t")
          ),
        tabPanel("割合の円グラフ", 
          plotOutput("makeplot2", width = "800px", height = "400px") 
          ) )
        )
      ),


  h4("カイ二乗検定"),

    sidebarLayout(
      sidebarPanel(
        
      h4("仮説"),
      tags$b("帰無仮説"), 
      HTML("<p> p&#8321 = p&#8322: 症例の確率は両方の群で等しい </p>"),
      
      radioButtons("alt1", label = "対立仮説", 
        choiceNames = list(
          HTML("p&#8321 &#8800 p&#8322: 症例の確率が等しくない"),
          HTML("p&#8321 < p&#8322: 最初のグループの症例の確率は2番目のグループよりも小さい"),
          HTML("p&#8321 > p&#8322: 最初のグループの症例の確率が2番目のグループよりも大きい")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),

      radioButtons("cr", label = "イェーツ補正(Yates-correction)", 
        choiceNames = list(
          HTML("No: 期待値が5未満のセルはない"),
          HTML("Yes: 少なくとも1つのセルの期待値が5未満")
          ),
        choiceValues = list(FALSE, TRUE)
        )
      ),

      mainPanel(
        h4("検定結果"), tableOutput("p.test")
        #tags$b("Interpretation"), p("Chi-square.test")
        )
      ),


      h4("フィッシャーの正確検定"),
    sidebarLayout(

      sidebarPanel(


      tags$b("前提として"),
      HTML("
        <ul>
        <li> 二項分布に対する正規近似は有効ではないとする
        <li> 各セルの期待値は5未満
        </ul>" )
      ),

      mainPanel(
        h4("結果"), 
        tableOutput("f.test")
      #tags$b("Interpretation"), p("Fisher's exact test")
        )
    )
    ),

##---------- Panel 3 ----------
    tabPanel("二つのデータの一致対の割合",

    titlePanel("マクネマー検定（McNemar's Test）"),

#tags$b("Introduction"),
#p("To test the difference between the sample proportions"),

    p(br()),

    sidebarLayout(
      sidebarPanel(

      h4("仮説"),
      tags$b("帰無仮説"), 
      HTML("<p> セル[i、j]と[j、i]に分類される確率は同じである </p>"),
      tags$b("対立仮説"), 
      HTML("<p> セル[i、j]と[j、i]に分類される確率は同じではない </p>"),
      hr(),

      h4("データ準備"),
      helpText("2 x 2 テーブル"),

      tags$b("入力するグループ名"),
      splitLayout(
        verticalLayout(
          tags$b("治療Aの結果"),
          tags$textarea(id="ra", rows=4, cols = 20, "Result1.A\nResult2.A")
          ),
        
        verticalLayout(
          tags$b("治療Bの結果"), 
          tags$textarea(id="cb", rows=4, cols = 20, "Result1.B\nResult2.B")
          )
        ),
      p(br()),
      tags$b("手入力"),
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
      ),

      mainPanel(
        h4("データ"), 
        tableOutput("n.t"),
        helpText(
          HTML(
            "
            注：
            <ul>
            <li> 不一致対の数が20未満の場合、訂正した結果を参照すべきである
            <li> 不一致対は、対のメンバーの結果が異なる一致対である
            </ul>
            "
            )
          ),
        h4("検定結果"), 
        tableOutput("n.test")
  #tags$b("Interpretation"), p("bbb")
        )
      )
    )
    ,
##---------- other panels ----------

source("../0tabs/home_jp.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop_jp.R",local=TRUE,encoding = "UTF-8")$value


  
  )))


