#****************************************************************************************************************************************************2.1. 2-2way

sidebarLayout(

sidebarPanel(

h4(tags$b("多重比較")), 

hr(),
  h4(tags$b("仮説")),
  p(tags$b("帰無仮説")),
  p("各群で平均が等しい"),
  p(tags$b("対立仮説")),
  p("少なくとも2群の間で平均値に有意差がある"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("この例では、転移のないフォローアップ時間が腫瘍のグレード（3つの順序付けられたレベル）によって異なるかどうかを知りたいです。"))
  ),
hr(),
  h4(tags$b("Step 2. 多重比較法を選択する")),
  radioButtons("methodm2", 
  "どの方法を使用しますか？右の説明を参照してください。", 
  choiceNames = list(
    #HTML("Bonferroni"),
    #HTML("Bonferroni-Holm: often used"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    #HTML("False Discovery Rate-BH"),
    #HTML("False Discovery Rate-BY"),
    HTML("シェッフェ(Scheffe)の方法"),
    HTML("テューキーのHSD(Tukey Honest Significant Difference)検定")
    #HTML("Dunnett")
    ),
  choiceValues = list("SF", "TH")
  ),
        p(br()),
      actionButton("M2", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
hr(),
      HTML(
  "<b> Explanations </b>

    <li> <b>Scheffe</b>法は各群におけるすべての対比の中で、有意なものをさがす検定です。</li>
    <li> 実験群と対照群のグループサイズが等しくない場合は、<b>Tukey Honest Significant Difference</b>が推奨されます。</li>
  "
    )


),

mainPanel(

  h4(tags$b("Output 2. 多重比較の結果")), p(br()),

  p(tags$b("因子別ペアワイズP値表")),
  DT::DTOutput("multiple.t2"),p(br()),

        HTML(
  "<b> 説明 </b>
  <ul> 
    <li> マトリックスの中で、P < 0.05はペアの中で統計的有意差があることを表します。</li>
    <li> マトリックスの中で、P >= 0.05はペアの中で統計的有意差がないことを表します。</li>
  </ul>"
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("この例では、すべてのペア、正常とLV、SVとLV、SVと正常、および男性と女性のSBPに有意差がありました。"))#,
    )


 # downloadButton("download.m222", "Download Results")
  )
)