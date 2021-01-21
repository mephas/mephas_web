#****************************************************************************************************************************************************pcr-pred

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

tabPanel.upload.pr(file ="newfile", header="newheader", col="newcol", sep="newsep", quote="newquote")

),

hr(),

h4(tags$b("Step 4. モデルと新しいデータが準備できたら、青色のボタンをクリックして予測の結果を生成")),

#actionButton("B.pcr", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("B.pcr", (tags$b("予測する >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),


mainPanel(

#actionButton("B.pcr", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output. 予測結果")),

#p(br()),
tabsetPanel(
tabPanel("テストデータ",p(br()),
DT::DTOutput("newX")
),
tabPanel("予測された従属変数",p(br()),

DT::DTOutput("pred.lp")
),

tabPanel("予測された成分",p(br()),
DT::DTOutput("pred.comp")
)

)
)
)
