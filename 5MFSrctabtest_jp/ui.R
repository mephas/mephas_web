##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyUI(
tagList(
#shinythemes::themeSelector(),
navbarPage(
 
  title = "分割表",

##---------- Panel 1 ----------
tabPanel("カイ二乗検定（R x C クロステーブル）",

titlePanel("カイ二乗検定"),

HTML("
<b>  注　</b>

<ul>

<li> R x C のクロステーブルではR(行)とC(列)のテーブルを引数として計算できる
<li> 1つの変数がRカテゴリを持ち、もう1つの変数がCカテゴリを持つ2つの離散変数間に重要な関係があるかどうかを判断する

</ul>

<b> 前提として </b>

<ul>

<li> セルの期待値が5未満であるセルの数は1/5
<li> 期待値が1未満のセルは存在しない

</ul>

  "),

p(br()),
sidebarLayout(

sidebarPanel(

  h4("設定"),
  numericInput("r", "行数　R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("行の名前"), 
  tags$textarea(id="rn", rows=4, cols = 30, "R1\nR2"),
  helpText("行名は行数に対応している必要がある")),
  numericInput("c", "列数　C", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("列の名前"),
  tags$textarea(id="cn", rows=4, cols = 30, "C1\nC2"),
  helpText("列名の数は列数に一致する必要がある")),
  hr(),

  h4("データ準備"),
  helpText("列ごとに値を入力する。つまり、2列目が1列目の後に続く"),
  tags$textarea(id="x", rows=10, "10\n20\n30\n35")
    ),

mainPanel(

h4("検定結果"), 
tableOutput("c.test"),
hr(),

h4("分割表の記述統計"),
tabsetPanel(

tabPanel("テーブル", p(br()),
  dataTableOutput("ct")
  ),

tabPanel("割合", p(br()),
  h4("行の割合"), tableOutput("prt"),
  h4("列の割合"), tableOutput("pct"),
  h4("全体の割合"), tableOutput("pt")
  ),

tabPanel("それぞれのセルの期待値", p(br()),
  tableOutput("c.e")
  ),

tabPanel("頻度の棒グラフ (回数)", p(br()),
  plotOutput("makeplot", width = "800px", height = "400px")
  )
  )
  )
)
),


##---------- Panel 2 ----------

tabPanel("傾向性の検定 (2 x K クロステーブル）)",

titlePanel("傾向性の検定"),


p("比率の増加傾向または減少傾向を判断する"),

p(br()),
sidebarLayout(

sidebarPanel(

h4("データ挿入"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("欠損値はNAとして表示されます"),
    tags$textarea(id="suc", rows=10, "320\n1206\n1011\n463\n220"),
    tags$textarea(id="fail", rows=10, "1422\n4432\n2893\n1092\n406")), 
    helpText("ケース群は左, コントロール群は右"),

  ##-------csv file-------##   
  tabPanel("アップロード CSV ファイル", p(br()),
    fileInput('file2', 'CSV ファイルを指定してください', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'ヘッダー', TRUE),
    radioButtons('sep', '区切り', c(Comma=',', Semicolon=';', Tab='\t'), ',')))),

  mainPanel(

h4("検定結果"), 
tableOutput("tr.test"),
hr(),

  h4("分割表の述統計"),
  tabsetPanel(
    tabPanel("テーブル", p(br()),
      dataTableOutput("ct.tr"),
      helpText("注: パーセンテージ ＝ ケース/合計")
      ),

    tabPanel("パーセンテージの棒グラフ", p(br()),
    plotOutput("makeplot.tr", width = "800px", height = "400px")
      )
    )
  )
  )
),

##---------- Panel 3 ----------

tabPanel("κ統計量（カッパ） (K x K クロステーブル）)",

titlePanel("κ統計"),

p("同一変数の再現性を複数回測定する信頼性試験において用いられる"),

sidebarLayout(
sidebarPanel(

h4("設定"),
  numericInput("r.k", "分類数, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("分類の名前"), 
  tags$textarea(id="rater", rows=4, cols = 30, "Yes\nNo")),

h4("データ挿入"),
  tabPanel("手入力",
  tags$textarea(id="k", rows=10, "136\n69\n92\n240")),
  helpText("列ごとにカウントを入力する。たとえば、2列目が1列目の後に続く")

  ),

mainPanel(

  h4("検定結果"), tableOutput("k.test"),
  tags$b("注"),
  HTML("
  <ul>
  <li> k > 0.75 優れた再現性を示す 
  <li> 0.4 < k < 0.75 良好な再現性を示す
  <li> 0 < k < 0.4 再現性はよくない 
  </ul>" ),

  hr(),
  h4("分割表"), dataTableOutput("kt"),
  HTML("
    <b> 注</b>
    <ul>
    <li> 行は測定Aの評価値であり、列は測定Bの評価値
    <li> 最後の行は上記の行の合計
    </ul>
    ")
  )

)),
##---------- other panels ----------

source("../0tabs/home_jp.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop_jp.R",local=TRUE,encoding = "UTF-8")$value


))
)

