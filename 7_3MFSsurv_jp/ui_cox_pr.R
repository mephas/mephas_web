#****************************************************************************************************************************************************cox^pred

sidebarLayout(

sidebarPanel(

h4(tags$b("予測")),
p("まずモデルを作成してください。"),
hr(),

h4(tags$b("Step 4.  テストセットの準備")),

tabsetPanel(

tabPanel("データ例", p(br()),

 h4(tags$b("データ：糖尿病/NKI70"))

  ),

tabPanel.upload.pr(file ="newfile2", header="newheader2", col="newcol2", sep="newsep2", quote="newquote2")

),
hr(),

h4(tags$b("Step 5. モデルと新しいデータが準備できたら、青色のボタンをクリックして予測の結果を生成")),
p(br()),
actionButton("B2.1", (tags$b("予測する >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()


),

mainPanel(
h4(tags$b("Output 3. 予測結果")),

#actionButton("B2.1", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("予測値",p(br()),
DT::DTOutput("pred2")
),

tabPanel("Brierスコア",p(br()),
HTML(
"
<p>Brierスコアは、ある時系列で予測される生存関数の正確度（accuracy）を評価するために使用します。このスコアは、観察された生存状態と、予測される生存確率の間の平均平方距離を表し、常に0と1の間で0が最良値です。<p>

<p>統合Brierスコア (IBS) は、データが入手されたすべての時点におけるモデルの性能を全体的に計算します。<p>
"
),
numericInput("ss", HTML("時系列を設定：開始時点"), value = 1, min = 0),
numericInput("ee", HTML("時系列を設定：終了時点"), value = 10, min = 1),
numericInput("by", HTML("時系列を設定：シーケンス"), value = 1, min = 0),

p(tags$i("デフォルトの設定では、時系列1,2,...10が指定されています。")),
p(tags$b("指定された時点のBrierスコア")),

plotly::plotlyOutput("bsplot"),
DT::DTOutput("bstab")

),

tabPanel("AUC",p(br()),
HTML(
"
<p><b> 説明  </b></p>
ここでのAUCは時間依存AUCで、ある時系列におけるAUCを意味します。
<ul>
<li>Chambless and Diao:　lpとlpnewがコックス比例ハザードモデルの予測因子であると仮定しています。
(Chambless, L. E. and G. Diao (2006). Estimation of time-dependent area under the ROC curve for long-term risk prediction. Statistics in Medicine 25, 3474–3486.)</li>

<li>Hung and Chiang:　予測因子と、予測因子によって予想される生存時間の間に1対1の関係があると仮定しています。
(Hung, H. and C.-T. Chiang (2010). Estimation methods for time-dependent AUC models with survival data. Canadian Journal of Statistics 38, 8–26.)</li>

<li>Song and Zhou: この方法では、打ち切り時間が予測因子の値に依存していても、推定量は有効となります。
(Song, X. and X.-H. Zhou (2008). A semiparametric approach for the covariate specific ROC curve with survival outcome. Statistica Sinica 18, 947–965.)</li>


<li>Uno et al.:　Inverse Probability of Censoring Weighted法 (確率の逆数を重みにする方法) に基づき、予測因子lpnewを導出するための特定のワーキングモデルを仮定しません。予測因子と、予測因子によって予想される生存時間の間に1対1の関係があると仮定しています。
(Uno, H., T. Cai, L. Tian, and L. J. Wei (2007). Evaluating prediction rules for t-year survivors with censored regression models. Journal of the American Statistical Association 102, 527–537.)</li>
</ul>

"
),

numericInput("ss1", HTML("時系列を設定：開始時点"), value = 1, min = 0),
numericInput("ee1", HTML("時系列を設定：終了時点"), value = 10, min = 1),
numericInput("by1", HTML("時系列を設定：シーケンス"), value = 1, min = 0),

tags$i("時系列の例： 1, 2, 3, ...,10"),

radioButtons("auc", "AUC推定法を1つ選択する",
  choiceNames = list(
    HTML("Chambless and Diao"),
    HTML("Hung and Chiang"),
    HTML("Song and Zhou"),
    HTML("Uno et al.")
    ),
  choiceValues = list("a", "b", "c", "d")
  ),
p(tags$b("指定した時間における時間依存AUC")),
plotly::plotlyOutput("aucplot"),
DT::DTOutput("auctab")

)
)


)


)
