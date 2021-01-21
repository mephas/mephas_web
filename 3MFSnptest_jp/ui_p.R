#****************************************************************************************************************************************************3.npp

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. データの準備")),
  p(tags$b("1. データに名前を付ける (必須)")),

  tags$textarea(id="cn3", rows=3, "Before\nAfter\nAfter-Before"), p(br()),


  p(tags$b("2. データの入力")),

  tabsetPanel(

  tabPanel("手入力", p(br()),
        conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここに示されている例は、治療前後の9人の患者のうつ病評価尺度因子（DRS）の測定値です。"))
      ),

    p(tags$b("例のようにデータを入力してください")),
    p("データは , ; /Enter /Tab /Spaceで区切ることができます"),
    p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")),   
      
    p(tags$b("群1 (治療前)")),
    tags$textarea(id="y1",
      rows=10,
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
    ),

    p(tags$b("群2 (治療後)")),
    tags$textarea(id="y2",
      rows=10,
      "0.88\n0.65\n0.59\n2.05\n1.06\n1.29\n1.06\n3.14\n1.29"
      ),

    p("欠測値はNAと入力し、2つのセットのデータの長さが同じになるようにします。長さが異なるとエラーになります。")

),

tabPanel.upload.num(file ="file3", header="header3", col="col3", sep="sep3")

    ),

  hr(),

  h4(tags$b("Step 2. 仮説を選択する")),

  p(tags$b("帰無仮説")),
  HTML("<p>  m = 0: 群1 (治療前)と群2 (治療後)の中央値の差が0 </p>
        <p>  つまり、対応のある値の差の分布が0を中心として対称</p> "),

  radioButtons("alt.wsr3", label = "対立仮説",
    choiceNames = list(
      HTML("m &#8800 0: 群1 (治療前)の中央値と群2 (治療後)の中央値の差が0ではない；対応のある値の差の分布が0を中心として対称ではない"),
      HTML("m < 0: 群2 (治療後)の母集団の中央値のほうが大きい"),
      HTML("m > 0: 群1 (治療前)の母集団の中央値のほうが大きい")),
    choiceValues = list("two.sided", "less", "greater")),
      conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("この例では、治療後のスケールに有意差があるかどうかを知りたいです。"))
        ),
hr(),

h4(tags$b("Step 3. P値を決める方法を選ぶ")),
radioButtons("alt.md3",
    label = "どのようなデータか", selected = "c",
	choiceNames = list(
      HTML("P値はほぼ正規分布（Approximate normal distributed P value）：標本サイズが大きい"),
      HTML("P値は漸近的に正規分布（Asymptotic normal distributed P value）：標本サイズが大きい"),
      HTML("正確なP値（Exact P value）：標本サイズが小さい (< 50未満)")
      ),
    choiceValues = list("a", "b", "c")),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、9人しかいないため、正確なP値を選択しました。"))
    )

  ),

mainPanel(

  h4(tags$b("Output 1. 記述統計の結")),

  tabsetPanel(

    tabPanel("データの確認", p(br()),

      DT::DTOutput("table3")
      ),

    tabPanel("記述統計量", p(br()),

        DT::DTOutput("bas3")
  ),

    tabPanel("差のボックスプロット", p(br()),

        plotly::plotlyOutput("bp3"),#click = "plot_click3"

        verbatimTextOutput("info3"), hr(),

          HTML(
          "説明:
          <ul>
            <li> 箱の中の線は中央値を表しています</li>
            <li> 箱の上辺は75パーセンタイル、下辺は25パーセンタイルを表しています</li>
            <li> 外れ値がある場合は赤色で示されます</li>
          </ul>"

          )
      ),

    tabPanel("分布プロット", p(br()),
            HTML(
          "Notes:
          <ul>
			<li> ヒストグラム：ある範囲の値について各観察の頻度を描き、変数の確率分布を大まかに評価する図です</li>
			<li> 密度プロット：データの確率密度関数を推定するプロットです</li>
          </ul>"
            ),
      p(tags$b("ヒストグラム")),
      plotly::plotlyOutput("makeplot3"),
      sliderInput("bin3", "ヒストグラムのビンの数",min = 0,max = 100,value = 0),
      p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
      p(tags$b("密度プロット")),
      plotly::plotlyOutput("makeplot3.1")

      )
    ),

    hr(),

  h4(tags$b("Output 2. 検定結果")),p(br()),
  tags$b('Results of Wilcoxon Signed-Rank Test'),
    DT::DTOutput("psr.test.t"),
      HTML(
    "<b> 説明 </b>
    <ul>
    <li> P < 0.05の場合、 群1 (治療前) と群2 (治療後)には有意差がある。(対立仮説が採択されます)</li>
    <li> P >= 0.05の場合、 2群のデータに有意差がありません。(帰無仮説が採択されます)</li>
    </ul>"
  ),
      conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("デフォルト設定から、治療後に有意差はないと結論付けました。 （P = 0.46）"))
    )


)
)
