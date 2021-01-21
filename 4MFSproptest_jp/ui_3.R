#****************************************************************************************************************************************************2.prop2
    sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. データの準備")),
     p(tags$b("データに名前を付ける")),
        tags$textarea(id = "gn",
          rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

      p(tags$b("成功/イベントに名前を付ける")),
        tags$textarea(id = "ln3",
          rows = 2,
        "Cancer\nNo-Cancer"
      ),
        p(br()), 

        p(tags$b("各群の成功/イベントの数, x")),
        tags$textarea(id = "xx", rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("各群の試行回数/サンプル数, n > x")),     
        tags$textarea(id = "nn", rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

    p("注：欠測値がないようにしてください。"),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、nに示すように5つの年齢層の人々がいて、xに癌を患った人々の数を記録しています。"))
    ),

        hr(),

    h4(tags$b("仮説")),

     p(tags$b("帰無仮説")), 

      p("確率/割合は群全体で同じ"),
      
      p(tags$b("対立仮説")), 
       p("確率/割合は同じではない"),          
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、がんになる確率が年齢層によって異なるかどうかを知りたいです"))
    )
   

    ),

      mainPanel(

      h4(tags$b("Output 1. データの確認")), p(br()), 

      tabsetPanel(
        tabPanel("Table",p(br()),
          
        p(tags$b("データ表")),

        DT::DTOutput("n.t")

          ),
        tabPanel("比例プロット",p(br()),
          plotly::plotlyOutput("makeplot3")

          )
        ),

      hr(),

      h4(tags$b("Output 2. 検定結果")), p(br()), 

      DT::DTOutput("n.test"),


     HTML(
    "<b> 説明 </b> 
    <ul> 
    <li> P < 0.05の場合、母集団の確率/割合は有意差があります (対立仮説が採択されます)</li>
    <li> P >= 0.05の場合、母集団の確率/割合に有意差はありません。(帰無仮説が採択されます)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、がんになる確率は年齢層によって大きく異なると結論付けました。 （P <0.001）"))
     )

        )
      )
