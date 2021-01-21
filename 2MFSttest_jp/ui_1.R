#****************************************************************************************************************************************************1.t1
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. データに名前を付ける (必須)")),

  tags$textarea(id = "cn", rows = 1, "Age"),p(br()),

  p(tags$b("2. データの入力")),

  tabsetPanel(

    tabPanel("手入力", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("144例リンパ節陽性患者の年齢を入力してあります"))
    ),

    p(tags$b("例のようにデータを入力してください")),
    p("データは , ; /Enter /Tab /Spaceで区切ることができます"),
    p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")),   
    tags$textarea(
        id = "x", #p
        rows = 10,
        "50\n42\n50\n43\n47\n47\n38\n45\n31\n41\n48\n47\n38\n44\n36\n42\n42\n45\n49\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48\n48\n36\n43\n44\n47\n40\n41\n48\n41\n45\n45\n47\n37\n43\n43\n49\n45\n41\n50"
        ),

      p("欠損値はNAとして入力されます")
      ),
  tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")
 

    ),

hr(),

  h4(tags$b("Step 2. パラメータを指定する")),

  numericInput('mu', HTML("データと比較したい平均 (&#956&#8320)"), 50), #p
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("指定されたパラメータは一般年齢50歳です"))
  ),

hr(),

  h4(tags$b("Step 3. 仮説を選択する")),

  p(tags$b("帰無仮説")),
  HTML("&#956 = &#956&#8320: データの母平均 (&#956) は &#956&#8320"),

  radioButtons(
    "alt",
    label = "対立仮説",
    choiceNames = list(
      HTML("&#956 &#8800 &#956&#8320: データの母平均 (&#956) は &#956&#8320ではない"),
      HTML("&#956 < &#956&#8320: データの母平均 (&#956) は &#956&#8320より小さい"),
      HTML("&#956 > &#956&#8320: データの母平均 (&#956) は &#956&#8320より大きい")
      ),
    choiceValues = list("two.sided", "less", "greater")),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("年齢が50歳かどうかを知りたかったので、1番目の対立仮説を選択します"))
    )

    ),


mainPanel(

  h4(tags$b("Output 1. 記述統計の結果")),

  tabsetPanel(

    tabPanel("データの確認", p(br()),

      DT::DTOutput("table")
      #shiny::dataTableOutput("table")
      ),

    tabPanel("記述統計量", p(br()),

        DT::DTOutput("bas")#,
      #p(br()),
       # downloadButton("download0", "Download Results")
       ),

    tabPanel("ボックスプロット", p(br()),

        plotly::plotlyOutput("bp"),#, click = "plot_click1"

        #verbatimTextOutput("info1"),
          HTML(
          "<b> 説明 </b>
          <ul>
            <li> 箱の中の線は中央値を表しています</li>
            <li> 箱の上辺は75パーセンタイル、下辺は25パーセンタイルを表しています</li>
            <li> 外れ値がある場合は赤色で示されます</li>
          </ul>"

          )

      ),

    tabPanel("平均値と標準偏差プロット", p(br()),
plotly::plotlyOutput("meanp")),


    tabPanel("分布プロット", p(br()),
HTML(
"<b> 説明 </b>
<ul>
<li> 正規Q–Qプロット：無作為に発生させた独立した標準正規データを縦軸上にプロットし、横軸上の正規分布と比較します。点が線形の場合、データは正規分布していることが示唆されます</li>
<li> ヒストグラム：ある範囲の値について各観察の頻度を描き、変数の確率分布を大まかに評価する図です</li>
<li> 密度プロット：データの確率密度関数を推定するプロットです</li>
</ul>"
),

      p(tags$b("正規Q–Qプロット")),
      plotly::plotlyOutput("makeplot1"),
      p(tags$b("ヒストグラム")),
      plotly::plotlyOutput("makeplot1.2"),
      sliderInput("bin","ヒストグラムのビンの数",min = 0,max = 100,value = 0),
      p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
      p(tags$b("密度プロット")),
      plotly::plotlyOutput("makeplot1.3")

)
),

  hr(),
  h4(tags$b("Output 2. 検定結果")),p(br()),
  DT::DTOutput("t.test"),


  HTML(
    "<b> 説明 </b>
    <ul>
    <li> P < 0.05の場合、データの母平均と指定された平均との間に有意差があります。(対立仮説が採択されます)</li>
    <li> P >= 0.05の場合、データの母平均と指定された平均との間に有意差はありません。(帰無仮説が採択されます)</li>
    </ul>"
  ),
  conditionalPanel(
  condition = "input.explain_on_off",
  p(tags$i("P <0.05であるため、リンパ節陽性集団の年齢は50歳とは有意に異なると結論付けました。 したがって、一般的なリンパ節陽性集団の年齢は50歳ではありませんでした。指定された平均を44にリセットすると、P> 0.05を得ることができます。"))
  )
 )

)
