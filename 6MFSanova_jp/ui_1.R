#****************************************************************************************************************************************************1 way

sidebarLayout(

sidebarPanel(

h4(tags$b("一元配置分散分析(One-way ANOVA)")),

  h4(tags$b("Step 1. データの準備")),

  p(tags$b("1. 値と因子群に名前を付ける")),

  tags$textarea(id = "cn1", rows = 2, "FEF\nSmoke"),p(br()),

  p(tags$b("2. データ入力")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("手入力", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("ここでの例は、喫煙者と喫煙グループからのFEFデータでした。 詳細情報は、Output 1.に記載されています。"))
    ),

    p(tags$b("例のようにデータを入力してください")),
	p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
	     shinyWidgets::awesomeCheckboxGroup(
   inputId = "separater_data1",
   label = "区切り文字", 
    choiceNames = c("カンマ", "行替え", "タブ","スペース","コロン","セミコロン"),
	choiceValues=c(",","\n","\t"," ",":",";"),
   selected = c(",","\n","\t"," ",":",";"),
   inline = TRUE
),
	p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")), 
    p(tags$b("サンプル値")),
      tags$textarea(id = "x1",rows = 10,
"3.53\n3.55\n3.50\n5.40\n3.43\n3.22\n2.94\n3.85\n2.91\n3.94\n3.50\n3.38\n4.15\n4.26\n3.71\n1.77\n2.11\n1.92\n3.65\n2.35\n3.26\n3.73\n2.36\n3.75\n3.21\n2.78\n2.95\n4.52\n3.41\n3.56\n2.48\n3.16\n2.11\n3.89\n2.10\n2.87\n2.77\n4.59\n3.66\n3.55\n2.49\n3.48\n3.28\n3.04\n3.49\n2.13\n3.56\n2.88\n2.30\n4.38"
),
    p(tags$b("因子群")),
      tags$textarea(id = "f11",rows = 10,
"NS\nLS\nLS\nPS\nLS\nHS\nMS\nNS\nPS\nNI\nMS\nLS\nNI\nNS\nMS\nPS\nMS\nLS\nPS\nHS\nMS\nMS\nHS\nLS\nHS\nMS\nHS\nNS\nLS\nNS\nHS\nMS\nHS\nNS\nLS\nNI\nMS\nPS\nLS\nPS\nNI\nLS\nLS\nHS\nLS\nHS\nLS\nMS\nHS\nNS"
),

    p("欠測値はNAと入力し、2つのセットのデータの長さが同じになるようにします。長さが異なるとエラーになります。")

        ),
tabPanel.upload(file ="file1", header="header1", col="col1", sep="sep1", quote = "quote1")

),
hr(),
uiOutput("value"),
hr(),
  h4(tags$b("仮説")),
  p(tags$b("帰無仮説")),
  p("各群で平均が等しい"),
  p(tags$b("対立仮説")),
  p("少なくとも2つの因子群の平均に有意差がある"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("この例では、6つの喫煙グループのどのペアでFEF値が異なるかを知りたいです。"))
  )

),

mainPanel(

  h4(tags$b("Output 1. 記述統計の結果")),

    tabsetPanel(

    tabPanel("データの確認", p(br()),
        DT::DTOutput("table1"),
        p(tags$b("因子群のカテゴリー")),
        DT::DTOutput("level.t1")
        ),

    tabPanel("記述統計", p(br()),
      p(tags$b("グループ別の記述統計量")),
      DT::DTOutput("bas1.t")#,
         #p(br()),
        #downloadButton("download1.1", "Download Results")
      ),
    tabPanel("ボックスプロット",p(br()),

      plotly::plotlyOutput("mbp1"),
    HTML(
    "<b> 説明 </b>
    <ul>
      <li> 箱の中の線は中央値を表しています</li>
      <li> 箱の上辺は75パーセンタイル、下辺は25パーセンタイルを表しています</li>
      <li> 外れ値がある場合は赤色で示されます</li>
    </ul>"

    )
      ),

    tabPanel("平均と標準偏差プロット",p(br()),

      plotly::plotlyOutput("mmean1")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA表")), p(br()),

  DT::DTOutput("anova1"),p(br()),
  HTML(
  "<b> 説明 </b>
  <ul>
    <li> DF<sub>因子</sub> = [因子群カテゴリの数] -1</li>
    <li> DF<sub>残差</sub> = [標本値の数] - [因子群カテゴリの]</li>
    <li> MS = SS/DF</li>
    <li> F = MS<sub>因子</sub> / MS<sub>残差</sub> </li>
    <li> P Value < 0.05の場合、母集団の平均は因子群間で有意差があります。(対立仮説が採択されます)</li>
    <li> P Value >= 0.05の場合、因子群間で有意差はありません。(帰無仮説が採択されます)</li>
  </ul>"
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、喫煙グループが有意であったため、FEFは6つのグループ間で有意に異なっていたと結論付けることができました。"))
    ),
        #downloadButton("download1", "Download Results"),

    hr(),
    HTML("<p><b>P < 0.05</b>の場合、 どのペアワイズ因子グループが大幅に異なるかを知りたい場合は、<b>多重比較</b>に進んでください。</p>")



  )
)
