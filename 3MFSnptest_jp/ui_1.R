#****************************************************************************************************************************************************1.np1

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. データに名前を付ける (必須)")),

  tags$textarea(id="cn", rows= 1, "Scale"), p(br()),

  p(tags$b("2. データの入力")),

  tabsetPanel(
  ##-------input data-------##
  tabPanel("手入力", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここでのデータは、特定の患者グループからの9人の患者のうつ病評価尺度因子（DRS）の測定値でした。"))
    ),

    p(tags$b("例のようにデータを入力してください")),
	p("データは , ; /Enter /Tab /Spaceで区切ることができます"),
    p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")),      
    tags$textarea(id="a",
      rows=5,
      "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
      ),

    p("欠損値はNAとして入力されます")

    ),
  tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")

    ),

  hr(),
  h4(tags$b("Step 2. パラメータを指定する")),
  numericInput("med", HTML("データと比較したい中央値 (m&#8320)"), 1),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("このデフォルト設定では、患者のグループがうつ病に苦しんでいるかどうかを知りたいです（スケール> 1）。"))
    ),
  hr(),

  h4(tags$b("Step 3. 仮説を選択する")),
  p(tags$b("帰無仮説")),

  HTML("<p> m = m&#8320: データの母集団の中央値は( m&#8320)を指定します。 </p>
        <p>つまり、データセットの分布は指定した中央値を中心として対称</p>"),

  radioButtons("alt.wsr",
    label = "対立仮説", selected = "greater",
    choiceNames = list(
    HTML("m &#8800 m&#8320: 母集団の中央値と指定した中央値との間に有意差がある"),
    HTML("m > m&#8320: 母集団の中央値は指定した中央値よりも大きい"),
    HTML("m < m&#8320: 母集団の中央値は指定した中央値よりも小さい")
    ),
  choiceValues = list("two.sided", "greater", "less")),
  hr(),
  conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("このデフォルト設定では、患者のグループがうつ病に苦しんでいるかどうかを知りたいです（スケール> 1）。"))
    ),

  h4(tags$b("Step 4. P値を決める方法を選ぶ")),
  radioButtons("alt.md",
    label = "どのようなデータか", selected = "a",
    choiceNames = list(
      HTML("P値はほぼ正規分布（Approximate normal distributed P value）：標本サイズが大きい"),
      HTML("P値は漸近的に正規分布（Asymptotic normal distributed P value）：標本サイズが大きい"),
      HTML("正確なP値（Exact P value）：標本サイズが小さい (< 50未満)")
      ),
    choiceValues = list("a", "b", "c")),
      conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、9人しかいませんでした。 したがって、正確なP値を選択しました"))
    )

  ),

mainPanel(

  h4(tags$b("Output 1. 記述統計の結果")),

  tabsetPanel(

    tabPanel("データの確認", p(br()),
      DT::DTOutput("table")
      ),

    tabPanel("記述統計量", p(br()),

        DT::DTOutput("bas")
      ),

    tabPanel("ボックスプロット", p(br()),

        plotly::plotlyOutput("bp"), #, click = "plot_click"

        #verbatimTextOutput("info"), hr(),

          HTML(
          "<b> 説明 </b>
          <ul>
            <li> 箱の中の線は中央値を表しています</li>
            <li> 箱の上辺は75パーセンタイル、下辺は25パーセンタイルを表しています</li>
            <li> 外れ値がある場合は赤色で示されます</li>
          </ul>"

          )
      ),

    tabPanel("分布プロット", p(br()),
            HTML(
          "<b> 説明 </b>
          <ul>
			<li> ヒストグラム：ある範囲の値について各観察の頻度を描き、変数の確率分布を大まかに評価する図です</li>
			<li> 密度プロット：データの確率密度関数を推定するプロットです</li>
          </ul>"
            ),
      p(tags$b("ヒストグラム")),
      plotly::plotlyOutput("makeplot"),
      sliderInput("bin","ヒストグラムのビンの数",min = 0,max = 100,value = 0),
      p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
      p(tags$b("密度プロット")),
      plotly::plotlyOutput("makeplot.1")

      )
    ),
hr(),
h4(tags$b("Output 2. 検定結果")),
    p(tags$b('ウィルコクソン符号順位検定（Wilcoxon Signed-Rank Test）の結果')), p(br()),
    DT::DTOutput("ws.test.t"),

    HTML(
    "<b> 説明 </b>
    <ul>
    <li> P < 0.05の場合、母集団の中央値と指定された中央値との間に有意差があります。(対立仮説が採択されます)</li>
    <li> P >= 0.05の場合、母集団の中央値と指定された中央値の間に有意差はありません。(帰無仮説が採択されます)</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("デフォルト設定から、スケールは1よりも有意に大きい（P = 0.006）と結論付けました。これは、患者がうつ病に苦しんでいることを示しています。"))
  )#,
  )
)
