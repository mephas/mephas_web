#****************************************************************************************************************************************************8. mh

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. 列名として、2つのカテゴリの因子にそれぞれ名前を付ける")),
        tags$textarea(id = "cn8",rows = 2,
        "Passive Smoker\nNon-Passive-Smoker"
      ),
    p(tags$b("2. 行名として、症例/対照の2つにそれぞれ名前を付ける")), 
        tags$textarea(id = "rn8",rows = 2,
        "Cancer (Case)\nNo Cancer (Control)"
      ),
  p(tags$b("3. 行名として、交絡している各カテゴリに名前を付ける")),
        tags$textarea(id = "kn8",rows = 4,
        "No-Active Smoker\nActive Smoker"
      ),
        p(br()), 

    p(tags$b("3. 行の順序で2*2*K個の値を入力")),
      p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
      tags$textarea(id="x8", rows=10, 
      "120\n111\n80\n115\n161\n117\n130\n124"),
      p("注：欠測値がないようにしてください。"),
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここでの例は、2x2テーブルの2セットでした。 1つは、アクティブな喫煙者のためのケースコントロールテーブルです。 もう1つは、非アクティブな喫煙者のケースコントロールテーブルです。"))
    ),

        hr(),

    h4(tags$b("Step 2. 仮説を選ぶ")),

   p(tags$b("帰無仮説")), 
   p("各層/交絡群で、症例/対照 (行) とグループ化因子 (列) の間に有意な関係はない"),
    
   radioButtons("alt8", label = "対立仮説", 
        choiceNames = list(
          HTML("症例/対照 (行) とグループ化因子 (列) との間に有意な関係があり、各層のオッズ比に有意差がある"),
          HTML("層1のオッズ比は層2のオッズ比よりも高い"),
          HTML("層2のオッズ比は層1のオッズ比よりも高い")
          ),
        choiceValues = list("two.sided", "greater", "less")
        ),
   hr(),

  h4(tags$b("Step 3. P値を決める方法を選ぶ")),
  radioButtons("md8", 
    label = "What is the data like", 
    choiceNames = list(
      HTML("漸近的正規分布のP値：標本サイズが大きくない(>= 15)"),
      HTML("ほぼ正規分布または正規分布：標本サイズが非常に大きい(> 40程度)"),
      HTML("正確なP値：標本サイズが小さい(< 15未満)")
      ), 
    choiceValues = list("a", "b", "c")),
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この設定では、受動喫煙者の肺がん（症例）のオッズ比が非受動喫煙者と異なり、個人の能動喫煙を制御しているかどうかを知りたいです。"))
    )
   
    ),


    mainPanel(

    h4(tags$b("Output 1. データの確認")), p(br()), 

    p(tags$b("K層の2x2分割表")),
    p("最初の2行は、最初の階層の2 x 2分割表を示し、その後に2番目の階層の2 x2分割表が続きます。"),

    DT::DTOutput("dt8"),

    hr(),

    h4(tags$b("Output 2. 検定結果")), p(br()), 

    DT::DTOutput("c.test8"),

     HTML(
    "<b> 説明 </b> 
    <ul> 
    <li> P < 0.05の場合、個人喫煙を制御している状況で、受動喫煙と癌のリスクには有意な関係はあり、オッズ比は有意に異なります。 (対立仮説が採択されます)</li>
    <li> P > = 0.05の場合、個人喫煙を制御している状況で、受動喫煙と癌のリスクには、有意な関係はありません。 (帰無仮説が採択されます)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("このデフォルト設定では、個人の能動喫煙を制御している状況では、がんリスクと受動喫煙の間に有意な関係があったと結論付けています。 （P <0.001）"))
      )
        )
      )
    