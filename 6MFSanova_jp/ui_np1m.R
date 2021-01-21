#****************************************************************************************************************************************************3.1. 2-np-way

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
  p(tags$i("この例では、FEF値が6つの喫煙グループ間で異なるかどうかを知りたいです。"))
  ),
  hr(),
  h4(tags$b("Step 2. 多重比較法を選択する")),
  radioButtons("methodnp2", 
  "どの方法を使用しますか？以下の説明を参照してください。",
  choiceNames = list(
    HTML("Bonferroni's"),
    HTML("Sidak's"),
    HTML("Holm's"),
    HTML("Holm-Sidak"),
    HTML("Hochberg's "),
    HTML("Benjamini-Hochberg"),
    HTML("Benjamini-Yekutieli")
    ),
  choiceValues = list("bonferroni", "sidak", "holm", "hs", "hochberg", "bh", "by")
  ),
   p(br()),
      actionButton("M3", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
      hr(),
  HTML(
  "<b> 説明 </b>

    <li> <b>Bonferroni</b>補正p値= 最大値 (1, pm); m= k(k-1)/2 ペアごとの多重比較</li>
    <li> <b>Sidak</b>補正p値 = 最大値 (1, 1 - (1 - p)^m)</li>
    <li> <b>Holm's</b>補正p値 = 最大値 [1, p(m+1-i)]；iは順序インデックス</li>
    <li> <b>Holm-Sidak</b>補正p値 = 最大値 [1, 1 - (1 - p)^(m+1-i)]</li>
    <li> <b>Hochberg's</b>補正p値 = 最大値 [1, p*i]</li>
    <li> <b>Benjamini-Hochberg</b>補正p値 = 最大値 [1, pm/(m+1-i)]</li>
    <li> <b>Benjamini-Yekutieli</b>補正p値 = 最大値 [1, pmC/(m+1-i)]; C = 1 + 1/2 + ...+ 1/m</li>

  "
    )
),

mainPanel(

  h4(tags$b("Output 2. 検定結果")), p(br()),

  p(tags$b("p <= 0.025の場合、帰無仮説を棄却します。")),

  DT::DTOutput("dunntest.t"),p(br()),
      conditionalPanel(
    condition = "input.explain_on_off",
  
    p(tags$i("この例では、喫煙グループが有意であったため、FEFはLS-NI、LS-PS、およびNI-PSグループで有意差はなかったと結論付けることができました。 他のグループの場合、P <0.025。"))#,
    )

  #downloadButton("downloadnp2.2", "Download Results")


  )
)