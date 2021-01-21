#****************************************************************************************************************************************************4.prop.t

 sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. データの準備")),
    p(tags$b("例のように、データを入力してください")),

      p(tags$b("1. データに名前を付ける")), 
        tags$textarea(id = "cn4",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

    p(tags$b("2. 成功/イベントに名前を付ける")), 
        tags$textarea(id = "rn4",rows = 2,
        "Cancer\nNo-Cancer"
      ),
    p(br()),

    p("データは , ; /Enter /Tabで区切ることができます。"),
    p(tags$b("3. 各群の成功/イベントの数 (x)")),
    tags$textarea(id = "x4", rows = 5,
    "320\n1206\n1011\n463\n220"        
    ),

    p(tags$b("4. 各群の試行回数/サンプル数 (n > x)")),     
    tags$textarea(id = "x44", rows = 5,
    "1742\n5638\n3904\n1555\n626"
    ),

    p("注：欠測値がないようにしてください。"),
    conditionalPanel(
    condition = "input.explain_on_off",

    p(tags$i("この例では、nに示すように5つの年齢層の人々がいて、xに癌を患った人々の数を記録しています。"))
    ),

        hr(),

   h4(tags$b("Step 2. 標本について検定したい順序を選ぶ")),

    p(tags$b("列の順序 (標本と同じ長さ)")),
    tags$textarea(id = "xs", rows = 5,
        "1\n2\n3\n4\n5"        
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この場合、年齢層は昇順でした"))
    ),

    hr(),

    h4(tags$b("仮説")),

   p(tags$b("帰無仮説")), 
   p("標本の割合に変動がない"),
    
   p(tags$b("対立仮説")), 
   p("割合/率/確率が変動する")   

    ),

    mainPanel(

    h4(tags$b("Output 1. データの確認")), p(br()), 

    tabsetPanel(

    tabPanel("Table", p(br()),

        p(tags$b("データ表")),
        DT::DTOutput("dt4"),

        p(tags$b("パーセンテージ%")),
        DT::DTOutput("dt4.2")
        ),

    tabPanel("比例プロット", p(br()),

      plotly::plotlyOutput("makeplot4")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test4"),

     HTML(
    "<b> 説明 </b> 
    <ul> 
    <li> P < 0.05の場合、 割合/率/確率が有意に変動しています (対立仮説が採択されます)</li>
    <li> P >= 0.05の場合、標本の割合に変動がありません. (帰無仮説が採択されます)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、がんの割合は年齢によって異なると結論付けました。 （P = 0.01）"))
     )

        )
      )
    