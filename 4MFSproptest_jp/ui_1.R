#****************************************************************************************************************************************************1.prop1
  sidebarLayout(

    sidebarPanel(

    h4(tags$b("Step 1. データの準備")),

    p(tags$b("データに名前を付ける")),
	
    tags$textarea(id = "ln", rows = 2, "Infertility\nfertility "), p(br()),
    
    p(tags$b("例のように、データを入力してください")),

      numericInput("x", "成功/イベントの数, x", value = 10, min = 0, max = 100000, step = 1),
      numericInput("n", "試行回数/サンプル数, n > x", value = 40, min = 1, max = 100000, step = 1),    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、イベントの数は10で、合計サンプルサイズは40です。"))
    ),
    hr(),

    h4(tags$b("Step 2. パラメータを指定する")),

      numericInput('p', HTML("比較したい特定の率/割合/確率 (0 < p<sub>0</sub> < 1)"), value = 0.2, min = 0, max = 1, step = 0.1),
        conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここでは、一般的に不妊率（20％）は私たちが比較したかったものでした。"))
      ),

      hr(),

    h4(tags$b("Step 3. 仮説を選択する")),

    p(tags$b("帰無仮説")), 
    HTML("<p>p = p<sub>0</sub>: 確率/割合は p<sub>0</sub></p>"),
    
    radioButtons("alt", 
      label = "対立仮説", 
      choiceNames = list(
        HTML("p &#8800 p<sub>0</sub>: 確率/割合はp<sub>0</sub>ではない"),
        HTML("p < p<sub>0</sub>: 確率/割合はp<sub>0</sub>よりも小さい"),
        HTML("p > p<sub>0</sub>: 確率/割合はp<sub>0</sub>よりも大きい")),
      choiceValues = list("two.sided", "less", "greater")
      ),
    conditionalPanel(
    condition = "input.explain_on_off",
	p(tags$i("この例では、一般的な不妊率の20％と比較して、治療を受けた女性の不妊率に有意差があるかどうかを検定したいため、最初の対立仮説を使用します。"))
	)
      ),

  mainPanel(

    h4(tags$b("Output 1. 検定結果")), p(br()), 

    plotly::plotlyOutput("makeplot"),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    HTML("<b>1. イェーツの連続補正を伴う正規理論方法 (Normal Theory Method with Yates' Continuity Correction), np<sub>0</sub>(1-p<sub>0</sub>) >= 5</b>"), p(br()), 

    DT::DTOutput("b.test1"),

    HTML("<b>2. 正確二項検定 (Exact Binomial Method), np<sub>0</sub>(1-p<sub>0</sub>) < 5</b>"),  
    p(br()), 

    DT::DTOutput("b.test"),

     HTML(
    "<b> 説明 </b> 
    <ul> 
     <li> P < 0.05の場合、 データの母確率/割合と指定された確率/割合との間に有意差があります。(対立仮説が採択されます)</li>
	 <li> P >= 0.05の場合、データの母確率/割合と指定された確率/割合との間に有意差はありません。(帰無仮説が採択されます)</li>
	</ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
  HTML("<i> デフォルト設定から、一般的な不妊率と比較して、治療を受けた女性との間で不妊率に有意差はないと結論付けました（P = 0.55）。 
  この場合、 np<sub>0</sub>(1-p<sub>0</sub>)=40*0.2*0.8 > 5であるため、<b>正規理論方法(Normal Theory Method)</b>が推奨されました。</i>")
  )


    )
  )
