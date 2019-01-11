##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: JP
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(
tagList(
#shinythemes::themeSelector(),
navbarPage(
 
  title = "Contingency Table of Counts",

## 1. Chi-square test for 2 by 2 table ---------------------------------------------------------------------------------
tabPanel("カイ二乗検定(クロステーブル)",

titlePanel("カイ二乗検定"),

tags$b("導入"),

p("R x C のクロステーブルではR(行)とC(列)のテーブルを引数として計算できる"),
p(" 1つの変数がRカテゴリを持ち、もう1つの変数がCカテゴリを持つ2つの離散変数間に重要な関係があるかどうかを判断する。"),

tags$b("前提として"),
tags$ul(
  tags$li("No more than 1/5 of the cells have expected values < 5"),
  tags$li("No cell has an expected value < 1")
  ),

p(br()),
sidebarLayout(

sidebarPanel(

  helpText("テーブル設定"),
  numericInput("r", "行数, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("行の名前"), 
  tags$textarea(id="rn", rows=4, cols = 30, "R1\nR2"),
  helpText("行の名前の数は行の数に一致する必要があります")),
  numericInput("c", "列数, C", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("列の名前"),
  tags$textarea(id="cn", rows=4, cols = 30, "C1\nC2"),
  helpText("列名の数は列数に一致する必要があります"))
  
  ),

mainPanel(
  wellPanel(
  h4(tags$b("データインプット")),
  helpText("列ごとに値を入力"),
  tabPanel("手入力",
  tags$textarea(id="x", rows=10, "10\n20\n30\n35"))),
  hr(),
  h4("テーブル"), dataTableOutput("ct"),
  hr(),
  h3(tags$b("カイ二乗検定結果")), tableOutput("c.test"),
  tags$b("Expected value in each cell"),
  tableOutput("c.e"),
  #tags$b("Interpretation"), p("The meaning"),
  hr(),
  h3(tags$b("割合")),
  h4("行の割合"), tableOutput("prt"),
  h4("列の割合"), tableOutput("pct"),
  h4("全体の割合"), tableOutput("pt"),
  hr(),
  h3(tags$b('頻度の棒グラフ (回数)')), plotOutput("makeplot", width = "600px", height = "300px")))),

## 2. Chi-square test for Test for Trend ---------------------------------------------------------------------------------
tabPanel("傾向性の検定 (2 x K Table)",

titlePanel("傾向性の検定"),

tags$b("導入"),

p("比率の増加傾向または減少傾向を判断する。"),

p(br()),
sidebarLayout(

sidebarPanel(
helpText("データ挿入"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("誤った値はNAとして表示されます"),
    tags$textarea(id="suc", rows=10, "320\n1206\n1011\n463\n220"),
    tags$textarea(id="fail", rows=10, "1422\n4432\n2893\n1092\n406")), 
    helpText("ケース群は左, コントロール群は右"),

  ##-------csv file-------##   
  tabPanel("アップロード.csv ファイルのみ", p(br()),
    fileInput('file2', '.csv ファイル選ぶ', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    #checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')))),

  mainPanel(
  h4("分割表"), dataTableOutput("ct.tr"),
  helpText("注: パーセンテージ ＝ ケース/合計"),
  hr(),
  h3(tags$b("結果, Case out of Total")), tableOutput("tr.test"),
  #tags$b("Interpretation"), p("The meaning"),
  hr(),
  h3(tags$b('パーセンテージ棒グラフ')), plotOutput("makeplot.tr", width = "600px", height = "300px"))
  )),

## 3. Goodness-of-Fit Test, kappa ---------------------------------------------------------------------------------
tabPanel("κ統計量（カッパ） (K x K Table)",

titlePanel("κ統計"),

tags$b("導入"),

p("同一変数の再現性を複数回測定する信頼性試験において用いられる"),

sidebarLayout(
sidebarPanel(

helpText("パラメータ設定"),
  numericInput("r.k", "分類数, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("分類の名前"), 
  tags$textarea(id="rater", rows=4, cols = 30, "Yes\nNo"))),

mainPanel(
  h4(tags$b("データインプット")),
  helpText("下の欄に記入"),
  tabPanel("手入力",
  tags$textarea(id="k", rows=10, "136\n69\n92\n240")),
  hr(),
  h4("分割表"), dataTableOutput("kt"),
  helpText("Row is the rater of measurement-A, while Column is measurement-B"),
  hr(),
  h3(tags$b("κ統計, k")), tableOutput("k.test"),
  tags$b("注"),
  HTML("
  <ul>
  <li> k > 0.75 優れた再現性を示す </li>
  <li> 0.4 < k < 0.75 良好な再現性を示す</li>
  <li> 0 < k < 0.4 再現性はよくない </li>
  </ul>" )

  #tags$b("Interpretation"), p("The meaning")
  )

))
,
##----------
tabPanel((a("ホーム",
 #target = "_blank",
 style = "margin-top:-30px;",
 href = paste0("https://pharmacometrics.info/mephas/", "index_jp.html")))),

tabPanel(
      tags$button(
      id = 'close',
     style = "margin-top:-10px;",
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止"))

))
)
