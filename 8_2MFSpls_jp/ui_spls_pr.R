#****************************************************************************************************************************************************spls-pred

sidebarLayout(

sidebarPanel(

h4(tags$b("予測")),
p("まずモデルを作成してください。"),
hr(),

h4(tags$b("Step 3. テストセットの準備")),
tabsetPanel(

tabPanel("データ例", p(br()),

 h4(tags$b("データ: NKI"))

  ),
tabPanel.upload.pr(file ="newfile.spls", header="newheader.spls", col="newcol.spls", sep="newsep.spls", quote="newquote.spls")

),

hr(),

h4(tags$b("Step 4. モデルと新しいデータが準備できたら、青色のボタンをクリックして予測の結果を生成")),

#actionButton("B.pcr", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("B.spls", (tags$b("予測する >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),


mainPanel(

h4(tags$b("Output. 予測結果")),

tabsetPanel(
tabPanel("テストデータ",p(br()),
DT::DTOutput("newX.spls")
),
tabPanel("予測された従属変数",p(br()),
DT::DTOutput("pred.lp.spls")
)

)
)
)
