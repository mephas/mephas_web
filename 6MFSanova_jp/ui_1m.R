#****************************************************************************************************************************************************1.1. 2-1way

sidebarLayout(

sidebarPanel(

h4(tags$b("多重比較")), 

hr(),
  h4(tags$b("仮説")),
  p(tags$b("帰無仮説")),
  p("1ペアの因子では、各ペアで平均が等しい"),
  p(tags$b("対立仮説")),
  p("1ペアの因子では、各ペアで平均に有意差がある"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("この例では、6つの喫煙グループのどのペアでFEF値が異なるかを知りたいです。"))
  ),
hr(),
  h4(tags$b("Step 2. 多重比較法を選択する")),
  radioButtons("method", 
  "どの方法を使用しますか？右の説明を参照してください。", selected="BH",
  choiceNames = list(
    HTML("Bonferroni法"),
    HTML("Bonferroni-Holm法：よく使われます。"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    HTML("偽発見率-BH(False Discovery Rate-BH)"),
    HTML("偽発見率-BY(False Discovery Rate-BY)"),
    HTML("シェッフェ(Scheffe)の方法"),
    HTML("テューキーのHSD(Tukey Honest Significant Difference)検定"),
    HTML("ダネット(Dunnett)法")
    ),
  choiceValues = list("B", "BH", "FDR", "BY", "SF", "TH", "DT")
  ),
  uiOutput("dt.ref"),
      p(br()),
      actionButton("M1", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
hr(),
      HTML(
  "<b> 説明 </b>
  
    <li> <b>Bonferroni</b>補正は、一般的であるものの非常に保守的なアプローチです。</li>
    <li> <b>Bonferroni-Holm</b>補正はそれほど保守的ではなく、一貫してBonferroni法より強力です。</li>
    <li> BenjaminiとHochbergが開発した<b>False Discovery Rate-BH</b>は、他の方法よりも強力です。</li>
    <li> BenjaminiとYekutieliが開発した<b>False Discovery Rate-BY</b>は、他の方法よりも強力です。</li>
    <li> <b>Scheffe</b>法は各群におけるすべての対比の中で、有意なものをさがす検定です。</li>
    <li> 実験群と対照群のグループサイズが等しくない場合は、<b>Tukey Honest Significant Difference</b>が推奨されます。</li>
    <li> <b>Dunnett</b>は、すべての治療群を対照群と比較するのに役立ちます</li>
  "
    )

),

mainPanel(

  h4(tags$b("Output 3. 多重比較の結果")), p(br()),

  #numericInput("control", HTML("* ダネット法を使う場合は、上の因子群から制御因子を変更することができます。"), 
  #  value = 1, min = 1, max = 20, step=1),

  p(tags$b("ペアワイズP値表")),
  DT::DTOutput("multiple.t"),p(br()),

      HTML(
  "<b> 説明 </b>
  <ul> 
    <li> マトリックスの中で、P < 0.05はペアの中で統計的有意差があることを表します。</li>
    <li> マトリックスの中で、P >= 0.05はペアの中で統計的有意差がないことを表します。</li>
  </ul>"
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、Bonferroni-Holmメソッドを使用して、P < 0.05の可能なペアを調査しました。 
      HSは他のグループとは有意に異なっていました。
      LSはMSやNSとは有意に異なりました。
      MSはNIやPSとは有意に異なりました。
      NIはNSとは有意に異なりました。"))#,
    )

  #downloadButton("download.m1", "結果をダウンロードする")
  )
)