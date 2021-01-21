#****************************************************************************************************************************************************pred

sidebarLayout(

sidebarPanel(
h4(tags$b("予測")),
p("まずモデルを作成してください。"),
hr(),

h4(tags$b("Step 4. テストセットの準備")),

tabsetPanel(

tabPanel("データ例", p(br()),

 h4(tags$b("データ：誕生時の体重"))

  ),

tabPanel.upload.pr(file ="newfile", header="newheader", col="newcol", sep="newsep", quote="newquote")

),

hr(),

h4(tags$b("Step 5. モデルと新しいデータが準備できたら、青色のボタンをクリックして予測の結果を生成")),
p(br()),
actionButton("B2", (tags$b("予測する >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),


mainPanel(
h4(tags$b("Output 3. 予測結果")),
#actionButton("B2", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("予測",p(br()),
p("予測された従属変数は1列目に表示されます"),
DT::DTOutput("pred")
),

tabPanel("評価プロット",p(br()),
p(tags$b("予測 vs 真の従属変数のプロット")),
p("このプロットは、新しい従属変数がテストデータに提供されたときに表示されます。"),
p("このプロットは、予測された従属変数と新しい従属変数の関係を一次平滑化処理で示します。灰色の領域は信頼区間です。"),
plotly::plotlyOutput("p.s")
)
)
)
)
