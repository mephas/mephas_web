#****************************************************************************************************************************************************pred

sidebarLayout(

sidebarPanel(
h4(tags$b("予測")),
p("まずモデルを作成してください。"),
hr(),

h4(tags$b("Step 4. テストセットの準備")),

tabsetPanel(

tabPanel("データ例", p(br()),

 h4(tags$b("データ：乳がん"))

  ),

tabPanel.upload.pr(file ="newfile", header="newheader", col="newcol", sep="newsep", quote="newquote")

# tabPanel("Upload Data", p(br()),
#
# p("New data should include all the variables in the model"),
# p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),
#
# fileInput('newfile', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
# #helpText("The columns of X are not suggested greater than 500"),
# # Input: Checkbox if file has header ----
# p(tags$b("2. Show 1st row as column names?")),
# checkboxInput("newheader", "Yes", TRUE),
#
# p(tags$b("3. Use 1st column as row names? (No duplicates)")),
# checkboxInput("newcol", "Yes", TRUE),
#
#      # Input: Select separator ----
# radioButtons("newsep", "4. Which separator for data?",
#   choiceNames = list(
#     HTML("Comma (,): CSV often use this"),
#     HTML("One Tab (->|): TXT often use this"),
#     HTML("Semicolon (;)"),
#     HTML("One Space (_)")
#     ),
#   choiceValues = list(",", "\t", ";", " ")
#   ),
#
# radioButtons("newquote", "5. Which quote for characters?",
# choices = c("None" = "",
#            "Double Quote" = '"',
#            "Single Quote" = "'"),
# selected = '"'),
#
# p("Correct separator and quote ensure the successful data input")
#
# )
),

hr(),

h4(tags$b("モデルと新しいデータが準備できたら、青色のボタンをクリックして予測の結果を生成")),
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

tabPanel("ROC評価",p(br()),
p("このプロットは、新しい従属変数がテストデータに提供されたときに表示されます。"),
p("このプロットは、モデルで使用されていない新しいデータに基づいて、予測値と真の値の間のROCプロットを示します。"),
plotly::plotlyOutput("p.s"),
p(tags$b("感度と特異度のテーブル")),
DT::DTOutput("sst.s")
)
)
# ,
# plotOutput("plot_model")
)
)
