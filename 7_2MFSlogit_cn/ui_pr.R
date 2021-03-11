#****************************************************************************************************************************************************pred

sidebarLayout(

sidebarPanel(
h4(tags$b("预测")),
p("请先准备好模型"),
hr(),

h4(tags$b("第4步 准备测试集")),

tabsetPanel(

tabPanel("示例", p(br()),

 h4(tags$b("数据: 乳癌"))

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

h4(tags$b("第5步 如果模型和新数据准备就绪，单击蓝色按钮生成预测结果。")),
p(br()),
actionButton("B2", (tags$b("显示预测结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),


mainPanel(

h4(tags$b("Output 3. 预测结果")),
#actionButton("B2", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("预测",p(br()),
p("因变量的预测值显示在第一列中"),
DT::DTOutput("pred")
),

tabPanel("ROC评价",p(br()),
p("当测试数据中提供新的因变量时，会出现该图。"),
p("该图显示了基于模型中未使用的新数据，预测值和真实值之间的ROC图。"),
plotly::plotlyOutput("p.s"),
p(tags$b("感度和特异度表")),
DT::DTOutput("sst.s")
)
)

)
)
