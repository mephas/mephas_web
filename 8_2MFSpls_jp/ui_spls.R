#****************************************************************************************************************************************************spls
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#spls {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#spls_cv {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; max-height: 200px; background: white};")),

h4(tags$b("モデルを構築する")),
p("データタブでデータを作成します。"),
hr(),      

h4(tags$b("Step 1. モデルを構築するパラメータを選択する")),    

uiOutput('y.s'), 
uiOutput('x.s'), 


numericInput("nc.s", "3.  新しい成分の数  (A, 数値が大きいほど、より多くの変数が選択されます)", 3, min = 1, max = NA),
numericInput("nc.eta", "4. 選択範囲のパラメーター（数値が大きいほど、変数の選択が少なくなります）", 0.5, min = 0, max = 1, step=0.1),

radioButtons("method.s", "5. 使用するPLSアルゴリズム?",
  choices = c("SIMPLS: 簡単で速い方法です" = 'simpls',
           "カーネル法のアルゴリズム" = "kernelpls",
           "ワイド・カーネル法のアルゴリズム" = "widekernelpls",
           "古典的な直交スコアアルゴリズム" = "oscorespls"),
selected = 'simpls'),

shinyWidgets::prettySwitch(
   inputId = "scale.s",
   label = tags$b("データをスケーリングする?"), 
   value=TRUE,
   status = "info",
   fill = TRUE
  ),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("SPLSは、変数選択を利用できるようにするためのペナルティを追加します。 ペナルティは、予測に適している可能性のある変数を選択します。 成分は、選択した変数に基づいて生成されます。.")),
