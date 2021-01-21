#****************************************************************************************************************************************************3. mcnemar

sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. アウトカムの2つの共通カテゴリに、それぞれ列名と行名として名前を付ける")),
  tags$textarea(id="cn2", rows=2, "Better\nNo-change"), 

  p(tags$b("2. 因子/治療に、行名と列名として名前を付ける")), 
  tags$textarea(id="rn2", rows=2, "Treatment-A\nTreatment-B"),p(br()),

  
  p(tags$b("3. 行の順序で4つの値を入力する")),
  p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
  tags$textarea(id="x2", rows=4, 
    "510\n16\n5\n90"),
  p("注：欠測値がないようにしてください。"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("ここに示されている例は、621ペアの患者で、1つのグループは治療Aを受け、もう1つのグループは治療Bを受けました。患者は同様の年齢と臨床状態でペアになりました。")),
  p(tags$i("621ペアの患者のうち、510ペアは治療Aと治療Bの両方で優れていました。 90ペアは治療Aでも治療Bでも変化しませんでした。（一致ペア）")),
  p(tags$i("16ペアでは、治療Aの後しか優れていません。 5ペアでは、治療Bの後しかしか優れていません。 （不一致ペア）"))
  ),

  hr(),

   h4(tags$b("仮説")),

   p(tags$b("帰無仮説")), 
   p("因子には有意差はない"),
    
   p(tags$b("対立仮説")), 
   p("ペアにした標本において、因子に有意差がある"),
   conditionalPanel(
    condition = "input.explain_on_off",
   p(tags$i("この例では、対応するペアに対して処置（治療）に有意差があるかどうかを判断します。"))
   ),
      
  hr(),

  h4(tags$b("Step 2. P値を決める方法を選ぶ")),
    radioButtons("yt2", label = "P値に対するイェーツの補正", 
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
        DT::DTOutput("dt2"),

        p(tags$b("期待値")),
        DT::DTOutput("dt2.0")
        ),
    
    tabPanel("パーセンテージ表", p(br()),

        p(tags$b("各セル/総数 %")),
        DT::DTOutput("dt2.3"),

        p(tags$b("セル/行の合計 %")),
        DT::DTOutput("dt2.1"),

        p(tags$b("セル/列の合計 %")),
        DT::DTOutput("dt2.2")
        ),

    tabPanel("比例プロット", p(br()),
      plotly::plotlyOutput("makeplot2")
      )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test2"),

     HTML(
    "<b> 説明 </b> 
    <ul> 
    <li> P < 0.05の場合、 因子はペアのサンプルで有意差があります。 (対立仮説が採択されます)</li>
    <li> P > = 0.05の場合、因子に有意差はありません。 （帰無仮説が採択されます）</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、2つの治療がペアの患者に有意に異なる効果をもたらしたと結論付けました。 （P = 0.03）"))
)
        )
      )
    