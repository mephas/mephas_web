#****************************************************************************************************************************************************pred-aft


sidebarLayout(

sidebarPanel(
h4(tags$b("预测")),
p("请先准备好模型。"),
hr(),

h4(tags$b("第4步 准备测试集")),

tabsetPanel(

tabPanel("示例", p(br()),

 h4(tags$b("数据：糖尿病/NKI70"))

  ),
tabPanel.upload.pr(file ="newfile", header="newheader", col="newcol", sep="newsep", quote="newquote")

),
hr(),

h4(tags$b("第5步 如果模型和新数据准备就绪，单击蓝色按钮生成预测结果。")),
p(br()),
actionButton("B1.1", (tags$b("显示预测结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),
mainPanel(
h4(tags$b("Output 3. 预测结果")),

#actionButton("B1.1", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("预测值",p(br()),
DT::DTOutput("pred")
),

tabPanel("预测生存图",p(br()),
p("第Nge观测预测的生存概率"),

numericInput("line", HTML("选择第N个观察值（新数据的第N行）"), value = 1, min = 1),

plotly::plotlyOutput("p.s"),
DT::DTOutput("pred.n")
)
)


)


)
