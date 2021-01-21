#****************************************************************************************************************************************************5. r c chi

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. 因子1の各カテゴリに、列名として名前を付ける")),
        tags$textarea(id = "cn5",rows = 5,
        "Smear+\nSmear-Culture+\nSmear-Culture-"
      ),
    p(tags$b("2. 因子2の各カテゴリに、行名として名前を付ける")), 
        tags$textarea(id = "rn5",rows = 5,
        "Penicillin\nSpectinomycin-low\nSpectinomycin-high"
      ),
        p(br()), 

    p(tags$b("3. 行の順序で R*C 個の値を入力する")),
      p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
      tags$textarea(id="x5", rows=10, 
      "40\n30\n130\n10\n20\n70\n15\n40\n45"),
      p("注：欠測値がないようにしてください。"),
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("行は異なる薬物治療であり、列は異なる応答でした")),
  p(tags$i("200人のペニシリンユーザーのうち、40人がSmear +、30人がSmear-　Culture+、その他がSmear-　Culture-でした。")),
  p(tags$i("100人のスペクチノマイシン（低用量）ユーザーのうち、10人がSmear +、20人がSmear-　Culture+、その他がSmear-　Culture-でした。")),
  p(tags$i("100人のスペクチノマイシン（高用量）ユーザーのうち、15人がSmear +、40人がSmear-　Culture+、その他がSmear-　Culture-でした。"))
  ),

        hr(),

    h4(tags$b("仮説")),

   p(tags$b("帰無仮説")), 
   p("症例/対照 (行) とグループ化因子 (列) との間に有意な関係はない"),
    
   p(tags$b("対立仮説")), 
   p("ケース/コントロール（行）は、グループ化された因子（列）と有意な関連がある"),     
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この設定では、薬物治療と反応の間に関係があるかどうかを知りたいです。"))
    )
   

    ),


    mainPanel(

    h4(tags$b("Output 1. データの確認")), p(br()), 

    tabsetPanel(

    tabPanel("分割表", p(br()),
    

        p(tags$b("総数を含むRxC分割表")),
        DT::DTOutput("dt5"),

        p(tags$b("期待値")),
        DT::DTOutput("dt5.0")
        ),
    tabPanel("パーセンテージ表", p(br()),

        p(tags$b("各セル/総数 %")),
        DT::DTOutput("dt5.3"),

        p(tags$b("セル/行の合計 %")),
        DT::DTOutput("dt5.1"),

        p(tags$b("セル/列の合計 %")),
        DT::DTOutput("dt5.2")
        ),

    tabPanel("比例プロット", p(br()),

      plotly::plotlyOutput("makeplot5")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test5"),

     HTML(
    "<b> 説明 </b> 
    <ul> 
    <li> P < 0.05の場合、 ケース/コントロール（行）はグループ化された因子（列）と有意に関連しています。 (対立仮説が採択されます)</li>
    <li> P > = 0.05の場合、ケース/コントロール（行）はグループ化された因子（列）に関連付けられません。 (帰無仮説が採択されます)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、薬物治療と反応の間に有意な関係があったと結論付けています。 （P <0.001）"))
     )

        )
      )
    