#****************************************************************************************************************************************************2.prop2

sidebarLayout(

  sidebarPanel(
    h4(tags$b("Step 1. データの準備")),

    p(tags$b("データに名前を付ける")),
    tags$textarea(id = "cn.2", rows = 2,
        "Birth>30\nBirth<30"
      ),
    p(tags$b("成功/イベントに名前を付ける")),
    tags$textarea(id = "rn.2", rows = 2,
        "Cancer (Case)\nNo-Cancer (Control)"
      ),
    p(br()),

    p(tags$b("例のように、データを入力してください")),

    p(tags$b("群 1 (ケース群)")),
      numericInput("x1", "(ケース群の中の)成功/イベントの数, x1", value =683, min = 0, max = 10000000, step = 1),
      numericInput("n1", "試行回数/サンプル数, n1 > x1", value = 3220, min = 1, max = 10000000, step = 1),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("群1のサンプルは3220人の乳がん患者の女性でした。 その中で、683人は30歳の後に少なくとも1回出産しました。 "))
    ),
    
    p(tags$b("群 2 (コントロール群)")),  
      numericInput("x2", "(コントロール群の中の)成功/イベントの数, x2", value = 1498, min = 0, max = 10000000, step = 1),
      numericInput("n2", "試行回数/サンプル数 , n2 > x2", value = 10245, min = 1, max = 10000000, step = 1),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("群2のサンプルは10245人の非乳がんの女性でした。 その中で、1498年は30歳の後に少なくとも1回出産しました。"))
    ),

      hr(),

    h4(tags$b("Step 2. 仮説を選択する")),

     tags$b("帰無仮説"), 

      HTML("<p> p<sub>1</sub> = p<sub>2</sub>: 群1と群2の間で確率/症例の割合は等しい </p>"),
      
      radioButtons("alt1", label = "対立仮説", 
        choiceNames = list(
          HTML("p<sub>1</sub> &#8800 p<sub>2</sub>: 確率/症例の割合は等しくない"),
          HTML("p<sub>1</sub> < p<sub>2</sub>: 群1での確率/症例の割合は群2よりも低い"),
          HTML("p<sub>1</sub> > p<sub>2</sub>: 群1の確率/症例の割合は群2よりも高い")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、30歳以上の最初の出産の確率が2つの群で異なるかどうかを知りたいです。"))
    ),
    hr(),
     
    h4(tags$b("Step 3. イェーツの補正の有無")),
    radioButtons("cr", label = "P値に対するイェーツの補正", 
        choiceNames = list(
          HTML("行う: サンプルサイズは十分に大きい: n1*p*(1-p)>=5 and n2*p*(1-p)>=5, p=(x1+x2)/(n1+n2)"),
          HTML("行わない: n1*p*(1-p)<5 or n2*p*(1-p)<5, p=(x1+x2)/(n1+n2)")
          ),
        choiceValues = list(TRUE, FALSE)
        )

      ),

  mainPanel(

    h4(tags$b("Output 1. データの確認")), p(br()), 

    p(tags$b("データ表")),
    DT::DTOutput("n.t2"),

    p(tags$b("比例プロット")),
    p(tags$b("1. ケース(Case)群")),
    plotly::plotlyOutput("makeplot2"),
    p(tags$b("2. コントロール(Control)群")),
    plotly::plotlyOutput("makeplot2.1"),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("p.test"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P < 0.05の場合、 2群は母集団の確率/割合に有意差があります. (対立仮説が採択されます)</li>
    <li> P Value >= 0.05の場合、2群は母集団の確率/割合に有意差はありません。(帰無仮説が採択されます)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
  HTML("<i> デフォルト設定から、乳がんの女性は、乳がんのない女性と比較して、30歳以降に最初の子供を産む可能性が非常に高いと結論付けています。 （P <0.001）</i>")
  )
          ) 

    )
    