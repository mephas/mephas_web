#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("データの準備")),

tabsetPanel(

tabPanel("サンプルデータ", p(br()),

  shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("サンプルデータを使用する"),
   choices = c("Mouse (PCA)","Chemical (EFA)"),
   selected = "Mouse (PCA)",
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
  shinyWidgets::prettySwitch(
   inputId = "transform",
   label = tags$b("データを変換するか？"), 
   status = "info",
   fill = TRUE
  ),

hr(),

h4(tags$b(" 一部の変数の種類を変更するか?")),
uiOutput("factor1"),
uiOutput("factor2"),
hr(),

uiOutput("rmrow"),

hr(),

p(br()),
actionButton("ModelPCA", "PCAモデルの構築へ >>",class="btn btn-primary",icon("location-arrow")),p(br()),
actionButton("ModelEFA", "EFAモデルの構築へ >>",class="btn btn-primary",icon("location-arrow")),p(br()),
hr()
),


mainPanel(
h4(tags$b("Output 1. データの確認")),
p(tags$b("データの確認")),
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

downloadButton("download2", "結果のダウンロード (カテゴリ変数)")

),

tabPanel("線形フィッティングプロット",p(br()),

HTML("<p><b>線形フィッティングプロット</b>:任意の2つの数値変数間の線形関係を大まかに示します。"),
HTML("灰色の領域は95％の信頼区間です。</p>"),
hr(),

uiOutput('tx'),
uiOutput('ty'),
p(tags$b("3. XとY軸のラベルを変更する")),
tags$textarea(id = "xlab", rows = 1, "X"),
tags$textarea(id = "ylab", rows = 1, "Y"),

plotly::plotlyOutput("p1")
),

tabPanel("ヒストグラムと密度プロット", p(br()),

HTML("<p><b>ヒストグラム</b>: ある範囲の値について各観察の頻度を描き、変数の確率分布を大まかに示す図です。</p>"),
HTML("<p><b>密度プロット</b>: 変数の分布を示します。</p>"),
hr(),

uiOutput('hx'),
p(tags$b("ヒストグラムト")),
plotly::plotlyOutput("p2"),
sliderInput("bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
p(tags$b("密度プロット")),
plotly::plotlyOutput("p21")),

tabPanel("ヒートマップと相関プロット",p(br()),

uiOutput('heat.x'),
shinyWidgets::prettySwitch(
   inputId = "heat.scale",
   label = tags$b("データをスケーリングする?"), 
   status = "info",
   fill = TRUE
  ),
plotly::plotlyOutput("heat")),

tabPanel("相関行列", p(br()),

uiOutput('cor.x'), 
plotOutput("cor.plot", ),p(br()),
DT::DTOutput("cor")
),
tabPanel("並列分析", p(br()),

uiOutput('para.x'), 
plotOutput("fa.plot"),
verbatimTextOutput("fancomp")
)


  )

)

)