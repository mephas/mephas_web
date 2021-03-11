#****************************************************************************************************************************************************spls-pred

sidebarLayout(

sidebarPanel(

h4(tags$b("预测")),
p("请先准备好模型。"),
hr(),

h4(tags$b("第3步　准备测试集")),
tabsetPanel(

tabPanel("示例", p(br()),

 h4(tags$b("数据: NKI"))

  ),
tabPanel.upload.pr(file ="newfile.spls", header="newheader.spls", col="newcol.spls", sep="newsep.spls", quote="newquote.spls")

),

hr(),

h4(tags$b("第4步　如果模型和新数据准备就绪，单击蓝色按钮生成预测结果。")),

#actionButton("B.pcr", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("B.spls", (tags$b("显示预测结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),


mainPanel(

h4(tags$b("Output. 预测结果")),

tabsetPanel(
tabPanel("测试集数据",p(br()),
DT::DTOutput("newX.spls")
),
tabPanel("因变量预测值",p(br()),
DT::DTOutput("pred.lp.spls")
)

)
)
)
