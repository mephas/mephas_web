#****************************************************************************************************************************************************2.np2

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. データに名前を付ける (必須)")),

  tags$textarea(id="cn2", rows=2, "Group1\nGroup2"), p(br()),

  p(tags$b("2. データの入力")),

  tabsetPanel(
  ##-------input data-------##
  tabPanel("手入力", p(br()),
        conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここに示されている例は、2つの患者グループからの19人の患者のうつ病評価尺度係数（DRS）の測定値です。"))
      ),

    p(tags$b("例のようにデータを入力してください")),
    p("データは , ; /Enter /Tab /Spaceで区切ることができます"),
    p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")),   
    p(tags$b("群 1")),
    tags$textarea(id="x1",
    rows=10,
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30\nNA"
    ),

    p(tags$b("群 2")),## disable on chrome
    tags$textarea(id="x2",
      rows=10,
      "0.80\n0.83\n1.89\n1.04\n1.45\n1.38\n1.91\n1.64\n0.73\n1.46"
      ),

    p("欠測値はNAと入力し、2つのセットのデータの長さが同じになるようにします。長さが異なるとエラーになります。")
    ),

  tabPanel.upload.num(file ="file2", header="header2", col="col2", sep="sep2")

        ),

  hr(),

    h4(tags$b("Step 2. 仮説を選択する")),

    p(tags$b("帰無仮説")),

    HTML("<p> m&#8321 = m&#8322: 2群の間で中央値は等しい </p>
          <p> つまり、各群で値の分布は等しい　</p>"),

radioButtons("alt.wsr2", label = "Alternative hypothesis",
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: 2群の母集団の中央値は等しくない"),
    HTML("m&#8321 < m&#8322: 母集団の中央値は群2のほうが大きい"),
    HTML("m&#8321 > m&#8322: 母集団の中央値は群1のほうが大きい")),
  choiceValues = list("two.sided", "less", "greater")),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("このデフォルト設定では、2つのグループの患者のうつ病評価尺度が異なるかどうかを知りたいです。"))
      ),
    hr(),


  h4(tags$b("Step 3. P値を決める方法を選ぶ")),
  radioButtons("alt.md2",
    label = "どのようなデータか", selected = "a",
	choiceNames = list(
      HTML("P値はほぼ正規分布（Approximate normal distributed P value）：標本サイズが大きい"),
      HTML("P値は漸近的に正規分布（Asymptotic normal distributed P value）：標本サイズが大きい"),
      HTML("正確なP値（Exact P value）：標本サイズが小さい (< 50未満)")
      ),
    choiceValues = list("a", "b", "c")),
      conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("各グループのサンプルサイズは9と10であったため、正確なp値を使用しました。"))
      )

  ),

mainPanel(

  h4(tags$b("Output 1. 記述統計の結果")),

  tabsetPanel(

    tabPanel("データの確認", p(br()),

      DT::DTOutput("table2")
      ),

    tabPanel("記述統計量", p(br()),

        DT::DTOutput("bas2")#,

      #p(br()),
      #  downloadButton("download2b", "Download Results")
      ),

    tabPanel("ボックスプロット", p(br()),
        plotly::plotlyOutput("bp2"),#, click = "plot_click2"

        #verbatimTextOutput("info2"),
        hr(),
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
          "説明:
          <ul>
			<li> ヒストグラム：ある範囲の値について各観察の頻度を描き、変数の確率分布を大まかに評価する図です</li>
			<li> 密度プロット：データの確率密度関数を推定するプロットです</li>
          </ul>"),
      p(tags$b("ヒストグラム")),
      plotly::plotlyOutput("makeplot2"),
      sliderInput("bin2", "ヒストグラムのビンの数",min = 0,max = 100,value = 0),
      p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
      p(tags$b("密度プロット")),
      plotly::plotlyOutput("makeplot2.1")
      )
    ),
  hr(),

  h4(tags$b("Output 2. 検定結果")),
  tags$b('ウィルコクソン順位和検定（Wilcoxon Rank-Sum Test）の結果'), p(br()),

  DT::DTOutput("mwu.test.t"), p(br()),

  HTML(
    "<b> Explanations </b>
    <ul>
    <li> P < 0.05の場合、2群の間で母集団の中央値に有意差があります。(対立仮説が採択されます)</li>
    <li> P >=  0.05の場合、2群の間で母集団の中央値に有意差はありません。(帰無仮説が採択されます)</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("デフォルト設定から、2つのグループの評価尺度に有意差はないと結論付けました。（P = 0.44）"))
    )#,


 # downloadButton("download2.1", "Download Results")

  )
)
