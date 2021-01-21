#****************************************************************************************************************************************************aft


sidebarLayout(

sidebarPanel(

tags$head(tags$style("#aft_form {height: 50px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str3 {overflow-y:scroll; max-height:: 200px; background: white};")),
tags$head(tags$style("#fit {overflow-y:scroll; max-height:: 400px; background: white};")),
tags$head(tags$style("#step2 {overflow-y:scroll; max-height:: 400px; background: white};")),

h4(tags$b("モデルの構築")),
p("データタブでデータを作成します。"),
hr(), 

h4(tags$b("Step 1. モデルを構築する変数を選択する")),    

p(tags$b("1. データタブで生存データオブジェクトSurv(time, event) をチェックする")), 



tabsetPanel(

tabPanel("基本モデル", p(br()),

uiOutput('var.x'),

radioButtons("dist", "3. AFTモデルを選択する",
  choiceNames = list(
    HTML("1. 対数正規回帰モデル"),
   # HTML("2. Extreme regression model"),
    HTML("2. Weibull回帰モデル"),
    HTML("3. 指数回帰モデル"),  
    HTML("4. 対数ロジスティック回帰モデル")
    ),
  choiceValues = list("lognormal","weibull", "exponential","loglogistic")
  ),


uiOutput('conf'),

radioButtons("intercept", "5. (オプション) 切片/定数項を維持または除去する", ##> intercept or not
     choices = c("切片/定数項を除去する" = "-1",
                 "切片/定数項を維持する" = ""),
     selected = ""),

p(tags$b("標本の異質性を考慮するのであれば、続いて拡張モデルタブを使用します。"))

),

tabPanel("拡張モデル", p(br()),

radioButtons("effect", "6. (オプション) 変量効果項（不均一性の効果）を追加する",
     choices = c(
      "しない" = "",
      "層：層化変数を識別します（疾患のサブタイプや登録機関などのカテゴリ）" = "Strata",
      "クラスター：相関する観測グループを識別します（被験者ごとの複数のイベントなど）" = "Cluster"
      #"Gamma Frailty: allows one to add a simple gamma distributed random effects term" = "Gamma Frailty",
      #"Gaussian Frailty: allows one to add a simple Gaussian distributed random effects term" = "Gaussian Frailty"
                 ),
     selected = ""),

uiOutput('fx.c'),
tags$i("糖尿病データの例では、「目」を層の変量効果として使用できます。
   「id」は、クラスターの変量効果変数として使用できます。" )
)
),
hr(),

h4(tags$b("Step 2. AFT モデルをチェックする")),
p(tags$b("有効なモデルの例：Surv(time, status) ~ X1 + X2")),
p(tags$b("または、Surv(time1, time2, status) ~ X1 + X2")),
verbatimTextOutput("aft_form", placeholder = TRUE),
p("「-1」は、切片/定数項が削除されたことを示します"),
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
   tabPanel("変数情報",p(br()),
 verbatimTextOutput("str3")
 ),
tabPanel("データの一部", br(),
p("データの全体を確認したい場合、データタブで確認してください"),
 DT::DTOutput("Xdata3")
 )

 ),
 hr(),
 
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. モデルの結果")),
p(br()),
tabsetPanel(

tabPanel("モデル推定", br(),
HTML(
"
<b> 説明  </b>
<ul>
<li> 変数ごとに、推定された係数 (値) 、単変数の有意性に関する統計、およびp値が表示されます。</li>
<li> 'z'のマークがついた列はWald統計量を表示します。これは、各回帰係数とその標準誤差の比 (z = coef/se(coef)) に対応します。Wald統計では、ある変数のベータ係数と0との間に統計的有意差があるかを評価します。</li>
<li> 係数はハザードに関連し、正の係数は予後が悪いこと、負の係数はその変数の予防効果を表します</li>
<li> exp(Value) = ハザード比 (HR)HR = 1：効果なし；HR < 1：ハザードの減少；HR > 1：ハザードの増加</li>
<li> スケールと対数 (スケール) は、AFTモデルの誤差項における推定されたパラメータです。l</li>
<li>　モデルから対数尤度がわかります。最大尤度推定を使用して対数尤度を生成するときには、その対数尤度 (LL) が0に近いほど、モデルの適合度は良好です。</li>
<li> 左を切り捨てたデータでは、ここでの時間は終了時と開始時の差です</li>
</ul>
"
),
verbatimTextOutput("fit")

),

tabPanel("データフィッティング", p(br()),

    p(tags$b("既存のデータからのフィッティング値および残差")),
    DT::DTOutput("fit.aft")
),

tabPanel("AIC変数選択",  br(),
HTML(
"<b> 説明 </b>
  <ul> 
    <li> 赤池情報量基準 (AIC) は、段階的なモデルの選択に使用します。 </li>
    <li> モデルの適合性はAIC値に従ってランク付けされ、AIC値がもっとも小さいモデルが「最良」と判断されることがあります。 </li>
  </ul>
</ul>"
),
    p(tags$b("AICに基づいたモデル選択")),
    verbatimTextOutput("step2")


    ),

tabPanel("診断プロット", p(br()),

HTML(
     "
<p><b> 説明  </b></p>
連続独立変数に対する<b>マルチンゲール(Martingale)残差</b>は、非線形性を検出するために一般的に使用される方法です。ある連続共変量について、プロットのパターンによってその変数が正しくフィットしていないことが示唆される場合があります。マルチンゲール残差は、範囲 (-INF, +1) 内の任意の値です。
<ul>
<li>1に近いマルチンゲール残差は、「予想より早い死亡」を表します。</li>
<li>大きな負の値は、「予想より長い生存」を表します。</li>
</ul>

<b>逸脱残差(Deviance residual)</b>は、マルチンゲール残差の正規化した変形です。これらの残差は、標準偏差1で0を中心としてほぼ対称に分布していなければなりません。
<ul>
<li>正の値は、予想される生存時間に比べて「早い死亡」を表します。</li>
<li>負の値は、「予想より長い生存」を表します。</li>
<li>非常に大きな値や非常に小さな値は外れ値で、モデルからは適切に予測できません。</li>
</ul>

<b>Cox-Snell残差</b>は、生存モデルの全体的な適合度をチェックするために使用できます。
<ul>
<li> Cox-Snell残差は、観察ごとの-log (生存確率) と同じです。</li>
<li> モデルがデータに適切に適合している場合、Cox-Snell残差は、平均1の指数分布からの標本のような挙動を示さなければなりません。</li>
<li> 残差が単位指数分布からの標本のような挙動を示すときには、45度の斜線にそっていなければなりません。</li>
</ul>

<p>残差はデータフィッティングのタブにあります。<p>
<p>赤色の点は「予想より早い死亡」、黒色の点は「予想より長い生存」を示します。<p>

"
),

p(tags$b("1. 連続独立変数に対するマルチンゲール残差プロット")), 
uiOutput('var.mr2'),
plotly::plotlyOutput("mrplot"),

p(tags$b("2. 観測IDごとの逸脱残差プロット")),
plotly::plotlyOutput("deplot"),

p(tags$b("3. Cox-Snell残差プロット")),
plotly::plotlyOutput("csplot")

)

)
)
)