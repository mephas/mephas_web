#****************************************************************************************************************************************************2. 2-way

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. データのの準備")),

  p(tags$b("1. 値および2つの因子群の変数に名前を付ける")),

  tags$textarea(id = "cn", rows = 3, "SBP\nDiet\nSex"),p(br()),

  p(tags$b("2. データ入力")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("手入力", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここでの例は、3つのグレードの腫瘍と2つのレベルのERの下にある100人のリンパ節陽性患者の完全な無転移追跡期間（月）でした。"))
    ),

    p(tags$b("例のようにデータを入力してください")),
	p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
	p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")), 
    
    p(tags$b("サンプル値")),
      tags$textarea(id = "x",rows = 10,
"128.97\n118.76\n128.41\n115.33\n128.07\n110.71\n109.42\n102.20\n110.80\n106.10\n110.20\n116.58\n102.89\n129.92\n129.07\n116.16\n115.71\n102.19\n130.18\n102.73\n109.67\n120.10\n120.20\n110.42\n103.99\n110.05\n109.12\n115.27\n115.30\n119.16\n110.84\n109.47\n104.92\n120.21\n103.11\n119.42\n110.78\n119.56\n120.13\n129.86\n109.74\n116.69\n105.31\n129.51\n127.07\n104.69\n109.99\n119.74\n115.49\n129.63"
),
    p(tags$b("因子群1")),
      tags$textarea(id = "f1",rows = 10,
"NORM\nNORM\nNORM\nLV\nNORM\nSV\nSV\nSV\nSV\nLV\nSV\nLV\nSV\nNORM\nNORM\nLV\nLV\nSV\nNORM\nSV\nSV\nNORM\nNORM\nSV\nSV\nSV\nSV\nLV\nLV\nNORM\nSV\nSV\nLV\nNORM\nSV\nNORM\nSV\nNORM\nNORM\nNORM\nSV\nLV\nLV\nNORM\nNORM\nLV\nSV\nNORM\nLV\nNORM"
),
      p(tags$b("因子群2")),
      tags$textarea(id = "f2",rows = 10,
"Male\nFemale\nMale\nMale\nMale\nMale\nMale\nFemale\nMale\nFemale\nMale\nMale\nFemale\nMale\nMale\nMale\nMale\nFemale\nMale\nFemale\nMale\nFemale\nFemale\nMale\nFemale\nMale\nMale\nMale\nMale\nFemale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nMale\nFemale\nFemale\nMale\nMale\nMale\nFemale\nMale\nMale\nFemale\nMale\nFemale\nMale\nMale"
        ),

    p("欠測値はNAと入力し、3つのセットのデータの長さが同じになるようにします。長さが異なるとエラーになります。")

        ),
tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote = "quote")

),
hr(),
uiOutput("value2"),
hr(),
  h4(tags$b("仮説")),
  p(tags$b("帰無仮説")),
  p("1. 最初の因子の下で母集団の平均が等しい"),
  p("2. 2番目の因子の下で母集団の平均が等しい"),
  p("3. 2つの因子の間に相互関係はない"),
  p(tags$b("対立仮説")),
  p("1. 最初の因子が影響を与えている"),
  p("2. 2番目の因子が影響を与えている"),
  p("3. 2つの因子の間に相互作用がある"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("この例では、ERの制御下にある腫瘍のグレードによって無転移のフォローアップ時間が異なるかどうかを知りたいです。"))
  )
),

mainPanel(

  h4(tags$b("Output 1. 記述統計の結果")),

    tabsetPanel(

    tabPanel("データの確認", p(br()),
  DT::DTOutput("table"),
  p(tags$b("因子1のカテゴリー")),
  DT::DTOutput("level.t21"),
  p(tags$b("因子2のカテゴリー")),
  DT::DTOutput("level.t22")
        ),

    tabPanel("記述統計", p(br()),
      radioButtons("bas.choice",
      "グループ別の記述統計量:",
      choiceNames = list(
        HTML("1. 因子1別"),
        HTML("2. 因子2別"),
        HTML("3. 因子1と因子2別")
        ),
      choiceValues = list("A", "B", "C")
      ),

      DT::DTOutput("bas.t")
      ),

      tabPanel("平均プロット",p(br()),
      #checkboxInput('tick', 'Tick to change the factor group', FALSE), #p
  shinyWidgets::prettySwitch(
   inputId = "tick",
   label = "因子グループを変更する", 
   status = "info",
   fill = TRUE
),
      plotly::plotlyOutput("meanp.a")
    ),

      tabPanel("周辺平均プロット",p(br()),
      #checkboxInput('tick2', 'Tick to change the factor group', FALSE), #p
  shinyWidgets::prettySwitch(
   inputId = "tick2",
   label = "因子グループを変更する", 
   status = "info",
   fill = TRUE
),
      plotly::plotlyOutput("mmean.a")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA表")), p(br()),

  #checkboxInput('inter', 'Interaction', TRUE),
  shinyWidgets::prettySwitch(
   inputId = "inter",
   label = "交互作を追加", 
   value = TRUE,
   status = "info",
   fill = TRUE
),
  DT::DTOutput("anova"),p(br()),
  HTML(
  "<b> 説明 </b>
  <ul>
    <li> DF<sub>因子</sub> = [因子群カテゴリの数] -1</li>
    <li> DF<sub>交互作用</sub> = DF<sub>因子1</sub> x DF<sub>因子2</sub></li>
    <li> DF<sub>残差</sub> = [標本の数] - [因子群1のカテゴリ数] x [因子群2のカテゴリ数]</li>
    <li> MS = SS/DF</li>
    <li> F = MS<sub>因子</sub> / MS<sub>残差</sub></li>
    <li> P Value < 0.05の場合、母集団の平均は因子群間で有意差があります。(対立仮説が採択されます)</li>
    <li> P Value >= 0.05の場合、因子群間で有意差はありません。(帰無仮説が採択されます)</li>
  </ul>"
    ),

    conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("この例では、食事の種類と性別の両方がSBPに影響を及ぼし（P <0.001）、食事の種類も性別と有意に関連しています（P <0.001）。"))#,
  ),

      hr(),
    HTML("<p><b>P < 0.05,</b>の場合、 どのペアワイズ因子グループが大幅に異なるかを知りたい場合は、<b>多重比較</b>に進んでください。</p>")

  )
)
