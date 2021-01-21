#****************************************************************************************************************************************************1.chi
sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. 列名として、2つのカテゴリの因子にそれぞれ名前を付ける")),
  tags$textarea(id="cn1", rows=2, "Developed-MI\nNo MI"),

    p(tags$b("2. 行名として、症例/対照の2つにそれぞれ名前を付ける")), 
  tags$textarea(id="rn1", rows=2, "OC user\nNever OC user"), p(br()),

  p(tags$b("3. 行の順序で4つの値を入力する")),
  p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
  tags$textarea(id="x1", rows=4, 
    "13\n4987\n7\n9993"),

  p("注：欠測値がないようにしてください。"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("ケース/コントロールは、経口避妊薬 (OC)ユーザーと、非経口避妊薬 (OC)ユーザーで、 ファクターカテゴリーは心筋梗塞 (MI)が発病されたかどうか。")),
  p(tags$i("MIを発症した人数はOC使用者5000例のうち13例、非OC使用者のうち7例でした。"))
  ),

  hr(),

   h4(tags$b("仮説")),

   p(tags$b("帰無仮説")), 
   p("症例/対照 (行) とグループ化因子 (列) との間に有意な関係はない"),
    
   p(tags$b("対立仮説")), 
   p("ケース/コントロール（行）は、グループ化された因子（列）と有意な関連がある"),
conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("この例では、OCの使用がMI発生率の上昇と有意に関連しているかどうかを判断したいです。"))
  ),

hr(),

  h4(tags$b("Step 2. P値を決める方法を選ぶ")),
    radioButtons("yt1", label = "P値に対するイェーツの補正", 
        choiceNames = list(
          HTML("補正を行う：期待値は5以上であるが大きくない"),
          HTML("補正を行わない：標本が非常に大きい")
          ),
        choiceValues = list(TRUE, FALSE)
        )
    ),

    mainPanel(

    h4(tags$b("Output 1. データの確認")), p(br()), 

    tabsetPanel(

    tabPanel("分割表", p(br()),

        p(tags$b("総数を含む2x2分割表")),
        DT::DTOutput("dt1"),

        p(tags$b("期待値")),
        DT::DTOutput("dt1.0")
        ),

    tabPanel("パーセンテージ表", p(br()),

        p(tags$b("各セル/総数 %")),
        DT::DTOutput("dt1.3"),

        p(tags$b("セル/行の合計 %")),
        DT::DTOutput("dt1.1"),

        p(tags$b("セル/列の合計 %")),
        DT::DTOutput("dt1.2")
        ),

    tabPanel("比例プロット", p(br()),
      p(tags$b("行単位のパーセンテージ")),
      plotly::plotlyOutput("makeplot1"),
      p(tags$b("列単位のパーセンテージ")),
      plotly::plotlyOutput("makeplot1.1")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test1"),

     HTML(
    "<b> 説明 </b> 
    <ul> 
    <li> P < 0.05の場合、 ケース/コントロール（行）はグループ化された因子（列）と有意に関連しています。 (対立仮説が採択されます)</li>
    <li> P > = 0.05の場合、ケース/コントロール（行）はグループ化された因子（列）に関連付けられません。 (帰無仮説が採択されます)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、MIの発病とOCを使用することには有意に関連があると結論付けました （P = 0.01）。最小期待値が6.67であったため、イェイツのP値の修正が行われました。" ))
)
        )
      )
    