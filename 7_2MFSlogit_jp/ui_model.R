#****************************************************************************************************************************************************model

sidebarLayout(


sidebarPanel(

tags$head(tags$style("#formula {height: 50px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; max-height: 200px; background: white};")),
tags$head(tags$style("#fit1 {overflow-y:scroll; max-height: 500px; background: lavender; color: black;};")),
tags$head(tags$style("#fit2 {overflow-y:scroll; max-height: 500px; background: lavender; color: black;};")),
tags$head(tags$style("#step {overflow-y:scroll; max-height: 500px; background: lavender};")),


h4(tags$b("モデルを構築する")),
p("前のタブでデータを作成します。"),
hr(),       

h4(tags$b("Step 1. モデルを構築する変数を選択する")),      

uiOutput('y'), 
uiOutput('x'),

radioButtons("intercept", "3.  (オプション) 切片/定数項を維持または除去する", ##> intercept or not
     choices = c("切片/定数項を除去する" = "-1",
                 "切片/定数項を維持する" = ""),
     selected = ""),
#p(tags$b("4. （オプション） 2つのカテゴリ変数間に交互作用項を追加する")), 
#p('Please input: + var1:var2'), 
#tags$textarea(id='conf', " " ), 
uiOutput('conf'),
hr(),
h4(tags$b("Step 2.  モデルをチェックする")),
tags$b("有効なモデルの例：Y ~ X1 + X2"),
verbatimTextOutput("formula"),
p("式中の'-1'は、切片/定数項が除去されていることを表します。"),
hr(),

h4(tags$b("Step 3. データとモデルが準備できたら、青色のボタンをクリックしてモデルの結果を生成")),
p(br()),
actionButton("B1", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. データの確認")),
tabsetPanel(
	tabPanel("変数情報", br(),
verbatimTextOutput("str")
),
tabPanel("データの一部", br(),
p("データタブでデータを編集してください"),
DT::DTOutput("Xdata2")
)

),
hr(),

h4(tags$b("Output 2. モデルの結果")),
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  class = "btn-warning"),
 p(br()),
tabsetPanel(

tabPanel("モデル推定",  br(),

HTML(
"
<b> 説明  </b>
<ul>
<li> 左側のアウトプットには、係数の推定値 (95%信頼区間)、1つの変数の有意性に関するT統計量 (t =)、P値 (p =) が表示されています。</li>
<li> 右側のアウトプットは、オッズ比 = exp(b) と元の係数の標準誤差を示しています。</li>
<li> 各変数のT検定でP < 0.05であれば、この変数がモデルで統計的に有意であることを表します。</li>
<li> 観察は標本の数を示します。</li>
<li> Akaike Inf. Crit. = AIC = -2 (log likelihood) + 2k; kは変数 + 定数の数; log likelihood:対数尤度 </li>
</ul>
"
),

fluidRow(
column(6, htmlOutput("fit1"),
    downloadButton("downloadfit1", "Save into CSV"),
    downloadButton("downloadfit.latex1", "Save LaTex codes")
),
column(6, htmlOutput("fit2"),
    downloadButton("downloadfit2", "Save into CSV"),
    downloadButton("downloadfit.latex2", "Save LaTex codes")
)
)


),

tabPanel("フィッティング(Data Fitting)",  br(),

    DT::DTOutput("fitdt0")
    ),

tabPanel("AIC変数選択",  br(),
HTML(
"<b> 説明 </b>
  <ul> 
    <li> 赤池情報量（Akaike Information Criterion (AIC)） は、段階的（Stepwise）なモデルの選択に使用します。 </li>
    <li> モデルの適合性はAIC値に従ってランク付けされ、AIC値がもっとも小さいモデルが「最良」と判断されることがあります。</li>
  </ul>
</ul>"
),
    p(tags$b("AICによるモデル選択")),
    verbatimTextOutput("step")


    ),

tabPanel("ROCプロット",   br(),

HTML(
"<b> 説明 </b>
<ul> 
<li> ROC曲線：受信者動作特性曲線は、分類閾値を変化させ、二値分類系の診断能力をグラフで示すプロットです。</li>
<li> ROC曲線は、様々な閾値を設定して真陽性率 (TPR) と偽陽性率 (FPR) をプロットして作成します。</li>
<li> 感度 (Sensitivity, 真陽性率とも呼ばれる) は、陽性であることが正しく識別された割合の尺度です。</li>
<li> 特異度 (Specificity, 真陰性率とも呼ばれる) は、陰性であることが正しく識別された割合の尺度です。</li>

</ul>"
),
plotly::plotlyOutput("p.lm"),
DT::DTOutput("sst")
    )

)
)
)