#****************************************************************************************************************************************************
sidebarLayout(

sidebarPanel(
  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("トレーニングセットの準備")),

tabsetPanel(

tabPanel("サンプルデータ", p(br()),

  #selectInput("edata", tags$b("サンプルデータを使用する"),
  #      choices =  c("Breast Cancer"),
  #      selected = "Breast Cancer")

    shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("サンプルデータを使用する"),
   choices =  c("Breast Cancer"),
   selected = "Breast Cancer",
   checkIcon = list(
    yes = tags$i(class = "fa fa-check-square", 
    style = "color: steelblue"),
   no = tags$i(class = "fa fa-square-o", 
  style = "color: steelblue"))
)
  ),

tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote="quote")
  ),

hr(),

h4(tags$b("一部の変数の種類を変更するか?")),
uiOutput("factor1"),
uiOutput("factor2"),

h4(tags$b("カテゴリ変数の基準レベルを変更するか?")),

uiOutput("lvl"),

p(tags$b("2. 基準レベルを入力（各ラインに、1つの変数）")),

tags$textarea(id='ref',""),
hr(),

uiOutput("rmrow"),

hr(),

#h4(tags$b(actionLink("Model","Build Model")))
#h4(tags$b("Build Model in the Next Tab"))
p(br()),
actionButton("Model", "モデルの構築へ >>",class="btn btn-primary",icon("location-arrow")),p(br()),
hr()

),

##########----------##########----------##########
mainPanel(
h4(tags$b("Output 1. データの確認")),
p(tags$b("データの確認")),
DT::DTOutput("Xdata"),

#p(tags$b("1. Numeric variable information list")),
#verbatimTextOutput("strnum"),

#p(tags$b("2. Categorical variable information list")),
#verbatimTextOutput("strfac"),
p(tags$b("変数タイプ")),
DT::DTOutput("var.type"),

hr(),
h4(tags$b("Output 2. 記述的結果")),

tabsetPanel(

tabPanel("基本統計量", br(),

p(tags$b("1. 数値変数")),

DT::DTOutput("sum"),

p(tags$b("2. カテゴリ変数")),
DT::DTOutput("fsum")

),

tabPanel("ロジットプロット",br(),

HTML("<p><b>ロジットプロット</b>: 任意の2つの数値変数間の関係を大まかに示します。"),
hr(),

uiOutput('tx'),
uiOutput('ty'),
p(tags$b("3.  X軸とY軸のラベルを変更する")),
tags$textarea(id = "xlab", rows = 1, "X"),
tags$textarea(id = "ylab", rows = 1, "Y"),

plotly::plotlyOutput("p1")
),

tabPanel("ヒストグラムと密度プロット", p(br()),

HTML("<p><b>ヒストグラム</b>: ある範囲の値について各観察の頻度を描き、変数の確率分布を大まかに示す図です。</p>"),
HTML("<p><b>密度プロット</b>:　変数の分布を示します。</p>"),
hr(),

uiOutput('hx'),
p(tags$b("ヒストグラム")),
plotly::plotlyOutput("p2"),
sliderInput("bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
p(tags$b("密度プロット")),
plotly::plotlyOutput("p21"))
))
##########----------##########----------##########
)
