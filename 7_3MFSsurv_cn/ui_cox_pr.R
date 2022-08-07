#****************************************************************************************************************************************************cox^pred

sidebarLayout(

sidebarPanel(

h4(tags$b("预测")),
p("请先准备好模型"),
hr(),

h4(tags$b("第4步  准备测试集")),

tabsetPanel(

tabPanel("示例", p(br()),

 h4(tags$b("数据: 糖尿病/NKI70"))

  ),

tabPanel.upload.pr(file ="newfile2", header="newheader2", col="newcol2", sep="newsep2", quote="newquote2")

),
hr(),

h4(tags$b("第5步 如果模型和新数据准备就绪，单击蓝色按钮生成预测结果。")),
p(br()),
actionButton("B2.1", (tags$b("显示预测结果 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()


),

mainPanel(
h4(tags$b("Output 3. 预测结果")),

#actionButton("B2.1", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("预测",p(br()),
DT::DTOutput("pred2")
),

tabPanel("Brier评分",p(br()),
HTML(
"
<p>Brier评分用于评价给定时间序列下预测生存函数的准确性。它表示观察到的生存状态和预测的存活率之间的平均平方距离，并且总是介于0和1之间的数字，0是可能的最佳值。<p>

<p>综合Brier评分（IBS）提供了在所有可用时间对模型性能的总体计算。<p>
"
),
numericInput("ss", HTML("设置时间序列：起点"), value = 1, min = 0),
numericInput("ee", HTML("设置时间序列：终点"), value = 10, min = 1),
numericInput("by", HTML("设置时间序列：序列"), value = 1, min = 0),

p(tags$i("默认设置给出时间序列1,2,...10。")),
p(tags$b("给定时间的Brier评分")),

plotly::plotlyOutput("bsplot", width = 700),
DT::DTOutput("bstab")

),

tabPanel("AUC",p(br()),
HTML(
"
<p><b> 说明  </b></p>
这里的AUC是时间相关的AUC，给出了给定时间序列下的AUC。
<ul>
<li>Chambless and Diao:　假设lp和lpnew是Cox比例风险模型的预测因子。
(Chambless, L. E. and G. Diao (2006). Estimation of time-dependent area under the ROC curve for long-term risk prediction. Statistics in Medicine 25, 3474–3486.)</li>

<li>Hung and Chiang:　假设在预测因子和以预测因子为条件的预期存活时间之间存在一对一的关系。
(Hung, H. and C.-T. Chiang (2010). Estimation methods for time-dependent AUC models with survival data. Canadian Journal of Statistics 38, 8–26.)</li>

<li>Song and Zhou: 在该方法中，即使截尾次数依赖于预测量的值，估计量仍然有效。
(Song, X. and X.-H. Zhou (2008). A semiparametric approach for the covariate specific ROC curve with survival outcome. Statistica Sinica 18, 947–965.)</li>


<li>Uno et al.:　基于反向删失概率权重，并且没有假设一个特定的工作模型来推导预测因子lpnew。假设在预测因子和以预测因子为条件的预期存活时间之间存在一对一的关系。
(Uno, H., T. Cai, L. Tian, and L. J. Wei (2007). Evaluating prediction rules for t-year survivors with censored regression models. Journal of the American Statistical Association 102, 527–537.)</li>
</ul>

"
),

numericInput("ss1", HTML("设置时间序列：起点"), value = 1, min = 0),
numericInput("ee1", HTML("设置时间序列：终点"), value = 10, min = 1),
numericInput("by1", HTML("设置时间序列"), value = 1, min = 0),

tags$i("示例时间序列： 1, 2, 3, ...,10。"),

radioButtons("auc", "选择一个AUC估计量",
  choiceNames = list(
    HTML("Chambless and Diao"),
    HTML("Hung and Chiang"),
    HTML("Song and Zhou"),
    HTML("Uno et al.")
    ),
  choiceValues = list("a", "b", "c", "d")
  ),
p(tags$b("给定时间的时间相关AUC")),
plotly::plotlyOutput("aucplot", width = 700),
DT::DTOutput("auctab")

)
)


)


)
