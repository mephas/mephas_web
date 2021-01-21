#****************************************************************************************************************************************************2. fisher
sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. 列名として、2つのカテゴリの因子にそれぞれ名前を付ける")),
  tags$textarea(id="cn4", rows=2, "High salt\nLow salt"),

  p(tags$b("2. 行名として、症例/対照の2つにそれぞれ名前を付ける")), 
  tags$textarea(id="rn4", rows=2, "CVD\nNon CVD"), p(br()),

  p(tags$b("3. 行の順序で4つの値を入力する")),
  p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
  tags$textarea(id="x4", rows=4, 
    "5\n30\n2\n23"),

  p("注：欠測値がないようにしてください。"),
conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("症例/対照はCVD患者であったかどうか、 要因のカテゴリーは、高塩分食であるかどうかです。")),
  p(tags$i("CVDで死亡した35人のうち、5人は死亡する前に高塩分食を摂っていました。 他の原因で死亡した25人のうち、2人は高塩分食でした。"))
  ),

  hr(),

   h4(tags$b("Step 2. 仮説を選択する")),

   p(tags$b("帰無仮説")), 
   p("症例/対照 (行) とグループ化因子 (列) との間に有意な関係はない"),

    radioButtons("yt4", label = "対立仮説", 
        choiceNames = list(
          HTML("ケース/コントロール（行）は、グループ化された因子（列）と有意な関連があり、 グループ1のオッズ比はグループ2とは大きく異なる"),
          HTML("群1のオッズ比は群2のオッズ比よりも大きい"),
          HTML("群2のオッズ比は群1のオッズ比よりも大きい")
          ),
        choiceValues = list("two.sided", "greater", "less")
        ),
    conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("この例では、死因と高塩分食との間に関連があるかどうかを判断したいです。"))
      )

    ),

    mainPanel(

    h4(tags$b("Output 1.  データの確認")), p(br()), 

    tabsetPanel(

    tabPanel("分割表", p(br()),

        p(tags$b("総数を含む2x2分割表")),
        DT::DTOutput("dt4"),

        p(tags$b("期待値")),
        DT::DTOutput("dt4.0")
        ),

    tabPanel("パーセンテージ表", p(br()),

        p(tags$b("各セル/総数 %")),
        DT::DTOutput("dt4.3"),

        p(tags$b("セル/行の合計 %")),
        DT::DTOutput("dt4.1"),

        p(tags$b("セル/列の合計 %")),
        DT::DTOutput("dt4.2")
        ),

    tabPanel("比例プロット", p(br()),
      p(tags$b("行単位のパーセンテージ")),
      plotly::plotlyOutput("makeplot4"),
      p(tags$b("列単位のパーセンテージ")),
      plotly::plotlyOutput("makeplot4.1")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test4"),

     HTML(
    "<b> 説明 </b> 
    <ul> 
    <li> P < 0.05の場合、 ケース/コントロール（行）はグループ化された因子（列）と有意に関連しています (対立仮説が採択されます)</li>
    <li> P > = 0.05の場合、ケース/コントロール（行）はグループ化された因子（列）に関連付けられません。 (帰無仮説が採択されます)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、2つの期待値<5であるため、フィッシャーの正確確率検定を使用しました。 検定結果から、死因と高食塩食との間に有意な関連は見られなかったと結論付けました。" ))
)
        )
      )
    