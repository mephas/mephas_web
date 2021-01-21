#****************************************************************************************************************************************************3.tp

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. データに名前を付ける (必須)")),

    tags$textarea(id = "cn.p", rows = 3, "Before\nAfter\nAfter-Before"), p(br()),

    p(tags$b("2. データの入力")),

  tabsetPanel(
          ##-------input data-------##
    tabPanel("手入力", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
        p(tags$i("ここでの例は、ある薬の影響を受けた睡眠時間です。 薬を服用する前後の睡眠時間を記録した"))
    ),

    p(tags$b("例のようにデータを入力してください")),
    p("データは , ; /Enter /Tab /Spaceで区切ることができます"),
    p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")),   
          p(tags$b("群1 (服用前)")),
            tags$textarea(id = "x1.p",rows = 10,
              "0.6\n3\n4.7\n5.5\n6.2\n3.2\n2.5\n2.8\n1.1\n2.9"
              ),
           p(tags$b("群2 (服用後)")),
            tags$textarea(id = "x2.p",rows = 10,
              "1.3\n1.4\n4.5\n4.3\n6.1\n6.6\n6.2\n3.6\n1.1\n4.9"
              ),
    p("欠測値はNAと入力し、2つのセットのデータの長さが同じになるようにします。長さが異なるとエラーになります。")

),
tabPanel.upload.num(file ="file.p", header="header.p", col="col.p", sep="sep.p")

        ),

        hr(),

  h4(tags$b("Step 2. 仮説を選択する")),

        tags$b("帰無仮説"),
        HTML("<p> &#916 = 0: 群1 (服用前) と群2 (服用後) に差がない </p>"),

        radioButtons(
          "alt.pt",
          label = "対立仮説",
          choiceNames = list(
            HTML("&#916 &#8800 0: 群1 (服用前) と群2 (服用後) に差がある"),
            HTML("&#916 < 0: 群2 (服用後) では群1 (服用前) に比べ睡眠時間が短い"),
            HTML("&#916 > 0: 群2 (服用後) では群1 (服用前) に比べ睡眠時間が長い")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),
      conditionalPanel(
        condition = "input.explain_on_off",
       p(tags$i("このデフォルト設定では、薬が効果があるかどうかを知りたいです。
	   つまり、薬を服用した後で睡眠時間が変わったかどうかを検定したいです。 "))
       )

        ),

      mainPanel(

  h4(tags$b("Output 1. 記述統計の結果")),

        tabsetPanel(

    tabPanel("データの確認", p(br()),

      DT::DTOutput("table.p")),

    tabPanel("記述統計量", p(br()),

      tags$b("差の記述統計"),

              DT::DTOutput("bas.p")
            ),

      tabPanel("ボックスプロット", p(br()),

       plotly::plotlyOutput("bp.p",width = "80%"),#,click = "plot_click3"

       #verbatimTextOutput("info3"), hr(),

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

            plotly::plotlyOutput("meanp.p")),

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
            plotly::plotlyOutput("makeplot.p"),
            p(tags$b("ヒストグラム")),
            plotly::plotlyOutput("makeplot.p2"),
            sliderInput("bin.p","ヒストグラムのビンの数",min = 0,max = 100,value = 0),
			p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します"),
			p(tags$b("密度プロット")),
            plotly::plotlyOutput("makeplot.p3")

            )
          ),

          hr(),
    h4(tags$b("Output 2. 検定結果")),p(br()),
          DT::DTOutput("t.test.p"),p(br()),

            HTML(
    "<b> 説明 </b>
    <ul>
    <li> P < 0.05の場合、 群1 (服用前) と群2 (服用後)は有意に等しくなりません. (対立仮説が採択されます)</li>
    <li> P >= 0.05の場合、 2群のデータに有意差がありません. (帰無仮説が採択されます)</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("デフォルト設定から、この薬は睡眠時間に有意な影響を及ぼさないと結論付けました。 （P = 0.2）"))
  )
        )
      )
