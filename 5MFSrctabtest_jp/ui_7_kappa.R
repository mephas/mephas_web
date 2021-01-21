#****************************************************************************************************************************************************7. kk kappa

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. データの準備")),

    p(tags$b("1. 列名と行名として、K個観察者間/測定に名前を付ける")), 
    tags$textarea(id="cn6", rows=2, "Yes\nNo"), 

    p(tags$b("2. 列名と行名として、対象となる実験/反復測定に名前を付ける")), 
    tags$textarea(id="rn6", rows=2, "Survey1\nSurvey2"),p(br()),

  
  p(tags$b("3. 行の順序でK*K個の値を入力する")),
  p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
  tags$textarea(id="x6", rows=4, 
    "136\n92\n69\n240"),
      p("注：欠測値がないようにしてください。"),
      conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここに示されている例は、調査1と調査2からの回答です。"))
    ),
        hr(),

    h4(tags$b("仮説")),

   p(tags$b("帰無仮説")), 
   p("症例/対照 (行) とグループ化因子 (列) との間に有意な関係はない"),
    
   p(tags$b("対立仮説")), 
   p("ケース/コントロール（行）は、グループ化された因子（列）と有意な関連がある"),     
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この設定では、調査の再現性を知りたいです。"))
    )
   

    ),


    mainPanel(

    h4(tags$b("Output 1. データの確認")), p(br()), 

    tabsetPanel(

    tabPanel("分割表", p(br()),

        p(tags$b("総数を含むKxK分割表")),
        DT::DTOutput("dt6")
        ),
    tabPanel("一致性表", p(br()),
        DT::DTOutput("dt6.0")
        ),
    tabPanel("重み表", p(br()),
        DT::DTOutput("dt6.1")
        )
    ),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test6"),

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
     p(tags$i("このデフォルト設定では、Survey1とSurvey2からの応答は再現性が低く、わずかに再現性があると結論付けました。"))
)
        )
      )
    