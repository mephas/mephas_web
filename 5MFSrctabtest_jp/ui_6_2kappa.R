#****************************************************************************************************************************************************6. 2k kappa

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1.  データの準備")),

    p(tags$b("1. 列名として、対象となる2名の観察者/2つのランキングに名前を付ける")), 
    tags$textarea(id="cn9", rows=2, "Survey1\nSurvey2"),p(br()),

  
  p(tags$b("2. 最初の観察者のK個の値を入力する")),
  p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
  tags$textarea(id="x9", rows=10, 
    "1\n2\n3\n4\n5\n6\n7\n8\n9"),
  p(br()),

  p(tags$b("3. 2番目の観察者のK個の値を入力する")),
  p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
  tags$textarea(id="x99", rows=10, 
    "1\n3\n1\n6\n1\n5\n5\n6\n7"),

    p("注：欠測値がないようにしてください。 2群はデータの長さが同じの必要がある。"),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここでの例は、Survey1とSurvey2を示しています。
      この設定では、2つのランキングは一致するかどうかを知りたいです。"))
    )
   

    ),


    mainPanel(

    h4(tags$b("Output 1. データの確認")), p(br()), 

    tabsetPanel(

    tabPanel("分割表", p(br()),
    p(tags$b("総数を含む2xK分割表")),
    DT::DTOutput("dt9")
    ),

    tabPanel("一致性表", p(br()),
    DT::DTOutput("dt9.0")
    ),
    tabPanel("重み表", p(br()),
    DT::DTOutput("dt9.1")
    )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test9"),

     HTML(
    "<b> カッパを用いた評価に関する説明とガイドライン </b> 
    <ul>
      <li> <b>コーエンのカッパ係数　> 0.75</b>: <b>優れた</b> 再現性 </li>
      <li> <b>0.4 <= コーエンのカッパ係数 <= 0.75</b>: <b>良好な</b> 再現性</li>
      <li> <b>0 <= コーエンのカッパ係数 < 0.4</b>: <b>低い</b> 再現性 </li>
      <li> コーエンのカッパ係数は、観察者2名の間が不一致であることを示しているだけであり、その程度は示していません。</li>
      <li> 重み付きカッパ係数は、2人の評価者間の不一致の程度を測定する事前定義された重み表を使用して計算されます。 不一致が大きいほど、重みが大きくなります。</li>
    </ul>

  "
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、Survey1とSurvey2からの応答の再現性はそれほど高くないと結論付けました。"))
  )
        )
      )
    