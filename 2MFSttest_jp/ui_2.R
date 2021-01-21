#****************************************************************************************************************************************************2.t2
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. データに名前を付ける (必須)")),

  tags$textarea(id = "cn2", rows = 2, "Age.positive\nAge.negative"), p(br()),

    p(tags$b("2. データの入力")),

    tabsetPanel(
      ##-------input data-------##
      tabPanel("手入力", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例は、27人のエストロゲン受容体（ER）陽性のリンパ節陽性患者（Group.1-Age.positive）と117人のER陰性患者（Group.2-Age.negative）の年齢です。"))
    ),

    p(tags$b("例のようにデータを入力してください")),
    p("データは , ; /Enter /Tab /Spaceで区切ることができます"),
    p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")), 
        p(tags$b("群 1")),
        tags$textarea(id = "x1",rows = 10,
"47\n45\n31\n38\n44\n49\n48\n44\n47\n45\n37\n43\n49\n32\n41\n38\n37\n44\n45\n46\n26\n49\n48\n45\n46"
),
        p(tags$b("群 2")),
        tags$textarea(id = "x2",rows = 10,
"50\n42\n50\n43\n47\n38\n41\n48\n47\n36\n42\n42\n45\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48"
), 

    p("欠測値はNAと入力し、2つのセットのデータの長さが同じになるようにします。長さが異なるとエラーになります。")

        ),
tabPanel.upload.num(file ="file2", header="header2", col="col2", sep="sep2")

        ),

    hr(),

  h4(tags$b("仮説を選択する")),

  h4(tags$b("Step 2. 分散の等価性")),
  p("T検定を行う前に、分散が等しいかを確認し、使用するT検定の種類を決める必要があります。"),
  p(tags$b("帰無仮説")),
  HTML("<p> v1 = v2: 群1と群2の母分散は等しい </p>"),

    radioButtons("alt.t22", #p
      label = "対立仮説",
      choiceNames = list(
        HTML("v1 &#8800 v2: 群1と群2の母分散は等しくない"),
        HTML("v1 < v2: 群1の母分散は群2の母分散よりも小さい"),
        HTML("v1 > v2: 群1の母分散は群2の母分散よりも大きい")
        ),
      choiceValues = list("two.sided", "less", "greater")),
    hr(),

  h4(tags$b("Step 3. T検定")),

  p(tags$b("帰無仮説")),
  HTML("<p> &#956&#8321 = &#956&#8322: 群1と群2の母平均は等しい</p>"),

    radioButtons("alt.t2", #p
      label = "対立仮説",
      choiceNames = list(
        HTML("&#956&#8321 &#8800 &#956&#8322: 群1と群2の母平均は等しくない"),
        HTML("&#956&#8321 < &#956&#8322: 群1の母平均は群2の母平均よりも小さい"),
        HTML("&#956&#8321 > &#956&#8322: 群1の母平均は群2の母平均よりも大きい")
        ),
      choiceValues = list("two.sided", "less", "greater")),
    conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("このデフォルト設定では、ER陽性の患者の年齢がER陰性の患者と有意に異なるかどうかを知りたいです"))
    )


    ),

  mainPanel(

  h4(tags$b("Output 1. 記述統計の結果")),

    tabsetPanel(

    tabPanel("データの確認", p(br()),

      DT::DTOutput("table2")),

    tabPanel("記述統計量", p(br()),

          DT::DTOutput("bas2")
      ),

      tabPanel("ボックスプロット",p(br()),

      plotly::plotlyOutput("bp2"), #,click = "plot_click2"

        #verbatimTextOutput("info2"),
        hr(),

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

        plotly::plotlyOutput("meanp2")),

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
        plotly::plotlyOutput("makeplot2"),
        #plotOutput("makeplot2.2"),
        p(tags$b("ヒストグラム")),
        plotly::plotlyOutput("makeplot2.3"),
        sliderInput("bin2","ヒストグラムのビンの数",min = 0,max = 100,value = 0),
        p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
        p(tags$b("密度プロット")),
        plotly::plotlyOutput("makeplot2.4")

         )

      ),

    hr(),
    h4(tags$b("Output 2. 検定結果 1")),

    tags$b("2つの分散の等価性を確認"),

    DT::DTOutput("var.test"),

    HTML(
    "<b> 説明 </b>
    <ul>
    <li> P < 0.05の場合、 <b>ウェルチ2標本t検定（Welch Two-Sample t-test）</b>の結果を使って下さい</li>
    <li> P >= 0.05の場合、 <b>2標本t検定（Two-Sample t-test）</b>の結果を使って下さい</li>
    </ul>"
  ),

    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、F検定のP値は約0.15（> 0.05）であり、データの分散が等しいことを示しています。 したがって、「2標本t検定」の結果を使います"))
    ),

    hr(),
    h4(tags$b("Output 3. 検定結果 2")),

    tags$b("T検定を選択"),

    DT::DTOutput("t.test2"),
    p(br()),

      HTML(
    "<b> 説明 </b>
    <ul>
    <li> P < 0.05の場合、2群のデータの母平均の間に有意差があります。(対立仮説が採択されます)</li>
    <li> P >= 0.05の場合、2群のデータの母平均の間に有意差はありません。(帰無仮説が採択されます)</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、ER陽性のリンパ節陽性集団の年齢はER陰性と有意差がないと結論付けました（P = 0.55、「2標本t検定」から）"))
    )
    )
  )