p(tags$i("NKIデータの例では、従属変数（Y）としてtimeを使用し、TSPYL5からの変数...を独立変数として使用しています。
デフォルトでは、Y以外のすべての変数をXに入れます。したがって、変数DiamとAgeを削除する必要があります。")),
p(tags$i("データタブから、Xが20x25の行列であることがわかったため、aの最大値は19です。A=20の場合はエラーが発生します。"))
),

hr(),

h4(tags$b("Step 2. データとモデルが準備できたら、青色のボタンをクリックしてモデルの結果を生成")),
#actionButton("spls1", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("spls1", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. データの確認")),

tabsetPanel(

tabPanel("SPLS　クロスバリデーション", p(br()),
p("次の範囲から最適なパラメータを選択してください。"),
numericInput("cv.s", "新しい成分の最大数 (デフォルト：1～10)", 10, min = 1, max = NA),
numericInput("cv.eta", "選択範囲のパラメータ (数が大きいとより少ない変数が選択される。デフォルト：0.1～0.9)", 0.9, min = 0, max = 1, step=0.1),
#p("This result chooses optimal parameters using 10-fold cross-validation which split data randomly, so the result will not be exactly the same every time."),
p("クロスバリデーションでは最小誤差に従ってパラメータが選択され、パラメータを選択するためのガイドとなります。"),
actionButton("splscv", (tags$b("CV結果を見る >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
verbatimTextOutput("spls_cv")
  ),
tabPanel("データの一部", br(),
 p("データタブでデータを編集してください"),
DT::DTOutput("spls.x")
)
),

hr(),
#actionButton("spls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 1. モデルの結果")),

tabsetPanel(
tabPanel("選択",p(br()),
verbatimTextOutput("spls"),
p(br()),
p(tags$b("選択された変数")),
DT::DTOutput("spls.sv")
),

tabPanel("データフィッティン",p(br()),
p(tags$b("Yの予測値")),
DT::DTOutput("spls.pres"),
p(br()),
p(tags$b("このプロットは、変数を選択するによって係数がどのように変化したかを示しています")),
numericInput("spls.y", "プロットする応答（N番目の従属変数）", 1, min = 1, step=1),
plotOutput("spls.bp"),
p(tags$b("係数")),
DT::DTOutput("spls.coef")

),

tabPanel("成分", p(br()),
	p("これは、選択した変数に基づいて導出された成分です"),
	  HTML("
<b>説明</b>
<ul>
<li> このプロットでは2つのスコアから成分の関係をグラフにします。スコアプロットを使用してデータの構造を評価し、クラスター、外れ値、および傾向を検出することができます。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
</ul>
  "),
    hr(),
uiOutput("g.s"),
uiOutput("type.s"),
p(tags$b("A >=2のとき、2成分を選択して2D負荷量プロットを表示する")),
numericInput("c1.s", "1. x-axisの成分", 1, min = 1, max = NA),
numericInput("c2.s", "2. y-axisの成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("このプロットでは、component1とcomponent2の散布図をプロットし、378が外れ値であることがわかりました。"))
),

	plotly::plotlyOutput("spls.s.plot"),
  DT::DTOutput("spls.s")
  ),

tabPanel("負荷量", p(br()),
  p(tags$b("これは、選択した変数に基づいて導出された負荷量です")),
	  HTML("
<b>説明</b>
<ul>
<li> このプロットは、変数からPCへの寄与度を示します (左側のパネルでPCを選択します)。</li>
<li> 赤色は負の効果、青色は正の効果を表しています。</li>
<li> 分散の累積割合 (分散表) を使用して、その因子が説明する分散の量を調べることができます。</li>
<li> 記述統計の場合は、分散の80% (0.8) が説明できれば十分です。</li>
<li> データについて他の解析も行う場合は、分散の90%以上を因子によって説明する必要があります。</li>
</ul>
  "),
    hr(),
	plotly::plotlyOutput("spls.l.plot"),
  DT::DTOutput("spls.l")
  ),

tabPanel("成分と負荷量の2Dプロット", p(br()),
  p(tags$b("これは、選択した変数に基づいて導出された負荷量です")),
    HTML("
<b>説明</b>
<ul>
<li> このプロット (バイプロット) では、主成分と負荷量を重ねています (左側のパネルでPCを選択します)。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
<li> 負荷量は、各成分に対して最も効果が大きな変数を特定します。</li>
<li> 負荷量の範囲は-1から1です。負荷量が-1または1に近い場合は、その変数が成分に強い影響を与えていることを表します。負荷量が0に近い場合は、その変数が成分にあまり影響を与えていないことを表します。</li>
</ul>
  "),
    hr(),
p(tags$b("A >=2のとき、2成分を選択して負荷量の2Dプロットを表示する")),
numericInput("c11.s", "1. x-axisの成分", 1, min = 1, max = NA),
numericInput("c22.s", "2. y-axisの成分", 2, min = 1, max = NA),
  plotly::plotlyOutput("spls.biplot")
  ),

tabPanel("成分と負荷量の3Dプロット" ,p(br()),
  HTML("
<b>説明</b>
<ul>
<li> これは2Dプロットの拡張です。このプロットでは、3つのPCの成分と負荷量を重ねます (左パネルでPCおよび線分の長さを選択します)。</li>
<li> このプロットには、2Dプロットと同様の機能があります。 トレースは、クリックすると非表示にできる変数です。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
<li> 負荷量は、各成分に対して最も効果が大きな変数を特定します。</li>
<li> 負荷量の範囲は-1から1です。負荷量が-1または1に近い場合は、その変数が成分に強い影響を与えていることを表します。負荷量が0に近い場合は、その変数が成分にあまり影響を与えていないことを表します。</li>
</ul>

  "),
hr(),
p(tags$b("このプロットの初回ロード時は少し時間がかかります")),

p(tags$b("A >=3のとき、3成分を選択して負荷量の3Dプロットを表示する")),
numericInput("td1.s", "1. x-axisの成分", 1, min = 1, max = NA),
numericInput("td2.s", "2. y-axisの成分", 2, min = 1, max = NA),
numericInput("td3.s", "3. z-axisの成分", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines.s", "4. (オプション) ラインスケール（長さ）を変更する", 2, min = 1, max = NA),
plotly::plotlyOutput("tdplot.s"),
p(tags$b("トレースの凡例")),
verbatimTextOutput("tdtrace.s")
)
)

)

)