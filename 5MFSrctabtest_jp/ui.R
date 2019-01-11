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
 
  title = "Contingency Table of Counts",

##---------- Panel 1 ----------
tabPanel("カイ二乗検定（クロステーブル）",

titlePanel("カイ二乗検定"),

HTML("
<b>  注　</b>

<ul>

<li> R x C のクロステーブルではR(行)とC(列)のテーブルを引数として計算できる
<li> 1つの変数がRカテゴリを持ち、もう1つの変数がCカテゴリを持つ2つの離散変数間に重要な関係があるかどうかを判断する

</ul>

<b> 前提として </b>

<ul>

<li> No more than 1/5 of the cells have expected values < 5
<li> No cell has an expected value < 1

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
  helpText("Row names must be corresponding to number of rows")),
  numericInput("c", "列数　C", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("列の名前"),
  tags$textarea(id="cn", rows=4, cols = 30, "C1\nC2"),
  helpText("列名の数は列数に一致する必要があります")),
  hr(),

  h4("データ挿入"),
  helpText("Input your values by column, i.e., the second column follows the first column"),
  tags$textarea(id="x", rows=10, "10\n20\n30\n35")
    ),

mainPanel(

h4("カイ二乗検定結果"), 
tableOutput("c.test"),
hr(),

h4("Contingency Table Description"),
tabsetPanel(

tabPanel("テーブル", 
  dataTableOutput("ct")
  ),

tabPanel("割合",
  h4("行の割合"), tableOutput("prt"),
  h4("列の割合"), tableOutput("pct"),
  h4("全体の割合"), tableOutput("pt")
  ),

tabPanel("Expected value in each cell",
  tableOutput("c.e")
  ),

tabPanel("頻度の棒グラフ (回数)",
  plotOutput("makeplot", width = "800px", height = "400px")
  )
  )
  )
)
),


##---------- Panel 2 ----------

tabPanel("傾向性の検定 (2 x K Table)",

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
  tabPanel("アップロード.csv", p(br()),
    fileInput('file2', '.csv ファイル選ぶ', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')))),

  mainPanel(

h4("Results of the Test for Trend, Case out of Total"), 
tableOutput("tr.test"),
hr(),

  h4("Contingency Table Description"),
  tabsetPanel(
    tabPanel("分割表",
      dataTableOutput("ct.tr"),
      helpText("注: パーセンテージ ＝ ケース/合計")
      ),

    tabPanel("パーセンテージの棒グラフ",
    plotOutput("makeplot.tr", width = "800px", height = "400px")
      )
    )
  )
  )
),

##---------- Panel 3 ----------

tabPanel("κ統計量（カッパ） (K x K Table)",

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
  helpText("Input the counts by column, for example, the second column follows the first column")

  ),

mainPanel(

  h4("Results of the Kappa Statistic, k"), tableOutput("k.test"),
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
    <li> Row is the rater of measurement-A, while column is measurement-B
    <li> The last row is the sum of above rows
    </ul>
    ")
  )

)),
##---------- other panels ----------

source("../0tabs/home_jp.R",local=TRUE)$value,
source("../0tabs/stop_jp.R",local=TRUE)$value


))
)

