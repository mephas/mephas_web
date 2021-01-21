#****************************************************************************************************************************************************pred-aft


sidebarLayout(

sidebarPanel(
h4(tags$b("予測")),
p("まずモデルを作成してください。"),
hr(),

h4(tags$b("Step 4. テストセットの準備")),

tabsetPanel(

tabPanel("データ例", p(br()),

 h4(tags$b("データ：糖尿病/NKI70"))

  ),
tabPanel.upload.pr(file ="newfile", header="newheader", col="newcol", sep="newsep", quote="newquote")

),
hr(),

h4(tags$b("Step 5. モデルと新しいデータが準備できたら、青色のボタンをクリックして予測の結果を生成")),
p(br()),
actionButton("B1.1", (tags$b("予測する >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),
mainPanel(
h4(tags$b("Output 3. 予測結果")),

#actionButton("B1.1", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("予測値",p(br()),
DT::DTOutput("pred")
),

tabPanel("予測生存プロット",p(br()),
p("N番目の観察で予測される生存確率"),

numericInput("line", HTML("N番目の観測値（新しいデータのN番目の行）を選択する"), value = 1, min = 1),

plotly::plotlyOutput("p.s"),
DT::DTOutput("pred.n")
)
)


)


)
