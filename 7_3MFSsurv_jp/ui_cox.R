#****************************************************************************************************************************************************cox-pred

sidebarLayout(

sidebarPanel(

tags$head(tags$style("#cox_form {height: 100px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str4 {overflow-y:scroll; max-height:: 350px; background: white};")),
tags$head(tags$style("#fitcx {overflow-y:scroll; max-height:: 400px; background: white};")),
tags$head(tags$style("#fitcx2 {overflow-y:scroll; max-height:: 400px; background: white};")),
tags$head(tags$style("#zph {overflow-y:scroll; max-height:: 150px; background: white};")),
tags$head(tags$style("#step {overflow-y:scroll; max-height:: 400px; background: white};")),



h4(tags$b("モデルの構築")),
p("データタブでデータを作成します。"),
hr(),       

h4(tags$b("Step 1. モデルを構築する変数を選択する")),      

p(tags$b("1. データタブで生存データオブジェクトSurv(time, event) をチェックする")), 

tabsetPanel(
tabPanel("基本モデル", p(br()),

uiOutput('var.cx'),

p(br()),

uiOutput('conf.cx'),

p(tags$b("標本の異質性を考慮するのであれば、続いて拡張モデルタブを使用します。"))
  ),

tabPanel("拡張モデル", p(br()),
radioButtons("tie", "4. (オプション) タイの取り扱い方法を選択する",selected="breslow",
  choiceNames = list(
    
    HTML("1. エフロン(Efron)法：同点が多い場合はより正確"),
    HTML("2. Breslow近似：プログラミングが最も簡単で、ほとんどすべてのコンピュータールーチン用にコーディングされた最初のオプション"),
    HTML("3. 正確な部分尤度(Exact partial likelihood)法: Cox部分尤度は、一致したロジスティック回帰の場合と同等です。")
    ),
  choiceValues = list("efron","breslow","exact")
  ),

radioButtons("effect.cx", "5. (オプション) 変量効果項（不均一性の効果）を追加する",
     choices = c(
      "しない" = "",
      "層：層化変数を識別します（疾患のサブタイプや登録機関などのカテゴリ）" = "Strata",
      "クラスター：相関する観測グループを識別します（被験者ごとの複数のイベントなど）" = "Cluster",
      "ガンマフレイルティ（Gamma Frailty）：単純なガンマ分布変量効果項を追加できます" = "Gamma Frailty",
      "ガウスフレイルティ（Gaussian Frailty）：単純なガウス分布変量効果項を追加できます" = "Gaussian Frailty"
                 ),
     selected = ""),
uiOutput('fx.cx'),
p("ガンマフレイルティ（脆弱性）：個人にはさまざまな脆弱性があり、最も脆弱な人は他の人よりも早く死にます。
   フレイルティモデルは、変量効果変数内の相対リスクを推定します"),

p("クラスターモデル（Cluster model）は、マージナルモデル（marginal model）とも呼ばれます。 独立変数による母集団の平均相対リスクを推定します。"),

p(tags$i("糖尿病データの例では、「目」を層の変量効果として使用でき、結果は目のグループごとに表示されます。
   「id」はクラスターの変量効果変数として使用でき、結果はクラスター内で独立していると見なされます。
   「id」はフレイルの変量効果変数としても使用でき、結果は「id」からのシミュレートされた分布によって調整されます。" ))
)
  ),

hr(),

h4(tags$b("Step 2. コックス(Cox)モデルをチェックする")),
p(tags$b("有効なモデルの例：Surv(time, status) ~ X1 + X2")),
p(tags$b("または、Surv(time1, time2, status) ~ X1 + X2")),

verbatimTextOutput("cox_form", placeholder = TRUE),
hr(),

h4(tags$b("Step 3. データとモデルが準備できたら、青色のボタンをクリックしてモデルの結果を生成")),
p(br()),
actionButton("B2", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. データの確認")),
 tabsetPanel(
 tabPanel("変数情報",p(br()),
 verbatimTextOutput("str4")
 ),
tabPanel("データの一部", br(),
p("データの全体を確認したい場合、データタブで確認してください"),
 DT::DTOutput("Xdata4")
 )

 ),
 hr(),
 
#actionButton("B2", h4(tags$b("Click 1: Output 2. モデル結果の表示/更新")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. モデルの結果")),

tabsetPanel(

tabPanel("モデル推定", br(),
HTML(
"
<b> 説明  </b>
<ul>
<li> 変数ごとに、推定された係数 (coef) 、単一変数の有意性に関する統計量、およびP値が表示されます。</li>
<li> 'z'のマークがついた列はWald統計量を表示します。これは、各回帰係数とその標準誤差の比に対応します (z = coef/se(coef))。Wald統計では、ある変数のベータ係数と0の間に統計的有意差があるかを評価します。</li>
<li> 係数はハザードに関連し、正の係数は予後が悪いこと、負の係数はその変数の予防効果を表します。</li>
<li> exp(coef) = ハザード比 (HR)HR = 1：効果なし；HR < 1：ハザードの減少；HR > 1：ハザードの増加</li>
<li> またアウトプットに、ハザード比 (exp(coef)) の95%信頼区間の上限と下限が表示されます。</li>
<li> 尤度比検定、Wald検定、およびスコアログランク統計からは、モデルのグローバルな統計的有意性がわかります。これらの3種類の方法は、漸近的に等価です。Nが十分に大きいと、同様の結果が得られます。Nが小さいと、いくぶん異なる結果が得られます。標本が小さいときは、挙動がよいため尤度比検定が一般的に好まれます。</li>
</ul>
"
),
verbatimTextOutput("fitcx")

),

tabPanel("データフィッティング", p(br()),
    p(tags$b("既存のデータからのフィッティング値および残差")),
    DT::DTOutput("fit.cox")
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
    verbatimTextOutput("step")


    ),

tabPanel("生存曲線", p(br()),
  HTML(
     "
<b> 説明  </b>
<ul>
<li> このプロットでは、サブポピュレーション/層とは別に、コックスモデルに基づいて計算した、予想される生存曲線を提示します。</li>
<li> 層() 要素がない場合には、全母集団の平均である1曲線のみがプロットされます。</li>
</ul>
"
),
p(tags$b("コックス回帰からの調整生存曲線")),
 plotOutput("splot")

),

tabPanel("比例ハザード検定", br(),

HTML(
"
<b> 説明  </b>
<ul>
<li> シェーンフィールド(Schoenfeld)残差は、比例ハザードの仮定をチェックするために使用します。</li>
<li> シェーンフィールド残差は時間から独立しています。時間に対してランダムではないパターンを示すプロットは、PH仮定の違反の証拠です。</li>
<li> 各独立変数の検定で統計的有意性がない場合 (p>0.05)、比例ハザードを仮定することができます。</li>
</ul>
"
),
numericInput("num", HTML("N番目の変数を選択する"), value = 1, min = 1, step=1),

plotOutput("zphplot"),

DT::DTOutput("zph")



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

uiOutput('var.mr'),
plotly::plotlyOutput("diaplot1"),

#p(tags$b("2. 観測IDに対するマルチンゲール残差プロット")), 
# plotOutput("diaplot1.2"),

 p(tags$b("2. 観測IDごとの逸脱残差プロット")),
 plotly::plotlyOutput("diaplot2"),

 p(tags$b("3. Cox-Snell残差プロット")),
 plotly::plotlyOutput("csplot.cx")
)

)
)
)