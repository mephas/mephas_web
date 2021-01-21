#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$style(type='text/css', '#surv {background-color: rgba(0,0,255,0.10); color: blue;}'),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#kmat1 {overflow-y:scroll; max-height: 200px; background: white};")),

h4(tags$b("トレーニングセットの準備")),

tabsetPanel(

tabPanel("サンプルデータ", p(br()),

#selectInput("edata", tags$b("サンプルデータを使用する"),
#        choices =  c("Diabetes","NKI70"),
#        selected = "Diabetes")
#),

shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("サンプルデータを使用する"),
   choices = c("Diabetes","NKI70"),
   selected = "Diabetes",
   checkIcon = list(
    yes = tags$i(class = "fa fa-check-square", 
    style = "color: steelblue"),
   no = tags$i(class = "fa fa-square-o", 
  style = "color: steelblue"))
)
),

tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote="quote")

),
tags$i("糖尿病データには1つの期間変数しかありませんが、Nki70データにはstart.timeとend.timeがあります。"),
hr(),

h4(tags$b("Step 2. 生存データオブジェクトを作成する")),

#p(tags$b("1. Choose a Time Variable")),

uiOutput('c'),

  selectInput(
      "time", "2. 生存時間の種類を選択する",
      c("右側で打ち切った時間" = "A",
        "左側で切り捨て右側で打ち切った時間" = "B"
        )),
  p("右側で打ち切った時間では、1つだけの時間の長さ/フォローアップ変数が必要"),
  p("左側で切り捨て右側で打ち切った時間には、開始時間と終了時間の変数が必要"),


conditionalPanel(
  condition = "input.time == 'A'",
  uiOutput('t')
  ),
conditionalPanel(
  condition = "input.time == 'B'",
  uiOutput('t1'),
  uiOutput('t2')
  ),

tags$i("糖尿病データには右側で打ち切った時間がありますが、Nki70データは左側を切り捨て右側で打ち切った時間があります。"),

hr(),
h4(tags$b("Step 3. 生存データオブジェクトをチェックする")),
p(tags$b("有効な生存データオブジェクトの例： Surv (time, status)")),
p(tags$b("または Surv (start.time, end.time, status)")),
verbatimTextOutput("surv", placeholder = TRUE),


hr(),


h4(tags$b("一部の変数の種類を変更するか?")),

uiOutput("factor1"),

uiOutput("factor2"),

h4(tags$b("カテゴリ変数の基準レベルを変更するか?")),

uiOutput("lvl"),

p(tags$b("2. 基準レベルを入力（各ラインに、1つの変数）")),

tags$textarea(id='ref', column=40, ""),

hr(),

uiOutput("rmrow"),

hr(),
p(br()),
#h4(tags$b(actionLink("Non-Parametric Model","Build Non-Parametric Model"))),
#h4(tags$b(actionLink("Semi-Parametric Model","Build Semi-Parametric Model"))),
#h4(tags$b(actionLink("Parametric Model","Build Parametric Model")))
#h4(tags$b("Build Model in the Next Tab"))

actionButton("Non-Parametric Model", "KM モデルへ >>",class="btn btn-primary",icon("location-arrow")),p(br()),
actionButton("Semi-Parametric Model", "コックス(Cox)モデルへ >>",class="btn btn-primary",icon("location-arrow")),p(br()),
actionButton("Parametric Model", "AFTモデルへ >>",class="btn btn-primary",icon("location-arrow")),p(br()),

hr()
),

##########----------##########----------##########

mainPanel(
h4(tags$b("Output 1. データの確認")),
p(tags$b("データの確認")),
p(br()),
DT::DTOutput("Xdata"),

p(tags$b("1. 数値変数情報リスト")),
verbatimTextOutput("strnum"),


p(tags$b("2. カテゴリ変数情報リスト")),
verbatimTextOutput("strfac"),


hr(),
h4(tags$b("Output 2. 記述的結果")),

tabsetPanel(

tabPanel("基本統計量", p(br()),

p(tags$b("1. 数値変数")),

DT::DTOutput("sum"),

p(tags$b("2. カテゴリ変数")),
verbatimTextOutput("fsum"),

downloadButton("download2", "結果のダウンロード（カテゴリ変数）")

),

tabPanel("生存曲線",  p(br()),
  radioButtons("fun1", "一つのプロットを選んでください",
  choiceNames = list(
    HTML("1. 生存確率"),
    HTML("2. 累積イベント"),
    HTML("3. 累積ハザード")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
plotOutput("km.a"),
verbatimTextOutput("kmat1")
     ),

tabPanel("生命表",  p(br()),
DT::DTOutput("kmat")
     ),

tabPanel("ヒストグラムと密度プロット", p(br()),

HTML("<p><b>ヒストグラム</b>:　ある範囲の値について各観察の頻度を描き、変数の確率分布を大まかに示す図です。</p>"),
HTML("<p><b>密度プロット</b>:　変数の分布を示します。</p>"),
hr(),

uiOutput('hx'),
p(tags$b("ヒストグラム")),
plotly::plotlyOutput("p2"),
sliderInput("bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
p(tags$b("密度プロット")),
plotly::plotlyOutput("p21"))

)

)
##########----------##########----------##########

)
