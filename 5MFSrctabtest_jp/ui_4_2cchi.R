#****************************************************************************************************************************************************4. 2 c chi
   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. データの準備")),

  p(tags$b("2. 列名として、カテゴリの因子にそれぞれ名前を付ける")),
        tags$textarea(id = "cn3",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),
    p(tags$b("2. 行名として、症例/対照の2つにそれぞれ名前を付ける")), 
        tags$textarea(id = "rn3",rows = 2,
        "Cancer\nNo-Cancer"
      ),

        p(br()), 

        p(tags$b("3. 各グループの症例数")),
        p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
        tags$textarea(id = "x3", rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("4. 各グループの対照数")), 
        p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
        tags$textarea(id = "x33", rows = 5,
        "1422\n4432\n2893\n1092\n406"
        ),

    p("注：欠測値がないようにしてください。"),
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、さまざまな年齢で示されているように、5つの年齢層の人々がいて、癌を患っている人と癌を患っていない人の数を記録しています。"))
    ),

        hr(),

    h4(tags$b("仮説")),

   p(tags$b("帰無仮説")), 
   p("症例/対照 (行) とグループ化因子 (列) との間に有意な関係はない"),
    
   p(tags$b("対立仮説")), 
   p("症例/対照 (行) とグループ化因子 (列) の間に有意な関係がある"),     
   conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この設定では、がんと年齢の間に何関係があるかどうかを知りたいです。"))
    )
   

    ),


    mainPanel(

    h4(tags$b("Output 1. データの確認")), p(br()), 

    tabsetPanel(

    tabPanel("分割表", p(br()),

        p(tags$b("総数を含む2xC分割表")),
        DT::DTOutput("dt3"),

        p(tags$b("期待値")),
        DT::DTOutput("dt3.0")
        ),
    tabPanel("パーセンテージ表", p(br()),

        p(tags$b("各セル/総数 %")),
        DT::DTOutput("dt3.3"),

        p(tags$b("セル/行の合計 %")),
        DT::DTOutput("dt3.1"),

        p(tags$b("セル/列の合計 %")),
        DT::DTOutput("dt3.2")
        ),

    tabPanel("比例プロット", p(br()),
      plotly::plotlyOutput("makeplot3")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test3"),

     HTML(
    "<b> 説明 </b> 
    <ul> 
    <li> P < 0.05の場合、 ケース/コントロール（行）はグループ化された因子（列）と有意に関連しています。 (対立仮説が採択されます)</li>
    <li> P > = 0.05の場合、ケース/コントロール（行）はグループ化された因子（列）に関連付けられません。 (帰無仮説が採択されます)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、癌と年齢の間に有意な関係があったと結論付けています。 （P <0.001）"))
     )

        )
      )
    