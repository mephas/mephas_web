#****************************************************************************************************************************************************pred

sidebarLayout(

sidebarPanel(
h4(tags$b("预测")),
p("请先准备好模型"),
hr(),

h4(tags$b("第4步  准备测试集")),

tabsetPanel(

tabPanel("示例", p(br()),

 h4(tags$b("数据: 出生体重"))

  ),

tabPanel.upload.pr(file ="newfile", header="newheader", col="newcol", sep="newsep", quote="newquote")

),

hr(),

h4(tags$b("第5步  如果模型和新数据准备就绪，单击蓝色按钮生成预测结果。")),
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

tabPanel("评价图",p(br()),
p(tags$b("预测 vs 真因变量图")),
p("当测试数据中提供新的因变量时，会出现该图。"),
p("该图显示预测因变量和新因变量之间的关系，采用了线性平滑方法。灰色区域是置信区间。"),
plotly::plotlyOutput("p.s")
)
)
)
)
